# =============================================================================
# REVISION PISA 2022 - Colombia, items de matematicas (archivo cognitivo)
#
# Que hace:
#   1. Ubica a Colombia dentro de CY08MSP_STU_COG.SAV (613.744 estudiantes,
#      5.023 columnas) leyendo SOLO la columna CNT.
#   2. Lee unicamente ese bloque de filas y las columnas de matematicas:
#      respuesta calificada (S o C), tiempo total (TT, en ms), tiempo a la
#      primera accion (F), numero de acciones (A) y la ruta adaptativa.
#   3. Guarda el cache COL_matematicas_cog.rds (en esta misma carpeta).
#      Las siguientes corridas leen el cache y no vuelven a abrir el .SAV.
#   4. Imprime el perfil: rutas, respuestas por item y respuestas rapidas.
#   5. Hace lo mismo con el cuestionario de estudiantes (CY08MSP_STU_QQQ.SAV:
#      ESCS, posesiones del hogar, valores plausibles, pesos, sexo) y guarda
#      COL_estudiantes_qqq.rds; une zona y sector desde CY08MSP_SCH_QQQ.SAV.
#
# Como correrlo (desde la carpeta datos/, o abriendo el script en RStudio):
#   & "C:\Program Files\R\R-4.4.1\bin\Rscript.exe" revision_pisa2022_col.R
# =============================================================================

options(stringsAsFactors = FALSE, scipen = 999)
suppressPackageStartupMessages({ library(data.table); library(haven) })

# Carpeta del script: funciona con Rscript, con source() y con RStudio.
carpeta_script <- function() {
  arg <- grep("^--file=", commandArgs(FALSE), value = TRUE)
  if (length(arg)) return(dirname(normalizePath(sub("^--file=", "", arg))))
  if (!is.null(sys.frames()[[1]]$ofile)) return(dirname(normalizePath(sys.frames()[[1]]$ofile)))
  getwd()
}
DIR     <- carpeta_script()
ARCHIVO <- file.path(DIR, "CY08MSP_STU_COG.SAV")
CACHE   <- file.path(DIR, "COL_matematicas_cog.rds")
PAIS    <- "COL"
# Rehacer un cache aunque exista: cambiar a TRUE, o definir la variable de entorno
# (REHACER_COG=1 / REHACER_QQQ=1) antes de correr el script.
REHACER     <- FALSE || Sys.getenv("REHACER_COG") == "1"   # items cognitivos (lee el .SAV de 3,7 GB)
REHACER_QQQ <- FALSE || Sys.getenv("REHACER_QQQ") == "1"   # cuestionario de estudiantes

# =============================================================================
# 1. CONSTRUIR O LEER EL CACHE
# =============================================================================
if (file.exists(CACHE) && !REHACER) {
  d <- readRDS(CACHE)
  cat("Cache leido:", CACHE, "-", nrow(d), "filas x", ncol(d), "columnas\n")
} else {
  if (!file.exists(ARCHIVO)) stop("No encuentro ", ARCHIVO)
  nombres <- names(read_sav(ARCHIVO, n_max = 0))

  # Items de matematicas. Codificacion OCDE (PISA 2022 Technical Report):
  #   CM...S  = item calificado automaticamente (CMA = items nuevos de 2022)
  #   DM...C  = item corregido por codificador humano
  #   CM...TT = tiempo total; F = primera accion; A = numero de acciones.
  #   Los items humanos (DM) guardan sus tiempos con prefijo CM.
  calif <- c(grep("^CMA?[0-9A-Z]+Q[0-9]+S$", nombres, value = TRUE),
             grep("^DMA?[0-9A-Z]+Q[0-9]+C$", nombres, value = TRUE))
  base_t <- sub("^D", "C", sub("(S|C)$", "", calif))
  proceso <- intersect(c(paste0(base_t, "TT"), paste0(base_t, "F"), paste0(base_t, "A")), nombres)
  ruta <- intersect(c("CNT", "CNTSCHID", "CNTSTUID", "BOOKID", "MPATH",
                      "MCORE_ItemSet", "MS1_LEV", "MS2_LEV"), nombres)

  # Ubicar el pais leyendo solo CNT (unos 2 minutos: recorre las 613.744 filas).
  cat("Ubicando", PAIS, "en el archivo (lectura de la columna CNT)...\n")
  cnt  <- read_sav(ARCHIVO, col_select = "CNT")[["CNT"]]
  filas <- which(cnt == PAIS)
  if (!length(filas)) stop("No hay filas para ", PAIS)
  if (max(filas) - min(filas) + 1 != length(filas)) stop("Las filas de ", PAIS, " no son contiguas")
  rm(cnt); invisible(gc())
  cat(PAIS, ": filas", min(filas), "a", max(filas), "(", length(filas), "estudiantes )\n")

  d <- read_sav(ARCHIVO, col_select = all_of(c(ruta, calif, proceso)),
                skip = min(filas) - 1, n_max = length(filas))
  stopifnot(all(d$CNT == PAIS))
  # Las variables de ruta se pasan a factor (conservan sus etiquetas);
  # los items quedan numericos (los codigos de "no respuesta" ya vienen como NA).
  for (v in intersect(c("MPATH", "MS1_LEV", "MS2_LEV"), names(d))) d[[v]] <- as_factor(d[[v]])
  d <- as.data.table(zap_labels(d))
  saveRDS(d, CACHE, compress = TRUE)
  cat("Cache guardado:", CACHE, "-", round(file.size(CACHE) / 1024^2, 1), "MB\n")
}

