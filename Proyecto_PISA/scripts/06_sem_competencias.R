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
#   6. Robustez con los puntajes propios (D-44 puntos 1 a 3): los puntos 1 a 4 con los 10 VP propios de 05_puntajes_rl.R
#      en lugar de los de la OCDE, coeficiente estandarizado del NSE y tabla de concordancia entre las dos fuentes.
#   7. Ajuste del SEM latente con el VP1 de la OCDE (D-44 punto 4; caché en datos/COL_sem_ajuste.rds; también lo salta
#      SIN_SEM) y diagrama del modelo (D-44 punto 5).
#
# Entradas: datos/COL_nse.rds, COL_nse_tri.rds, COL_cuestionario.rds, COL_puntajes_competencia.rds y
#   salidas/nse_estructura_afe.csv.
# Salidas (solo agregados): salidas/sem_coeficientes.csv, sem_igualdad.csv, sem_h5.csv, sem_h6.csv,
#   sem_h6_interacciones.csv, sem_robustez_latente.csv, sem_propios_coeficientes.csv, sem_propios_igualdad.csv,
#   sem_propios_h5.csv, sem_propios_h6.csv, sem_comparacion_fuentes.csv, sem_ajuste_latente.csv y sem_diagrama.png.
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
col_pv <- function(comp, m) paste0("PV", m, OCDE[[comp]])

# --- VP propios (D-39) con los mismos nombres de columna que los de la OCDE (D-44 punto 1)
pun <- readRDS(file.path(DATOS, "COL_puntajes_competencia.rds"))
stopifnot(isTRUE(pun$valido), identical(dim(pun$pv)[2:3], c(10L, 4L)))
kp <- match(nse$CNTSTUID, pun$CNTSTUID); stopifnot(!anyNA(kp))
Yp <- Y; Yp[] <- NA_real_
for (j in seq_along(COMP)) for (m in 1:10) Yp[, col_pv(COMP[j], m)] <- pun$pv[kp, m, j]
stopifnot(!anyNA(Yp))

# wls81(), rubin_vec() y wald() están en utilidades_pisa.R (las usa también 07_sensibilidad.R)

# =============================================================================
# 1 A 3. COEFICIENTES (1), IGUALDAD Y H5 (2), H6 (3) - D-42 puntos 1 a 3
#   La función se aplica a los VP de la OCDE (principal) y a los propios (robustez, D-44). dig = decimales de las
#   salidas: los VP propios están en DE latentes, no en puntos PISA, y con 2 decimales se perdería precisión.
# =============================================================================
X <- model.matrix(~ eco + libros + sexo + grado, data = d)
sd_w <- function(x, w) { m <- sum(w * x) / sum(w); sqrt(sum(w * (x - m)^2) / sum(w)) }
DE <- c(eco = sd_w(d$eco, nse$W_FSTUWT), libros = sd_w(d$libros, nse$W_FSTUWT))
dif_eco <- function(B, m, a, b) B[, "eco", col_pv(a, m)] - B[, "eco", col_pv(b, m)]
conf <- d$mitad == "confirmacion"
ok6 <- !is.na(d$zona) & !is.na(d$sector)
X6 <- model.matrix(~ eco + libros + sexo + grado + zona + sector + eco:zona + eco:sector, data = d[ok6])
INT_ZONA <- c("eco:zonapueblo", "eco:zonarural"); INT_SECT <- "eco:sectorprivado"
stopifnot(all(c(INT_ZONA, INT_SECT) %in% colnames(X6)))

