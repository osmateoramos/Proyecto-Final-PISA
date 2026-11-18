# =============================================================================
# 08 NSE TRI: complementos del Taller 2 de TRI - PISA 2022 Colombia (D-52)
#
# Decisión: D-52 (Vault_PISA2022/03 Registro de decisiones.md). Es POSTERIOR a la Puerta G4 y descriptivo: estudia las
# propiedades de la escala del NSE. No cambia H1, H2, el NSE que usa la F6 ni las salidas de resultados-v1.
# Entrada: datos/COL_nse.rds (03_nse_medicion.R), salidas/nse_estructura_afe.csv (3.2), salidas/nse_q3_tri.csv
#   (03_nse_tri.R) y salidas/nse_dif_posesiones.csv (04_invarianza.R, para el libro de resultados).
#
# Modelo de referencia: la estructura del AFE (D-24). Cada ítem carga en un solo factor, así que cada subescala
# (económica, 19 ítems; libros, 10 ítems) se calibra con un modelo de 1 dimensión. Eso permite la parametrización
# tradicional (a, b), el mapa de Wright, la curva característica, Mokken y el puntaje total, que son unidimensionales.
#   1. Familias de modelos, ponderadas: Rasch/PCM, 2PL/GPCM (el del proyecto) y 2PL/GRM. Con pesos es
#      pseudo-verosimilitud: la comparación es descriptiva (como en D-19).
#   2. Ajuste absoluto del 2PL/GPCM: M2 (tipo C2), RMSEA2, SRMSR, CFI y TLI, con los faltantes imputados.
#   3. Mokken: H de Loevinger por ítem y por subescala, y monotonicidad, en casos completos y sin pesos.
#   5. Independencia local: criterio Q3 - media(Q3) > 0,20 sobre los Q3 del 2D del AFE que ya calculó 03_nse_tri.R.
#   6. Ajuste de personas: Zh; solo el porcentaje con Zh < -1,645, en total y por sexo, zona y sector.
#   7. Parámetros a y b con errores estándar de Oakes (NO reflejan el diseño por colegios), clasificación de Baker y
#      Kim y umbrales desordenados.
#   8. Mapa de Wright por subescala. Curvas de información, error estándar condicional y curva característica.
#   9. EAP y MAP; patrones extremos; relación con el puntaje total.
#  10. Libro Taller2_TRI_resultados.xlsx con las 6 hojas del taller. La hoja de puntajes va en resúmenes (percentiles y
#      por grupo), no por estudiante (Ley 1581 de 2012).
#
# Salidas (solo agregados): salidas/nse_taller_*.csv, nse_taller_*.png y Taller2_TRI_resultados.xlsx.
# Caché (no va a Git): datos/COL_nse_taller_modelos.rds. Para reestimar: $env:REHACER_TALLER = "1".
#
# Cómo correrlo (desde Proyecto_PISA/scripts/, después de 03_nse_tri.R y 04_invarianza.R):
#   & "C:\Program Files\R\R-4.4.1\bin\Rscript.exe" 08_nse_tri_taller.R
# =============================================================================

options(stringsAsFactors = FALSE, scipen = 999, width = 160)
suppressPackageStartupMessages({ library(data.table); library(mirt); library(mokken); library(ggplot2)
  library(writexl) })
set.seed(2026)

carpeta_script <- function() {
  arg <- grep("^--file=", commandArgs(FALSE), value = TRUE)
  if (length(arg)) return(dirname(normalizePath(sub("^--file=", "", arg))))
  if (!is.null(sys.frames()[[1]]$ofile)) return(dirname(normalizePath(sys.frames()[[1]]$ofile)))
  getwd()
}
DIR     <- carpeta_script()                                        # Proyecto_PISA/scripts
DATOS   <- normalizePath(file.path(DIR, "..", "datos"))
SALIDAS <- normalizePath(file.path(DIR, "..", "salidas"))
for (f in c(file.path(DATOS, "COL_nse.rds"), file.path(SALIDAS, c("nse_estructura_afe.csv", "nse_q3_tri.csv",
                                                                   "nse_dif_posesiones.csv"))))
  if (!file.exists(f)) stop("Falta ", f, ": correr antes 03_nse_medicion.R, 03_nse_tri.R y 04_invarianza.R")

