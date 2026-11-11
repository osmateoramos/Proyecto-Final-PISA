# -----------------------------------------------------------------------------------------------------------------
# Copia en el proyecto (2026-11-10) de afc_3_diagnostico_A.R, que corrió en una copia aparte (scratchpad de Claude) del
# 2026-11-08 al 2026-11-10. Solo cambian las rutas y los nombres de los archivos de salida; el cálculo es el mismo.
# Exploratorio y posterior a la Puerta G4: no está en 00_correr_todo.R ni registrado en el 03 (ver Hallazgos.md y la
# nota 17, sección 10). Requiere datos/COL_mat_respuestas.rds, COL_mat_tri_1D.rds y COL_mat_tri_4D.rds, que genera
# 05_tri_competencias.R. Se corre desde Proyecto_PISA/scripts/ con Rscript.
# -----------------------------------------------------------------------------------------------------------------
# Diagnóstico POSTERIOR a ver la prueba A (no forma parte de la lectura fijada): ¿por qué fallan los ítems?
# Solo agregados por ítem (Ley 1581).
suppressPackageStartupMessages({ library(data.table); library(mirt) })
carpeta_script <- function() { arg <- grep("^--file=", commandArgs(FALSE), value = TRUE)
  if (length(arg)) dirname(normalizePath(sub("^--file=", "", arg))) else getwd() }
DIR <- carpeta_script(); DATOS <- normalizePath(file.path(DIR, "..", "datos")); SALIDAS <- normalizePath(file.path(DIR, "..", "salidas"))
S <- SALIDAS
r <- fread(file.path(S, "mat_afc_items_condicional.csv"))
m1 <- readRDS(file.path(DATOS, "COL_mat_tri_1D.rds"))
M <- readRDS(file.path(DATOS, "COL_mat_respuestas.rds"))
cargas_1D <- function(m) { pars <- m@ParObjects$pars; J <- length(pars) - 1L; gcov <- mirt:::ExtractGroupPars(pars[[J + 1L]])$gcov
  L <- do.call(rbind, lapply(seq_len(J), function(i) { p <- pars[[i]]; l <- mirt:::ExtractLambdas(p, include_fixed = FALSE) / 1.702
    if (p@ncat > 2 && (is(p, "gpcm") || is(p, "nominal"))) { d <- mirt:::nominal_rescale_d(p@par[1:(1 + p@ncat)], nfact = 1, ncat = p@ncat); l <- l * d
      s <- sign(l[which(l != 0)[1]]); if (is.na(s)) s <- 1; l <- l * sqrt((p@ncat - 1) * 1.702) * s }; l }))
  L <- L * sqrt(gcov[1, 1]); F <- L / sqrt(1 + rowSums(L^2)); rownames(F) <- extract.mirt(m, "itemnames"); F }
F1 <- cargas_1D(m1); r[, carga_1D := F1[item, 1]]
r[, A_ok := carga_propia >= 0.30 & carga_lim_inf > 0]
r[, formato := fifelse(grepl("C$", item), "C humano", "S automatico")]
acierto <- colMeans(M$a > 0, na.rm = TRUE); r[, p_acierto := acierto[item]]

cat("=== Por qué falla A ===\n")
cat("No cumplen A:", sum(!r$A_ok), "| carga propia < 0,30:", sum(r$carga_propia < 0.30), "| carga >= 0,30 pero límite <= 0:", sum(r$carga_propia >= 0.30 & r$carga_lim_inf <= 0), "\n")
cat("Carga propia < 0,20:", sum(r$carga_propia < 0.20), "| < 0:", sum(r$carga_propia < 0), "| límite inferior <= 0:", sum(r$carga_lim_inf <= 0), "\n")
cat("n de los que no cumplen (mín, mediana, máx):", min(r[A_ok == FALSE, n]), median(r[A_ok == FALSE, n]), max(r[A_ok == FALSE, n]), "\n")
cat("n de los que cumplen (mín, mediana, máx):", min(r[A_ok == TRUE, n]), median(r[A_ok == TRUE, n]), max(r[A_ok == TRUE, n]), "\n")
cat("\n=== ¿También son débiles con UNA sola dimensión? ===\n")
cat("Correlación carga propia 4D - carga 1D:", round(cor(r$carga_propia, r$carga_1D), 4), "\n")
cat("Diferencia absoluta carga propia - 1D (mediana, máx):", round(median(abs(r$carga_propia - r$carga_1D)), 3), round(max(abs(r$carga_propia - r$carga_1D)), 3), "\n")
print(r[, .N, keyby = .(cumple_A = A_ok, carga_1D_mayor_030 = carga_1D >= 0.30)])
cat("\n=== Dificultad y formato (proporción con puntaje > 0, sin pesos) ===\n")
print(r[, .(items = .N, p_acierto_mediana = round(median(p_acierto), 3), p_min = round(min(p_acierto), 3), p_max = round(max(p_acierto), 3)), keyby = A_ok])
print(r[, .(items = .N, cumplen = sum(A_ok), pct = round(100 * mean(A_ok), 1)), keyby = formato])
print(r[, .(items = .N, cumplen = sum(A_ok), pct = round(100 * mean(A_ok), 1)), keyby = .(tercio_dificultad = cut(p_acierto, quantile(p_acierto, 0:3 / 3), include.lowest = TRUE, labels = c("difícil", "media", "fácil")))])
cat("\n=== Sobre B: ¿discrimina el criterio de magnitud? ===\n")
cat("Ítems con cruzada >= 0,30:", sum(r$lam_cruzada_max >= 0.30), "de", nrow(r), "\n")
L <- as.matrix(r[, .(lam_EMP, lam_FOR, lam_INT, lam_RAZ)])
cat("Ítems con alguna carga libre mayor que 1 en valor absoluto:", sum(apply(abs(L), 1, max) > 1), "\n")
cat("Mediana del máximo valor absoluto de carga libre:", round(median(apply(abs(L), 1, max)), 2), "\n")
cat("p de cruzadas < 0,05 sin corregir:", sum(r$p_cruzadas < 0.05), "| BH 5 %:", sum(r$p_BH < 0.05), "\n")
cat("\n=== Sobre C: ventaja de la mejor dimensión ===\n")
cat("Ítems con ventaja >= 1,92 (equivale a LR 3,84):", sum(r$ll_dif_mejor_propia >= 1.92), "de", nrow(r), "\n")
cat("Ítems asignados como mejores:", sum(r$mejor_dim == r$competencia), "\n")
set.seed(2026); B <- 10000; f <- r$formato; obs <- sum(r$mejor_dim == r$competencia)
sim <- replicate(B, { e <- r$competencia; for (g in unique(f)) e[f == g] <- sample(e[f == g]); sum(r$mejor_dim == e) })
cat("Permutando etiquetas dentro de formato: esperado", round(mean(sim), 1), "| percentiles 2,5 y 97,5:", quantile(sim, c(.025, .975)), "| p:", round((1 + sum(sim >= obs)) / (1 + B), 4), "\n")
