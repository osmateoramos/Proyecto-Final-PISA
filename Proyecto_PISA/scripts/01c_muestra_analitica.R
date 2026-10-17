# =============================================================================
# 01c MUESTRA ANALITICA - PISA 2022 Colombia (F1, paso 1.5; incluye la unión del paso 1.1)
#
# Qué hace:
#   1. Une datos/COL_cuestionario.rds (01b: NSE, pesos, PV, zona, sector) con
#      datos/COL_cognitivo.rds (01a: ítems y estados D-13) por CNTSTUID.
#   2. Marca la muestra analítica según D-14 (Vault_PISA2022/03 Registro de decisiones.md):
#      con ESCS y con al menos 10 ítems de matemáticas vistos, donde «visto» = respondido u omitido.
#      La definición de la revisión del 29/09 (tiempo válido) se calcula como control.
#   3. Compara la media de matemáticas de incluidos y excluidos (10 PV + BRR, D-14 / D-15),
#      separando a los excluidos por motivo.
#   4. Guarda datos/COL_analitica.rds con TODOS los estudiantes y la marca `incluido`: los análisis
#      filtran por esa marca, pero las cifras poblacionales usan los 7.804 con sus pesos.
#
# Salidas (solo agregados): salidas/conteos_muestra.csv y salidas/comparacion_incluidos_excluidos.csv
#
# Cómo correrlo (desde Proyecto_PISA/scripts/, después de 01a y 01b):
#   & "C:\Program Files\R\R-4.4.1\bin\Rscript.exe" 01c_muestra_analitica.R
# =============================================================================

options(stringsAsFactors = FALSE, scipen = 999)
suppressPackageStartupMessages(library(data.table))

carpeta_script <- function() {
  arg <- grep("^--file=", commandArgs(FALSE), value = TRUE)
  if (length(arg)) return(dirname(normalizePath(sub("^--file=", "", arg))))
  if (!is.null(sys.frames()[[1]]$ofile)) return(dirname(normalizePath(sys.frames()[[1]]$ofile)))
  getwd()
}
DIR     <- carpeta_script()                                        # Proyecto_PISA/scripts
DATOS   <- normalizePath(file.path(DIR, "..", "datos"))
SALIDAS <- normalizePath(file.path(DIR, "..", "salidas"))
source(file.path(DIR, "utilidades_pisa.R"))                        # estimar_pv(), media_w()
for (f in c("COL_cuestionario.rds", "COL_cognitivo.rds"))
  if (!file.exists(file.path(DATOS, f))) stop("Falta datos/", f, ": correr antes 01a y 01b")

# =============================================================================
# 1. UNIR (paso 1.1)
# =============================================================================
cue <- readRDS(file.path(DATOS, "COL_cuestionario.rds"))
cog <- readRDS(file.path(DATOS, "COL_cognitivo.rds"))
stopifnot(nrow(cue) == 7804, nrow(cog) == 7804, !anyDuplicated(cue$CNTSTUID), !anyDuplicated(cog$CNTSTUID),
          setequal(cue$CNTSTUID, cog$CNTSTUID))
comunes <- setdiff(intersect(names(cue), names(cog)), "CNTSTUID")
cat("Columnas en ambos cachés (se toman del cuestionario):", paste(comunes, collapse = ", "), "\n")
chk <- merge(cue[, c("CNTSTUID", comunes), with = FALSE], cog[, c("CNTSTUID", comunes), with = FALSE], by = "CNTSTUID")
for (v in comunes) stopifnot(isTRUE(all.equal(chk[[paste0(v, ".x")]], chk[[paste0(v, ".y")]], check.attributes = FALSE)))
u <- merge(cue, cog[, !comunes, with = FALSE], by = "CNTSTUID")
stopifnot(nrow(u) == 7804)
cat("Unión:", nrow(u), "estudiantes x", ncol(u), "columnas\n")