# =============================================================================
# 2. PERFIL
# =============================================================================
calif  <- grep("^(CMA?[0-9A-Z]+Q[0-9]+S|DMA?[0-9A-Z]+Q[0-9]+C)$", names(d), value = TRUE)
tiempo <- paste0(sub("^D", "C", sub("(S|C)$", "", calif)), "TT")
con_t  <- tiempo %in% names(d)

cat("\n--- Items de matematicas ---\n")
cat("Calificados:", length(calif), "(automaticos:", sum(grepl("S$", calif)),
    "| humanos:", sum(grepl("C$", calif)), ") | con tiempo:", sum(con_t), "\n")

cat("\n--- Rutas ---\n")
print(d[, .N, by = MPATH][order(-N)])
cat("Nivel en la etapa 2:\n"); print(d[, .N, by = MS1_LEV][order(MS1_LEV)])
cat("Nivel en la etapa 3:\n"); print(d[, .N, by = MS2_LEV][order(MS2_LEV)])

S <- as.matrix(d[, ..calif])
n_item <- colSums(!is.na(S))
cat("\n--- Respuestas por item en Colombia ---\n")
print(summary(n_item))
cat("Items con menos de 200:", sum(n_item < 200), "| menos de 500:", sum(n_item < 500),
    "| 1000 o mas:", sum(n_item >= 1000), "\n")
k <- rowSums(!is.na(S))
cat("Items respondidos por estudiante (quienes tuvieron matematicas):\n"); print(summary(k[k > 0]))
cat("Proporcion de credito (>0) por item:\n"); print(summary(colMeans(S > 0, na.rm = TRUE)))

# --- Desenganche: respuestas rapidas y omisiones (umbral NT10) ---------------
# Rapida = tiempo menor al 10 % de la mediana del item, con tope de 10 s
# (criterio usual en la literatura de rapid guessing; ver Rios y Soland).
# Se separan dos conductas sobre los items que el estudiante VIO (tiene tiempo):
#   - respuesta rapida: contesto, pero demasiado rapido (adivinar)
#   - omision: vio el item y no dejo respuesta calificada (NA)
Tm  <- as.matrix(d[, tiempo[con_t], with = FALSE])
Sm  <- S[, con_t]
vio <- !is.na(Tm)
contesto <- vio & !is.na(Sm)
omitio   <- vio &  is.na(Sm)
umb <- pmin(0.10 * apply(Tm, 2, median, na.rm = TRUE), 10000)
rap <- sweep(Tm, 2, umb, "<") & vio        # FALSE donde no vio el item

n_vio <- rowSums(vio)
ok    <- n_vio >= 10                        # estudiantes con al menos 10 items vistos
p_rap_contestadas <- rowSums(rap & contesto) / pmax(rowSums(contesto), 1)
p_omite           <- rowSums(omitio) / pmax(n_vio, 1)
p_desenganche     <- rowSums(rap | omitio) / pmax(n_vio, 1)
pct <- function(x) round(100 * mean(x), 1)

cat("\n--- Desenganche (NT10) sobre items vistos ---\n")
cat("Items vistos:", sum(vio), "| contestados:", pct(contesto[vio]), "% | omitidos:",
    pct(omitio[vio]), "%\n")
