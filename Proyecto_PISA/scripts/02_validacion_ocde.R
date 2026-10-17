# =============================================================================
# 02 VALIDACION OCDE - PISA 2022 Colombia (F2, Puerta G1)
#
# Qué hace (decisión D-15, Vault_PISA2022/03 Registro de decisiones.md):
#   Reproduce tres cifras publicadas por la OCDE con los 10 valores plausibles de matemáticas,
#   el peso final W_FSTUWT y los 80 pesos replicados (BRR con ajuste de Fay):
#     2.1 media de matemáticas                      -> 382,70 (EE 3,03)  TR, Annex Table 14.A.12, p. 301
#     2.2 brecha cuarto alto - cuarto bajo de ESCS  -> 79 puntos         ficha OCDE Colombia, p. 5
#     2.3 % de la varianza explicada por ESCS       -> 16 %              ficha OCDE Colombia, p. 5
#   2.4 Contraste: recalcula las tres con el paquete survey (svrepdesign, Fay rho = 0,5), una
#       implementación independiente de la nuestra.
#
# Varianza (Technical Report 2022): muestral BRR = 0,05 * suma_t (theta_t - theta)^2 (Formula 10.9,
# p. 198); total = promedio de las 10 muestrales + (1 + 1/10) * varianza entre PV (pp. 226 y 280).
#
# Entrada: datos/COL_cuestionario.rds (01b_etl_cuestionario.R). Usa a todos los estudiantes, no la
# muestra analítica de D-14: la OCDE reporta sobre toda la población.
# Salida (solo agregados): salidas/validacion_ocde.csv
#
# Cómo correrlo (desde Proyecto_PISA/scripts/):
#   & "C:\Program Files\R\R-4.4.1\bin\Rscript.exe" 02_validacion_ocde.R
# =============================================================================

options(stringsAsFactors = FALSE, scipen = 999)
suppressPackageStartupMessages({ library(data.table); library(survey) })

carpeta_script <- function() {
  arg <- grep("^--file=", commandArgs(FALSE), value = TRUE)
  if (length(arg)) return(dirname(normalizePath(sub("^--file=", "", arg))))
  if (!is.null(sys.frames()[[1]]$ofile)) return(dirname(normalizePath(sys.frames()[[1]]$ofile)))
  getwd()
}
DIR     <- carpeta_script()                                        # Proyecto_PISA/scripts
DATOS   <- normalizePath(file.path(DIR, "..", "datos"))
SALIDAS <- normalizePath(file.path(DIR, "..", "salidas"))
CACHE   <- file.path(DATOS, "COL_cuestionario.rds")
if (!file.exists(CACHE)) stop("Falta ", CACHE, ": correr antes 01b_etl_cuestionario.R")

q    <- readRDS(CACHE)
PV   <- paste0("PV", 1:10, "MATH")
REPS <- paste0("W_FSTURWT", 1:80)
stopifnot(nrow(q) == 7804, all(c(PV, REPS, "W_FSTUWT", "ESCS") %in% names(q)))
cat("Estudiantes:", nrow(q), "| con ESCS:", sum(!is.na(q$ESCS)), "\n")

# =============================================================================
# 1. ESTIMADOR PISA: 10 PV x (peso final + 80 réplicas)
# =============================================================================
# f(y, w) devuelve la estadística para un PV (y) y un vector de pesos (w).
estimar_pv <- function(d, f) {
  W <- as.matrix(d[, c("W_FSTUWT", REPS), with = FALSE])
  por_pv <- sapply(PV, function(p) {
    th <- unname(apply(W, 2, function(w) f(d[[p]], w)))   # th[1] = peso final; th[-1] = 80 réplicas
    c(est = th[1], var_m = 0.05 * sum((th[-1] - th[1])^2))   # Formula 10.9 (0,05 = 1 / (80 * 0,5^2))
  })
  est <- por_pv["est", ]
  c(est = mean(est), ee = sqrt(mean(por_pv["var_m", ]) + (1 + 1 / length(PV)) * var(est)))
}

# Cuantil ponderado: primer valor en que la proporción acumulada del peso llega a p.
cuantil_w <- function(x, w, p) { o <- order(x); cw <- cumsum(w[o]) / sum(w[o]); x[o][which(cw >= p)[1]] }

# --- 2.1 Media (todos los estudiantes)
media <- function(y, w) sum(w * y) / sum(w)
r21 <- estimar_pv(q, media)

# --- 2.2 Brecha Q4 - Q1 de ESCS (estudiantes con ESCS; cortes ponderados fijos)
e <- q[!is.na(ESCS)]
cortes <- sapply(c(0.25, 0.50, 0.75), function(p) cuantil_w(e$ESCS, e$W_FSTUWT, p))
e[, cuarto := cut(ESCS, c(-Inf, cortes, Inf), labels = c("Q1", "Q2", "Q3", "Q4"))]
peso_cuarto <- e[, .(pct_peso = round(100 * sum(W_FSTUWT) / sum(e$W_FSTUWT), 2), n = .N), by = cuarto][order(cuarto)]
brecha <- function(y, w) { a <- e$cuarto == "Q4"; b <- e$cuarto == "Q1"
  sum(w[a] * y[a]) / sum(w[a]) - sum(w[b] * y[b]) / sum(w[b]) }
