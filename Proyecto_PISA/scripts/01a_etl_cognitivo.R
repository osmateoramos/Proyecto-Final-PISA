# =============================================================================
# 01a ETL COGNITIVO - PISA 2022 Colombia, items de matematicas (F1, paso 1.2)
#
# Qué hace:
#   1. Lee solo el bloque de Colombia de CY08MSP_STU_COG.SAV (primero la columna CNT, luego
#      col_select + skip + n_max) con user_na = TRUE, para conservar los códigos de faltante:
#      puntaje de cada ítem (S o C), tiempo total (TT), tiempo a la primera acción (F),
#      número de acciones (A) y las variables de forma y ruta adaptativa.
#   2. Clasifica cada celda estudiante x ítem según la decisión D-13
#      (Vault_PISA2022/03 Registro de decisiones.md): respondido, omitido, no alcanzado,
#      no administrado, no aplicable o inválido.
#   3. Guarda datos/COL_cognitivo.rds (no va a Git: datos de menores, Ley 1581 de 2012).
#   4. Escribe en salidas/ solo tablas agregadas:
#      cognitivo_estados_resumen.csv (celdas por estado) y cognitivo_estados_por_item.csv.
#
# Estructura de COL_cognitivo.rds (una fila por estudiante):
#   - CNTSTUID, CNTSCHID, BOOKID, MPATH, MCORE_ItemSet, MS1_LEV, MS2_LEV;
#   - <ítem>      puntaje: el valor válido de la OCDE; NA si el estado no es "respondido".
#                 Los ítems de crédito parcial con dos dígitos (11-14, 21-22) quedan como vienen:
#                 cómo se recodifican para la TRI se decide en la F5 (no lo fija D-13);
#   - E_<ítem>    estado del ítem (factor con los 6 niveles de D-13);
#   - <ítem>TT, F, A   tiempos y acciones; los códigos de faltante pasan a NA (D-13);
#   - n_<estado>  ítems en cada estado por estudiante, y n_tt_valido (ítems con tiempo válido).
#
# Cómo correrlo (desde Proyecto_PISA/scripts/):
#   & "C:\Program Files\R\R-4.4.1\bin\Rscript.exe" 01a_etl_cognitivo.R
# La primera vez lee el .SAV de 3,7 GB (varios minutos) y guarda un caché crudo. Para releerlo
# aunque exista el caché: $env:REHACER_COG = "1" antes de correr el script.
# =============================================================================

options(stringsAsFactors = FALSE, scipen = 999)
suppressPackageStartupMessages({ library(data.table); library(haven) })

# Carpeta del script: funciona con Rscript, con source() y con RStudio.
carpeta_script <- function() {
  arg <- grep("^--file=", commandArgs(FALSE), value = TRUE)
  if (length(arg)) return(dirname(normalizePath(sub("^--file=", "", arg))))
  if (!is.null(sys.frames()[[1]]$ofile)) return(dirname(normalizePath(sys.frames()[[1]]$ofile)))
  getwd()
}
DIR     <- carpeta_script()                                        # Proyecto_PISA/scripts
DATOS   <- normalizePath(file.path(DIR, "..", "datos"))
SALIDAS <- normalizePath(file.path(DIR, "..", "salidas"))
COG     <- file.path(DATOS, "CY08MSP_STU_COG.SAV")
CRUDO   <- file.path(DATOS, "COL_cognitivo_crudo.rds")            # bloque de Colombia con los códigos originales
FINAL   <- file.path(DATOS, "COL_cognitivo.rds")                  # clasificado (D-13)
PAIS    <- "COL"
N_COL   <- 7804   # tamaño de la muestra principal (Technical Report, Annex Table 11.A.2, p. 244; ver 01b)
REHACER <- Sys.getenv("REHACER_COG") == "1"
ESTADOS <- c("respondido", "omitido", "no_alcanzado", "no_administrado", "no_aplicable", "invalido")

