# -----------------------------------------------------------------------------------------------------------------
# Copia en el proyecto (2026-11-10) de afc_2b_rango.R, que corrió en una copia aparte (scratchpad de Claude) del
# 2026-11-08 al 2026-11-10. Solo cambian las rutas y los nombres de los archivos de salida; el cálculo es el mismo.
# Exploratorio y posterior a la Puerta G4: no está en 00_correr_todo.R ni registrado en el 03 (ver Hallazgos.md y la
# nota 17, sección 10). Requiere datos/COL_mat_respuestas.rds, COL_mat_tri_1D.rds y COL_mat_tri_4D.rds, que genera
# 05_tri_competencias.R. Se corre desde Proyecto_PISA/scripts/ con Rscript.
# -----------------------------------------------------------------------------------------------------------------
# Control D repartido en varios procesos. No cambia el método: ejecuta tal cual las líneas 1 a 44 de
# afc_2_permutaciones.R (datos, función corre, semilla 2026 y las 19 permutaciones) y corre solo las permutaciones ini:fin.
# Cada proceso guarda su propio archivo después de cada asignación. Solo agregados (Ley 1581).
args <- commandArgs(trailingOnly = TRUE); ini <- as.integer(args[1]); fin <- as.integer(args[2]); stopifnot(ini >= 1L, fin <= 19L, ini <= fin)
carpeta_script <- function() { arg <- grep("^--file=", commandArgs(FALSE), value = TRUE)
  if (length(arg)) dirname(normalizePath(sub("^--file=", "", arg))) else getwd() }
DIR <- carpeta_script(); DATOS <- normalizePath(file.path(DIR, "..", "datos")); SALIDAS <- normalizePath(file.path(DIR, "..", "salidas"))
lin <- readLines(file.path(DIR, "05_explorar_afc_2_permutaciones.R"), encoding = "UTF-8")
k <- grep("^res <- list\\(corre\\(COMP", lin)   # la copia del proyecto tiene más líneas de cabecera: se busca la línea
stopifnot(length(k) == 1L, startsWith(lin[k - 3L], "fmt <- "), startsWith(lin[k - 1L], "cat(\"Coinciden"))
eval(parse(text = lin[seq_len(k - 1L)], encoding = "UTF-8"))
SAL_R <- file.path(SALIDAS, sprintf("mat_afc_permutaciones_%02d_%02d.csv", ini, fin))
res <- list()
for (b in ini:fin) {
  r1 <- corre(perms[[b]], paste0("azar_", b)); res[[length(res) + 1L]] <- r1
  print(r1); fwrite(rbindlist(res), SAL_R); flush.console()
}
cat("FIN", ini, fin, "\n")
