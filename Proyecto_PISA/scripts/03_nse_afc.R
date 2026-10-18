# =============================================================================
# 03 NSE AFC - PISA 2022 Colombia (F3, paso 3.4: H1)
#
# Decisiones: D-16 (puntos 5 a 8) y D-18 (Vault_PISA2022/03 Registro de decisiones.md).
# Entrada: datos/COL_nse.rds (03_nse_medicion.R, paso 3.1) y salidas/nse_estructura_afe.csv (paso 3.2).
#
# AFC ordinal en la mitad de confirmación (3.441 estudiantes), con WLSMV:
#   - M1: 1 factor con los 29 indicadores; M2: 2 factores con la estructura de D-16 (la de H1);
#     M2_AFE: la estructura del AFE del 3.2, solo exploratoria;
#   - pesos W_FSTUWT normalizados a la mitad (D-16 punto 5) y faltantes por pares (punto 6);
#   - H1 (D-16 punto 8) con M1 y M2 puros: se acepta si el CFI scaled y el robust mejoran los dos >= 0,01
#     y la correlación entre factores es < 0,90;
#   - sensibilidades (D-18 punto 6): (a) sin pesos; (b) exploratoria, M1 y M2 con 10 residuos correlacionados
#     fijados el 2026-10-18, antes de correr este script y antes de ver el Q3 del 3.3b.
#   - Puerta G2 (D-18 punto 7): CFI >= 0,95, RMSEA <= 0,06 (las dos versiones) y SRMR <= 0,08.
#
# Los errores estándar de lavaan no reflejan el diseño por colegios (D-16): se usan estimaciones puntuales.
#
# Salidas (solo agregados): salidas/nse_ajuste_afc.csv, nse_h1_afc.csv, nse_cargas_afc.csv,
#   nse_omega_afc.csv y nse_residuos_afc.csv.
#
# Cómo correrlo (desde Proyecto_PISA/scripts/, después de 03_nse_medicion.R). Tarda unos minutos:
#   & "C:\Program Files\R\R-4.4.1\bin\Rscript.exe" 03_nse_afc.R
# =============================================================================

options(stringsAsFactors = FALSE, scipen = 999, width = 160)
suppressPackageStartupMessages({ library(data.table); library(lavaan); library(semTools) })

carpeta_script <- function() {
  arg <- grep("^--file=", commandArgs(FALSE), value = TRUE)
  if (length(arg)) return(dirname(normalizePath(sub("^--file=", "", arg))))
  if (!is.null(sys.frames()[[1]]$ofile)) return(dirname(normalizePath(sys.frames()[[1]]$ofile)))
  getwd()
}
DIR     <- carpeta_script()                                        # Proyecto_PISA/scripts
DATOS   <- normalizePath(file.path(DIR, "..", "datos"))
SALIDAS <- normalizePath(file.path(DIR, "..", "salidas"))
if (!file.exists(file.path(DATOS, "COL_nse.rds"))) stop("Falta datos/COL_nse.rds: correr antes 03_nse_medicion.R")

nse <- readRDS(file.path(DATOS, "COL_nse.rds"))
fac <- attr(nse, "factores"); ECO <- fac$economico; CUL <- fac$cultural; IND <- c(ECO, CUL)
est_afe <- fread(file.path(SALIDAS, "nse_estructura_afe.csv"), encoding = "UTF-8")
CUL_AFE <- est_afe[factor_AFE == "cultural", item]; ECO_AFE <- setdiff(IND, CUL_AFE)
stopifnot(length(ECO) == 17, length(CUL) == 12, length(CUL_AFE) == 10, setequal(est_afe$item, IND))

# --- Mitad de confirmación y pesos normalizados (D-16 punto 5)
conf <- nse[mitad == "confirmacion"]
stopifnot(nrow(conf) == 3441)
conf[, w_norm := W_FSTUWT * .N / sum(W_FSTUWT)]
d <- as.data.frame(conf[, c(IND, "w_norm"), with = FALSE])
for (v in IND) { k <- sort(unique(na.omit(d[[v]])))                 # categorías 0..k-1, sin huecos en la mitad
  if (length(k) < 2 || any(k != seq_along(k) - 1)) stop("Categorías con huecos en la mitad de confirmación: ", v) }

# --- Modelos (D-18 punto 2)
sintaxis <- function(f) paste(vapply(names(f), function(k) paste(k, "=~", paste(f[[k]], collapse = " + ")), ""),
                              collapse = "\n")
MODELOS <- list(M1 = sintaxis(list(NSE = IND)), M2 = sintaxis(list(ECO = ECO, CUL = CUL)),
                M2_AFE = sintaxis(list(ECO = ECO_AFE, CUL = CUL_AFE)))
# D-18 punto 6(b): los 10 pares, fijados el 2026-10-18 (ítems cuyo contenido se superpone)
PARES <- rbind(c("ST250Q02JA", "ST254Q02JA"), c("ST250Q02JA", "ST254Q03JA"), c("ST250Q02JA", "ST254Q04JA"),
               c("ST250Q04JA", "ST254Q06JA"), cbind("ST253Q01JA", sprintf("ST254Q0%dJA", 1:6)))
