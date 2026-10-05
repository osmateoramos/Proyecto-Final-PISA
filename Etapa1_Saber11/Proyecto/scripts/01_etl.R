# =============================================================================
# FASE 1 - ETL, recodificacion y libro de codigos
# Proyecto: NSE latente y desempeno en matematicas, Saber 11 2025-2
# Vanessa Acosta / Mateo Ramos
#
# COMO USARLO
#   Abrir Proyecto/Proyecto.Rproj en RStudio (asi el directorio de trabajo es
#   Proyecto/) y correr BLOQUE POR BLOQUE (Ctrl+Enter), leyendo la salida de cada
#   verificacion antes de pasar al siguiente. No correrlo todo de una sola vez la
#   primera vez: la idea es entender cada decision.
#
#   Guia paso a paso: Vault_PISA2022/01 Plan paso a paso.md, Fase 1.
#   Cada decision de recodificacion esta en Vault_PISA2022/03 Registro de decisiones.md
#
# Tambien corre completo por consola, desde la carpeta Proyecto/:
#   & "C:\Program Files\R\R-4.4.1\bin\Rscript.exe" scripts/01_etl.R
# =============================================================================

options(stringsAsFactors = FALSE, scipen = 999)
suppressPackageStartupMessages(library(data.table))

# Si se corre con Rscript desde otra carpeta, ubicarse en Proyecto/
if (!dir.exists("scripts") && dir.exists("../scripts")) setwd("..")

# Rutas. El crudo (422 MB) NO se versiona en Git: se busca primero en
# datos/crudos/ y, si no esta, en la carpeta del primer corte.
CANDIDATOS <- c("datos/crudos/Examen_Saber_11_20252.txt",
                "../Primer Corte/Examen_Saber_11_20252.txt")
ARCHIVO   <- CANDIDATOS[file.exists(CANDIDATOS)][1]
if (is.na(ARCHIVO)) stop("No encuentro Examen_Saber_11_20252.txt en: ",
                         paste(CANDIDATOS, collapse = " ni "))
SALIDA_RDS <- "datos/procesados/saber11_analitica.rds"
dir.create("datos/procesados", recursive = TRUE, showWarnings = FALSE)
dir.create("salidas", showWarnings = FALSE)

fnum <- function(x) format(x, big.mark = ".", decimal.mark = ",", scientific = FALSE)

# Recodificacion por patron (tomada de Primer Corte/00_auditoria_datos.R).
# Recorre los patrones EN ORDEN y asigna el valor del primero que coincide;
# lo que no coincide con ninguno queda NA. Por eso el orden importa:
# "Secundaria.*incompleta" tiene que ir antes que "Secundaria.*completa".
rec <- function(x, pats, vals) {
  out <- rep(NA_real_, length(x))
  for (i in seq_along(pats)) {
    hit <- is.na(out) & grepl(pats[i], x, ignore.case = TRUE)
    out[hit] <- vals[i]
  }
  out
}
si_no <- function(x) ifelse(is.na(x), NA_integer_,
                            ifelse(grepl("^Si$", x, ignore.case = TRUE), 1L, 0L))


# =============================================================================
# 1.1 CARGAR Y FILTRAR LA MUESTRA ANALITICA
# =============================================================================
# Por que: los modelos de medida del NSE necesitan el cuestionario
# socioeconomico. Quien no lo diligencio no tiene INSE ni indicadores, asi que
# no puede entrar. Esa exclusion NO es aleatoria (sacan menos en matematicas):
# hay que dejarla cuantificada para declararla como limite de validez externa.

dt_total <- fread(ARCHIVO, sep = ";", encoding = "UTF-8",
                  na.strings = c("", "NA", "."), showProgress = FALSE)
N_TOTAL <- nrow(dt_total)

excluidos <- dt_total[is.na(estu_inse_individual)]
dt        <- dt_total[!is.na(estu_inse_individual)]

cat("\n[1.1] Registros en el archivo:        ", fnum(N_TOTAL), "\n")
cat("[1.1] Sin cuestionario (excluidos):    ", fnum(nrow(excluidos)),
    sprintf("(%.1f %%)\n", 100 * nrow(excluidos) / N_TOTAL))
cat("[1.1] Muestra analitica:               ", fnum(nrow(dt)), "\n")
cat("[1.1] Matematicas excluidos vs incluidos: ",
    round(mean(excluidos$punt_matematicas, na.rm = TRUE), 2), "vs",
    round(mean(dt$punt_matematicas, na.rm = TRUE), 2), "\n")


# =============================================================================
# 1.2 DUPLICADOS EN estu_consecutivo
# =============================================================================
# Por que: estu_consecutivo deberia identificar a cada evaluado una sola vez.
# Aqui NO se borra nada: se muestran los casos y se marcan con una bandera.
# La decision (conservar / eliminar) la toma el equipo y va al registro.