nse <- readRDS(file.path(DATOS, "COL_nse.rds"))
fac <- attr(nse, "factores"); IND <- c(fac$economico, fac$cultural)
est_afe <- fread(file.path(SALIDAS, "nse_estructura_afe.csv"), encoding = "UTF-8")
CUL <- est_afe[factor_AFE == "cultural", item]; ECO <- setdiff(IND, CUL)
stopifnot(nrow(nse) == 6886, length(ECO) == 19, length(CUL) == 10)
SUB <- list(economico = ECO, libros = CUL)
NOMBRE_SUB <- c(economico = "NSE económico", libros = "NSE libros")
w <- nse$W_FSTUWT * nrow(nse) / sum(nse$W_FSTUWT)                   # pesos normalizados (D-16 punto 5)
dicotomico <- function(items) grepl("^ST250", items)               # ítems Sí/No (2PL), como en 03_nse_tri.R
FAMILIAS <- list("Rasch/PCM" = function(it) rep("Rasch", length(it)),
                 "2PL/GPCM"  = function(it) ifelse(dicotomico(it), "2PL", "gpcm"),
                 "2PL/GRM"   = function(it) ifelse(dicotomico(it), "2PL", "graded"))
REF <- "2PL/GPCM"                                                   # el modelo del proyecto (D-16, D-19)
# Cada subescala se calibra con quienes respondieron al menos uno de sus ítems: mirt descarta los patrones sin
# ninguna respuesta y los pesos tienen que ir con las mismas filas.
FILAS <- lapply(SUB, function(it) which(rowSums(!is.na(as.data.frame(nse[, it, with = FALSE]))) > 0))
datos_sub <- function(s) as.data.frame(nse[FILAS[[s]], SUB[[s]], with = FALSE])
peso_sub  <- function(s) w[FILAS[[s]]]
cat("Estudiantes sin ninguna respuesta en la subescala (quedan fuera de su calibración):\n")
print(sapply(FILAS, function(f) nrow(nse) - length(f)))

# =============================================================================
# 1. FAMILIAS DE MODELOS (con caché: el modelo de referencia lleva errores estándar de Oakes)
# =============================================================================
ajustar <- function(X, tipos, SE, pesos) mirt(X, 1, itemtype = tipos, survey.weights = pesos, SE = SE,
                                              SE.type = "Oakes", verbose = FALSE, technical = list(NCYCLES = 3000))
MODELOS <- file.path(DATOS, "COL_nse_taller_modelos.rds")
huella <- function(...) { f <- tempfile(); on.exit(unlink(f))
  writeBin(serialize(list(...), NULL, version = 3), f); unname(tools::md5sum(f)) }
HUELLA <- huella(lapply(names(SUB), function(s) as.list(datos_sub(s))), w, SUB, names(FAMILIAS))
modelos <- if (file.exists(MODELOS) && Sys.getenv("REHACER_TALLER") != "1") readRDS(MODELOS) else NULL
if (is.null(modelos) || !identical(attr(modelos, "huella_datos"), HUELLA)) {
  t0 <- Sys.time()
  modelos <- list()
  for (s in names(SUB)) for (f in names(FAMILIAS)) {
    cat("Ajustando", s, f, "\n")
    modelos[[s]][[f]] <- ajustar(datos_sub(s), FAMILIAS[[f]](SUB[[s]]), SE = (f == REF), pesos = peso_sub(s))
  }
  attr(modelos, "huella_datos") <- HUELLA
  attr(modelos, "minutos") <- round(as.numeric(Sys.time() - t0, units = "mins"), 1)
  saveRDS(modelos, MODELOS)
} else cat("Modelos leídos del caché", basename(MODELOS), "\n")
cat("Minutos de estimación (de la corrida que hizo el caché):", attr(modelos, "minutos"), "\n")

