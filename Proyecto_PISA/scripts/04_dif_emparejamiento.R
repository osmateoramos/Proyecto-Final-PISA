# =============================================================================
# 04 DIF SENSIBILIDAD S2 - emparejamiento del ΔR² y una sola familia de Benjamini-Hochberg (D-35; exploratoria)
#
# Qué hace:
#   1. Emparejamiento. En 04_invarianza.R, el ΔR² de Nagelkerke empareja con las EAP del modelo de la G2, que es de un
#      solo grupo: todos comparten la misma distribución previa y sus EAP se contraen hacia una media común, aunque los
#      grupos difieren hasta 1,4 DE (salidas/nse_medias_latentes.csv). Esa contracción puede fabricar o tapar DIF
#      uniforme. Aquí el ΔR² se repite con EAP de un modelo multigrupo por factor (mirt::multipleGroup, con pesos),
#      con todos los ítems iguales entre grupos y medias y varianzas libres: cada grupo se contrae hacia su propia
#      media. Mismos ítems, datos, regresión y corte (ΔR² >= 0,035) que en 04_invarianza.R.
#   2. Benjamini-Hochberg. En la vuelta 2 de 04_invarianza.R (líneas 278-283), BH se aplicaba solo a los ítems
#      probados y las anclas conservaban el valor de la vuelta 1: dos familias. Aquí se aplica una sola vez a los
#      valores p finales de cada análisis y factor (los de salidas/nse_dif_posesiones.csv, que no cambian).
#   La prueba TRI del DIF no se repite (tarda horas): sus valores p son los de salidas/nse_dif_posesiones.csv.
#
# Entradas: datos/COL_nse.rds, datos/COL_nse_tri.rds, salidas/nse_estructura_afe.csv, salidas/nse_dif_posesiones.csv
#   y salidas/inv_recodificacion.csv (control).
# Salidas (solo agregados): salidas/nse_dif_sens_emparejamiento.csv.
#
# Cómo correrlo (desde Proyecto_PISA/scripts/, después de 04_invarianza.R):
#   & "C:\Program Files\R\R-4.4.1\bin\Rscript.exe" 04_dif_emparejamiento.R
# =============================================================================

options(stringsAsFactors = FALSE, scipen = 999, width = 160)
suppressPackageStartupMessages({ library(data.table); library(mirt); library(MASS) })

carpeta_script <- function() {
  arg <- grep("^--file=", commandArgs(FALSE), value = TRUE)
  if (length(arg)) return(dirname(normalizePath(sub("^--file=", "", arg))))
  if (!is.null(sys.frames()[[1]]$ofile)) return(dirname(normalizePath(sys.frames()[[1]]$ofile)))
  getwd()
}
DIR     <- carpeta_script()
DATOS   <- normalizePath(file.path(DIR, "..", "datos"))
SALIDAS <- normalizePath(file.path(DIR, "..", "salidas"))
for (f in c("nse_dif_posesiones.csv", "inv_recodificacion.csv"))
  if (!file.exists(file.path(SALIDAS, f))) stop("Falta salidas/", f, ": correr antes 04_invarianza.R")

source(file.path(DIR, "utilidades_pisa.R"))                        # preparar_f4()
f4 <- preparar_f4(DATOS, SALIDAS)                                  # grupos y categorías de la F4 (D-25)
nse <- f4$nse; ECO <- f4$ECO; CUL <- f4$CUL; ANALISIS <- f4$ANALISIS

# --- ΔR² de Nagelkerke: la misma función que 04_invarianza.R (líneas 220-229)
nagelkerke <- function(m, m0, n) (1 - exp((2 / n) * (as.numeric(logLik(m0)) - as.numeric(logLik(m))))) /
                                 (1 - exp((2 / n) * as.numeric(logLik(m0))))
magnitud <- function(y, eap, g, w) {
  k <- !is.na(y) & !is.na(eap) & !is.na(g); y <- y[k]; eap <- eap[k]; g <- droplevels(g[k]); w <- w[k] * sum(k) / sum(w[k])
  dd <- data.frame(y = factor(y, ordered = TRUE), eap, g, w)
  ajusta <- function(fm) suppressWarnings(if (nlevels(dd$y) > 2) polr(fm, dd, weights = w, Hess = FALSE) else
                                            glm(fm, binomial, dd, weights = w))
  tryCatch({ m0 <- ajusta(y ~ 1); m1 <- ajusta(y ~ eap); m3 <- ajusta(y ~ eap * g)
             nagelkerke(m3, m0, nrow(dd)) - nagelkerke(m1, m0, nrow(dd)) }, error = function(e) NA_real_)
}

