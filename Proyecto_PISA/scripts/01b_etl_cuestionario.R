# =============================================================================
# 01b ETL CUESTIONARIO - PISA 2022 Colombia (F1, pasos 1.3 y 1.4)
#
# Qué hace:
#   1. Lee solo el bloque de Colombia de CY08MSP_STU_QQQ.SAV (primero la columna CNT, luego
#      col_select + skip + n_max): sexo, NSE (índices, educación, posesiones), pesos y valores
#      plausibles. Del cuestionario de colegios lee la zona y el tipo de colegio.
#   2. Recodifica según la decisión D-12 (Vault_PISA2022/03 Registro de decisiones.md).
#   3. Guarda datos/COL_cuestionario.rds (no va a Git: datos de menores, Ley 1581 de 2012).
#   4. Escribe salidas/diccionario_cuestionario.csv (solo agregados) y la nota
#      Vault_PISA2022/Datos/PISA2022 - Variables recodificadas.md.
#
# Cómo correrlo (desde Proyecto_PISA/scripts/):
#   & "C:\Program Files\R\R-4.4.1\bin\Rscript.exe" 01b_etl_cuestionario.R
# La primera vez lee el .SAV de 2 GB (varios minutos) y guarda un caché crudo. Para releerlo
# aunque exista el caché: $env:REHACER_CUEST = "1" antes de correr el script.
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
DIR     <- carpeta_script()                                        # Proyecto_PISA/scripts
DATOS   <- normalizePath(file.path(DIR, "..", "datos"))
SALIDAS <- normalizePath(file.path(DIR, "..", "salidas"))
VAULT   <- normalizePath(file.path(DIR, "..", "..", "Vault_PISA2022", "Datos"))
STU     <- file.path(DATOS, "CY08MSP_STU_QQQ.SAV")
SCH     <- file.path(DATOS, "CY08MSP_SCH_QQQ.SAV")
CRUDO   <- file.path(DATOS, "COL_cuestionario_crudo.rds")         # bloque de Colombia sin recodificar
FINAL   <- file.path(DATOS, "COL_cuestionario.rds")               # recodificado (D-12)
PAIS    <- "COL"
N_COL   <- 7804   # tamaño de la muestra principal (Technical Report, Annex Table 11.A.2, p. 244)
REHACER <- Sys.getenv("REHACER_CUEST") == "1"

# Filas de Colombia: se lee solo la columna CNT y se exige que el bloque sea contiguo.
bloque_col <- function(f) {
  cnt <- read_sav(f, col_select = "CNT")[["CNT"]]
  w <- which(cnt == PAIS)
  if (max(w) - min(w) + 1 != length(w)) stop("Las filas de ", PAIS, " no son contiguas en ", basename(f))
  list(skip = min(w) - 1, n = length(w))
}

# =============================================================================
# 1. LEER (o usar el caché crudo)
# =============================================================================
nombres <- names(read_sav(STU, n_max = 0))
POS <- grep("^ST25[0-6]Q[0-9]+JA$", nombres, value = TRUE)          # 27 ítems de HOMEPOS 2022
if (file.exists(CRUDO) && !REHACER) {
  q <- readRDS(CRUDO)
  cat("Caché crudo leído:", nrow(q), "filas x", ncol(q), "columnas\n")
} else {
  cols <- c(intersect(c("CNT", "CNTSCHID", "CNTSTUID", "ST004D01T", "GRADE", "IMMIG", "ESCS", "HISEI",
                        "PAREDINT", "HISCED", "HOMEPOS", "ST005Q01JA", "ST007Q01JA", "W_FSTUWT"), nombres),
            grep("^W_FSTURWT[0-9]+$", nombres, value = TRUE),                          # 80 pesos replicados
            grep("^PV[0-9]+(MATH|MPEM|MPFS|MPIN|MPRE|MCCR|MCQN|MCSS|MCUD)$", nombres, value = TRUE),
            POS)
  cat("Ubicando", PAIS, "en", basename(STU), "(lectura de la columna CNT)...\n")
  b <- bloque_col(STU)
  # user_na = FALSE (por defecto): Valid Skip, Not Applicable, Invalid y No Response llegan como NA (D-12).
  q <- read_sav(STU, col_select = all_of(cols), skip = b$skip, n_max = b$n)
  stopifnot(all(q$CNT == PAIS))
  q <- as.data.table(zap_labels(q))
  saveRDS(q, CRUDO, compress = TRUE)
  cat("Caché crudo guardado:", nrow(q), "filas x", ncol(q), "columnas\n")
}

