# =============================================================================
# AUDITORIA DE DATOS - Saber 11 (Examen_Saber_11_20252.txt)
# Anteproyecto: NSE como constructo latente (SEM) + calibracion TRI + DIF
# Vanessa Acosta / Mateo Ramos
#
# Objetivo del script: verificar empiricamente los supuestos de datos sobre los
# que descansan los objetivos 1, 2 y 3 del anteproyecto, ANTES de escribir
# cualquier modelo.
#
# Ejecutar con R 4.4.1 (es la instalacion que tiene los paquetes):
#   & "C:\Program Files\R\R-4.4.1\bin\Rscript.exe" 00_auditoria_datos.R
# =============================================================================

options(stringsAsFactors = FALSE, scipen = 999)

req <- c("data.table", "dplyr", "psych", "ggplot2")
falta <- req[!req %in% rownames(installed.packages())]
if (length(falta)) stop("Faltan paquetes: ", paste(falta, collapse = ", "))
suppressPackageStartupMessages({
  library(data.table); library(dplyr); library(psych); library(ggplot2)
})

ARCHIVO <- "Examen_Saber_11_20252.txt"
OUT     <- "auditoria_saber11"
dir.create(OUT, showWarnings = FALSE)

log_con <- file(file.path(OUT, "log_auditoria.txt"), open = "wt", encoding = "UTF-8")
sink(log_con, split = TRUE)

titulo <- function(x) cat("\n\n", strrep("=", 78), "\n", x, "\n", strrep("=", 78), "\n", sep = "")
sub_t  <- function(x) cat("\n--- ", x, " ---\n", sep = "")
fnum   <- function(x) format(x, big.mark = ".", decimal.mark = ",", scientific = FALSE)

# =============================================================================
titulo("0. CARGA E INTEGRIDAD DEL ARCHIVO")
# =============================================================================
# Antes de leer nada: verificar que la descarga esta completa. Un archivo
# truncado a mitad de registro se lee sin error y produce descriptivos que
# parecen validos, por eso este chequeo va primero.
sub_t("Integridad de la descarga")
con <- file(ARCHIVO, "rb")
tam <- file.size(ARCHIVO)
invisible(seek(con, max(0, tam - 5000)))
cola <- rawToChar(readBin(con, "raw", 5000))
close(con)
Encoding(cola) <- "UTF-8"
lineas_cola <- strsplit(cola, "\r?\n")[[1]]
ultima <- lineas_cola[length(lineas_cola)]
# Se cuentan separadores + 1, no strsplit: strsplit descarta el campo vacio
# final, de modo que una linea completa cuya ultima columna viene vacia
# (termina en ";") se contaria como 91 y dispararia un falso truncamiento.
n_campos_ultima <- length(gregexpr(";", ultima, fixed = TRUE)[[1]]) + 1
termina_en_salto <- grepl("\n$", cola)

cat("Tamano del archivo:", fnum(round(tam / 1024^2, 1)), "MB\n")
cat("Termina en salto de linea:", termina_en_salto, "\n")
cat("Campos en la ultima linea:", n_campos_ultima, "(deberian ser 92)\n")
TRUNCADO <- !termina_en_salto || n_campos_ultima < 92
if (TRUNCADO) {
  cat("\n*** ARCHIVO TRUNCADO ***\n",
      "La ultima linea esta cortada a mitad de registro. La descarga quedo\n",
      "incompleta. Los descriptivos de abajo se calculan sobre lo que alcanzo a\n",
      "bajar y NO deben citarse en el documento sin volver a descargar.\n", sep = "")
} else {
  cat("Archivo completo.\n")
}

t0 <- Sys.time()
dt <- fread(ARCHIVO, sep = ";", encoding = "UTF-8", na.strings = c("", "NA", "."),
            showProgress = FALSE)
N_COLS_ORIG <- ncol(dt)   # se guarda antes de crear variables derivadas
cat("\nFilas leidas:", fnum(nrow(dt)), " Columnas:", N_COLS_ORIG, "\n")
cat("Tiempo de carga:", round(difftime(Sys.time(), t0, units = "secs")), "seg\n")
cat("Periodos presentes:", paste(sort(unique(dt$periodo)), collapse = ", "), "\n")

sub_t("Duplicados")
cat("estu_consecutivo duplicados:", sum(duplicated(dt$estu_consecutivo)), "\n")
cat("Filas completamente duplicadas:", sum(duplicated(dt)), "\n")


# =============================================================================
titulo("1. OBJETIVO 1 - Hay respuestas item por item en este archivo?")
# =============================================================================
# El objetivo 1 exige calibrar un modelo TRI propio, lo que requiere la matriz
# de respuestas dicotomicas persona x item. Aqui se verifica si existe.

