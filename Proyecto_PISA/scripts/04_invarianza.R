# =============================================================================
# 04 INVARIANZA - PISA 2022 Colombia (F4, O2, H2; pasos 4.1 a 4.5)
#
# Decisiones: D-24 (modelo que pasa de la G2) y D-25 (reglas de la F4), en
#   Vault_PISA2022/03 Registro de decisiones.md.
# Entrada: datos/COL_nse.rds (03_nse_medicion.R), salidas/nse_estructura_afe.csv (3.2) y
#   datos/COL_nse_tri.rds (EAP del modelo 2D del AFE, 03_nse_tri.R).
#
# Qué hace (muestra completa, 6.886; D-25 punto 1):
#   0. Une las categorías con < 10 respuestas en algún grupo de zona, sexo o sector (D-25 punto 3).
#   1. 4.1: el AFC del AFE (D-24) en cada grupo por separado.
#   2. 4.2: secuencia configural -> umbrales -> cargas -> interceptos (Wu y Estabrook, theta) en 4 análisis:
#      zona con 3 grupos, H2 (rural vs urbana), sexo y sector. Un paso se sostiene si el CFI no empeora más de
#      0,01 y el RMSEA no más de 0,015 frente al anterior, en versión scaled (D-25 punto 5).
#   3. 4.3: invarianza parcial: libera de a una la restricción con el mayor X2 de lavTestScore (máx. 15 por paso).
#   4. 4.4: DIF con TRI por factor (mirt::multipleGroup SIN pesos, D-26; anclas depuradas en 2 vueltas, BH 5 %)
#      y magnitud con el ΔR² de Nagelkerke, con pesos, de una regresión logística ordinal sobre la EAP del factor
#      (corte 0,035).
#   5. 4.5: medias latentes con el nivel de invarianza que se sostenga.
#   6. H2 (D-25 punto 8).
#
# Salidas (solo agregados): salidas/inv_recodificacion.csv, invarianza_por_grupo.csv, invarianza_tabla.csv,
#   nse_items_no_invariantes.csv, nse_dif_posesiones.csv, nse_medias_latentes.csv e inv_h2.csv.
# Cachés (no van a Git): datos/COL_inv_cfa.rds, COL_inv_dif.rds y COL_inv_dif_parcial.rds.
#   $env:REHACER_INV = "1" rehace todo; $env:REHACER_DIF = "1" rehace solo el DIF.
#
# Cómo correrlo (desde Proyecto_PISA/scripts/, después de 03_nse_tri.R). Tarda bastante (DIF ítem por ítem):
#   & "C:\Program Files\R\R-4.4.1\bin\Rscript.exe" 04_invarianza.R
# =============================================================================

options(stringsAsFactors = FALSE, scipen = 999, width = 160)
suppressPackageStartupMessages({ library(data.table); library(lavaan); library(semTools); library(mirt); library(MASS) })

carpeta_script <- function() {
  arg <- grep("^--file=", commandArgs(FALSE), value = TRUE)
  if (length(arg)) return(dirname(normalizePath(sub("^--file=", "", arg))))
  if (!is.null(sys.frames()[[1]]$ofile)) return(dirname(normalizePath(sys.frames()[[1]]$ofile)))
  getwd()
}
DIR     <- carpeta_script()
DATOS   <- normalizePath(file.path(DIR, "..", "datos"))
SALIDAS <- normalizePath(file.path(DIR, "..", "salidas"))
for (f in c("COL_nse.rds", "COL_nse_tri.rds")) if (!file.exists(file.path(DATOS, f))) stop("Falta datos/", f)
REHACER <- Sys.getenv("REHACER_INV") == "1"
reloj <- function(...) cat(format(Sys.time(), "%H:%M:%S"), "|", ..., "\n")