analizar_f6 <- function(Y, fuente, dig = 2) {
  # --- 1. Modelo principal (muestra completa)
  B <- wls81(X, Y, WR); reloj("Modelo principal estimado (81 pesos x 40 VP):", fuente)
  coefs <- rbindlist(lapply(COMP, function(cp) rbindlist(lapply(colnames(X), function(v) {
    r <- rubin_vec(B, function(B, m) matrix(B[, v, col_pv(cp, m)], ncol = 1))
    ee <- sqrt(r$V[1, 1]); de <- if (v %in% names(DE)) DE[[v]] else NA_real_
    data.table(competencia = cp, coeficiente = v, estimacion = round(r$est, dig), ee_BRR = round(ee, dig),
               ic95_inf = round(r$est - 1.96 * ee, dig), ic95_sup = round(r$est + 1.96 * ee, dig), p = formatC(2 * pnorm(-abs(r$est / ee)), format = "e", digits = 2),
               por_DE_de_la_EAP = round(r$est * de, dig)) }))))
  r2 <- vapply(COMP, function(cp) mean(vapply(1:10, function(m) { y <- Y[, col_pv(cp, m)]; w <- nse$W_FSTUWT
    f <- drop(X %*% B[1, , col_pv(cp, m)]); 1 - sum(w * (y - f)^2) / sum(w * (y - sum(w * y) / sum(w))^2) }, 0)), 0)
  coefs[, R2_medio := round(r2[competencia], 3)]
  # NSE económico sin redondear y DE ponderada de cada competencia, para el coeficiente estandarizado (D-44 punto 2)
  eco <- rbindlist(lapply(COMP, function(cp) { r <- rubin_vec(B, function(B, m) matrix(B[, "eco", col_pv(cp, m)], ncol = 1))
    data.table(competencia = cp, est = r$est, p = 2 * pnorm(-abs(r$est / sqrt(r$V[1, 1]))), R2 = r2[[cp]],
               sd_y = mean(vapply(1:10, function(m) sd_w(Y[, col_pv(cp, m)], nse$W_FSTUWT), 0))) }))
  eco[, estandarizado := est * DE[["eco"]] / sd_y]

  # --- 2. Igualdad del efecto del NSE económico entre competencias (6.4) y H5
  ig <- wald(rubin_vec(B, function(B, m) cbind(dif_eco(B, m, "formular", "emplear"), dif_eco(B, m, "interpretar", "emplear"),
                                                dif_eco(B, m, "razonar", "emplear"))))
  igualdad <- data.table(prueba = "coeficiente del NSE económico igual en las 4 competencias", chi2 = round(ig[["chi2"]], 2),
                         gl = ig[["gl"]], p = formatC(ig[["p"]], format = "e", digits = 2))
  h5_fila <- function(B, muestra) { r <- rubin_vec(B, function(B, m) matrix(dif_eco(B, m, "interpretar", "emplear"), ncol = 1))
    ee <- sqrt(r$V[1, 1]); p <- 2 * pnorm(-abs(r$est / ee))
    data.table(muestra = muestra, diferencia_interpretar_menos_emplear = round(r$est, dig), ee_BRR = round(ee, dig),
               ic95_inf = round(r$est - 1.96 * ee, dig), ic95_sup = round(r$est + 1.96 * ee, dig), p = signif(p, 3),
               cumple_regla = r$est > 0 && p < 0.05) }
  Bc <- wls81(X[conf, ], Y[conf, ], WR[conf, ])
  h5 <- rbind(h5_fila(B, "completa (6.886)"), h5_fila(Bc, sprintf("mitad de confirmación (%d)", sum(conf))))
  h5[, H5 := if (all(cumple_regla)) "se cumple la regla (exploratoria, D-32)" else "no se cumple la regla (exploratoria, D-32)"]

  # --- 3. H6: interacciones NSE x zona y NSE x sector (D-42 punto 3)
  B6 <- wls81(X6, Y[ok6, ], WR[ok6, ])
  th_int <- function(vars) function(B, m) do.call(cbind, lapply(COMP, function(cp) B[, vars, col_pv(cp, m), drop = FALSE][, , 1]))
  wz <- wald(rubin_vec(B6, th_int(INT_ZONA))); ws <- wald(rubin_vec(B6, th_int(INT_SECT)))
  h6 <- data.table(variable = c("zona (NSE x pueblo y NSE x rural)", "sector (NSE x privado)"), chi2 = round(c(wz[["chi2"]], ws[["chi2"]]), 2),
                   gl = c(wz[["gl"]], ws[["gl"]]), p = c(wz[["p"]], ws[["p"]]), n = sum(ok6))
  h6[, p_Holm := p.adjust(p, "holm")]
  h6[, H6 := if (any(p_Holm < 0.05)) "se acepta" else "se rechaza"]
  p6 <- h6$p_Holm
  h6[, `:=`(p = signif(p, 3), p_Holm = signif(p_Holm, 3))]
  int_tab <- rbindlist(lapply(COMP, function(cp) rbindlist(lapply(c(INT_ZONA, INT_SECT), function(v) {
    r <- rubin_vec(B6, function(B, m) matrix(B[, v, col_pv(cp, m)], ncol = 1)); ee <- sqrt(r$V[1, 1])
    data.table(competencia = cp, interaccion = v, estimacion = round(r$est, dig), ee_BRR = round(ee, dig)) }))))
  list(coefs = coefs, eco = eco, igualdad = igualdad, ig = ig, h5 = h5, h6 = h6, p6 = p6, int_tab = int_tab)
}

