# =============================================================================
# NADA SIN FUENTE - Evaluación de fidelidad con el banco de preguntas (criterio C4)
#
# Entrada: nada_sin_fuente/evaluacion/banco_{persona}.csv, una fila por
#          pregunta x tratamiento (A, B, C). Basta con escribir la pregunta,
#          la respuesta conocida, dónde está y si está en el corpus en la
#          primera fila de cada id_pregunta: el script la copia a las demás.
# Salidas:
#   evaluacion/banco_completo.csv              los tres bancos juntos
#   salidas/nsf_banco_por_tratamiento.csv      por tratamiento:
#       - preguntas EN el corpus: respuesta sostenida por un fragmento real y
#         respuesta correcta (proporción con IC de Wilson 95 %); abstenciones
#         indebidas (dijo "no está" cuando sí estaba);
#       - preguntas FUERA del corpus: abstención correcta (IC de Wilson) e
#         invenciones (respondió algo en vez de abstenerse).
#   salidas/nsf_banco_fallos.csv               candidatas para el caso de fallo
#
# Cómo correrlo (desde Proyecto_PISA/scripts/):
#   & "C:\Program Files\R\R-4.4.1\bin\Rscript.exe" nsf_evaluacion.R
# =============================================================================

local({
  arg <- grep("^--file=", commandArgs(FALSE), value = TRUE)
  of  <- tryCatch(sys.frame(1)$ofile, error = function(e) NULL)
  dir <- if (length(arg)) dirname(normalizePath(sub("^--file=", "", arg))) else
         if (!is.null(of)) dirname(normalizePath(of)) else getwd()
  source(file.path(dir, "nsf_comun.R"), encoding = "UTF-8")
})

DIR_EV <- file.path(DIR_NSF, "evaluacion")
COL_B  <- c("id_pregunta", "pregunta", "respuesta_conocida", "donde_esta", "en_corpus", "tratamiento",
            "respuesta_obtenida", "cita_dada", "sostenida", "correcta", "se_abstuvo", "fecha")

archivos <- file.path(DIR_EV, sprintf("banco_%s.csv", PERSONAS))
archivos <- archivos[file.exists(archivos)]
if (!length(archivos)) stop("No hay archivos banco_{persona}.csv en ", DIR_EV)

b <- rbindlist(lapply(archivos, function(a) {
  x <- leer_csv(a); exigir_columnas(x, COL_B, a); x[, responsable := persona_de(a)][]
}), fill = TRUE)
b <- b[!is.na(id_pregunta)]
b[, tratamiento := toupper(trimws(tratamiento))]
# Copiar los datos de la pregunta a todas sus filas
for (v in c("pregunta", "respuesta_conocida", "donde_esta", "en_corpus"))
  b[, (v) := { x <- get(v); y <- x[!is.na(x)]; if (length(y)) y[1] else NA_character_ }, by = id_pregunta]
b[, en_corpus := normalizar_si_no(en_corpus)]
b[, sostenida := normalizar_si_no(sostenida)]
b[, correcta := normalizar_si_no(correcta, permitir_parcial = TRUE)]
b[, se_abstuvo := normalizar_si_no(se_abstuvo)]
b <- b[!is.na(pregunta)]
escribir_csv(b, file.path(DIR_EV, "banco_completo.csv"))

# --- Controles del enunciado -------------------------------------------------------------
preg <- unique(b[, .(id_pregunta, en_corpus)])
cat("Preguntas:", nrow(preg), "(en el corpus:", sum(preg$en_corpus == "si", na.rm = TRUE),
    "| fuera:", sum(preg$en_corpus == "no", na.rm = TRUE), ")\n")
if (nrow(preg) < 15 || nrow(preg) > 20) cat("AVISO: el enunciado pide de 15 a 20 preguntas.\n")
if (sum(preg$en_corpus == "no", na.rm = TRUE) < 3) cat("AVISO: faltan preguntas fuera del corpus (mínimo 3).\n")
inc <- b[, .(trat = paste(sort(unique(tratamiento[!is.na(se_abstuvo) | !is.na(sostenida)])), collapse = ""))
         , by = id_pregunta][trat != "ABC"]
if (nrow(inc)) cat("AVISO: preguntas sin correr en los tres tratamientos:", paste(inc$id_pregunta, collapse = ", "), "\n")

# --- Métricas por tratamiento ----------------------------------------------------------------
fila_ic <- function(x, n, nombre) {
  w <- wilson(x, n)
  setNames(list(x, n, round(w[["p"]], 3), round(w[["li"]], 3), round(w[["ls"]], 3)),
           paste0(nombre, c("", "_n", "_p", "_ic95_inf", "_ic95_sup")))
}
res <- b[, {
  dentro <- .SD[en_corpus == "si" & !is.na(sostenida)]
  fuera  <- .SD[en_corpus == "no" & !is.na(se_abstuvo)]
  c(fila_ic(sum(dentro$sostenida == "si"), nrow(dentro), "sostenida"),
    fila_ic(sum(dentro$correcta == "si", na.rm = TRUE), sum(!is.na(dentro$correcta)), "correcta"),
    list(correcta_parcial = sum(dentro$correcta == "parcial", na.rm = TRUE),
         abstencion_indebida = sum(dentro$se_abstuvo == "si", na.rm = TRUE)),
    fila_ic(sum(fuera$se_abstuvo == "si"), nrow(fuera), "abstencion_fuera"),
    list(invenciones_fuera = sum(fuera$se_abstuvo == "no")))
}, by = tratamiento][order(tratamiento)]
res[, herramienta := TRATAMIENTOS[tratamiento]]
escribir_csv(res, file.path(DIR_SALIDAS, "nsf_banco_por_tratamiento.csv"))

fallos <- b[(en_corpus == "si" & (sostenida == "no" | correcta == "no" | se_abstuvo == "si")) |
            (en_corpus == "no" & se_abstuvo == "no"),
            .(id_pregunta, tratamiento, responsable, en_corpus, sostenida, correcta, se_abstuvo,
              pregunta, respuesta_obtenida, cita_dada)]
escribir_csv(fallos, file.path(DIR_SALIDAS, "nsf_banco_fallos.csv"))

cat("\n--- Fidelidad por tratamiento ---\n")
print(res[, .(tratamiento, herramienta, sostenida, sostenida_n, sostenida_p, sostenida_ic95_inf, sostenida_ic95_sup,
              abstencion_fuera, abstencion_fuera_n, invenciones_fuera, abstencion_indebida)])
cat("\nCandidatas para el caso de fallo:", nrow(fallos), "(salidas/nsf_banco_fallos.csv)\n")
cat("\nListo: evaluacion/banco_completo.csv y salidas/nsf_banco_*.csv\n")