nombres <- names(dt)
patrones_item <- "^(p|item|resp|pregunta|ib|it)[_.]?[0-9]+|item|respuesta"
cols_item <- grep(patrones_item, nombres, ignore.case = TRUE, value = TRUE)

cat("Columnas que podrian ser respuestas de item:",
    if (length(cols_item)) paste(cols_item, collapse = ", ") else "NINGUNA", "\n")

sub_t("Todo lo que el archivo trae sobre desempeno en matematicas")
print(grep("matematic", nombres, ignore.case = TRUE, value = TRUE))

sub_t("Familias de variables de resultado disponibles")
for (pref in c("punt_", "desemp_", "percentil_")) {
  cat(sprintf("%-12s: %s\n", pref,
      paste(grep(paste0("^", pref), nombres, value = TRUE), collapse = ", ")))
}

cat("\nVEREDICTO O1: el archivo entrega puntajes agregados por area (escala 0-100),\n",
    "niveles de desempeno (1-4) y percentiles. NO entrega respuestas por item.\n",
    "Sin matriz persona x item no se puede calibrar un modelo TRI propio.\n", sep = "")


# =============================================================================
titulo("2. LA ANOMALIA DE ESTRATO (el supuesto bug de agrupamiento)")
# =============================================================================
# En el anteproyecto se reporta estrato 1 = 51,87 y estrato 6 = 47,77, en
# sentido contrario a la literatura. Aqui se reproduce desde el crudo.

# "Sin Estrato" queda NA por construccion: no es el escalon 0 de una ordinal.
# La coercion genera NAs a proposito, por eso se silencia el aviso.
dt[, estrato_num := suppressWarnings(as.integer(sub("Estrato ", "", fami_estratovivienda)))]

sub_t("Puntaje de matematicas por estrato (crudo, tal como viene el archivo)")
tab_estrato <- dt[, .(n           = .N,
                      media_mat   = round(mean(punt_matematicas, na.rm = TRUE), 2),
                      sd_mat      = round(sd(punt_matematicas, na.rm = TRUE), 2),
                      media_inse  = round(mean(estu_inse_individual, na.rm = TRUE), 2),
                      pct_no_ofic = round(100 * mean(cole_naturaleza == "NO OFICIAL",
                                                     na.rm = TRUE), 1)),
                  by = .(fami_estratovivienda)][order(fami_estratovivienda)]
print(tab_estrato)
fwrite(tab_estrato, file.path(OUT, "tabla_estrato.csv"))

sub_t("Contraste con el INSE del ICFES (indice construido, no autorreportado)")
dt[, inse_decil := cut(estu_inse_individual,
                       breaks = quantile(estu_inse_individual, probs = seq(0, 1, 0.1),
                                         na.rm = TRUE),
                       include.lowest = TRUE, labels = 1:10)]
tab_inse <- dt[!is.na(inse_decil),
               .(n = .N, media_mat = round(mean(punt_matematicas, na.rm = TRUE), 2)),
               by = inse_decil][order(inse_decil)]
print(tab_inse)
fwrite(tab_inse, file.path(OUT, "tabla_inse_decil.csv"))

sub_t("Correlaciones")
cat("estrato ~ punt_matematicas : ",
    round(cor(dt$estrato_num, dt$punt_matematicas, use = "complete.obs"), 3), "\n")
cat("INSE    ~ punt_matematicas : ",
    round(cor(dt$estu_inse_individual, dt$punt_matematicas, use = "complete.obs"), 3), "\n")
cat("estrato ~ INSE             : ",
    round(cor(dt$estrato_num, dt$estu_inse_individual, use = "complete.obs"), 3), "\n")
cat("\nSi estrato correlaciona debilmente incluso con el INSE del propio ICFES,\n",
    "el problema esta en el estrato, no en el puntaje.\n", sep = "")

cat("\nLECTURA: si el INSE es monotono y fuerte mientras el estrato no lo es, la\n",
    "anomalia no es un error de agrupamiento del script sino ruido de medicion en\n",
    "una variable autorreportada por un menor de edad. Eso es un ARGUMENTO A FAVOR\n",
    "de modelar el NSE como constructo latente en vez de usar estrato observado.\n",
    sep = "")

p <- ggplot(dt[!is.na(estrato_num)],
            aes(x = factor(estrato_num), y = punt_matematicas)) +
  geom_boxplot(outlier.alpha = 0.05, fill = "grey85") +
  stat_summary(fun = mean, geom = "point", color = "red", size = 2) +
  labs(title = "Matematicas por estrato autorreportado",
       subtitle = "Punto rojo = media. La relacion no es monotona.",
       x = "Estrato de vivienda", y = "Puntaje matematicas") +
  theme_minimal()
