# =============================================================================
# 07 SENSIBILIDAD - paso 7.1 de la F7 (D-45)
#
# Qué hace: pone a prueba los 5 candidatos de D-45 con las sensibilidades que les aplican y cuenta la robustez con la
# regla del 75 % (mínimo 3).
#   K1 igualdad del NSE entre competencias rechazada y H5 con su regla (completa y mitad de confirmación)
#   K2 interacción NSE x sector significativa (Holm)       K3 NSE > 0 y significativo en las 4 competencias
#   K4 H4 rechazada                                         K5 H3: primera parte sí, segunda no
#   Sensibilidades: S-A ESCS · S-B sin ruta lineal (MPATH = Linear) · S-C omisión rápida NT15 y 5 s · S-D sin corrección
#   múltiple · S-E reponderación por colegio (D-38).
#   - K1-K3 usan la F6 en dos pasos (D-42) con los VP de la OCDE, BRR y Rubin; la versión base debe reproducir
#     salidas/sem_h5.csv y sem_h6.csv.
#   - K4 usa los ítems, la regresión latente y los números aleatorios de D-41; los VP de las versiones (b) NT10, NT15 y 5 s
#     se calculan con E1 (caché datos/COL_f7_h4_pv.rds). La base debe reproducir salidas/mat_h4_brechas.csv.
#   - K5 lee salidas/f7_h3_<variante>.csv (05_dif_matematicas.R con F7_VARIANTE); S-D se calcula aquí desde
#     salidas/mat_dif.csv. Si falta una variante, la fila queda «pendiente».
#   - En S-B los cuartiles de H4 quedan fijos (los de la muestra completa); en S-E se recalculan con el peso ajustado.
#
# Entradas: datos/COL_nse.rds, COL_nse_tri.rds, COL_cuestionario.rds, COL_cognitivo.rds, COL_mat_respuestas.rds,
#   COL_mat_tri_4D.rds, COL_mat_rl_em.rds, COL_puntajes_competencia.rds; salidas/sem_h5.csv, sem_h6.csv,
#   mat_h4_brechas.csv, mat_dif.csv y f7_h3_*.csv.
# Salidas (solo agregados): salidas/f7_sensibilidad_detalle.csv y f7_robustez.csv.
#
# Cómo correrlo (desde Proyecto_PISA/scripts/; ~15 min la primera vez por los VP de H4):
#   & "C:\Program Files\R\R-4.4.1\bin\Rscript.exe" 07_sensibilidad.R
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
source(file.path(DIR, "utilidades_pisa.R"))                        # REPS, huella(), factor_d38(), wls81(), rubin_vec(), wald()
source(file.path(DIR, "utilidades_e1.R"))                          # e1_motor()
reloj <- function(...) { cat(format(Sys.time(), "%H:%M:%S"), "|", ..., "\n"); flush.console() }

nse <- readRDS(file.path(DATOS, "COL_nse.rds")); tri <- readRDS(file.path(DATOS, "COL_nse_tri.rds"))
cue <- readRDS(file.path(DATOS, "COL_cuestionario.rds")); cog <- readRDS(file.path(DATOS, "COL_cognitivo.rds"))
stopifnot(nrow(nse) == 6886, identical(nse$CNTSTUID, tri$CNTSTUID), !anyNA(nse$ESCS))
cq <- cue[match(nse$CNTSTUID, CNTSTUID)]
OCDE <- c(emplear = "MPEM", formular = "MPFS", interpretar = "MPIN", razonar = "MPRE"); COMP <- names(OCDE)
col_pv <- function(comp, m) paste0("PV", m, OCDE[[comp]])
PVN <- unlist(lapply(OCDE, function(o) paste0("PV", 1:10, o)))
Y <- as.matrix(cq[, ..PVN])

