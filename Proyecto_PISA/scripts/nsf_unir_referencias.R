# =============================================================================
# NADA SIN FUENTE - Unir referencias y armar la hoja ciega
#
# Lee experimento/referencias_{persona}.csv (las referencias que dio cada
# herramienta en la consulta de cada integrante) y produce:
#   - experimento/clave_referencias.csv  id -> persona y tratamiento.
#                                         NO ABRIR hasta terminar de clasificar.
#   - experimento/hoja_ciega.csv         id, referencia, doi_url, afirmación
#                                         atribuida; sin tratamiento ni dueño y
#                                         en orden aleatorio (semilla fija).
#   - experimento/clasificacion_{persona}.csv  copia de la hoja ciega con las
#                                         columnas por llenar. Si ya existe, solo
#                                         agrega las referencias nuevas al final:
#                                         nunca borra una clasificación hecha.
# Los id ya asignados se conservan si alguien agrega referencias después.
#
# Cómo correrlo (desde Proyecto_PISA/scripts/):
#   & "C:\Program Files\R\R-4.4.1\bin\Rscript.exe" nsf_unir_referencias.R
# =============================================================================

local({
  arg <- grep("^--file=", commandArgs(FALSE), value = TRUE)
  of  <- tryCatch(sys.frame(1)$ofile, error = function(e) NULL)
  dir <- if (length(arg)) dirname(normalizePath(sub("^--file=", "", arg))) else
         if (!is.null(of)) dirname(normalizePath(of)) else getwd()
  source(file.path(dir, "nsf_comun.R"), encoding = "UTF-8")
})

DIR_E   <- file.path(DIR_NSF, "experimento")
CLAVE   <- file.path(DIR_E, "clave_referencias.csv")
HOJA    <- file.path(DIR_E, "hoja_ciega.csv")
COL_REF <- c("id_local", "tratamiento", "referencia", "doi_url", "afirmacion_atribuida", "herramienta", "fecha")
COL_CLA <- c("categoria", "evidencia", "fecha")

# --- Leer las referencias de cada integrante -----------------------------------------
archivos <- file.path(DIR_E, sprintf("referencias_%s.csv", PERSONAS))
archivos <- archivos[file.exists(archivos)]
if (!length(archivos)) stop("No hay archivos referencias_{persona}.csv en ", DIR_E)

r <- rbindlist(lapply(archivos, function(a) {
  x <- leer_csv(a); exigir_columnas(x, COL_REF, a)
  x <- x[!is.na(referencia)]
  x[, tratamiento := toupper(trimws(tratamiento))]
  malos <- x[!tratamiento %in% names(TRATAMIENTOS)]
  if (nrow(malos)) stop(basename(a), ": tratamiento debe ser A, B o C (filas id_local ",
                        paste(malos$id_local, collapse = ", "), ")")
  if (anyDuplicated(x$id_local)) stop(basename(a), ": hay id_local repetidos")
  x[, persona := persona_de(a)][]
}), fill = TRUE)

cat("Referencias por integrante y tratamiento:\n")
print(dcast(r[, .N, by = .(persona, tratamiento)], persona ~ tratamiento, value.var = "N", fill = 0))
pocas <- r[, .N, by = .(persona, tratamiento)][N < 5]
if (nrow(pocas)) cat("AVISO: el enunciado pide al menos 5 referencias por tratamiento; faltan en:",
                     paste(pocas$persona, pocas$tratamiento, collapse = "; "), "\n")

# --- Asignar id estables y en orden aleatorio -------------------------------------------
previa <- if (file.exists(CLAVE)) leer_csv(CLAVE)[, .(persona, id_local, id)] else
          data.table(persona = character(), id_local = character(), id = character())
r <- merge(r, previa, by = c("persona", "id_local"), all.x = TRUE, sort = FALSE)
nuevas <- which(is.na(r$id))
if (length(nuevas)) {
  usados <- suppressWarnings(as.integer(sub("^R", "", previa$id)))
  inicio <- if (length(usados) && any(!is.na(usados))) max(usados, na.rm = TRUE) else 0L
  set.seed(2026 + inicio)
  r$id[nuevas] <- sprintf("R%03d", inicio + sample(length(nuevas)))
}
setorder(r, id)
escribir_csv(r[, c("id", "persona", COL_REF), with = FALSE], CLAVE)

hoja <- r[, .(id, referencia, doi_url, afirmacion_atribuida)]
escribir_csv(hoja, HOJA)
cat("Hoja ciega:", nrow(hoja), "referencias (", length(nuevas), "nuevas )\n")

# --- Hoja de clasificación de cada integrante -------------------------------------------
for (p in PERSONAS) {
  ruta <- file.path(DIR_E, sprintf("clasificacion_%s.csv", p))
  vacia <- copy(hoja)[, (COL_CLA) := NA_character_]
  if (!file.exists(ruta)) {
    escribir_csv(vacia, ruta); cat("Creada:", basename(ruta), "\n"); next
  }
  ya <- leer_csv(ruta)
  faltan <- vacia[!id %in% ya$id]
  if (nrow(faltan)) {
    escribir_csv(rbind(ya, faltan, fill = TRUE), ruta)
    cat("Agregadas", nrow(faltan), "referencias nuevas al final de", basename(ruta), "\n")
  } else cat("Sin cambios:", basename(ruta), "\n")
}
cat("\nListo. Cada integrante clasifica SOLO su archivo clasificacion_{persona}.csv, sin abrir clave_referencias.csv.\n")
