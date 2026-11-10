# =============================================================================
# 05 DIF DE MATEMÁTICAS POR NSE - paso 5.6, H3 (D-22, D-36 y D-40)
#
# Qué hace:
#   1. Grupos: cuartil bajo (Q1, focal) y alto (Q4, referencia) del NSE económico de la G2, con los cuartiles ponderados
#      de 05_explorar_items.R. Solo entran los estudiantes de Q1 y Q4.
#   2. Modelo conjunto de 1 dimensión (D-36) con los ítems de la versión (a) que tienen todas sus categorías en los dos
#      grupos; multipleGroup sin pesos (D-26), medias y varianzas libres. Se prueban los 165 ítems elegibles (D-27).
#      Vuelta 1: todos los ítems anclas, DIF(scheme = "drop"). Vuelta 2: anclas = los no significativos,
#      DIF(scheme = "add"). BH al 5 % como una sola familia por competencia sobre los valores p finales (D-35).
#   3. Magnitud con pesos (D-40): ΔMH (α_MH ponderado, 10 estratos por deciles de la EAP multigrupo de la vuelta 1) y
#      χ² de Mantel-Haenszel sin pesos en los dicotómicos (categorías del ETS); ΔR² de Nagelkerke en los de crédito parcial.
#   4. H3: primera parte, al menos 1 ítem con DIF; segunda parte, Fisher de una cola (interpretar + formular frente a
#      emplear), α = 0,05.
#   Las pruebas TRI se guardan en datos/COL_mat_dif.rds (con huella): reestimarlas tarda horas.
#   Sensibilidades de la F7 (D-45), con la variable de entorno F7_VARIANTE:
#     escs       cuartiles de ESCS en lugar del NSE económico (TRI completo; caché datos/COL_f7_dif_escs.rds)
#     sin_lineal mismos cuartiles, sin los estudiantes de la ruta lineal (MPATH; caché datos/COL_f7_dif_sin_lineal.rds)
#     d38        pesos ajustados por no respuesta dentro del colegio (D-38): cambia solo la magnitud; usa el caché TRI
#                principal porque la prueba TRI va sin pesos (D-26)
#
# Entradas: datos/COL_mat_respuestas.rds (05_tri_competencias.R), COL_nse.rds, COL_nse_tri.rds y
#   salidas/items_respuestas.csv; con F7_VARIANTE, también COL_cognitivo.rds o COL_cuestionario.rds.
# Salidas (solo agregados): salidas/mat_dif.csv, mat_dif_resumen.csv y mat_h3.csv; con F7_VARIANTE,
#   salidas/f7_dif_<variante>.csv, f7_dif_resumen_<variante>.csv y f7_h3_<variante>.csv.
#
# Cómo correrlo (desde Proyecto_PISA/scripts/):
#   & "C:\Program Files\R\R-4.4.1\bin\Rscript.exe" 05_dif_matematicas.R
#   $env:F7_VARIANTE = "escs"; & "C:\Program Files\R\R-4.4.1\bin\Rscript.exe" 05_dif_matematicas.R
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
source(file.path(DIR, "utilidades_pisa.R"))                        # huella(), magnitud_dR2()
reloj <- function(...) { cat(format(Sys.time(), "%H:%M:%S"), "|", ..., "\n"); flush.console() }

R   <- readRDS(file.path(DATOS, "COL_mat_respuestas.rds"))
nse <- readRDS(file.path(DATOS, "COL_nse.rds")); tri <- readRDS(file.path(DATOS, "COL_nse_tri.rds"))
ic  <- fread(file.path(SALIDAS, "items_respuestas.csv"), encoding = "UTF-8")    # elegibilidad (05_explorar_items.R)
stopifnot(identical(nse$CNTSTUID, tri$CNTSTUID), all(R$CNTSTUID %in% nse$CNTSTUID))
k <- match(R$CNTSTUID, nse$CNTSTUID)
W <- nse$W_FSTUWT[k]; ECO <- tri$eap_AFE_ECO[k]
VAR <- Sys.getenv("F7_VARIANTE")                                    # "" = análisis principal (D-40); si no, D-45
stopifnot(VAR %in% c("", "escs", "sin_lineal", "d38"))
if (nzchar(VAR)) reloj("Sensibilidad de la F7 (D-45):", VAR)

