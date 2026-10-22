# =============================================================================
# EXPLORACION PREVIA A 04 - Grupos de la invarianza del NSE (Colombia, PISA 2022)
#
# Para qué: decidir cómo se hace la F4 (O2, H2) ANTES de estimar cualquier modelo de invarianza
# (ver el aviso de la F4 en Vault_PISA2022/07 Plan de desarrollo PISA 2022.md, D-22 y D-23).
# No estima modelos: solo cuenta estudiantes por grupo y por categoría de cada indicador.
#
# Qué hace (sobre datos/COL_nse.rds, salida de 03_nse_medicion.R; 29 indicadores ya recodificados):
#   1. Tamaño de cada grupo (zona, sexo, sector) en la muestra completa (6.886) y en cada mitad,
#      sin ponderar y con el % ponderado; cuántos no tienen dato de zona o de sector.
#   2. Para cada indicador, grupo y categoría: número de respuestas. Para cada indicador y variable
#      de grupo: la categoría con menos respuestas en el grupo más chico (para saber si alguna queda
#      vacía o casi vacía, lo que impide estimar sus umbrales en ese grupo).
#
# Salidas (solo agregados, Ley 1581): salidas/inv_grupos_n.csv, salidas/inv_categorias_grupo.csv
#
# Cómo correrlo (desde Proyecto_PISA/scripts/, después de 03_nse_medicion.R):
#   & "C:\Program Files\R\R-4.4.1\bin\Rscript.exe" 04_explorar_grupos.R
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
if (!file.exists(file.path(DATOS, "COL_nse.rds"))) stop("Falta datos/COL_nse.rds: correr antes 03_nse_medicion.R")

nse <- readRDS(file.path(DATOS, "COL_nse.rds"))
fac <- attr(nse, "factores"); IND <- c(fac$economico, fac$cultural)
stopifnot(nrow(nse) == 6886, length(IND) == 29)
GRUPOS <- c("zona", "sexo", "sector")
MUESTRAS <- list(completa = nse, confirmacion = nse[mitad == "confirmacion"], exploracion = nse[mitad == "exploracion"])

# --- 1. Tamaño de cada grupo
grupos_n <- rbindlist(lapply(names(MUESTRAS), function(mu) { d <- MUESTRAS[[mu]]
  rbindlist(lapply(GRUPOS, function(g) {
    d[, .(n = .N, peso = sum(W_FSTUWT)), by = .(nivel = as.character(get(g)))][
      , .(muestra = mu, grupo = g, nivel = fifelse(is.na(nivel), "(sin dato)", nivel), n,
          pct_ponderado = round(100 * peso / sum(peso), 1))] })) }))
fwrite(grupos_n, file.path(SALIDAS, "inv_grupos_n.csv"))

# --- 2. Respuestas por indicador, grupo y categoría (sin ponderar; solo estudiantes con dato del grupo)
cats <- rbindlist(lapply(names(MUESTRAS)[1:2], function(mu) { d <- MUESTRAS[[mu]]
  rbindlist(lapply(GRUPOS, function(g) {
    dd <- d[!is.na(get(g))]
    rbindlist(lapply(IND, function(v) {
      k <- sort(unique(na.omit(d[[v]])))
      t <- dd[!is.na(get(v)), .N, by = .(nivel = as.character(get(g)), categoria = get(v))]
      todo <- CJ(nivel = unique(as.character(dd[[g]])), categoria = k)       # incluye las celdas vacías (0)
      t <- merge(todo, t, by = c("nivel", "categoria"), all.x = TRUE); t[is.na(N), N := 0L]
      t[, .(muestra = mu, grupo = g, item = v, nivel, categoria, n = N)] })) })) }))
fwrite(cats, file.path(SALIDAS, "inv_categorias_grupo.csv"))

minimos <- cats[, .(min_n = min(n), nivel_min = nivel[which.min(n)], categoria_min = categoria[which.min(n)]),
                by = .(muestra, grupo, item)]

# --- Resumen en consola
cat("--- 1. Tamaño de los grupos (salidas/inv_grupos_n.csv) ---\n")
print(dcast(grupos_n, grupo + nivel ~ muestra, value.var = "n"))
cat("\n% ponderado en la muestra completa:\n"); print(grupos_n[muestra == "completa", .(grupo, nivel, n, pct_ponderado)])
cat("\n--- 2. Categoría con menos respuestas en el grupo más chico (salidas/inv_categorias_grupo.csv) ---\n")
for (mu in c("completa", "confirmacion")) for (g in GRUPOS) {
  m <- minimos[muestra == mu & grupo == g]
  cat(sprintf("\n%s | %s: celdas vacías = %d ítems; < 10 respuestas = %d; < 20 = %d; < 30 = %d\n", mu, g,
              sum(m$min_n == 0), sum(m$min_n < 10), sum(m$min_n < 20), sum(m$min_n < 30)))
  print(m[min_n < 30][order(min_n), .(item, min_n, nivel_min, categoria_min)])
}