# =============================================================================
# 1. LEER (o usar el caché crudo)
# =============================================================================
m0 <- read_sav(COG, n_max = 0, user_na = TRUE)
nombres <- names(m0)
# Codificación OCDE: CM...S = ítem calificado automáticamente (CMA = nuevos de 2022);
# DM...C = corregido por codificador humano, que guarda sus tiempos con prefijo CM.
ITEMS <- c(grep("^CMA?[0-9A-Z]+Q[0-9]+S$", nombres, value = TRUE),
           grep("^DMA?[0-9A-Z]+Q[0-9]+C$", nombres, value = TRUE))
BASE  <- sub("^D", "C", sub("(S|C)$", "", ITEMS))
TT    <- paste0(BASE, "TT")
PROC  <- intersect(c(TT, paste0(BASE, "F"), paste0(BASE, "A")), nombres)
RUTA  <- c("CNTSTUID", "CNTSCHID", "BOOKID", "MPATH", "MCORE_ItemSet", "MS1_LEV", "MS2_LEV")
stopifnot(length(ITEMS) == 234, all(TT %in% nombres), all(RUTA %in% nombres))

# Rango de faltantes de usuario de cada columna (metadatos SPSS); se guarda antes de quitar etiquetas.
RANGO <- lapply(setNames(c(ITEMS, PROC), c(ITEMS, PROC)), function(v) attr(m0[[v]], "na_range"))
FACT  <- c("BOOKID", "MPATH", "MCORE_ItemSet", "MS1_LEV", "MS2_LEV")
ETQ   <- lapply(setNames(FACT, FACT), function(v) attr(m0[[v]], "labels"))

if (file.exists(CRUDO) && !REHACER) {
  d <- readRDS(CRUDO)
  cat("Caché crudo leído:", nrow(d), "filas x", ncol(d), "columnas\n")
} else {
  cat("Ubicando", PAIS, "en", basename(COG), "(lectura de la columna CNT, unos minutos)...\n")
  cnt <- read_sav(COG, col_select = "CNT")[["CNT"]]
  w <- which(cnt == PAIS); rm(cnt); invisible(gc())
  if (max(w) - min(w) + 1 != length(w)) stop("Las filas de ", PAIS, " no son contiguas en ", basename(COG))
  cat(PAIS, ": filas", min(w), "a", max(w), "(", length(w), "estudiantes )\n")
  # user_na = TRUE: los códigos 6-9 / 96-99 / 99999996-99999999 llegan con su valor (D-13).
  d <- read_sav(COG, col_select = all_of(c("CNT", RUTA, ITEMS, PROC)),
                skip = min(w) - 1, n_max = length(w), user_na = TRUE)
  stopifnot(all(d$CNT == PAIS))
  # Valores crudos (sin clase labelled): el código de faltante queda como número.
  d <- as.data.table(lapply(d, function(x) { attributes(x) <- NULL; x }))
  saveRDS(d, CRUDO, compress = TRUE)
  cat("Caché crudo guardado:", nrow(d), "filas x", ncol(d), "columnas\n")
}

# =============================================================================
# 2. CLASIFICAR (decisión D-13)
# =============================================================================
# El último dígito del código de faltante identifica el tipo: 6 = Not Reached, 7 = Not Applicable,
# 8 = Invalid, 9 = No Response (igual en 6-9, 96-99 y 99999996-99999999).
es_faltante <- function(x, rg) !is.na(x) & x >= rg[1] & x <= rg[2]
estado_item <- function(x, rg) {
  f <- es_faltante(x, rg)
  e <- fifelse(is.na(x), "no_administrado",
       fifelse(!f, "respondido",
       fcase(x %% 10 == 9, "omitido", x %% 10 == 6, "no_alcanzado",
             x %% 10 == 7, "no_aplicable", x %% 10 == 8, "invalido")))
  factor(e, levels = ESTADOS)
}

# r llega a ~1.180 columnas: se reserva espacio para que set() pueda agregarlas
# (en data.table 1.17 set() no crece la tabla sola; corrección de Mateo, 2026-10-16).
r <- setalloccol(d[, ..RUTA], length(RUTA) + 2 * length(ITEMS) + length(PROC) + length(ESTADOS) + 100)
for (v in FACT) {   # forma y ruta como factor con las etiquetas de la OCDE
  lab <- ETQ[[v]]   # set() y no r[[v]] <- ...: esto último copia la tabla y pierde el espacio reservado
  set(r, j = v, value = factor(names(lab)[match(d[[v]], lab)], levels = names(lab)))
}
for (v in ITEMS) {
  e <- estado_item(d[[v]], RANGO[[v]])
  set(r, j = v, value = fifelse(e == "respondido", d[[v]], NA_real_))
  set(r, j = paste0("E_", v), value = e)
}
for (v in PROC) {   # tiempos y acciones: códigos de faltante (incluido Invalid) a NA
  x <- d[[v]]; x[es_faltante(x, RANGO[[v]])] <- NA
  set(r, j = v, value = x)
}

