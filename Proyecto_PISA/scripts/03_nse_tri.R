# =============================================================================
# 03 NSE TRI - PISA 2022 Colombia (F3, pasos 3.3 y 3.5)
#
# Decisiones: D-16 (puntos 5, 6, 7 y 9) y D-19 (Vault_PISA2022/03 Registro de decisiones.md).
# Entrada: datos/COL_nse.rds (03_nse_medicion.R, paso 3.1) y salidas/nse_estructura_afe.csv (paso 3.2).
#
# 3.3 TRI en los 6.886 estudiantes (las dos mitades), ponderada y sin errores estándar (D-19):
#   - 2PL para los ítems Sí/No (ST250) y GPCM para el resto, como la OCDE (Technical Report, p. 380);
#   - tres modelos: 1 dimensión (enfoque de HOMEPOS), 2 dimensiones de D-16 (la estructura de H1) y
#     2 dimensiones del AFE (solo exploratorio);
#   - comparación con AIC y BIC (pseudo-verosimilitud ponderada: es descriptiva);
#   - ajuste de cada ítem con S-X² en los casos completos (itemfit no admite faltantes ni pesos);
#   - información del test y confiabilidad; información de cada ítem en el modelo 1D (D-19, corrección).
# 3.3b Dependencia local (D-21): Q3 de Yen en los tres modelos, sin pesos; se marca |Q3| > 0,2.
# 3.5 Validez: correlación ponderada de las puntuaciones EAP con HOMEPOS y ESCS oficiales.
#
# Salidas (solo agregados): salidas/nse_parametros_tri.csv, nse_tri_cargas_2d.csv, nse_ajuste_tri.csv,
#   nse_itemfit_tri.csv, nse_q3_tri.csv, nse_informacion_tri.csv, nse_confiabilidad_tri.csv, nse_validez.csv
#   y la figura nse_informacion_tri.png.
# Caché (no va a Git: puntuaciones individuales): datos/COL_nse_tri.rds.
#
# Cómo correrlo (desde Proyecto_PISA/scripts/, después de 03_nse_medicion.R). Tarda varios minutos:
#   & "C:\Program Files\R\R-4.4.1\bin\Rscript.exe" 03_nse_tri.R
# =============================================================================

options(stringsAsFactors = FALSE, scipen = 999, width = 160)
suppressPackageStartupMessages({ library(data.table); library(mirt) })

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
CUL_AFE <- est_afe[factor_AFE == "cultural", item]
ECO_AFE <- setdiff(IND, CUL_AFE)
stopifnot(nrow(nse) == 6886, length(IND) == 29, setequal(est_afe$item, IND), length(CUL_AFE) == 10)

X     <- as.data.frame(nse[, ..IND])
w     <- nse$W_FSTUWT * nrow(nse) / sum(nse$W_FSTUWT)                 # pesos normalizados (D-16 punto 5)
tipos <- ifelse(grepl("^ST250", IND), "2PL", "gpcm")
stopifnot(all(sapply(X[tipos == "2PL"], function(x) all(x %in% c(0, 1, NA)))))

# =============================================================================
# 3.3 ESTIMACIÓN DE LOS TRES MODELOS
# =============================================================================
modelo_2d <- function(eco, cul)
  mirt.model(paste0("ECO = ", paste(eco, collapse = ", "), "\nCUL = ", paste(cul, collapse = ", "),
                    "\nCOV = ECO*CUL"), itemnames = IND)
ajustar <- function(modelo) mirt(X, modelo, itemtype = tipos, survey.weights = w, SE = FALSE,
                                 verbose = FALSE, technical = list(NCYCLES = 3000))
# Los modelos tardan unos 10 minutos: se guardan en un caché y las corridas siguientes lo reutilizan.
# Para volver a estimarlos: $env:REHACER_TRI = "1" antes de correr el script.
MODELOS <- file.path(DATOS, "COL_nse_tri_modelos.rds")
# El caché guarda la huella (md5) de lo que entra a los modelos: si cambian los datos, los pesos, los tipos o la
# estructura, se reestiman en vez de usar modelos viejos (observación 2 de Brayan, PR #12).
huella <- function(...) { f <- tempfile(); on.exit(unlink(f))
  writeBin(serialize(list(...), NULL, version = 3), f); unname(tools::md5sum(f)) }
