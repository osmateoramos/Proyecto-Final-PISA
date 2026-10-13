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
#   nsf_descartadas.csv               referencias que la herramienta nombró solo para descartarlas
#   nsf_sensibilidad_descartadas.csv  proporciones sin y con las descartadas
#   nsf_rango_sin_mayoria.csv         proporción si las referencias sin mayoría fueran todas no utilizables
#                                     (mínimo) o todas utilizables (máximo)
#
# Etiqueta final: la categoría que eligió la mayoría (2 de 3). Si no hay mayoría,
# queda "sin_consenso" y no entra a las proporciones, salvo que se resuelva en
# clasificacion_consenso.csv. Las referencias de una misma consulta no son
# independientes: los IC son orientativos (se declara en la memoria).
#
# Descartadas (aclaración de la regla de conteo, 2026-10-13): si la afirmación atribuida empieza por
# "Descartada", la herramienta nombró la fuente solo para decir que no sirve; no es una fuente ofrecida.
# Se conservan sus clasificaciones, pero no entran a conteos, proporciones ni acuerdo.
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

clave <- leer_csv(file.path(DIR_E, "clave_referencias.csv"))[
  , .(id, persona_consulta = persona, tratamiento, referencia, afirmacion_atribuida)]
clave[, descartada := grepl("^\\s*descartad[ao]", afirmacion_atribuida, ignore.case = TRUE)]
n_analisis <- clave[descartada == FALSE, .N]

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
cl <- merge(cl, clave[, .(id, tratamiento, descartada)], by = "id")
cat("Clasificaciones por integrante (sin las descartadas):\n"); print(cl[descartada == FALSE, .N, by = clasificador])
avance <- cl[descartada == FALSE, .(clasificadas = .N), by = clasificador]
if (length(CLASIF) < length(PERSONAS) || any(avance$clasificadas < n_analisis))
  cat("AVISO: hay hojas incompletas; el análisis usa lo que hay.\n")

ancho_todo <- dcast(cl, id + tratamiento + descartada ~ clasificador, value.var = "categoria")

# --- Conteos por clasificador -------------------------------------------------------------
tabla_cruzada <- function(d, filas, col, niveles) {
  d <- copy(d)[, (col) := factor(get(col), levels = niveles)]
  f <- as.formula(paste(paste(filas, collapse = " + "), "~", col))
  dcast(d, f, fun.aggregate = length, value.var = col, drop = c(TRUE, FALSE))
}
por_clasif <- tabla_cruzada(cl[descartada == FALSE], c("clasificador", "tratamiento"), "categoria", CATS)
escribir_csv(por_clasif, file.path(DIR_SALIDAS, "nsf_conteos_por_clasificador.csv"))

# --- Etiqueta final por mayoría ---------------------------------------------------------------
mayoria <- function(v) {
  v <- v[!is.na(v)]
  if (length(v) < 2) return("sin_consenso")
  t <- sort(table(v), decreasing = TRUE)
  if (t[[1]] > length(v) / 2) names(t)[1] else "sin_consenso"
}
ancho_todo[, final := apply(.SD, 1, mayoria), .SDcols = CLASIF]
cons_f <- file.path(DIR_E, "clasificacion_consenso.csv")
if (file.exists(cons_f)) {
  cons <- leer_csv(cons_f)[, .(id, cat_cons = normalizar_categoria(categoria, cons_f))][!is.na(cat_cons)]
  ancho_todo <- merge(ancho_todo, cons, by = "id", all.x = TRUE)
  ancho_todo[!is.na(cat_cons), final := cat_cons][, cat_cons := NULL]
  cat("Consenso aplicado a", nrow(cons), "referencias\n")
}
ancho <- ancho_todo[descartada == FALSE]
sin_clasificar <- clave[descartada == FALSE & !id %in% ancho$id]

conteos <- tabla_cruzada(ancho, "tratamiento", "final", c(CATS, "sin_consenso"))
escribir_csv(conteos, file.path(DIR_SALIDAS, "nsf_conteos.csv"))

# --- Descartadas: se listan aparte, con lo que les asignó cada clasificador ----------------------------
descartadas <- merge(clave[descartada == TRUE, .(id, persona_consulta, tratamiento, referencia,
                                                motivo = afirmacion_atribuida)],
                     ancho_todo[descartada == TRUE, c("id", CLASIF), with = FALSE], by = "id", all.x = TRUE)
escribir_csv(descartadas, file.path(DIR_SALIDAS, "nsf_descartadas.csv"))

# --- Proporciones con IC de Wilson ----------------------------------------------------------------
proporciones <- function(d) {
  p <- d[final != "sin_consenso", {
    n <- .N; x <- sum(final == "utilizable"); w <- wilson(x, n)
    .(n = n, utilizables = x, existe_no_dice = sum(final == "existe_no_dice"), no_existe = sum(final == "no_existe"),
      p_utilizable = round(w[["p"]], 3), ic95_inf = round(w[["li"]], 3), ic95_sup = round(w[["ls"]], 3))
  }, by = tratamiento][order(tratamiento)]
  p[, herramienta := TRATAMIENTOS[tratamiento]]
}
prop <- proporciones(ancho)
escribir_csv(prop, file.path(DIR_SALIDAS, "nsf_proporciones.csv"))

# Sensibilidad: la aclaración se decidió después de clasificar, así que se reporta también contándolas
sens <- rbind(prop[, .(version = "sin descartadas (análisis)", tratamiento, n, utilizables, p_utilizable)],
              proporciones(ancho_todo)[, .(version = "contando las descartadas", tratamiento, n, utilizables,
                                           p_utilizable)])
escribir_csv(sens, file.path(DIR_SALIDAS, "nsf_sensibilidad_descartadas.csv"))

# Las referencias sin mayoría salen de las proporciones; si se concentran en un tratamiento, su proporción puede
# quedar inflada. El rango va de contarlas todas como no utilizables a contarlas todas como utilizables.
rango <- ancho[, .(n_total = .N, utilizables = sum(final == "utilizable"), sin_mayoria = sum(final == "sin_consenso")),
               by = tratamiento][order(tratamiento)]
rango[, `:=`(p_analisis = round(utilizables / (n_total - sin_mayoria), 3),
             p_min = round(utilizables / n_total, 3),
             p_max = round((utilizables + sin_mayoria) / n_total, 3))]
escribir_csv(rango, file.path(DIR_SALIDAS, "nsf_rango_sin_mayoria.csv"))

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
cat("\nDescartadas por la herramienta (fuera del análisis):", nrow(descartadas), "\n")
cat("\n--- Sensibilidad: proporción de utilizables sin y con las descartadas ---\n"); print(sens)
cat("\n--- Rango según cómo se cuenten las referencias sin mayoría ---\n"); print(rango)
cat("\nListo: salidas/nsf_*.csv\n")