# --- Pesos (D-38) y ruta lineal, en el orden de nse
WCOL <- c("W_FSTUWT", REPS)
WR0  <- as.matrix(cbind(W_FSTUWT = nse$W_FSTUWT, cq[, ..REPS])); stopifnot(!anyNA(WR0))
WR38 <- WR0 * factor_d38(cue, nse$CNTSTUID, WCOL)
ruta <- as.character(cog$MPATH[match(nse$CNTSTUID, cog$CNTSTUID)]); stopifnot(!anyNA(ruta))
NOLIN <- ruta != "Linear"
reloj("Ruta lineal en la muestra analítica:", sum(!NOLIN), "| factor D-38 del peso final: de", round(min(WR38[, 1] / WR0[, 1]), 3),
      "a", round(max(WR38[, 1] / WR0[, 1]), 3))

# =============================================================================
# 1. K1-K3: F6 EN DOS PASOS (D-42) BAJO CADA SENSIBILIDAD
# =============================================================================
d <- data.table(eco = tri$eap_AFE_ECO, libros = tri$eap_AFE_CUL, escs = nse$ESCS, sexo = nse$sexo, mitad = nse$mitad,
                grado = factor(as.numeric(cq$GRADE), levels = c(0, -3, -2, -1, 1)),
                zona = factor(fcase(nse$zona == "Urbana (>15 mil)", "urbana", nse$zona == "Pueblo (3-15 mil)", "pueblo",
                                    nse$zona == "Rural (<3.000)", "rural"), levels = c("urbana", "pueblo", "rural")),
                sector = factor(fcase(nse$sector == "Público", "público", nse$sector == "Privado", "privado"), levels = c("público", "privado")))
mm <- function(f, dd) { X <- model.matrix(f, dd); X[, colSums(abs(X)) > 0, drop = FALSE] }   # sin niveles vacíos
p_de <- function(r) 2 * pnorm(-abs(r$est / sqrt(diag(r$V))))

f6_dec <- function(usar_escs, sub, WR) {
  dd <- d[sub]; dd[, x1 := if (usar_escs) escs else eco]
  f  <- if (usar_escs) ~ x1 + sexo + grado else ~ x1 + libros + sexo + grado
  X <- mm(f, dd); Ys <- Y[sub, ]; W <- WR[sub, ]
  B <- wls81(X, Ys, W)
  co <- rbindlist(lapply(COMP, function(cp) { r <- rubin_vec(B, function(B, m) matrix(B[, "x1", col_pv(cp, m)], ncol = 1))
    data.table(competencia = cp, est = r$est, p = p_de(r)) }))
  dx <- function(B, m, a, b) B[, "x1", col_pv(a, m)] - B[, "x1", col_pv(b, m)]
  ig <- wald(rubin_vec(B, function(B, m) cbind(dx(B, m, "formular", "emplear"), dx(B, m, "interpretar", "emplear"), dx(B, m, "razonar", "emplear"))))
  h5 <- function(B) { r <- rubin_vec(B, function(B, m) matrix(dx(B, m, "interpretar", "emplear"), ncol = 1)); c(est = r$est, p = p_de(r)) }
  conf <- dd$mitad == "confirmacion"
  h5f <- h5(B); h5c <- h5(wls81(X[conf, ], Ys[conf, ], W[conf, ]))
  ok6 <- !is.na(dd$zona) & !is.na(dd$sector)
  X6 <- mm(update(f, ~ . + zona + sector + x1:zona + x1:sector), dd[ok6]); B6 <- wls81(X6, Ys[ok6, ], W[ok6, ])
  th <- function(v) function(B, m) do.call(cbind, lapply(COMP, function(cp) B[, v, col_pv(cp, m), drop = FALSE][, , 1]))
  wz <- wald(rubin_vec(B6, th(c("x1:zonapueblo", "x1:zonarural")))); ws <- wald(rubin_vec(B6, th("x1:sectorprivado")))
  ph <- p.adjust(c(wz[["p"]], ws[["p"]]), "holm")
  list(co = co, ig = ig, h5f = h5f, h5c = h5c, pz = wz[["p"]], ps = ws[["p"]], ps_holm = ph[2], n = nrow(dd))
}
TODOS <- rep(TRUE, nrow(d))
F6 <- list(base = f6_dec(FALSE, TODOS, WR0), S_A = f6_dec(TRUE, TODOS, WR0), S_B = f6_dec(FALSE, NOLIN, WR0),
           S_E = f6_dec(FALSE, TODOS, WR38))
