# =============================================================================
# EXPLORACION PREVIA A 05 - Ítems de matemáticas por competencia (Colombia, PISA 2022)
#
# Para qué: preparar las decisiones de la F5 (D-05, D-23 puntos 2 a 4, P2) ANTES de calibrar.
# No estima modelos: solo clasifica y cuenta.
#
# Qué hace:
#   1. Paso 5.1: lee la hoja Mathematics-CBA del anexo A del Technical Report 2022 (xlsx, con xml2) y arma la
#      tabla ítem -> competencia, contenido, contexto, formato y parámetros internacionales.
#   2. Puntaje: los códigos de dos dígitos (11, 12, 21...) se leen por su primer dígito, que indica el crédito
#      (Technical Report, p. 313: «the first digit of assigned codes, denoting full, partial, and no credit»; y
#      las etiquetas del .SAV, p. ej. «21 - Full credit»). En esos ítems, 1 y 2 son «01» y «02» (sin crédito).
#      Se compara con el anexo (los ítems de crédito parcial tienen pasos).
#   3. En la muestra analítica (6.886): respuestas, omisiones y no alcanzados por ítem; ítems con < 500
#      respuestas (P2); respuestas en el cuartil bajo y el alto del NSE económico (D-24) y de ESCS (D-23 punto 3).
#   4. Tiempos para D-05: tiempo medio de cada ítem entre quienes lo vieron (respondido u omitido) y omisiones
#      por debajo del 10 % de esa media (NT10; Rios y Soland, 2022, citando a Wise y Ma, 2012), con y sin el
#      tope de 10 segundos.
#
# Salidas (solo agregados, Ley 1581): salidas/items_competencia.csv, salidas/items_respuestas.csv y
#   salidas/items_resumen_competencia.csv
#
# Cómo correrlo (desde Proyecto_PISA/scripts/, después de 03_nse_tri.R):
#   & "C:\Program Files\R\R-4.4.1\bin\Rscript.exe" 05_explorar_items.R
# =============================================================================

options(stringsAsFactors = FALSE, scipen = 999, width = 160)
suppressPackageStartupMessages({ library(data.table); library(xml2) })

carpeta_script <- function() {
  arg <- grep("^--file=", commandArgs(FALSE), value = TRUE)
  if (length(arg)) return(dirname(normalizePath(sub("^--file=", "", arg))))
  if (!is.null(sys.frames()[[1]]$ofile)) return(dirname(normalizePath(sys.frames()[[1]]$ofile)))
  getwd()
}
DIR     <- carpeta_script()
DATOS   <- normalizePath(file.path(DIR, "..", "datos"))
SALIDAS <- normalizePath(file.path(DIR, "..", "salidas"))
DOC     <- normalizePath(file.path(DIR, "..", "documentacion"))
for (f in c("COL_cognitivo.rds", "COL_nse.rds", "COL_nse_tri.rds")) if (!file.exists(file.path(DATOS, f))) stop("Falta datos/", f)

# =============================================================================
# 1. ANEXO A, hoja Mathematics-CBA (paso 5.1)
# =============================================================================
tmp <- file.path(tempdir(), "anexoA"); unzip(file.path(DOC, "PISA2022_TechnicalReport_AnexoA_clasificacion_items.xlsx"), exdir = tmp)
wb <- read_xml(file.path(tmp, "xl/workbook.xml"))
hojas <- xml_find_all(wb, "//*[local-name()='sheet']"); stopifnot("Mathematics-CBA" %in% xml_attr(hojas, "name"))
rels <- xml_find_all(read_xml(file.path(tmp, "xl/_rels/workbook.xml.rels")), "//*[local-name()='Relationship']")
rid  <- vapply(hojas, function(h) { a <- xml_attrs(h); a[grepl("id$", names(a)) & names(a) != "sheetId"][1] }, "")
archivo <- xml_attr(rels, "Target")[match(rid[xml_attr(hojas, "name") == "Mathematics-CBA"], xml_attr(rels, "Id"))]
cadenas <- xml_text(xml_find_all(read_xml(file.path(tmp, "xl/sharedStrings.xml")), "//*[local-name()='si']"))
sh <- read_xml(file.path(tmp, "xl", sub("^/?xl/", "", archivo)))
celdas <- xml_find_all(sh, "//*[local-name()='sheetData']/*[local-name()='row']/*[local-name()='c']")
ref <- xml_attr(celdas, "r"); tipo <- xml_attr(celdas, "t"); v <- xml_text(celdas)
k <- !is.na(tipo) & tipo == "s"; v[k] <- cadenas[as.integer(v[k]) + 1]
m <- data.table(fila = as.integer(sub("^[A-Z]+", "", ref)), col = sub("[0-9]+$", "", ref), valor = trimws(v))
stopifnot(m[fila == 1 & col == "A", valor] == "Item ID in MS Analysis Output", grepl("^Process", m[fila == 1 & col == "K", valor]))
an <- dcast(m[fila >= 3 & col %in% c("A", "B", "F", "G", "H", "I", "J", "K", "O", "P", "Q", "R")], fila ~ col, value.var = "valor")
setnames(an, c("A", "B", "F", "G", "H", "I", "J", "K", "O", "P", "Q", "R"),
         c("item_anexo", "unidad", "tipo_unidad", "orden_en_unidad", "formato", "contenido", "contexto", "proceso",
           "a_int", "b_int", "paso1_int", "paso2_int"))
