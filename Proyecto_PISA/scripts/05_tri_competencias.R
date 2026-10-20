# =============================================================================
# 05 TRI POR COMPETENCIAS - Colombia, PISA 2022 (F5, O3; reglas en D-27)
#
# Qué hace (por ahora, los pasos 5.2 y 5.3; los pasos 5.4 a 5.7 se agregan uno a uno):
#   5.2 Matriz de respuestas: 6.886 estudiantes de la muestra analítica (D-27 punto 2) x 232 ítems calibrables.
#     - Puntaje (D-27 punto 1): el crédito es el primer dígito en los ítems con códigos de dos dígitos, y en ellos
#       1 y 2 valen 0 (Technical Report, p. 313). Quedan 170 ítems dicotómicos y 62 de crédito parcial (0/1/2).
#     - Tres versiones según cómo se trata la omisión (D-27 punto 5; D-05):
#       (a) la omitida vale 0, como la OCDE; el no alcanzado y el no administrado son faltantes;
#       (b) la omisión rápida (NT10: menos del 10 % del tiempo medio del ítem entre quienes lo vieron, sin tope)
#           es faltante y las demás omisiones valen 0;
#       (c) toda omisión es faltante (sensibilidad).
#     - Las celdas vacías por la ruta adaptativa quedan NA: la falta de datos es ignorable si se calibran todos los
#       ítems juntos (plan, paso 5.2).
#   5.3 Calibración (D-27 punto 3): con la versión (a), un modelo de 1 dimensión y uno de 4 competencias
#       correlacionadas (cada ítem carga solo en la suya); 2PL y GPCM; pesos normalizados; QMCEM con 1.000 puntos de
#       integración en los dos (D-27, decidido el 2026-10-20). H8 se acepta si el de 4 dimensiones tiene menor BIC y
#       ninguna correlación entre competencias es > 0,95 (09 Hipótesis preregistradas; con pesos, el BIC es
#       descriptivo, D-19 punto 4).
#     - Cada modelo se guarda en un caché con huella (datos, pesos, tipos, estructura y configuración): si algo
#       cambia, se reestima. Para reestimar a la fuerza: $env:REHACER_MAT = "1".
#     - El de 4 dimensiones tarda horas: para probar solo el de 1 dimensión, $env:SOLO_1D = "1".
#
# Entradas: datos/COL_cognitivo.rds (01a), datos/COL_nse.rds (03_nse_medicion) y salidas/items_competencia.csv
#   (05_explorar_items.R).
# Salidas: datos/COL_mat_respuestas.rds, COL_mat_tri_1D.rds y COL_mat_tri_4D.rds (no van a Git: datos por
#   estudiante, Ley 1581) y, solo agregados, salidas/mat_matriz_resumen.csv y salidas/mat_ajuste.csv.
#
# Cómo correrlo (desde Proyecto_PISA/scripts/, después de 05_explorar_items.R):
#   & "C:\Program Files\R\R-4.4.1\bin\Rscript.exe" 05_tri_competencias.R
# =============================================================================

options(stringsAsFactors = FALSE, scipen = 999, width = 160)
suppressPackageStartupMessages({ library(data.table) })

carpeta_script <- function() {
  arg <- grep("^--file=", commandArgs(FALSE), value = TRUE)
  if (length(arg)) return(dirname(normalizePath(sub("^--file=", "", arg))))
  if (!is.null(sys.frames()[[1]]$ofile)) return(dirname(normalizePath(sys.frames()[[1]]$ofile)))
  getwd()
}
DIR     <- carpeta_script()
DATOS   <- normalizePath(file.path(DIR, "..", "datos"))
SALIDAS <- normalizePath(file.path(DIR, "..", "salidas"))
for (f in c("COL_cognitivo.rds", "COL_nse.rds")) if (!file.exists(file.path(DATOS, f))) stop("Falta datos/", f)
if (!file.exists(file.path(SALIDAS, "items_competencia.csv"))) stop("Falta salidas/items_competencia.csv: correr antes 05_explorar_items.R")

# =============================================================================
# 5.2 MATRIZ DE RESPUESTAS
# =============================================================================
cog <- readRDS(file.path(DATOS, "COL_cognitivo.rds"))
nse <- readRDS(file.path(DATOS, "COL_nse.rds"))
ic  <- fread(file.path(SALIDAS, "items_competencia.csv"), encoding = "UTF-8")
ITEMS <- ic[calibrable == TRUE, item]
COMP  <- setNames(ic[calibrable == TRUE, competencia], ITEMS)
stopifnot(length(ITEMS) == 232, all(ITEMS %in% names(cog)))