# --- Cuartiles ponderados del NSE económico (05_explorar_items.R, línea 88); con «escs», de ESCS (D-45)
cuartil_w <- function(x, w) { o <- order(x); cw <- cumsum(w[o]) / sum(w[o]); q <- integer(length(x)); q[o] <- pmin(4L, 1L + floor(4 * cw - 1e-9)); q }
q <- cuartil_w(if (VAR == "escs") nse$ESCS[k] else ECO, W)
sel <- q %in% c(1L, 4L)
if (VAR == "sin_lineal") {                                         # cuartiles fijos; se quitan los de la ruta lineal
  cog <- readRDS(file.path(DATOS, "COL_cognitivo.rds")); ruta <- as.character(cog$MPATH[match(R$CNTSTUID, cog$CNTSTUID)])
  stopifnot(!anyNA(ruta)); reloj("Ruta lineal excluida:", sum(ruta == "Linear"), "estudiantes de la muestra analítica")
  sel <- sel & ruta != "Linear"
}
if (VAR == "d38") {                                                 # peso final ajustado por colegio (D-38)
  cue <- readRDS(file.path(DATOS, "COL_cuestionario.rds"))
  W <- W * factor_d38(cue, R$CNTSTUID, "W_FSTUWT")[, 1]
}
grp <- factor(ifelse(q[sel] == 4L, "Q4", "Q1"), levels = c("Q4", "Q1"))        # Q4 = referencia
Y <- R$a[sel, ]; w <- W[sel]; w <- w * length(w) / sum(w)
COMP <- R$competencia; TIPO <- setNames(R$tipo, colnames(R$a))

# --- Ítems de la calibración y elegibles (D-40 punto 2)
completo <- vapply(colnames(Y), function(j) { cats <- sort(unique(na.omit(R$a[, j])))
  all(vapply(levels(grp), function(g) setequal(sort(unique(na.omit(Y[grp == g, j]))), cats), TRUE)) }, TRUE)
ELEG <- ic[calibrable == TRUE & elegible_DIF_ECO == TRUE, item]
stopifnot(length(ELEG) == 165, all(ELEG %in% colnames(Y)))
ITEMS <- colnames(Y)[completo]
fuera_eleg <- setdiff(ELEG, ITEMS)
if (length(fuera_eleg)) reloj("Aviso: elegibles sin todas sus categorías en los dos grupos (no se prueban):", paste(fuera_eleg, collapse = ", "))
PROBAR <- intersect(ELEG, ITEMS)
X <- as.data.frame(Y[, ITEMS]); tipos <- unname(TIPO[ITEMS])
reloj("Q1:", sum(grp == "Q1"), "| Q4:", sum(grp == "Q4"), "| ítems en la calibración:", length(ITEMS), "de 232 | a probar:", length(PROBAR))

# =============================================================================
# 1. PRUEBA TRI (sin pesos), dos vueltas
# =============================================================================
pars_item <- function(j) if (TIPO[[j]] == "2PL") c("a1", "d") else c("a1", paste0("d", 1:(length(unique(na.omit(X[[j]]))) - 1)))
vuelta <- function(anclas, probar, esquema) {
  mg <- multipleGroup(X, 1, group = grp, itemtype = tipos, SE = FALSE, verbose = FALSE,
                      invariance = c("free_means", "free_var", anclas), technical = list(NCYCLES = 2000))
  stopifnot(extract.mirt(mg, "converged"))
  firma <- vapply(probar, function(j) paste(pars_item(j), collapse = ","), "")
  res <- rbindlist(lapply(unique(firma), function(fm) { js <- probar[firma == fm]
    r <- DIF(mg, which.par = strsplit(fm, ",")[[1]], scheme = esquema, items2test = match(js, ITEMS), verbose = FALSE)
    data.table(item = js, X2 = round(r[js, "X2"], 2), gl = r[js, "df"], p = r[js, "p"]) }))
  list(mg = mg, res = res)
}
CACHE <- file.path(DATOS, if (VAR %in% c("escs", "sin_lineal")) paste0("COL_f7_dif_", VAR, ".rds") else "COL_mat_dif.rds")
if (VAR == "d38" && !identical(readRDS(CACHE)$huella, huella(as.list(X), as.character(grp), tipos, PROBAR, "D-40")))
  stop("d38 debe reutilizar las pruebas TRI del análisis principal y la huella no coincide")