an <- an[!is.na(item_anexo) & item_anexo != ""]
an[, retirado := grepl("Dropped", item_anexo)]
an[, base := sub("[SC]$", "", sub(" *\\(Dropped\\)", "", item_anexo))]
an[, competencia := fcase(grepl("^Formulat", proceso), "formular", grepl("^Employ", proceso), "emplear",
                          grepl("^Interpret", proceso), "interpretar", grepl("^Reason", proceso), "razonar")]
stopifnot(!anyNA(an$competencia))
for (c0 in c("a_int", "b_int", "paso1_int", "paso2_int")) an[, (c0) := suppressWarnings(as.numeric(get(c0)))]

# =============================================================================
# 2. DATOS DE COLOMBIA Y PUNTAJE POR EL PRIMER DÍGITO
# =============================================================================
cog <- readRDS(file.path(DATOS, "COL_cognitivo.rds"))
nse <- readRDS(file.path(DATOS, "COL_nse.rds")); tri <- readRDS(file.path(DATOS, "COL_nse_tri.rds"))
ITEMS <- grep("^[CD]M[A-Z0-9]+Q[0-9]+[SC]$", names(cog), value = TRUE)
stopifnot(length(ITEMS) == 234)
cruce <- data.table(item = ITEMS, base = sub("[SC]$", "", ITEMS))
cruce <- merge(cruce, an[, .(base, item_anexo, unidad, tipo_unidad, orden_en_unidad, formato, contenido, contexto, competencia,
                             a_int, b_int, paso1_int, paso2_int, retirado)], by = "base", all.x = TRUE)
# Primer dígito = crédito (TR p. 313). En un ítem con códigos de dos dígitos, los de un dígito son «0x» con el cero
# inicial perdido: en DM462Q01C, 1 y 2 son «01 - No credit» y «02 - No credit» según las etiquetas del .SAV.
puntaje <- function(x) if (any(x >= 10, na.rm = TRUE)) x %/% 10 else x

an_col <- cog[CNTSTUID %in% nse$CNTSTUID]                               # muestra analítica (D-14)
stopifnot(nrow(an_col) == 6886)
an_col <- merge(an_col, data.table(CNTSTUID = nse$CNTSTUID, W = nse$W_FSTUWT, ESCS = nse$ESCS, ECO = tri$eap_AFE_ECO),
                by = "CNTSTUID")
cuartil_w <- function(x, w) { o <- order(x); cw <- cumsum(w[o]) / sum(w[o]); q <- integer(length(x)); q[o] <- pmin(4L, 1L + floor(4 * cw - 1e-9)); q }
an_col[, `:=`(q_ECO = cuartil_w(ECO, W), q_ESCS = cuartil_w(ESCS, W))]

resp <- rbindlist(lapply(ITEMS, function(j) {
  e <- an_col[[paste0("E_", j)]]; s <- puntaje(an_col[[j]])
  tt <- an_col[[paste0(sub("^D", "C", sub("[SC]$", "", j)), "TT")]] / 1000     # tiempo en s; los ítems D usan el prefijo C
  visto <- e %in% c("respondido", "omitido") & !is.na(tt)
  media <- if (any(visto)) mean(tt[visto]) else NA_real_
  umb <- 0.10 * media; umb_tope <- min(umb, 10)
  om <- e == "omitido"; om_t <- om & !is.na(tt)
  data.table(item = j,
             codigos = paste(sort(unique(na.omit(an_col[[j]]))), collapse = "/"),
             categorias_puntaje = paste(sort(unique(na.omit(s))), collapse = "/"),
             n_respondido = sum(e == "respondido"), n_omitido = sum(om), n_no_alcanzado = sum(e == "no_alcanzado"),
             n_no_aplicable = sum(e == "no_aplicable"),
             n_resp_Q1_ECO = sum(e == "respondido" & an_col$q_ECO == 1), n_resp_Q4_ECO = sum(e == "respondido" & an_col$q_ECO == 4),
             n_resp_Q1_ESCS = sum(e == "respondido" & an_col$q_ESCS == 1, na.rm = TRUE),
             n_resp_Q4_ESCS = sum(e == "respondido" & an_col$q_ESCS == 4, na.rm = TRUE),
             tiempo_medio_s = round(media, 1), umbral_NT10_s = round(umb, 2), umbral_NT10_tope_s = round(umb_tope, 2),
             omisiones_rapidas_NT10 = sum(om_t & tt < umb), omisiones_rapidas_NT10_tope = sum(om_t & tt < umb_tope),
             omisiones_rapidas_Q1_ECO = sum(om_t & tt < umb & an_col$q_ECO == 1),
             omisiones_rapidas_Q4_ECO = sum(om_t & tt < umb & an_col$q_ECO == 4),
             omisiones_Q1_ECO = sum(om & an_col$q_ECO == 1), omisiones_Q4_ECO = sum(om & an_col$q_ECO == 4)) }))