bs <- bloque_col(SCH)
s <- as.data.table(zap_labels(read_sav(SCH, col_select = c("CNT", "CNTSCHID", "SC001Q01TA", "SCHLTYPE"),
                                       skip = bs$skip, n_max = bs$n)))
stopifnot(all(s$CNT == PAIS))

# =============================================================================
# 2. RECODIFICAR (decisión D-12)
# =============================================================================
r <- copy(q)

# Posesiones: el nivel más bajo vale 0 y cada categoría suma 1.
si_no  <- grep("^ST250", POS, value = TRUE)                         # 1 = Sí, 2 = No
menos1 <- grep("^ST25[135]", POS, value = TRUE)                     # 1 = ninguno ... k
con_ns <- grep("^ST25[46]", POS, value = TRUE)                      # 1 ... 4, y 5 = "No sé"
n_nose <- r[, lapply(.SD, function(x) sum(x == 5, na.rm = TRUE)), .SDcols = con_ns]
r[, (si_no)  := lapply(.SD, function(x) fcase(x == 1, 1L, x == 2, 0L)), .SDcols = si_no]
r[, (menos1) := lapply(.SD, function(x) as.integer(x) - 1L), .SDcols = menos1]
r[, (con_ns) := lapply(.SD, function(x) { x <- as.integer(x); x[x == 5L] <- NA_integer_; x - 1L }), .SDcols = con_ns]

# Educación de los padres: viene invertida (1 = ISCED 3.4 ... 5 = no completó ISCED 1). Queda 0 ... 4.
r[, educ_madre := 5L - as.integer(ST005Q01JA)]
r[, educ_padre := 5L - as.integer(ST007Q01JA)]

# Sexo
r[, sexo := factor(fcase(ST004D01T == 1, "Mujer", ST004D01T == 2, "Hombre"), levels = c("Mujer", "Hombre"))]

# Zona y sector (plan 07, paso 1.3), y unión por colegio
s[, zona := factor(fcase(SC001Q01TA == 1, "Rural (<3.000)", SC001Q01TA == 2, "Pueblo (3-15 mil)",
                         SC001Q01TA %in% 3:6, "Urbana (>15 mil)"),
                   levels = c("Rural (<3.000)", "Pueblo (3-15 mil)", "Urbana (>15 mil)"))]
s[, sector := factor(fcase(SCHLTYPE == 3, "Público", SCHLTYPE %in% 1:2, "Privado"), levels = c("Público", "Privado"))]
stopifnot(all(r$CNTSCHID %in% s$CNTSCHID))
r <- merge(r, s[, .(CNTSCHID, SC001Q01TA, SCHLTYPE, zona, sector)], by = "CNTSCHID", all.x = TRUE)

# =============================================================================
# 3. CONTROLES
# =============================================================================
en_rango <- function(v, lo, hi) all(is.na(r[[v]]) | (r[[v]] >= lo & r[[v]] <= hi))
stopifnot(
  nrow(r) == N_COL, !anyDuplicated(r$CNTSTUID),
  all(vapply(si_no, en_rango, logical(1), 0, 1)),
  all(vapply(grep("^ST25[146]", POS, value = TRUE), en_rango, logical(1), 0, 3)),
  en_rango("ST253Q01JA", 0, 7), en_rango("ST255Q01JA", 0, 6),
  en_rango("educ_madre", 0, 4), en_rango("educ_padre", 0, 4)
)
saveRDS(r, FINAL, compress = TRUE)
cat("\nGuardado", basename(FINAL), ":", nrow(r), "estudiantes x", ncol(r), "columnas;", uniqueN(r$CNTSCHID), "colegios\n")

# =============================================================================
# 4. DICCIONARIO (solo agregados)
# =============================================================================
etq_stu <- read_sav(STU, n_max = 0); etq_sch <- read_sav(SCH, n_max = 0)
etiqueta <- function(v) { x <- if (v %in% names(etq_stu)) etq_stu[[v]] else etq_sch[[v]]; a <- attr(x, "label"); if (is.null(a)) "" else a }
pct_na <- function(x) round(100 * mean(is.na(x)), 1)
dist   <- function(x) { t <- table(x, useNA = "no"); paste(sprintf("%s: %d", names(t), as.integer(t)), collapse = " | ") }

