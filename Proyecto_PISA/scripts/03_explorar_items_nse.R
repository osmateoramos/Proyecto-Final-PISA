# =============================================================================
# EXPLORACION PREVIA A 03 - Ítems del NSE (Colombia, PISA 2022)
#
# Para qué: decidir D-16 (cómo se mide el NSE en la F3) ANTES de estimar cualquier modelo.
# No estima correlaciones, factores ni modelos TRI: solo describe los ítems.
#
# Qué hace (sobre datos/COL_analitica.rds, salida de 01c):
#   1. Cobertura: cuántas respuestas válidas tiene cada estudiante en los 29 indicadores
#      (27 posesiones + HISCED + HISEI) y cuántos cumplen la regla OCDE de >= 3 respuestas
#      válidas (Technical Report 2022, p. 384), cruzado con los motivos de exclusión de D-14.
#   2. (Sobre la muestra de la F3 = muestra analítica de D-14, según D-16.) Frecuencia de cada
#      categoría de cada ítem (sin ponderar y ponderada) y marca de
#      categorías escasas (< 1 % y < 2 % de las respuestas válidas).
#   3. HISEI: cortes de quintiles ponderados y tamaño de cada grupo.
#   4. Techo de educ_madre / educ_padre (ST005 / ST007 llegan solo a ISCED 3.4) frente a HISCED.
#   5. Colegios: estudiantes por colegio (para la división en mitades estratificada por colegio).
#
# Salidas (solo agregados, Ley 1581): salidas/nse_items_frecuencias.csv, salidas/nse_cobertura.csv
#
# Cómo correrlo (desde Proyecto_PISA/scripts/, después de 01c):
#   & "C:\Program Files\R\R-4.4.1\bin\Rscript.exe" 03_explorar_items_nse.R
# =============================================================================

options(stringsAsFactors = FALSE, scipen = 999, width = 160)
suppressPackageStartupMessages({ library(data.table); library(haven) })

carpeta_script <- function() {
  arg <- grep("^--file=", commandArgs(FALSE), value = TRUE)
  if (length(arg)) return(dirname(normalizePath(sub("^--file=", "", arg))))
  if (!is.null(sys.frames()[[1]]$ofile)) return(dirname(normalizePath(sys.frames()[[1]]$ofile)))
  getwd()
}
DIR     <- carpeta_script()
DATOS   <- normalizePath(file.path(DIR, "..", "datos"))
SALIDAS <- normalizePath(file.path(DIR, "..", "salidas"))
source(file.path(DIR, "utilidades_pisa.R"))                        # cuantil_w()

u <- readRDS(file.path(DATOS, "COL_analitica.rds"))
POS <- grep("^ST25[0-6]Q[0-9]+JA$", names(u), value = TRUE)
IND <- c(POS, "HISCED", "HISEI")
stopifnot(length(POS) == 27, nrow(u) == 7804)

# Etiquetas: diccionario de 01b para los ítems; códigos de HISCED desde el .SAV (solo metadatos)
dic <- fread(file.path(SALIDAS, "diccionario_cuestionario.csv"), sep = ";", encoding = "UTF-8")
etq <- setNames(dic$etiqueta, dic$original)
lab_hisced <- attr(read_sav(file.path(DATOS, "CY08MSP_STU_QQQ.SAV"), col_select = "HISCED", n_max = 0)$HISCED, "labels")
cat("Códigos de HISCED en el .SAV:\n"); print(lab_hisced)

# =============================================================================
# 1. COBERTURA
# =============================================================================
u[, n_validas_nse := rowSums(!is.na(as.matrix(.SD))), .SDcols = IND]
u[, n_validas_pos := rowSums(!is.na(as.matrix(.SD))), .SDcols = POS]
u[, regla3 := n_validas_nse >= 3]
cob <- rbind(
  data.table(conjunto = "Total", n = nrow(u), n_regla3 = sum(u$regla3)),
  u[, .(n = .N, n_regla3 = sum(regla3)), by = .(conjunto = paste("D-14:", motivo))][order(conjunto)],
  data.table(conjunto = c("Con 0 respuestas válidas en los 29 indicadores", "Con las 27 posesiones respondidas",
                          "Con >= 3 válidas solo en posesiones"),
             n = c(sum(u$n_validas_nse == 0), sum(u$n_validas_pos == 27), sum(u$n_validas_pos >= 3)),
             n_regla3 = NA_integer_))