reloj("F6 bajo las sensibilidades: listo")
# La base reproduce la F6 (D-42)
s5 <- fread(file.path(SALIDAS, "sem_h5.csv")); s6 <- fread(file.path(SALIDAS, "sem_h6.csv"))
stopifnot(abs(F6$base$h5f[["est"]] - s5$diferencia_interpretar_menos_emplear[1]) < 0.006,
          abs(F6$base$h5c[["est"]] - s5$diferencia_interpretar_menos_emplear[2]) < 0.006,
          abs(F6$base$ps_holm / s6$p_Holm[2] - 1) < 0.01)

k1 <- function(o) o$ig[["p"]] < 0.05 && all(c(o$h5f[["est"]], o$h5c[["est"]]) > 0) && all(c(o$h5f[["p"]], o$h5c[["p"]]) < 0.05)
k1_txt <- function(o) sprintf("igualdad p = %.2g; H5 completa %.3g (p = %.2g); mitad %.3g (p = %.2g); n = %d",
                              o$ig[["p"]], o$h5f[["est"]], o$h5f[["p"]], o$h5c[["est"]], o$h5c[["p"]], o$n)
k3 <- function(o) all(o$co$est > 0 & o$co$p < 0.05)
k3_txt <- function(o) paste0(paste(sprintf("%s %.3g (p = %.2g)", o$co$competencia, o$co$est, o$co$p), collapse = "; "), sprintf("; n = %d", o$n))
k2_txt <- function(o, holm = TRUE) sprintf("NSE x sector p %s = %.2g (zona p = %.2g); n = %d", if (holm) "Holm" else "sin corregir",
                                          if (holm) o$ps_holm else o$ps, o$pz, o$n)
SENS <- c(S_A = "S-A ESCS", S_B = "S-B sin ruta lineal", S_C = "S-C umbral de omisión (NT15 y 5 s)",
          S_D = "S-D sin corrección múltiple", S_E = "S-E reponderación D-38")
fila <- function(k, s, ok, txt) data.table(candidato = k, sensibilidad = SENS[[s]], se_mantiene = ok, detalle = txt)
det <- list()
for (s in c("S_A", "S_B", "S_E")) {
  o <- F6[[s]]
  det[[length(det) + 1]] <- fila("K1", s, k1(o), k1_txt(o))
  det[[length(det) + 1]] <- fila("K2", s, o$ps_holm < 0.05, k2_txt(o))
  det[[length(det) + 1]] <- fila("K3", s, k3(o), k3_txt(o))
}
det[[length(det) + 1]] <- fila("K2", "S_D", F6$base$ps < 0.05, k2_txt(F6$base, holm = FALSE))
base_txt <- list(K1 = k1_txt(F6$base), K2 = k2_txt(F6$base), K3 = k3_txt(F6$base))

# =============================================================================
# 2. K4: H4 BAJO CADA SENSIBILIDAD (D-41 con los cambios de D-45)
# =============================================================================
R  <- readRDS(file.path(DATOS, "COL_mat_respuestas.rds")); m4 <- readRDS(file.path(DATOS, "COL_mat_tri_4D.rds"))
st <- readRDS(file.path(DATOS, "COL_mat_rl_em.rds"));      pun <- readRDS(file.path(DATOS, "COL_puntajes_competencia.rds"))
N <- nrow(R$a); K <- 4; stopifnot(identical(pun$CNTSTUID, R$CNTSTUID), st$convergio, isTRUE(pun$valido))
kr <- match(R$CNTSTUID, nse$CNTSTUID)