E <- as.matrix(r[, paste0("E_", ITEMS), with = FALSE])
for (s in ESTADOS) set(r, j = paste0("n_", s), value = rowSums(E == s))
set(r, j = "n_tt_valido", value = rowSums(!is.na(as.matrix(r[, ..TT]))))

# =============================================================================
# 3. CONTROLES
# =============================================================================
stopifnot(
  nrow(r) == N_COL, !anyDuplicated(r$CNTSTUID),
  !anyNA(E),                                                        # toda celda tiene un estado
  rowSums(as.matrix(r[, paste0("n_", ESTADOS), with = FALSE])) == length(ITEMS),
  all(is.na(as.matrix(r[, ..ITEMS])) == (E != "respondido")),       # puntaje solo si respondido
  all(as.matrix(r[, ..ITEMS]) >= 0, na.rm = TRUE)                   # ningún código de faltante quedó como puntaje
)
saveRDS(r, FINAL, compress = TRUE)
cat("\nGuardado", basename(FINAL), ":", nrow(r), "estudiantes x", ncol(r), "columnas\n")

# =============================================================================
# 4. SALIDAS AGREGADAS
# =============================================================================
# Estado del puntaje x estado del tiempo: debe reproducir salidas/faltantes_cog_cruce.csv
# (01a_explorar_faltantes_cog.R), con los códigos agrupados por tipo.
tt_estado <- function(v) { x <- d[[v]]
  fifelse(is.na(x), "NA_sistema", fifelse(es_faltante(x, RANGO[[v]]), "codigo_faltante", "valido")) }
resumen <- as.data.table(table(estado = as.vector(E), tiempo_TT = as.vector(sapply(TT, tt_estado))))[N > 0]
setnames(resumen, "N", "celdas")
resumen[, estado := factor(estado, levels = ESTADOS)]
setorder(resumen, estado, tiempo_TT)
fwrite(resumen, file.path(SALIDAS, "cognitivo_estados_resumen.csv"))

por_item <- rbindlist(lapply(ITEMS, function(v) {
  t <- table(r[[paste0("E_", v)]])
  data.table(item = v, t(setNames(as.integer(t), names(t))),
             valores_validos = paste(sort(unique(na.omit(r[[v]]))), collapse = " "))
}))
fwrite(por_item, file.path(SALIDAS, "cognitivo_estados_por_item.csv"))

# =============================================================================
# 5. RESUMEN EN CONSOLA
# =============================================================================
cat("\nCeldas por estado (", nrow(r), "x", length(ITEMS), "=", length(E), "):\n")
print(resumen[, .(celdas = sum(celdas)), by = estado])
cat("\nEstado x tiempo TT:\n"); print(resumen)
cat("\nÍtems sin ninguna respuesta en Colombia:", paste(por_item[respondido == 0, item], collapse = ", "), "\n")
cat("Ítems con crédito parcial de dos dígitos (se recodifican en la F5):",
    sum(grepl("1[1-4]|2[12]", por_item$valores_validos)), "\n")
cat("\nRuta (MPATH):\n"); print(r[, .N, by = MPATH][order(MPATH)])
cat("\nÍtems por estudiante (quienes tienen al menos uno respondido):\n")
print(summary(r[n_respondido > 0, .(n_respondido, n_omitido, n_no_alcanzado, n_no_aplicable, n_tt_valido)]))
cat("Estudiantes sin ningún ítem respondido:", r[n_respondido == 0, .N], "\n")
cat("\nListo: datos/COL_cognitivo.rds, salidas/cognitivo_estados_resumen.csv y cognitivo_estados_por_item.csv.\n")
