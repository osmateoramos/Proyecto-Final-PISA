# =============================================================================
# 00 CORRER TODO - PISA 2022 Colombia
#
# Qué hace:
#   Corre la cadena de scripts del proyecto en orden, cada uno en su propio proceso de R (igual que
#   correrlos a mano), y se detiene en el primero que falle. Al final dice cuánto tardó cada uno y
#   qué archivos de salidas/ cambiaron frente al último commit (si no cambia nada, la cadena se
#   reprodujo). Criterio C1 de Vault_PISA2022/08 Rúbrica de desarrollo.md.
#
# Cómo correrlo (desde Proyecto_PISA/scripts/):
#   & "C:\Program Files\R\R-4.4.1\bin\Rscript.exe" 00_correr_todo.R          # toda la cadena
#   & "C:\Program Files\R\R-4.4.1\bin\Rscript.exe" 00_correr_todo.R 03       # solo los que empiezan por 03
#   & "C:\Program Files\R\R-4.4.1\bin\Rscript.exe" 00_correr_todo.R 02 03    # varios prefijos
#
# Notas:
#   - Primero corre 00_verificar_entorno.R: si las versiones no coinciden con versiones_paquetes.csv
#     (D-17), se detiene antes de tocar las salidas.
#   - Cada script lee los .SAV solo si falta su caché; 03_nse_tri.R reutiliza los modelos guardados
#     (para re-estimarlos: $env:REHACER_TRI = "1" antes de correr).
#   - La consola de cada script se guarda en la carpeta temporal de R (no en el proyecto) y, si un
#     script falla, se muestran sus últimas líneas.
#   - Al final dice qué scripts leyeron un caché (si los modelos salieron del caché, que salidas/ no cambie no
#     prueba que se reproduzcan: hay que rehacerlos) y revisa también la nota del vault que reescribe 01b
#     (observación 14 de Brayan, PR #12).
#   - No incluye los scripts nsf_* (actividad «Nada sin fuente»), que son otra entrega.
# =============================================================================

CADENA <- c(
  "01a_explorar_faltantes_cog.R",  # D-13: etiquetas de faltantes del archivo cognitivo
  "01a_etl_cognitivo.R",           # F1, paso 1.2 (D-13)
  "01b_etl_cuestionario.R",        # F1, pasos 1.3 y 1.4 (D-12)
  "01c_muestra_analitica.R",       # F1, pasos 1.1 y 1.5 (D-14)
  "02_validacion_ocde.R",          # F2, Puerta G1 (D-15)
  "03_explorar_items_nse.R",       # F3, descripción de los ítems (D-16)
  "03_explorar_saltos.R",          # F3, saltos del cuestionario (D-20)
  "03_nse_medicion.R",             # F3, pasos 3.1 y 3.2 (D-16, D-20)
  "03_nse_tri.R",                  # F3, pasos 3.3, 3.3b y 3.5 (D-19, D-21)
  "03_nse_afc.R",                  # F3, paso 3.4 (D-18)
  "03_nse_sens_d20.R",             # F3, sensibilidad S1 a los ceros de D-20 (D-35)
  "04_explorar_grupos.R",          # F4, conteos por grupo previos a D-25
  "04_invarianza.R",               # F4, pasos 4.1 a 4.5 (D-25, D-26)
  "04_dif_emparejamiento.R",       # F4, sensibilidad S2 (D-35)
  "04_medias_brr.R",               # F4, medias latentes con BRR (D-34; ~6 h sin caché)
  "05_explorar_items.R",           # F5, paso 5.1 y conteos previos a D-27
  "05_tri_competencias.R",         # F5, pasos 5.2 a 5.3b (D-27, D-29)
  "05_afc_competencias.R",         # F5, AFC por competencia, exploratorio (D-48)
  "05_puntajes_e1.R",              # F5, paso 5.4: E1 sin covariables (D-33)
  "05_puntajes_rl.R",              # F5, paso 5.4: regresión latente (D-39; horas sin caché)
  "05_dif_matematicas.R",          # F5, paso 5.6, H3 (D-40; horas sin caché)
  "05_h4_h7.R",                    # F5, pasos 5.5 y 5.7, H4, H7 y P3 (D-41)
  "05_p3_robusto.R",               # F5, paso 5.5, enlace robusto (D-43)
  "06_sem_competencias.R",         # F6, O4, H5 y H6 (D-42, D-44)
  "05_dif_matematicas.R|F7_VARIANTE=escs",       # F7, S-A del DIF (D-45; horas sin caché)
  "05_dif_matematicas.R|F7_VARIANTE=sin_lineal", # F7, S-B del DIF (D-45; horas sin caché)
  "05_dif_matematicas.R|F7_VARIANTE=d38",        # F7, S-E del DIF (D-45)
  "07_sensibilidad.R"              # F7, paso 7.1 (D-45)
)
# Una entrada «script|VAR=valor» corre el script con esa variable de entorno (la hereda el proceso hijo).

carpeta_script <- function() {
  arg <- grep("^--file=", commandArgs(FALSE), value = TRUE)
  if (length(arg)) return(dirname(normalizePath(sub("^--file=", "", arg))))
  if (!is.null(sys.frames()[[1]]$ofile)) return(dirname(normalizePath(sys.frames()[[1]]$ofile)))
  getwd()
}
DIR     <- carpeta_script()
RSCRIPT <- file.path(R.home("bin"), "Rscript.exe")
if (!file.exists(RSCRIPT)) RSCRIPT <- file.path(R.home("bin"), "Rscript")
prefijos <- commandArgs(trailingOnly = TRUE)
cadena   <- if (length(prefijos)) CADENA[Reduce(`|`, lapply(prefijos, function(p) startsWith(CADENA, p)))] else CADENA
if (!length(cadena)) stop("Ningún script de la cadena empieza por: ", paste(prefijos, collapse = ", "))

