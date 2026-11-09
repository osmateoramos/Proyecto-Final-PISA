# =============================================================================
# 03 NSE SENSIBILIDAD S1 - ceros de D-20 (D-35; exploratoria, no cambia el modelo de la G2 ni H1)
#
# Qué hace:
#   D-20 pone 0 en los 8 tipos de libros (ST256) a quien dice que no hay libros (ST255 = 0) y en los 6 dispositivos
#   (ST254) a quien dice que no hay dispositivos con pantalla (ST253 = 0). Eso crea una dependencia estructural: para
#   esos estudiantes, las respuestas de ST256 (o ST254) quedan determinadas por ST255 (o ST253), sea cual sea su NSE.
#   Aquí se re-estima la TRI de 2 dimensiones del AFE (D-24) con esos saltos como faltantes, como antes de D-20. La
#   falta depende solo de ST255 y ST253, que están observados (MAR), así que una TRI por verosimilitud la ignora sin
#   sesgo (interpretación, D-35).
#   Todo lo demás es igual a 03_nse_tri.R: mismas categorías (las del 3.1), estructura, tipos, pesos normalizados y
#   EM de mirt. Se compara con el modelo 2D_AFE de 03_nse_tri.R: cargas, información, confiabilidad, validez, Q3 y la
#   correlación entre las EAP de las dos versiones.
#
# Entradas: datos/COL_nse.rds (03_nse_medicion.R), datos/COL_nse_tri.rds y datos/COL_nse_tri_modelos.rds
#   (03_nse_tri.R) y salidas/nse_estructura_afe.csv.
# Salidas: datos/COL_nse_sens_d20.rds (modelo; no va a Git) y, solo agregados, salidas/nse_sens_d20_items.csv y
#   salidas/nse_sens_d20_resumen.csv.
#
# Cómo correrlo (desde Proyecto_PISA/scripts/, después de 03_nse_tri.R):
#   & "C:\Program Files\R\R-4.4.1\bin\Rscript.exe" 03_nse_sens_d20.R
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
source(file.path(DIR, "utilidades_pisa.R"))                        # huella(), cargas_mirt(), r_w()
for (f in c("COL_nse.rds", "COL_nse_tri.rds", "COL_nse_tri_modelos.rds"))
  if (!file.exists(file.path(DATOS, f))) stop("Falta datos/", f, ": correr antes 03_nse_medicion.R y 03_nse_tri.R")

nse <- readRDS(file.path(DATOS, "COL_nse.rds"))
tri <- readRDS(file.path(DATOS, "COL_nse_tri.rds"))
original <- readRDS(file.path(DATOS, "COL_nse_tri_modelos.rds"))[["2D_AFE"]]
fac <- attr(nse, "factores"); IND <- c(fac$economico, fac$cultural)
est_afe <- fread(file.path(SALIDAS, "nse_estructura_afe.csv"), encoding = "UTF-8")
CUL <- est_afe[factor_AFE == "cultural", item]; ECO <- setdiff(IND, CUL)
stopifnot(nrow(nse) == 6886, identical(nse$CNTSTUID, tri$CNTSTUID), length(CUL) == 10)

# --- Deshace D-20: los saltos vuelven a ser faltantes (las categorías unidas en el 3.1 no cambian)
X <- as.data.frame(nse[, ..IND])
ST256 <- grep("^ST256", IND, value = TRUE); ST254 <- grep("^ST254", IND, value = TRUE)
sin_libros <- which(X$ST255Q01JA %in% 0); sin_disp <- which(X$ST253Q01JA %in% 0)
stopifnot(all(as.matrix(X[sin_libros, ST256]) == 0, na.rm = TRUE), all(as.matrix(X[sin_disp, ST254]) == 0, na.rm = TRUE))
X[sin_libros, ST256] <- NA; X[sin_disp, ST254] <- NA
stopifnot(all(sapply(X, function(x) length(unique(na.omit(x))) >= 2)))   # ninguna columna queda sin variación

w     <- nse$W_FSTUWT * nrow(nse) / sum(nse$W_FSTUWT)
tipos <- ifelse(grepl("^ST250", IND), "2PL", "gpcm")
modelo <- mirt.model(paste0("ECO = ", paste(ECO, collapse = ", "), "\nCUL = ", paste(CUL, collapse = ", "),
                            "\nCOV = ECO*CUL"), itemnames = IND)

CACHE <- file.path(DATOS, "COL_nse_sens_d20.rds")
H <- huella(as.list(X), w, tipos, ECO, CUL, "S1 D-35")
m <- if (file.exists(CACHE)) readRDS(CACHE) else NULL
if (is.null(m) || !identical(attr(m, "huella_datos"), H)) {
  cat(format(Sys.time(), "%H:%M:%S"), "| S1: estimando la TRI 2D del AFE sin los ceros de D-20\n"); t0 <- Sys.time()
  m <- mirt(X, modelo, itemtype = tipos, survey.weights = w, SE = FALSE, verbose = FALSE, technical = list(NCYCLES = 3000))
  attr(m, "minutos") <- round(as.numeric(Sys.time() - t0, units = "mins"), 1); attr(m, "huella_datos") <- H
  saveRDS(m, CACHE)
} else cat("S1: modelo leído del caché", basename(CACHE), "\n")
stopifnot(extract.mirt(m, "converged"))

# --- Comparación por ítem: cargas estandarizadas
F0 <- cargas_mirt(original)[IND, ]; F1 <- cargas_mirt(m)[IND, ]
items <- data.table(item = IND, factor = ifelse(IND %in% CUL, "libros", "económico"),
                    carga_D20 = round(ifelse(IND %in% CUL, F0[, "CUL"], F0[, "ECO"]), 3),
                    carga_S1  = round(ifelse(IND %in% CUL, F1[, "CUL"], F1[, "ECO"]), 3),
                    pct_faltante_D20 = round(100 * colMeans(is.na(nse[, ..IND])), 1),
                    pct_faltante_S1  = round(100 * colMeans(is.na(X)), 1))
