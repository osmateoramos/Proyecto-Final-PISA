# =============================================================================
# NADA SIN FUENTE - funciones comunes
#
# Lo cargan los scripts nsf_*.R con source(). No se corre solo.
#   - Rutas del proyecto (funciona con Rscript, source() y RStudio).
#   - Lectura y escritura de CSV compatibles con Excel en español: se escriben
#     con ";" y UTF-8 con BOM; se leen detectando el separador y, si el archivo
#     se guardó en ANSI, se relee como Latin-1.
#   - Normalización de categorías y de respuestas sí/no.
#   - Intervalos de Wilson (proporción) y de Newcombe (diferencia).
# =============================================================================

options(stringsAsFactors = FALSE, scipen = 999)
suppressPackageStartupMessages(library(data.table))

carpeta_script <- function() {
  arg <- grep("^--file=", commandArgs(FALSE), value = TRUE)
  if (length(arg)) return(dirname(normalizePath(sub("^--file=", "", arg))))
  for (i in rev(seq_along(sys.frames()))) {
    of <- sys.frames()[[i]]$ofile
    if (!is.null(of)) return(dirname(normalizePath(of)))
  }
  getwd()
}

# --- Rutas --------------------------------------------------------------------
DIR_SCRIPTS <- carpeta_script()
DIR_PISA    <- dirname(DIR_SCRIPTS)                       # Proyecto_PISA/
# NSF_DIR y NSF_SALIDAS solo sirven para probar los scripts con datos de prueba fuera del repositorio
DIR_NSF     <- Sys.getenv("NSF_DIR", file.path(DIR_PISA, "nada_sin_fuente"))
DIR_SALIDAS <- Sys.getenv("NSF_SALIDAS", file.path(DIR_PISA, "salidas"))
DIR_VAULT   <- file.path(dirname(DIR_PISA), "Vault_PISA2022")
DIR_LIT     <- file.path(DIR_VAULT, "Literatura")
RMD_ANTEPROYECTO <- file.path(DIR_PISA, "anteproyecto", "anteproyecto_VanessaAcosta_MateoRamos.Rmd")

PERSONAS <- c("Brayan", "Mateo", "Vanessa")
TRATAMIENTOS <- c(A = "Claude sin contexto", B = "Zotero + Obsidian (Claude con el vault)",
                  C = "NotebookLM")

# --- CSV -----------------------------------------------------------------------
# Se lee con read.table y no con fread: fread dejaba las comillas dobles escapadas ("") como dos
# comillas, y cada lectura + escritura las duplicaba (error reportado por Vanessa el 2026-10-12).
# read.table convierte "" en " dentro de un campo entre comillas y acepta saltos de línea dentro de él.
leer_csv <- function(ruta) {
  bytes <- readBin(ruta, "raw", file.size(ruta))
  texto <- rawToChar(bytes); Encoding(texto) <- "UTF-8"
  utf8 <- validUTF8(texto)
  if (!utf8) message("Aviso: ", basename(ruta), " no estaba en UTF-8; se leyó como Latin-1. ",
                     "En Excel: Guardar como -> CSV UTF-8.")
  cabecera <- sub("^﻿", "", strsplit(if (utf8) texto else iconv(texto, "latin1", "UTF-8"), "\r?\n")[[1]][1])
  cuenta <- vapply(c(";", ",", "\t"), function(s) lengths(regmatches(cabecera, gregexpr(s, cabecera, fixed = TRUE))), 0L)
  d <- utils::read.table(ruta, sep = names(which.max(cuenta)), quote = "\"", header = TRUE,
                         colClasses = "character", na.strings = c("", "NA"), fill = TRUE,
                         comment.char = "", check.names = FALSE, strip.white = FALSE,
                         fileEncoding = if (utf8) "UTF-8-BOM" else "latin1", encoding = "UTF-8")
  d <- as.data.table(d)
  setnames(d, trimws(sub("^﻿", "", names(d))))
  d[]
}

escribir_csv <- function(d, ruta) {
  dir.create(dirname(ruta), showWarnings = FALSE, recursive = TRUE)
  fwrite(d, ruta, sep = ";", bom = TRUE, na = "", encoding = "UTF-8")
  invisible(ruta)
}

exigir_columnas <- function(d, columnas, archivo) {
  faltan <- setdiff(columnas, names(d))
  if (length(faltan)) stop(basename(archivo), ": faltan las columnas ", paste(faltan, collapse = ", "))
}

# Persona a partir del nombre del archivo: referencias_Brayan.csv -> "Brayan"
persona_de <- function(ruta) sub("^.*_([^_]+)\\.csv$", "\\1", basename(ruta))

# --- Normalización ----------------------------------------------------------------
sin_tildes <- function(x) chartr("áéíóúüñÁÉÍÓÚÜÑ", "aeiouunAEIOUUN", x)

normalizar_categoria <- function(x, archivo = "") {
  y <- trimws(tolower(sin_tildes(x)))
  y <- gsub("[^a-z ]", " ", y)
  y <- gsub("\\s+", " ", trimws(y))
  out <- rep(NA_character_, length(y))
  out[y %in% c("u", "utilizable")] <- "utilizable"
  out[y %in% c("e", "existe pero no dice eso", "existe pero no dice", "existe no dice")] <- "existe_no_dice"
  out[y %in% c("n", "no existe")] <- "no_existe"
  malos <- unique(x[!is.na(y) & y != "" & is.na(out)])
  if (length(malos)) stop(basename(archivo), ": categorías no reconocidas: ", paste(malos, collapse = " | "),
                          ". Use: utilizable / existe pero no dice eso / no existe (o U / E / N).")
  out
}

normalizar_si_no <- function(x, permitir_parcial = FALSE) {
  y <- trimws(tolower(sin_tildes(x)))
  out <- rep(NA_character_, length(y))
  out[y %in% c("si", "s", "1", "true", "x")] <- "si"
  out[y %in% c("no", "n", "0", "false")] <- "no"
  if (permitir_parcial) out[y %in% c("parcial", "p")] <- "parcial"
  out
}

# --- Intervalos ----------------------------------------------------------------------
Z95 <- qnorm(0.975)

wilson <- function(x, n, z = Z95) {
  if (n == 0) return(c(p = NA_real_, li = NA_real_, ls = NA_real_))
  p <- x / n
  centro <- (p + z^2 / (2 * n)) / (1 + z^2 / n)
  medio  <- z * sqrt(p * (1 - p) / n + z^2 / (4 * n^2)) / (1 + z^2 / n)
  c(p = p, li = max(0, centro - medio), ls = min(1, centro + medio))
}

# Diferencia p1 - p2 con el método híbrido de Newcombe (1998, método 10)
newcombe <- function(x1, n1, x2, n2) {
  a <- wilson(x1, n1); b <- wilson(x2, n2)
  d <- a[["p"]] - b[["p"]]
  c(dif = d,
    li = d - sqrt((a[["p"]] - a[["li"]])^2 + (b[["ls"]] - b[["p"]])^2),
    ls = d + sqrt((a[["ls"]] - a[["p"]])^2 + (b[["p"]] - b[["li"]])^2))
}

pct <- function(x) ifelse(is.na(x), "", sprintf("%.1f %%", 100 * x))
