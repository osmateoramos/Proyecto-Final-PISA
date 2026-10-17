# =============================================================================
# EXPLORACION PARA D-20 - Saltos válidos de los tipos de libros (ST256), Colombia
#
# Para qué: comprobar si los faltantes de ST256 son saltos del cuestionario (quien dice que no hay libros
# en casa no ve las preguntas de tipos de libros) o respuestas que faltan. D-12 convierte en NA todo
# faltante de usuario, incluido el «Valid Skip» (95).
#
# Lee el bloque de Colombia de CY08MSP_STU_QQQ.SAV (columna CNT y luego col_select + skip + n_max) con
# user_na = TRUE, para conservar los códigos 95-99 y el 5 («I don't know»).
#
# Salida (solo agregados, Ley 1581): salidas/nse_saltos_st256.csv
#   - cruce de ST255 (libros en casa) con el código de ST256Q01JA;
#   - códigos de cada uno de los 8 ítems ST256.
#
# Cómo correrlo (desde Proyecto_PISA/scripts/; unos minutos):
#   & "C:\Program Files\R\R-4.4.1\bin\Rscript.exe" 03_explorar_saltos_st256.R
# =============================================================================

options(stringsAsFactors = FALSE, scipen = 999, width = 160)
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
ST256 <- grep("^ST256Q[0-9]+JA$", names(read_sav(STU, n_max = 0)), value = TRUE)
d <- read_sav(STU, col_select = all_of(c("CNT", "ST255Q01JA", ST256)), skip = min(w) - 1, n_max = length(w), user_na = TRUE)
stopifnot(all(d$CNT == "COL"), length(ST256) == 8)

crudo <- function(x) { r <- unclass(x); attributes(r) <- NULL; r }
etq255 <- attr(d$ST255Q01JA, "labels"); etq256 <- attr(d$ST256Q01JA, "labels")
nombre <- function(cod, etq) ifelse(is.na(cod), "NA del sistema", paste0(cod, " = ", names(etq)[match(cod, etq)]))

cruce <- as.data.table(table(ST255 = nombre(crudo(d$ST255Q01JA), etq255), codigo = nombre(crudo(d$ST256Q01JA), etq256)))[N > 0]
cruce[, tabla := "ST255 x ST256Q01JA"]
por_item <- rbindlist(lapply(ST256, function(v) as.data.table(table(codigo = nombre(crudo(d[[v]]), etq256)))[, ST255 := v]))
por_item[, tabla := "códigos de cada ítem ST256"]
salida <- rbind(cruce[, .(tabla, fila = ST255, codigo, n = N)], por_item[, .(tabla, fila = ST255, codigo, n = N)])
fwrite(salida, file.path(SALIDAS, "nse_saltos_st256.csv"))

cat("Colombia:", nrow(d), "estudiantes\n\nCruce ST255 x ST256Q01JA:\n")
print(dcast(cruce, ST255 ~ codigo, value.var = "N", fill = 0))
cat("\nCeldas de los 8 ítems ST256 por código:\n")
print(por_item[, .(n = sum(N)), by = codigo][order(codigo)])
cat("\nListo: salidas/nse_saltos_st256.csv\n")
