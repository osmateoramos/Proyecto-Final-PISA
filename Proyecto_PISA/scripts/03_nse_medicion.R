# =============================================================================
# 03 NSE MEDICION - PISA 2022 Colombia (F3, objetivo O1, hipótesis H1)
#
# Decisiones: D-16 (Vault_PISA2022/03 Registro de decisiones.md). Pasos: plan 07, F3.
# El script se construye paso a paso; por ahora contiene el paso 3.1.
#
# 3.1 Preparación (no estima ningún modelo):
#   - muestra de la F3 = muestra analítica de D-14 (6.886; marca `incluido` de 01c), D-16 punto 1;
#   - 29 indicadores: 27 posesiones + HISCED + HISEI en quintiles ponderados, D-16 punto 3;
#   - categorías con < 2 % de las respuestas válidas unidas con la vecina hacia el centro, D-16 punto 4;
#   - mitades de exploración y confirmación al azar dentro de cada colegio (set.seed(2026)), D-16 punto 2;
#   - estructura de 2 factores fijada en D-16 punto 7 (se guarda con los datos para los pasos siguientes).
#
# Salidas: datos/COL_nse.rds (no va a Git: datos de menores, Ley 1581 de 2012);
#          salidas/nse_recodificacion.csv y salidas/nse_mitades.csv (solo agregados).
#
# Cómo correrlo (desde Proyecto_PISA/scripts/, después de 01a, 01b y 01c):
#   & "C:\Program Files\R\R-4.4.1\bin\Rscript.exe" 03_nse_medicion.R
# =============================================================================

options(stringsAsFactors = FALSE, scipen = 999, width = 160)
suppressPackageStartupMessages(library(data.table))

carpeta_script <- function() {
  arg <- grep("^--file=", commandArgs(FALSE), value = TRUE)
  if (length(arg)) return(dirname(normalizePath(sub("^--file=", "", arg))))
  if (!is.null(sys.frames()[[1]]$ofile)) return(dirname(normalizePath(sys.frames()[[1]]$ofile)))
  getwd()
}
DIR     <- carpeta_script()                                        # Proyecto_PISA/scripts
DATOS   <- normalizePath(file.path(DIR, "..", "datos"))
SALIDAS <- normalizePath(file.path(DIR, "..", "salidas"))
source(file.path(DIR, "utilidades_pisa.R"))                        # cuantil_w()
if (!file.exists(file.path(DATOS, "COL_analitica.rds"))) stop("Falta datos/COL_analitica.rds: correr antes 01c")

# =============================================================================
# 3.1 PREPARACIÓN
# =============================================================================
u  <- readRDS(file.path(DATOS, "COL_analitica.rds"))
f3 <- u[incluido == TRUE]                                          # D-16 punto 1
POS <- grep("^ST25[0-6]Q[0-9]+JA$", names(f3), value = TRUE)
stopifnot(nrow(f3) == 6886, !anyDuplicated(f3$CNTSTUID), length(POS) == 27)

# --- Estructura de 2 factores para H1 (D-16 punto 7), fijada antes de ver los datos
CULTURAL  <- c("ST255Q01JA", paste0("ST256Q", c("01", "02", "03", "06", "07", "08", "09", "10"), "JA"),
               "ST251Q06JA", "ST251Q07JA", "HISCED_c")
ECONOMICO <- c(paste0("ST250Q0", 1:5, "JA"), paste0("ST251Q0", 1:4, "JA"), "ST253Q01JA",
               paste0("ST254Q0", 1:6, "JA"), "HISEI_q")
IND <- c(ECONOMICO, CULTURAL)
stopifnot(length(CULTURAL) == 12, length(ECONOMICO) == 17, !anyDuplicated(IND),
          setequal(setdiff(IND, c("HISCED_c", "HISEI_q")), POS))