comparacion <- rbindlist(lapply(names(SUB), function(s) rbindlist(lapply(names(FAMILIAS), function(f) {
  m <- modelos[[s]][[f]]
  data.table(subescala = s, familia = f, convergio = extract.mirt(m, "converged"),
             iteraciones = extract.mirt(m, "iterations"), logLik = round(extract.mirt(m, "logLik"), 1),
             parametros = extract.mirt(m, "nest"), AIC = round(extract.mirt(m, "AIC"), 1),
             BIC = round(extract.mirt(m, "BIC"), 1), SABIC = round(extract.mirt(m, "SABIC"), 1)) }))))
comparacion[, `:=`(dif_AIC = round(AIC - min(AIC), 1), dif_BIC = round(BIC - min(BIC), 1),
                   dif_SABIC = round(SABIC - min(SABIC), 1)), by = subescala]
# Razón de verosimilitudes de los anidados: Rasch/PCM dentro de 2PL/GPCM (pendientes iguales a 1 frente a libres)
rv <- comparacion[, {
  l0 <- logLik[familia == "Rasch/PCM"]; l1 <- logLik[familia == REF]
  gl <- parametros[familia == REF] - parametros[familia == "Rasch/PCM"]; G2 <- -2 * (l0 - l1)
  .(G2_Rasch_vs_2PL = round(G2, 1), gl_G2 = gl, p_G2 = signif(pchisq(G2, gl, lower.tail = FALSE), 3)) },
  by = subescala]
comparacion <- merge(comparacion, rv, by = "subescala", sort = FALSE)
comparacion[familia != "Rasch/PCM", `:=`(G2_Rasch_vs_2PL = NA, gl_G2 = NA, p_G2 = NA)]
comparacion[familia == "Rasch/PCM", nota_G2 := "frente a 2PL/GPCM; pseudo-verosimilitud ponderada: descriptivo (D-19)"]
stopifnot(all(comparacion$convergio))
fwrite(comparacion, file.path(SALIDAS, "nse_taller_modelos.csv"))

# =============================================================================
# 2. AJUSTE ABSOLUTO: M2 (tipo C2) del modelo de referencia, con los faltantes imputados
# =============================================================================
# M2 necesita datos completos: con faltantes imputa 10 veces con valores plausibles y promedia. Si no acepta el
# modelo ponderado, se calcula con el mismo modelo sin pesos y se dice.
m2_de <- function(s) {
  m <- modelos[[s]][[REF]]; X <- datos_sub(s); imp <- if (anyNA(X)) 10 else 0
  r <- tryCatch(M2(m, type = "C2", impute = imp), error = function(e) e)
  nota <- "modelo ponderado"
  if (inherits(r, "error")) {
    cat("M2 con pesos falló en", s, ":", conditionMessage(r), "-> sin pesos\n")
    m0 <- mirt(X, 1, itemtype = FAMILIAS[[REF]](SUB[[s]]), verbose = FALSE, technical = list(NCYCLES = 3000))
    r <- M2(m0, type = "C2", impute = imp); nota <- "modelo sin pesos (M2 no admitió el ponderado)"
  }
  r <- as.data.table(r)[1]
  cbind(data.table(subescala = s, imputaciones = imp), r[, lapply(.SD, function(x) round(as.numeric(x), 4))],
        nota = nota)
}
m2 <- rbindlist(lapply(names(SUB), m2_de), fill = TRUE)
m2[, criterio := "RMSEA2 <= 0,05 y SRMSR <= 0,05: ajuste aproximado adecuado (Maydeu-Olivares y Joe, 2014, citado en el taller)"]
fwrite(m2, file.path(SALIDAS, "nse_taller_m2.csv"))