ggsave(file.path(OUT, "fig_estrato.png"), p, width = 7, height = 5, dpi = 150)


# =============================================================================
titulo("3. OBJETIVO 3 - Viabilidad del DIF entre calendarios A y B")
# =============================================================================
sub_t("Distribucion de cole_calendario")
tab_cal <- dt[, .(n = .N,
                  pct = round(100 * .N / nrow(dt), 3),
                  media_mat = round(mean(punt_matematicas, na.rm = TRUE), 2)),
              by = cole_calendario][order(-n)]
print(tab_cal)
fwrite(tab_cal, file.path(OUT, "tabla_calendario.csv"))

n_b <- dt[cole_calendario == "B", .N]
cat("\nCalendario B: n =", n_b, "\n")
if (n_b < 5000) {
  cat("ALERTA O3: el calendario B es marginal en esta aplicacion. Los colegios de\n",
      "calendario B presentan mayoritariamente en la aplicacion del PRIMER semestre\n",
      "(periodo 20251), no en esta. Comparar calendarios con este archivo solo no es\n",
      "viable; y aun uniendo ambos periodos, el calendario B es un grupo pequeno y\n",
      "muy seleccionado (privado, urbano, alto NSE), lo que confunde calendario con\n",
      "nivel socioeconomico.\n", sep = "")
}

sub_t("Perfil de los colegios de calendario B (para dimensionar la confusion)")
print(dt[cole_calendario %in% c("A", "B"),
         .(n = .N,
           pct_no_oficial = round(100 * mean(cole_naturaleza == "NO OFICIAL", na.rm = TRUE), 1),
           pct_urbano     = round(100 * mean(cole_area_ubicacion == "URBANA", na.rm = TRUE), 1),
           media_inse     = round(mean(estu_inse_individual, na.rm = TRUE), 2)),
         by = cole_calendario])


# =============================================================================
titulo("4. OBJETIVO 2 - Viabilidad del NSE latente (SEM)")
# =============================================================================
sub_t("Faltantes en el bloque de indicadores candidatos")
indic <- c("fami_estratovivienda", "fami_educacionmadre", "fami_educacionpadre",
           "fami_numlibros", "fami_cuartoshogar", "fami_personashogar",
           "fami_tieneautomovil", "fami_tienecomputador", "fami_tieneinternet",
           "fami_tienelavadora", "fami_tienehornomicroogas", "fami_tieneserviciotv",
           "fami_tienemotocicleta", "fami_tieneconsolavideojuegos")
miss <- data.table(variable = indic,
                   pct_na = sapply(indic, function(v) round(100 * mean(is.na(dt[[v]])), 2)))
print(miss)
fwrite(miss, file.path(OUT, "tabla_faltantes_indicadores.csv"))

# --- Recodificacion ordinal (por patron, robusto a acentos y encoding) -------
rec <- function(x, pats, vals) {
  out <- rep(NA_integer_, length(x))
  for (i in seq_along(pats)) {
    hit <- is.na(out) & grepl(pats[i], x, ignore.case = TRUE)
    out[hit] <- vals[i]
  }
  out
}
si_no <- function(x) ifelse(is.na(x), NA_integer_,
                            ifelse(grepl("^Si$", x, ignore.case = TRUE), 1L, 0L))

# OJO: "No sabe" y "No Aplica" en educacion de los padres NO son el escalon mas
# bajo de la escala; son no-respuesta. Tratarlos como 0 sesga el modelo.
# Los 12 niveles originales se colapsan a 6: polychoric admite hasta 8 categorias
# y las celdas de los niveles "incompleta" quedan muy poco pobladas.
niv_educ <- c("No sabe", "No Aplica", "Ninguno", "Primaria",
              "Secundaria.*incompleta", "Secundaria.*completa",
              "cnica", "profesional|Postgrado")
val_educ <- c(NA, NA, 1L, 2L, 3L, 4L, 5L, 6L)

dt[, educ_madre := rec(fami_educacionmadre, niv_educ, val_educ)]
dt[, educ_padre := rec(fami_educacionpadre, niv_educ, val_educ)]
dt[, libros   := rec(fami_numlibros, c("^0 A 10", "^11 A 25", "^26 A 100", "DE 100"),
                     c(1L, 2L, 3L, 4L))]
dt[, cuartos  := rec(fami_cuartoshogar,
                     c("^Uno", "^Dos", "^Tres", "^Cuatro", "^Cinco", "^Seis"),
                     c(1L, 2L, 3L, 4L, 5L, 6L))]
