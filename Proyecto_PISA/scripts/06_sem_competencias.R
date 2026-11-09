# =============================================================================
# 06 MODELO ESTRUCTURAL POR COMPETENCIA - F6, O4, H5 y H6 (D-32, D-34 y D-42)
#
# Qué hace:
#   1. Principal (D-42 punto 1): para cada competencia y cada VP de la OCDE, regresión lineal ponderada sobre las EAP del
#      NSE de la G2 (económico y libros), el sexo y el grado categórico. Se estima con el peso final y las 80 réplicas
#      BRR (Fay 0,5: 0,05 · suma de cuadrados) y se combina con Rubin (utilidades_pisa.R).
#   2. Igualdad del efecto del NSE económico entre competencias (6.4): Wald conjunta, 3 gl.
#   3. H5 (exploratoria, D-32): diferencia interpretar - emplear del coeficiente del NSE económico, en la muestra completa
#      y en la mitad de confirmación.
#   4. H6 (6.5): modelo con zona, sector y NSE económico x zona y x sector (sin los que no tienen dato); Wald conjunta por
#      variable en las 4 competencias (zona 8 gl, sector 4 gl) y Holm sobre las 2.
#      Las Wald usan la covarianza total de Rubin, T = media de las covarianzas BRR + (1 + 1/10) · covarianza entre VP,
#      y una χ² con q gl (aproximación declarada en D-42).
#   5. Robustez (D-42 punto 4): SEM con el NSE latente (estructura del AFE, WLSMV, 29 indicadores ordinales) que predice
#      las 4 competencias, solo con el peso final, por cada VP; caché en datos/COL_sem_latente.rds. Para no correrlo:
#      $env:SIN_SEM = "1".
#
# Entradas: datos/COL_nse.rds, COL_nse_tri.rds, COL_cuestionario.rds y salidas/nse_estructura_afe.csv.
# Salidas (solo agregados): salidas/sem_coeficientes.csv, sem_igualdad.csv, sem_h5.csv, sem_h6.csv y
#   sem_robustez_latente.csv.
#
# Cómo correrlo (desde Proyecto_PISA/scripts/):
#   & "C:\Program Files\R\R-4.4.1\bin\Rscript.exe" 06_sem_competencias.R
# =============================================================================

options(stringsAsFactors = FALSE, scipen = 999, width = 160)
suppressPackageStartupMessages(library(data.table))

carpeta_script <- function() {
  arg <- grep("^--file=", commandArgs(FALSE), value = TRUE)
  if (length(arg)) return(dirname(normalizePath(sub("^--file=", "", arg))))
  if (!is.null(sys.frames()[[1]]$ofile)) return(dirname(normalizePath(sys.frames()[[1]]$ofile)))
  getwd()
}
DIR     <- carpeta_script()
DATOS   <- normalizePath(file.path(DIR, "..", "datos"))
SALIDAS <- normalizePath(file.path(DIR, "..", "salidas"))
source(file.path(DIR, "utilidades_pisa.R"))                        # REPS, huella()
reloj <- function(...) { cat(format(Sys.time(), "%H:%M:%S"), "|", ..., "\n"); flush.console() }

nse <- readRDS(file.path(DATOS, "COL_nse.rds")); tri <- readRDS(file.path(DATOS, "COL_nse_tri.rds"))
cue <- readRDS(file.path(DATOS, "COL_cuestionario.rds"))
stopifnot(nrow(nse) == 6886, identical(nse$CNTSTUID, tri$CNTSTUID))
cq <- cue[match(nse$CNTSTUID, CNTSTUID)]
OCDE <- c(emplear = "MPEM", formular = "MPFS", interpretar = "MPIN", razonar = "MPRE"); COMP <- names(OCDE)
PVN  <- unlist(lapply(OCDE, function(o) paste0("PV", 1:10, o)))
WR   <- as.matrix(cbind(W_FSTUWT = nse$W_FSTUWT, cq[, ..REPS]))
stopifnot(!anyNA(WR), !anyNA(cq[, ..PVN]))