# =============================================================================
# 3. MOKKEN: escalabilidad (H de Loevinger) y monotonicidad, en casos completos y sin pesos
# =============================================================================
mokken_de <- function(s) {
  Xc <- na.omit(datos_sub(s)); Xc <- as.matrix(Xc - matrix(apply(Xc, 2, min), nrow(Xc), ncol(Xc), byrow = TRUE))
  h  <- coefH(Xc, se = FALSE, nice.output = FALSE)
  hi <- h$Hi; if (is.matrix(hi)) hi <- hi[, 1]
  H  <- h$H;  if (length(H) > 1) H <- H[1]
  mono <- as.data.table(summary(check.monotonicity(Xc)), keep.rownames = "item")
  items <- data.table(subescala = s, item = colnames(Xc), Hj = round(as.numeric(hi), 3))
  items <- merge(items, mono[, .(item, violaciones = `#vi`, violaciones_significativas = `#zsig`,
                                 crit = round(as.numeric(crit), 1))], by = "item", sort = FALSE)
  items[, Hj_menor_030 := Hj < 0.30]
  escala <- data.table(subescala = s, n_casos_completos = nrow(Xc), items = ncol(Xc), H = round(as.numeric(H), 3),
                       items_Hj_menor_030 = sum(items$Hj_menor_030),
                       items_con_violacion_significativa = sum(items$violaciones_significativas > 0))
  list(items = items, escala = escala)
}
mk <- lapply(names(SUB), mokken_de)
mk_items <- rbindlist(lapply(mk, `[[`, "items")); mk_escala <- rbindlist(lapply(mk, `[[`, "escala"))
mk_escala[, criterio := "H >= 0,30: escala aceptable (Loevinger, 1948, citado en el taller); crit > 80: violación seria (convención de mokken)"]
fwrite(mk_items, file.path(SALIDAS, "nse_taller_mokken_items.csv"))
fwrite(mk_escala, file.path(SALIDAS, "nse_taller_mokken_escalas.csv"))

# =============================================================================
# 5. INDEPENDENCIA LOCAL: criterio relativo de Christensen et al. (2017) sobre los Q3 del 2D del AFE
# =============================================================================
q3 <- fread(file.path(SALIDAS, "nse_q3_tri.csv"), encoding = "UTF-8")[modelo == "2D_AFE"]
media_q3 <- mean(q3$Q3)
q3[, `:=`(media_Q3 = round(media_q3, 3), Q3_menos_media = round(Q3 - media_q3, 3))]
q3[, marcado_relativo := Q3_menos_media > 0.20]
fwrite(q3[marcado_relativo | marcado], file.path(SALIDAS, "nse_taller_q3.csv"))
cat("Q3 (2D del AFE): media", round(media_q3, 3), "; pares con Q3 - media > 0,20:", sum(q3$marcado_relativo),
    "; con |Q3| > 0,2 (D-21):", sum(q3$marcado), "de", nrow(q3), "\n")

# =============================================================================
# 6, 7 y 9. PARÁMETROS, PUNTAJES Y AJUSTE DE PERSONAS (modelo de referencia)
# =============================================================================
baker_kim <- function(a) cut(a, c(-Inf, 0.35, 0.65, 1.35, 1.70, Inf), right = FALSE,
                             labels = c("muy baja", "baja", "moderada", "alta", "muy alta"))
parametros <- rbindlist(lapply(names(SUB), function(s) {
  cf <- coef(modelos[[s]][[REF]], IRTpars = TRUE, printSE = TRUE)
  rbindlist(lapply(SUB[[s]], function(it) {
    p <- cf[[it]]; est <- p["par", ]; ee <- if ("SE" %in% rownames(p)) p["SE", ] else rep(NA, ncol(p))
    b <- grep("^b[0-9]*$", colnames(p), value = TRUE)
    fila <- data.table(subescala = s, item = it, tipo = if (dicotomico(it)) "2PL" else "GPCM",
                       a = round(est[["a"]], 3), a_EE = round(ee[["a"]], 3))
    for (k in b) fila[, (k) := round(est[[k]], 3)][, (paste0(k, "_EE")) := round(ee[[k]], 3)]
    bs <- est[b]
    fila[, `:=`(categorias = length(b) + 1, umbrales_desordenados = length(bs) > 1 && any(diff(bs) < 0))]
    fila }), fill = TRUE) }), fill = TRUE)
