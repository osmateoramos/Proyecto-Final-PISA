# =============================================================================
# 05 PUNTAJES CON REGRESIÓN LATENTE - paso 3 de D-33 (5.4; D-27 punto 4, D-37 y D-39)
#
# Qué hace:
#   Con los ítems fijos en el modelo de 4 competencias (5.3), estima la regresión latente theta_i ~ N(x_i' Gamma, Sigma)
#   por EM (D-39): paso E con E1 (utilidades_e1.R, 5 puntos por dimensión) y paso M con mínimos cuadrados ponderados.
#   - Covariables (18 columnas): intercepto, EAP económico y de libros de la G2 (D-24), sexo, GRADE categórico (modal de
#     referencia), zona (pueblo, rural, sin dato), sector (privado, sin dato) y NSE económico x zona y x sector (D-37).
#   - Inicio: Gamma de la regresión de las EAP sin covariables (05_puntajes_e1.R) sobre las covariables y Sigma del
#     modelo de 4 competencias. EM acelerado con SQUAREM (mismo punto fijo; ver la sección 1).
#     Convergencia: cambio máximo de un paso del EM en Gamma y Sigma <= 1e-4 (máximo 300 iteraciones del EM). Cada
#     iteración se guarda en datos/COL_mat_rl_em.rds para retomar si se interrumpe.
#   - Con los parámetros finales: V1 (E1 frente a la malla fina en los 277 de D-33), V2 y V3 (5 frente a 7 puntos), con
#     los umbrales de D-27; confiabilidad empírica por competencia; 10 valores plausibles por estudiante de la normal
#     con la EAP y la covarianza posterior (D-27, detalle 3; set.seed(2026)) y sus controles.
#
# Entradas: datos/COL_mat_respuestas.rds, COL_mat_tri_4D.rds, COL_mat_e1_sin_cov.rds, COL_nse.rds, COL_nse_tri.rds y
#   COL_cuestionario.rds.
# Salidas: datos/COL_puntajes_competencia.rds (por estudiante; no va a Git) y, solo agregados,
#   salidas/mat_rl_coeficientes.csv, mat_rl_ajuste.csv, mat_rl_validacion.csv, mat_pv_controles.csv y
#   mat_confiabilidad_competencias.csv.
#
# Cómo correrlo (desde Proyecto_PISA/scripts/, después de 05_puntajes_e1.R; tarda horas):
#   & "C:\Program Files\R\R-4.4.1\bin\Rscript.exe" 05_puntajes_rl.R
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
source(file.path(DIR, "utilidades_pisa.R"))                        # huella()
source(file.path(DIR, "utilidades_e1.R"))                          # e1_motor()
for (f in c("COL_mat_respuestas.rds", "COL_mat_tri_4D.rds", "COL_mat_e1_sin_cov.rds", "COL_nse.rds", "COL_nse_tri.rds", "COL_cuestionario.rds"))
  if (!file.exists(file.path(DATOS, f))) stop("Falta datos/", f)
reloj <- function(...) { cat(format(Sys.time(), "%H:%M:%S"), "|", ..., "\n"); flush.console() }

R   <- readRDS(file.path(DATOS, "COL_mat_respuestas.rds"))
m4  <- readRDS(file.path(DATOS, "COL_mat_tri_4D.rds"))
sc  <- readRDS(file.path(DATOS, "COL_mat_e1_sin_cov.rds"))
nse <- readRDS(file.path(DATOS, "COL_nse.rds")); tri <- readRDS(file.path(DATOS, "COL_nse_tri.rds"))
cue <- readRDS(file.path(DATOS, "COL_cuestionario.rds"))
Y <- R$a; N <- nrow(Y); COMP <- c("emplear", "formular", "interpretar", "razonar")
stopifnot(identical(R$CNTSTUID, sc$CNTSTUID), identical(nse$CNTSTUID, tri$CNTSTUID), all(R$CNTSTUID %in% nse$CNTSTUID))
E <- e1_motor(m4, Y, R$tipo); K <- E$K

