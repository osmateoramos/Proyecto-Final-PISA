# =============================================================================
# NADA SIN FUENTE - README de procedencia del corpus (criterio C2)
#
# El corpus son los documentos que cita el anteproyecto (las fuentes de los
# archivos de trazabilidad) y cualquier otro PDF que se ponga en corpus/.
# Convención de nombres: corpus/{clave_bib}.pdf. Los PDF no van a Git
# (.gitignore); la copia oficial está en el grupo de Zotero.
#
# El script mantiene corpus/procedencia.csv:
#   - columnas automáticas: título, autores, año, origen (DOI/URL) desde la nota
#     del vault; si el PDF está en la carpeta local y su fecha de obtención está vacía,
#     usa la fecha del archivo;
#   - columnas a mano (se conservan al volver a correr): fecha_obtencion,
#     licencia_o_permiso, verificado_por, notas.
# y escribe corpus/README_procedencia.md, una fila por archivo.
#
# Cómo correrlo (desde Proyecto_PISA/scripts/):
#   & "C:\Program Files\R\R-4.4.1\bin\Rscript.exe" nsf_procedencia.R
# =============================================================================

local({
  arg <- grep("^--file=", commandArgs(FALSE), value = TRUE)
  of  <- tryCatch(sys.frame(1)$ofile, error = function(e) NULL)
  dir <- if (length(arg)) dirname(normalizePath(sub("^--file=", "", arg))) else
         if (!is.null(of)) dirname(normalizePath(of)) else getwd()
  source(file.path(dir, "nsf_comun.R"), encoding = "UTF-8")
})

DIR_C   <- file.path(DIR_NSF, "corpus")
PROC    <- file.path(DIR_C, "procedencia.csv")
MANUAL  <- c("fecha_obtencion", "licencia_o_permiso", "verificado_por", "notas")
dir.create(DIR_C, showWarnings = FALSE, recursive = TRUE)

frontmatter <- function(clave) {
  f <- file.path(DIR_LIT, paste0(clave, ".md"))
  vacio <- list(titulo = NA_character_, autores = NA_character_, año = NA_character_, doi_url = NA_character_)
  if (!file.exists(f)) return(vacio)
  l <- readLines(f, encoding = "UTF-8", warn = FALSE)
  fin <- which(l == "---")
  if (length(fin) < 2) return(vacio)
  l <- l[(fin[1] + 1):(fin[2] - 1)]
  val <- function(k) {
    x <- grep(paste0("^", k, ":"), l, value = TRUE)
    if (!length(x)) return(NA_character_)
    x <- trimws(sub(paste0("^", k, ":"), "", x[1])); x <- gsub('^"|"$', "", x)
    if (nzchar(x)) x else NA_character_
  }
  list(titulo = val("titulo"), autores = val("autores"), año = val("año"), doi_url = val("doi_url"))
}

# --- Claves del corpus ------------------------------------------------------------------
traz <- file.path(DIR_NSF, "trazabilidad", sprintf("trazabilidad_%s.csv", PERSONAS))
traz <- traz[file.exists(traz)]
claves <- unique(unlist(lapply(traz, function(a) leer_csv(a)$fuente)))
pdfs <- sub("\\.pdf$", "", list.files(DIR_C, pattern = "\\.pdf$", ignore.case = TRUE))
extra <- setdiff(pdfs, claves)
claves <- sort(unique(c(claves, pdfs)))

p <- rbindlist(lapply(claves, function(k) c(list(clave = k), frontmatter(k))))
p[, archivo := paste0(clave, ".pdf")]

# Conservar lo que se llenó a mano
previo <- if (file.exists(PROC)) leer_csv(PROC)[, c("clave", MANUAL), with = FALSE] else
          data.table(clave = character())[, (MANUAL) := character()]
p <- merge(p, previo, by = "clave", all.x = TRUE, sort = TRUE)
local_pdf <- file.exists(file.path(DIR_C, p$archivo))
auto_fecha <- local_pdf & is.na(p$fecha_obtencion)
p$fecha_obtencion[auto_fecha] <- format(file.mtime(file.path(DIR_C, p$archivo[auto_fecha])), "%Y-%m-%d")
# "Obtenido" no depende de la máquina: basta con que alguien lo haya bajado y anotado la fecha.
# Así, quien corra el script sin los PDF en su carpeta no borra lo que otro ya consiguió.
p[, en_carpeta := ifelse(local_pdf | !is.na(fecha_obtencion), "si", "falta")]
escribir_csv(p[, c("clave", "archivo", "en_carpeta", "titulo", "autores", "año", "doi_url", MANUAL), with = FALSE], PROC)

# --- README en Markdown -------------------------------------------------------------------
esc <- function(x) gsub("\\|", "/", ifelse(is.na(x), "", x))
md <- c(
  "# README de procedencia del corpus", "",
  "Generado por `Proyecto_PISA/scripts/nsf_procedencia.R` a partir de `procedencia.csv`.",
  "No editar este archivo: se editan las columnas a mano de `procedencia.csv` y se vuelve a correr el script.", "",
  "- **Convención de nombres:** `{clave_bib}.pdf` (la misma clave de `referencias.bib`, de Zotero y de la nota en `Vault_PISA2022/Literatura/`).",
  "- **Dónde viven los PDF:** copia oficial en el grupo de Zotero *Proyecto Final PISA*; copia local en esta carpeta. No van a Git (derechos de autor).",
  "- **Datos de la contraparte:** ninguno. Todo el corpus es público (OCDE, Icfes y artículos publicados).",
  "- **Para registrar un PDF obtenido:** guardarlo como `corpus/{clave_bib}.pdf` y correr `nsf_procedencia.R`; la columna «Obtenido» y la fecha se llenan solas. No se editan a mano en `procedencia.csv`: si varias personas editan ese archivo a la vez, Git choca. Las columnas a mano (licencia, verificador, notas) las mantiene Mateo.", "",
  sprintf("Documentos: %d · obtenidos: %d · faltan: %d", nrow(p), sum(p$en_carpeta == "si"), sum(p$en_carpeta == "falta")), "",
  "| Archivo | Obtenido | Origen (DOI / URL) | Fecha de obtención | Licencia o permiso | Quién lo verificó | Notas |",
  "|---|---|---|---|---|---|---|",
  sprintf("| %s | %s | %s | %s | %s | %s | %s |", p$archivo, p$en_carpeta, esc(p$doi_url), esc(p$fecha_obtencion),
          esc(p$licencia_o_permiso), esc(p$verificado_por), esc(p$notas)))
writeLines(md, file.path(DIR_C, "README_procedencia.md"))

cat("Corpus:", nrow(p), "documentos | obtenidos:", sum(p$en_carpeta == "si"),
    "| sin DOI/URL:", sum(is.na(p$doi_url)), "\n")
if (length(extra)) cat("PDF que no corresponden a ninguna fuente citada:", paste(extra, collapse = ", "), "\n")
falta_manual <- p[en_carpeta == "si" & (is.na(licencia_o_permiso) | is.na(verificado_por)), clave]
if (length(falta_manual)) cat("PDF sin licencia o sin verificador:", paste(falta_manual, collapse = ", "), "\n")
cat("Listo: corpus/procedencia.csv y corpus/README_procedencia.md\n")
