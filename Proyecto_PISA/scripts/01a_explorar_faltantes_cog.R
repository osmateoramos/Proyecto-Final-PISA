# =============================================================================
# EXPLORACION PREVIA A 01a - Codigos de faltante en los items de matematicas
# (Colombia, CY08MSP_STU_COG.SAV)
#
# Para que: decidir la regla omitido / no alcanzado / no administrado (D-12)
# ANTES de programar la ETL cognitiva. No construye caches ni modifica datos.
#
# Que hace:
#   1. Lee los metadatos SPSS de los items calificados (S / C) y de sus tiempos
#      (TT) con user_na = TRUE, para ver que codigos declara la OCDE.
#   2. Ubica el bloque de Colombia leyendo solo CNT y lee ese bloque.
#   3. Cruza el estado del puntaje (valido / codigo de faltante / NA del sistema)
#      con el estado del tiempo TT, sobre todas las celdas estudiante x item.
#
# Salidas (solo tablas agregadas, Ley 1581):
#   salidas/faltantes_cog_etiquetas.csv  - codigos declarados, n de items por firma
#   salidas/faltantes_cog_cruce.csv      - celdas por estado del puntaje x estado del TT
#
# Ojo: con user_na = TRUE, is.na() es TRUE tambien para los codigos de faltante
# de usuario; por eso el estado se calcula sobre el valor crudo (unclass).
#
# Correr (R 4.4.1, desde PowerShell):
#   Start-Process "C:\Program Files\R\R-4.4.1\bin\Rscript.exe" -ArgumentList "01a_explorar_faltantes_cog.R" `
#     -RedirectStandardOutput explorar_out.txt -RedirectStandardError explorar_err.txt -NoNewWindow -Wait
# =============================================================================

options(stringsAsFactors = FALSE, scipen = 999, width = 200)
suppressPackageStartupMessages({ library(data.table); library(haven) })

carpeta_script <- function() {
  arg <- grep("^--file=", commandArgs(FALSE), value = TRUE)
  if (length(arg)) return(dirname(normalizePath(sub("^--file=", "", arg))))
  if (!is.null(sys.frames()[[1]]$ofile)) return(dirname(normalizePath(sys.frames()[[1]]$ofile)))
  getwd()
}
RAIZ    <- dirname(carpeta_script())                     # Proyecto_PISA/
ARCHIVO <- file.path(RAIZ, "datos", "CY08MSP_STU_COG.SAV")
SALIDAS <- file.path(RAIZ, "salidas")
PAIS    <- "COL"
if (!file.exists(ARCHIVO)) stop("No encuentro ", ARCHIVO)
cat(R.version.string, "| haven", as.character(packageVersion("haven")), "\n")

# =============================================================================
# 1. METADATOS: codigos declarados
# =============================================================================
m0 <- read_sav(ARCHIVO, n_max = 0, user_na = TRUE)
nombres <- names(m0)
calif <- c(grep("^CMA?[0-9A-Z]+Q[0-9]+S$", nombres, value = TRUE),
           grep("^DMA?[0-9A-Z]+Q[0-9]+C$", nombres, value = TRUE))
tt <- paste0(sub("^D", "C", sub("(S|C)$", "", calif)), "TT")   # los items DM guardan su tiempo con prefijo CM
stopifnot(all(tt %in% nombres))
cat("Items calificados:", length(calif), "| todos con columna TT\n")

firma <- function(v) {
  lab <- attr(m0[[v]], "labels"); rg <- attr(m0[[v]], "na_range")
  falt <- lab[lab >= rg[1] & lab <= rg[2]]
  data.table(rango_faltante = paste(rg, collapse = "-"),
             codigos_faltante = paste(paste0(unname(falt), "=", names(falt)), collapse = "; "))
}
etiquetas <- rbindlist(lapply(c(calif, tt), function(v)
  cbind(columna = if (v %in% calif) "puntaje" else "tiempo_TT", firma(v))))[
  , .(n_columnas = .N), by = .(columna, rango_faltante, codigos_faltante)]
print(etiquetas)
fwrite(etiquetas, file.path(SALIDAS, "faltantes_cog_etiquetas.csv"))

# =============================================================================
# 2. BLOQUE DE COLOMBIA
# =============================================================================
cat("\nUbicando", PAIS, "(lectura de la columna CNT, unos minutos)...\n")
cnt   <- read_sav(ARCHIVO, col_select = "CNT")[["CNT"]]
filas <- which(cnt == PAIS); rm(cnt); invisible(gc())
if (max(filas) - min(filas) + 1 != length(filas)) stop("Las filas de ", PAIS, " no son contiguas")
cat(PAIS, ": filas", min(filas), "a", max(filas), "(", length(filas), "estudiantes )\n")
d <- read_sav(ARCHIVO, col_select = all_of(c("CNT", calif, tt)),
              skip = min(filas) - 1, n_max = length(filas), user_na = TRUE)
stopifnot(all(d$CNT == PAIS))

# =============================================================================
# 3. CRUCE: estado del puntaje x estado del tiempo
# =============================================================================
estado <- function(x) {
  r <- unclass(x); attributes(r) <- NULL; rg <- attr(x, "na_range")
  ifelse(is.na(r), "NA_sistema", ifelse(r >= rg[1] & r <= rg[2], paste0("codigo_", r), "valido"))
}
ep <- sapply(calif, function(v) estado(d[[v]]))
et <- sapply(tt,    function(v) estado(d[[v]]))
cruce <- as.data.table(table(estado_puntaje = as.vector(ep), estado_tiempo = as.vector(et)))[N > 0]
setnames(cruce, "N", "celdas")
setorder(cruce, estado_puntaje, estado_tiempo)
cat("\nCeldas estudiante x item:", nrow(d), "x", length(calif), "=", sum(cruce$celdas), "\n")
print(cruce)
fwrite(cruce, file.path(SALIDAS, "faltantes_cog_cruce.csv"))

cat("\nListo. Salidas en", SALIDAS, "\n")