# --- Covariables (D-27 punto 4, D-37, D-39), en el orden de la matriz de respuestas
k   <- match(R$CNTSTUID, nse$CNTSTUID)
cov <- data.table(eco = tri$eap_AFE_ECO[k], libros = tri$eap_AFE_CUL[k], sexo = nse$sexo[k],
                  grade = factor(as.numeric(cue$GRADE[match(R$CNTSTUID, cue$CNTSTUID)]), levels = c(0, -3, -2, -1, 1)),
                  zona = factor(fcase(is.na(nse$zona[k]), "sin dato", nse$zona[k] == "Urbana (>15 mil)", "urbana",
                                      nse$zona[k] == "Pueblo (3-15 mil)", "pueblo", default = "rural"), levels = c("urbana", "pueblo", "rural", "sin dato")),
                  sector = factor(fcase(is.na(nse$sector[k]), "sin dato", nse$sector[k] == "Público", "público", default = "privado"),
                                  levels = c("público", "privado", "sin dato")))
stopifnot(!anyNA(cov))
X <- model.matrix(~ eco + libros + sexo + grade + zona + sector + eco:zona + eco:sector, data = cov)
stopifnot(ncol(X) == 18, qr(X)$rank == 18)
w <- nse$W_FSTUWT[k]; w <- w * N / sum(w)
wls <- function(Z) solve(crossprod(X, X * w), crossprod(X, Z * w))

# =============================================================================
# 1. EM (D-39)
# =============================================================================
paso_E <- function(Gamma, Sigma, inicio, n = "5") {
  SINV <- solve(Sigma); MU <- X %*% Gamma
  out <- lapply(seq_len(N), function(i) { md <- E$moda(i, MU[i, ], SINV, inicio[i, ]); r <- E$e1(i, md, n, MU[i, ], SINV)
    list(md = md, eap = r$eap, cov = r$cov, se = r$se) })
  list(eap = do.call(rbind, lapply(out, `[[`, "eap")), se = do.call(rbind, lapply(out, `[[`, "se")),
       cov = lapply(out, `[[`, "cov"), md = lapply(out, `[[`, "md"),
       moda = do.call(rbind, lapply(out, function(o) o$md$th)), ok = vapply(out, function(o) o$md$ok, TRUE))
}
paso_M <- function(e) { G <- wls(e$eap); res <- e$eap - X %*% G
  S <- (crossprod(res, res * w) + Reduce(`+`, Map(`*`, e$cov, w))) / sum(w); list(Gamma = G, Sigma = (S + t(S)) / 2) }

CACHE <- file.path(DATOS, "COL_mat_rl_em.rds")
H <- huella(as.list(as.data.frame(Y)), X, w, coef(m4, simplify = TRUE)$items, "D-39")
st <- if (file.exists(CACHE)) readRDS(CACHE) else NULL
if (is.null(st) || !identical(st$huella, H)) {
  st <- list(huella = H, Gamma = wls(sc$eap5), Sigma = coef(m4, simplify = TRUE)$cov, inicio = sc$eap5, iter = 0,
             historial = data.table(), convergio = FALSE)
}
# Aceleración SQUAREM (esquema S3 de Varadhan y Roland, 2008; agregada el 2026-11-08 porque el EM convergía con una
# razón de ~0,93 por iteración). Cada ciclo: dos pasos del EM, una extrapolación y un paso de estabilización. Llega al
# mismo punto fijo que el EM; si la extrapolación deja una Sigma no definida positiva, se usa el segundo paso del EM.
# La convergencia se juzga igual que antes (D-39): el cambio de un paso del EM <= 1e-4 en Gamma y en Sigma.
a_vec <- function(G, S) c(G, S[lower.tri(S, diag = TRUE)])
de_vec <- function(v) { G <- matrix(v[seq_along(st$Gamma)], nrow(st$Gamma)); S <- matrix(0, K, K)
  S[lower.tri(S, diag = TRUE)] <- v[-seq_along(st$Gamma)]; S <- S + t(S) - diag(diag(S)); list(Gamma = G, Sigma = S) }
paso_EM <- function(G, S, inicio) { e <- paso_E(G, S, inicio); nv <- paso_M(e); c(nv, list(moda = e$moda, ok = sum(e$ok))) }
anotar <- function(tipo, dG, dS, ok, alfa = NA_real_) {
  st$historial <<- rbind(st$historial, data.table(iter = st$iter, tipo = tipo, dif_Gamma = dG, dif_Sigma = dS, modas_ok = ok, alfa = alfa), fill = TRUE)
  reloj("EM", tipo, "iteración", st$iter, "| cambio Gamma", signif(dG, 3), "| cambio Sigma", signif(dS, 3), "| modas", ok, if (!is.na(alfa)) paste("| alfa", signif(alfa, 3))) }