stopifnot(nrow(PARES) == 10, all(PARES %in% ECO))
RESIDUOS <- paste(PARES[, 1], "~~", PARES[, 2], collapse = "\n")

# --- Estimación: cada ajuste guarda sus avisos (D-18 punto 8: se reportan tal cual)
ajustar <- function(modelo, pesos = TRUE) {
  avisos <- character()
  fit <- withCallingHandlers(
    tryCatch(cfa(modelo, data = d, ordered = IND, estimator = "WLSMV", missing = "pairwise", std.lv = TRUE,
                 sampling.weights = if (pesos) "w_norm" else NULL),
             error = function(e) { avisos <<- c(avisos, paste("ERROR:", conditionMessage(e))); NULL }),
    warning = function(w) { avisos <<- c(avisos, conditionMessage(w)); invokeRestart("muffleWarning") })
  list(fit = fit, avisos = unique(avisos))
}
ESPEC <- data.table(
  modelo  = c("M1", "M2", "M2_AFE", "M1", "M2", "M1", "M2"),
  version = c("principal", "principal", "exploratoria (AFE)", "sin pesos", "sin pesos",
              "con 10 residuos (D-18 b)", "con 10 residuos (D-18 b)"),
  pesos   = c(TRUE, TRUE, TRUE, FALSE, FALSE, TRUE, TRUE),
  pares   = c(FALSE, FALSE, FALSE, FALSE, FALSE, TRUE, TRUE))
ESPEC[, clave := paste(modelo, version, sep = " | ")]
t0 <- Sys.time()
res <- lapply(seq_len(nrow(ESPEC)), function(i) { e <- ESPEC[i]
  sint <- MODELOS[[e$modelo]]; if (e$pares) sint <- paste(sint, RESIDUOS, sep = "\n")
  ajustar(sint, e$pesos) })
names(res) <- ESPEC$clave
minutos <- round(as.numeric(difftime(Sys.time(), t0, units = "mins")), 1)
fits <- lapply(res, `[[`, "fit")
if (any(vapply(fits, is.null, TRUE))) {
  print(lapply(res, `[[`, "avisos")); stop("Algún modelo no se pudo estimar (D-18 punto 8): ver los avisos")
}

# --- Ajuste de cada modelo
MEDIDAS <- c("chisq.scaled", "df.scaled", "pvalue.scaled", "cfi.scaled", "cfi.robust", "tli.scaled", "tli.robust",
             "rmsea.scaled", "rmsea.ci.lower.scaled", "rmsea.ci.upper.scaled", "rmsea.robust",
             "rmsea.ci.lower.robust", "rmsea.ci.upper.robust", "srmr")
cor_fac <- function(f) { p <- parameterEstimates(f); r <- p[p$op == "~~" & p$lhs != p$rhs & p$lhs %in% c("ECO", "CUL") &
                                                        p$rhs %in% c("ECO", "CUL"), ]
  if (!nrow(r)) c(NA, NA, NA) else c(r$est, r$ci.lower, r$ci.upper) }
ajuste <- rbindlist(lapply(seq_len(nrow(ESPEC)), function(i) { f <- fits[[i]]; fm <- fitMeasures(f)
  m <- as.list(round(unname(fm[MEDIDAS]), 4)); names(m) <- MEDIDAS; rf <- cor_fac(f)
  c(list(modelo = ESPEC$modelo[i], version = ESPEC$version[i], n = lavInspect(f, "nobs"),
         convergio = lavInspect(f, "converged")), m,
    list(correlacion_factores = round(rf[1], 3), cor_ic95_inf = round(rf[2], 3), cor_ic95_sup = round(rf[3], 3),
         avisos = paste(res[[i]]$avisos, collapse = " / "))) }))
# Corte de la G2 en las dos versiones (D-18 punto 7). Si lavaan no pudo calcular la robust (NaN o Inf), se dice.
corte_g2 <- function(s, r, cumple) fcase(
  !is.finite(r), fifelse(cumple(s), "solo scaled (robust no calculable)", "no cumple (robust no calculable)"),
  cumple(s) & cumple(r), "cumple (ambas)",
  cumple(s) | cumple(r), "solo una versión",
  default = "no cumple")
ajuste[, `:=`(G2_cfi   = corte_g2(cfi.scaled, cfi.robust, function(x) x >= 0.95),
              G2_rmsea = corte_g2(rmsea.scaled, rmsea.robust, function(x) x <= 0.06),
              G2_srmr  = fifelse(srmr <= 0.08, "cumple", "no cumple"))]
ajuste[!is.finite(cfi.robust) | !is.finite(rmsea.robust) | !is.finite(tli.robust),
       avisos := trimws(paste(avisos, "lavaan no pudo calcular los índices robust (NaN o Inf)"))]
fwrite(ajuste, file.path(SALIDAS, "nse_ajuste_afc.csv"))

