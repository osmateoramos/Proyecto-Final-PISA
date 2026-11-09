# =============================================================================
# 05 PUNTAJES E1 - cuadratura de Gauss-Hermite adaptativa para la posterior del 5.4 (D-33; modifica D-31)
#
# Qué hace (pasos 1 y 2 del orden de D-33; el 3, la regresión latente, solo si estos se cumplen):
#   Para cada estudiante, la posterior de sus 4 competencias es p(theta | y) ∝ L(y | theta) · N(theta; mu, Sigma),
#   con los ítems fijos en el modelo de 4 competencias del 5.3 y, por ahora, sin covariables (mu = 0, Sigma = la
#   covarianza latente del modelo).
#   - Moda: Newton-Raphson con el gradiente y la Hessiana exactos. Con ítems 2PL y GPCM la log-verosimilitud es
#     cóncava en theta (Hessiana = -suma a a' Var(puntaje | theta)), y con la previa normal la posterior es
#     estrictamente log-cóncava: la moda es única. Se acepta si la norma infinita del gradiente es <= 1e-5 y la
#     Hessiana negativa es definida positiva (D-31 punto 4).
#   - E1: malla producto de Gauss-Hermite centrada en la moda y orientada con la Cholesky de la inversa de la
#     Hessiana negativa; 5 puntos por dimensión (625) y, para V2 y V3, 7 (2.401).
#   - Referencia: regla del rectángulo en una malla de 21 puntos por dimensión sobre ± 6 desviaciones posteriores en
#     las mismas coordenadas (194.481 puntos). No supone normalidad. Se comprueba la cobertura con 27 puntos sobre ± 8.
#   - Submuestra de V1 (D-31 punto 2): los estudiantes con tamaño efectivo < 100 en la integración de V1 (se recalcula
#     con los mismos 5.000 puntos de Halton) y 200 más al azar, set.seed(2026).
#   - Criterios (D-27, sin cambios): V1 r >= 0,999 y diferencia máxima <= 0,02 (E1 5 puntos frente a la referencia, en
#     la submuestra); V2 r >= 0,995, diferencia media <= 0,02 y P95 <= 0,05 (5 frente a 7 puntos, los 6.886);
#     V3 diferencia relativa de los EE: mediana <= 2 % y P95 <= 5 % (5 frente a 7 puntos).
#   Las probabilidades de los ítems se programan aquí (más rápido que probtrace) y se comprueban contra probtrace().
#
# Entradas: datos/COL_mat_respuestas.rds y datos/COL_mat_tri_4D.rds (05_tri_competencias.R).
# Salidas (solo agregados): salidas/mat_e1_validacion.csv y salidas/mat_e1_resumen.csv. Los puntajes por estudiante
#   van a datos/COL_mat_e1_sin_cov.rds (no va a Git).
#
# Cómo correrlo (desde Proyecto_PISA/scripts/, después de 05_tri_competencias.R):
#   & "C:\Program Files\R\R-4.4.1\bin\Rscript.exe" 05_puntajes_e1.R
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
for (f in c("COL_mat_respuestas.rds", "COL_mat_tri_4D.rds")) if (!file.exists(file.path(DATOS, f))) stop("Falta datos/", f, ": correr antes 05_tri_competencias.R")
reloj <- function(...) { cat(format(Sys.time(), "%H:%M:%S"), "|", ..., "\n"); flush.console() }

R  <- readRDS(file.path(DATOS, "COL_mat_respuestas.rds"))
m4 <- readRDS(file.path(DATOS, "COL_mat_tri_4D.rds"))
Y  <- R$a; ITEMS <- colnames(Y); N <- nrow(Y); K <- 4
COMP <- c("emplear", "formular", "interpretar", "razonar")
stopifnot(identical(extract.mirt(m4, "itemnames"), ITEMS), N == 6886)
SIGMA <- coef(m4, simplify = TRUE)$cov; SINV <- solve(SIGMA); MU0 <- rep(0, K)