dup_ids <- dt_total[duplicated(estu_consecutivo), unique(estu_consecutivo)]
cat("\n[1.2] Consecutivos repetidos en el archivo completo:", length(dup_ids), "\n")
if (length(dup_ids)) {
  print(dt_total[estu_consecutivo %in% dup_ids,
                 .(estu_consecutivo, estu_estudiante, estu_genero, cole_nombre_sede,
                   punt_matematicas, punt_global, tiene_inse = !is.na(estu_inse_individual))])
}
dt[, dup_consecutivo := estu_consecutivo %in% dup_ids]
cat("[1.2] De ellos en la muestra analitica:", sum(dt$dup_consecutivo), "filas\n")
rm(dt_total, excluidos); invisible(gc())


# =============================================================================
# 1.3 RECODIFICACION
# =============================================================================
# Regla general: todo lo que NO es un escalon de la escala ("No sabe",
# "No Aplica", "Sin Estrato") es NO-RESPUESTA (NA), nunca el nivel mas bajo.
# Las variables nuevas conservan la original intacta: se crean columnas nuevas.

# --- 1.3a Educacion de los padres: 12 categorias -> 6 niveles ----------------
# Se colapsan porque las categorias "incompleta" quedan poco pobladas y las
# correlaciones policoricas se vuelven inestables con celdas pequenas.
niv_educ <- c("No sabe", "No Aplica", "Ninguno", "Primaria",
              "Secundaria.*incompleta", "Secundaria.*completa",
              "cnica", "profesional|Postgrado")
val_educ <- c(NA, NA, 1, 2, 3, 4, 5, 6)
dt[, educ_madre := as.integer(rec(fami_educacionmadre, niv_educ, val_educ))]
dt[, educ_padre := as.integer(rec(fami_educacionpadre, niv_educ, val_educ))]

# --- 1.3b Estrato: "Sin Estrato" es NA, no estrato 0 --------------------------
dt[, estrato := suppressWarnings(as.integer(sub("Estrato ", "", fami_estratovivienda)))]

# --- 1.3c Bienes del hogar: Si/No -> 1/0 --------------------------------------
for (v in grep("^fami_tiene", names(dt), value = TRUE)) {
  set(dt, j = paste0("b_", sub("^fami_tiene", "", v)), value = si_no(dt[[v]]))
}

# --- 1.3d Libros, cuartos, personas -------------------------------------------
dt[, libros   := as.integer(rec(fami_numlibros,
                                c("^0 A 10", "^11 A 25", "^26 A 100", "100"), 1:4))]
dt[, cuartos  := as.integer(rec(fami_cuartoshogar,
                                c("^Uno", "^Dos", "^Tres", "^Cuatro", "^Cinco", "^Seis"), 1:6))]
dt[, personas := as.integer(rec(fami_personashogar,
                                c("^1 a 2", "^3 a 4", "^5 a 6", "^7 a 8", "^9"), 1:5))]

# Hacinamiento = personas por cuarto, con el punto medio de cada categoria.
# Personas tiene relacion INVERSA con el NSE: combinarla con cuartos da un
# indicador con sentido sustantivo (mas personas por cuarto = mas privacion).
pm_personas <- c(1.5, 3.5, 5.5, 7.5, 9.5)
dt[, hacinamiento := round(pm_personas[personas] / cuartos, 2)]

# --- 1.3e Alimentacion: frecuencia semanal 1-4 --------------------------------
pat_frec <- c("Nunca o rara", "^1 o 2", "^3 a 5", "Todos o casi")
dt[, come_proteina := as.integer(rec(fami_comecarnepescadohuevo,    pat_frec, 1:4))]
dt[, come_cereal   := as.integer(rec(fami_comecerealfrutoslegumbre, pat_frec, 1:4))]
dt[, come_lacteos  := as.integer(rec(fami_comelechederivados,       pat_frec, 1:4))]

# --- 1.3f Ocupacion de los padres: nominal -> prestigio ordinal 1-5 -----------
# PROPUESTA (decision D-08 en el registro). La original nominal se conserva
# porque en TRI podria modelarse con respuesta nominal en vez de GRM.
# "Hogar/no trabaja", "Pensionado", "No sabe" y "No aplica" quedan NA:
# no son un nivel de prestigio ocupacional.
pat_ocup <- c("agricultor|limpieza",                          # 1 manual no calificado
              "operario|vendedor|cuenta propia",               # 2 manual calificado / servicios
              "auxiliar administrativo|negocio peque",         # 3 administrativo / pequeno negocio
              "profesional",                                   # 4 profesional
              "negocio grande|directivo")                      # 5 directivo
dt[, ocup_madre := as.integer(rec(fami_trabajolabormadre, pat_ocup, 1:5))]
dt[, ocup_padre := as.integer(rec(fami_trabajolaborpadre, pat_ocup, 1:5))]

