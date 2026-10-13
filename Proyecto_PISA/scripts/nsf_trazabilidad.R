# =============================================================================
# NADA SIN FUENTE - Tabla de trazabilidad
#
# Dos modos:
#   preparar  Lee el anteproyecto y crea trazabilidad/trazabilidad_{persona}.csv
#             con una fila por (oración del anteproyecto x fuente citada), ya
#             repartidas por sección. Agrega "ubicacion_sugerida" desde la nota
#             de la fuente en el vault (es una PISTA por_verificar, no evidencia).
#             No sobrescribe un archivo que ya exista (salvo con --forzar).
#   unir      Junta los tres archivos llenos en trazabilidad_completa.csv y
#             trazabilidad.md (tabla para abrir en la sustentación), revisa que
#             cada fila sostenida tenga ubicación, verificador y fecha, y guarda
#             el resumen en salidas/nsf_trazabilidad_resumen.csv.
#
# Cómo correrlo (desde Proyecto_PISA/scripts/):
#   & "C:\Program Files\R\R-4.4.1\bin\Rscript.exe" nsf_trazabilidad.R preparar
#   & "C:\Program Files\R\R-4.4.1\bin\Rscript.exe" nsf_trazabilidad.R unir
# =============================================================================

local({
  arg <- grep("^--file=", commandArgs(FALSE), value = TRUE)
  of  <- tryCatch(sys.frame(1)$ofile, error = function(e) NULL)
  dir <- if (length(arg)) dirname(normalizePath(sub("^--file=", "", arg))) else
         if (!is.null(of)) dirname(normalizePath(of)) else getwd()
  source(file.path(dir, "nsf_comun.R"), encoding = "UTF-8")
})

args   <- commandArgs(TRUE)
MODO   <- if (length(args)) args[1] else "unir"
FORZAR <- "--forzar" %in% args
DIR_T  <- file.path(DIR_NSF, "trazabilidad")

# Qué sección del anteproyecto verifica cada quien (plan de equipo, bloque 2)
REPARTO <- data.table(
  seccion = c("Planteamiento del problema y contexto",
              "El desempeño como variable observada: el enfoque econométrico en Colombia",
              "La medición del NSE: del índice compuesto al constructo latente",
              "Matemáticas por competencias",
              "Equidad de la prueba: funcionamiento diferencial del ítem",
              "Desenganche en la prueba",
              "Datos disponibles y aproximación metodológica preliminar"),
  persona = c("Mateo", "Brayan", "Mateo", "Brayan", "Vanessa", "Vanessa", "Brayan"))

COLUMNAS <- c("id", "seccion", "afirmacion", "fuente", "marca_verificar", "ubicacion_sugerida",
              "ubicacion", "se_sostiene", "correccion_propuesta", "verificado_por", "fecha")

# --- Oraciones con cita del anteproyecto ---------------------------------------------
oraciones_con_cita <- function(rmd) {
  l <- readLines(rmd, encoding = "UTF-8", warn = FALSE)
  en_chunk <- FALSE; sec1 <- ""; sec2 <- ""; parrafo <- character(); out <- list()
  cerrar <- function() {
    if (!length(parrafo)) return(invisible())
    txt <- paste(trimws(parrafo), collapse = " ")
    txt <- gsub("\\^\\[[^]]*\\]", "", txt)                 # notas al pie
    ora <- unlist(strsplit(txt, "(?<=[.?!]|[.?!]\\*\\*)\\s+(?=[A-ZÁÉÍÓÚÑ¿@*(])", perl = TRUE))
    for (o in ora) {
      claves <- unique(regmatches(o, gregexpr("@[A-Za-z][A-Za-z0-9_]*", o))[[1]])
      if (!length(claves)) next
      limpia <- gsub("\\*\\*\\[VERIFICAR\\]\\*\\*", "", o)
      limpia <- gsub("\\\\,", " ", gsub("\\*\\*", "", limpia))
      limpia <- gsub("\\s+([.,;])", "\\1", gsub("\\s+", " ", trimws(limpia)))
      out[[length(out) + 1]] <<- data.table(
        seccion = if (nzchar(sec2) && sec1 == "Estado del arte y antecedentes") sec2 else sec1,
        afirmacion = limpia, fuente = sub("^@", "", claves),
        marca_verificar = ifelse(grepl("[VERIFICAR]", o, fixed = TRUE), "si", "no"))
    }
    parrafo <<- character()
  }
  for (x in l) {
    if (grepl("^```", x)) { cerrar(); en_chunk <- !en_chunk; next }
    if (en_chunk) next
    if (grepl("^# ", x))  { cerrar(); sec1 <- trimws(sub("^# ", "", sub("\\{.*\\}", "", x))); sec2 <- ""; next }
    if (grepl("^## ", x)) { cerrar(); sec2 <- trimws(sub("^## ", "", x)); next }
    if (!nzchar(trimws(x)) || grepl("^>", x)) { cerrar(); next }
    parrafo <- c(parrafo, x)
  }
  cerrar()
  rbindlist(out)
}