fwrite(cob, file.path(SALIDAS, "nse_cobertura.csv"))
cat("\n--- Cobertura (regla OCDE: >= 3 respuestas válidas) ---\n"); print(cob)
cat("Respuestas válidas por estudiante (de 29), entre quienes cumplen la regla:\n")
print(summary(u[regla3 == TRUE, n_validas_nse]))

# Base de los pasos 2 a 5: la muestra de la F3 elegida en D-16 = muestra analítica de D-14 (6.886).
# Todos cumplen la regla de >= 3 respuestas válidas, como muestra la tabla de cobertura.
m <- u[incluido == TRUE]
stopifnot(nrow(m) == 6886, all(m$regla3))
cat("\nBase de las frecuencias, HISEI y colegios: muestra analítica (D-14 / D-16),", nrow(m), "estudiantes\n")
w <- m$W_FSTUWT

# =============================================================================
# 2. FRECUENCIAS POR CATEGORÍA
# =============================================================================
frec <- rbindlist(lapply(c(POS, "HISCED"), function(v) {
  x <- m[[v]]; ok <- !is.na(x)
  t  <- table(x[ok]); tw <- tapply(w[ok], x[ok], sum)
  data.table(item = v, etiqueta = if (v == "HISCED") "Highest level of education of parents (ISCED)" else
               sub("^.*: ", "", etq[[v]]),
             pct_na = round(100 * mean(!ok), 1), categoria = names(t), n = as.integer(t),
             pct = round(100 * as.numeric(t) / sum(ok), 2), pct_ponderado = round(100 * as.numeric(tw) / sum(tw), 2))
}))
frec[, escasa_1pct := pct < 1]
frec[, escasa_2pct := pct < 2]
fwrite(frec, file.path(SALIDAS, "nse_items_frecuencias.csv"))
cat("\n--- Categorías escasas (sin ponderar) ---\n")
print(frec[escasa_2pct == TRUE, .(item, etiqueta = substr(etiqueta, 1, 45), categoria, n, pct, escasa_1pct)])
cat("Ítems con alguna categoría < 1 %:", frec[escasa_1pct == TRUE, uniqueN(item)],
    "| con alguna < 2 %:", frec[escasa_2pct == TRUE, uniqueN(item)], "\n")

# =============================================================================
# 3. HISEI: quintiles ponderados
# =============================================================================
h <- m[!is.na(HISEI)]
cortes <- sapply(c(0.2, 0.4, 0.6, 0.8), function(p) cuantil_w(h$HISEI, h$W_FSTUWT, p))
h[, quintil := cut(HISEI, c(-Inf, cortes, Inf), labels = paste0("Q", 1:5))]
cat("\n--- HISEI ---\nValores distintos:", uniqueN(h$HISEI), "| cortes ponderados 20/40/60/80 %:", cortes, "\n")
print(h[, .(n = .N, pct_ponderado = round(100 * sum(W_FSTUWT) / sum(h$W_FSTUWT), 1),
            min = min(HISEI), max = max(HISEI)), by = quintil][order(quintil)])
top <- h[, .N, by = HISEI][order(-N)][1:3]
cat("Los 3 valores más repetidos de HISEI concentran el", round(100 * sum(top$N) / nrow(h), 1), "% de los casos\n")

# =============================================================================
# 4. TECHO DE ST005 / ST007 FRENTE A HISCED
# =============================================================================
cat("\n--- Techo de la educación de los padres (ST005/ST007 llegan a ISCED 3.4) ---\n")
cat("educ_madre en el máximo (4 = ISCED 3.4):", round(100 * mean(m$educ_madre == 4, na.rm = TRUE), 1), "% |",
    "educ_padre en el máximo:", round(100 * mean(m$educ_padre == 4, na.rm = TRUE), 1), "%\n")
cat("HISCED de quienes tienen al menos un padre en el máximo de ST005/ST007:\n")
print(m[(educ_madre == 4 | educ_padre == 4) & !is.na(HISCED), .N, by = HISCED][order(HISCED)])

# =============================================================================
# 5. COLEGIOS
# =============================================================================
tam <- m[, .N, by = CNTSCHID]
cat("\n--- Colegios (muestra de la F3) ---\nColegios:", nrow(tam), "| estudiantes por colegio:\n")
print(summary(tam$N))
cat("Colegios con 1 estudiante:", sum(tam$N == 1), "| con número impar:", sum(tam$N %% 2 == 1), "\n")
cat("\nListo: salidas/nse_items_frecuencias.csv y salidas/nse_cobertura.csv\n")