# =============================================================================
# 2. MUESTRA ANALITICA (D-14)
# =============================================================================
u[, con_escs  := !is.na(ESCS)]
u[, n_vistos  := n_respondido + n_omitido]                         # D-14: respondido u omitido
u[, vistos10  := n_vistos >= 10]
u[, vistos10_tt := n_tt_valido >= 10]                               # control: definición de la revisión 29/09
u[, incluido  := con_escs & vistos10]
u[, motivo := factor(fcase(incluido, "incluido",
                           !con_escs & vistos10, "excluido: sin ESCS",
                           con_escs & !vistos10, "excluido: menos de 10 vistos",
                           default = "excluido: sin ESCS y menos de 10 vistos"),
                     levels = c("incluido", "excluido: sin ESCS", "excluido: menos de 10 vistos",
                                "excluido: sin ESCS y menos de 10 vistos"))]

# Control «Listo cuando» de la F1: reproducir los conteos de la revisión del 29/09
stopifnot(sum(u$con_escs) == 7459, sum(u$vistos10_tt) == 7222)

pct_w <- function(g) round(100 * sum(u$W_FSTUWT[g]) / sum(u$W_FSTUWT), 2)
conteos <- data.table(
  conjunto = c("Total Colombia", "Con ESCS",
               ">= 10 ítems con tiempo válido (revisión 29/09, control)",
               ">= 10 ítems vistos (D-14: respondido u omitido)",
               "Con ESCS y >= 10 con tiempo válido (control)",
               "Muestra analítica: con ESCS y >= 10 vistos (D-14)"),
  n = c(nrow(u), sum(u$con_escs), sum(u$vistos10_tt), sum(u$vistos10),
        sum(u$con_escs & u$vistos10_tt), sum(u$incluido)),
  pct_poblacion = c(100, pct_w(u$con_escs), pct_w(u$vistos10_tt), pct_w(u$vistos10),
                    pct_w(u$con_escs & u$vistos10_tt), pct_w(u$incluido)))
conteos <- rbind(conteos, u[, .(conjunto = paste("Motivo:", motivo), n = .N,
                               pct_poblacion = round(100 * sum(W_FSTUWT) / sum(u$W_FSTUWT), 2)),
                            by = motivo][order(motivo), .(conjunto, n, pct_poblacion)])
fwrite(conteos, file.path(SALIDAS, "conteos_muestra.csv"))

# =============================================================================
# 3. INCLUIDOS VS EXCLUIDOS (media de matemáticas, 10 PV + BRR)
# =============================================================================
grupos <- c(list("incluidos" = u$incluido, "excluidos (todos)" = !u$incluido),
            setNames(lapply(levels(u$motivo)[-1], function(m) u$motivo == m), levels(u$motivo)[-1]))
inc <- u$incluido
comp <- rbindlist(lapply(names(grupos), function(gn) {
  g <- grupos[[gn]]
  m <- estimar_pv(u, function(y, w) media_w(y, w, g))
  dif <- if (gn == "incluidos") c(est = NA, ee = NA) else
    estimar_pv(u, function(y, w) media_w(y, w, g) - media_w(y, w, inc))   # dentro de cada PV y réplica
  data.table(grupo = gn, n = sum(g), media_mat = round(m[["est"]], 1), ee = round(m[["ee"]], 1),
             dif_vs_incluidos = round(dif[["est"]], 1), ee_dif = round(dif[["ee"]], 1),
             z = round(dif[["est"]] / dif[["ee"]], 2))
}))
fwrite(comp, file.path(SALIDAS, "comparacion_incluidos_excluidos.csv"))

saveRDS(u, file.path(DATOS, "COL_analitica.rds"), compress = TRUE)

# =============================================================================
# 4. RESUMEN EN CONSOLA
# =============================================================================
cat("\n--- Conteos (salidas/conteos_muestra.csv) ---\n"); print(conteos)
cat("\n--- Media de matemáticas: incluidos vs excluidos (salidas/comparacion_incluidos_excluidos.csv) ---\n")
print(comp)
cat("\nListo: datos/COL_analitica.rds (7.804 estudiantes, marca `incluido`) y las dos salidas.\n")