H <- huella(as.list(X), as.character(grp), tipos, PROBAR, "D-40")
cache <- if (file.exists(CACHE)) readRDS(CACHE) else NULL
if (!is.null(cache) && identical(cache$huella, H)) {
  reloj("Pruebas TRI leídas del caché", basename(CACHE)); v1 <- cache$v1; v2 <- cache$v2; eap_mg <- cache$eap_mg; medias <- cache$medias
} else {
  mirtCluster(2)                                      # 2 procesos: el equipo tiene 4 núcleos
  t0 <- Sys.time(); reloj("Vuelta 1: todos los ítems como anclas")
  r1 <- vuelta(ITEMS, PROBAR, "drop"); v1 <- r1$res
  v1[, p_BH := p.adjust(p, "BH"), by = .(competencia = COMP[item])]
  sig1 <- v1[p_BH < 0.05, item]
  reloj("Vuelta 1 lista:", length(sig1), "de", length(PROBAR), "significativos con BH")
  # EAP de emparejamiento: modelo de la vuelta 1, con la media de cada grupo (D-35, S2)
  eap_mg <- numeric(nrow(X))
  for (g in seq_along(levels(grp))) { e <- fscores(extract.group(r1$mg, g), method = "EAP")[, 1]
    stopifnot(length(e) == sum(grp == levels(grp)[g])); eap_mg[grp == levels(grp)[g]] <- e }
  cf <- coef(r1$mg, simplify = TRUE); medias <- vapply(levels(grp), function(g) cf[[g]]$means[1], 0)
  v2 <- NULL
  if (length(sig1) && length(sig1) < length(ITEMS) - 1) {
    reloj("Vuelta 2: anclas depuradas (", length(ITEMS) - length(sig1), ")")
    v2 <- vuelta(setdiff(ITEMS, sig1), sig1, "add")$res
  }
  mirtCluster(remove = TRUE)
  saveRDS(list(huella = H, v1 = v1, v2 = v2, eap_mg = eap_mg, medias = medias, minutos = round(as.numeric(Sys.time() - t0, units = "mins"), 1)), CACHE)
}
final <- if (is.null(v2)) copy(v1)[, vuelta := 1L] else
  rbind(v1[!item %in% v2$item, .(item, X2, gl, p)][, vuelta := 1L], v2[, vuelta := 2L])
final[, competencia := COMP[item]]
final[, p_BH := p.adjust(p, "BH"), by = competencia]                # una sola familia por competencia (D-35)

# =============================================================================
# 2. MAGNITUD (con pesos) Y CLASIFICACIÓN
# =============================================================================
estrato <- cut(eap_mg, quantile(eap_mg, seq(0, 1, 0.1)), include.lowest = TRUE, labels = FALSE)
mh <- function(y) {                                 # Q4 referencia, Q1 focal; y en 0/1
  ok <- !is.na(y); y <- y[ok]; g <- grp[ok]; s <- estrato[ok]; ww <- w[ok] * sum(ok) / sum(w[ok])
  num <- 0; den <- 0
  for (h in unique(s)) { i <- s == h; Tk <- sum(ww[i])
    A <- sum(ww[i & g == "Q4" & y == 1]); B <- sum(ww[i & g == "Q4" & y == 0])
    C <- sum(ww[i & g == "Q1" & y == 1]); D <- sum(ww[i & g == "Q1" & y == 0])
    num <- num + A * D / Tk; den <- den + B * C / Tk }
  tab <- table(factor(y, 0:1), g, s); tab <- tab[, , apply(tab, 3, function(m) sum(m) >= 2 && all(rowSums(m) > 0) && all(colSums(m) > 0)), drop = FALSE]
  p <- tryCatch(mantelhaen.test(tab)$p.value, error = function(e) NA_real_)
  c(delta = -2.35 * log(num / den), p = p)
}
mag <- rbindlist(lapply(final$item, function(j) {
  y <- X[[j]]
  if (TIPO[[j]] == "2PL") { r <- mh(y); d <- unname(r["delta"]); pm <- unname(r["p"])
    cat_ets <- if (is.na(pm) || pm >= 0.05 || abs(d) <= 1) "A" else if (abs(d) <= 1.5) "B" else "C"
    data.table(item = j, tipo = "2PL", delta_MH = round(d, 3), p_MH = signif(pm, 3), categoria_ETS = cat_ets, dR2_Nagelkerke = NA_real_,
               no_despreciable = cat_ets %in% c("B", "C"))
  } else { d2 <- magnitud_dR2(y, eap_mg, grp, w)
    data.table(item = j, tipo = "gpcm", delta_MH = NA_real_, p_MH = NA_real_, categoria_ETS = NA_character_,
               dR2_Nagelkerke = round(d2, 4), no_despreciable = !is.na(d2) && d2 >= 0.035) } }))