o <- analizar_f6(Y, "VP de la OCDE")
coefs <- o$coefs; igualdad <- o$igualdad; h5 <- o$h5; h6 <- o$h6; int_tab <- o$int_tab
fwrite(coefs, file.path(SALIDAS, "sem_coeficientes.csv"))
fwrite(igualdad, file.path(SALIDAS, "sem_igualdad.csv"))
fwrite(h5, file.path(SALIDAS, "sem_h5.csv"))
fwrite(h6, file.path(SALIDAS, "sem_h6.csv"))
fwrite(int_tab, file.path(SALIDAS, "sem_h6_interacciones.csv"))

# =============================================================================
# 6. ROBUSTEZ CON LOS PUNTAJES PROPIOS Y CONCORDANCIA ENTRE FUENTES (D-44 puntos 1 a 3)
# =============================================================================
op <- analizar_f6(Yp, "VP propios", dig = 4)
fwrite(op$coefs, file.path(SALIDAS, "sem_propios_coeficientes.csv"))
fwrite(op$igualdad, file.path(SALIDAS, "sem_propios_igualdad.csv"))
fwrite(op$h5, file.path(SALIDAS, "sem_propios_h5.csv"))
fwrite(op$h6, file.path(SALIDAS, "sem_propios_h6.csv"))
fwrite(op$int_tab, file.path(SALIDAS, "sem_propios_h6_interacciones.csv"))

# Concordancia (D-44 punto 3): mismo signo (si aplica) y misma decisión con alfa = 0,05
fmt_p <- function(p) if (is.na(p)) NA_character_ else formatC(p, format = "e", digits = 2)
fila <- function(prueba, unidad, eo, po, ep, pp, signo = TRUE) data.table(prueba = prueba, unidad = unidad,
  ocde_estimacion = eo, ocde_p = fmt_p(po), propios_estimacion = ep, propios_p = fmt_p(pp),
  coincide = if (is.na(po)) NA else (!signo || sign(eo) == sign(ep)) && ((po < 0.05) == (pp < 0.05)))
comparacion <- rbind(
  rbindlist(lapply(COMP, function(cp) fila(paste("NSE económico,", cp), "coeficiente estandarizado",
    round(o$eco[competencia == cp, estandarizado], 3), o$eco[competencia == cp, p],
    round(op$eco[competencia == cp, estandarizado], 3), op$eco[competencia == cp, p]))),
  rbindlist(lapply(COMP, function(cp) fila(paste("R² medio,", cp), "proporción de varianza",
    round(o$eco[competencia == cp, R2], 3), NA_real_, round(op$eco[competencia == cp, R2], 3), NA_real_))),
  fila("Igualdad del NSE económico entre competencias (6.4)", "chi2 de Wald, 3 gl",
       round(o$ig[["chi2"]], 2), o$ig[["p"]], round(op$ig[["chi2"]], 2), op$ig[["p"]], signo = FALSE),
  rbindlist(lapply(1:2, function(i) fila(paste("H5, interpretar - emplear,", o$h5$muestra[i]), "puntos PISA (OCDE) / DE latentes (propios)",
    o$h5$diferencia_interpretar_menos_emplear[i], o$h5$p[i], op$h5$diferencia_interpretar_menos_emplear[i], op$h5$p[i]))),
  rbindlist(lapply(1:2, function(i) fila(paste("H6,", o$h6$variable[i]), "chi2 de Wald; p con Holm",
    o$h6$chi2[i], o$p6[i], op$h6$chi2[i], op$p6[i], signo = FALSE))))