parametros[, discriminacion_Baker_Kim := as.character(baker_kim(a))]
parametros[, nota := fifelse(tipo == "2PL", "", "En los GPCM la pendiente no es comparable con la de un 2PL (D-19): la clasificación es de referencia")]
parametros[, nota_EE := "EE de Oakes con pesos normalizados: no reflejan el diseño por colegios (D-19, D-52)"]
setcolorder(parametros, c("subescala", "item", "tipo", "categorias", "a", "a_EE", "discriminacion_Baker_Kim",
                          "umbrales_desordenados"))
fwrite(parametros, file.path(SALIDAS, "nse_taller_parametros.csv"))

# --- Ajuste de ítems del modelo de referencia (S-X2 en casos completos, sin pesos: itemfit no los admite; D-19)
itemfit_sub <- rbindlist(lapply(names(SUB), function(s) {
  r <- tryCatch(as.data.table(itemfit(modelos[[s]][[REF]], fit_stats = "S_X2", p.adjust = "BH", na.rm = TRUE)),
                error = function(e) data.table(item = SUB[[s]], nota = conditionMessage(e)))
  cbind(data.table(subescala = s), r) }), fill = TRUE)
num <- names(itemfit_sub)[sapply(itemfit_sub, is.numeric)]
itemfit_sub[, (num) := lapply(.SD, function(x) round(x, 4)), .SDcols = num]
if ("p.S_X2" %in% names(itemfit_sub)) itemfit_sub[, problematico := p.S_X2 < 0.05 & RMSEA.S_X2 > 0.05]
fwrite(itemfit_sub, file.path(SALIDAS, "nse_taller_itemfit.csv"))

# --- Puntajes: EAP y MAP, ajuste de personas (Zh) y puntaje total. Lo individual queda en memoria; solo se guardan
# resúmenes (Ley 1581).
wq <- function(x, p, pesos) { o <- order(x); x <- x[o]; cw <- cumsum(pesos[o]) / sum(pesos)
  vapply(p, function(q) x[which(cw >= q)[1]], numeric(1)) }
wcor <- function(x, y, pesos) { ok <- !is.na(x) & !is.na(y)
  cov.wt(cbind(x[ok], y[ok]), wt = pesos[ok], cor = TRUE)$cor[1, 2] }