dif <- merge(final, mag, by = "item", sort = FALSE)
dif[, n_Q1 := vapply(item, function(j) sum(!is.na(X[[j]][grp == "Q1"])), 0L)]
dif[, n_Q4 := vapply(item, function(j) sum(!is.na(X[[j]][grp == "Q4"])), 0L)]
dif[, `:=`(TRI_significativo = !is.na(p_BH) & p_BH < 0.05)]
dif[, DIF := TRI_significativo & no_despreciable]
dif[, favorece := fifelse(!DIF, "", fifelse(tipo == "2PL", fifelse(delta_MH < 0, "Q4 (NSE alto)", "Q1 (NSE bajo)"), "ver curvas"))]
dif[, `:=`(p = signif(p, 3), p_BH = signif(p_BH, 3))]
setcolorder(dif, c("competencia", "item", "tipo", "n_Q1", "n_Q4", "vuelta", "X2", "gl", "p", "p_BH", "delta_MH", "p_MH",
                   "categoria_ETS", "dR2_Nagelkerke", "TRI_significativo", "no_despreciable", "DIF", "favorece"))
setorder(dif, competencia, item)
salida <- function(base) file.path(SALIDAS, if (nzchar(VAR)) sub("^mat_", "f7_", sub("\\.csv$", paste0("_", VAR, ".csv"), base)) else base)
fwrite(dif, salida("mat_dif.csv"))

resumen <- dif[, .(elegibles = .N, significativos_BH = sum(TRI_significativo), no_despreciables = sum(no_despreciable),
                   con_DIF = sum(DIF), pct_DIF = round(100 * mean(DIF), 1), ETS_B = sum(categoria_ETS == "B", na.rm = TRUE),
                   ETS_C = sum(categoria_ETS == "C", na.rm = TRUE)), by = competencia]
fwrite(resumen, salida("mat_dif_resumen.csv"))

# =============================================================================
# 3. H3 (09 Hipótesis preregistradas, D-22, D-40)
# =============================================================================
grupo_h3 <- fcase(dif$competencia %in% c("interpretar", "formular"), "interpretar + formular", dif$competencia == "emplear", "emplear")
tf <- table(factor(grupo_h3[!is.na(grupo_h3)], c("interpretar + formular", "emplear")), factor(dif$DIF[!is.na(grupo_h3)], c(TRUE, FALSE)))
fis <- fisher.test(tf, alternative = "greater")
parte1 <- sum(dif$DIF) >= 1
parte2 <- parte1 && fis$p.value < 0.05
h3 <- data.table(
  parte = c("1: al menos 1 ítem con DIF (BH 5 % y efecto no despreciable)", "2: más DIF en interpretar + formular que en emplear (Fisher, una cola)"),
  dato = c(sprintf("%d de %d ítems elegibles con DIF", sum(dif$DIF), nrow(dif)),
           sprintf("interpretar + formular %d de %d; emplear %d de %d; OR %.2f; p = %.3g", tf[1, 1], sum(tf[1, ]), tf[2, 1], sum(tf[2, ]),
                   unname(fis$estimate), fis$p.value)),
  se_acepta = c(parte1, parte2))
h3[, H3 := if (parte1 && parte2) "se acepta (las dos partes)" else if (parte1) "se acepta solo la primera parte" else "se rechaza"]
fwrite(h3, salida("mat_h3.csv"))

cat("\nMedias latentes del modelo de la vuelta 1 (Q4 = 0):", paste(sprintf("%s %.3f", names(medias), medias), collapse = " | "), "\n")
cat("\n--- 5.6 DIF por competencia (salidas/mat_dif_resumen.csv) ---\n"); print(resumen)
cat("\nÍtems con DIF:\n"); print(dif[DIF == TRUE, .(competencia, item, tipo, p_BH, delta_MH, categoria_ETS, dR2_Nagelkerke, favorece)])
cat("\n--- H3 (salidas/mat_h3.csv) ---\n"); print(h3)