fwrite(comparacion, file.path(SALIDAS, "sem_comparacion_fuentes.csv"))

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

  # --- 7. Ajuste del SEM latente con el VP1 de la OCDE y el peso final (D-44 punto 4; descriptivo)
  CACHE_AJ <- file.path(DATOS, "COL_sem_ajuste.rds")
  Ha <- huella(ds[, setdiff(names(ds), paste0("y_", COMP))], as.data.frame(Y[, vapply(COMP, col_pv, "", m = 1)]), modelo, "D-44")
  aj <- if (file.exists(CACHE_AJ)) readRDS(CACHE_AJ) else NULL
  if (is.null(aj) || !identical(aj$huella, Ha)) {
    for (cp in COMP) ds[[paste0("y_", cp)]] <- Y[, col_pv(cp, 1)] / 100
    reloj("SEM latente con estadístico de prueba, VP1 (D-44)")
    f1 <- sem(modelo, data = ds, ordered = IND, estimator = "WLSMV", std.lv = TRUE, sampling.weights = "w_norm",
              missing = "pairwise")
    aj <- list(huella = Ha, medidas = fitMeasures(f1), convergio = lavInspect(f1, "converged"), n = lavInspect(f1, "nobs"))
    saveRDS(aj, CACHE_AJ); reloj("Ajuste listo")
  }
  MED <- c("chisq.scaled", "df.scaled", "pvalue.scaled", "cfi.scaled", "tli.scaled", "rmsea.scaled", "cfi.robust",
           "tli.robust", "rmsea.robust", "srmr")
  ajuste <- cbind(data.table(modelo = "NSE latente del AFE (29 indicadores) -> 4 competencias, sexo y grado; VP1 de la OCDE",
                             n = aj$n, convergio = aj$convergio),
                  as.data.table(as.list(setNames(round(unname(aj$medidas[MED]), 4), MED))))
  fwrite(ajuste, file.path(SALIDAS, "sem_ajuste_latente.csv"))
  cat("\n--- Ajuste del SEM latente, VP1 (salidas/sem_ajuste_latente.csv) ---\n"); print(ajuste)
}

# =============================================================================
# 7. DIAGRAMA DEL MODELO (D-44 punto 5): etiquetas = puntos PISA por DE de la EAP (sem_coeficientes.csv)
# =============================================================================
png(file.path(SALIDAS, "sem_diagrama.png"), width = 1800, height = 1100, res = 150)
par(mar = c(3, 1, 3, 1)); plot.new(); plot.window(xlim = c(0, 10), ylim = c(0, 10))
title("F6: NSE de la G2 y competencias matemáticas (D-42; robustez en D-44)")
caja <- function(x, y, txt, elipse = FALSE, an = 1.9, al = 0.9) {
  if (elipse) { t <- seq(0, 2 * pi, length.out = 100); polygon(x + an / 2 * cos(t), y + al / 2 * sin(t), col = "grey92") }
  else rect(x - an / 2, y - al / 2, x + an / 2, y + al / 2, col = "white")
  text(x, y, txt, cex = 0.8) }