# --- 1.3f' Maximo de los dos padres (como HISEI / HISCED en PISA) ------------
# Con "hogar" como NA, ocup_madre pierde ~43 % de los casos y educ_padre ~11 %
# ("No sabe" suele indicar padre ausente: faltante NO aleatorio). Tomar el
# mayor de los dos padres recupera casi todos. Propuesta D-08: usar ocup_max y
# educ_max como indicadores y dejar los de cada padre para analisis de robustez.
dt[, ocup_max := suppressWarnings(pmax(ocup_madre, ocup_padre, na.rm = TRUE))]
dt[, educ_max := suppressWarnings(pmax(educ_madre, educ_padre, na.rm = TRUE))]

# --- 1.3g Variables de grupo --------------------------------------------------
dt[, sexo      := fifelse(estu_genero == "F", "Mujer", fifelse(estu_genero == "M", "Hombre", NA_character_))]
dt[, sector    := fifelse(cole_naturaleza == "OFICIAL", "Oficial",
                  fifelse(cole_naturaleza == "NO OFICIAL", "No oficial", NA_character_))]
dt[, zona      := fifelse(toupper(cole_area_ubicacion) %in% c("URBANA", "URBANO"), "Urbana",
                  fifelse(toupper(cole_area_ubicacion) == "RURAL", "Rural", NA_character_))]
# Jornadas nocturna y sabatina = educacion de adultos (decision D-06 pendiente).
dt[, jornada_adultos := cole_jornada %in% c("NOCHE", "SABATINA")]

cat("\n[1.3] Verificacion de recodificaciones (tabla cruzada original -> nueva):\n")
print(dt[, .N, by = .(fami_educacionmadre, educ_madre)][order(educ_madre)])
print(dt[, .N, by = .(fami_trabajolaborpadre, ocup_padre)][order(ocup_padre)])
cat("\n[1.3] Zona:\n");            print(dt[, .N, by = zona])
cat("[1.3] Jornada de adultos:\n"); print(dt[, .N, by = jornada_adultos])
cat("[1.3] Hacinamiento (resumen):\n"); print(summary(dt$hacinamiento))


# =============================================================================
# 1.4 GUARDAR LA BASE ANALITICA
# =============================================================================
saveRDS(dt, SALIDA_RDS, compress = TRUE)
cat("\n[1.4] Guardado", SALIDA_RDS, "-", fnum(nrow(dt)), "filas x", ncol(dt), "columnas\n")


# =============================================================================
# 1.5 LIBRO DE CODIGOS
# =============================================================================
# Una fila por variable NUEVA: de donde sale, que regla se aplico, faltantes.
codigos <- rbindlist(list(
  list("educ_madre",      "fami_educacionmadre",      "ordinal 1-6", "Ninguno=1 Primaria=2 Sec.incompleta=3 Sec.completa=4 Tecnica=5 Profesional/Postgrado=6; No sabe/No Aplica=NA"),
  list("educ_padre",      "fami_educacionpadre",      "ordinal 1-6", "igual que educ_madre"),
  list("estrato",         "fami_estratovivienda",     "ordinal 1-6", "Sin Estrato=NA"),
  list("libros",          "fami_numlibros",           "ordinal 1-4", "0-10=1 11-25=2 26-100=3 >100=4"),
  list("cuartos",         "fami_cuartoshogar",        "ordinal 1-6", "Uno=1 ... Seis o mas=6"),
  list("personas",        "fami_personashogar",       "ordinal 1-5", "1-2=1 ... 9 o mas=5"),
  list("hacinamiento",    "personas + cuartos",       "continua",    "punto medio de personas / cuartos"),
  list("b_automovil",     "fami_tieneautomovil",      "binaria 0/1", "Si=1 No=0"),
  list("b_computador",    "fami_tienecomputador",     "binaria 0/1", "Si=1 No=0"),
  list("b_consolavideojuegos", "fami_tieneconsolavideojuegos", "binaria 0/1", "Si=1 No=0"),
  list("b_hornomicroogas","fami_tienehornomicroogas", "binaria 0/1", "Si=1 No=0"),
  list("b_internet",      "fami_tieneinternet",       "binaria 0/1", "Si=1 No=0"),
  list("b_lavadora",      "fami_tienelavadora",       "binaria 0/1", "Si=1 No=0"),
  list("b_motocicleta",   "fami_tienemotocicleta",    "binaria 0/1", "Si=1 No=0 (excluida del modelo, D-03)"),
  list("b_serviciotv",    "fami_tieneserviciotv",     "binaria 0/1", "Si=1 No=0"),
  list("come_proteina",   "fami_comecarnepescadohuevo",    "ordinal 1-4", "Nunca=1 1-2/sem=2 3-5/sem=3 Diario=4"),
  list("come_cereal",     "fami_comecerealfrutoslegumbre", "ordinal 1-4", "igual que come_proteina"),
  list("come_lacteos",    "fami_comelechederivados",       "ordinal 1-4", "igual que come_proteina"),
  list("ocup_madre",      "fami_trabajolabormadre",   "ordinal 1-5", "prestigio (D-08); hogar/pensionado/no sabe/no aplica=NA"),
  list("ocup_padre",      "fami_trabajolaborpadre",   "ordinal 1-5", "igual que ocup_madre"),
  list("ocup_max",        "ocup_madre + ocup_padre",  "ordinal 1-5", "maximo de los dos padres (D-08)"),
  list("educ_max",        "educ_madre + educ_padre",  "ordinal 1-6", "maximo de los dos padres (D-08)"),
  list("sexo",            "estu_genero",             "grupo",       "F=Mujer M=Hombre"),
  list("sector",          "cole_naturaleza",          "grupo",       "OFICIAL / NO OFICIAL"),
  list("zona",            "cole_area_ubicacion",      "grupo",       "URBANA y URBANO unificadas"),
  list("jornada_adultos", "cole_jornada",             "bandera",     "NOCHE o SABATINA = TRUE (D-06)"),
  list("dup_consecutivo", "estu_consecutivo",         "bandera",     "consecutivo repetido en el archivo")
))
setnames(codigos, c("variable_nueva", "variable_origen", "tipo", "regla"))
codigos[, pct_na := sapply(variable_nueva, function(v) round(100 * mean(is.na(dt[[v]])), 2))]
fwrite(codigos, "salidas/diccionario.csv")
cat("\n[1.5] Libro de codigos -> salidas/diccionario.csv\n")
print(codigos[, .(variable_nueva, tipo, pct_na)])