r22 <- estimar_pv(e, brecha)

# --- 2.3 R² de la regresión lineal ponderada PV ~ ESCS, en %
r2 <- function(y, w) { x <- e$ESCS
  mx <- sum(w * x) / sum(w); my <- sum(w * y) / sum(w)
  100 * sum(w * (x - mx) * (y - my))^2 / (sum(w * (x - mx)^2) * sum(w * (y - my)^2)) }
r23 <- estimar_pv(e, r2)

# =============================================================================
# 2. CONTRASTE CON EL PAQUETE survey (paso 2.4)
# =============================================================================
diseno <- function(d) svrepdesign(data = d, weights = ~W_FSTUWT, repweights = "^W_FSTURWT[0-9]+$",
                                  type = "Fay", rho = 0.5, mse = TRUE,   # mse: desvíos respecto al peso final
                                  combined.weights = TRUE)               # los W_FSTURWT ya incluyen el peso base
rubin <- function(est, ee) c(est = mean(est), ee = sqrt(mean(ee^2) + (1 + 1 / length(est)) * var(est)))
ds <- diseno(as.data.frame(q))
de <- diseno(as.data.frame(e))
s21 <- rubin(sapply(PV, function(p) coef(svymean(as.formula(paste0("~", p)), ds))),
             sapply(PV, function(p) SE(svymean(as.formula(paste0("~", p)), ds))))
s22 <- t(sapply(PV, function(p) {
  b <- svyby(as.formula(paste0("~", p)), ~cuarto, de, svymean, covmat = TRUE)
  k <- svycontrast(b, c(Q1 = -1, Q2 = 0, Q3 = 0, Q4 = 1)); c(coef(k), SE(k)) }))
s22 <- rubin(s22[, 1], s22[, 2])
s23 <- t(sapply(PV, function(p) {
  v <- withReplicates(de, function(w, d) { m <- cov.wt(cbind(d[[p]], d$ESCS), wt = w, cor = TRUE)$cor
    100 * m[1, 2]^2 })
  c(coef(v), SE(v)) }))
s23 <- rubin(s23[, 1], s23[, 2])

# =============================================================================
# 3. TABLA Y PUERTA G1
# =============================================================================
tabla <- data.table(
  paso      = c("2.1", "2.2", "2.3"),
  cifra     = c("Media de matemáticas", "Brecha Q4 - Q1 de ESCS (puntos)", "Varianza explicada por ESCS (%)"),
  n         = c(nrow(q), nrow(e), nrow(e)),
  estimacion = round(c(r21[["est"]], r22[["est"]], r23[["est"]]), 2),
  ee        = round(c(r21[["ee"]],  r22[["ee"]],  r23[["ee"]]), 2),
  publicado = c(382.70, 79, 16),
  ee_publicado = c(3.03, NA, NA),
  fuente    = c("Technical Report 2022, Annex Table 14.A.12, p. 301", "Ficha OCDE Colombia, p. 5", "Ficha OCDE Colombia, p. 5"),
  contraste_survey = round(c(s21[["est"]], s22[["est"]], s23[["est"]]), 2),
  contraste_survey_ee = round(c(s21[["ee"]], s22[["ee"]], s23[["ee"]]), 2)
)
tabla[, diferencia := round(estimacion - publicado, 2)]
tabla[, cumple_G1 := abs(diferencia) <= 1]                         # ±1 punto o ±1 punto porcentual (D-15)
tabla[, coincide_survey := abs(estimacion - contraste_survey) < 0.01 & abs(ee - contraste_survey_ee) < 0.01]
setcolorder(tabla, c("paso", "cifra", "n", "estimacion", "ee", "publicado", "ee_publicado", "diferencia",
                     "cumple_G1", "contraste_survey", "contraste_survey_ee", "coincide_survey", "fuente"))
fwrite(tabla, file.path(SALIDAS, "validacion_ocde.csv"))

cat("\nCortes ponderados de ESCS (25/50/75 %):", round(cortes, 3), "\n")
cat("Peso de cada cuarto (debe ser ~25 %):\n"); print(peso_cuarto)
cat("\n--- Puerta G1 ---\n"); print(tabla[, .(paso, cifra, estimacion, ee, publicado, diferencia, cumple_G1,
                                             contraste_survey, contraste_survey_ee, coincide_survey)])
cat("\nPuerta G1:", if (all(tabla$cumple_G1)) "PASA (las tres cifras dentro de ±1)" else "NO PASA: revisar pesos, PV y filtros (D-15)", "\n")
cat("Listo: salidas/validacion_ocde.csv\n")