nse <- readRDS(file.path(DATOS, "COL_nse.rds"))
tri <- readRDS(file.path(DATOS, "COL_nse_tri.rds"))
fac <- attr(nse, "factores"); IND <- c(fac$economico, fac$cultural)
est_afe <- fread(file.path(SALIDAS, "nse_estructura_afe.csv"), encoding = "UTF-8")
CUL <- est_afe[factor_AFE == "cultural", item]; ECO <- setdiff(IND, CUL)          # estructura de D-24
stopifnot(nrow(nse) == 6886, length(ECO) == 19, length(CUL) == 10, identical(nse$CNTSTUID, tri$CNTSTUID))
nse[, `:=`(eap_ECO = tri$eap_AFE_ECO, eap_CUL = tri$eap_AFE_CUL)]

# Grupos (D-25 punto 2): la primera categoría de cada uno es el grupo de referencia de las medias latentes
nse[, zona3 := factor(fcase(zona == "Urbana (>15 mil)", "Urbana", zona == "Pueblo (3-15 mil)", "Pueblo",
                            zona == "Rural (<3.000)", "Rural"), levels = c("Urbana", "Pueblo", "Rural"))]
nse[, rural_urbana := factor(fcase(zona3 == "Urbana", "Urbana", zona3 == "Rural", "Rural"), levels = c("Urbana", "Rural"))]
nse[, sexo2 := factor(as.character(sexo), levels = c("Mujer", "Hombre"))]
nse[, sector2 := factor(as.character(sector), levels = c("Público", "Privado"))]
ANALISIS <- list(zona = "zona3", H2_rural_urbana = "rural_urbana", sexo = "sexo2", sector = "sector2")
VARS_RECOD <- c("zona3", "sexo2", "sector2")        # grupos que cuentan para la regla de las categorías

# =============================================================================
# 0. CATEGORÍAS ESCASAS (D-25 punto 3): < 10 respuestas en algún grupo -> se une con la vecina hacia el centro
# =============================================================================
MIN_N <- 10
recod <- list()
for (v in IND) {
  x <- nse[[v]]; orig <- x
  repeat {
    k <- sort(unique(na.omit(x)))
    cuenta <- rbindlist(lapply(VARS_RECOD, function(g) { t <- table(factor(x[!is.na(nse[[g]])], levels = k), nse[[g]][!is.na(nse[[g]])])
      data.table(categoria = k, minimo = apply(t, 1, min)) }))[, .(minimo = min(minimo)), by = categoria]
    if (all(cuenta$minimo >= MIN_N)) break
    centro <- mean(range(k))
    mala <- cuenta[minimo < MIN_N][order(-abs(categoria - centro))][1, categoria]   # la más extrema primero
    vecina <- if (mala > centro) max(k[k < mala]) else min(k[k > mala])
    x[!is.na(x) & x == mala] <- vecina
    x <- match(x, sort(unique(na.omit(x)))) - 1                                     # vuelve a 0..k-1
  }
  if (!identical(as.numeric(orig), as.numeric(x)))
    recod[[v]] <- data.table(item = v, categoria_F3 = sort(unique(na.omit(orig))))[
      , categoria_F4 := vapply(categoria_F3, function(c0) unique(x[!is.na(orig) & orig == c0])[1], numeric(1))]
  nse[, (v) := x]
}
tabla_recod <- rbindlist(recod)
CAMBIADOS <- unique(tabla_recod$item)
if (!setequal(CAMBIADOS, c("ST254Q02JA", "ST251Q01JA", "HISCED_c")))
  stop("La regla de < 10 cambió otros ítems que los previstos en D-25: ", paste(CAMBIADOS, collapse = ", "))
fwrite(tabla_recod, file.path(SALIDAS, "inv_recodificacion.csv"))
reloj("Categorías unidas (D-25 punto 3):", paste(CAMBIADOS, collapse = ", "))

MODELO <- paste0("ECO =~ ", paste(ECO, collapse = " + "), "\nCUL =~ ", paste(CUL, collapse = " + "))
pesos_norm <- function(d) d[, w_norm := W_FSTUWT * .N / sum(W_FSTUWT)]
MEDIDAS <- c("chisq.scaled", "df.scaled", "cfi.scaled", "tli.scaled", "rmsea.scaled", "srmr", "cfi.robust", "rmsea.robust")
medidas <- function(f) { m <- fitMeasures(f); as.list(round(unname(m[MEDIDAS]), 4)) |> setNames(MEDIDAS) }

