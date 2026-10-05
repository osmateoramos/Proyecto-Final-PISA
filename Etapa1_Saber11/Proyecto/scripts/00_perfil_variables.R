# =============================================================================
# PERFIL DE LAS 92 VARIABLES ORIGINALES
# Genera salidas/perfil_variables_originales.csv, insumo del diccionario
# Vault_PISA2022/Datos/Variables originales.md
# Correr desde Proyecto/ (abrir Proyecto.Rproj).
# =============================================================================
suppressPackageStartupMessages(library(data.table))
if (!dir.exists("scripts") && dir.exists("../scripts")) setwd("..")

CANDIDATOS <- c("datos/crudos/Examen_Saber_11_20252.txt",
                "../Primer Corte/Examen_Saber_11_20252.txt")
ARCHIVO <- CANDIDATOS[file.exists(CANDIDATOS)][1]

dt <- fread(ARCHIVO, sep = ";", encoding = "UTF-8",
            na.strings = c("", "NA", "."), showProgress = FALSE)
con_cuest <- !is.na(dt$estu_inse_individual)

perfil <- rbindlist(lapply(seq_along(dt), function(i) {
  x <- dt[[i]]
  tab <- sort(table(x), decreasing = TRUE)
  numerica <- is.numeric(x)
  data.table(
    posicion       = i,
    variable       = names(dt)[i],
    clase_r        = class(x)[1],
    n_distintos    = length(tab),
    ejemplos       = if (numerica && length(tab) > 15)
                       sprintf("rango %s a %s", format(min(x, na.rm = TRUE)), format(max(x, na.rm = TRUE)))
                     else paste(head(names(tab), 4), collapse = " | "),
    pct_na_total   = round(100 * mean(is.na(x)), 1),
    pct_na_analit  = round(100 * mean(is.na(x[con_cuest])), 1)
  )
}))
fwrite(perfil, "salidas/perfil_variables_originales.csv")
cat("Listo:", nrow(perfil), "variables -> salidas/perfil_variables_originales.csv\n")
