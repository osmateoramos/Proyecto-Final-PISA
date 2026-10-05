# =============================================================================
# DICCIONARIO DE VARIABLES PISA 2022 USADAS EN EL PROYECTO (Colombia)
#
# Lee las etiquetas oficiales de los .SAV (solo metadatos) y calcula el % de datos
# faltantes en el bloque de Colombia. Genera:
#   Proyecto_PISA/salidas/diccionario_pisa2022.csv
#   Vault_PISA2022/Datos/PISA2022 - Diccionario de variables.md
# Correr desde cualquier carpeta:
#   & "C:\Program Files\R\R-4.4.1\bin\Rscript.exe" diccionario_pisa2022.R
# =============================================================================
suppressPackageStartupMessages({ library(haven); library(data.table) })
carpeta_script <- function() {
  arg <- grep("^--file=", commandArgs(FALSE), value = TRUE)
  if (length(arg)) return(dirname(normalizePath(sub("^--file=", "", arg))))
  getwd()
}
DIR   <- carpeta_script()                       # Proyecto_PISA/datos
RAIZ  <- normalizePath(file.path(DIR, "..", ".."))
STU   <- file.path(DIR, "CY08MSP_STU_QQQ.SAV")
SCH   <- file.path(DIR, "CY08MSP_SCH_QQQ.SAV")
COG   <- file.path(DIR, "CY08MSP_STU_COG.SAV")

# Variables del proyecto por bloque (uso = objetivo o función)
sel <- list(
  "Identificación y diseño" = list(arch = "STU", vars = c("CNT", "CNTSCHID", "CNTSTUID", "STRATUM", "W_FSTUWT", "W_FSTURWT1"), uso = "Unir archivos; pesos (W_FSTURWT1 representa las 80 réplicas)"),
  "Grupos" = list(arch = "STU", vars = c("ST004D01T", "GRADE", "IMMIG"), uso = "O2 (sexo) y covariables de O4"),
  "Colegio" = list(arch = "SCH", vars = c("SC001Q01TA", "SCHLTYPE"), uso = "O2: zona y sector"),
  "NSE: índices oficiales" = list(arch = "STU", vars = c("ESCS", "HISEI", "PAREDINT", "HISCED", "HOMEPOS"), uso = "Contraste y validación de O1"),
  "NSE: educación de los padres" = list(arch = "STU", vars = c("ST005Q01JA", "ST007Q01JA"), uso = "O1: capital cultural"),
  "NSE: posesiones del hogar (HOMEPOS)" = list(arch = "STU", vars = NULL, patron = "^ST25[0-6]Q", uso = "O1: indicadores del NSE latente"),
  "Competencias: valores plausibles OCDE" = list(arch = "STU", vars = c("PV1MATH", "PV1MPFS", "PV1MPEM", "PV1MPIN", "PV1MPRE"), uso = "O3 validación; O4 robustez (PV1 representa PV1–PV10)"),
  "Ítems de matemáticas: diseño adaptativo" = list(arch = "COG", vars = c("MPATH", "MS1_LEV", "MS2_LEV"), uso = "O3: ruta adaptativa"),
  "Ítems de matemáticas: ejemplo de un ítem" = list(arch = "COG", vars = c("CM033Q01S", "CM033Q01TT", "CM033Q01F", "CM033Q01A"), uso = "O3: respuesta calificada (S/C), tiempo (TT), primera acción (F), acciones (A); igual para los 234 ítems")
)

bloque_col <- function(f) {
  cnt <- read_sav(f, col_select = "CNT")[["CNT"]]
  w <- which(cnt == "COL"); list(skip = min(w) - 1, n = length(w))
}
filas <- list()
for (arch in c("STU", "SCH", "COG")) {
  f <- get(arch); h <- read_sav(f, n_max = 0)
  b <- bloque_col(f)
  for (nm in names(sel)) {
    s <- sel[[nm]]; if (s$arch != arch) next
    vars <- if (is.null(s$vars)) grep(s$patron, names(h), value = TRUE) else intersect(s$vars, names(h))
    d <- read_sav(f, col_select = all_of(vars), skip = b$skip, n_max = b$n)
    for (v in vars) {
      lab <- attr(h[[v]], "label"); if (is.null(lab)) lab <- ""
      filas[[length(filas) + 1]] <- data.table(bloque = nm, archivo = arch, variable = v,
        etiqueta_oficial = gsub("\\|", "/", lab), uso = s$uso,
        pct_na_colombia = round(100 * mean(is.na(d[[v]])), 1))
    }
  }
}
dic <- rbindlist(filas)
dic <- dic[!(pct_na_colombia >= 99.5 & grepl("^ST25", variable))]   # ítems no aplicados en Colombia
fwrite(dic, file.path(RAIZ, "Proyecto_PISA", "salidas", "diccionario_pisa2022.csv"))

md <- c("---", "tipo: dato", "estado: por_verificar",
        "script: Proyecto_PISA/datos/diccionario_pisa2022.R",
        "salida: Proyecto_PISA/salidas/diccionario_pisa2022.csv",
        paste0("fecha_calculo: ", Sys.Date()), "verificado_por:", "fecha_verificacion:", "---", "",
        "# Diccionario de variables PISA 2022 usadas en el proyecto (Colombia)", "",
        "Volver a [[00 Inicio]] · Objetivos en [[06 Objetivos PISA 2022]]", "",
        "Etiquetas tomadas de los archivos oficiales de la OCDE (`.SAV`). `% NA` = faltantes en los 7.804 estudiantes",
        "(o 262 colegios) de Colombia. Versión inicial: se completa en el paso 1.4 del plan.", "")
for (nm in names(sel)) {
  x <- dic[bloque == nm]; if (!nrow(x)) next
  md <- c(md, paste0("## ", nm), "", paste0("*Uso:* ", x$uso[1], " · Archivo: `", x$archivo[1], "`"), "",
          "| Variable | Etiqueta oficial (OCDE) | % NA Colombia |", "|---|---|---|",
          sprintf("| `%s` | %s | %s |", x$variable, x$etiqueta_oficial, format(x$pct_na_colombia, decimal.mark = ",")), "")
}
writeLines(md, file.path(RAIZ, "Vault_PISA2022", "Datos", "PISA2022 - Diccionario de variables.md"), useBytes = TRUE)
cat("Variables documentadas:", nrow(dic), "\n")