items[, dif_carga := round(carga_S1 - carga_D20, 3)]
fwrite(items, file.path(SALIDAS, "nse_sens_d20_items.csv"))

# --- Resumen: correlación entre factores, información, confiabilidad, validez, Q3 y acuerdo entre las EAP
th <- seq(-4, 4, by = 0.1)
info_eje <- function(mm, d) if (d == 1) testinfo(mm, cbind(th, 0), degrees = c(0, 90)) else testinfo(mm, cbind(0, th), degrees = c(90, 0))
rango <- function(x) { k <- th[x >= 4]; if (length(k)) sprintf("%.1f a %.1f", min(k), max(k)) else "ninguno" }
fcor <- function(mm) cov2cor(coef(mm, simplify = TRUE)$cov)[1, 2]
eap1 <- fscores(m, method = "EAP", full.scores.SE = TRUE)
eap0 <- cbind(ECO = tri$eap_AFE_ECO, CUL = tri$eap_AFE_CUL)
q3_libros <- function(mm, XX) { Q <- residuals(mm, type = "Q3", verbose = FALSE)
  q <- Q["ST255Q01JA", ST256]; c(min = min(q), max = max(q), marcados = sum(abs(q) > 0.2)) }
q0 <- q3_libros(original, as.data.frame(nse[, ..IND])); q1 <- q3_libros(m, X)

fila <- function(medida, d20, s1) data.table(medida = medida, D20 = as.character(d20), S1 = as.character(s1))
i0 <- sapply(1:2, function(d) info_eje(original, d)); i1 <- sapply(1:2, function(d) info_eje(m, d))
rx0 <- empirical_rxx(fscores(original, method = "EAP", full.scores.SE = TRUE)); rx1 <- empirical_rxx(eap1)
resumen <- rbind(
  fila("correlación entre factores", round(fcor(original), 3), round(fcor(m), 3)),
  fila("información máxima, libros (theta del máximo)", sprintf("%.1f (%.1f)", max(i0[, 2]), th[which.max(i0[, 2])]),
       sprintf("%.1f (%.1f)", max(i1[, 2]), th[which.max(i1[, 2])])),
  fila("rango con información >= 4, libros", rango(i0[, 2]), rango(i1[, 2])),
  fila("información máxima, económico", round(max(i0[, 1]), 1), round(max(i1[, 1]), 1)),
  fila("rango con información >= 4, económico", rango(i0[, 1]), rango(i1[, 1])),
  fila("confiabilidad empírica, económico", round(rx0[["ECO"]], 3), round(rx1[["ECO"]], 3)),
  fila("confiabilidad empírica, libros", round(rx0[["CUL"]], 3), round(rx1[["CUL"]], 3)),
  fila("r ponderada con HOMEPOS, económico", round(r_w(eap0[, "ECO"], nse$HOMEPOS, nse$W_FSTUWT), 3), round(r_w(eap1[, "ECO"], nse$HOMEPOS, nse$W_FSTUWT), 3)),
  fila("r ponderada con ESCS, económico", round(r_w(eap0[, "ECO"], nse$ESCS, nse$W_FSTUWT), 3), round(r_w(eap1[, "ECO"], nse$ESCS, nse$W_FSTUWT), 3)),
  fila("r ponderada con HOMEPOS, libros", round(r_w(eap0[, "CUL"], nse$HOMEPOS, nse$W_FSTUWT), 3), round(r_w(eap1[, "CUL"], nse$HOMEPOS, nse$W_FSTUWT), 3)),
  fila("r ponderada con ESCS, libros", round(r_w(eap0[, "CUL"], nse$ESCS, nse$W_FSTUWT), 3), round(r_w(eap1[, "CUL"], nse$ESCS, nse$W_FSTUWT), 3)),
  fila("Q3 ST255-ST256: mínimo / máximo / pares con |Q3| > 0,2", sprintf("%.3f / %.3f / %d", q0[["min"]], q0[["max"]], q0[["marcados"]]),
       sprintf("%.3f / %.3f / %d", q1[["min"]], q1[["max"]], q1[["marcados"]])),
  fila("r ponderada entre las EAP D-20 y S1, económico", "—", round(r_w(eap0[, "ECO"], eap1[, "ECO"], nse$W_FSTUWT), 3)),
  fila("r ponderada entre las EAP D-20 y S1, libros", "—", round(r_w(eap0[, "CUL"], eap1[, "CUL"], nse$W_FSTUWT), 3)),
  fila("r ponderada entre las EAP D-20 y S1, libros, solo quienes no tienen libros", "—",
       round(r_w(eap0[sin_libros, "CUL"], eap1[sin_libros, "CUL"], nse$W_FSTUWT[sin_libros]), 3)),
  fila("estudiantes con los saltos como faltantes (libros / dispositivos)", "0 / 0", sprintf("%d / %d", length(sin_libros), length(sin_disp))),
  fila("iteraciones del EM", extract.mirt(original, "iterations"), extract.mirt(m, "iterations")))
fwrite(resumen, file.path(SALIDAS, "nse_sens_d20_resumen.csv"))

cat("\n--- S1: TRI 2D del AFE con D-20 (saltos = 0) frente a saltos como faltantes ---\n"); print(resumen)
cat("\nCargas de los ítems de libros y de dispositivos:\n"); print(items[grepl("^ST25[3-6]", item)])
cat("\nListo: salidas/nse_sens_d20_items.csv y nse_sens_d20_resumen.csv (exploratorio, D-35)\n")