# --- Parámetros de los ítems como modelos de división por el total: P(k) ∝ exp(s_k (a'theta) + d_k)
cf <- coef(m4)
PAR <- lapply(seq_along(ITEMS), function(j) { v <- cf[[j]][1, ]; a <- unname(v[paste0("a", 1:K)])
  if (R$tipo[j] == "2PL") list(a = a, s = c(0, 1), d = c(0, unname(v["d"])))
  else list(a = a, s = unname(v[grep("^ak", names(v))]), d = unname(v[grep("^d[0-9]", names(v))])) })
rowmax <- function(M) { mx <- M[, 1]; for (c in seq_len(ncol(M))[-1]) mx <- pmax(mx, M[, c]); mx }
prob <- function(p, Th) { eta <- outer(drop(Th %*% p$a), p$s) + rep(p$d, each = nrow(Th))
  eta <- eta - rowmax(eta); e <- exp(eta); e / rowSums(e) }
set.seed(1); Th_prueba <- matrix(rnorm(40 * K, sd = 1.5), ncol = K)
dif_prob <- max(vapply(seq_along(ITEMS), function(j) max(abs(prob(PAR[[j]], Th_prueba) - probtrace(extract.item(m4, j), Th_prueba))), 0))
stopifnot(dif_prob < 1e-10)                                    # las probabilidades propias son las de mirt

# --- Log-posterior (sin la constante) en muchos puntos, y gradiente y Hessiana exactos en uno
OBS <- lapply(seq_len(N), function(i) which(!is.na(Y[i, ])))
logpost <- function(i, Th, mu = MU0) {
  ll <- numeric(nrow(Th))
  for (j in OBS[[i]]) { p <- PAR[[j]]; eta <- outer(drop(Th %*% p$a), p$s) + rep(p$d, each = nrow(Th))
    mx <- rowmax(eta); ll <- ll + eta[, Y[i, j] + 1] - mx - log(rowSums(exp(eta - mx))) }
  dv <- sweep(Th, 2, mu); ll - 0.5 * rowSums((dv %*% SINV) * dv)
}
deriv <- function(i, th, mu = MU0) {
  g <- -SINV %*% (th - mu); H <- -SINV
  for (j in OBS[[i]]) { p <- PAR[[j]]; eta <- p$s * sum(p$a * th) + p$d; pr <- exp(eta - max(eta)); pr <- pr / sum(pr)
    Es <- sum(pr * p$s); Vs <- sum(pr * p$s^2) - Es^2
    g <- g + p$a * (p$s[Y[i, j] + 1] - Es); H <- H - Vs * tcrossprod(p$a) }
  list(g = drop(g), H = H)
}
moda <- function(i, mu = MU0) {
  th <- mu; lp <- logpost(i, matrix(th, 1), mu)
  for (it in 1:100) { dv <- deriv(i, th, mu); if (max(abs(dv$g)) <= 1e-10) break
    paso <- solve(-dv$H, dv$g); t <- 1
    repeat { nuevo <- th + t * paso; lpn <- logpost(i, matrix(nuevo, 1), mu); if (lpn >= lp - 1e-12 || t < 1e-8) break; t <- t / 2 }
    th <- nuevo; lp <- lpn }
  dv <- deriv(i, th, mu); ev <- eigen(-dv$H, symmetric = TRUE, only.values = TRUE)$values
  list(th = th, negH = -dv$H, ok = max(abs(dv$g)) <= 1e-5 && min(ev) > 0, grad = max(abs(dv$g)), iter = it)
}

# --- Nodos y pesos de Gauss-Hermite (peso exp(-z^2)) por Golub-Welsch
gauss_hermite <- function(n) { J <- matrix(0, n, n); off <- sqrt(seq_len(n - 1) / 2)
  J[cbind(1:(n - 1), 2:n)] <- off; J[cbind(2:n, 1:(n - 1))] <- off
  e <- eigen(J, symmetric = TRUE); list(z = e$values, w = sqrt(pi) * e$vectors[1, ]^2) }