HUELLA <- huella(as.list(X), w, tipos, ECO, CUL, ECO_AFE, CUL_AFE)
usar_cache <- file.exists(MODELOS) && Sys.getenv("REHACER_TRI") != "1"
if (usar_cache) {
  modelos <- readRDS(MODELOS)
  usar_cache <- identical(attr(modelos, "huella_datos"), HUELLA)
  if (!usar_cache) cat("El caché", basename(MODELOS), "no corresponde a los datos actuales: se reestiman los modelos\n")
}
if (usar_cache) {
  minutos <- NA
  cat("Modelos leídos del caché", basename(MODELOS), "\n")
} else {
  t0 <- Sys.time()
  modelos <- list("1D"     = ajustar(1),
                  "2D_D16" = ajustar(modelo_2d(ECO, CUL)),
                  "2D_AFE" = ajustar(modelo_2d(ECO_AFE, CUL_AFE)))
  minutos <- round(as.numeric(Sys.time() - t0, units = "mins"), 1)
  attr(modelos, "huella_datos") <- HUELLA
  saveRDS(modelos, MODELOS)
}
stopifnot(all(sapply(modelos, extract.mirt, "converged")))

# --- Comparación de los modelos
fcor <- function(m) { s <- summary(m, verbose = FALSE)$fcor; if (is.null(s) || ncol(s) < 2) NA_real_ else s[1, 2] }
ajuste <- rbindlist(lapply(names(modelos), function(k) { m <- modelos[[k]]
  data.table(modelo = k, logLik = round(extract.mirt(m, "logLik"), 1), parametros = extract.mirt(m, "nest"),
             AIC = round(extract.mirt(m, "AIC"), 1), BIC = round(extract.mirt(m, "BIC"), 1),
             iteraciones = extract.mirt(m, "iterations"), correlacion_factores = round(fcor(m), 3)) }))
ajuste[, `:=`(dif_AIC = AIC - min(AIC), dif_BIC = BIC - min(BIC))]
ajuste[, nota := "pseudo-verosimilitud ponderada: la comparación es descriptiva (D-19)"]
fwrite(ajuste, file.path(SALIDAS, "nse_ajuste_tri.csv"))

# --- Cargas estandarizadas: la misma fórmula que usa summary() de mirt (función interna Lambdas), con una corrección.
# En mirt 1.46.1, Lambdas multiplica la carga de cada ítem GPCM por sign(pendiente del factor 1). En los ítems que
# solo cargan en el factor 2, esa pendiente es 0 y sign(0) = 0 anula la carga: por eso summary() daba 0 en todo el
# factor cultural (D-19, corrección del 2026-10-18). Aquí se usa el signo de la primera pendiente que no es 0.
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
cargas <- lapply(modelos, cargas_mirt)
# Control: en 1D coincide con summary(); en 2D, coincide en los ítems que no cargan en el factor 2 (donde mirt no falla)
s1 <- summary(modelos[["1D"]], verbose = FALSE)
stopifnot(isTRUE(all.equal(unname(cargas[["1D"]][, 1]), unname(s1$rotF[, 1]), tolerance = 1e-8)))
for (k in c("2D_D16", "2D_AFE")) { s <- summary(modelos[[k]], verbose = FALSE)
  solo_eco <- cargas[[k]][, "CUL"] == 0
  stopifnot(isTRUE(all.equal(unname(cargas[[k]][solo_eco, "ECO"]), unname(s$rotF[solo_eco, "ECO"]), tolerance = 1e-8)),
            all(cargas[[k]][!solo_eco, "CUL"] > 0)) }

