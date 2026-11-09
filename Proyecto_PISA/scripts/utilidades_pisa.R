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

# Huella (md5) de lo que entra a un modelo, para saber si un caché corresponde a los datos actuales.
huella <- function(...) { f <- tempfile(); on.exit(unlink(f))
  writeBin(serialize(list(...), NULL, version = 3), f); unname(tools::md5sum(f)) }

# Cargas estandarizadas de un modelo de mirt 1.46.1, con la corrección de D-19: summary() anula la carga de los ítems
# GPCM que no cargan en el factor 1, porque multiplica por sign(0). Aquí se usa el signo de la primera pendiente que no
# es 0. Es la misma función que tienen 03_nse_tri.R y 05_tri_competencias.R; usa funciones internas de mirt (:::),
# así que hay que revisarla si cambia la versión de mirt (D-17).
cargas_mirt <- function(m) {
  pars <- m@ParObjects$pars; J <- length(pars) - 1L
  nf   <- length(mirt:::ExtractLambdas(pars[[1L]], include_fixed = FALSE))
  gcov <- mirt:::ExtractGroupPars(pars[[J + 1L]])$gcov
  stopifnot(ncol(gcov) == nf)
  L <- do.call(rbind, lapply(seq_len(J), function(i) {
    p <- pars[[i]]; l <- mirt:::ExtractLambdas(p, include_fixed = FALSE) / 1.702
    if (p@ncat > 2 && (is(p, "gpcm") || is(p, "nominal"))) {
      d <- mirt:::nominal_rescale_d(p@par[1:(nf + p@ncat)], nfact = nf, ncat = p@ncat)
      l <- l * d
      s <- sign(l[which(l != 0)[1]]); if (is.na(s)) s <- 1
      l <- l * sqrt((p@ncat - 1) * 1.702) * s
    }
    l }))
  L <- L %*% diag(sqrt(diag(gcov)), nf)
  F <- L / sqrt(1 + rowSums(L^2))
  dimnames(F) <- list(extract.mirt(m, "itemnames"), extract.mirt(m, "factorNames")); F
}

# Datos de la F4 (D-24, D-25): estructura del AFE, grupos y categorías con < 10 respuestas unidas en todos los grupos.
# Es lo mismo que hace 04_invarianza.R (líneas 47-90); lo usan 04_dif_emparejamiento.R y 04_medias_brr.R. Comprueba que
# cambian los mismos ítems que en salidas/inv_recodificacion.csv.
preparar_f4 <- function(DATOS, SALIDAS) {
  nse <- readRDS(file.path(DATOS, "COL_nse.rds")); tri <- readRDS(file.path(DATOS, "COL_nse_tri.rds"))
  fac <- attr(nse, "factores"); IND <- c(fac$economico, fac$cultural)
  est_afe <- data.table::fread(file.path(SALIDAS, "nse_estructura_afe.csv"), encoding = "UTF-8")
  CUL <- est_afe[factor_AFE == "cultural", item]; ECO <- setdiff(IND, CUL)
  stopifnot(nrow(nse) == 6886, identical(nse$CNTSTUID, tri$CNTSTUID), length(ECO) == 19, length(CUL) == 10)
  nse[, `:=`(eap_ECO = tri$eap_AFE_ECO, eap_CUL = tri$eap_AFE_CUL)]
  nse[, zona3 := factor(fcase(zona == "Urbana (>15 mil)", "Urbana", zona == "Pueblo (3-15 mil)", "Pueblo",
                              zona == "Rural (<3.000)", "Rural"), levels = c("Urbana", "Pueblo", "Rural"))]
  nse[, rural_urbana := factor(fcase(zona3 == "Urbana", "Urbana", zona3 == "Rural", "Rural"), levels = c("Urbana", "Rural"))]
  nse[, sexo2 := factor(as.character(sexo), levels = c("Mujer", "Hombre"))]
  nse[, sector2 := factor(as.character(sector), levels = c("Público", "Privado"))]
  VARS_RECOD <- c("zona3", "sexo2", "sector2"); cambiados <- character()
  for (v in IND) {
    x <- nse[[v]]; orig <- x
    repeat {
      k <- sort(unique(na.omit(x)))
      cuenta <- data.table::rbindlist(lapply(VARS_RECOD, function(g) { t <- table(factor(x[!is.na(nse[[g]])], levels = k), nse[[g]][!is.na(nse[[g]])])
        data.table::data.table(categoria = k, minimo = apply(t, 1, min)) }))[, .(minimo = min(minimo)), by = categoria]
      if (all(cuenta$minimo >= 10)) break
      centro <- mean(range(k))
      mala <- cuenta[minimo < 10][order(-abs(categoria - centro))][1, categoria]
      vecina <- if (mala > centro) max(k[k < mala]) else min(k[k > mala])
      x[!is.na(x) & x == mala] <- vecina
      x <- match(x, sort(unique(na.omit(x)))) - 1
    }
    if (!identical(as.numeric(orig), as.numeric(x))) cambiados <- c(cambiados, v)
    nse[, (v) := x]
  }
  stopifnot(setequal(cambiados, unique(data.table::fread(file.path(SALIDAS, "inv_recodificacion.csv"))$item)))
  list(nse = nse, IND = IND, ECO = ECO, CUL = CUL,
       ANALISIS = list(zona = "zona3", H2_rural_urbana = "rural_urbana", sexo = "sexo2", sector = "sector2"))
}