puntajes <- list(); personas <- list(); totales <- list()
for (s in names(SUB)) {
  m <- modelos[[s]][[REF]]; X <- datos_sub(s); w <- peso_sub(s); grupos <- nse[FILAS[[s]]]
  eap <- fscores(m, method = "EAP", full.scores.SE = TRUE)
  map <- fscores(m, method = "MAP", full.scores.SE = TRUE)
  zh  <- personfit(m)$Zh
  maximo <- apply(X, 2, max, na.rm = TRUE); minimo <- apply(X, 2, min, na.rm = TRUE)
  respondidos <- rowSums(!is.na(X))
  todo_min <- respondidos > 0 & rowSums(sweep(X, 2, minimo, "=="), na.rm = TRUE) == respondidos
  todo_max <- respondidos > 0 & rowSums(sweep(X, 2, maximo, "=="), na.rm = TRUE) == respondidos
  completo <- respondidos == ncol(X); total <- ifelse(completo, rowSums(X), NA)
  for (met in c("EAP", "MAP")) {
    th <- if (met == "EAP") eap[, "F1"] else map[, "F1"]; se <- if (met == "EAP") eap[, "SE_F1"] else map[, "SE_F1"]
    q <- wq(th, c(0.05, 0.25, 0.5, 0.75, 0.95), w)
    puntajes[[length(puntajes) + 1]] <- data.table(
      subescala = s, metodo = met, n = sum(!is.na(th)), media_ponderada = round(weighted.mean(th, w, na.rm = TRUE), 3),
      de_ponderada = round(sqrt(cov.wt(cbind(th), wt = w)$cov[1, 1]), 3), p05 = q[1], p25 = q[2], p50 = q[3],
      p75 = q[4], p95 = q[5], ee_mediano = round(median(se, na.rm = TRUE), 3),
      confiabilidad_empirica = round(if (met == "EAP") empirical_rxx(eap) else NA_real_, 3),
      confiabilidad_marginal = round(if (met == "EAP") marginal_rxx(m) else NA_real_, 3),
      r_con_EAP = round(if (met == "MAP") wcor(th, eap[, "F1"], w) else 1, 4),
      r_puntaje_total = round(wcor(th, total, w), 3),
      rho_spearman_total = round(cor(th, total, method = "spearman", use = "complete.obs"), 3),
      n_puntaje_total = sum(completo), patrones_todo_minimo = sum(todo_min), patrones_todo_maximo = sum(todo_max))
  }
  aberrante <- zh < -1.645
  for (g in c("total", "sexo", "zona", "sector")) {
    grupo <- if (g == "total") rep("todos", nrow(grupos)) else as.character(grupos[[g]])
    grupo[is.na(grupo)] <- "sin dato"
    personas[[length(personas) + 1]] <- data.table(subescala = s, variable = g, grupo = grupo, ab = aberrante, w = w,
                                                   zh = zh)[!is.na(zh), .(
      n = .N, aberrantes = sum(ab), pct = round(100 * mean(ab), 2), pct_ponderado = round(100 * weighted.mean(ab, w), 2),
      zh_mediana = round(median(zh), 3)), by = .(subescala, variable, grupo)]
  }
  totales[[s]] <- data.table(subescala = s, total = total, theta = eap[, "F1"], w = w)[!is.na(total)]
}
w <- nse$W_FSTUWT * nrow(nse) / sum(nse$W_FSTUWT)                   # se restituye el peso de toda la muestra
puntajes <- rbindlist(puntajes); num <- c("p05", "p25", "p50", "p75", "p95")
puntajes[, (num) := lapply(.SD, round, 3), .SDcols = num]
puntajes[, nota := "Patrones todo en el mínimo o todo en el máximo: la máxima verosimilitud daría theta infinito; EAP y MAP dan un valor finito gracias a la previa N(0, 1)"]
fwrite(puntajes, file.path(SALIDAS, "nse_taller_puntajes.csv"))
personas <- rbindlist(personas)
personas[, criterio := "Zh < -1,645: patrón aberrante (Drasgow et al., 1985, citado en el taller)"]
fwrite(personas, file.path(SALIDAS, "nse_taller_personas.csv"))

# =============================================================================
# 8. CURVAS: información del test, error estándar condicional y curva característica; mapa de Wright
# =============================================================================
grilla <- matrix(seq(-4, 4, by = 0.05))
curvas <- rbindlist(lapply(names(SUB), function(s) { m <- modelos[[s]][[REF]]
  info <- testinfo(m, grilla)
  data.table(subescala = s, theta = round(grilla[, 1], 2), informacion = round(info, 4),
             ee_condicional = round(1 / sqrt(info), 4), puntaje_esperado = round(expected.test(m, grilla), 4),
             puntaje_maximo = sum(apply(datos_sub(s), 2, max, na.rm = TRUE))) }))
fwrite(curvas, file.path(SALIDAS, "nse_taller_curvas.csv"))
rango_preciso <- curvas[ee_condicional < 0.40, .(theta_min = min(theta), theta_max = max(theta)), by = subescala]
cat("\nRegión con EE condicional < 0,40 (confiabilidad ~0,84):\n"); print(rango_preciso)

etiqueta <- function(x) gsub(".", ",", format(x, decimal.mark = "."), fixed = TRUE)
largo <- melt(curvas, id.vars = c("subescala", "theta"), measure.vars = c("informacion", "ee_condicional",
                                                                          "puntaje_esperado"))
largo[, variable := factor(variable, c("informacion", "ee_condicional", "puntaje_esperado"),
                           c("Información del test", "Error estándar condicional", "Curva característica (puntaje esperado)"))]