cat("Rapidos entre contestados:", pct(rap[contesto]), "% | rapidos entre omitidos:",
    pct(rap[omitio]), "%\n")
cat(sprintf("Acierto en respuestas rapidas: %.1f %% | en las demas contestadas: %.1f %%\n",
            100 * mean((Sm > 0)[rap & contesto]), 100 * mean((Sm > 0)[!rap & contesto])))
cat("\nPorcentaje de estudiantes (con 10+ items vistos) que superan cada umbral:\n")
print(data.table(
  conducta   = c("Responde rapido (sobre contestadas)", "Omite (sobre vistas)",
                 "Desenganche total: rapido u omite"),
  mas_10_pct = c(pct(p_rap_contestadas[ok] > 0.10), pct(p_omite[ok] > 0.10), pct(p_desenganche[ok] > 0.10)),
  mas_25_pct = c(pct(p_rap_contestadas[ok] > 0.25), pct(p_omite[ok] > 0.25), pct(p_desenganche[ok] > 0.25))))
cat("\nDesenganche total mayor al 25 %, por nivel de la etapa 3:\n")
print(data.table(etapa3 = d$MS2_LEV[ok], alto = p_desenganche[ok] > 0.25)[
  , .(n = .N, pct = round(100 * mean(alto), 1)), by = etapa3][order(etapa3)])

des <- data.table(CNTSTUID = d$CNTSTUID, n_vistos = n_vio, p_omite = p_omite,
                  p_rapido = p_rap_contestadas, p_desenganche = p_desenganche)

# =============================================================================
# 3. CUESTIONARIO DE ESTUDIANTES (STU_QQQ) Y DE COLEGIOS (SCH_QQQ)
# =============================================================================
# STU_QQQ trae ESCS, posesiones del hogar, puntajes por proceso (valores
# plausibles), pesos muestrales y sexo. Se une con los items por CNTSTUID y
# con el colegio por CNTSCHID. Segundo cache: COL_estudiantes_qqq.rds.
ARCHIVO_QQQ <- file.path(DIR, "CY08MSP_STU_QQQ.SAV")
ARCHIVO_SCH <- file.path(DIR, "CY08MSP_SCH_QQQ.SAV")
CACHE_QQQ   <- file.path(DIR, "COL_estudiantes_qqq.rds")

if (!file.exists(CACHE_QQQ) && !file.exists(ARCHIVO_QQQ)) {
  cat("\nFalta CY08MSP_STU_QQQ.SAV: se omite la parte de cuestionario.\n")
  quit(save = "no")
}
if (file.exists(CACHE_QQQ) && !REHACER_QQQ) {
  q <- readRDS(CACHE_QQQ)
  cat("\nCache leido:", CACHE_QQQ, "-", nrow(q), "filas x", ncol(q), "columnas\n")
} else {
  nq <- names(read_sav(ARCHIVO_QQQ, n_max = 0))
  cols_q <- c(intersect(c("CNT", "CNTSCHID", "CNTSTUID", "ST004D01T", "GRADE", "IMMIG",
                          "ESCS", "HISEI", "PAREDINT", "HOMEPOS", "W_FSTUWT"), nq),
              grep("^W_FSTURWT[0-9]+$", nq, value = TRUE),                 # 80 pesos replicados
              grep("^PV[0-9]+(MATH|MPEM|MPFS|MPIN|MPRE|MCCR|MCQN|MCSS|MCUD)$", nq, value = TRUE),
              grep("^ST25[0-6]Q[0-9]+", nq, value = TRUE))               # posesiones HOMEPOS 2022: ST250, 251, 253-256
  cat("\nUbicando", PAIS, "en STU_QQQ (lectura de la columna CNT)...\n")
  cnt <- read_sav(ARCHIVO_QQQ, col_select = "CNT")[["CNT"]]
  fq  <- which(cnt == PAIS); rm(cnt); invisible(gc())
  if (max(fq) - min(fq) + 1 != length(fq)) stop("Las filas de ", PAIS, " no son contiguas en STU_QQQ")
  q <- read_sav(ARCHIVO_QQQ, col_select = all_of(cols_q), skip = min(fq) - 1, n_max = length(fq))
  stopifnot(all(q$CNT == PAIS))
  q$ST004D01T <- as_factor(q$ST004D01T)
  q <- as.data.table(zap_labels(q))
  saveRDS(q, CACHE_QQQ, compress = TRUE)
  cat("Cache guardado:", CACHE_QQQ, "-", round(file.size(CACHE_QQQ) / 1024^2, 1), "MB\n")
}

