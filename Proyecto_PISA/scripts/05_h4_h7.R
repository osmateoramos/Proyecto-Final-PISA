# =============================================================================
# 05 H4 Y H7 - omisiones (paso 5.7) y validez frente a la OCDE con el enlace P3 (paso 5.5) (D-22, D-27, D-41)
#
# Qué hace:
#   H4. Con los ítems y la regresión latente fijos (D-39, D-41 punto 1), calcula la posterior de cada estudiante con E1
#       para las calificaciones (a) omitida = 0, (b) omisión rápida = faltante y (c) toda omisión = faltante, y genera
#       10 VP de cada una con los mismos números aleatorios (D-41 punto 2). Brecha Q4 - Q1 del NSE económico en DE de (a),
#       reducción (a) - (b), BRR con 80 réplicas y Rubin, Holm sobre las 4 competencias (D-41 punto 3).
#   H7. Promedio de las 10 correlaciones ponderadas VP propio m - VP de la OCDE m, matriz 4 x 4 (D-22, D-41 punto 4).
#   P3. Enlace media-sigma de las dificultades de los ítems dicotómicos con las del anexo A (D-41 punto 5).
#
# Entradas: datos/COL_mat_respuestas.rds, COL_mat_tri_4D.rds, COL_mat_rl_em.rds y COL_puntajes_competencia.rds
#   (05_puntajes_rl.R), COL_nse.rds, COL_nse_tri.rds, COL_cuestionario.rds y salidas/items_competencia.csv.
# Salidas (solo agregados): salidas/mat_h4_brechas.csv, mat_h4.csv, mat_h7_correlaciones.csv, mat_h7.csv y
#   mat_p3_enlace.csv.
#
# Cómo correrlo (desde Proyecto_PISA/scripts/, después de 05_puntajes_rl.R):
#   & "C:\Program Files\R\R-4.4.1\bin\Rscript.exe" 05_h4_h7.R
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
source(file.path(DIR, "utilidades_pisa.R"))                        # huella(), REPS
source(file.path(DIR, "utilidades_e1.R"))                          # e1_motor()
reloj <- function(...) { cat(format(Sys.time(), "%H:%M:%S"), "|", ..., "\n"); flush.console() }

R   <- readRDS(file.path(DATOS, "COL_mat_respuestas.rds")); m4 <- readRDS(file.path(DATOS, "COL_mat_tri_4D.rds"))
st  <- readRDS(file.path(DATOS, "COL_mat_rl_em.rds"));      pun <- readRDS(file.path(DATOS, "COL_puntajes_competencia.rds"))
nse <- readRDS(file.path(DATOS, "COL_nse.rds")); tri <- readRDS(file.path(DATOS, "COL_nse_tri.rds"))
cue <- readRDS(file.path(DATOS, "COL_cuestionario.rds"))
N <- nrow(R$a); COMP <- c("emplear", "formular", "interpretar", "razonar"); K <- 4
stopifnot(identical(pun$CNTSTUID, R$CNTSTUID), st$convergio)
if (!isTRUE(pun$valido)) reloj("AVISO: los puntajes de 05_puntajes_rl.R no están validados (D-33): H4 y H7 se reportan con esa salvedad")

# --- Covariables: las mismas de 05_puntajes_rl.R (se comprueba con la huella del EM)
k <- match(R$CNTSTUID, nse$CNTSTUID)
cov <- data.table(eco = tri$eap_AFE_ECO[k], libros = tri$eap_AFE_CUL[k], sexo = nse$sexo[k],
                  grade = factor(as.numeric(cue$GRADE[match(R$CNTSTUID, cue$CNTSTUID)]), levels = c(0, -3, -2, -1, 1)),
                  zona = factor(fcase(is.na(nse$zona[k]), "sin dato", nse$zona[k] == "Urbana (>15 mil)", "urbana",
                                      nse$zona[k] == "Pueblo (3-15 mil)", "pueblo", default = "rural"), levels = c("urbana", "pueblo", "rural", "sin dato")),
                  sector = factor(fcase(is.na(nse$sector[k]), "sin dato", nse$sector[k] == "Público", "público", default = "privado"),
                                  levels = c("público", "privado", "sin dato")))
X <- model.matrix(~ eco + libros + sexo + grade + zona + sector + eco:zona + eco:sector, data = cov)
W <- nse$W_FSTUWT[k]; w <- W * N / sum(W)
stopifnot(identical(st$huella, huella(as.list(as.data.frame(R$a)), X, w, coef(m4, simplify = TRUE)$items, "D-39")))
MU <- X %*% st$Gamma; SINV <- solve(st$Sigma)

