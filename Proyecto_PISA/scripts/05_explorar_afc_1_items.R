# -----------------------------------------------------------------------------------------------------------------
# Copia en el proyecto (2026-11-10) de afc_1_items.R, que corrió en una copia aparte (scratchpad de Claude) del
# 2026-11-08 al 2026-11-10. Solo cambian las rutas y los nombres de los archivos de salida; el cálculo es el mismo.
# Exploratorio y posterior a la Puerta G4: no está en 00_correr_todo.R ni registrado en el 03 (ver Hallazgos.md y la
# nota 17, sección 10). Requiere datos/COL_mat_respuestas.rds, COL_mat_tri_1D.rds y COL_mat_tri_4D.rds, que genera
# 05_tri_competencias.R. Se corre desde Proyecto_PISA/scripts/ con Rscript.
# -----------------------------------------------------------------------------------------------------------------
# AFC de los ítems de matemáticas, parte 1 (lectura fijada en afc_0_lectura_y_viabilidad.R): pruebas A, B, C y E.
# AFC de información completa a nivel de ítem: es el modelo confirmatorio de 4 factores del 5.3 (cada ítem solo en su
# competencia), en la parametrización de TRI (2PL y GPCM), que usa todas las respuestas observadas.
# Cada ítem se reestima solo, con el resto del modelo fijo: la posterior de cada estudiante sale de sus OTROS ítems
# (se deja fuera el ítem evaluado), con 5.000 puntos QMC y la covarianza latente del 5.3. Es una prueba condicional:
# no reestima el resto del modelo y, con pesos, la razón de verosimilitud es aproximada.
# Solo guarda agregados por ítem (Ley 1581).
suppressPackageStartupMessages({ library(data.table); library(mirt) })
carpeta_script <- function() { arg <- grep("^--file=", commandArgs(FALSE), value = TRUE)
  if (length(arg)) dirname(normalizePath(sub("^--file=", "", arg))) else getwd() }
DIR <- carpeta_script(); DATOS <- normalizePath(file.path(DIR, "..", "datos")); SALIDAS <- normalizePath(file.path(DIR, "..", "salidas"))
S <- SALIDAS
D <- DATOS
M <- readRDS(file.path(D, "COL_mat_respuestas.rds")); A <- M$a; ITEMS <- colnames(A); COMP <- M$competencia[ITEMS]; tipos <- M$tipo[ITEMS]
nse <- readRDS(file.path(D, "COL_nse.rds")); w0 <- nse$W_FSTUWT[match(M$CNTSTUID, nse$CNTSTUID)]; stopifnot(!anyNA(w0))
m1 <- readRDS(file.path(D, "COL_mat_tri_1D.rds")); m4 <- readRDS(file.path(D, "COL_mat_tri_4D.rds"))
K <- c("emplear", "formular", "interpretar", "razonar"); FACT <- c(EMP = "emplear", FOR = "formular", INT = "interpretar", RAZ = "razonar")
Phi <- coef(m4, simplify = TRUE)$cov; stopifnot(identical(colnames(Phi), names(FACT)))
sv <- as.data.table(mod2values(m4))

# --- Cargas estandarizadas como en la F3 (cargas_mirt de 03_nse_tri.R, copiada tal cual): sirve de control
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
F4 <- cargas_mirt(m4); stopifnot(identical(rownames(F4), ITEMS), identical(colnames(F4), names(FACT)))

# Constante que pasa de pendiente a carga en la escala de cargas_mirt (depende solo del tipo de ítem)
const <- sapply(seq_along(ITEMS), function(i) { p <- m4@ParObjects$pars[[i]]
  if (p@ncat > 2) (1 / 1.702) * mirt:::nominal_rescale_d(p@par[1:(4 + p@ncat)], nfact = 4, ncat = p@ncat) * sqrt((p@ncat - 1) * 1.702) else 1 / 1.702 })

par_item <- function(j) { s <- sv[item == j]; a <- s[name %in% paste0("a", 1:4), value]
  d <- if (tipos[[j]] == "2PL") s[name == "d", value] else s[name %in% c("d1", "d2"), value]; list(a = a, d = d) }
prob <- function(th, a, d, tipo) { eta <- drop(th %*% a)
  if (tipo == "2PL") { p1 <- plogis(eta + d); return(cbind(1 - p1, p1)) }
  lp <- cbind(0, eta + d[1], 2 * eta + d[2]); ex <- exp(lp - pmax(lp[, 1], lp[, 2], lp[, 3])); ex / rowSums(ex) }