s <- as.data.table(read_sav(ARCHIVO_SCH, col_select = any_of(c("CNT", "CNTSCHID", "SC001Q01TA", "SCHLTYPE"))))[CNT == PAIS]
s[, zona := fcase(SC001Q01TA == 1, "Rural (<3.000)", SC001Q01TA == 2, "Pueblo (3-15 mil)",
                  SC001Q01TA >= 3, "Urbana (>15 mil)", default = NA_character_)]
s[, sector := fcase(SCHLTYPE == 3, "Publico", SCHLTYPE %in% 1:2, "Privado", default = NA_character_)]
q <- merge(q, s[, .(CNTSCHID, zona, sector)], by = "CNTSCHID", all.x = TRUE)
q <- merge(q, des, by = "CNTSTUID", all.x = TRUE)

# --- Utilidades para PISA: pesos finales + 80 replicados BRR (Fay 0,5) + 10 PV
# Varianza muestral BRR = 1 / (80 * (1 - 0,5)^2) * suma (theta_r - theta)^2
# Varianza total = promedio de la muestral de cada PV + (1 + 1/10) * varianza entre PV
REPS <- grep("^W_FSTURWT[0-9]+$", names(q), value = TRUE)
pendiente <- function(y, x, w) { k <- !is.na(y) & !is.na(x) & !is.na(w)
  lm.wfit(cbind(1, x[k]), y[k], w[k])$coefficients[2] }
estimar_pv <- function(pvs, fun) {
  est <- sapply(pvs, function(p) fun(q[[p]], q$W_FSTUWT))
  var_m <- sapply(pvs, function(p) {
    r <- sapply(REPS, function(w) fun(q[[p]], q[[w]]))
    sum((r - fun(q[[p]], q$W_FSTUWT))^2) / (length(REPS) * 0.25) })
  c(est = mean(est), ee = sqrt(mean(var_m) + (1 + 1 / length(pvs)) * var(est)))
}

cat("\n--- Muestra Colombia (cuestionario) ---\n")
cat("Estudiantes:", nrow(q), "| con ESCS:", sum(!is.na(q$ESCS)),
    "| con items de matematicas vistos (10+):", sum(q$n_vistos >= 10, na.rm = TRUE), "\n")
print(q[, .N, by = .(zona)][order(zona)]); print(q[, .N, by = .(sector)])
print(q[, .N, by = .(sexo = ST004D01T)])

# --- Idea 3: los 4 procesos ---------------------------------------------------
proc <- c(MPEM = "Emplear", MPFS = "Formular", MPIN = "Interpretar", MPRE = "Razonar")
if (all(paste0("PV1", names(proc)) %in% names(q))) {
  cat("\n--- Idea 3: correlaciones entre procesos en Colombia (ponderadas, promedio de 10 PV) ---\n")
  cm <- Reduce(`+`, lapply(1:10, function(i) {
    m <- q[, paste0("PV", i, names(proc)), with = FALSE]
    cov.wt(m, wt = q$W_FSTUWT, cor = TRUE)$cor })) / 10
  dimnames(cm) <- list(proc, proc); print(round(cm, 2))
  cat("(Promedio internacional segun el Technical Report: 0,79 a 0,87)\n")
  cat("\nPuntos por 1 unidad de ESCS en cada proceso (con error estandar BRR + PV):\n")
  print(rbindlist(lapply(names(proc), function(p) {
    e <- estimar_pv(paste0("PV", 1:10, p), function(y, w) pendiente(y, q$ESCS, w))
    data.table(proceso = proc[[p]], pendiente_ESCS = round(e[["est"]], 1), ee = round(e[["ee"]], 1)) })))

  # La diferencia entre dos pendientes se estima dentro de cada PV y de cada
  # replica (los procesos vienen de los mismos estudiantes: no son independientes).
  cat("\nDiferencia de pendiente ESCS entre procesos (z > 1,96 ~ significativa al 5 %; hay 6 comparaciones):\n")
  dif_pend <- function(a, b) {
    f <- function(i, w) pendiente(q[[paste0("PV", i, a)]], q$ESCS, w) - pendiente(q[[paste0("PV", i, b)]], q$ESCS, w)
    est   <- sapply(1:10, function(i) f(i, q$W_FSTUWT))
    var_m <- sapply(1:10, function(i) sum((sapply(REPS, function(w) f(i, q[[w]])) - est[i])^2) / (length(REPS) * 0.25))
    e <- mean(est); ee <- sqrt(mean(var_m) + 1.1 * var(est))
    data.table(comparacion = paste(proc[[a]], "-", proc[[b]]), diferencia = round(e, 1), ee = round(ee, 1), z = round(e / ee, 2))
  }
  print(rbindlist(list(dif_pend("MPIN", "MPEM"), dif_pend("MPFS", "MPEM"), dif_pend("MPRE", "MPEM"),
                       dif_pend("MPIN", "MPRE"), dif_pend("MPFS", "MPRE"), dif_pend("MPIN", "MPFS"))))
}

