# =============================================================================
# 04 MEDIAS LATENTES CON BRR - errores estándar de diseño para el paso 4.5 (D-34 punto 1)
#
# Qué hace:
#   Los ee de salidas/nse_medias_latentes.csv son los de lavaan y no reflejan el diseño por colegios. Aquí, para cada
#   análisis (zona, rural-urbana, sexo y sector), se re-estima el modelo escalar de 04_invarianza.R (mismo modelo,
#   sintaxis, datos y opciones) con cada uno de los 80 pesos replicados W_FSTURWT1-80, normalizados como el peso final,
#   partiendo de la solución con el peso final. La varianza es la de BRR con Fay 0,5: 0,05 · suma (theta_r - theta)^2
#   (utilidades_pisa.R; Technical Report, Formula 10.9, p. 198).
#   - Si una réplica no converge, se excluye y se cuenta; si fallan más de 4 de 80 (5 %), ese análisis no tiene error
#     BRR (D-34).
#   - Cada análisis terminado se guarda en datos/COL_inv_brr.rds (caché por análisis, con huella): si se interrumpe, al
#     volver a correr sigue donde iba.
#   Son 4 x 81 ajustes: tarda horas. Correrlo en segundo plano.
#
# Entradas: datos/COL_nse.rds, datos/COL_nse_tri.rds, datos/COL_cuestionario.rds (pesos replicados),
#   salidas/nse_estructura_afe.csv, salidas/inv_recodificacion.csv y salidas/nse_medias_latentes.csv (control).
# Salidas (solo agregados): salidas/nse_medias_latentes_brr.csv.
#
# Cómo correrlo (desde Proyecto_PISA/scripts/, después de 04_invarianza.R):
#   & "C:\Program Files\R\R-4.4.1\bin\Rscript.exe" 04_medias_brr.R
# =============================================================================

options(stringsAsFactors = FALSE, scipen = 999, width = 160)
suppressPackageStartupMessages({ library(data.table); library(lavaan); library(semTools) })

carpeta_script <- function() {
  arg <- grep("^--file=", commandArgs(FALSE), value = TRUE)
  if (length(arg)) return(dirname(normalizePath(sub("^--file=", "", arg))))
  if (!is.null(sys.frames()[[1]]$ofile)) return(dirname(normalizePath(sys.frames()[[1]]$ofile)))
  getwd()
}
DIR     <- carpeta_script()
DATOS   <- normalizePath(file.path(DIR, "..", "datos"))
SALIDAS <- normalizePath(file.path(DIR, "..", "salidas"))
source(file.path(DIR, "utilidades_pisa.R"))                        # preparar_f4(), huella(), REPS
reloj <- function(...) { cat(format(Sys.time(), "%H:%M:%S"), "|", ..., "\n"); flush.console() }

f4  <- preparar_f4(DATOS, SALIDAS)
nse <- f4$nse; IND <- f4$IND; ECO <- f4$ECO; CUL <- f4$CUL; ANALISIS <- f4$ANALISIS
cue <- readRDS(file.path(DATOS, "COL_cuestionario.rds"))
nse <- merge(nse, cue[, c("CNTSTUID", REPS), with = FALSE], by = "CNTSTUID", sort = FALSE)
stopifnot(nrow(nse) == 6886, !anyNA(nse[, ..REPS]))

# --- Modelo escalar como en 04_invarianza.R (líneas 94-110 y 143-144)
MODELO <- paste0("ECO =~ ", paste(ECO, collapse = " + "), "\nCUL =~ ", paste(CUL, collapse = " + "))
ESCALAR <- c("thresholds", "loadings", "intercepts")
ajustar <- function(sint, d, g, peso, inicio = NULL) {
  d[, w_norm := get(peso) * .N / sum(get(peso))]
  args <- list(model = sint, data = as.data.frame(d), group = g, group.label = levels(d[[g]]), ordered = IND,
               estimator = "WLSMV", parameterization = "theta", sampling.weights = "w_norm", missing = "pairwise")
  if (!is.null(inicio)) args$start <- inicio
  suppressWarnings(do.call(cfa, args))
}
medias <- function(f) { pe <- parameterEstimates(f, se = FALSE); gl <- lavInspect(f, "group.label")
  pe <- pe[pe$op == "~1" & pe$lhs %in% c("ECO", "CUL") & pe$group > 1, ]
  setNames(pe$est, paste(pe$lhs, gl[pe$group], sep = "|")) }

