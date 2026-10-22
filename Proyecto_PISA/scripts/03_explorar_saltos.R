# =============================================================================
# EXPLORACION PARA D-20 - Saltos válidos del cuestionario en los indicadores del NSE, Colombia
#
# Para qué: comprobar si los faltantes de dos bloques de posesiones son saltos del cuestionario y no
# respuestas que faltan. D-12 convierte en NA todo faltante de usuario, incluido el «Valid Skip» (95).
#   - Tipos de libros (ST256): ¿se saltan para quien dice que no hay libros en casa (ST255)?
#   - Cantidad de cada dispositivo (ST254): ¿se salta para quien dice que no hay dispositivos con
#     pantalla (ST253)?
#
# Lee el bloque de Colombia de CY08MSP_STU_QQQ.SAV (columna CNT y luego col_select + skip + n_max) con
# user_na = TRUE, para conservar los códigos 95-99 y el 5 («I don't know»).
#
# Salidas (solo agregados, Ley 1581): salidas/nse_saltos_st256.csv y salidas/nse_saltos_st254.csv
#   - cruce de la pregunta filtro con el código del primer ítem del bloque;
#   - códigos de cada ítem del bloque.
#
# Cómo correrlo (desde Proyecto_PISA/scripts/; unos minutos):
#   & "C:\Program Files\R\R-4.4.1\bin\Rscript.exe" 03_explorar_saltos.R
# =============================================================================

options(stringsAsFactors = FALSE, scipen = 999, width = 180)
suppressPackageStartupMessages({ library(data.table); library(haven) })

carpeta_script <- function() {
  arg <- grep("^--file=", commandArgs(FALSE), value = TRUE)
  if (length(arg)) return(dirname(normalizePath(sub("^--file=", "", arg))))
  if (!is.null(sys.frames()[[1]]$ofile)) return(dirname(normalizePath(sys.frames()[[1]]$ofile)))
  getwd()
}
DIR     <- carpeta_script()
STU     <- normalizePath(file.path(DIR, "..", "datos", "CY08MSP_STU_QQQ.SAV"))
SALIDAS <- normalizePath(file.path(DIR, "..", "salidas"))

cnt <- read_sav(STU, col_select = "CNT")[["CNT"]]; w <- which(cnt == "COL"); rm(cnt)
if (max(w) - min(w) + 1 != length(w)) stop("Las filas de COL no son contiguas")
nombres <- names(read_sav(STU, n_max = 0))
bloques <- list(st256 = list(filtro = "ST255Q01JA", items = grep("^ST256Q[0-9]+JA$", nombres, value = TRUE)),
                st254 = list(filtro = "ST253Q01JA", items = grep("^ST254Q[0-9]+JA$", nombres, value = TRUE)))
d <- read_sav(STU, col_select = all_of(c("CNT", unlist(lapply(bloques, function(b) c(b$filtro, b$items))))),
              skip = min(w) - 1, n_max = length(w), user_na = TRUE)
stopifnot(all(d$CNT == "COL"), length(bloques$st256$items) == 8, length(bloques$st254$items) == 6)
cat("Colombia:", nrow(d), "estudiantes\n")

crudo  <- function(x) { r <- unclass(x); attributes(r) <- NULL; r }
nombre <- function(cod, etq) ifelse(is.na(cod), "NA del sistema", paste0(cod, " = ", names(etq)[match(cod, etq)]))

for (k in names(bloques)) {
  b <- bloques[[k]]; etq_f <- attr(d[[b$filtro]], "labels"); etq_i <- attr(d[[b$items[1]]], "labels")
  cruce <- as.data.table(table(fila = nombre(crudo(d[[b$filtro]]), etq_f), codigo = nombre(crudo(d[[b$items[1]]]), etq_i)))[N > 0]
  cruce[, tabla := paste(b$filtro, "x", b$items[1])]
  por_item <- rbindlist(lapply(b$items, function(v) as.data.table(table(codigo = nombre(crudo(d[[v]]), etq_i)))[, fila := v]))
  por_item[, tabla := paste("códigos de cada ítem", substr(b$items[1], 1, 5))]
  fwrite(rbind(cruce[, .(tabla, fila, codigo, n = N)], por_item[, .(tabla, fila, codigo, n = N)]),
         file.path(SALIDAS, paste0("nse_saltos_", k, ".csv")))
  cat("\n===", b$filtro, "(filtro) x", b$items[1], "===\n")
  print(dcast(cruce, fila ~ codigo, value.var = "N", fill = 0))
  cat("Celdas de los", length(b$items), "ítems", substr(b$items[1], 1, 5), "por código:\n")
  print(por_item[, .(n = sum(N)), by = codigo][order(codigo)])
}
cat("\nListo: salidas/nse_saltos_st256.csv y salidas/nse_saltos_st254.csv\n")