# --- Matrices (b) con otros umbrales, con la misma regla de 05_tri_competencias.R (líneas 61-76)
dc <- cog[match(R$CNTSTUID, cog$CNTSTUID)]
puntaje <- function(x) if (any(x >= 10, na.rm = TRUE)) x %/% 10 else x
tiempo  <- function(j) dc[[paste0(sub("^D", "C", sub("[SC]$", "", j)), "TT")]] / 1000
version_b <- function(regla) {
  Bm <- R$a
  for (j in colnames(R$a)) {
    e <- dc[[paste0("E_", j)]]; tt <- tiempo(j); visto <- e %in% c("respondido", "omitido") & !is.na(tt)
    umbral <- switch(regla, NT10 = 0.10 * mean(tt[visto]), NT15 = 0.15 * mean(tt[visto]), s5 = 5)
    Bm[e == "omitido" & !is.na(tt) & tt < umbral, j] <- NA }
  Bm }
B10 <- version_b("NT10"); stopifnot(identical(is.na(B10), is.na(R$b)))          # reproduce la versión (b) de D-27
B15 <- version_b("NT15"); B5 <- version_b("s5")
OMIS <- c(NT10 = sum(!is.na(R$a) & is.na(B10)), NT15 = sum(!is.na(R$a) & is.na(B15)), s5 = sum(!is.na(R$a) & is.na(B5)))
reloj("Omisiones rápidas: NT10", OMIS[["NT10"]], "| NT15", OMIS[["NT15"]], "| 5 s", OMIS[["s5"]])

# --- Covariables y regresión latente fijas (como 05_h4_h7.R, líneas 46-56)
cov <- data.table(eco = tri$eap_AFE_ECO[kr], libros = tri$eap_AFE_CUL[kr], sexo = nse$sexo[kr],
                  grade = factor(as.numeric(cue$GRADE[match(R$CNTSTUID, cue$CNTSTUID)]), levels = c(0, -3, -2, -1, 1)),
                  zona = factor(fcase(is.na(nse$zona[kr]), "sin dato", nse$zona[kr] == "Urbana (>15 mil)", "urbana",
                                      nse$zona[kr] == "Pueblo (3-15 mil)", "pueblo", default = "rural"), levels = c("urbana", "pueblo", "rural", "sin dato")),
                  sector = factor(fcase(is.na(nse$sector[kr]), "sin dato", nse$sector[kr] == "Público", "público", default = "privado"),
                                  levels = c("público", "privado", "sin dato")))
XL <- model.matrix(~ eco + libros + sexo + grade + zona + sector + eco:zona + eco:sector, data = cov)
Wr <- nse$W_FSTUWT[kr]
stopifnot(identical(st$huella, huella(as.list(as.data.frame(R$a)), XL, Wr * N / sum(Wr), coef(m4, simplify = TRUE)$items, "D-39")))
MU <- XL %*% st$Gamma; SINV <- solve(st$Sigma)
set.seed(2026); Z <- array(NA_real_, c(N, 10, K))
for (i in seq_len(N)) Z[i, , ] <- matrix(rnorm(10 * K), 10, K)      # mismos números que 05_puntajes_rl.R y 05_h4_h7.R
posterior_pv <- function(Ym) { E <- e1_motor(m4, Ym, R$tipo); pv <- array(NA_real_, c(N, 10, K)); ok <- logical(N)
  for (i in seq_len(N)) { md <- E$moda(i, MU[i, ], SINV, st$inicio[i, ]); r <- E$e1(i, md, "5", MU[i, ], SINV)
    pv[i, , ] <- Z[i, , ] %*% chol(r$cov) + rep(r$eap, each = 10); ok[i] <- md$ok }
  stopifnot(all(ok)); pv }
CACHE <- file.path(DATOS, "COL_f7_h4_pv.rds")
H <- huella(B10, B15, B5, st$Gamma, st$Sigma, "D-45")
pvs <- if (file.exists(CACHE)) readRDS(CACHE) else NULL
if (is.null(pvs) || !identical(pvs$huella, H)) {
  pvs <- list(huella = H)
  for (v in c("NT10", "NT15", "s5")) { reloj("Posterior (b)", v); pvs[[v]] <- posterior_pv(switch(v, NT10 = B10, NT15 = B15, s5 = B5)) }
  saveRDS(pvs, CACHE)
}
Pa <- unclass(pun$pv)

