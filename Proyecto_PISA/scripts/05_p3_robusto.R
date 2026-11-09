# =============================================================================
# 05 P3 ROBUSTO - enlace de las dificultades propias con las internacionales (paso 5.5) (D-41 punto 5, D-43)
#
# Qué hace (D-43, posterior a ver el resultado de D-41; así se declara en el informe):
#   1. Correlación de Spearman entre b propio (= -d / a, modelo de 4 competencias) y b_int del anexo A, por competencia
#      (análisis principal de P3).
#   2. Enlace media-sigma solo con los ítems dicotómicos con a propio >= 0,3: pendiente, intercepto, correlación de
#      Pearson y diferencia cuadrática media después del enlace.
#   3. Lista de los dicotómicos con a propio < 0,3 frente a su a_int (hallazgo de calidad de los ítems).
#
# Entradas: datos/COL_mat_respuestas.rds, COL_mat_tri_4D.rds y salidas/items_competencia.csv.
# Salidas (parámetros de ítems; sin datos de estudiantes): salidas/mat_p3_robusto.csv y
#   mat_p3_baja_discriminacion.csv.
#
# Cómo correrlo (desde Proyecto_PISA/scripts/):
#   & "C:\Program Files\R\R-4.4.1\bin\Rscript.exe" 05_p3_robusto.R
# =============================================================================

options(stringsAsFactors = FALSE, scipen = 999, width = 160)
suppressPackageStartupMessages({ library(data.table); library(mirt) })

carpeta_script <- function() {
  arg <- grep("^--file=", commandArgs(FALSE), value = TRUE)
  if (length(arg)) return(dirname(normalizePath(sub("^--file=", "", arg))))
  if (!is.null(sys.frames()[[1]]$ofile)) return(dirname(normalizePath(sys.frames()[[1]]$ofile)))
  getwd()
}
DIR     <- carpeta_script()
DATOS   <- normalizePath(file.path(DIR, "..", "datos"))
SALIDAS <- normalizePath(file.path(DIR, "..", "salidas"))
A_MIN   <- 0.3                                                     # D-43 punto 2
K       <- 4

R  <- readRDS(file.path(DATOS, "COL_mat_respuestas.rds")); m4 <- readRDS(file.path(DATOS, "COL_mat_tri_4D.rds"))
ic <- fread(file.path(SALIDAS, "items_competencia.csv"), encoding = "UTF-8")

# --- Los mismos b propios que 05_h4_h7.R (D-41 punto 5)
cf <- coef(m4, simplify = TRUE)$items; it <- colnames(R$a)
dic <- data.table(item = it, competencia = R$competencia[it], tipo = R$tipo)[tipo == "2PL"]
dic[, a_propio := vapply(item, function(j) max(abs(cf[j, paste0("a", 1:K)])), 0)]
dic[, b_propio := -cf[item, "d"] / a_propio]
dic <- merge(dic, ic[, .(item, a_int, b_int)], by = "item")[!is.na(b_int)]

# --- 1 y 2. Spearman con todos; media-sigma con a >= A_MIN
p3 <- dic[, {
  s <- a_propio >= A_MIN; bp <- b_propio[s]; bi <- b_int[s]
  A <- sd(bi) / sd(bp); B <- mean(bi) - A * mean(bp); be <- A * bp + B
  .(items = .N, r_spearman_todos = round(cor(b_propio, b_int, method = "spearman"), 3),
    items_a_min = sum(s), excluidos = .N - sum(s),
    r_b_a_min = round(cor(bp, bi), 3), r_spearman_a_min = round(cor(bp, bi, method = "spearman"), 3),
    pendiente_A = round(A, 3), intercepto_B = round(B, 3), RMSD_b_enlazado = round(sqrt(mean((be - bi)^2)), 3))
}, by = competencia]
p3[, umbral_a := A_MIN]
fwrite(p3, file.path(SALIDAS, "mat_p3_robusto.csv"))

# --- 3. Ítems con baja discriminación en Colombia
baja <- dic[a_propio < A_MIN, .(item, competencia, a_propio = round(a_propio, 3), a_int = round(a_int, 3),
                                b_propio = round(b_propio, 2), b_int = round(b_int, 3))][order(competencia, a_propio)]
fwrite(baja, file.path(SALIDAS, "mat_p3_baja_discriminacion.csv"))

cat("--- P3 robusto (salidas/mat_p3_robusto.csv) ---\n"); print(p3)
cat("\n--- Dicotómicos con a <", A_MIN, "(salidas/mat_p3_baja_discriminacion.csv):", nrow(baja), "---\n"); print(baja)
cat("\nCorrelación de Spearman entre a propio y a_int (todos los dicotómicos):",
    round(cor(dic$a_propio, dic$a_int, method = "spearman"), 3), "\n")