ajustar_mg <- function(d, g, iguales, parcial = character()) {
  sint <- as.character(measEq.syntax(configural.model = MODELO, data = as.data.frame(d), ordered = IND,
                                     parameterization = "theta", ID.fac = "std.lv", ID.cat = "Wu.Estabrook.2016",
                                     group = g, group.equal = iguales,
                                     group.partial = if (length(parcial)) parcial else ""))
  avisos <- character()
  fit <- withCallingHandlers(
    cfa(sint, data = as.data.frame(d), group = g, group.label = levels(d[[g]]), ordered = IND, estimator = "WLSMV",
        parameterization = "theta", sampling.weights = "w_norm", missing = "pairwise"),
    warning = function(w) { avisos <<- c(avisos, conditionMessage(w)); invokeRestart("muffleWarning") })
  attr(fit, "avisos") <- unique(avisos); fit
}
PASOS <- list(configural = "", umbrales = "thresholds", cargas = c("thresholds", "loadings"),
              interceptos = c("thresholds", "loadings", "intercepts"))
OP_PASO <- c(umbrales = "|", cargas = "=~", interceptos = "~1")
se_sostiene <- function(a, b) (b$cfi.scaled - a$cfi.scaled) >= -0.01 & (b$rmsea.scaled - a$rmsea.scaled) <= 0.015

# =============================================================================
# 1-3. AFC POR GRUPO, SECUENCIA DE INVARIANZA E INVARIANZA PARCIAL
# =============================================================================
CACHE_CFA <- file.path(DATOS, "COL_inv_cfa.rds")
# Los cachés guardan la huella (md5) de lo que entra al análisis: si cambian COL_nse.rds o COL_nse_tri.rds, o el
# modelo, se rehacen en vez de usar resultados viejos (observación 4 de Brayan sobre la F4, PR #12).
huella <- function(...) { f <- tempfile(); on.exit(unlink(f))
  writeBin(serialize(list(...), NULL, version = 3), f); unname(tools::md5sum(f)) }