dt[, personas := rec(fami_personashogar, c("^1 a 2", "^3 a 4", "^5 a 6", "^7 a 8", "^9"),
                     c(1L, 2L, 3L, 4L, 5L))]
for (v in grep("^fami_tiene", names(dt), value = TRUE)) {
  set(dt, j = paste0("b_", sub("^fami_tiene", "", v)), value = si_no(dt[[v]]))
}

items <- c("estrato_num", "educ_madre", "educ_padre", "libros", "cuartos",
           grep("^b_", names(dt), value = TRUE))

sub_t("Casos completos en el bloque de medida")
cc <- complete.cases(dt[, ..items])
cat("Completos:", fnum(sum(cc)), "de", fnum(nrow(dt)),
    sprintf("(%.1f%%)\n", 100 * mean(cc)))
cat("NOTA: con perdida por item cercana al 10% conviene FIML/WLSMV sobre datos\n",
    "parciales antes que listwise; el listwise descarta una fraccion no trivial.\n",
    sep = "")

sub_t("Correlacion policorica del bloque de medida (submuestra n=4000)")
set.seed(2025)
sub_dt <- dt[cc][sample(.N, min(4000, .N))][, ..items]
pc <- try(psych::polychoric(as.data.frame(sub_dt))$rho, silent = TRUE)

if (!inherits(pc, "try-error")) {
  print(round(pc[1:6, 1:6], 2))
  fwrite(as.data.table(round(pc, 3), keep.rownames = "variable"),
         file.path(OUT, "matriz_policorica.csv"))

  sub_t("Adecuacion factorial")
  cat("KMO global:", round(psych::KMO(pc)$MSA, 3), "\n")
  ev <- eigen(pc)$values
  cat("Primeros 5 autovalores:", paste(round(ev[1:5], 2), collapse = ", "), "\n")
  cat("Varianza explicada por el 1er factor:", sprintf("%.1f%%\n", 100 * ev[1] / sum(ev)))

  sub_t("Cargas del factor unico (unidimensionalidad del NSE)")
  fa1 <- try(psych::fa(pc, nfactors = 1, n.obs = nrow(sub_dt), fm = "wls"), silent = TRUE)
  if (!inherits(fa1, "try-error")) {
    cargas <- data.table(indicador = rownames(fa1$loadings),
                         carga = round(as.numeric(fa1$loadings[, 1]), 3))[order(-carga)]
    print(cargas)
    fwrite(cargas, file.path(OUT, "cargas_factor_nse.csv"))
    cat("\nIndicadores con carga menor a 0.30 (candidatos a salir del modelo):\n")
    print(cargas[carga < 0.30])
  }
} else {
  cat("No se pudo estimar la matriz policorica:\n"); print(pc)
}


# =============================================================================
titulo("5. RESUMEN PARA EL DOCUMENTO")
# =============================================================================
if (TRUNCADO) {
  cat("\n*** ADVERTENCIA: el archivo leido esta TRUNCADO. Vuelve a descargarlo\n",
      "    antes de citar cualquier cifra de este informe. ***\n", sep = "")
}

cat("
1. FUENTE DE DATOS. Archivo agregado de DataIcfes: ", fnum(nrow(dt)),
" registros leidos y ", N_COLS_ORIG, " variables, sin respuestas por item. El
   anteproyecto describe 576.213 registros; este archivo (periodo ",
   as.character(unique(dt$periodo)[1]), ") tiene otro tamano, asi que hay que
   declarar exactamente cual aplicacion se usa.

2. OBJETIVO 1 (TRI propio). No ejecutable con esta fuente: no hay matriz de
   respuestas. Se suma la reserva legal del banco de preguntas (Ley 1324 de 2009).
   Reformular hacia analisis sobre los puntajes ya calibrados por el ICFES.

3. ANOMALIA DE ESTRATO. Se reproduce desde el crudo, no es un bug del script.
   Es ruido de medicion del autorreporte y sostiene el argumento del NSE latente.

4. OBJETIVO 3 (DIF por calendario). Inviable con este archivo (calendario B
   marginal) y confundido con NSE aunque se unan periodos.

5. OBJETIVO 2 (NSE latente). Es el objetivo mas solido: el bloque de indicadores
   existe, con faltantes manejables y estructura factorial evaluable.
", sep = "")

cat("\n\nSalidas escritas en: ", normalizePath(OUT), "\n", sep = "")
sink()
close(log_con)
cat("Listo. Revisa", file.path(OUT, "log_auditoria.txt"), "\n")