# --- Puntos QMC (Halton de 4 dimensiones transformada a normal), como D-27
halton <- function(n, b, salto = 409) sapply(seq_len(n) + salto, function(i) { f <- 1; r <- 0
  while (i > 0) { f <- f / b; r <- r + f * (i %% b); i <- i %/% b }; r })
Q <- 5000; U <- sapply(c(2, 3, 5, 7), function(b) halton(Q, b)); TH <- qnorm(U) %*% chol(Phi)
cat("Covarianza de los puntos frente a la del modelo (máx. dif.):", round(max(abs(cov(TH) - Phi)), 3), "\n")

# Control: mis probabilidades coinciden con las de mirt
for (j in ITEMS[c(1, which(tipos == "gpcm")[1], 100)]) { p <- par_item(j); pm <- probtrace(extract.item(m4, j), TH[1:50, ])
  stopifnot(max(abs(prob(TH[1:50, ], p$a, p$d, tipos[[j]]) - pm)) < 1e-6) }
cat("Control de probabilidades frente a mirt: correcto\n"); flush.console()

# --- Log-verosimilitud de cada estudiante en cada punto
n <- nrow(A); L <- matrix(0, n, Q)
logP <- function(j) { p <- par_item(j); log(prob(TH, p$a, p$d, tipos[[j]])) }
for (j in ITEMS) { lp <- logP(j); for (x in 0:(ncol(lp) - 1)) { ii <- which(A[, j] == x)
  if (length(ii)) L[ii, ] <- L[ii, , drop = FALSE] + rep(lp[, x + 1], each = length(ii)) } }
cat(format(Sys.time(), "%H:%M:%S"), "matriz de log-verosimilitud lista\n"); flush.console()

ajusta <- function(j, cuales, ini_a, ini_d, PI, x, w) {
  tipo <- tipos[[j]]; na <- length(cuales)
  nll <- function(par) { a <- numeric(4); a[cuales] <- par[seq_len(na)]; P <- prob(TH, a, par[-seq_len(na)], tipo); ll <- 0
    for (c in unique(x)) { i <- x == c; ll <- ll + sum(w[i] * log(pmax(drop(PI[i, , drop = FALSE] %*% P[, c + 1]), 1e-300))) }; -ll }
  o <- optim(c(ini_a, ini_d), nll, method = "L-BFGS-B", lower = c(rep(-8, na), rep(-25, length(ini_d))),
             upper = c(rep(8, na), rep(25, length(ini_d))), control = list(maxit = 300))
  list(par = o$par, ll = -o$value, nll = nll, conv = o$convergence)
}

res <- rbindlist(lapply(seq_along(ITEMS), function(idx) { j <- ITEMS[idx]; k0 <- match(COMP[[j]], K); p <- par_item(j)
  ii <- which(!is.na(A[, j])); x <- A[ii, j]; lp <- logP(j); Lm <- L[ii, , drop = FALSE]
  for (c in unique(x)) { i <- which(x == c); Lm[i, ] <- Lm[i, , drop = FALSE] - rep(lp[, c + 1], each = length(i)) }   # deja fuera el ítem
  PI <- exp(Lm - apply(Lm, 1, max)); PI <- PI / rowSums(PI)
  w <- w0[ii] * length(ii) / sum(w0[ii]); aown <- p$a[k0]
  fk <- lapply(1:4, function(k) ajusta(j, k, aown, p$d, PI, x, w)); ll <- vapply(fk, `[[`, 0, "ll")
  own <- fk[[k0]]; nd <- length(p$d)
  fr <- ajusta(j, 1:4, replace(numeric(4), k0, own$par[1]), own$par[-1], PI, x, w)
  H <- optimHess(own$par, own$nll); se <- tryCatch(sqrt(solve(H)[1, 1]), error = function(e) NA_real_)
  esc <- function(a) { l <- a * const[idx]; l / sqrt(1 + l^2) }
  afree <- fr$par[1:4]; l <- afree * const[idx]; lam <- l / sqrt(drop(1 + t(l) %*% Phi %*% l)); LR <- max(2 * (fr$ll - own$ll), 0)
  if (idx %% 20 == 0) { cat(format(Sys.time(), "%H:%M:%S"), "ítem", idx, "de 232\n"); flush.console() }
  data.table(item = j, competencia = COMP[[j]], tipo = tipos[[j]], n = length(ii), a_propia = own$par[1], ee_a = se,
             carga_propia = esc(own$par[1]), carga_lim_inf = esc(own$par[1] - 1.96 * se), carga_5_3 = F4[j, k0],
             mejor_dim = K[which.max(ll)], ll_dif_mejor_propia = max(ll) - ll[k0], LR_cruzadas = LR, p_cruzadas = pchisq(LR, 3, lower.tail = FALSE),
             lam_EMP = lam[1], lam_FOR = lam[2], lam_INT = lam[3], lam_RAZ = lam[4], lam_propia_libre = lam[k0],
             lam_cruzada_max = max(abs(lam[-k0])), conv = max(own$conv, fr$conv)) }))