reglas <- rbind(
  data.table(original = "ST004D01T", nueva = "sexo", regla = "1 = Mujer, 2 = Hombre"),
  data.table(original = "SC001Q01TA", nueva = "zona", regla = "1 = Rural (<3.000); 2 = Pueblo (3-15 mil); 3 a 6 = Urbana (>15 mil)"),
  data.table(original = "SCHLTYPE", nueva = "sector", regla = "3 = Público; 1 y 2 = Privado"),
  data.table(original = "ST005Q01JA", nueva = "educ_madre", regla = "Se invierte: 5 - valor (0 = no completó ISCED 1 ... 4 = ISCED 3.4)"),
  data.table(original = "ST007Q01JA", nueva = "educ_padre", regla = "Se invierte: 5 - valor (0 = no completó ISCED 1 ... 4 = ISCED 3.4)"),
  data.table(original = c("HISCED", "HISEI", "PAREDINT", "ESCS", "HOMEPOS"),
             nueva = c("HISCED", "HISEI", "PAREDINT", "ESCS", "HOMEPOS"), regla = "Sin cambios (solo faltantes de usuario a NA)"),
  data.table(original = si_no, nueva = si_no, regla = "Sí = 1, No = 0"),
  data.table(original = menos1, nueva = menos1, regla = "Categoría - 1 (0 = ninguno)"),
  data.table(original = con_ns, nueva = con_ns, regla = "Categoría - 1 (0 = ninguno); «No sé» (5) a NA")
)
dic <- reglas[, {
  antes <- if (original %in% names(q)) q[[original]] else r[[original]]   # zona y sector: valor original unido al estudiante
  .(etiqueta = etiqueta(original), pct_na_antes = pct_na(antes), pct_na_despues = pct_na(r[[nueva]]),
    valores = if (is.factor(r[[nueva]]) || uniqueN(r[[nueva]], na.rm = TRUE) <= 11) dist(r[[nueva]]) else
      sprintf("continua: %.2f a %.2f", min(r[[nueva]], na.rm = TRUE), max(r[[nueva]], na.rm = TRUE)))
}, by = .(original, nueva, regla)]
fwrite(dic, file.path(SALIDAS, "diccionario_cuestionario.csv"), sep = ";", bom = TRUE)

# Nota del vault (generada: no editar a mano)
f2 <- function(x) sub(".", ",", sprintf("%.1f", x), fixed = TRUE)
tabla <- dic[, sprintf("| `%s` | `%s` | %s | %s | %s |", original, nueva, regla, f2(pct_na_antes), f2(pct_na_despues))]
nota <- c("---", "tipo: datos", "generado_por: Proyecto_PISA/scripts/01b_etl_cuestionario.R",
          paste0("fecha: ", Sys.Date()), "estado: por_verificar", "---", "",
          "# Variables recodificadas del cuestionario (Colombia, PISA 2022)", "",
          "Volver a [[Datos/PISA2022 - Diccionario de variables]] · Reglas en [[03 Registro de decisiones]] (D-12) ·",
          "Plan en [[07 Plan de desarrollo PISA 2022]] (pasos 1.3 y 1.4).", "",
          "Nota generada por el script: no se edita a mano. % NA sobre los 7.804 estudiantes, antes y después de",
          "recodificar. Antes: los faltantes de usuario (Valid Skip, Not Applicable, Invalid, No Response) ya cuentan como NA.",
          "Después: además, el «No sé» de ST254 y ST256 pasa a NA.", "",
          "| Original | Nueva | Regla | % NA antes | % NA después |", "|---|---|---|---|---|", tabla)
con <- file(file.path(VAULT, "PISA2022 - Variables recodificadas.md"), open = "w", encoding = "UTF-8")
writeLines(nota, con); close(con)

# =============================================================================
# 5. RESUMEN EN CONSOLA
# =============================================================================
cat("\n«No sé» recodificado a NA (n de estudiantes):\n"); print(n_nose)
cat("\nSexo:\n"); print(r[, .N, by = sexo][order(sexo)])
cat("\nZona:\n"); print(r[, .N, by = zona][order(zona)])
cat("\nSector:\n"); print(r[, .N, by = sector][order(sector)])
cat("\n% NA en colegios (262): SC001Q01TA =", pct_na(s$SC001Q01TA), "| SCHLTYPE =", pct_na(s$SCHLTYPE), "\n")
cat("\nPrueba de la inversión (correlación de Spearman con HISCED, debe ser positiva):\n")
cat("  educ_madre:", round(cor(r$educ_madre, r$HISCED, method = "spearman", use = "pairwise.complete.obs"), 3),
    "| educ_padre:", round(cor(r$educ_padre, r$HISCED, method = "spearman", use = "pairwise.complete.obs"), 3), "\n")
cat("\nListo: datos/COL_cuestionario.rds, salidas/diccionario_cuestionario.csv y la nota del vault.\n")