malla <- function(z) as.matrix(expand.grid(rep(list(z), K)))
GH <- lapply(c(5, 7), function(n) { g <- gauss_hermite(n); Z <- malla(g$z)
  list(Z = Z, logw = rowSums(log(as.matrix(expand.grid(rep(list(g$w), K))))) + rowSums(Z^2)) })
names(GH) <- c("5", "7")
REF <- list(c6 = malla(seq(-6, 6, length.out = 21)), c8 = malla(seq(-8, 8, length.out = 27)))

# Integra con nodos U (coordenadas estándar) y log-pesos lw: theta = moda + C u, con C C' = inversa de -H
integrar <- function(i, md, U, lw, escala = 1, mu = MU0) {
  C <- t(chol(solve(md$negH))); Th <- sweep(U %*% t(C) * escala, 2, md$th, "+")
  lq <- lw + logpost(i, Th, mu); wq <- exp(lq - max(lq)); wq <- wq / sum(wq)
  e <- colSums(Th * wq); dv <- sweep(Th, 2, e)
  list(eap = e, se = sqrt(colSums(dv^2 * wq)), ess = 1 / sum(wq^2))
}
e1  <- function(i, md, n) integrar(i, md, GH[[n]]$Z, GH[[n]]$logw, escala = sqrt(2))
ref <- function(i, md, cual) integrar(i, md, REF[[cual]], 0)

# =============================================================================
# 1. MODA Y E1 CON 5 Y 7 PUNTOS EN LOS 6.886 (V2, V3)
# =============================================================================
reloj("E1: moda y cuadratura en", N, "estudiantes")
t0 <- Sys.time()
MD <- lapply(seq_len(N), moda)
ok_moda <- vapply(MD, `[[`, logical(1), "ok")
E5 <- lapply(seq_len(N), function(i) e1(i, MD[[i]], "5")); E7 <- lapply(seq_len(N), function(i) e1(i, MD[[i]], "7"))
min_e1 <- round(as.numeric(Sys.time() - t0, units = "mins"), 1)
eap5 <- do.call(rbind, lapply(E5, `[[`, "eap")); eap7 <- do.call(rbind, lapply(E7, `[[`, "eap"))
se5  <- do.call(rbind, lapply(E5, `[[`, "se"));  se7  <- do.call(rbind, lapply(E7, `[[`, "se"))
reloj("E1 listo en", min_e1, "min; modas aceptadas:", sum(ok_moda), "de", N)

# =============================================================================
# 2. SUBMUESTRA DE V1 Y REFERENCIA (malla fina)
# =============================================================================
# Tamaño efectivo de la integración de V1 (05_tri_competencias.R, líneas 269-285): 5.000 puntos de Halton de la previa
halton <- function(n, bases = c(2, 3, 5, 7)) vapply(bases, function(b) vapply(seq_len(n), function(i) { f <- 1; r <- 0
  while (i > 0) { f <- f / b; r <- r + f * (i %% b); i <- i %/% b }; r }, 0), numeric(n))
Zv1 <- qnorm(halton(5000)) %*% chol(SIGMA)
ess_v1 <- vapply(seq_len(N), function(i) { lq <- logpost(i, Zv1) + 0.5 * rowSums((Zv1 %*% SINV) * Zv1)  # solo verosimilitud
  wq <- exp(lq - max(lq)); wq <- wq / sum(wq); 1 / sum(wq^2) }, 0)
extremos <- which(ess_v1 < 100)
set.seed(2026); azar <- sample(setdiff(seq_len(N), extremos), 200)
sub <- c(extremos, azar)
reloj("Submuestra:", length(extremos), "con tamaño efectivo < 100 (D-27 dice 77) y", length(azar), "al azar")