HUELLA_CFA <- huella(as.list(nse), MODELO)
usar_cfa <- file.exists(CACHE_CFA) && !REHACER
if (usar_cfa) {
  res_cfa <- readRDS(CACHE_CFA)
  usar_cfa <- identical(attr(res_cfa, "huella_datos"), HUELLA_CFA)
  if (!usar_cfa) reloj("El caché", basename(CACHE_CFA), "no corresponde a los datos actuales: se rehace")
}
if (usar_cfa) {
  reloj("AFC e invarianza leídos del caché", basename(CACHE_CFA))
} else {
  # --- 4.1 Cada grupo por separado
  por_grupo <- rbindlist(lapply(c("zona3", "sexo2", "sector2"), function(g) rbindlist(lapply(levels(nse[[g]]), function(nv) {
    d <- pesos_norm(nse[!is.na(get(g)) & get(g) == nv]); reloj("4.1", g, nv, "n =", nrow(d))
    f <- cfa(MODELO, data = as.data.frame(d), ordered = IND, estimator = "WLSMV", std.lv = TRUE,
             sampling.weights = "w_norm", missing = "pairwise")
    c(list(grupo = g, nivel = nv, n = nrow(d), convergio = lavInspect(f, "converged")), medidas(f)) }))))

  secuencia <- list(); parciales <- list(); finales <- list()
  for (a in names(ANALISIS)) {
    g <- ANALISIS[[a]]; d <- pesos_norm(nse[!is.na(get(g))]); d[, (g) := droplevels(get(g))]
    setorderv(d, g)    # lavaan toma los grupos en el orden en que aparecen: el de referencia (1.er nivel) va primero
    # --- 4.2 Secuencia completa, sin liberar nada (de aquí sale H2)
    fits <- list()
    for (p in names(PASOS)) { reloj("4.2", a, p); fits[[p]] <- ajustar_mg(d, g, PASOS[[p]]) }
    tab <- rbindlist(lapply(names(fits), function(p) c(list(analisis = a, paso = p, n = nrow(d),
                       convergio = lavInspect(fits[[p]], "converged")), medidas(fits[[p]]),
                       list(avisos = paste(attr(fits[[p]], "avisos"), collapse = " / ")))))
    tab[, `:=`(dCFI = round(cfi.scaled - shift(cfi.scaled), 4), dRMSEA = round(rmsea.scaled - shift(rmsea.scaled), 4))]
    tab[, se_sostiene := fifelse(paso == "configural", NA, dCFI >= -0.01 & dRMSEA <= 0.015)]
    secuencia[[a]] <- tab
    # --- 4.3 Invarianza parcial desde el primer paso que no se sostiene
    libres <- character(); previo <- fits[["configural"]]; final <- NULL
    for (p in names(PASOS)[-1]) {
      f <- if (length(libres)) ajustar_mg(d, g, PASOS[[p]], libres) else fits[[p]]
      k <- 0
      while (!se_sostiene(medidas(previo), medidas(f)) && k < 15) {
        ts <- lavTestScore(f)$uni; pt <- parTable(f)
        ts$param <- vapply(ts$lhs, function(l) { r <- pt[pt$plabel == l, ][1, ]
          if (r$op == "~1") paste(r$lhs, "~ 1") else paste(r$lhs, r$op, r$rhs) }, "")
        ts$op <- vapply(ts$lhs, function(l) pt$op[pt$plabel == l][1], "")
        ts <- ts[ts$op == OP_PASO[[p]] & !ts$param %in% libres, ]
        if (!nrow(ts)) break
        elegido <- ts[which.max(ts$X2.scaled), ]
        libres <- c(libres, elegido$param); k <- k + 1
        reloj("4.3", a, p, "libera", elegido$param)
        f <- ajustar_mg(d, g, PASOS[[p]], libres); m <- medidas(f); m0 <- medidas(previo)
        parciales[[length(parciales) + 1]] <- data.table(analisis = a, paso = p, orden = k, parametro = elegido$param,
          X2_scaled = round(elegido$X2.scaled, 1), cfi.scaled = m$cfi.scaled, rmsea.scaled = m$rmsea.scaled,
          dCFI = round(m$cfi.scaled - m0$cfi.scaled, 4), dRMSEA = round(m$rmsea.scaled - m0$rmsea.scaled, 4),
          se_sostiene = se_sostiene(m0, m))
      }
      if (!se_sostiene(medidas(previo), medidas(f))) { final <- paste("no se sostiene:", p); break }
      previo <- f
    }
    if (is.null(final)) final <- if (length(libres)) sprintf("interceptos parcial (%d liberados)", length(libres)) else
                                   "interceptos (total)"
    finales[[a]] <- list(fit = previo, nivel = final, libres = libres)
  }
  # --- 4.5 Medias latentes con el modelo final (solo si se sostiene la invarianza escalar, total o parcial)
  medias <- rbindlist(lapply(names(finales), function(a) { fz <- finales[[a]]
    escalar <- !grepl("^no se sostiene", fz$nivel)
    pe <- parameterEstimates(fz$fit); gl <- lavInspect(fz$fit, "group.label")
    pe <- pe[pe$op == "~1" & pe$lhs %in% c("ECO", "CUL") & pe$group > 1, ]
    data.table(analisis = a, nivel_invarianza = fz$nivel, factor = pe$lhs, grupo = gl[pe$group], referencia = gl[1],
               diferencia = round(pe$est, 3), ee = round(pe$se, 3), ic95_inf = round(pe$ci.lower, 3),
               ic95_sup = round(pe$ci.upper, 3), comparable = escalar) }))
  res_cfa <- list(por_grupo = por_grupo, secuencia = rbindlist(secuencia, fill = TRUE),
                  parciales = rbindlist(parciales), medias = medias,
                  niveles = rbindlist(lapply(names(finales), function(a) data.table(analisis = a, nivel = finales[[a]]$nivel,
                                                                                     liberados = length(finales[[a]]$libres)))))
  attr(res_cfa, "huella_datos") <- HUELLA_CFA
  saveRDS(res_cfa, CACHE_CFA)
}
fwrite(res_cfa$por_grupo, file.path(SALIDAS, "invarianza_por_grupo.csv"))
fwrite(res_cfa$secuencia, file.path(SALIDAS, "invarianza_tabla.csv"))
fwrite(if (nrow(res_cfa$parciales)) res_cfa$parciales else data.table(analisis = character(), nota = "no hizo falta"),
       file.path(SALIDAS, "nse_items_no_invariantes.csv"))
