# -----------------------------------------------------------------------------------------------------------------
# Copia en el proyecto (2026-11-10) de afc_0_lectura_y_viabilidad.R, que corrió en una copia aparte (scratchpad de Claude) del
# 2026-11-08 al 2026-11-10. Solo cambian las rutas y los nombres de los archivos de salida; el cálculo es el mismo.
# Exploratorio y posterior a la Puerta G4: no está en 00_correr_todo.R ni registrado en el 03 (ver Hallazgos.md y la
# nota 17, sección 10). Requiere datos/COL_mat_respuestas.rds, COL_mat_tri_1D.rds y COL_mat_tri_4D.rds, que genera
# 05_tri_competencias.R. Se corre desde Proyecto_PISA/scripts/ con Rscript.
# -----------------------------------------------------------------------------------------------------------------
# AFC de los ítems de matemáticas (exploratorio, posterior a H8; copia aparte, fuera del proyecto; solo agregados).
# Pregunta (Brayan, 2026-11-08): ¿cada ítem mide la competencia que le asigna la OCDE, y únicamente esa?
#
# LECTURA FIJADA ANTES DE CORRER (cortes operativos de Claude, sin fuente en el vault, como los de D-29):
#   A. Mide su competencia: carga estandarizada propia >= 0,30 y límite inferior del IC 95 % > 0.
#   B. Únicamente esa: se marca el ítem si la prueba conjunta de las 3 cargas cruzadas es significativa (BH 5 %, sobre
#      232 ítems) y además alguna carga cruzada estandarizada es >= 0,30 en valor absoluto.
#   C. Mejor dimensión: proporción de ítems cuya competencia asignada es la de mayor log-verosimilitud (azar: 25 %).
#   D. Control: la ganancia de la asignación OCDE frente a 1D debe superar a TODAS las de 19 asignaciones al azar,
#      permutando las competencias dentro de cada formato (automático / codificación humana).
#   E. Residuos: en 1D, Q3 medio entre ítems de la misma competencia frente a competencias distintas (unidades
#      distintas, >= 200 estudiantes en común).
#   Veredicto: CONFIRMA si A >= 90 % de los ítems, B <= 10 % y D se cumple. NO CONTRADICE, PERO NO CONFIRMA si A y B se
#   cumplen y D no. CONTRADICE si A < 90 % o B > 10 %.
#
# Esta parte: ¿se puede hacer un AFC clásico (WLSMV)? Necesita la correlación policórica de TODOS los pares de ítems.
suppressPackageStartupMessages(library(data.table))
carpeta_script <- function() { arg <- grep("^--file=", commandArgs(FALSE), value = TRUE)
  if (length(arg)) dirname(normalizePath(sub("^--file=", "", arg))) else getwd() }
DIR <- carpeta_script(); DATOS <- normalizePath(file.path(DIR, "..", "datos")); SALIDAS <- normalizePath(file.path(DIR, "..", "salidas"))
BASE <- normalizePath(file.path(DIR, ".."))
M <- readRDS(file.path(BASE, "datos", "COL_mat_respuestas.rds")); A <- M$a; stopifnot(ncol(A) == 232, nrow(A) == 6886)
N <- crossprod(!is.na(A)); p <- N[upper.tri(N)]
cat("Pares de ítems:", length(p), "\n")
tb <- table(cut(p, c(-1, 0, 49, 199, Inf), labels = c("0 estudiantes", "1 a 49", "50 a 199", "200 o más")))
print(tb); print(round(100 * prop.table(tb), 1))
cat("Mediana de estudiantes por par:", median(p), "\n")
cat("Ítems por estudiante (mínimo, mediana, máximo):", range(rowSums(!is.na(A)))[1], median(rowSums(!is.na(A))), range(rowSums(!is.na(A)))[2], "\n")
cog <- readRDS(file.path(BASE, "datos", "COL_cognitivo.rds"))
d <- cog[match(M$CNTSTUID, CNTSTUID)]
patron <- apply(!is.na(A), 1, function(x) paste(which(x), collapse = ","))
tp <- as.integer(sort(table(patron), decreasing = TRUE))
cat("Patrones distintos de ítems respondidos:", length(tp), "\n")
cat("Estudiantes en el patrón más frecuente:", tp[1], "| en los 5 más frecuentes:", sum(tp[1:5]), "\n")
cat("Patrones con 200 o más estudiantes:", sum(tp >= 200), "\n")