# --- H1 (D-16 punto 8): de M1 a M2, con pesos (decide), sin pesos y con la estructura del AFE (no deciden)
h1_fila <- function(k1, k2, decide) {
  a1 <- ajuste[paste(modelo, version, sep = " | ") == k1]; a2 <- ajuste[paste(modelo, version, sep = " | ") == k2]
  lrt <- tryCatch(lavTestLRT(fits[[k1]], fits[[k2]]), error = function(e) NULL)
  dcs <- a2$cfi.scaled - a1$cfi.scaled; dcr <- a2$cfi.robust - a1$cfi.robust; r <- a2$correlacion_factores
  data.table(comparacion = paste(k1, "->", k2), decide_H1 = decide,
             dCFI_scaled = round(dcs, 4), dCFI_robust = round(dcr, 4), correlacion_factores = r,
             cumple_regla = dcs >= 0.01 & dcr >= 0.01 & r < 0.90,
             LRT_dif_chi2 = if (is.null(lrt)) NA else round(lrt[2, "Chisq diff"], 1),
             LRT_gl = if (is.null(lrt)) NA else lrt[2, "Df diff"],
             LRT_p = if (is.null(lrt)) NA_character_ else format(signif(lrt[2, "Pr(>Chisq)"], 3), scientific = TRUE))
}
h1 <- rbind(h1_fila("M1 | principal", "M2 | principal", "sí (D-16 punto 8)"),
            h1_fila("M1 | sin pesos", "M2 | sin pesos", "no: sensibilidad (a)"),
            h1_fila("M1 | principal", "M2_AFE | exploratoria (AFE)", "no: exploratoria"),
            h1_fila("M1 | con 10 residuos (D-18 b)", "M2 | con 10 residuos (D-18 b)", "no: sensibilidad (b)"))
h1[, H1 := fifelse(decide_H1 == "sí (D-16 punto 8)", fifelse(cumple_regla, "se acepta", "se rechaza"), "—")]
fwrite(h1, file.path(SALIDAS, "nse_h1_afc.csv"))

# --- Cargas estandarizadas (modelos principales y exploratorio, con pesos)
PRINC <- c("M1 | principal", "M2 | principal", "M2_AFE | exploratoria (AFE)")
cargas <- rbindlist(lapply(PRINC, function(k) { s <- standardizedSolution(fits[[k]]); s <- s[s$op == "=~", ]
  data.table(modelo = sub(" \\|.*", "", k), factor = s$lhs, item = s$rhs, carga_std = round(s$est.std, 3)) }))
fwrite(cargas, file.path(SALIDAS, "nse_cargas_afc.csv"))

# --- Omega por factor (compRelSEM, indicadores ordinales)
omega <- rbindlist(lapply(PRINC, function(k) { o <- tryCatch(compRelSEM(fits[[k]]), error = function(e) NULL)
  if (is.null(o)) return(data.table(modelo = sub(" \\|.*", "", k), factor = NA_character_, omega = NA_real_))
  data.table(modelo = sub(" \\|.*", "", k), factor = names(o),
             omega = round(vapply(o, function(x) as.numeric(x)[1], numeric(1)), 3)) }))
fwrite(omega, file.path(SALIDAS, "nse_omega_afc.csv"))

# --- Los 10 residuos de correlación más grandes de cada modelo principal (D-18 punto 7)
residuos <- rbindlist(lapply(PRINC, function(k) { R <- lavResiduals(fits[[k]], type = "cor")$cov
  R <- R[IND, IND]; ij <- which(upper.tri(R), arr.ind = TRUE)
  r <- data.table(modelo = sub(" \\|.*", "", k), item1 = rownames(R)[ij[, 1]], item2 = colnames(R)[ij[, 2]],
                  residuo = round(R[ij], 3))
  r[order(-abs(residuo))][1:10] }))
fwrite(residuos, file.path(SALIDAS, "nse_residuos_afc.csv"))

# =============================================================================
# RESUMEN EN CONSOLA
# =============================================================================
cat("Paso 3.4: AFC en la mitad de confirmación (n =", nrow(d), ") |", nrow(ESPEC), "modelos en", minutos, "min\n\n")
cat("--- Ajuste (salidas/nse_ajuste_afc.csv) ---\n")
print(ajuste[, .(modelo, version, convergio, chisq.scaled, df.scaled, cfi.scaled, cfi.robust, tli.robust,
                 rmsea.scaled, rmsea.robust, srmr, correlacion_factores, G2_cfi, G2_rmsea, G2_srmr)])
avisos <- ajuste[avisos != "", .(modelo, version, avisos)]
if (nrow(avisos)) { cat("\nAvisos de lavaan (D-18 punto 8):\n"); print(avisos) }
cat("\n--- H1 (salidas/nse_h1_afc.csv) ---\n"); print(h1)
cat("\n--- Omega (salidas/nse_omega_afc.csv) ---\n"); print(omega)
cat("\n--- Cargas de M2 (D-16), de mayor a menor ---\n"); print(cargas[modelo == "M2"][order(factor, -carga_std)])
cat("\n--- Residuos de correlación más grandes (salidas/nse_residuos_afc.csv) ---\n"); print(residuos)
cat("\nListo: salidas/nse_ajuste_afc.csv, nse_h1_afc.csv, nse_cargas_afc.csv, nse_omega_afc.csv y nse_residuos_afc.csv\n")