fwrite(res_cfa$medias, file.path(SALIDAS, "nse_medias_latentes.csv"))

# =============================================================================
# 4. DIF CON TRI POR FACTOR (D-25 punto 7)
# =============================================================================
CACHE_DIF <- file.path(DATOS, "COL_inv_dif.rds")
nagelkerke <- function(m, m0, n) (1 - exp((2 / n) * (as.numeric(logLik(m0)) - as.numeric(logLik(m))))) /
                                 (1 - exp((2 / n) * as.numeric(logLik(m0))))
magnitud <- function(y, eap, g, w) {           # ΔR² de Nagelkerke: (EAP + grupo + EAP x grupo) frente a (EAP)
  k <- !is.na(y) & !is.na(eap) & !is.na(g); y <- y[k]; eap <- eap[k]; g <- droplevels(g[k]); w <- w[k] * sum(k) / sum(w[k])
  dd <- data.frame(y = factor(y, ordered = TRUE), eap, g, w)
  ajusta <- function(fm) suppressWarnings(if (nlevels(dd$y) > 2) polr(fm, dd, weights = w, Hess = FALSE) else
                                            glm(fm, binomial, dd, weights = w))
  tryCatch({ m0 <- ajusta(y ~ 1); m1 <- ajusta(y ~ eap); m3 <- ajusta(y ~ eap * g)
             nagelkerke(m3, m0, nrow(dd)) - nagelkerke(m1, m0, nrow(dd)) }, error = function(e) NA_real_)
}
pars_item <- function(x) { k <- length(unique(na.omit(x))); if (k == 2) c("a1", "d") else c("a1", paste0("d", 1:(k - 1))) }
# D-26: la prueba TRI va SIN pesos. DIF() de mirt 1.46.1 re-estima cada modelo sin survey.weights, y con pesos la
# razón de verosimilitudes sería una pseudo-verosimilitud (D-19 punto 4). La magnitud (ΔR²) sí va con pesos.
dif_una_vuelta <- function(X, g, tipos, anclas, probar, esquema) {
  mg <- multipleGroup(X, 1, group = g, itemtype = tipos, SE = FALSE, verbose = FALSE,
                      invariance = c("free_means", "free_var", anclas), technical = list(NCYCLES = 2000))
  # Se agrupan los ítems con los mismos parámetros (mismo número de categorías) para que DIF() los pruebe juntos
  # y reparta el trabajo entre los procesos de mirtCluster.
  firma <- vapply(probar, function(j) paste(pars_item(X[[j]]), collapse = ","), "")
  rbindlist(lapply(unique(firma), function(fm) { js <- probar[firma == fm]
    r <- tryCatch(DIF(mg, which.par = strsplit(fm, ",")[[1]], scheme = esquema, items2test = match(js, colnames(X)),
                      verbose = FALSE), error = function(e) { reloj("  DIF falló:", conditionMessage(e)); NULL })
    if (is.null(r)) data.table(item = js, X2 = NA_real_, gl = NA_real_, p = NA_real_) else
      data.table(item = js, X2 = round(r[js, "X2"], 2), gl = r[js, "df"], p = r[js, "p"]) }))
}
REHACER_DIF <- REHACER || Sys.getenv("REHACER_DIF") == "1"      # rehace solo el DIF, sin repetir el AFC
# Un caché con X² negativos viene de la corrida inválida con pesos (D-26): no se usa.
invalido <- function(x) is.null(x) || !"X2" %in% names(x) || any(x$X2 < -1, na.rm = TRUE)
if (file.exists(CACHE_DIF) && !REHACER_DIF && invalido(readRDS(CACHE_DIF))) {
  reloj("El caché del DIF es de la corrida inválida con pesos (D-26): se rehace"); REHACER_DIF <- TRUE }