res[, p_BH := p.adjust(p_cruzadas, "BH")]
fwrite(res, file.path(S, "mat_afc_items_condicional.csv"))

cat("\n=== A. ¿Mide su competencia? (carga propia >= 0,30 y límite inferior > 0) ===\n")
res[, A_ok := carga_propia >= 0.30 & carga_lim_inf > 0]
print(res[, .(items = .N, cumple_A = sum(A_ok, na.rm = TRUE), pct = round(100 * mean(A_ok, na.rm = TRUE), 1), carga_mediana = round(median(carga_propia), 2),
              carga_min = round(min(carga_propia), 2)), keyby = competencia])
cat("Total A:", sum(res$A_ok, na.rm = TRUE), "de", nrow(res), "(", round(100 * mean(res$A_ok, na.rm = TRUE), 1), "%)\n")
cat("Control: correlación carga condicional – carga del 5.3:", round(cor(res$carga_propia, res$carga_5_3), 4), "\n")
cat("Ítems que no cumplen A, por respuestas (<500 / >=500):", res[A_ok == FALSE & n < 500, .N], "/", res[A_ok == FALSE & n >= 500, .N], "\n")

cat("\n=== B. ¿Únicamente esa? (BH 5 % y alguna carga cruzada >= 0,30) ===\n")
res[, B_marca := p_BH < 0.05 & lam_cruzada_max >= 0.30]
print(res[, .(items = .N, sig_BH = sum(p_BH < 0.05), cruzada_030 = sum(lam_cruzada_max >= 0.30), marcados = sum(B_marca), pct = round(100 * mean(B_marca), 1)), keyby = competencia])
cat("Total B:", sum(res$B_marca), "de", nrow(res), "(", round(100 * mean(res$B_marca), 1), "%)\n")
cat("Mediana de LR de las cruzadas (esperado con 3 gl si no hay cruzadas: 2,37):", round(median(res$LR_cruzadas), 2), "\n")
cat("Convergencia con avisos en", sum(res$conv != 0), "ítems\n")

cat("\n=== C. ¿En cuál competencia encaja mejor? (azar: 25 %) ===\n")
tc <- res[, .(items = .N, asignada_es_mejor = sum(mejor_dim == competencia), pct = round(100 * mean(mejor_dim == competencia), 1)), keyby = competencia]; print(tc)
cat("Total C:", sum(res$mejor_dim == res$competencia), "de", nrow(res), "(", round(100 * mean(res$mejor_dim == res$competencia), 1), "%)\n")
print(dcast(res[, .N, by = .(asignada = competencia, mejor = mejor_dim)], asignada ~ mejor, value.var = "N", fill = 0))
cat("Mediana de ventaja en log-verosimilitud de la mejor frente a la asignada:", round(median(res$ll_dif_mejor_propia), 3), "\n")

cat("\n=== E. Residuos Q3, pares de unidades distintas con >= 200 estudiantes en común ===\n")
ic <- fread(file.path(SALIDAS, "items_competencia.csv"), encoding = "UTF-8")[calibrable == TRUE]
un <- setNames(ic$unidad, ic$item); N <- crossprod(!is.na(A))
q3r <- rbindlist(lapply(c("1D", "4D"), function(k) { mod <- if (k == "1D") m1 else m4
  th <- if (k == "4D") fscores(mod, method = "EAP", QMC = TRUE, full.scores = TRUE, verbose = FALSE) else NULL
  Qm <- residuals(mod, type = "Q3", Theta = th, verbose = FALSE); stopifnot(identical(rownames(Qm), ITEMS))
  ij <- which(upper.tri(Qm), arr.ind = TRUE)
  data.table(modelo = k, Q3 = Qm[ij], n = N[ij], misma_unidad = un[ITEMS[ij[, 1]]] == un[ITEMS[ij[, 2]]],
             misma_comp = COMP[ij[, 1]] == COMP[ij[, 2]]) }))
print(q3r[!is.na(Q3) & !misma_unidad & n >= 200, .(pares = .N, Q3_medio = round(mean(Q3), 4), Q3_mediana = round(median(Q3), 4),
          pct_marcados = round(100 * mean(abs(Q3) > 0.2), 1)), keyby = .(modelo, tipo = fifelse(misma_comp, "misma competencia", "competencias distintas"))])