# --- Parámetros del modelo de 1 dimensión (a = discriminación; b = umbrales en la escala del NSE)
# Las a de un 2PL y de un GPCM con 3 a 10 categorías no son comparables entre sí. Para comparar ítems se agrega la
# información de cada ítem: el área bajo su curva de información en theta de -4 a 4 (areainfo) y su % del total.
p1  <- as.data.table(coef(modelos[["1D"]], IRTpars = TRUE, simplify = TRUE)$items, keep.rownames = "item")
par1 <- p1[, c("item", "a", grep("^b[0-9]*$", names(p1), value = TRUE)), with = FALSE]
info_item <- vapply(seq_along(IND), function(j) areainfo(modelos[["1D"]], c(-4, 4), which.items = j)$Info, numeric(1))
par1[, `:=`(tipo = tipos[match(item, IND)], factor_D16 = ifelse(item %in% CUL, "cultural", "económico"),
            carga_1D = cargas[["1D"]][item, 1], h2_1D = cargas[["1D"]][item, 1]^2,
            info_1D = info_item[match(item, IND)], pct_info_1D = 100 * info_item[match(item, IND)] / sum(info_item))]
num <- names(par1)[sapply(par1, is.numeric)]; par1[, (num) := lapply(.SD, round, 3), .SDcols = num]
setcolorder(par1, c("item", "factor_D16", "tipo", "a", "carga_1D", "h2_1D", "info_1D", "pct_info_1D"))
fwrite(par1, file.path(SALIDAS, "nse_parametros_tri.csv"))

# --- Cargas estandarizadas de los modelos de 2 dimensiones (con cargas_mirt, no con summary)
cargas2 <- rbindlist(lapply(c("2D_D16", "2D_AFE"), function(k) { F <- cargas[[k]][IND, , drop = FALSE]
  data.table(modelo = k, item = IND, carga_ECO = round(F[, "ECO"], 3), carga_CUL = round(F[, "CUL"], 3),
             h2 = round(rowSums(F^2), 3)) }))
fwrite(cargas2, file.path(SALIDAS, "nse_tri_cargas_2d.csv"))

# --- Información del test (1D) y a lo largo de cada eje (2D), en theta de -4 a 4
th <- seq(-4, 4, by = 0.1)
eje <- function(m, d) if (d == 1) testinfo(m, cbind(th, 0), degrees = c(0, 90)) else testinfo(m, cbind(0, th), degrees = c(90, 0))
info <- data.table(theta = th, info_1D = testinfo(modelos[["1D"]], matrix(th)),
                   info_D16_ECO = eje(modelos[["2D_D16"]], 1), info_D16_CUL = eje(modelos[["2D_D16"]], 2),
                   info_AFE_ECO = eje(modelos[["2D_AFE"]], 1), info_AFE_CUL = eje(modelos[["2D_AFE"]], 2))
info[, se_1D := 1 / sqrt(info_1D)]
fwrite(info[, lapply(.SD, round, 3)], file.path(SALIDAS, "nse_informacion_tri.csv"))
# Rango de theta con información >= 4 (error estándar <= 0,5): convención descriptiva del equipo
rango <- function(x) { k <- th[x >= 4]; if (length(k)) sprintf("%.1f a %.1f", min(k), max(k)) else "ninguno" }

png(file.path(SALIDAS, "nse_informacion_tri.png"), width = 1800, height = 700, res = 150)
par(mfrow = c(1, 3), mar = c(4.2, 4.2, 3, 1))
plot(th, info$info_1D, type = "l", lwd = 2, xlab = "NSE (theta)", ylab = "Información", main = "TRI de 1 dimensión")
abline(h = 4, lty = 3, col = "grey40")
for (k in c("D16", "AFE")) {
  y <- cbind(info[[paste0("info_", k, "_ECO")]], info[[paste0("info_", k, "_CUL")]])
  matplot(th, y, type = "l", lty = 1, lwd = 2, col = c("#1f6fa8", "#b8432f"), xlab = "theta en cada eje", ylab = "Información",
          main = if (k == "D16") "2 dimensiones de D-16 (H1)" else "2 dimensiones del AFE (exploratorio)")
  abline(h = 4, lty = 3, col = "grey40"); legend("topright", c("económico", "cultural"), col = c("#1f6fa8", "#b8432f"), lwd = 2, bty = "n")
}
invisible(dev.off())

# --- Puntuaciones EAP y confiabilidad
eap <- lapply(modelos, function(m) fscores(m, method = "EAP", full.scores.SE = TRUE))
confiab <- rbindlist(c(
  list(data.table(modelo = "1D", dimension = "NSE", tipo = "marginal", confiabilidad = round(marginal_rxx(modelos[["1D"]]), 3))),
  lapply(names(eap), function(k) { r <- empirical_rxx(eap[[k]])
    data.table(modelo = k, dimension = if (k == "1D") "NSE" else names(r), tipo = "empírica (EAP)", confiabilidad = round(unname(r), 3)) })))