CACHE <- file.path(DATOS, "COL_inv_brr.rds")
H <- huella(as.list(nse[, c("CNTSTUID", IND, "W_FSTUWT", REPS, unlist(ANALISIS)), with = FALSE]), MODELO, ESCALAR, "D-34")
hechos <- if (file.exists(CACHE)) readRDS(CACHE) else list()
if (!identical(attr(hechos, "huella_datos"), H)) hechos <- list()
attr(hechos, "huella_datos") <- H

for (a in names(ANALISIS)) {
  if (!is.null(hechos[[a]])) { reloj(a, "leído del caché"); next }
  g <- ANALISIS[[a]]; d <- nse[!is.na(get(g))]; d[, (g) := droplevels(get(g))]; setorderv(d, g)
  sint <- as.character(measEq.syntax(configural.model = MODELO, data = as.data.frame(d), ordered = IND,
                                     parameterization = "theta", ID.fac = "std.lv", ID.cat = "Wu.Estabrook.2016",
                                     group = g, group.equal = ESCALAR))
  t0 <- Sys.time(); reloj(a, "peso final")
  f0 <- ajustar(sint, d, g, "W_FSTUWT"); stopifnot(lavInspect(f0, "converged"))
  th0 <- medias(f0)
  rep_est <- matrix(NA_real_, length(REPS), length(th0), dimnames = list(REPS, names(th0)))
  for (r in seq_along(REPS)) {
    fr <- tryCatch(ajustar(sint, d, g, REPS[r], inicio = f0), error = function(e) NULL)
    if (!is.null(fr) && lavInspect(fr, "converged")) rep_est[r, ] <- medias(fr)
    if (r %% 10 == 0) reloj(a, "réplica", r, "de 80")
  }
  hechos[[a]] <- list(est = th0, rep = rep_est, minutos = round(as.numeric(Sys.time() - t0, units = "mins"), 1))
  saveRDS(hechos, CACHE)
}

# --- Errores BRR y tabla
lav <- fread(file.path(SALIDAS, "nse_medias_latentes.csv"), encoding = "UTF-8")
tab <- rbindlist(lapply(names(hechos), function(a) { h <- hechos[[a]]; ok <- rowSums(is.na(h$rep)) == 0
  rbindlist(lapply(names(h$est), function(k) { p <- strsplit(k, "|", fixed = TRUE)[[1]]
    ee <- if (sum(!ok) <= 4) sqrt(0.05 * sum((h$rep[ok, k] - h$est[[k]])^2) * 80 / sum(ok)) else NA_real_
    data.table(analisis = a, factor = p[1], grupo = p[2], diferencia = round(h$est[[k]], 3), ee_BRR = round(ee, 3),
               ic95_inf_BRR = round(h$est[[k]] - 1.96 * ee, 3), ic95_sup_BRR = round(h$est[[k]] + 1.96 * ee, 3),
               replicas_ok = sum(ok), minutos = h$minutos) })) }))
tab <- merge(tab, lav[, .(analisis, factor, grupo, referencia, diferencia_lavaan = diferencia, ee_lavaan = ee)],
             by = c("analisis", "factor", "grupo"), sort = FALSE)
tab[, razon_ee := round(ee_BRR / ee_lavaan, 2)]
stopifnot(all(abs(tab$diferencia - tab$diferencia_lavaan) < 0.002))     # la estimación puntual es la de 04_invarianza.R
tab[, diferencia_lavaan := NULL]
setcolorder(tab, c("analisis", "factor", "grupo", "referencia"))
fwrite(tab, file.path(SALIDAS, "nse_medias_latentes_brr.csv"))
cat("\n--- 4.5 Medias latentes con error BRR (salidas/nse_medias_latentes_brr.csv) ---\n"); print(tab)
cat("\nNota: si fallan réplicas, la suma se reescala a 80 (se reporta replicas_ok); con más de 4 fallas no hay error BRR (D-34).\n")