d <- data.table(eco = tri$eap_AFE_ECO, libros = tri$eap_AFE_CUL, sexo = nse$sexo, mitad = nse$mitad,
                grado = factor(as.numeric(cq$GRADE), levels = c(0, -3, -2, -1, 1)),
                zona = factor(fcase(nse$zona == "Urbana (>15 mil)", "urbana", nse$zona == "Pueblo (3-15 mil)", "pueblo",
                                    nse$zona == "Rural (<3.000)", "rural"), levels = c("urbana", "pueblo", "rural")),
                sector = factor(fcase(nse$sector == "Público", "público", nse$sector == "Privado", "privado"), levels = c("público", "privado")))
stopifnot(!anyNA(d[, .(eco, libros, sexo, grado)]))
Y <- as.matrix(cq[, ..PVN])                                         # 6.886 x 40 (competencia x VP)

# --- WLS con los 81 pesos a la vez: B[peso, coeficiente, columna de Y]
wls81 <- function(X, Y, WR) {
  B <- array(NA_real_, c(ncol(WR), ncol(X), ncol(Y)), dimnames = list(colnames(WR), colnames(X), colnames(Y)))
  for (r in seq_len(ncol(WR))) { w <- WR[, r]; B[r, , ] <- solve(crossprod(X, X * w), crossprod(X, Y * w)) }
  B }
col_pv <- function(comp, m) paste0("PV", m, OCDE[[comp]])
# theta(B, m) devuelve, para el VP m, el vector de cantidades de interés en cada uno de los 81 pesos (81 x q)
rubin_vec <- function(B, theta) {
  est <- lapply(1:10, function(m) theta(B, m)); q <- ncol(est[[1]])
  th <- t(vapply(est, function(e) e[1, ], numeric(q)))              # 10 x q (peso final)
  U <- Reduce(`+`, lapply(est, function(e) { dv <- sweep(e[-1, , drop = FALSE], 2, e[1, ]); 0.05 * crossprod(dv) })) / 10
  Bv <- if (q == 1) matrix(var(th[, 1])) else cov(th)
  list(est = colMeans(th), V = U + 1.1 * Bv) }
wald <- function(r) { s <- drop(t(r$est) %*% solve(r$V, r$est)); c(chi2 = s, gl = length(r$est), p = pchisq(s, length(r$est), lower.tail = FALSE)) }

# =============================================================================
# 1. MODELO PRINCIPAL (muestra completa)
# =============================================================================
X <- model.matrix(~ eco + libros + sexo + grado, data = d)
B <- wls81(X, Y, WR); reloj("Modelo principal estimado (81 pesos x 40 VP)")
sd_w <- function(x, w) { m <- sum(w * x) / sum(w); sqrt(sum(w * (x - m)^2) / sum(w)) }
DE <- c(eco = sd_w(d$eco, nse$W_FSTUWT), libros = sd_w(d$libros, nse$W_FSTUWT))
coefs <- rbindlist(lapply(COMP, function(cp) rbindlist(lapply(colnames(X), function(v) {
  r <- rubin_vec(B, function(B, m) matrix(B[, v, col_pv(cp, m)], ncol = 1))
  ee <- sqrt(r$V[1, 1]); de <- if (v %in% names(DE)) DE[[v]] else NA_real_
  data.table(competencia = cp, coeficiente = v, estimacion = round(r$est, 2), ee_BRR = round(ee, 2),
             ic95_inf = round(r$est - 1.96 * ee, 2), ic95_sup = round(r$est + 1.96 * ee, 2), p = signif(2 * pnorm(-abs(r$est / ee)), 3),
             por_DE_de_la_EAP = round(r$est * de, 2)) }))))
r2 <- vapply(COMP, function(cp) mean(vapply(1:10, function(m) { y <- Y[, col_pv(cp, m)]; w <- nse$W_FSTUWT
  f <- drop(X %*% B[1, , col_pv(cp, m)]); 1 - sum(w * (y - f)^2) / sum(w * (y - sum(w * y) / sum(w))^2) }, 0)), 0)
coefs[, R2_medio := round(r2[competencia], 3)]
fwrite(coefs, file.path(SALIDAS, "sem_coeficientes.csv"))

