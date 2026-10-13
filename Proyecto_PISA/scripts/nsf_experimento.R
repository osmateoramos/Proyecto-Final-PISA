# =============================================================================
# NADA SIN FUENTE - Análisis del experimento (criterio C1)
#
# Entradas (Proyecto_PISA/nada_sin_fuente/experimento/):
#   clave_referencias.csv         id -> persona y tratamiento (nsf_unir_referencias.R)
#   clasificacion_{persona}.csv   categoría que asignó cada integrante, a ciegas
#   clasificacion_consenso.csv    (opcional) id;categoria para desempatar después
#                                 de discutir los casos sin mayoría
# Salidas (Proyecto_PISA/salidas/):
#   nsf_conteos_por_clasificador.csv  tratamiento x categoría, por integrante
#   nsf_conteos.csv                   tratamiento x categoría con la etiqueta final
#   nsf_proporciones.csv              proporción de utilizables por tratamiento, IC de Wilson 95 %
#   nsf_diferencias.csv               B - A y C - A: diferencia con IC de Newcombe y Fisher
#   nsf_acuerdo.csv                   acuerdo entre clasificadores (%, kappa de Cohen y de Fleiss)
#   nsf_desacuerdos.csv               referencias en que no coincidieron, para discutir
#
# Etiqueta final: la categoría que eligió la mayoría (2 de 3). Si no hay mayoría,
# queda "sin_consenso" y no entra a las proporciones, salvo que se resuelva en
# clasificacion_consenso.csv. Las referencias de una misma consulta no son
# independientes: los IC son orientativos (se declara en la memoria).
#
# Cómo correrlo (desde Proyecto_PISA/scripts/):
#   & "C:\Program Files\R\R-4.4.1\bin\Rscript.exe" nsf_experimento.R
# =============================================================================

local({
  arg <- grep("^--file=", commandArgs(FALSE), value = TRUE)
  of  <- tryCatch(sys.frame(1)$ofile, error = function(e) NULL)
  dir <- if (length(arg)) dirname(normalizePath(sub("^--file=", "", arg))) else
         if (!is.null(of)) dirname(normalizePath(of)) else getwd()
  source(file.path(dir, "nsf_comun.R"), encoding = "UTF-8")
})
suppressPackageStartupMessages(library(irr))

DIR_E <- file.path(DIR_NSF, "experimento")
CATS  <- c("utilizable", "existe_no_dice", "no_existe")

clave <- leer_csv(file.path(DIR_E, "clave_referencias.csv"))[, .(id, persona_consulta = persona, tratamiento)]

# --- Clasificaciones ---------------------------------------------------------------------
archivos <- file.path(DIR_E, sprintf("clasificacion_%s.csv", PERSONAS))
archivos <- archivos[file.exists(archivos)]
cl <- rbindlist(lapply(archivos, function(a) {
  x <- leer_csv(a); exigir_columnas(x, c("id", "categoria"), a)
  x[, .(id, categoria = normalizar_categoria(categoria, a), clasificador = persona_de(a))]
}))
cl <- cl[!is.na(categoria)]
fuera <- setdiff(cl$id, clave$id)
if (length(fuera)) stop("Clasificaciones con id que no está en la clave: ", paste(fuera, collapse = ", "))
CLASIF <- sort(unique(cl$clasificador))
cat("Clasificaciones por integrante:\n"); print(cl[, .N, by = clasificador])
avance <- cl[, .(clasificadas = .N), by = clasificador][, total := nrow(clave)]
if (any(avance$clasificadas < nrow(clave))) cat("AVISO: hay hojas incompletas; el análisis usa lo que hay.\n")

cl <- merge(cl, clave, by = "id")
ancho <- dcast(cl, id + tratamiento ~ clasificador, value.var = "categoria")

# --- Conteos por clasificador -------------------------------------------------------------
tabla_cruzada <- function(d, filas, col, niveles) {
  d <- copy(d)[, (col) := factor(get(col), levels = niveles)]
  f <- as.formula(paste(paste(filas, collapse = " + "), "~", col))
  dcast(d, f, fun.aggregate = length, value.var = col, drop = c(TRUE, FALSE))
}
por_clasif <- tabla_cruzada(cl, c("clasificador", "tratamiento"), "categoria", CATS)
escribir_csv(por_clasif, file.path(DIR_SALIDAS, "nsf_conteos_por_clasificador.csv"))

# --- Etiqueta final por mayoría ---------------------------------------------------------------
mayoria <- function(v) {
  v <- v[!is.na(v)]
  if (length(v) < 2) return("sin_consenso")
  t <- sort(table(v), decreasing = TRUE)
  if (t[[1]] > length(v) / 2) names(t)[1] else "sin_consenso"
}
ancho[, final := apply(.SD, 1, mayoria), .SDcols = CLASIF]
cons_f <- file.path(DIR_E, "clasificacion_consenso.csv")
if (file.exists(cons_f)) {
  cons <- leer_csv(cons_f)[, .(id, cat_cons = normalizar_categoria(categoria, cons_f))][!is.na(cat_cons)]
  ancho <- merge(ancho, cons, by = "id", all.x = TRUE)
  ancho[!is.na(cat_cons), final := cat_cons][, cat_cons := NULL]
  cat("Consenso aplicado a", nrow(cons), "referencias\n")
}
sin_clasificar <- clave[!id %in% ancho$id]