items <- merge(cruce, resp, by = "item")
items[, `:=`(puntaje_max = vapply(strsplit(categorias_puntaje, "/"), function(z) if (length(z)) max(as.numeric(z)) else NA_real_, 1),
             credito_parcial_anexo = !is.na(paso1_int))]
items[, coincide_parcial := (puntaje_max == 2) == credito_parcial_anexo]
items[, `:=`(calibrable = n_respondido > 0 & !retirado, menos_500 = n_respondido < 500,
             elegible_DIF_ECO = n_resp_Q1_ECO >= 100 & n_resp_Q4_ECO >= 100,
             elegible_DIF_ESCS = n_resp_Q1_ESCS >= 100 & n_resp_Q4_ESCS >= 100)]
setcolorder(items, c("item", "competencia", "unidad", "contenido", "contexto", "formato", "tipo_unidad", "retirado"))

fwrite(items[, .(item, item_anexo, competencia, unidad, orden_en_unidad, tipo_unidad, formato, contenido, contexto,
                 a_int, b_int, paso1_int, paso2_int, retirado, calibrable)][order(competencia, item)],
       file.path(SALIDAS, "items_competencia.csv"))
fwrite(items[, !c("base", "item_anexo", "unidad", "orden_en_unidad", "tipo_unidad", "formato", "contenido", "contexto",
                  "a_int", "b_int", "paso1_int", "paso2_int")][order(competencia, item)],
       file.path(SALIDAS, "items_respuestas.csv"))

# --- Ítems vistos por estudiante (respondido u omitido) en la muestra analítica
vistos <- rowSums(sapply(ITEMS, function(j) an_col[[paste0("E_", j)]] %in% c("respondido", "omitido")))

resumen <- items[!is.na(competencia), .(items_anexo = .N, calibrables = sum(calibrable),
                    menos_500 = sum(calibrable & menos_500), elegibles_DIF_ECO = sum(calibrable & elegible_DIF_ECO),
                    elegibles_DIF_ESCS = sum(calibrable & elegible_DIF_ESCS), credito_parcial = sum(calibrable & puntaje_max == 2, na.rm = TRUE),
                    respuestas = sum(n_respondido), omisiones = sum(n_omitido),
                    omisiones_rapidas_NT10 = sum(omisiones_rapidas_NT10), omisiones_rapidas_NT10_tope = sum(omisiones_rapidas_NT10_tope)),
                 by = competencia][order(competencia)]
resumen <- rbind(resumen, resumen[, c(list(competencia = "total"), lapply(.SD, sum)), .SDcols = -"competencia"])
fwrite(resumen, file.path(SALIDAS, "items_resumen_competencia.csv"))

# =============================================================================
# RESUMEN EN CONSOLA
# =============================================================================
cat("--- 5.1 Anexo A: ítems de la hoja Mathematics-CBA:", nrow(an), "| retirados:", sum(an$retirado), "\n")
cat("Ítems de Colombia (234) sin fila en el anexo:", paste(items[is.na(competencia), item], collapse = ", "), "\n")
cat("Sin respuestas en la muestra analítica:", paste(items[n_respondido == 0, item], collapse = ", "), "\n")
cat("\n--- Resumen por competencia (salidas/items_resumen_competencia.csv) ---\n"); print(resumen)
cat("\n--- Códigos de puntaje y crédito parcial ---\n"); print(items[, .N, by = .(codigos, categorias_puntaje)][order(-N)])
cat("Crédito parcial según los datos (puntaje 0/1/2) vs. según el anexo (tiene pasos): coinciden",
    sum(items$coincide_parcial, na.rm = TRUE), "de", sum(!is.na(items$coincide_parcial)), "\n")
print(items[coincide_parcial == FALSE, .(item, codigos, categorias_puntaje, paso1_int, paso2_int)])
cat("\n--- Ítems vistos por estudiante (muestra analítica) ---\n"); print(summary(vistos))
cat("\n--- Omisiones y omisiones rápidas (NT10) por cuartil del NSE económico ---\n")
print(items[, .(omisiones_Q1 = sum(omisiones_Q1_ECO), rapidas_Q1 = sum(omisiones_rapidas_Q1_ECO),
                omisiones_Q4 = sum(omisiones_Q4_ECO), rapidas_Q4 = sum(omisiones_rapidas_Q4_ECO))])
cat("Umbral NT10 (s): "); print(summary(items$umbral_NT10_s))