fwrite(confiab, file.path(SALIDAS, "nse_confiabilidad_tri.csv"))

tri <- data.table(CNTSTUID = nse$CNTSTUID, mitad = nse$mitad, W_FSTUWT = nse$W_FSTUWT,
                  eap_1D = eap[["1D"]][, "F1"], se_1D = eap[["1D"]][, "SE_F1"],
                  eap_D16_ECO = eap[["2D_D16"]][, "ECO"], eap_D16_CUL = eap[["2D_D16"]][, "CUL"],
                  se_D16_ECO = eap[["2D_D16"]][, "SE_ECO"], se_D16_CUL = eap[["2D_D16"]][, "SE_CUL"],
                  eap_AFE_ECO = eap[["2D_AFE"]][, "ECO"], eap_AFE_CUL = eap[["2D_AFE"]][, "CUL"],
                  se_AFE_ECO = eap[["2D_AFE"]][, "SE_ECO"], se_AFE_CUL = eap[["2D_AFE"]][, "SE_CUL"])
saveRDS(tri, file.path(DATOS, "COL_nse_tri.rds"), compress = TRUE)

# =============================================================================
# 3.5 VALIDEZ: correlación ponderada (peso final) con HOMEPOS y ESCS oficiales
# =============================================================================
r_w <- function(x, y) { k <- !is.na(x) & !is.na(y)
  c(r = cov.wt(cbind(x[k], y[k]), wt = nse$W_FSTUWT[k], cor = TRUE)$cor[1, 2], n = sum(k)) }
validez <- rbindlist(lapply(grep("^eap_", names(tri), value = TRUE), function(v) {
  a <- r_w(tri[[v]], nse$HOMEPOS); b <- r_w(tri[[v]], nse$ESCS)
  data.table(puntuacion = v, r_HOMEPOS = round(a[["r"]], 3), n_HOMEPOS = a[["n"]], r_ESCS = round(b[["r"]], 3), n_ESCS = b[["n"]]) }))
stopifnot(all(validez$r_HOMEPOS > 0))      # el sentido de cada factor es "más NSE = más alto"
fwrite(validez, file.path(SALIDAS, "nse_validez.csv"))

# =============================================================================
# AJUSTE DE CADA ÍTEM (D-19 punto 5), al final y protegido: si falla, las demás salidas ya están guardadas.
# =============================================================================
# S-X² en los casos completos y sin pesos. Antes de D-20, ningún caso completo tenía la categoría 0 de ST253Q01JA
# ni de ST255Q01JA y el S-X² no se podía calcular; con D-20 (saltos = 0) ya se calcula.
n_completos <- sum(complete.cases(X))
items_fit <- rbindlist(lapply(names(modelos), function(k) {
  f <- tryCatch(as.data.table(suppressMessages(itemfit(modelos[[k]], fit_stats = "S_X2", na.rm = TRUE))),
                error = function(e) data.table(item = NA_character_, error = conditionMessage(e)))
  f[, `:=`(modelo = k, n_casos_completos = n_completos)] }), fill = TRUE)
if ("p.S_X2" %in% names(items_fit)) {
  items_fit[, p_BH := p.adjust(p.S_X2, "BH"), by = modelo]
  items_fit[, problematico := p_BH < 0.05 & RMSEA.S_X2 > 0.05]
  # Redondeo solo para el archivo, después de marcar los problemáticos: sin él, en otra máquina el CSV cambia en el
  # último decimal aunque el resultado sea el mismo (observación 10 de Brayan, PR #12).
  items_fit[, `:=`(S_X2 = round(S_X2, 2), RMSEA.S_X2 = round(RMSEA.S_X2, 4),
                   p.S_X2 = round(p.S_X2, 4), p_BH = round(p_BH, 4))]
}
setcolorder(items_fit, c("modelo", "item"))
fwrite(items_fit, file.path(SALIDAS, "nse_itemfit_tri.csv"))