# --- Une categorías escasas (D-16 punto 4). Devuelve el ítem recodificado a 0..k-1 y el mapa.
# Mientras la categoría más pequeña tenga < 2 % de las respuestas válidas, se une con su vecina hacia
# el centro de la escala (las de los extremos, con la única vecina que tienen).
unir_escasas <- function(x, minimo = 0.02) {
  cats  <- sort(unique(x[!is.na(x)]))
  grupo <- seq_along(cats)                                         # grupo de cada categoría original
  repeat {
    g <- sort(unique(grupo))
    n <- sapply(g, function(k) sum(x %in% cats[grupo == k]))
    p <- n / sum(n)
    j <- which.min(p)
    if (p[j] >= minimo || length(g) <= 2) break
    centro  <- (length(g) + 1) / 2
    vecino  <- if (j == 1) 2 else if (j == length(g)) j - 1 else if (j < centro) j + 1 else j - 1
    grupo[grupo == g[j]] <- g[vecino]
  }
  nuevo <- match(grupo, sort(unique(grupo))) - 1L                  # códigos consecutivos 0..k-1
  n_orig <- sapply(cats, function(k) sum(x == k, na.rm = TRUE))
  list(x = nuevo[match(x, cats)],
       mapa = data.table(categoria_original = as.character(cats), n_original = n_orig,
                         pct_original = round(100 * n_orig / sum(n_orig), 2), categoria_nueva = nuevo))
}

w <- f3$W_FSTUWT
recod <- list()
for (v in POS) {
  r <- unir_escasas(f3[[v]]); set(f3, j = v, value = r$x); recod[[v]] <- r$mapa
}
r <- unir_escasas(f3$HISCED); f3[, HISCED_c := r$x]; recod[["HISCED_c"]] <- r$mapa
r$mapa[, categoria_original := paste0("HISCED ", categoria_original)]

# --- HISEI en quintiles ponderados (D-16 punto 3); cortes calculados una vez sobre los 6.886
h <- !is.na(f3$HISEI)
cortes_hisei <- sapply(c(0.2, 0.4, 0.6, 0.8), function(p) cuantil_w(f3$HISEI[h], w[h], p))
stopifnot(isTRUE(all.equal(round(cortes_hisei, 2), c(17.55, 29.18, 39.02, 68.77))))   # los de D-16
f3[, HISEI_q := as.integer(cut(HISEI, c(-Inf, cortes_hisei, Inf))) - 1L]
lim <- c(min(f3$HISEI, na.rm = TRUE), cortes_hisei, max(f3$HISEI, na.rm = TRUE))
n_q <- sapply(0:4, function(k) sum(f3$HISEI_q == k, na.rm = TRUE))
recod[["HISEI_q"]] <- data.table(categoria_original = sprintf("HISEI %.2f a %.2f", lim[1:5], lim[2:6]),
                                 n_original = n_q, pct_original = round(100 * n_q / sum(n_q), 2), categoria_nueva = 0:4)

# --- Tabla de recodificación (agregada) y controles
tabla_rec <- rbindlist(lapply(IND, function(v) {
  m <- copy(recod[[v]]); x <- f3[[v]]; ok <- !is.na(x)
  m[, `:=`(item = v, factor = if (v %in% CULTURAL) "cultural" else "económico")]
  cn <- m[, .(n = sum(x[ok] == categoria_nueva), pct = round(100 * mean(x[ok] == categoria_nueva), 2),
              pct_ponderado = round(100 * sum(w[ok][x[ok] == categoria_nueva]) / sum(w[ok]), 2)),
          by = categoria_nueva]
  merge(m, cn, by = "categoria_nueva", sort = FALSE)[, .(item, factor, categoria_original, n_original, pct_original,
                                                           categoria_nueva, n_nueva = n, pct_nueva = pct,
                                                           pct_ponderado_nueva = pct_ponderado)]
}))
fwrite(tabla_rec, file.path(SALIDAS, "nse_recodificacion.csv"))

for (v in IND) {
  k <- sort(unique(na.omit(f3[[v]])))
  stopifnot(length(k) >= 2, identical(as.integer(k), seq(0L, length(k) - 1L)))      # 0..k-1 consecutivos
}
min_pct <- tabla_rec[, .(minimo = min(pct_nueva)), by = item]
stopifnot(all(min_pct$minimo >= 2))
cambiados <- tabla_rec[!item %in% c("HISCED_c", "HISEI_q"), .(k_orig = .N, k_nuevo = uniqueN(categoria_nueva)), by = item][k_orig > k_nuevo, item]
esperados <- c("ST254Q02JA", "ST254Q03JA", "ST254Q04JA", "ST254Q05JA", "ST255Q01JA")   # D-16 punto 4
if (!setequal(cambiados, esperados)) stop("La regla del 2 % cambió otros ítems que los de D-16: ", paste(cambiados, collapse = ", "))
stopifnot(tabla_rec[item == "HISEI_q", all(abs(pct_ponderado_nueva - 20) < 1)])