# =============================================================================
# 1.6 REPRODUCIR LAS CIFRAS DEL ANTEPROYECTO
# =============================================================================
# Por que: toda cifra que vaya al informe tiene que salir de un script.
# "OK" = coincide con el anteproyecto; "REVISAR" = no coincide: corregir el
# documento o declarar el filtro que se uso (ver 04 Pendientes del primer corte).
verifica <- function(nombre, obtenido, esperado, tol = 0.005) {
  estado <- if (abs(obtenido - esperado) <= tol) "OK     " else "REVISAR"
  cat(sprintf("  %s %-45s obtenido %10s | anteproyecto %10s\n",
              estado, nombre, format(obtenido, decimal.mark = ","),
              format(esperado, decimal.mark = ",")))
}
cat("\n[1.6] Contraste con el anteproyecto\n")
verifica("Registros en la muestra analitica", nrow(dt), 495807, 0)
verifica("Matematicas NSE 1", round(mean(dt[estu_nse_individual == 1]$punt_matematicas), 2), 47.22)
verifica("Matematicas NSE 4", round(mean(dt[estu_nse_individual == 4]$punt_matematicas), 2), 61.81)
verifica("Correlacion matematicas-lectura",
         round(cor(dt$punt_matematicas, dt$punt_lectura_critica, use = "complete.obs"), 3), 0.760)
verifica("Matematicas sector no oficial", round(mean(dt[sector == "No oficial"]$punt_matematicas), 2), 56.15)
verifica("Matematicas sector oficial",    round(mean(dt[sector == "Oficial"]$punt_matematicas), 2), 51.03)

# Faltantes en los indicadores del modelo, AHORA sobre la base analitica
indicadores <- c("estrato", "educ_madre", "educ_padre", "libros", "cuartos",
                 "b_automovil", "b_computador", "b_consolavideojuegos",
                 "b_hornomicroogas", "b_internet", "b_lavadora", "b_serviciotv")
na_ind <- sapply(indicadores, function(v) 100 * mean(is.na(dt[[v]])))
cat(sprintf("\n  Faltantes por indicador (base analitica): %.1f %% a %.1f %%\n",
            min(na_ind), max(na_ind)))
cat(sprintf("  Casos completos en los %d indicadores:     %.1f %%\n",
            length(indicadores), 100 * mean(complete.cases(dt[, ..indicadores]))))
cat("  (el anteproyecto reporta 11,8-16,3 % y 63,2 %, calculados sobre el archivo completo)\n")
cat("  Nota: educ_* y estrato suben de NA porque 'No sabe'/'Sin Estrato' ahora son NA.\n")
alt <- c("estrato", "educ_max", "libros", "cuartos", grep("^b_(?!moto)", indicadores, value = TRUE, perl = TRUE), "ocup_max")
cat(sprintf("  Con educ_max + ocup_max en vez de cada padre: %.1f %% casos completos\n",
            100 * mean(complete.cases(dt[, ..alt]))))

cat("\nFase 1 terminada.\n")
