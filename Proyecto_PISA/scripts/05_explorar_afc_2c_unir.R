# -----------------------------------------------------------------------------------------------------------------
# Copia en el proyecto (2026-11-10) de afc_2c_combinar.R, que corrió en una copia aparte (scratchpad de Claude) del
# 2026-11-08 al 2026-11-10. Solo cambian las rutas y los nombres de los archivos de salida; el cálculo es el mismo.
# Exploratorio y posterior a la Puerta G4: no está en 00_correr_todo.R ni registrado en el 03 (ver Hallazgos.md y la
# nota 17, sección 10). Requiere datos/COL_mat_respuestas.rds, COL_mat_tri_1D.rds y COL_mat_tri_4D.rds, que genera
# 05_tri_competencias.R. Se corre desde Proyecto_PISA/scripts/ con Rscript.
# -----------------------------------------------------------------------------------------------------------------
# Une el control D repartido en 3 procesos (mat_afc_permutaciones_secuencial.csv y mat_afc_permutaciones_II_FF.csv) y aplica el mismo
# resumen de las líneas 48 a 54 de afc_2_permutaciones.R. Solo agregados (Ley 1581).
suppressPackageStartupMessages(library(data.table))
carpeta_script <- function() { arg <- grep("^--file=", commandArgs(FALSE), value = TRUE)
  if (length(arg)) dirname(normalizePath(sub("^--file=", "", arg))) else getwd() }
DIR <- carpeta_script(); DATOS <- normalizePath(file.path(DIR, "..", "datos")); SALIDAS <- normalizePath(file.path(DIR, "..", "salidas"))
S <- SALIDAS
fs <- c(file.path(S, "mat_afc_permutaciones_secuencial.csv"), list.files(S, "^mat_afc_permutaciones_[0-9]{2}_[0-9]{2}\\.csv$", full.names = TRUE))
r <- rbindlist(lapply(fs, fread), fill = TRUE)
cat("Archivos:", basename(fs), "\n")
cat("Filas:", nrow(r), "| asignaciones distintas:", uniqueN(r$asignacion), "\n")
r <- unique(r, by = "asignacion")
esperadas <- c("OCDE", paste0("azar_", 1:19)); cat("Faltan:", setdiff(esperadas, r$asignacion), "\n")
r <- r[match(intersect(esperadas, r$asignacion), asignacion)]
fwrite(r, file.path(S, "mat_afc_permutaciones.csv"))
print(r[, .(asignacion, convergio, iteraciones, ganancia = round(ganancia, 2), r_min = round(r_min, 3), r_max = round(r_max, 3), minutos, error)])
cat("No convergieron:", sum(!r$convergio, na.rm = TRUE), "| con error:", sum(is.na(r$ganancia)), "\n")

az <- r[asignacion != "OCDE" & !is.na(ganancia)]
cat("\n=== D. Control con asignaciones al azar ===\n")
cat("Ganancia OCDE:", round(r[asignacion == "OCDE", ganancia], 2), "| r máx.:", round(r[asignacion == "OCDE", r_max], 3), "\n")
cat("Azar (", nrow(az), "): ganancia mínima", round(min(az$ganancia), 2), "mediana", round(median(az$ganancia), 2), "máxima", round(max(az$ganancia), 2), "\n")
cat("Azar: r máx. mediana", round(median(az$r_max), 3), "| r mín. mediana", round(median(az$r_min), 3), "\n")
cat("Asignaciones al azar con ganancia igual o mayor que la OCDE:", sum(az$ganancia >= r[asignacion == "OCDE", ganancia]), "de", nrow(az), "\n")
cat("p de permutación:", round((1 + sum(az$ganancia >= r[asignacion == "OCDE", ganancia])) / (1 + nrow(az)), 3), "\n")