# =============================================================================
# 2. IGUALDAD DEL EFECTO DEL NSE ECONÓMICO ENTRE COMPETENCIAS (6.4) Y H5
# =============================================================================
dif_eco <- function(B, m, a, b) B[, "eco", col_pv(a, m)] - B[, "eco", col_pv(b, m)]
ig <- wald(rubin_vec(B, function(B, m) cbind(dif_eco(B, m, "formular", "emplear"), dif_eco(B, m, "interpretar", "emplear"),
                                              dif_eco(B, m, "razonar", "emplear"))))
igualdad <- data.table(prueba = "coeficiente del NSE económico igual en las 4 competencias", chi2 = round(ig[["chi2"]], 2),
                       gl = ig[["gl"]], p = signif(ig[["p"]], 3))
fwrite(igualdad, file.path(SALIDAS, "sem_igualdad.csv"))

h5_fila <- function(B, muestra) { r <- rubin_vec(B, function(B, m) matrix(dif_eco(B, m, "interpretar", "emplear"), ncol = 1))
  ee <- sqrt(r$V[1, 1]); p <- 2 * pnorm(-abs(r$est / ee))
  data.table(muestra = muestra, diferencia_interpretar_menos_emplear = round(r$est, 2), ee_BRR = round(ee, 2),
             ic95_inf = round(r$est - 1.96 * ee, 2), ic95_sup = round(r$est + 1.96 * ee, 2), p = signif(p, 3),
             cumple_regla = r$est > 0 && p < 0.05) }
conf <- d$mitad == "confirmacion"
Bc <- wls81(X[conf, ], Y[conf, ], WR[conf, ])
h5 <- rbind(h5_fila(B, "completa (6.886)"), h5_fila(Bc, sprintf("mitad de confirmación (%d)", sum(conf))))
h5[, H5 := if (all(cumple_regla)) "se cumple la regla (exploratoria, D-32)" else "no se cumple la regla (exploratoria, D-32)"]
fwrite(h5, file.path(SALIDAS, "sem_h5.csv"))

# =============================================================================
# 3. H6: INTERACCIONES NSE x ZONA Y NSE x SECTOR (D-42 punto 3)
# =============================================================================
ok6 <- !is.na(d$zona) & !is.na(d$sector)
X6 <- model.matrix(~ eco + libros + sexo + grado + zona + sector + eco:zona + eco:sector, data = d[ok6])
B6 <- wls81(X6, Y[ok6, ], WR[ok6, ])
INT_ZONA <- c("eco:zonapueblo", "eco:zonarural"); INT_SECT <- "eco:sectorprivado"
stopifnot(all(c(INT_ZONA, INT_SECT) %in% colnames(X6)))
th_int <- function(vars) function(B, m) do.call(cbind, lapply(COMP, function(cp) B[, vars, col_pv(cp, m), drop = FALSE][, , 1]))
wz <- wald(rubin_vec(B6, th_int(INT_ZONA))); ws <- wald(rubin_vec(B6, th_int(INT_SECT)))
h6 <- data.table(variable = c("zona (NSE x pueblo y NSE x rural)", "sector (NSE x privado)"), chi2 = round(c(wz[["chi2"]], ws[["chi2"]]), 2),
                 gl = c(wz[["gl"]], ws[["gl"]]), p = c(wz[["p"]], ws[["p"]]), n = sum(ok6))
h6[, p_Holm := p.adjust(p, "holm")]
h6[, H6 := if (any(p_Holm < 0.05)) "se acepta" else "se rechaza"]
h6[, `:=`(p = signif(p, 3), p_Holm = signif(p_Holm, 3))]
int_tab <- rbindlist(lapply(COMP, function(cp) rbindlist(lapply(c(INT_ZONA, INT_SECT), function(v) {
  r <- rubin_vec(B6, function(B, m) matrix(B[, v, col_pv(cp, m)], ncol = 1)); ee <- sqrt(r$V[1, 1])
  data.table(competencia = cp, interaccion = v, estimacion = round(r$est, 2), ee_BRR = round(ee, 2)) }))))
