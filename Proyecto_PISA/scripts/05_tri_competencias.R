# =============================================================================
# 05 TRI POR COMPETENCIAS - Colombia, PISA 2022 (F5, O3; reglas en D-27)
#
# Qué hace (por ahora, solo el paso 5.2; los pasos 5.3 a 5.7 se agregan uno a uno):
#   5.2 Matriz de respuestas: 6.886 estudiantes de la muestra analítica (D-27 punto 2) x 232 ítems calibrables.
#     - Puntaje (D-27 punto 1): el crédito es el primer dígito en los ítems con códigos de dos dígitos, y en ellos
#       1 y 2 valen 0 (Technical Report, p. 313). Quedan 170 ítems dicotómicos y 62 de crédito parcial (0/1/2).
#     - Tres versiones según cómo se trata la omisión (D-27 punto 5; D-05):
#       (a) la omitida vale 0, como la OCDE; el no alcanzado y el no administrado son faltantes;
#       (b) la omisión rápida (NT10: menos del 10 % del tiempo medio del ítem entre quienes lo vieron, sin tope)
#           es faltante y las demás omisiones valen 0;
#       (c) toda omisión es faltante (sensibilidad).
#     - Las celdas vacías por la ruta adaptativa quedan NA: la falta de datos es ignorable si se calibran todos los
#       ítems juntos (plan, paso 5.2).
#
# Entradas: datos/COL_cognitivo.rds (01a), datos/COL_nse.rds (03_nse_medicion) y salidas/items_competencia.csv
#   (05_explorar_items.R).
# Salidas: datos/COL_mat_respuestas.rds (no va a Git: datos por estudiante, Ley 1581) y, solo agregados,
#   salidas/mat_matriz_resumen.csv.
#
# Cómo correrlo (desde Proyecto_PISA/scripts/, después de 05_explorar_items.R):
#   & "C:\Program Files\R\R-4.4.1\bin\Rscript.exe" 05_tri_competencias.R
# =============================================================================

options(stringsAsFactors = FALSE, scipen = 999, width = 160)
suppressPackageStartupMessages({ library(data.table) })

carpeta_script <- function() {
  arg <- grep("^--file=", commandArgs(FALSE), value = TRUE)
  if (length(arg)) return(dirname(normalizePath(sub("^--file=", "", arg))))
  if (!is.null(sys.frames()[[1]]$ofile)) return(dirname(normalizePath(sys.frames()[[1]]$ofile)))
  getwd()
}
DIR     <- carpeta_script()
DATOS   <- normalizePath(file.path(DIR, "..", "datos"))
SALIDAS <- normalizePath(file.path(DIR, "..", "salidas"))
for (f in c("COL_cognitivo.rds", "COL_nse.rds")) if (!file.exists(file.path(DATOS, f))) stop("Falta datos/", f)
if (!file.exists(file.path(SALIDAS, "items_competencia.csv"))) stop("Falta salidas/items_competencia.csv: correr antes 05_explorar_items.R")

# =============================================================================
# 5.2 MATRIZ DE RESPUESTAS
# =============================================================================
cog <- readRDS(file.path(DATOS, "COL_cognitivo.rds"))
nse <- readRDS(file.path(DATOS, "COL_nse.rds"))
ic  <- fread(file.path(SALIDAS, "items_competencia.csv"), encoding = "UTF-8")
ITEMS <- ic[calibrable == TRUE, item]
COMP  <- setNames(ic[calibrable == TRUE, competencia], ITEMS)
stopifnot(length(ITEMS) == 232, all(ITEMS %in% names(cog)))

d <- cog[CNTSTUID %in% nse$CNTSTUID]                                   # muestra analítica (D-14, D-27 punto 2)
setkey(d, CNTSTUID); stopifnot(nrow(d) == 6886)

# Primer dígito = crédito (TR p. 313); en los ítems con códigos de dos dígitos, 1 y 2 son «01» y «02» (sin crédito)
puntaje <- function(x) if (any(x >= 10, na.rm = TRUE)) x %/% 10 else x
tiempo  <- function(j) d[[paste0(sub("^D", "C", sub("[SC]$", "", j)), "TT")]] / 1000   # s; los ítems D usan el prefijo C

A <- B <- C <- matrix(NA_real_, nrow(d), length(ITEMS), dimnames = list(NULL, ITEMS))
umbral <- setNames(numeric(length(ITEMS)), ITEMS)
for (j in ITEMS) {
  e <- d[[paste0("E_", j)]]; s <- puntaje(d[[j]]); tt <- tiempo(j)
  visto <- e %in% c("respondido", "omitido") & !is.na(tt)
  umbral[j] <- 0.10 * mean(tt[visto])                                   # NT10 con la media, sin tope (D-27 punto 5)
  resp <- e == "respondido"; om <- e == "omitido"
  rapida <- om & !is.na(tt) & tt < umbral[j]
  A[resp, j] <- s[resp]; A[om, j] <- 0                                  # (a) omitida = 0
  B[, j] <- A[, j]; B[rapida, j] <- NA                                  # (b) omisión rápida = faltante
  C[, j] <- A[, j]; C[om, j] <- NA                                      # (c) toda omisión = faltante
}

# --- Controles (D-27): categorías, número de ítems de cada tipo y cobertura del diseño adaptativo
cats <- apply(A, 2, function(x) paste(sort(unique(na.omit(x))), collapse = "/"))
stopifnot(all(cats %in% c("0/1", "0/1/2")), sum(cats == "0/1") == 170, sum(cats == "0/1/2") == 62)
tipos <- ifelse(cats == "0/1", "2PL", "gpcm")

resumen <- rbindlist(lapply(c(sort(unique(COMP)), "total"), function(k) {
  jj <- if (k == "total") ITEMS else ITEMS[COMP == k]
  data.table(competencia = k, items = length(jj), dicotomicos = sum(tipos[jj] == "2PL"), credito_parcial = sum(tipos[jj] == "gpcm"),
             celdas_con_dato_a = sum(!is.na(A[, jj])), pct_celdas_con_dato_a = round(100 * mean(!is.na(A[, jj])), 2),
             omisiones = sum(!is.na(A[, jj]) & is.na(C[, jj])), omisiones_rapidas = sum(!is.na(A[, jj]) & is.na(B[, jj])),
             estudiantes_con_dato = sum(rowSums(!is.na(A[, jj, drop = FALSE])) > 0),
             items_por_estudiante_mediana = as.numeric(median(rowSums(!is.na(A[, jj, drop = FALSE]))))) }))
fwrite(resumen, file.path(SALIDAS, "mat_matriz_resumen.csv"))

saveRDS(list(CNTSTUID = d$CNTSTUID, a = A, b = B, c = C, competencia = COMP, tipo = tipos, umbral_NT10_s = umbral),
        file.path(DATOS, "COL_mat_respuestas.rds"))

cat("--- 5.2 Matriz de respuestas (salidas/mat_matriz_resumen.csv) ---\n"); print(resumen)
cat("\nListo: datos/COL_mat_respuestas.rds (no va a Git) y salidas/mat_matriz_resumen.csv\n")