# --- Pista de ubicación desde la nota de la fuente ------------------------------------
pista_de_nota <- function(clave) {
  f <- file.path(DIR_LIT, paste0(clave, ".md"))
  if (!file.exists(f)) return("sin nota en el vault")
  l <- readLines(f, encoding = "UTF-8", warn = FALSE)
  filas <- grep("^\\| *[0-9]+ *\\|", l, value = TRUE)
  if (!length(filas)) return("la nota no tiene afirmaciones con página")
  partes <- lapply(strsplit(filas, "\\|"), function(c) trimws(c[-1]))
  txt <- vapply(partes, function(c) {
    afirm <- gsub("\\*\\*", "", c[2])
    cita  <- if (length(c) >= 4 && nzchar(c[4])) paste0(" ", c[4]) else ""
    sprintf("%s (%s)%s", afirm, c[3], cita)
  }, "")
  paste0("[nota del vault, por_verificar] ", paste(txt, collapse = " || "))
}

# --- Modos --------------------------------------------------------------------------------
if (MODO == "preparar") {
  o <- oraciones_con_cita(RMD_ANTEPROYECTO)
  o <- merge(o, REPARTO, by = "seccion", all.x = FALSE, sort = FALSE)
  o[, ubicacion_sugerida := vapply(fuente, pista_de_nota, "")]
  o[, c("ubicacion", "se_sostiene", "correccion_propuesta", "verificado_por", "fecha") := ""]
  orden_sec <- REPARTO$seccion
  o <- o[order(match(seccion, orden_sec))]
  cat("Filas de trazabilidad por persona y sección:\n")
  print(o[, .N, by = .(persona, seccion)])
  cat("Fuentes distintas:", uniqueN(o$fuente), "| filas con [VERIFICAR]:", sum(o$marca_verificar == "si"), "\n")
  for (p in PERSONAS) {
    ruta <- file.path(DIR_T, sprintf("trazabilidad_%s.csv", p))
    if (file.exists(ruta) && !FORZAR) { cat("Ya existe, no se toca:", basename(ruta), "\n"); next }
    d <- o[persona == p]
    d[, id := sprintf("T-%s-%02d", substr(p, 1, 3), seq_len(.N))]
    escribir_csv(d[, ..COLUMNAS], ruta)
    cat("Creado:", basename(ruta), "-", nrow(d), "filas\n")
  }
} else if (MODO == "unir") {
  archivos <- file.path(DIR_T, sprintf("trazabilidad_%s.csv", PERSONAS))
  archivos <- archivos[file.exists(archivos)]
  if (!length(archivos)) stop("No hay archivos trazabilidad_{persona}.csv en ", DIR_T)
  d <- rbindlist(lapply(archivos, function(a) {
    x <- leer_csv(a); exigir_columnas(x, COLUMNAS, a); x[, persona := persona_de(a)][]
  }), fill = TRUE)
  d[, se_sostiene := normalizar_si_no(se_sostiene, permitir_parcial = TRUE)]
  d[, completa := !is.na(se_sostiene) & !is.na(verificado_por) & !is.na(fecha) &
        (se_sostiene == "no" | !is.na(ubicacion))]
  d[se_sostiene %in% c("no", "parcial") & is.na(correccion_propuesta), completa := FALSE]
  escribir_csv(d[, c(COLUMNAS, "persona"), with = FALSE], file.path(DIR_T, "trazabilidad_completa.csv"))

  # Tabla en Markdown para abrir en la sustentación (Obsidian o cualquier visor)
  esc <- function(x) gsub("\\|", "/", ifelse(is.na(x), "", x))
  md <- c("# Tabla de trazabilidad", "",
          "Generada por `Proyecto_PISA/scripts/nsf_trazabilidad.R unir`. No editar a mano: se edita el CSV de cada persona.", "",
          "| ID | Afirmación (anteproyecto) | Fuente | Ubicación | ¿Se sostiene? | Corrección | Verificado por | Fecha |",
          "|---|---|---|---|---|---|---|---|",
          sprintf("| %s | %s | %s | %s | %s | %s | %s | %s |", d$id, esc(d$afirmacion), esc(d$fuente), esc(d$ubicacion),
                  esc(d$se_sostiene), esc(d$correccion_propuesta), esc(d$verificado_por), esc(d$fecha)))
  writeLines(md, file.path(DIR_T, "trazabilidad.md"), useBytes = FALSE)

  res <- d[, .(filas = .N, completas = sum(completa), se_sostiene = sum(se_sostiene == "si", na.rm = TRUE),
               parcial = sum(se_sostiene == "parcial", na.rm = TRUE), no = sum(se_sostiene == "no", na.rm = TRUE),
               sin_revisar = sum(is.na(se_sostiene))), by = persona]
  res <- rbind(res, res[, c(list(persona = "TOTAL"), lapply(.SD, sum)), .SDcols = -"persona"])
  escribir_csv(res, file.path(DIR_SALIDAS, "nsf_trazabilidad_resumen.csv"))
  print(res)
  inc <- d[completa == FALSE & !is.na(se_sostiene)]
  if (nrow(inc)) {
    cat("\nFilas revisadas pero INCOMPLETAS (falta ubicación, verificador, fecha o corrección):\n")
    print(inc[, .(id, fuente, se_sostiene, ubicacion, verificado_por, fecha)])
  }
  cat("\nListo: trazabilidad_completa.csv, trazabilidad.md y salidas/nsf_trazabilidad_resumen.csv\n")
} else stop("Modo desconocido: use 'preparar' o 'unir'")
