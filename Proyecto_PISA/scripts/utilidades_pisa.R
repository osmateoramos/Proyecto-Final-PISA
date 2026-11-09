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

# Correlación ponderada entre x e y (casos completos)
r_w <- function(x, y, w) { k <- !is.na(x) & !is.na(y); cov.wt(cbind(x[k], y[k]), wt = w[k], cor = TRUE)$cor[1, 2] }