# =============================================================================
# 3.3b DEPENDENCIA LOCAL (D-21): Q3 de Yen, protegido como el S-X²
# =============================================================================
# Q3 = correlación entre los residuos de dos ítems (de Ayala, pp. 132-133). Sin pesos (residuals no los admite) y
# con todas las respuestas disponibles. Se marca |Q3| > 0,2 (de Ayala, p. 134, citando a Yen, 1993, para 17 ítems
# o más). Bajo independencia, el Q3 esperado es -1/(L - 1) (p. 133). Exploratorio: no decide H1.
bloque <- function(x) fifelse(grepl("^ST25[56]", x), "libros", fifelse(grepl("^ST25[34]", x), "dispositivos", "otros"))
q3 <- rbindlist(lapply(names(modelos), function(k) {
  Q <- tryCatch(residuals(modelos[[k]], type = "Q3", verbose = FALSE), error = function(e) conditionMessage(e))
  if (is.character(Q)) return(data.table(modelo = k, error = Q))
  ij <- which(upper.tri(Q), arr.ind = TRUE)
  data.table(modelo = k, item1 = rownames(Q)[ij[, 1]], item2 = colnames(Q)[ij[, 2]], Q3 = round(Q[ij], 3)) }), fill = TRUE)
Q3_ESPERADO <- -1 / (length(IND) - 1)
if ("Q3" %in% names(q3)) {
  q3[, `:=`(bloque = fifelse(bloque(item1) == bloque(item2), bloque(item1), "entre bloques"), marcado = abs(Q3) > 0.2)]
  q3_res <- q3[, .(pares = .N, marcados = sum(marcado), Q3_medio = round(mean(Q3), 3), Q3_max = max(Q3),
                   Q3_min = min(Q3)), by = .(modelo, bloque)]
}
fwrite(q3, file.path(SALIDAS, "nse_q3_tri.csv"))

# =============================================================================
# RESUMEN EN CONSOLA
# =============================================================================
cat("Estimación de los tres modelos:", if (is.na(minutos)) "leídos del caché" else paste(minutos, "min"),
    "| todos convergieron\n\n--- Comparación (salidas/nse_ajuste_tri.csv) ---\n")
print(ajuste[, .(modelo, logLik, parametros, AIC, BIC, dif_AIC, dif_BIC, correlacion_factores, iteraciones)])
cat("\n--- 1 dimensión: información de cada ítem (área en theta -4 a 4), de mayor a menor; a y carga como referencia ---\n")
print(par1[order(-info_1D), .(item, factor_D16, tipo, a, carga_1D, info_1D, pct_info_1D)])
cat("\n--- 2 dimensiones: cargas estandarizadas corregidas (salidas/nse_tri_cargas_2d.csv) ---\n")
print(dcast(cargas2, item ~ modelo, value.var = c("carga_ECO", "carga_CUL"))[match(IND, item)])
cat("\n--- Ajuste de ítems (S-X², n =", n_completos, "casos completos): ítems problemáticos por modelo ---\n")
if ("problematico" %in% names(items_fit)) print(items_fit[, .(problematicos = sum(problematico, na.rm = TRUE), cuales = paste(item[problematico %in% TRUE], collapse = ", ")), by = modelo]) else print(unique(items_fit[, .(modelo, error)]))
cat("\n--- 3.3b Dependencia local: Q3 por bloque (|Q3| > 0,2 marcado; esperado bajo independencia:",
    round(Q3_ESPERADO, 3), ") ---\n")
if (exists("q3_res")) { print(q3_res); cat("Pares marcados:\n"); print(q3[marcado == TRUE][order(modelo, -abs(Q3))]) } else print(q3)
cat("\n--- Información >= 4 (error estándar <= 0,5) en el rango de theta ---\n")
cat("1D:", rango(info$info_1D), "| D-16 económico:", rango(info$info_D16_ECO), "| D-16 cultural:", rango(info$info_D16_CUL),
    "| AFE económico:", rango(info$info_AFE_ECO), "| AFE cultural:", rango(info$info_AFE_CUL), "\n")
cat("\n--- Confiabilidad ---\n"); print(confiab)
cat("\n--- 3.5 Validez (correlación ponderada) ---\n"); print(validez)
cat("\nListo: salidas/nse_*_tri.csv, nse_validez.csv, nse_informacion_tri.png y datos/COL_nse_tri.rds\n")