correr <- function(entrada) {
  partes <- strsplit(entrada, "|", fixed = TRUE)[[1]]; script <- partes[1]; env <- partes[-1]
  for (e in env) do.call(Sys.setenv, setNames(list(sub("^[^=]*=", "", e)), sub("=.*$", "", e)))
  on.exit(for (e in env) Sys.unsetenv(sub("=.*$", "", e)), add = TRUE)
  log <- file.path(tempdir(), paste0(sub("\\.R$", "", script), if (length(env)) paste0("_", gsub("[^A-Za-z0-9]", "_", env), collapse = ""), ".txt"))
  t0  <- Sys.time()
  st  <- system2(RSCRIPT, shQuote(script), stdout = log, stderr = log)
  lineas <- if (file.exists(log)) readLines(log, warn = FALSE, encoding = "UTF-8") else character()
  list(estado = st, minutos = round(as.numeric(difftime(Sys.time(), t0, units = "mins")), 1), log = log,
       cache = any(grepl("[Cc]aché crudo leído|leíd[oa]s? del caché", lineas)))
}

owd <- setwd(DIR); on.exit(setwd(owd), add = TRUE)
cat("R:", R.version.string, "\nCarpeta:", DIR, "\n\n")

ent <- correr("00_verificar_entorno.R")
cat(readLines(ent$log, warn = FALSE, encoding = "UTF-8"), sep = "\n")
if (ent$estado != 0) stop("Las versiones no coinciden con versiones_paquetes.csv (D-17): instalar con --instalar.")

resumen <- data.frame(script = character(), estado = character(), minutos = numeric(), uso_cache = character())
for (s in cadena) {
  if (!file.exists(sub("\\|.*$", "", s))) { cat(sprintf("%-30s  no existe todavía: se salta\n", s))
    resumen[nrow(resumen) + 1, ] <- list(s, "no existe", NA, ""); next }
  cat(sprintf("%-30s  corriendo...", s)); flush.console()
  r <- correr(s)
  ok <- r$estado == 0
  cat(if (ok) " listo" else " FALLÓ", sprintf("(%.1f min)\n", r$minutos))
  resumen[nrow(resumen) + 1, ] <- list(s, if (ok) "listo" else "falló", r$minutos, if (r$cache) "sí" else "no")
  if (!ok) {
    cat("\nÚltimas líneas de", r$log, ":\n")
    cat(tail(readLines(r$log, warn = FALSE, encoding = "UTF-8"), 20), sep = "\n")
    stop("La cadena se detuvo en ", s)
  }
}

cat("\n--- Resumen ---\n"); print(resumen, row.names = FALSE)
cat("Total:", round(sum(resumen$minutos, na.rm = TRUE), 1), "min | consola de cada script en", tempdir(), "\n")

con_cache <- resumen$script[resumen$uso_cache == "sí"]
if (length(con_cache))
  cat("\nLeyeron un caché:", paste(con_cache, collapse = ", "),
      "\nSus resultados no se reestimaron. Para probar que se reproducen: REHACER_COG, REHACER_CUEST, REHACER_TRI,",
      "REHACER_INV, REHACER_DIF (04) o REHACER_MAT (05_tri) = \"1\" (ver el encabezado de cada script). Los scripts de la",
      "F4 (BRR) a la F7 usan cachés con huella en datos/ (COL_inv_brr, COL_mat_e1_sin_cov, COL_mat_rl_em, COL_mat_dif,",
      "COL_sem_*, COL_f7_*): para reestimarlos, renombrar el .rds y volver a correr.\n")

# ¿Se reprodujeron las salidas? Compara salidas/ con el último commit (si Git está disponible).
cambios <- tryCatch(system2("git", c("status", "--porcelain", "--", shQuote("../salidas")), stdout = TRUE, stderr = TRUE),
                    error = function(e) NA_character_)
# La nota del vault que reescribe 01b: si solo cambió su fecha, el contenido se reprodujo.
NOTA_01B <- "../../Vault_PISA2022/Datos/PISA2022 - Variables recodificadas.md"
if (!(length(cambios) == 1 && is.na(cambios))) {
  dif_nota <- tryCatch(system2("git", c("diff", "-U0", "--", shQuote(NOTA_01B)), stdout = TRUE, stderr = TRUE),
                       error = function(e) character())
  lineas <- grep("^[-+]", grep("^(---|\\+\\+\\+) ", dif_nota, value = TRUE, invert = TRUE), value = TRUE)
  if (!length(lineas)) {
    cat("\nLa nota «Variables recodificadas» del vault no cambió.\n")
  } else if (all(grepl("^[-+]fecha:", lineas))) {
    cat("\nLa nota «Variables recodificadas» del vault solo cambió la fecha: el contenido se reprodujo",
        "(se puede descartar con git restore).\n")
  } else {
    cat("\nLa nota «Variables recodificadas» del vault cambió de contenido (revisar antes de subir):", NOTA_01B, "\n")
  }
}
if (length(cambios) == 1 && is.na(cambios)) {
  cat("\nGit no está disponible: no se pudo comparar salidas/ con el último commit.\n")
} else if (!length(cambios)) {
  cat("\nsalidas/ no cambió frente al último commit: la cadena se reprodujo.\n")
} else {
  cat("\nArchivos de salidas/ que cambiaron frente al último commit (revisar antes de subir):\n")
  cat(cambios, sep = "\n")
}