conteos <- tabla_cruzada(ancho, "tratamiento", "final", c(CATS, "sin_consenso"))
escribir_csv(conteos, file.path(DIR_SALIDAS, "nsf_conteos.csv"))

# --- Proporciones con IC de Wilson ----------------------------------------------------------------
prop <- ancho[final != "sin_consenso", {
  n <- .N; x <- sum(final == "utilizable"); w <- wilson(x, n)
  .(n = n, utilizables = x, existe_no_dice = sum(final == "existe_no_dice"), no_existe = sum(final == "no_existe"),
    p_utilizable = round(w[["p"]], 3), ic95_inf = round(w[["li"]], 3), ic95_sup = round(w[["ls"]], 3))
}, by = tratamiento][order(tratamiento)]
prop[, herramienta := TRATAMIENTOS[tratamiento]]
escribir_csv(prop, file.path(DIR_SALIDAS, "nsf_proporciones.csv"))

# --- Diferencias frente al control A ------------------------------------------------------------------
dif <- rbindlist(lapply(intersect(c("B", "C"), prop$tratamiento), function(t) {
  if (!"A" %in% prop$tratamiento) return(NULL)
  a <- prop[tratamiento == "A"]; b <- prop[tratamiento == t]
  nc <- newcombe(b$utilizables, b$n, a$utilizables, a$n)
  f <- fisher.test(matrix(c(b$utilizables, b$n - b$utilizables, a$utilizables, a$n - a$utilizables), 2))
  data.table(comparacion = paste(t, "- A"), diferencia = round(nc[["dif"]], 3),
             ic95_inf = round(nc[["li"]], 3), ic95_sup = round(nc[["ls"]], 3), p_fisher = signif(f$p.value, 3))
}))
escribir_csv(dif, file.path(DIR_SALIDAS, "nsf_diferencias.csv"))

# --- Acuerdo entre clasificadores --------------------------------------------------------------------
completas <- ancho[complete.cases(ancho[, ..CLASIF])]
acuerdo <- list(data.table(medida = "clasificadores", valor = paste(CLASIF, collapse = ", ")),
                data.table(medida = "referencias clasificadas por todos", valor = nrow(completas)))
if (length(CLASIF) >= 2 && nrow(completas)) {
  m <- as.matrix(completas[, ..CLASIF])
  todos_igual <- apply(m, 1, function(v) length(unique(v)) == 1)
  acuerdo[[length(acuerdo) + 1]] <- data.table(
    medida = c("referencias con desacuerdo", "acuerdo total (%)"),
    valor = c(sum(!todos_igual), round(100 * mean(todos_igual), 1)))
  for (par in combn(CLASIF, 2, simplify = FALSE)) {
    k <- suppressWarnings(kappa2(m[, par])$value)
    acuerdo[[length(acuerdo) + 1]] <- data.table(
      medida = c(sprintf("acuerdo %s-%s (%%)", par[1], par[2]), sprintf("kappa de Cohen %s-%s", par[1], par[2])),
      valor = c(round(100 * mean(m[, par[1]] == m[, par[2]]), 1), round(k, 3)))
  }
  if (length(CLASIF) >= 3) {
    fk <- suppressWarnings(kappam.fleiss(m))
    acuerdo[[length(acuerdo) + 1]] <- data.table(medida = "kappa de Fleiss", valor = round(fk$value, 3))
  }
  des <- completas[!todos_igual]
  escribir_csv(des, file.path(DIR_SALIDAS, "nsf_desacuerdos.csv"))
  # ¿Qué categoría está en juego cuando no coinciden?
  if (nrow(des)) {
    impl <- table(unlist(apply(as.matrix(des[, ..CLASIF]), 1, unique)))
    acuerdo[[length(acuerdo) + 1]] <- data.table(
      medida = paste("desacuerdos que involucran", names(impl)), valor = as.integer(impl))
  }
}
acuerdo <- rbindlist(acuerdo)[, valor := as.character(valor)]
escribir_csv(acuerdo, file.path(DIR_SALIDAS, "nsf_acuerdo.csv"))

# --- Resumen en consola ---------------------------------------------------------------------------------
cat("\n--- Etiqueta final por tratamiento ---\n"); print(conteos)
cat("\n--- Proporción de referencias utilizables (IC de Wilson 95 %) ---\n")
print(prop[, .(tratamiento, herramienta, n, utilizables, p_utilizable, ic95_inf, ic95_sup)])
if (nrow(dif)) { cat("\n--- Diferencia frente al control A (IC de Newcombe 95 %) ---\n"); print(dif) }
cat("\n--- Acuerdo entre clasificadores ---\n"); print(acuerdo)
if (nrow(sin_clasificar)) cat("\nReferencias que nadie ha clasificado:", nrow(sin_clasificar), "\n")
cat("\nListo: salidas/nsf_*.csv\n")