# --- Idea 1: desenganche y NSE ---------------------------------------------------
k <- q$n_vistos >= 10 & !is.na(q$ESCS)
q[k, cuartil_escs := cut(ESCS, breaks = Hmisc_wq <- {
  o <- order(ESCS); cw <- cumsum(W_FSTUWT[o]) / sum(W_FSTUWT)
  c(-Inf, sapply(c(.25, .5, .75), function(p) ESCS[o][which(cw >= p)[1]]), Inf) },
  labels = c("Q1 (bajo)", "Q2", "Q3", "Q4 (alto)"))]
cat("\n--- Idea 1: desenganche por cuartil de ESCS (ponderado) ---\n")
print(q[k, .(n = .N,
             pct_omite_mas25   = round(100 * weighted.mean(p_omite > 0.25, W_FSTUWT), 1),
             pct_desengan_mas25 = round(100 * weighted.mean(p_desenganche > 0.25, W_FSTUWT), 1),
             omision_media_pct = round(100 * weighted.mean(p_omite, W_FSTUWT), 1)),
        by = cuartil_escs][order(cuartil_escs)])

# --- Idea 2: respuestas por item segun NSE --------------------------------------
Sq <- as.matrix(d[match(q$CNTSTUID, d$CNTSTUID), ..calif])
bajo <- q$cuartil_escs %in% "Q1 (bajo)"; alto <- q$cuartil_escs %in% "Q4 (alto)"
n_bajo <- colSums(!is.na(Sq[bajo, , drop = FALSE])); n_alto <- colSums(!is.na(Sq[alto, , drop = FALSE]))
cat("\n--- Idea 2: respuestas por item en el cuartil bajo vs alto de ESCS ---\n")
cat("Cuartil bajo, mediana por item:", median(n_bajo), "| cuartil alto:", median(n_alto), "\n")
cat("Items con al menos 100 respuestas en AMBOS cuartiles:", sum(n_bajo >= 100 & n_alto >= 100),
    "de", length(calif), "\n")

# --- Idea 4: posesiones del hogar ------------------------------------------------
pos <- grep("^ST25[0-6]Q", names(q), value = TRUE)
cat("\n--- Idea 4: items de posesiones del hogar disponibles para Colombia ---\n")
disp <- pos[sapply(pos, function(v) mean(!is.na(q[[v]])) > 0.5)]
cat(length(disp), "items con datos:", paste(disp, collapse = ", "), "\n")
# Los 3 bienes nacionales de Colombia (televisor, nevera, consola; Technical
# Report, anexo D, por verificar) NO estan en la base publica: las adaptaciones
# nacionales no se incluyen en el archivo de uso publico (PUF).
cat("Bienes nacionales de Colombia en la base publica:",
    if (length(intersect(c("ST250Q06JA", "ST250Q07JA", "ST251Q08JA", "ST251Q09JA"), names(q))))
      "si" else "NO (excluidos del PUF; solo se usan los items internacionales)", "\n")
cat("HOMEPOS medio (ponderado) por zona y por sexo:\n")
print(q[!is.na(HOMEPOS), .(n = .N, HOMEPOS = round(weighted.mean(HOMEPOS, W_FSTUWT), 2)), by = zona][order(zona)])
print(q[!is.na(HOMEPOS), .(n = .N, HOMEPOS = round(weighted.mean(HOMEPOS, W_FSTUWT), 2)), by = .(sexo = ST004D01T)])

cat("\nListo.\n")