d <- cog[CNTSTUID %in% nse$CNTSTUID]                                   # muestra analítica (D-14, D-27 punto 2)
setkey(d, CNTSTUID); stopifnot(nrow(d) == 6886)

# Primer dígito = crédito (TR p. 313); en los ítems con códigos de dos dígitos, 1 y 2 son «01» y «02» (sin crédito)
puntaje <- function(x) if (any(x >= 10, na.rm = TRUE)) x %/% 10 else x
tiempo  <- function(j) d[[paste0(sub("^D", "C", sub("[SC]$", "", j)), "TT")]] / 1000   # s; los ítems D usan el prefijo C

A <- B <- C <- matrix(NA_real_, nrow(d), length(ITEMS), dimnames = list(NULL, ITEMS))
umbral <- setNames(numeric(length(ITEMS)), ITEMS)
for (j in ITEMS) {
  e <- d[[paste0("E_", j)]]; s <- puntaje(d[[j]]); tt <- tiempo(j)
  visto <- e %in% c("respondido", "omitido") & !is.na(tt)
  umbral[j] <- 0.10 * mean(tt[visto])                                   # NT10 con la media, sin tope (D-27 punto 5)
  resp <- e == "respondido"; om <- e == "omitido"
  rapida <- om & !is.na(tt) & tt < umbral[j]
  A[resp, j] <- s[resp]; A[om, j] <- 0                                  # (a) omitida = 0
  B[, j] <- A[, j]; B[rapida, j] <- NA                                  # (b) omisión rápida = faltante
  C[, j] <- A[, j]; C[om, j] <- NA                                      # (c) toda omisión = faltante
}

# --- Controles (D-27): categorías, número de ítems de cada tipo y cobertura del diseño adaptativo
cats <- apply(A, 2, function(x) paste(sort(unique(na.omit(x))), collapse = "/"))
stopifnot(all(cats %in% c("0/1", "0/1/2")), sum(cats == "0/1") == 170, sum(cats == "0/1/2") == 62)
tipos <- ifelse(cats == "0/1", "2PL", "gpcm")

resumen <- rbindlist(lapply(c(sort(unique(COMP)), "total"), function(k) {
  jj <- if (k == "total") ITEMS else ITEMS[COMP == k]
  data.table(competencia = k, items = length(jj), dicotomicos = sum(tipos[jj] == "2PL"), credito_parcial = sum(tipos[jj] == "gpcm"),
             celdas_con_dato_a = sum(!is.na(A[, jj])), pct_celdas_con_dato_a = round(100 * mean(!is.na(A[, jj])), 2),
             omisiones = sum(!is.na(A[, jj]) & is.na(C[, jj])), omisiones_rapidas = sum(!is.na(A[, jj]) & is.na(B[, jj])),
             estudiantes_con_dato = sum(rowSums(!is.na(A[, jj, drop = FALSE])) > 0),
             items_por_estudiante_mediana = as.numeric(median(rowSums(!is.na(A[, jj, drop = FALSE]))))) }))
fwrite(resumen, file.path(SALIDAS, "mat_matriz_resumen.csv"))

saveRDS(list(CNTSTUID = d$CNTSTUID, a = A, b = B, c = C, competencia = COMP, tipo = tipos, umbral_NT10_s = umbral),
        file.path(DATOS, "COL_mat_respuestas.rds"))

cat("--- 5.2 Matriz de respuestas (salidas/mat_matriz_resumen.csv) ---\n"); print(resumen)

# =============================================================================
# 5.3 CALIBRACIÓN: 1 DIMENSIÓN FRENTE A 4 COMPETENCIAS (H8)
# =============================================================================
suppressPackageStartupMessages(library(mirt))
X <- as.data.frame(A)
peso <- nse$W_FSTUWT[match(d$CNTSTUID, nse$CNTSTUID)]; stopifnot(!anyNA(peso))
w <- peso * length(peso) / sum(peso)                                      # pesos normalizados (D-16 punto 5)
FACT <- c(emplear = "EMP", formular = "FOR", interpretar = "INT", razonar = "RAZ")
sintaxis <- vapply(names(FACT), function(k) paste0(FACT[[k]], " = ", paste(ITEMS[COMP == k], collapse = ", ")), "")
modelo_4d <- mirt.model(paste0(paste(sintaxis, collapse = "\n"), "\nCOV = ", paste(FACT, collapse = "*")), itemnames = ITEMS)
CONFIG <- list(method = "QMCEM", quadpts = 1000, NCYCLES = 2000)
ajustar <- function(modelo) mirt(X, modelo, itemtype = unname(tipos), survey.weights = w, method = CONFIG$method,
                                 quadpts = CONFIG$quadpts, SE = FALSE, verbose = FALSE,
                                 technical = list(NCYCLES = CONFIG$NCYCLES))