fwrite(h6, file.path(SALIDAS, "sem_h6.csv"))
fwrite(int_tab, file.path(SALIDAS, "sem_h6_interacciones.csv"))

# =============================================================================
# 4. ROBUSTEZ: SEM CON NSE LATENTE (peso final, por VP; D-42 punto 4)
# =============================================================================
if (Sys.getenv("SIN_SEM") != "1") {
  suppressPackageStartupMessages(library(lavaan))
  fac <- attr(nse, "factores"); IND <- c(fac$economico, fac$cultural)
  est_afe <- fread(file.path(SALIDAS, "nse_estructura_afe.csv"), encoding = "UTF-8")
  CUL <- est_afe[factor_AFE == "cultural", item]; ECO <- setdiff(IND, CUL)
  ds <- cbind(as.data.frame(nse[, ..IND]), as.data.frame(model.matrix(~ sexo + grado, data = d)[, -1]))
  covs <- setdiff(names(ds), IND); names(ds)[match(covs, names(ds))] <- make.names(covs); covs <- make.names(covs)
  ds$w_norm <- nse$W_FSTUWT * nrow(nse) / sum(nse$W_FSTUWT)
  modelo <- paste0("ECO =~ ", paste(ECO, collapse = " + "), "\nCUL =~ ", paste(CUL, collapse = " + "), "\n",
                   paste0(paste0("y_", COMP), " ~ ECO + CUL + ", paste(covs, collapse = " + "), collapse = "\n"))
  CACHE <- file.path(DATOS, "COL_sem_latente.rds")
  H <- huella(ds, as.data.frame(Y), modelo, "D-42")
  res <- if (file.exists(CACHE)) readRDS(CACHE) else NULL
  if (is.null(res) || !identical(res$huella, H)) {
    res <- list(huella = H, est = list())
    for (m in 1:10) {
      for (cp in COMP) ds[[paste0("y_", cp)]] <- Y[, col_pv(cp, m)] / 100   # en centenas de puntos, por la escala de WLSMV
      reloj("SEM latente, VP", m)
      f <- sem(modelo, data = ds, ordered = IND, estimator = "WLSMV", std.lv = TRUE, sampling.weights = "w_norm",
               missing = "pairwise", se = "none", test = "none")
      pe <- parameterEstimates(f, se = FALSE)
      res$est[[m]] <- data.table(pe[pe$op == "~" & pe$rhs %in% c("ECO", "CUL"), c("lhs", "rhs", "est")])[, convergio := lavInspect(f, "converged")]
      saveRDS(res, CACHE)
    }
  }
  lat <- rbindlist(res$est, idcol = "vp")[, .(coef_latente_por_DE = round(100 * mean(est), 2), convergieron = sum(convergio)), by = .(lhs, rhs)]
  lat[, `:=`(competencia = sub("^y_", "", lhs), coeficiente = fifelse(rhs == "ECO", "eco", "libros"))]
  rob <- merge(lat[, .(competencia, coeficiente, coef_latente_por_DE, convergieron)],
               coefs[coeficiente %in% c("eco", "libros"), .(competencia, coeficiente, dos_pasos_por_DE_de_la_EAP = por_DE_de_la_EAP)],
               by = c("competencia", "coeficiente"))
  rob[, razon_dos_pasos_sobre_latente := round(dos_pasos_por_DE_de_la_EAP / coef_latente_por_DE, 3)]
  fwrite(rob, file.path(SALIDAS, "sem_robustez_latente.csv"))
  cat("\n--- Robustez: SEM latente frente a dos pasos (salidas/sem_robustez_latente.csv) ---\n"); print(rob)
}

cat("\n--- Coeficientes del NSE (salidas/sem_coeficientes.csv) ---\n"); print(coefs[coeficiente %in% c("eco", "libros")])
cat("\n--- Igualdad entre competencias (salidas/sem_igualdad.csv) ---\n"); print(igualdad)
cat("\n--- H5, exploratoria (salidas/sem_h5.csv) ---\n"); print(h5)
cat("\n--- H6 (salidas/sem_h6.csv) ---\n"); print(h6); print(int_tab)