HUELLA_DIF <- huella(as.list(nse), as.list(tri), ECO, CUL)
if (file.exists(CACHE_DIF) && !REHACER_DIF && !identical(attr(readRDS(CACHE_DIF), "huella_datos"), HUELLA_DIF)) {
  reloj("El caché del DIF no corresponde a los datos actuales: se rehace"); REHACER_DIF <- TRUE }
if (file.exists(CACHE_DIF) && !REHACER_DIF) {
  dif <- readRDS(CACHE_DIF); reloj("DIF leído del caché", basename(CACHE_DIF))
} else {
  mirtCluster(2)                          # 2 procesos: el equipo tiene 4 núcleos y poca memoria libre
  FACTORES <- list(ECO = list(items = ECO, eap = "eap_ECO"), CUL = list(items = CUL, eap = "eap_CUL"))
  # Caché parcial: cada análisis x factor terminado se guarda, para no repetirlo si algo falla después
  CACHE_PARCIAL <- file.path(DATOS, "COL_inv_dif_parcial.rds")
  hechos <- if (file.exists(CACHE_PARCIAL) && Sys.getenv("REHACER_DIF") != "1") readRDS(CACHE_PARCIAL) else list()
  if (!identical(attr(hechos, "huella_datos"), HUELLA_DIF)) hechos <- list()   # caché parcial de otros datos
  hechos <- Filter(Negate(invalido), hechos)                     # descarta lo que venga de la corrida con pesos
  attr(hechos, "huella_datos") <- HUELLA_DIF
  dif <- rbindlist(lapply(names(ANALISIS), function(a) rbindlist(lapply(names(FACTORES), function(fc) {
    clave <- paste(a, fc)
    if (!is.null(hechos[[clave]])) { reloj("4.4", clave, "leído del caché parcial"); return(hechos[[clave]]) }
    g <- ANALISIS[[a]]; d <- nse[!is.na(get(g))]; it <- FACTORES[[fc]]$items
    # mirt quita a quien no respondió ningún ítem del factor, pero no recorta survey.weights: se quitan antes
    d <- d[rowSums(!is.na(d[, ..it])) > 0]
    X <- as.data.frame(d[, ..it]); grp <- droplevels(d[[g]]); w <- d$W_FSTUWT * nrow(d) / sum(d$W_FSTUWT)
    tipos <- ifelse(vapply(X, function(x) length(unique(na.omit(x))), 1) == 2, "2PL", "gpcm")
    reloj("4.4", a, fc, "vuelta 1 (anclas: todos los demás)")
    v1 <- dif_una_vuelta(X, grp, tipos, anclas = it, probar = it, esquema = "drop")
    v1[, p_BH := p.adjust(p, "BH")]
    reloj("    vuelta 1: X2 de", round(min(v1$X2, na.rm = TRUE), 1), "a", round(max(v1$X2, na.rm = TRUE), 1),
          "| significativos con BH:", sum(v1$p_BH < 0.05, na.rm = TRUE), "de", nrow(v1), "| sin p:", sum(is.na(v1$p)))
    if (any(v1$X2 < -1, na.rm = TRUE)) stop("X2 negativos en la vuelta 1: la prueba no es válida (ver D-26)")
    anclas <- v1[is.na(p_BH) | p_BH >= 0.05, item]
    if (length(anclas) >= 2 && length(anclas) < length(it)) {
      reloj("4.4", a, fc, "vuelta 2 (anclas depuradas:", length(anclas), ")")
      v2 <- dif_una_vuelta(X, grp, tipos, anclas = anclas, probar = setdiff(it, anclas), esquema = "add")
      v2[, p_BH := p.adjust(p, "BH")]
      final <- rbind(v1[item %in% anclas][, vuelta := 1L], v2[, vuelta := 2L])
    } else final <- v1[, vuelta := 1L]
    final[, `:=`(analisis = a, factor = fc, anclas_vuelta2 = length(anclas))]
    final[, dR2_Nagelkerke := vapply(item, function(j) round(magnitud(d[[j]], d[[FACTORES[[fc]]$eap]], grp, w), 4), 1)]
    final[, `:=`(TRI_significativo = !is.na(p_BH) & p_BH < 0.05, no_despreciable = dR2_Nagelkerke >= 0.035)]
    final[, DIF := TRI_significativo & no_despreciable]
    final[, n := nrow(d)]
    hechos[[clave]] <<- final; saveRDS(hechos, CACHE_PARCIAL)
    final }))))
  mirtCluster(remove = TRUE)
  setcolorder(dif, c("analisis", "factor", "item", "vuelta", "X2", "gl", "p", "p_BH", "dR2_Nagelkerke"))
  setattr(dif, "huella_datos", HUELLA_DIF)
  saveRDS(dif, CACHE_DIF)
}
fwrite(dif, file.path(SALIDAS, "nse_dif_posesiones.csv"))