t0 <- Sys.time()
while (!st$convergio && st$iter < 300) {
  p1 <- paso_EM(st$Gamma, st$Sigma, st$inicio); p2 <- paso_EM(p1$Gamma, p1$Sigma, p1$moda); st$iter <- st$iter + 2
  th0 <- a_vec(st$Gamma, st$Sigma); r <- a_vec(p1$Gamma, p1$Sigma) - th0; v <- a_vec(p2$Gamma, p2$Sigma) - 2 * a_vec(p1$Gamma, p1$Sigma) + th0
  alfa <- min(-1, -sqrt(sum(r^2)) / sqrt(sum(v^2)))
  ext <- de_vec(th0 - 2 * alfa * r + alfa^2 * v)
  if (!isTRUE(all(eigen(ext$Sigma, symmetric = TRUE, only.values = TRUE)$values > 1e-8))) ext <- p2[c("Gamma", "Sigma")]
  p3 <- paso_EM(ext$Gamma, ext$Sigma, p2$moda); st$iter <- st$iter + 1      # estabilización: un paso del EM desde la extrapolación
  dG <- max(abs(p3$Gamma - ext$Gamma)); dS <- max(abs(p3$Sigma - ext$Sigma))
  st$Gamma <- p3$Gamma; st$Sigma <- p3$Sigma; st$inicio <- p3$moda
  anotar("SQUAREM", dG, dS, p3$ok, alfa)
  st$convergio <- dG <= 1e-4 && dS <= 1e-4
  saveRDS(st, CACHE)
}
min_em <- round(as.numeric(Sys.time() - t0, units = "mins"), 1)
if (!st$convergio) reloj("AVISO: el EM no convergió en 300 iteraciones")

# =============================================================================
# 2. PASO E FINAL, V1-V3 CON COVARIABLES Y CONFIABILIDAD
# =============================================================================
SINV <- solve(st$Sigma); MU <- X %*% st$Gamma
e5 <- paso_E(st$Gamma, st$Sigma, st$inicio, "5"); e7 <- paso_E(st$Gamma, st$Sigma, st$inicio, "7")
sub <- sc$sub; extremos <- sub[sc$ess_v1[sub] < 100]
ref6 <- do.call(rbind, lapply(sub, function(i) E$ref(i, e5$md[[i]], "c6", MU[i, ], SINV)$eap))
ref8 <- do.call(rbind, lapply(extremos, function(i) E$ref(i, e5$md[[i]], "c8", MU[i, ], SINV)$eap))
q95 <- function(x) unname(quantile(x, 0.95))
val <- rbindlist(lapply(seq_len(K), function(j) {
  d1 <- abs(e5$eap[sub, j] - ref6[, j]); d2 <- abs(e5$eap[, j] - e7$eap[, j]); rel <- abs(e5$se[, j] - e7$se[, j]) / e7$se[, j]
  cob <- max(abs(ref6[match(extremos, sub), j] - ref8[, j]))
  data.table(competencia = COMP[j], V1_r = round(cor(e5$eap[sub, j], ref6[, j]), 6), V1_dif_max = round(max(d1), 5),
             V1_cumple = cor(e5$eap[sub, j], ref6[, j]) >= 0.999 && max(d1) <= 0.02,
             V2_r = round(cor(e5$eap[, j], e7$eap[, j]), 6), V2_dif_media = round(mean(d2), 5), V2_dif_p95 = round(q95(d2), 5),
             V2_cumple = cor(e5$eap[, j], e7$eap[, j]) >= 0.995 && mean(d2) <= 0.02 && q95(d2) <= 0.05,
             V3_mediana_pct = round(100 * median(rel), 3), V3_p95_pct = round(100 * q95(rel), 3),
             V3_cumple = median(rel) <= 0.02 && q95(rel) <= 0.05,
             cobertura_extremos_dif_max = round(cob, 5), cobertura_ok = cob <= 0.005) }))
fwrite(val, file.path(SALIDAS, "mat_rl_validacion.csv"))
valido <- all(val$V1_cumple, val$V2_cumple, val$V3_cumple, val$cobertura_ok, e5$ok)

vw <- function(x) { m <- sum(w * x) / sum(w); sum(w * (x - m)^2) / sum(w) }
confiab <- data.table(competencia = COMP,
  confiabilidad_empirica_con_covariables = round(vapply(1:K, function(j) vw(e5$eap[, j]) / (vw(e5$eap[, j]) + sum(w * e5$se[, j]^2) / sum(w)), 0), 3),
  confiabilidad_empirica_sin_covariables = round(vapply(1:K, function(j) vw(sc$eap5[, j]) / (vw(sc$eap5[, j]) + sum(w * sc$se5[, j]^2) / sum(w)), 0), 3),
  ee_posterior_mediano = round(apply(e5$se, 2, median), 3))
