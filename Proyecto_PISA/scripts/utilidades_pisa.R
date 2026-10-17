# =============================================================================
# UTILIDADES PISA - estimación con valores plausibles y pesos replicados (D-15)
#
# Se carga con source() desde los scripts que estiman cifras poblacionales
# (02_validacion_ocde.R, 01c_muestra_analitica.R, ...).
#
# Varianza (Technical Report 2022): muestral BRR = 0,05 * suma_t (theta_t - theta)^2
# (Formula 10.9, p. 198; 0,05 = 1 / (80 * 0,5^2)); total = promedio de las 10 muestrales
# + (1 + 1/10) * varianza entre PV (pp. 226 y 280).
# =============================================================================

PV_MATH <- paste0("PV", 1:10, "MATH")
REPS    <- paste0("W_FSTURWT", 1:80)

# f(y, w) devuelve la estadística para un PV (y) y un vector de pesos (w), alineados con las filas de d.
estimar_pv <- function(d, f, pv = PV_MATH) {
  W <- as.matrix(d[, c("W_FSTUWT", REPS), with = FALSE])
  por_pv <- sapply(pv, function(p) {
    th <- unname(apply(W, 2, function(w) f(d[[p]], w)))   # th[1] = peso final; th[-1] = 80 réplicas
    c(est = th[1], var_m = 0.05 * sum((th[-1] - th[1])^2))
  })
  est <- por_pv["est", ]
  c(est = mean(est), ee = sqrt(mean(por_pv["var_m", ]) + (1 + 1 / length(pv)) * var(est)))
}

# Media ponderada de y en el subconjunto g (lógico)
media_w <- function(y, w, g = rep(TRUE, length(y))) sum(w[g] * y[g]) / sum(w[g])

# Cuantil ponderado: primer valor en que la proporción acumulada del peso llega a p.
cuantil_w <- function(x, w, p) { o <- order(x); cw <- cumsum(w[o]) / sum(w[o]); x[o][which(cw >= p)[1]] }