# --- S2: EAP de un modelo multigrupo (ítems iguales, medias y varianzas libres) y ΔR² con ellas
FACTORES <- list(ECO = list(items = ECO, eap = "eap_ECO"), CUL = list(items = CUL, eap = "eap_CUL"))
s2 <- rbindlist(lapply(names(ANALISIS), function(a) rbindlist(lapply(names(FACTORES), function(fc) {
  g <- ANALISIS[[a]]; it <- FACTORES[[fc]]$items
  d <- nse[!is.na(get(g))]; d <- d[rowSums(!is.na(d[, ..it])) > 0]          # como en 04_invarianza.R
  X <- as.data.frame(d[, ..it]); grp <- droplevels(d[[g]]); w <- d$W_FSTUWT * nrow(d) / sum(d$W_FSTUWT)
  tipos <- ifelse(vapply(X, function(x) length(unique(na.omit(x))), 1) == 2, "2PL", "gpcm")
  cat(format(Sys.time(), "%H:%M:%S"), "| S2", a, fc, "\n"); flush.console()
  mg <- multipleGroup(X, 1, group = grp, itemtype = tipos, survey.weights = w, SE = FALSE, verbose = FALSE,
                      invariance = c("free_means", "free_var", it), technical = list(NCYCLES = 2000))
  stopifnot(extract.mirt(mg, "converged"))
  eap_mg <- numeric(nrow(d))
  for (k in seq_along(levels(grp))) {                                  # el modelo de cada grupo guarda sus filas en orden
    e <- fscores(extract.group(mg, k), method = "EAP")[, 1]
    stopifnot(length(e) == sum(grp == levels(grp)[k])); eap_mg[grp == levels(grp)[k]] <- e }
  medias <- vapply(levels(grp), function(k) coef(mg, simplify = TRUE)[[k]]$means[1], 0)
  data.table(analisis = a, factor = fc, item = it,
             r_EAP_G2_vs_multigrupo = round(cor(d[[FACTORES[[fc]]$eap]], eap_mg), 4),
             medias_latentes = paste(sprintf("%s %.2f", levels(grp), medias), collapse = " | "),
             dR2_multigrupo = vapply(it, function(j) round(magnitud(d[[j]], eap_mg, grp, w), 4), 1))
}))))

# --- Une con la corrida original y aplica BH como una sola familia por análisis y factor
dif <- fread(file.path(SALIDAS, "nse_dif_posesiones.csv"), encoding = "UTF-8")
stopifnot(nrow(dif) == 116)
dif[, p_BH_una_familia := p.adjust(p, "BH"), by = .(analisis, factor)]
res <- merge(dif[, .(analisis, factor, item, vuelta, p, p_BH_original = p_BH, p_BH_una_familia, dR2_original = dR2_Nagelkerke,
                     DIF_original = DIF)], s2, by = c("analisis", "factor", "item"), sort = FALSE)
res[, `:=`(DIF_una_familia = !is.na(p_BH_una_familia) & p_BH_una_familia < 0.05 & dR2_original >= 0.035,
           DIF_S2 = !is.na(p_BH_una_familia) & p_BH_una_familia < 0.05 & dR2_multigrupo >= 0.035)]
res[, `:=`(p_BH_una_familia = signif(p_BH_una_familia, 3), cambia_significancia = (p_BH_original < 0.05) != (p_BH_una_familia < 0.05))]
fwrite(res, file.path(SALIDAS, "nse_dif_sens_emparejamiento.csv"))

cat("\n--- S2: resumen por análisis y factor ---\n")
print(res[, .(items = .N, sig_BH_original = sum(p_BH_original < 0.05, na.rm = TRUE), sig_BH_una_familia = sum(p_BH_una_familia < 0.05, na.rm = TRUE),
              DIF_original = sum(DIF_original), DIF_S2 = sum(DIF_S2), dR2_max_original = max(dR2_original, na.rm = TRUE),
              dR2_max_S2 = max(dR2_multigrupo, na.rm = TRUE), r_EAP = min(r_EAP_G2_vs_multigrupo)), by = .(analisis, factor)])
cat("\nÍtems con DIF en alguna versión:\n"); print(res[DIF_original | DIF_S2 | DIF_una_familia,
  .(analisis, factor, item, p_BH_una_familia, dR2_original, dR2_multigrupo, DIF_original, DIF_S2)])
cat("\nÍtems cuya significancia cambia con una sola familia de BH:", sum(res$cambia_significancia, na.rm = TRUE), "\n")
cat("H2 no cambia: se rechaza por la primera condición (salidas/inv_h2.csv), tenga o no DIF.\n")
cat("\nListo: salidas/nse_dif_sens_emparejamiento.csv (exploratorio, D-35)\n")
