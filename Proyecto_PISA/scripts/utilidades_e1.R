# =============================================================================
# UTILIDADES E1 - posterior de las 4 competencias con cuadratura de Gauss-Hermite adaptativa (D-33)
#
# Se carga con source() desde 05_puntajes_e1.R (validación sin covariables) y 05_puntajes_rl.R (regresión latente).
# e1_motor(m4, Y, tipos) devuelve las funciones para una previa normal N(mu, Sigma) de cada estudiante:
#   - logpost(i, Th, mu, SINV): log-posterior sin la constante en las filas de Th;
#   - moda(i, mu, SINV, inicio): Newton-Raphson con gradiente y Hessiana exactos. Con ítems 2PL y GPCM la
#     log-verosimilitud es cóncava en theta (Hessiana = -suma a a' Var(puntaje | theta)) y la previa normal la hace
#     estrictamente cóncava: la moda es única. Se acepta si |gradiente| <= 1e-5 y -Hessiana es definida positiva;
#   - e1(i, md, n, mu, SINV): malla producto de Gauss-Hermite con n puntos por dimensión, centrada en la moda y
#     orientada con la Cholesky de la inversa de -Hessiana; devuelve EAP, covarianza y EE posteriores;
#   - ref(i, md, cual, mu, SINV): regla del rectángulo en una malla de 21 puntos por dimensión sobre ± 6 desviaciones
#     posteriores ("c6") o 27 sobre ± 8 ("c8"); no supone normalidad.
# Las probabilidades de los ítems se programan aquí como modelos de división por el total, P(k) ∝ exp(s_k a'theta + d_k),
# y prob() permite compararlas con probtrace() de mirt.
# =============================================================================

e1_motor <- function(m4, Y, tipos) {
  K <- ncol(coef(m4, simplify = TRUE)$cov); cf <- coef(m4)
  PAR <- lapply(seq_len(ncol(Y)), function(j) { v <- cf[[j]][1, ]; a <- unname(v[paste0("a", 1:K)])
    if (tipos[j] == "2PL") list(a = a, s = c(0, 1), d = c(0, unname(v["d"])))
    else list(a = a, s = unname(v[grep("^ak", names(v))]), d = unname(v[grep("^d[0-9]", names(v))])) })
  OBS <- lapply(seq_len(nrow(Y)), function(i) which(!is.na(Y[i, ])))
  rowmax <- function(M) { mx <- M[, 1]; for (c in seq_len(ncol(M))[-1]) mx <- pmax(mx, M[, c]); mx }
  prob <- function(j, Th) { p <- PAR[[j]]; eta <- outer(drop(Th %*% p$a), p$s) + rep(p$d, each = nrow(Th))
    eta <- eta - rowmax(eta); e <- exp(eta); e / rowSums(e) }
  logpost <- function(i, Th, mu, SINV) {
    ll <- numeric(nrow(Th))
    for (j in OBS[[i]]) { p <- PAR[[j]]; eta <- outer(drop(Th %*% p$a), p$s) + rep(p$d, each = nrow(Th))
      mx <- rowmax(eta); ll <- ll + eta[, Y[i, j] + 1] - mx - log(rowSums(exp(eta - mx))) }
    dv <- sweep(Th, 2, mu); ll - 0.5 * rowSums((dv %*% SINV) * dv)
  }
  deriv <- function(i, th, mu, SINV) {
    g <- -SINV %*% (th - mu); H <- -SINV
    for (j in OBS[[i]]) { p <- PAR[[j]]; eta <- p$s * sum(p$a * th) + p$d; pr <- exp(eta - max(eta)); pr <- pr / sum(pr)
      Es <- sum(pr * p$s); Vs <- sum(pr * p$s^2) - Es^2
      g <- g + p$a * (p$s[Y[i, j] + 1] - Es); H <- H - Vs * tcrossprod(p$a) }
    list(g = drop(g), H = H)
  }
  moda <- function(i, mu, SINV, inicio = mu) {
    th <- inicio; lp <- logpost(i, matrix(th, 1), mu, SINV)
    for (it in 1:100) { dv <- deriv(i, th, mu, SINV); if (max(abs(dv$g)) <= 1e-10) break
      paso <- solve(-dv$H, dv$g); t <- 1
      repeat { nuevo <- th + t * paso; lpn <- logpost(i, matrix(nuevo, 1), mu, SINV); if (lpn >= lp - 1e-12 || t < 1e-8) break; t <- t / 2 }
      th <- nuevo; lp <- lpn }
    dv <- deriv(i, th, mu, SINV); ev <- eigen(-dv$H, symmetric = TRUE, only.values = TRUE)$values
    list(th = th, negH = -dv$H, ok = max(abs(dv$g)) <= 1e-5 && min(ev) > 0, grad = max(abs(dv$g)), iter = it)
  }
  gauss_hermite <- function(n) { J <- matrix(0, n, n); off <- sqrt(seq_len(n - 1) / 2)
    J[cbind(1:(n - 1), 2:n)] <- off; J[cbind(2:n, 1:(n - 1))] <- off
    e <- eigen(J, symmetric = TRUE); list(z = e$values, w = sqrt(pi) * e$vectors[1, ]^2) }
  malla <- function(z) as.matrix(expand.grid(rep(list(z), K)))
  GH <- lapply(c("5" = 5, "7" = 7), function(n) { g <- gauss_hermite(n); Z <- malla(g$z)
    list(Z = Z, logw = rowSums(log(as.matrix(expand.grid(rep(list(g$w), K))))) + rowSums(Z^2)) })
  REF <- list(c6 = malla(seq(-6, 6, length.out = 21)), c8 = malla(seq(-8, 8, length.out = 27)))
  integrar <- function(i, md, U, lw, escala, mu, SINV) {
    C <- t(chol(solve(md$negH))); Th <- sweep(U %*% t(C) * escala, 2, md$th, "+")
    lq <- lw + logpost(i, Th, mu, SINV); wq <- exp(lq - max(lq)); wq <- wq / sum(wq)
    e <- colSums(Th * wq); dv <- sweep(Th, 2, e); cv <- crossprod(dv * sqrt(wq))
    list(eap = e, cov = cv, se = sqrt(diag(cv)), ess = 1 / sum(wq^2))
  }
  list(K = K, PAR = PAR, OBS = OBS, prob = prob, logpost = logpost, moda = moda,
       e1  = function(i, md, n, mu, SINV) integrar(i, md, GH[[n]]$Z, GH[[n]]$logw, sqrt(2), mu, SINV),
       ref = function(i, md, cual, mu, SINV) integrar(i, md, REF[[cual]], 0, 1, mu, SINV))
}