fwrite(confiab, file.path(SALIDAS, "mat_confiabilidad_competencias.csv"))

# =============================================================================
# 3. VALORES PLAUSIBLES (D-27, detalle 3) Y CONTROLES
# =============================================================================
set.seed(2026)
PV <- array(NA_real_, c(N, 10, K), dimnames = list(NULL, paste0("PV", 1:10), COMP))
for (i in seq_len(N)) PV[i, , ] <- matrix(rnorm(10 * K), 10, K) %*% chol(e5$cov[[i]]) + rep(e5$eap[i, ], each = 10)
media_w <- function(x) sum(w * x) / sum(w)
cov_w   <- function(M) cov.wt(M, wt = w / sum(w), method = "ML")$cov
cov_tot_pv <- Reduce(`+`, lapply(1:10, function(m) cov_w(PV[, m, ]))) / 10
cov_esperada <- cov_w(e5$eap) + Reduce(`+`, Map(`*`, e5$cov, w)) / sum(w)
controles <- rbindlist(lapply(seq_len(K), function(j) data.table(competencia = COMP[j],
  media_EAP = round(media_w(e5$eap[, j]), 4), media_PV = round(mean(vapply(1:10, function(m) media_w(PV[, m, j]), 0)), 4),
  var_PV = round(cov_tot_pv[j, j], 4), var_esperada = round(cov_esperada[j, j], 4))))
controles[, `:=`(dif_media = round(media_PV - media_EAP, 4), razon_var = round(var_PV / var_esperada, 4))]
r_pv <- cov2cor(cov_tot_pv); r_esp <- cov2cor(cov_esperada)
fwrite(controles, file.path(SALIDAS, "mat_pv_controles.csv"))

# =============================================================================
# 4. COEFICIENTES Y AJUSTE
# =============================================================================
coefs <- data.table(covariable = colnames(X), round(st$Gamma, 4)); setnames(coefs, c("covariable", COMP))
fwrite(coefs, file.path(SALIDAS, "mat_rl_coeficientes.csv"))
var_pred <- vapply(1:K, function(j) vw(drop(X %*% st$Gamma[, j])), 0)
rs <- cov2cor(st$Sigma)
ajuste <- data.table(competencia = COMP, varianza_residual = round(diag(st$Sigma), 4),
                     R2_latente = round(var_pred / (var_pred + diag(st$Sigma)), 3),
                     r_residual_con = vapply(1:K, function(j) paste(sprintf("%s %.3f", COMP[-j], rs[j, -j]), collapse = " | "), ""),
                     r_total_PV_con = vapply(1:K, function(j) paste(sprintf("%s %.3f", COMP[-j], r_pv[j, -j]), collapse = " | "), ""),
                     iteraciones_EM = st$iter, convergio = st$convergio, minutos_EM_esta_corrida = min_em,
                     puntajes_validos = valido)
fwrite(ajuste, file.path(SALIDAS, "mat_rl_ajuste.csv"))

saveRDS(list(CNTSTUID = R$CNTSTUID, eap = e5$eap, se = e5$se, pv = PV, W_FSTUWT = nse$W_FSTUWT[k], valido = valido,
             nota = "D-33, D-37, D-39: no presentar como suficientemente precisos si valido = FALSE"),
        file.path(DATOS, "COL_puntajes_competencia.rds"))

cat("\n--- EM:", st$iter, "iteraciones; convergió:", st$convergio, "---\n"); print(ajuste[, .(competencia, varianza_residual, R2_latente, iteraciones_EM, convergio)])
cat("\n--- V1-V3 con covariables (salidas/mat_rl_validacion.csv) ---\n"); print(val)
cat("\n--- Confiabilidad (salidas/mat_confiabilidad_competencias.csv) ---\n"); print(confiab)
cat("\n--- Controles de los VP (salidas/mat_pv_controles.csv) ---\n"); print(controles)
cat("\nCorrelaciones totales de los VP:\n"); print(round(r_pv, 3)); cat("Esperadas (EAP + covarianza posterior):\n"); print(round(r_esp, 3))
cat("\nPuntajes", if (valido) "VÁLIDOS según V1-V3" else "NO validados: no presentarlos como precisos (D-33)", "\n")