cuartil_w <- function(x, w) { o <- order(x); cw <- cumsum(w[o]) / sum(w[o]); q <- integer(length(x)); q[o] <- pmin(4L, 1L + floor(4 * cw - 1e-9)); q }
brecha <- function(y, ya, ww, qq) { m <- function(g) sum(ww[qq == g] * y[qq == g]) / sum(ww[qq == g])
  mu <- sum(ww * ya) / sum(ww); s <- sqrt(sum(ww * (ya - mu)^2) / sum(ww)); (m(4) - m(1)) / s }
rubin <- function(est_rep) { est <- est_rep[1, ]; vm <- apply(est_rep, 2, function(t) 0.05 * sum((t[-1] - t[1])^2))
  c(est = mean(est), ee = sqrt(mean(vm) + 1.1 * var(est))) }
h4_dec <- function(q, sub, WR, Pb) {
  s <- which(sub); WRs <- WR[kr, ][s, ]; qs <- q[s]
  r <- rbindlist(lapply(seq_len(K), function(j) {
    x <- rubin(sapply(1:10, function(m) apply(WRs, 2, function(ww)
      brecha(Pa[s, m, j], Pa[s, m, j], ww, qs) - brecha(Pb[s, m, j], Pa[s, m, j], ww, qs))))
    data.table(competencia = COMP[j], reduccion = x[["est"]], ee = x[["ee"]]) }))
  r[, p := 2 * pnorm(-abs(reduccion / ee))][, p_Holm := p.adjust(p, "holm")]
  r[, `:=`(cumple = reduccion >= 0.05 & p_Holm < 0.05, cumple_sin_corr = reduccion >= 0.05 & p < 0.05)]
  r }
q_eco  <- cuartil_w(tri$eap_AFE_ECO[kr], Wr)
q_escs <- cuartil_w(nse$ESCS[kr], Wr)
q_d38  <- cuartil_w(tri$eap_AFE_ECO[kr], WR38[kr, 1])
TR <- rep(TRUE, N)
H4 <- list(base = h4_dec(q_eco, TR, WR0, pvs$NT10), S_A = h4_dec(q_escs, TR, WR0, pvs$NT10),
           S_B = h4_dec(q_eco, NOLIN[kr], WR0, pvs$NT10), NT15 = h4_dec(q_eco, TR, WR0, pvs$NT15),
           s5 = h4_dec(q_eco, TR, WR0, pvs$s5), S_E = h4_dec(q_d38, TR, WR38, pvs$NT10))
reloj("H4 bajo las sensibilidades: listo")
hb <- fread(file.path(SALIDAS, "mat_h4_brechas.csv"))
stopifnot(max(abs(H4$base$reduccion - hb$reduccion_b)) < 1e-4)                 # la base reproduce D-41
h4_txt <- function(r, sin_corr = FALSE) paste(sprintf("%s %.4f (p%s = %.2g)", r$competencia, r$reduccion,
  if (sin_corr) "" else " Holm", if (sin_corr) r$p else r$p_Holm), collapse = "; ")
for (s in c("S_A", "S_B", "S_E")) det[[length(det) + 1]] <- fila("K4", s, !any(H4[[s]]$cumple), h4_txt(H4[[s]]))
det[[length(det) + 1]] <- fila("K4", "S_C", !any(H4$NT15$cumple) && !any(H4$s5$cumple),
  sprintf("NT15 (%d omisiones rápidas): %s | 5 s (%d): %s", OMIS[["NT15"]], h4_txt(H4$NT15), OMIS[["s5"]], h4_txt(H4$s5)))
det[[length(det) + 1]] <- fila("K4", "S_D", !any(H4$base$cumple_sin_corr), h4_txt(H4$base, sin_corr = TRUE))
base_txt$K4 <- h4_txt(H4$base)

# =============================================================================
# 3. K5: H3 (05_dif_matematicas.R con F7_VARIANTE; S-D aquí)
# =============================================================================
h3_dec <- function(dif_flag, comp) { g <- fcase(comp %in% c("interpretar", "formular"), "if", comp == "emplear", "em")
  tf <- table(factor(g[!is.na(g)], c("if", "em")), factor(dif_flag[!is.na(g)], c(TRUE, FALSE)))
  c(parte1 = sum(dif_flag) >= 1, parte2 = sum(dif_flag) >= 1 && fisher.test(tf, alternative = "greater")$p.value < 0.05,
    n_dif = sum(dif_flag)) }