largo[, subescala := NOMBRE_SUB[subescala]]
g <- ggplot(largo, aes(theta, value, colour = subescala)) + geom_line(linewidth = 0.8) +
  geom_hline(data = data.table(variable = factor("Error estándar condicional", levels(largo$variable)), y = 0.40),
             aes(yintercept = y), linetype = 2, colour = "grey50") +
  facet_wrap(~variable, scales = "free_y", nrow = 1) +
  scale_colour_manual(values = c("NSE económico" = "#1F5FA8", "NSE libros" = "#D9622B")) +
  scale_y_continuous(labels = etiqueta) + scale_x_continuous(labels = etiqueta) +
  labs(x = expression(theta), y = NULL, colour = NULL,
       caption = "Modelo 2PL/GPCM por subescala, ponderado. Línea punteada: EE = 0,40 (confiabilidad aproximada de 0,84).") +
  theme_minimal(base_size = 10) + theme(legend.position = "bottom")
ggsave(file.path(SALIDAS, "nse_taller_curvas.png"), g, width = 10, height = 3.6, dpi = 300, bg = "white")

# --- Mapa de Wright: distribución ponderada de theta (EAP) y umbrales de los ítems en la misma escala
umbrales <- melt(parametros[, c("subescala", "item", grep("^b[0-9]*$", names(parametros), value = TRUE)), with = FALSE],
                 id.vars = c("subescala", "item"), variable.name = "umbral", value.name = "theta")[!is.na(theta)]
umbrales[, orden := frank(-sapply(item, function(i) mean(theta[item == i])), ties.method = "dense"), by = subescala]
personas_th <- rbindlist(lapply(names(SUB), function(s)
  data.table(subescala = s, theta = fscores(modelos[[s]][[REF]], method = "EAP")[, 1], w = peso_sub(s))))
paneles <- c("Estudiantes (EAP, ponderado)", "Umbrales de los ítems")
nombre_sub <- function(s) factor(NOMBRE_SUB[s], NOMBRE_SUB)
hist_th <- personas_th[, .(Subescala = nombre_sub(subescala), panel = factor(paneles[1], paneles), theta, w)]
puntos  <- umbrales[, .(Subescala = nombre_sub(subescala), panel = factor(paneles[2], paneles), item, orden, theta)]
rotulos <- puntos[, .(theta = min(theta) - 0.25), by = .(Subescala, panel, item, orden)]
g <- ggplot() +
  geom_histogram(data = hist_th, aes(y = theta, weight = w), binwidth = 0.2, orientation = "y", fill = "grey70",
                 colour = "white") +
  geom_point(data = puntos, aes(x = orden, y = theta), size = 1.2, colour = "#1F5FA8") +
  geom_text(data = rotulos, aes(x = orden, y = theta, label = item), angle = 90, hjust = 1, size = 1.9) +
  facet_grid(Subescala ~ panel, scales = "free_x") +
  scale_y_continuous(labels = etiqueta, expand = expansion(add = c(2.8, 0.3))) +   # espacio para los rótulos
  labs(x = NULL, y = expression(theta), caption = paste("Umbrales: b (2PL) o b_k (GPCM) del modelo 2PL/GPCM por",
                                                        "subescala. Fuente: nse_taller_parametros.csv (08_nse_tri_taller.R).")) +
  theme_minimal(base_size = 9) + theme(axis.text.x = element_blank(), panel.grid.major.x = element_blank())
ggsave(file.path(SALIDAS, "nse_taller_wright.png"), g, width = 10, height = 7, dpi = 300, bg = "white")
cobertura <- merge(umbrales[, .(umbral_min = min(theta), umbral_max = max(theta)), by = subescala],
                   personas_th[, .(p05 = wq(theta, 0.05, w), p95 = wq(theta, 0.95, w)), by = subescala], by = "subescala")
cat("\nMapa de Wright: rango de los umbrales frente a los percentiles 5 y 95 de theta:\n"); print(cobertura)
fwrite(cobertura[, lapply(.SD, function(x) if (is.numeric(x)) round(x, 3) else x)],
       file.path(SALIDAS, "nse_taller_wright.csv"))

# --- Puntaje total frente a theta: celdas agregadas (se omiten las de menos de 5 estudiantes, Ley 1581)
celdas <- rbindlist(lapply(totales, function(d) d[, .(n = .N, n_pond = sum(w)),
                                                   by = .(subescala, total, theta_c = round(theta / 0.1) * 0.1)]))