# =============================================================================
# 1. POSTERIOR Y VP DE (a), (b) Y (c) CON NÚMEROS COMUNES
# =============================================================================
set.seed(2026); Z <- array(NA_real_, c(N, 10, K))
for (i in seq_len(N)) Z[i, , ] <- matrix(rnorm(10 * K), 10, K)      # mismo orden que 05_puntajes_rl.R
posterior <- function(Y) { E <- e1_motor(m4, Y, R$tipo)
  out <- lapply(seq_len(N), function(i) { md <- E$moda(i, MU[i, ], SINV, st$inicio[i, ]); r <- E$e1(i, md, "5", MU[i, ], SINV)
    list(eap = r$eap, C = r$cov, ok = md$ok) })
  pv <- array(NA_real_, c(N, 10, K))
  for (i in seq_len(N)) pv[i, , ] <- Z[i, , ] %*% chol(out[[i]]$C) + rep(out[[i]]$eap, each = 10)
  list(pv = pv, ok = vapply(out, `[[`, TRUE, "ok"), eap = do.call(rbind, lapply(out, `[[`, "eap"))) }
reloj("Posterior (a)"); Pa <- posterior(R$a)
stopifnot(max(abs(Pa$pv - unclass(pun$pv))) < 1e-8)               # reproduce los VP de 05_puntajes_rl.R
reloj("Posterior (b)"); Pb <- posterior(R$b)
reloj("Posterior (c)"); Pc <- posterior(R$c)
stopifnot(all(Pa$ok), all(Pb$ok), all(Pc$ok))

# =============================================================================
# 2. H4: BRECHA Q4 - Q1 Y SU REDUCCIÓN (D-22, D-27 punto 6, D-41 punto 3)
# =============================================================================
cuartil_w <- function(x, w) { o <- order(x); cw <- cumsum(w[o]) / sum(w[o]); q <- integer(length(x)); q[o] <- pmin(4L, 1L + floor(4 * cw - 1e-9)); q }
q <- cuartil_w(cov$eco, W)                                          # cuartiles fijos con el peso final (como en H3)
WR <- cbind(W, as.matrix(cue[match(R$CNTSTUID, CNTSTUID), ..REPS])); stopifnot(!anyNA(WR))
brecha <- function(y, ya, ww) { m <- function(g) sum(ww[q == g] * y[q == g]) / sum(ww[q == g])
  mu <- sum(ww * ya) / sum(ww); s <- sqrt(sum(ww * (ya - mu)^2) / sum(ww)); (m(4) - m(1)) / s }
rubin <- function(est_rep) {                                        # est_rep: 81 x 10 (fila 1 = peso final)
  est <- est_rep[1, ]; vm <- apply(est_rep, 2, function(t) 0.05 * sum((t[-1] - t[1])^2))
  c(est = mean(est), ee = sqrt(mean(vm) + 1.1 * var(est))) }
h4 <- rbindlist(lapply(seq_len(K), function(j) {
  calc <- function(f) rubin(sapply(1:10, function(m) apply(WR, 2, function(ww) f(m, ww))))
  ga <- calc(function(m, ww) brecha(Pa$pv[, m, j], Pa$pv[, m, j], ww))
  gb <- calc(function(m, ww) brecha(Pb$pv[, m, j], Pa$pv[, m, j], ww))
  gc <- calc(function(m, ww) brecha(Pc$pv[, m, j], Pa$pv[, m, j], ww))
  rb <- calc(function(m, ww) brecha(Pa$pv[, m, j], Pa$pv[, m, j], ww) - brecha(Pb$pv[, m, j], Pa$pv[, m, j], ww))
  rc <- calc(function(m, ww) brecha(Pa$pv[, m, j], Pa$pv[, m, j], ww) - brecha(Pc$pv[, m, j], Pa$pv[, m, j], ww))
  data.table(competencia = COMP[j], brecha_a = ga[["est"]], ee_a = ga[["ee"]], brecha_b = gb[["est"]], brecha_c = gc[["est"]],
             reduccion_b = rb[["est"]], ee_reduccion_b = rb[["ee"]], reduccion_c = rc[["est"]], ee_reduccion_c = rc[["ee"]]) }))