YC <- setNames(c(8.6, 6.4, 4.2, 2.0), COMP); YL <- c(ECO = 7.6, CUL = 4.6)
caja(0.9, YL[["ECO"]], "19 indicadores\n(bienes del hogar)"); caja(0.9, YL[["CUL"]], "10 indicadores\n(libros)")
caja(3.4, YL[["ECO"]], "NSE\neconómico", elipse = TRUE); caja(3.4, YL[["CUL"]], "NSE\nlibros", elipse = TRUE)
caja(3.4, 2.2, "Sexo", an = 1.3, al = 0.6); caja(3.4, 1.1, "Grado", an = 1.3, al = 0.6)
for (f in names(YL)) arrows(3.4 - 0.95, YL[[f]], 0.9 + 0.95, YL[[f]], length = 0.08)
arrows(3.4, YL[["ECO"]] - 0.45, 3.4, YL[["CUL"]] + 0.45, code = 3, length = 0.08)
ETQ <- list()
for (cp in COMP) {
  caja(8.4, YC[[cp]], paste0(toupper(substr(cp, 1, 1)), substring(cp, 2), "\n(10 VP)"))
  for (f in names(YL)) {
    v <- if (f == "ECO") "eco" else "libros"; x0 <- 3.4 + 0.95; x1 <- 8.4 - 0.95
    arrows(x0, YL[[f]], x1, YC[[cp]], length = 0.08, col = if (f == "ECO") "black" else "grey45", lwd = if (f == "ECO") 1.6 else 1)
    lab <- formatC(coefs[competencia == cp & coeficiente == v, por_DE_de_la_EAP], format = "f", digits = 1)
    fx <- if (f == "ECO") 0.82 else 0.2                            # etiquetas lejos del cruce de las líneas
    ETQ[[length(ETQ) + 1]] <- list(x = x0 + fx * (x1 - x0), y = YL[[f]] + fx * (YC[[cp]] - YL[[f]]), lab = lab,
                                   col = if (f == "ECO") "black" else "grey35") }
  for (yy in c(2.2, 1.1)) arrows(3.4 + 0.65, yy, 8.4 - 0.95, YC[[cp]], length = 0.05, col = "grey75", lty = 2) }
for (e in ETQ) {                                                    # etiquetas al final, sobre fondo blanco
  rect(e$x - strwidth(e$lab, cex = 0.75) * 0.65, e$y - strheight(e$lab, cex = 0.75) * 0.8,
       e$x + strwidth(e$lab, cex = 0.75) * 0.65, e$y + strheight(e$lab, cex = 0.75) * 0.8, col = "white", border = NA)
  text(e$x, e$y, e$lab, cex = 0.75, col = e$col) }
lines(c(9.5, 9.7, 9.7, 9.5), c(YC[[1]], YC[[1]], YC[[4]], YC[[4]]), col = "grey40")
text(9.78, mean(YC), "residuos\ncorrelacionados", srt = 90, cex = 0.7, col = "grey30")
mtext(paste("Principal: dos pasos (EAP del NSE + regresión con los 10 VP de la OCDE, 80 réplicas BRR y Rubin).",
            "Robustez: NSE latente (WLSMV) y VP propios (D-44)."), side = 1, line = 0.5, cex = 0.7)
mtext("Etiquetas: puntos PISA por DE de la EAP del NSE (salidas/sem_coeficientes.csv). Líneas punteadas: covariables.",
      side = 1, line = 1.5, cex = 0.7)
invisible(dev.off())

cat("\n--- Coeficientes del NSE (salidas/sem_coeficientes.csv) ---\n"); print(coefs[coeficiente %in% c("eco", "libros")])
cat("\n--- Igualdad entre competencias (salidas/sem_igualdad.csv) ---\n"); print(igualdad)
cat("\n--- H5, exploratoria (salidas/sem_h5.csv) ---\n"); print(h5)
cat("\n--- H6 (salidas/sem_h6.csv) ---\n"); print(h6); print(int_tab)
cat("\n--- Robustez con VP propios (salidas/sem_propios_*.csv) ---\n")
print(op$coefs[coeficiente %in% c("eco", "libros")]); print(op$igualdad); print(op$h5); print(op$h6)
cat("\n--- Concordancia entre fuentes (salidas/sem_comparacion_fuentes.csv) ---\n"); print(comparacion)