RF6 <- lapply(sub, function(i) ref(i, MD[[i]], "c6")); RF8 <- lapply(sub, function(i) ref(i, MD[[i]], "c8"))
ref6 <- do.call(rbind, lapply(RF6, `[[`, "eap")); ref8 <- do.call(rbind, lapply(RF8, `[[`, "eap"))
reloj("Referencia lista")

# =============================================================================
# 3. CRITERIOS V1-V3 (D-27, sin cambios)
# =============================================================================
q95 <- function(x) unname(quantile(x, 0.95))
val <- rbindlist(lapply(seq_len(K), function(k) {
  d1 <- abs(eap5[sub, k] - ref6[, k]); d2 <- abs(eap5[, k] - eap7[, k]); rel <- abs(se5[, k] - se7[, k]) / se7[, k]
  data.table(competencia = COMP[k],
             V1_r = round(cor(eap5[sub, k], ref6[, k]), 6), V1_dif_max = round(max(d1), 5),
             V1_dif_max_extremos = round(max(d1[seq_along(extremos)]), 5),
             V1_cumple = cor(eap5[sub, k], ref6[, k]) >= 0.999 && max(d1) <= 0.02,
             V2_r = round(cor(eap5[, k], eap7[, k]), 6), V2_dif_media = round(mean(d2), 5), V2_dif_p95 = round(q95(d2), 5),
             V2_cumple = cor(eap5[, k], eap7[, k]) >= 0.995 && mean(d2) <= 0.02 && q95(d2) <= 0.05,
             V3_mediana_pct = round(100 * median(rel), 3), V3_p95_pct = round(100 * q95(rel), 3),
             V3_cumple = median(rel) <= 0.02 && q95(rel) <= 0.05,
             cobertura_ref_dif_max = round(max(abs(ref6[, k] - ref8[, k])), 5),
             cobertura_ok = max(abs(ref6[, k] - ref8[, k])) <= 0.005) }))
fwrite(val, file.path(SALIDAS, "mat_e1_validacion.csv"))

resumen <- data.table(
  medida = c("estudiantes", "modas aceptadas (gradiente <= 1e-5 y Hessiana definida)", "gradiente máximo de la moda",
             "iteraciones de Newton (máximo)", "minutos de E1 (5 y 7 puntos)", "diferencia máxima probabilidades propias vs probtrace",
             "tamaño efectivo V1 < 50", "tamaño efectivo V1 < 100", "submuestra de V1 (extremos + azar)",
             "tamaño efectivo mínimo de E1 con 5 puntos (de 625)", "todos los criterios V1-V3 y la cobertura"),
  valor = c(N, sum(ok_moda), signif(max(vapply(MD, `[[`, 0, "grad")), 3), max(vapply(MD, `[[`, 0, "iter")), min_e1,
            signif(dif_prob, 3), sum(ess_v1 < 50), length(extremos), length(sub),
            round(min(vapply(E5, `[[`, 0, "ess")), 1),
            if (all(val$V1_cumple, val$V2_cumple, val$V3_cumple, val$cobertura_ok, ok_moda)) "se cumplen" else "NO se cumplen"))
fwrite(resumen, file.path(SALIDAS, "mat_e1_resumen.csv"))
saveRDS(list(CNTSTUID = R$CNTSTUID, eap5 = eap5, se5 = se5, eap7 = eap7, se7 = se7, ok_moda = ok_moda, ess_v1 = ess_v1, sub = sub),
        file.path(DATOS, "COL_mat_e1_sin_cov.rds"))

cat("\n--- E1 sin covariables: criterios V1-V3 (salidas/mat_e1_validacion.csv) ---\n"); print(val)
cat("\n--- Resumen (salidas/mat_e1_resumen.csv) ---\n"); print(resumen)
cat("\nSi se cumplen, sigue el paso 3 de D-33 (regresión latente con los ítems fijos y E1 con covariables).\n")