h4[, p_b := 2 * pnorm(-abs(reduccion_b / ee_reduccion_b))]
h4[, p_b_Holm := p.adjust(p_b, "holm")]
h4[, `:=`(ic95_inf_b = reduccion_b - 1.96 * ee_reduccion_b, ic95_sup_b = reduccion_b + 1.96 * ee_reduccion_b)]
h4[, cumple := reduccion_b >= 0.05 & p_b_Holm < 0.05]
num <- setdiff(names(h4), c("competencia", "cumple", "p_b", "p_b_Holm")); h4[, (num) := lapply(.SD, round, 4), .SDcols = num]
h4[, `:=`(p_b = signif(p_b, 3), p_b_Holm = signif(p_b_Holm, 3))]
fwrite(h4, file.path(SALIDAS, "mat_h4_brechas.csv"))
h4_res <- data.table(regla = "reducción >= 0,05 DE y significativa (Holm) en al menos una competencia",
                     competencias_que_cumplen = paste(h4[cumple == TRUE, competencia], collapse = ", "),
                     H4 = if (any(h4$cumple)) "se acepta" else "se rechaza",
                     omisiones_rapidas = sum(!is.na(R$a) & is.na(R$b)), omisiones = sum(!is.na(R$a) & is.na(R$c)),
                     puntajes_validados = isTRUE(pun$valido))
fwrite(h4_res, file.path(SALIDAS, "mat_h4.csv"))

# =============================================================================
# 3. H7: VP PROPIOS FRENTE A LOS DE LA OCDE (D-22, D-41 punto 4)
# =============================================================================
OCDE <- c(emplear = "MPEM", formular = "MPFS", interpretar = "MPIN", razonar = "MPRE")
cq <- cue[match(R$CNTSTUID, CNTSTUID)]
r_w <- function(x, y) cov.wt(cbind(x, y), wt = W / sum(W), cor = TRUE)$cor[1, 2]
M <- sapply(names(OCDE), function(o) sapply(seq_len(K), function(j) mean(sapply(1:10, function(m) r_w(Pa$pv[, m, j], cq[[paste0("PV", m, OCDE[[o]])]])))))
dimnames(M) <- list(propio = COMP, OCDE = paste0(names(OCDE), " (", OCDE, ")"))
h7c <- data.table(propio = COMP, round(M, 4)); fwrite(h7c, file.path(SALIDAS, "mat_h7_correlaciones.csv"))
diag_ok <- diag(M) >= 0.80; propia_mayor <- vapply(seq_len(K), function(j) all(M[j, j] > M[j, -j]), TRUE)
h7 <- data.table(competencia = COMP, r_misma_competencia = round(diag(M), 4), r_max_otras = round(vapply(seq_len(K), function(j) max(M[j, -j]), 0), 4),
                 parte1_r_080 = diag_ok, parte2_propia_mayor = propia_mayor)
h7[, H7 := if (all(diag_ok) && all(propia_mayor)) "se acepta" else "se rechaza"]
fwrite(h7, file.path(SALIDAS, "mat_h7.csv"))

# =============================================================================
# 4. P3: ENLACE MEDIA-SIGMA DE LAS DIFICULTADES (solo dicotómicos, D-41 punto 5)
# =============================================================================
ic <- fread(file.path(SALIDAS, "items_competencia.csv"), encoding = "UTF-8")
cf <- coef(m4, simplify = TRUE)$items; it <- colnames(R$a)
dic <- data.table(item = it, competencia = R$competencia[it], tipo = R$tipo)[tipo == "2PL"]
dic[, a_propio := vapply(item, function(j) max(abs(cf[j, paste0("a", 1:K)])), 0)]
dic[, b_propio := -cf[item, "d"] / a_propio]
dic <- merge(dic, ic[, .(item, a_int, b_int)], by = "item")[!is.na(b_int)]
p3 <- dic[, { A <- sd(b_int) / sd(b_propio); B <- mean(b_int) - A * mean(b_propio); be <- A * b_propio + B
  .(items = .N, r_b = round(cor(b_propio, b_int), 3), r_a = round(cor(a_propio, a_int), 3),
    pendiente_A = round(A, 3), intercepto_B = round(B, 3), RMSD_b_enlazado = round(sqrt(mean((be - b_int)^2)), 3)) }, by = competencia]
fwrite(p3, file.path(SALIDAS, "mat_p3_enlace.csv"))

cat("\n--- H4 (salidas/mat_h4_brechas.csv y mat_h4.csv) ---\n"); print(h4); print(h4_res)
cat("\n--- H7 (salidas/mat_h7_correlaciones.csv y mat_h7.csv) ---\n"); print(round(M, 3)); print(h7)
cat("\n--- P3 (salidas/mat_p3_enlace.csv) ---\n"); print(p3)
