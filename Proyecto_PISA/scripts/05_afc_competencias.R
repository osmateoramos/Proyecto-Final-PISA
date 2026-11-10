# =============================================================================
# 05 ANÁLISIS CONFIRMATORIO DE LOS ÍTEMS POR COMPETENCIA - exploratorio, D-48
#
# Qué hace (sugerencia del profesor de Ecuaciones Estructurales, 2026-11-10; posterior a H8):
#   1. Cobertura de pares: cuántos estudiantes respondieron cada par de ítems (versión (a) de la matriz). Muestra por qué
#      un AFC con WLSMV en lavaan, que parte de correlaciones policóricas por pares, no se puede estimar con la prueba
#      adaptativa.
#   2. El AFC por ítem con información completa es el modelo de 4 competencias del 5.3 (cada ítem carga solo en su
#      competencia; mirt, QMCEM con 1.000 puntos y pesos). Se leen del caché, sin volver a estimar:
#      - la carga estandarizada de cada ítem en su competencia (cargas_mirt de utilidades_pisa.R, por la falla de
#        summary() de mirt 1.46.1 con los GPCM; D-19);
#      - la matriz completa de correlaciones entre competencias (Φ).
#   3. Marca los ítems con carga < 0,30, el criterio operativo de D-29 (V3). Solo se reporta: no excluye ítems.
#
# Entradas: datos/COL_mat_tri_4D.rds y COL_mat_respuestas.rds (05_tri_competencias.R).
# Salidas (solo agregados): salidas/mat_afc_cargas.csv, mat_afc_resumen.csv, mat_afc_phi.csv y mat_pares_cobertura.csv.
#
# Cómo correrlo (desde Proyecto_PISA/scripts/; menos de 1 minuto):
#   & "C:\Program Files\R\R-4.4.1\bin\Rscript.exe" 05_afc_competencias.R
# =============================================================================

options(stringsAsFactors = FALSE, width = 160)
suppressPackageStartupMessages({ library(data.table); library(mirt) })

carpeta_script <- function() {
  arg <- grep("^--file=", commandArgs(FALSE), value = TRUE)
  if (length(arg)) return(dirname(normalizePath(sub("^--file=", "", arg))))
  if (!is.null(sys.frames()[[1]]$ofile)) return(dirname(normalizePath(sys.frames()[[1]]$ofile)))
  getwd()
}
DIR     <- carpeta_script()
DATOS   <- normalizePath(file.path(DIR, "..", "datos"))
SALIDAS <- normalizePath(file.path(DIR, "..", "salidas"))
source(file.path(DIR, "utilidades_pisa.R"))                        # cargas_mirt()
for (f in c("COL_mat_tri_4D.rds", "COL_mat_respuestas.rds"))
  if (!file.exists(file.path(DATOS, f))) stop("Falta datos/", f, ": correr antes 05_tri_competencias.R")

R <- readRDS(file.path(DATOS, "COL_mat_respuestas.rds"))
m <- readRDS(file.path(DATOS, "COL_mat_tri_4D.rds"))
ITEMS <- colnames(R$a); stopifnot(length(ITEMS) == 232, identical(extract.mirt(m, "itemnames"), ITEMS))
COMP  <- R$competencia[ITEMS]; TIPO <- R$tipo[ITEMS]
FAC   <- c(emplear = "EMP", formular = "FOR", interpretar = "INT", razonar = "RAZ")
stopifnot(!anyNA(COMP), all(COMP %in% names(FAC)), identical(sort(unname(FAC)), sort(extract.mirt(m, "factorNames"))))

# --- 1. Cobertura de pares de ítems
O  <- !is.na(R$a)
N2 <- crossprod(O)                                                 # estudiantes que respondieron cada par
sup <- which(upper.tri(N2), arr.ind = TRUE)
pares <- data.table(n = N2[sup], misma = COMP[sup[, 1]] == COMP[sup[, 2]])
resumen_pares <- function(x, etiqueta) data.table(
  pares = etiqueta, n_pares = nrow(x), nunca_juntos = sum(x$n == 0), pct_nunca_juntos = round(100 * mean(x$n == 0), 1),
  menos_de_50 = sum(x$n < 50), pct_menos_de_50 = round(100 * mean(x$n < 50), 1),
  mediana_estudiantes = median(x$n), p90_estudiantes = unname(quantile(x$n, 0.9)))
cob <- rbind(resumen_pares(pares, "todos"), resumen_pares(pares[misma == TRUE], "misma competencia"),
             resumen_pares(pares[misma == FALSE], "competencias distintas"))
fwrite(cob, file.path(SALIDAS, "mat_pares_cobertura.csv"))
cat("--- 1. Cobertura de pares de ítems (salidas/mat_pares_cobertura.csv) ---\n"); print(cob)

# --- 2. Cargas de cada ítem en su competencia (modelo de 4 competencias del 5.3)
F  <- cargas_mirt(m)[ITEMS, , drop = FALSE]
co <- coef(m, simplify = TRUE)$items
pos <- apply(F, 1, function(f) which(abs(f) > 0))                  # estructura entre ítems: una sola carga por ítem
stopifnot(is.numeric(pos), all(colnames(F)[pos] == FAC[COMP]))    # cada ítem carga en la competencia del anexo A
cargas <- data.table(item = ITEMS, competencia = COMP, tipo = TIPO,
                     respuestas = colSums(O),
                     a = round(co[cbind(ITEMS, paste0("a", match(FAC[COMP], extract.mirt(m, "factorNames"))))], 3),
                     carga = round(F[cbind(ITEMS, FAC[COMP])], 3))
cargas[, carga_baja := carga < 0.30]
setorder(cargas, competencia, -carga)
fwrite(cargas, file.path(SALIDAS, "mat_afc_cargas.csv"))

res <- cargas[, .(items = .N, carga_mediana = round(median(carga), 3), carga_p10 = round(quantile(carga, 0.1), 3),
                  carga_min = min(carga), carga_max = max(carga), carga_menor_030 = sum(carga_baja),
                  pct_menor_030 = round(100 * mean(carga_baja), 1)), by = competencia]
res <- rbind(res, cargas[, .(competencia = "total", items = .N, carga_mediana = round(median(carga), 3),
                             carga_p10 = round(quantile(carga, 0.1), 3), carga_min = min(carga), carga_max = max(carga),
                             carga_menor_030 = sum(carga_baja), pct_menor_030 = round(100 * mean(carga_baja), 1))])
fwrite(res, file.path(SALIDAS, "mat_afc_resumen.csv"))
cat("\n--- 2. Cargas de los ítems en su competencia (salidas/mat_afc_resumen.csv y mat_afc_cargas.csv) ---\n"); print(res)

# --- 3. Matriz completa de correlaciones entre competencias (Φ)
PHI <- cov2cor(coef(m, simplify = TRUE)$cov)
phi <- data.table(competencia = names(FAC)[match(rownames(PHI), FAC)], round(PHI, 3))
setnames(phi, c("competencia", names(FAC)[match(colnames(PHI), FAC)]))
fwrite(phi, file.path(SALIDAS, "mat_afc_phi.csv"))
cat("\n--- 3. Correlaciones entre competencias, Φ (salidas/mat_afc_phi.csv) ---\n"); print(phi)
cat("\nListo: salidas/mat_pares_cobertura.csv, mat_afc_cargas.csv, mat_afc_resumen.csv y mat_afc_phi.csv\n")