# ΔR² de Nagelkerke de la regresión logística (ordinal si hay más de 2 categorías) del ítem sobre la variable de
# emparejamiento, el grupo y su interacción, frente a la variable de emparejamiento sola, con pesos (D-22, D-25). Es la
# misma función que 04_invarianza.R (líneas 220-229); requiere MASS.
magnitud_dR2 <- function(y, eap, g, w) {
  nagelkerke <- function(m, m0, n) (1 - exp((2 / n) * (as.numeric(logLik(m0)) - as.numeric(logLik(m))))) /
                                   (1 - exp((2 / n) * as.numeric(logLik(m0))))
  k <- !is.na(y) & !is.na(eap) & !is.na(g); y <- y[k]; eap <- eap[k]; g <- droplevels(g[k]); w <- w[k] * sum(k) / sum(w[k])
  dd <- data.frame(y = factor(y, ordered = TRUE), eap, g, w)
  ajusta <- function(fm) suppressWarnings(if (nlevels(dd$y) > 2) MASS::polr(fm, dd, weights = w, Hess = FALSE) else
                                            glm(fm, binomial, dd, weights = w))
  tryCatch({ m0 <- ajusta(y ~ 1); m1 <- ajusta(y ~ eap); m3 <- ajusta(y ~ eap * g)
             nagelkerke(m3, m0, nrow(dd)) - nagelkerke(m1, m0, nrow(dd)) }, error = function(e) NA_real_)
}

# Correlación ponderada entre x e y (casos completos)
r_w <- function(x, y, w) { k <- !is.na(x) & !is.na(y); cov.wt(cbind(x[k], y[k]), wt = w[k], cor = TRUE)$cor[1, 2] }

# Ajuste de no respuesta por colegio (D-38): factor = suma de los pesos de todos los estudiantes del colegio / suma de
# los pesos de los incluidos, por cada columna de peso (peso final y réplicas). Devuelve una matriz con una fila por
# cada id de `ids` (en ese orden) y una columna por cada peso de `cols`. `cue` = todos los estudiantes de Colombia.
factor_d38 <- function(cue, ids, cols) {
  inc <- cue$CNTSTUID %in% ids; sch <- as.character(cue$CNTSCHID); s_ids <- sch[match(ids, cue$CNTSTUID)]
  Fm <- vapply(cols, function(cl) { w <- cue[[cl]]; tot <- tapply(w, sch, sum); den <- tapply(w[inc], sch[inc], sum)
    unname((tot[s_ids]) / den[s_ids]) }, numeric(length(ids)))
  stopifnot(all(is.finite(Fm)), all(Fm >= 1 - 1e-12)); Fm
}

# Regresión ponderada con varias columnas de peso a la vez (F6, D-42): B[peso, coeficiente, columna de Y]
wls81 <- function(X, Y, WR) {
  B <- array(NA_real_, c(ncol(WR), ncol(X), ncol(Y)), dimnames = list(colnames(WR), colnames(X), colnames(Y)))
  for (r in seq_len(ncol(WR))) { w <- WR[, r]; B[r, , ] <- solve(crossprod(X, X * w), crossprod(X, Y * w)) }
  B }
# Rubin con BRR para un vector de cantidades: theta(B, m) devuelve, para el VP m, una matriz 81 x q (fila 1 = peso final)
rubin_vec <- function(B, theta) {
  est <- lapply(1:10, function(m) theta(B, m)); q <- ncol(est[[1]])
  th <- do.call(rbind, lapply(est, function(e) e[1, ]))             # 10 x q (peso final); rbind, no t(vapply()), por q = 1
  stopifnot(nrow(th) == 10, ncol(th) == q)
  U <- Reduce(`+`, lapply(est, function(e) { dv <- sweep(e[-1, , drop = FALSE], 2, e[1, ]); 0.05 * crossprod(dv) })) / 10
  Bv <- if (q == 1) matrix(var(th[, 1])) else cov(th)
  list(est = colMeans(th), V = U + 1.1 * Bv) }
# Wald conjunta con la covarianza total de Rubin (aproximación χ² con q gl, D-42)
wald <- function(r) { s <- drop(t(r$est) %*% solve(r$V, r$est)); c(chi2 = s, gl = length(r$est), p = pchisq(s, length(r$est), lower.tail = FALSE)) }