md <- fread(file.path(SALIDAS, "mat_dif.csv"))
b3 <- h3_dec(md$DIF, md$competencia); stopifnot(b3[["parte1"]] == 1, b3[["parte2"]] == 0)
sd3 <- h3_dec(md$p < 0.05 & md$no_despreciable, md$competencia)
det[[length(det) + 1]] <- fila("K5", "S_D", sd3[["parte1"]] == 1 && sd3[["parte2"]] == 0,
  sprintf("sin BH: %d de %d ítems con DIF (%s)", sd3[["n_dif"]], nrow(md),
          paste(md[p < 0.05 & no_despreciable == TRUE, paste(item, competencia)], collapse = ", ")))
VAR_DIF <- c(S_A = "escs", S_B = "sin_lineal", S_E = "d38")
for (nm in names(VAR_DIF)) {
  s <- VAR_DIF[[nm]]; fh <- file.path(SALIDAS, paste0("f7_h3_", s, ".csv")); fd <- file.path(SALIDAS, paste0("f7_dif_", s, ".csv"))
  if (!file.exists(fh)) { det[[length(det) + 1]] <- fila("K5", nm, NA, paste0("pendiente: falta salidas/f7_h3_", s, ".csv")); next }
  h <- fread(fh); dv <- fread(fd)
  det[[length(det) + 1]] <- fila("K5", nm, h$se_acepta[1] && !h$se_acepta[2],
    sprintf("%s | %s | ítems con DIF: %s", h$dato[1], h$dato[2], paste(dv[DIF == TRUE, item], collapse = ", "))) }
base_txt$K5 <- sprintf("%d de %d ítems con DIF (%s)", sum(md$DIF), nrow(md), paste(md[DIF == TRUE, item], collapse = ", "))

# =============================================================================
# 4. ROBUSTEZ (regla del 75 %, mínimo 3; D-45 punto 3)
# =============================================================================
detalle <- rbindlist(det)
CONCL <- c(K1 = "igualdad rechazada y H5 con su regla (completa y mitad)", K2 = "NSE x sector significativa (H6)",
           K3 = "NSE > 0 y significativo en las 4 competencias", K4 = "H4 se rechaza (nulo)",
           K5 = "H3: primera parte sí, segunda no")
base <- data.table(candidato = names(CONCL), sensibilidad = "base (análisis principal)", se_mantiene = TRUE, detalle = unlist(base_txt[names(CONCL)]))
detalle <- rbind(base, detalle)
detalle <- detalle[order(candidato, match(sensibilidad, c("base (análisis principal)", unname(SENS))))]
fwrite(detalle, file.path(SALIDAS, "f7_sensibilidad_detalle.csv"))
rob <- detalle[sensibilidad != "base (análisis principal)", .(aplicables = .N, evaluadas = sum(!is.na(se_mantiene)),
               se_mantiene_en = sum(se_mantiene, na.rm = TRUE)), by = candidato]
rob[, requerido := pmax(3L, as.integer(ceiling(0.75 * aplicables)))]
rob[, robusto := fifelse(evaluadas < aplicables, fifelse(se_mantiene_en >= requerido, "sí (faltan variantes)", "pendiente"),
                         fifelse(se_mantiene_en >= requerido, "sí", "no"))]
rob[, conclusion := CONCL[candidato]]; setcolorder(rob, c("candidato", "conclusion"))
fwrite(rob, file.path(SALIDAS, "f7_robustez.csv"))

cat("\n--- 7.1 Detalle (salidas/f7_sensibilidad_detalle.csv) ---\n"); print(detalle[, .(candidato, sensibilidad, se_mantiene)])
for (i in seq_len(nrow(detalle))) cat(detalle$candidato[i], "|", detalle$sensibilidad[i], "|", detalle$detalle[i], "\n")
cat("\n--- 7.1 Robustez (salidas/f7_robustez.csv) ---\n"); print(rob)