# --- Mitades al azar dentro de cada colegio (D-16 punto 2)
# Se ordena antes de sortear para que el resultado no dependa del orden de las filas. En colegios con
# número impar, el estudiante sobrante va a una mitad al azar.
setorder(f3, CNTSCHID, CNTSTUID)
set.seed(2026)
f3[, mitad := sample(rep(sample(c("exploracion", "confirmacion")), length.out = .N)), by = CNTSCHID]
f3[, mitad := factor(mitad, levels = c("exploracion", "confirmacion"))]
dif_colegio <- f3[, .(d = abs(sum(mitad == "exploracion") - sum(mitad == "confirmacion"))), by = CNTSCHID]
stopifnot(all(dif_colegio$d <= 1))

# Equilibrio de las mitades (solo describe; no es una prueba de H1)
media_w <- function(x, w) { k <- !is.na(x); sum(w[k] * x[k]) / sum(w[k]) }
mitades <- f3[, .(n = .N, colegios = uniqueN(CNTSCHID),
                  pct_peso = round(100 * sum(W_FSTUWT) / sum(f3$W_FSTUWT), 1),
                  ESCS_media = round(media_w(ESCS, W_FSTUWT), 3), HOMEPOS_media = round(media_w(HOMEPOS, W_FSTUWT), 3),
                  pct_mujer = round(100 * media_w(as.numeric(sexo == "Mujer"), W_FSTUWT), 1),
                  pct_rural = round(100 * media_w(as.numeric(zona == "Rural (<3.000)"), W_FSTUWT), 1),
                  pct_publico = round(100 * media_w(as.numeric(sector == "Público"), W_FSTUWT), 1)),
              by = mitad][order(mitad)]
fwrite(mitades, file.path(SALIDAS, "nse_mitades.csv"))

# --- Caché de la F3
nse <- f3[, c("CNTSTUID", "CNTSCHID", "mitad", "W_FSTUWT", IND, "HISCED", "HISEI", "ESCS", "HOMEPOS",
              "sexo", "zona", "sector"), with = FALSE]
setattr(nse, "factores", list(cultural = CULTURAL, economico = ECONOMICO))
setattr(nse, "cortes_hisei", cortes_hisei)
saveRDS(nse, file.path(DATOS, "COL_nse.rds"), compress = TRUE)

# --- Resumen en consola
cat("Paso 3.1 listo:", nrow(nse), "estudiantes x", length(IND), "indicadores (económico", length(ECONOMICO),
    "| cultural", length(CULTURAL), ")\n")
cat("Ítems con categorías unidas (regla del 2 %):", paste(cambiados, collapse = ", "), "\n")
print(tabla_rec[item %in% cambiados, .(item, categoria_original, n_original, pct_original, categoria_nueva, n_nueva, pct_nueva)])
cat("\nHISCED_c (0-9) y HISEI_q (quintiles, cortes", paste(round(cortes_hisei, 2), collapse = " / "), "):\n")
print(tabla_rec[item %in% c("HISCED_c", "HISEI_q"), .(item, categoria_original, categoria_nueva, n_nueva, pct_nueva, pct_ponderado_nueva)])
cat("\n% de faltantes por indicador (entre", nrow(nse), "):\n")
print(round(sort(sapply(nse[, ..IND], function(x) 100 * mean(is.na(x))), decreasing = TRUE), 1))
cat("\nMitades (salidas/nse_mitades.csv):\n"); print(mitades)
cat("Colegios con número impar (diferencia de 1 entre mitades):", sum(dif_colegio$d == 1), "de", nrow(dif_colegio), "\n")
cat("\nListo: datos/COL_nse.rds, salidas/nse_recodificacion.csv y salidas/nse_mitades.csv\n")