celdas <- celdas[n >= 5][, Subescala := nombre_sub(subescala)]
g <- ggplot(celdas, aes(total, theta_c, fill = n_pond)) + geom_tile(height = 0.1) +
  facet_wrap(~Subescala, scales = "free_x") +
  scale_fill_gradient(low = "#C9D7EA", high = "#0B2E59", name = "Estudiantes\n(ponderado)") +
  scale_y_continuous(labels = etiqueta) +
  labs(x = "Puntaje total (casos completos)", y = expression(theta ~ "(EAP)"),
       caption = "Celdas de 0,1 en theta; se omiten las celdas con menos de 5 estudiantes (Ley 1581 de 2012).") +
  theme_minimal(base_size = 10)
ggsave(file.path(SALIDAS, "nse_taller_total.png"), g, width = 9, height = 4, dpi = 300, bg = "white")

# =============================================================================
# 10. LIBRO DE RESULTADOS DEL TALLER (solo agregados)
# =============================================================================
dif <- fread(file.path(SALIDAS, "nse_dif_posesiones.csv"), encoding = "UTF-8")
libro <- list(
  ajuste_modelos = merge(comparacion, m2[, !c("criterio"), with = FALSE][, familia := REF],
                         by = c("subescala", "familia"), all.x = TRUE, suffixes = c("", "_M2")),
  parametros = parametros,
  ajuste_items = itemfit_sub,
  dependencia_local = q3[marcado_relativo | marcado],
  dif = dif,
  puntajes = rbind(puntajes[, .(subescala, tabla = paste("theta", metodo), n, media_ponderada, de_ponderada, p05,
                                p25, p50, p75, p95, ee_mediano)],
                   personas[, .(subescala, tabla = paste("Zh por", variable, "-", grupo), n,
                                media_ponderada = NA_real_, de_ponderada = NA_real_, p05 = NA_real_, p25 = NA_real_,
                                p50 = zh_mediana, p75 = NA_real_, p95 = NA_real_, ee_mediano = NA_real_,
                                pct_aberrantes = pct, pct_aberrantes_ponderado = pct_ponderado)], fill = TRUE),
  LEEME = data.table(nota = c(
    "Libro de resultados del Taller 2 de TRI, aplicado a la escala del NSE (D-52). Lo genera 08_nse_tri_taller.R.",
    "Modelo de referencia: 2PL/GPCM por subescala (estructura del AFE, D-24), ponderado con W_FSTUWT normalizado.",
    "La hoja 'puntajes' va en resúmenes (percentiles y por grupo), no por estudiante: Ley 1581 de 2012.",
    "La hoja 'dif' es nse_dif_posesiones.csv (04_invarianza.R, D-26): regresión logística y TRI multigrupo.",
    "La hoja 'dependencia_local' marca |Q3| > 0,2 (D-21) y Q3 - media > 0,20 (criterio del taller)."))
)
write_xlsx(libro, file.path(SALIDAS, "Taller2_TRI_resultados.xlsx"))

cat("\n--- Familias de modelos (nse_taller_modelos.csv) ---\n"); print(comparacion)
cat("\n--- M2 (nse_taller_m2.csv) ---\n"); print(m2[, !c("criterio"), with = FALSE])
cat("\n--- Mokken (nse_taller_mokken_escalas.csv) ---\n"); print(mk_escala[, !c("criterio"), with = FALSE])
cat("\n--- Puntajes (nse_taller_puntajes.csv) ---\n"); print(puntajes[, !c("nota"), with = FALSE])
cat("\n--- Personas, total (nse_taller_personas.csv) ---\n"); print(personas[variable == "total"])
cat("\n--- Parámetros: discriminación y umbrales desordenados ---\n")
print(parametros[, .N, by = .(subescala, discriminacion_Baker_Kim)])
print(parametros[umbrales_desordenados == TRUE, .(subescala, item)])
cat("\nListo:", format(Sys.time()), "\n")
sessionInfo()