huella <- function(...) { f <- tempfile(); on.exit(unlink(f))
  writeBin(serialize(list(...), NULL, version = 3), f); unname(tools::md5sum(f)) }
calibrar <- function(nombre, modelo) {
  cache <- file.path(DATOS, paste0("COL_mat_tri_", nombre, ".rds"))
  h <- huella(as.list(X), w, unname(tipos), COMP, CONFIG, nombre)
  if (file.exists(cache) && Sys.getenv("REHACER_MAT") != "1") {
    m <- readRDS(cache)
    if (identical(attr(m, "huella_datos"), h)) { cat("5.3", nombre, "leído del caché", basename(cache), "\n"); return(m) }
    cat("5.3 El caché", basename(cache), "no corresponde a los datos actuales: se reestima\n")
  }
  cat(format(Sys.time(), "%H:%M:%S"), "| 5.3 estimando el modelo", nombre, "\n"); flush.console()
  t0 <- Sys.time(); m <- ajustar(modelo)
  attr(m, "minutos") <- round(as.numeric(Sys.time() - t0, units = "mins"), 1); attr(m, "huella_datos") <- h
  saveRDS(m, cache); cat(format(Sys.time(), "%H:%M:%S"), "| 5.3", nombre, "listo en", attr(m, "minutos"), "min\n"); m
}
modelos <- list("1D" = calibrar("1D", 1))
if (Sys.getenv("SOLO_1D") != "1") modelos[["4D"]] <- calibrar("4D", modelo_4d)

correlaciones <- function(m) {
  s <- coef(m, simplify = TRUE)$cov
  if (is.null(s) || ncol(s) < 2) return(NULL)
  r <- cov2cor(s); dimnames(r) <- list(names(FACT), names(FACT)); r
}
ajuste <- rbindlist(lapply(names(modelos), function(k) { m <- modelos[[k]]; r <- correlaciones(m)
  data.table(modelo = k, convergio = extract.mirt(m, "converged"), iteraciones = extract.mirt(m, "iterations"),
             minutos = attr(m, "minutos"), logLik = round(extract.mirt(m, "logLik"), 1),
             parametros = extract.mirt(m, "nest"), AIC = round(extract.mirt(m, "AIC"), 1),
             BIC = round(extract.mirt(m, "BIC"), 1),
             correlacion_min = if (is.null(r)) NA_real_ else round(min(r[upper.tri(r)]), 3),
             correlacion_max = if (is.null(r)) NA_real_ else round(max(r[upper.tri(r)]), 3)) }))
fwrite(ajuste, file.path(SALIDAS, "mat_ajuste.csv"))

cat("\n--- 5.3 Ajuste (salidas/mat_ajuste.csv) ---\n"); print(ajuste)
if (all(c("1D", "4D") %in% ajuste$modelo)) {
  r4 <- correlaciones(modelos[["4D"]]); cat("\nCorrelaciones entre competencias (4D):\n"); print(round(r4, 3))
  h8 <- ajuste[modelo == "4D", BIC] < ajuste[modelo == "1D", BIC] && max(r4[upper.tri(r4)]) <= 0.95
  cat("\nH8 (menor BIC en 4D y ninguna correlación > 0,95):", if (h8) "se acepta" else "se rechaza", "\n")
}