# =============================================================================
# 6. H2 (D-25 punto 8): el paso escalar empeora (CFI > 0,01 o RMSEA > 0,015, scaled) Y hay >= 1 ítem con DIF
# =============================================================================
s <- res_cfa$secuencia[analisis == "H2_rural_urbana" & paso == "interceptos"]
empeora <- s$dCFI < -0.01 | s$dRMSEA > 0.015
items_dif <- dif[analisis == "H2_rural_urbana" & DIF == TRUE, item]
h2 <- data.table(dCFI_escalar = s$dCFI, dRMSEA_escalar = s$dRMSEA, escalar_empeora = empeora,
                 items_con_DIF = length(items_dif), cuales = paste(items_dif, collapse = ", "),
                 H2 = fifelse(empeora & length(items_dif) >= 1, "se acepta", "se rechaza"))
fwrite(h2, file.path(SALIDAS, "inv_h2.csv"))

# =============================================================================
# RESUMEN EN CONSOLA
# =============================================================================
cat("\n--- 0. Categorías unidas para la F4 (salidas/inv_recodificacion.csv) ---\n"); print(tabla_recod)
cat("\n--- 4.1 AFC en cada grupo (salidas/invarianza_por_grupo.csv) ---\n")
print(res_cfa$por_grupo[, .(grupo, nivel, n, convergio, cfi.scaled, rmsea.scaled, srmr, cfi.robust, rmsea.robust)])
cat("\n--- 4.2 Secuencia (salidas/invarianza_tabla.csv) ---\n")
print(res_cfa$secuencia[, .(analisis, paso, convergio, cfi.scaled, rmsea.scaled, srmr, dCFI, dRMSEA, se_sostiene)])
av <- res_cfa$secuencia[avisos != "", .(analisis, paso, avisos)]; if (nrow(av)) { cat("\nAvisos de lavaan:\n"); print(av) }
cat("\n--- 4.3 Invarianza parcial (salidas/nse_items_no_invariantes.csv) ---\n"); print(res_cfa$parciales)
cat("\nNivel de invarianza final por análisis:\n"); print(res_cfa$niveles)
cat("\n--- 4.4 DIF (salidas/nse_dif_posesiones.csv): ítems con DIF (TRI con BH y ΔR² >= 0,035) ---\n")
print(dif[, .(probados = .N, TRI_significativos = sum(TRI_significativo), no_despreciables = sum(no_despreciable, na.rm = TRUE),
              con_DIF = sum(DIF, na.rm = TRUE), cuales = paste(item[DIF %in% TRUE], collapse = ", ")), by = .(analisis, factor)])
cat("\nΔR² más altos:\n"); print(dif[order(-dR2_Nagelkerke)][1:10, .(analisis, factor, item, p_BH, dR2_Nagelkerke, DIF)])
cat("\n--- 4.5 Medias latentes (salidas/nse_medias_latentes.csv) ---\n"); print(res_cfa$medias)
cat("\n--- H2 (salidas/inv_h2.csv) ---\n"); print(h2)