# =============================================================================
# 5.3b BIFACTOR EXPLORATORIO (D-29): no decide hipótesis; criterios de viabilidad fijados antes de estimar
# =============================================================================
# Cada ítem carga en el factor general y en el específico de su competencia (factores ortogonales). Mismos datos,
# tipos y pesos que el 5.3; integración por defecto de bfactor(). Para no correrlo: $env:SIN_BIFACTOR = "1".
# Cargas estandarizadas como en la F3 (cargas_mirt de 03_nse_tri.R): summary() de mirt 1.46.1 anula cargas de GPCM (D-19).
cargas_mirt <- function(m) {
  pars <- m@ParObjects$pars; J <- length(pars) - 1L
  nf   <- length(mirt:::ExtractLambdas(pars[[1L]], include_fixed = FALSE))
  gcov <- mirt:::ExtractGroupPars(pars[[J + 1L]])$gcov
  stopifnot(ncol(gcov) == nf)
  L <- do.call(rbind, lapply(seq_len(J), function(i) {
    p <- pars[[i]]; l <- mirt:::ExtractLambdas(p, include_fixed = FALSE) / 1.702
    if (p@ncat > 2 && (is(p, "gpcm") || is(p, "nominal"))) {
      d <- mirt:::nominal_rescale_d(p@par[1:(nf + p@ncat)], nfact = nf, ncat = p@ncat)
      l <- l * d
      s <- sign(l[which(l != 0)[1]]); if (is.na(s)) s <- 1
      l <- l * sqrt((p@ncat - 1) * 1.702) * s
    }
    l }))
  L <- L %*% diag(sqrt(diag(gcov)), nf)
  F <- L / sqrt(1 + rowSums(L^2))
  dimnames(F) <- list(extract.mirt(m, "itemnames"), extract.mirt(m, "factorNames")); F
}
if (Sys.getenv("SOLO_1D") != "1" && Sys.getenv("SIN_BIFACTOR") != "1") {
  ESPECIFICO <- match(COMP, names(FACT))                                  # 1 a 4: emplear, formular, interpretar, razonar
  cache_bf <- file.path(DATOS, "COL_mat_tri_bifactor.rds")
  h_bf <- huella(as.list(X), w, unname(tipos), ESPECIFICO, "bifactor", "D-29", "con EE")
  bf <- NULL
  if (file.exists(cache_bf) && Sys.getenv("REHACER_MAT") != "1") {
    bf <- readRDS(cache_bf)
    if (identical(attr(bf, "huella_datos"), h_bf)) cat("\n5.3b bifactor leído del caché", basename(cache_bf), "\n") else bf <- NULL
  }
  if (is.null(bf)) {
    cat(format(Sys.time(), "%H:%M:%S"), "| 5.3b estimando el bifactor\n"); flush.console(); t0 <- Sys.time()
    # Con errores estándar: V2 y V3 los revisan (confirmación de Vanessa en D-29)
    bf <- tryCatch(bfactor(X, ESPECIFICO, itemtype = unname(tipos), survey.weights = w, SE = TRUE, verbose = FALSE,
                           technical = list(NCYCLES = 2000)),
                   error = function(e) structure(list(error = conditionMessage(e)), class = "error_bifactor"))
    attr(bf, "minutos") <- round(as.numeric(Sys.time() - t0, units = "mins"), 1); attr(bf, "huella_datos") <- h_bf
    saveRDS(bf, cache_bf)
  }
  if (inherits(bf, "error_bifactor")) {
    viab <- data.table(criterio = "estimación", cumple = FALSE, detalle = bf$error)
    fwrite(viab, file.path(SALIDAS, "mat_bifactor_viabilidad.csv"))
    cat("\n5.3b El bifactor no se pudo estimar:", bf$error, "\n")
  } else {
    Fb <- cargas_mirt(bf)
    # El general es el factor en el que cargan todos los ítems; el específico de cada competencia, el que cargan sus ítems
    G <- names(which.max(colSums(Fb != 0)))
    S <- vapply(names(FACT), function(k) { o <- setdiff(colnames(Fb), G)
      o[which.max(colSums(Fb[COMP == k, o, drop = FALSE] != 0))] }, "")
    stopifnot(all(Fb[, G] != 0), length(unique(S)) == 4)
    h2 <- rowSums(Fb^2)
    par_num <- unlist(lapply(bf@ParObjects$pars, function(p) p@par))
    n_fuertes <- vapply(seq_along(S), function(k) sum(abs(Fb[COMP == names(FACT)[k], S[k]]) >= 0.30), 0)
    # Pendiente específica de cada ítem y su error estándar (escala de la TRI); NA si no se pudo calcular
    fn <- extract.mirt(bf, "factorNames"); cf <- coef(bf, printSE = TRUE)
    pend <- rbindlist(lapply(ITEMS, function(j) { m <- cf[[j]]; col <- paste0("a", match(S[[COMP[[j]]]], fn))
      data.table(item = j, competencia = COMP[[j]],
                 pendiente_especifica = m["par", col], ee_pendiente_especifica = if ("SE" %in% rownames(m)) m["SE", col] else NA_real_) }))
    ee_todos <- unlist(lapply(cf[ITEMS], function(m) if ("SE" %in% rownames(m)) m["SE", ] else NA_real_))
    ee_ok <- length(ee_todos) > 0 && all(is.finite(ee_todos))
    viab <- data.table(
      criterio = c("V1 convergencia (<= 2.000 ciclos)", "V2a parámetros finitos", "V2b errores estándar calculados y finitos",
                   "V2c comunalidad < 0,99",
                   paste("V3", names(FACT), ">= 3 ítems con carga específica >= 0,30 (criterio operativo)")),
      cumple = c(extract.mirt(bf, "converged"), all(is.finite(par_num)), ee_ok, max(h2) < 0.99, n_fuertes >= 3),
      detalle = c(paste(extract.mirt(bf, "iterations"), "ciclos;", attr(bf, "minutos"), "min"),
                  paste(sum(!is.finite(par_num)), "no finitos"),
                  paste(sum(!is.finite(ee_todos)), "de", length(ee_todos), "EE no finitos o sin calcular"),
                  paste("comunalidad máxima", round(max(h2), 3)),
                  vapply(seq_along(S), function(k) { p <- pend[competencia == names(FACT)[k]]
                    sprintf("%d de %d ítems; EE de la pendiente específica: mediana %.3f, máximo %.3f", n_fuertes[k], nrow(p),
                            median(p$ee_pendiente_especifica, na.rm = TRUE), suppressWarnings(max(p$ee_pendiente_especifica, na.rm = TRUE))) }, "")))
    # Se reportan, sin umbral (D-29): varianzas de los factores (fijas en 1) y posibles soluciones de frontera
    frontera <- data.table(medida = c("varianzas de los factores", "comunalidad máxima", "carga general máxima (valor absoluto)",
                                      "carga específica máxima (valor absoluto)", "pendiente específica máxima (valor absoluto)"),
                           valor = c("fijas en 1 por identificación", round(max(h2), 3), round(max(abs(Fb[, G])), 3),
                                     round(max(abs(Fb[cbind(seq_len(nrow(Fb)), match(S[COMP], colnames(Fb)))])), 3),
                                     round(max(abs(pend$pendiente_especifica)), 3)))
    fwrite(frontera, file.path(SALIDAS, "mat_bifactor_frontera.csv"))
    fwrite(cbind(pend, carga_general = round(Fb[pend$item, G], 3),
                 carga_especifica = round(Fb[cbind(match(pend$item, rownames(Fb)), match(S[pend$competencia], colnames(Fb)))], 3),
                 comunalidad = round(h2[pend$item], 3))[, `:=`(pendiente_especifica = round(pendiente_especifica, 3),
                                                              ee_pendiente_especifica = round(ee_pendiente_especifica, 3))],
           file.path(SALIDAS, "mat_bifactor_items.csv"))
    fwrite(viab, file.path(SALIDAS, "mat_bifactor_viabilidad.csv"))
    viable <- all(viab$cumple)
    cat("\n--- 5.3b Viabilidad del bifactor (salidas/mat_bifactor_viabilidad.csv) ---\n"); print(viab)
    cat("\n--- 5.3b Posibles soluciones de frontera (salidas/mat_bifactor_frontera.csv; se reportan sin umbral) ---\n"); print(frontera)
    if (viable) {
      # ECV y omega jerárquico de subescala (D-29; fuente por buscar y verificar): se reportan sin cortes
      ecv <- sum(Fb[, G]^2) / sum(Fb^2)
      aporte <- rbindlist(lapply(seq_along(S), function(k) { jj <- COMP == names(FACT)[k]
        g <- sum(Fb[jj, G]); s <- sum(Fb[jj, S[k]]); u <- sum(1 - h2[jj])
        data.table(competencia = names(FACT)[k], items = sum(jj), carga_general_media = round(mean(Fb[jj, G]), 3),
                   carga_especifica_media = round(mean(Fb[jj, S[k]]), 3), items_carga_especifica_030 = n_fuertes[k],
                   omega_jerarquico_subescala = round(s^2 / (g^2 + s^2 + u), 3)) }))
      aporte <- rbind(aporte, data.table(competencia = "ECV (factor general)", omega_jerarquico_subescala = round(ecv, 3)), fill = TRUE)
      fwrite(aporte, file.path(SALIDAS, "mat_bifactor_aporte.csv"))
      cat("\n--- 5.3b Aporte de cada competencia (salidas/mat_bifactor_aporte.csv) ---\n"); print(aporte)
    } else cat("\n5.3b El bifactor no es viable según D-29: no se interpretan sus factores específicos.\n")
  }
}

cat("\nListo: datos/COL_mat_respuestas.rds y COL_mat_tri_*.rds (no van a Git); salidas/mat_matriz_resumen.csv, mat_ajuste.csv y mat_bifactor_*.csv\n")
