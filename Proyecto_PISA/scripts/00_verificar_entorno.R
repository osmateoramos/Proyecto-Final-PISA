# =============================================================================
# 00 VERIFICAR ENTORNO - versiones de R y de los paquetes del proyecto
#
# Qué hace:
#   Compara la versión de R y la de cada paquete instalado con scripts/versiones_paquetes.csv,
#   para que los tres corran los scripts con las mismas versiones mientras se arma el contenedor
#   (Docker). Solo revisa: no instala nada salvo que se pida con --instalar.
#
#   Las versiones del archivo son las de la copia de CRAN del 2026-10-17 en Posit Package Manager,
#   que tiene binarios para R 4.4 en Windows (no hay que compilar nada). La excepción es mirt: ver la
#   columna `nota` del archivo.
#
# Cuándo corre:
#   - solo, al abrir Proyecto_PISA.Rproj en RStudio (lo llama Proyecto_PISA/.Rprofile);
#   - a mano, desde Proyecto_PISA/scripts/:
#       & "C:\Program Files\R\R-4.4.1\bin\Rscript.exe" 00_verificar_entorno.R
#     (termina con código 1 si algo no coincide);
#   - además de la versión, comprueba que cada paquete carga (requireNamespace): un paquete puede tener la
#     versión correcta y no cargar porque le falta una dependencia, como le pasó a lavaan sin pbivnorm
#     (observación 14 de Brayan, PR #12). Al abrir RStudio no se hace, para no demorar el arranque;
#   - para instalar las versiones del archivo, en una sesión nueva de R (con RStudio cerrado, para
#     que Windows no bloquee los paquetes en uso):
#       & "C:\Program Files\R\R-4.4.1\bin\Rscript.exe" 00_verificar_entorno.R --instalar
#
# Límite: fija los paquetes que usa el proyecto, no sus dependencias. Eso lo resuelve Docker.
# =============================================================================

verificar_entorno <- function(archivo, instalar = FALSE, probar_carga = !isTRUE(getOption("pisa.desde_rprofile"))) {
  v  <- utils::read.csv(archivo, stringsAsFactors = FALSE, fileEncoding = "UTF-8")
  pk <- v[v$paquete != "R", ]

  # --- R
  r_req <- v$version[v$paquete == "R"]
  r_act <- paste(R.version$major, R.version$minor, sep = ".")
  r_ok  <- identical(r_act, r_req)

  # --- Paquetes (packageDescription lee la descripción instalada, tal como la escribe CRAN; no carga el paquete)
  inst <- vapply(pk$paquete, function(p) as.character(suppressWarnings(utils::packageDescription(p, fields = "Version"))), "")
  cmp <- mapply(function(a, b) if (is.na(a)) NA_integer_ else utils::compareVersion(a, b), inst, pk$version)
  estado <- ifelse(is.na(inst), "no instalado",
                   ifelse(cmp == 0, "ok", ifelse(cmp < 0, "más vieja", "más nueva")))
  if (probar_carga) {
    carga <- vapply(pk$paquete, function(p) isTRUE(tryCatch(suppressPackageStartupMessages(requireNamespace(p, quietly = TRUE)),
                                                          error = function(e) FALSE)), logical(1))
    estado[estado == "ok" & !carga] <- "no carga"
  }
  tabla <- data.frame(paquete = pk$paquete, requerida = pk$version, instalada = ifelse(is.na(inst), "-", inst),
                      estado = estado, stringsAsFactors = FALSE)
  difieren <- tabla$estado != "ok"

  cat("\n--- Entorno R del proyecto PISA (scripts/versiones_paquetes.csv) ---\n")
  cat("R", r_act, if (r_ok) "(ok)\n" else paste0("-> el proyecto usa R ", r_req, "\n"))
  if (r_ok && !any(difieren)) {
    cat("Al día: los", nrow(tabla), "paquetes coinciden con el archivo",
        if (probar_carga) "y cargan.\n\n" else "(no se probó que carguen).\n\n")
    return(invisible(TRUE))
  }
  if (any(difieren)) {
    print(tabla[difieren, ], row.names = FALSE)
    cat(sum(difieren), "de", nrow(tabla), "paquetes no coinciden.\n")
  }

  if (!instalar) {
    cat("Para instalar las versiones del proyecto (RStudio cerrado), desde Proyecto_PISA/scripts/:\n",
        "  & \"C:\\Program Files\\R\\R-4.4.1\\bin\\Rscript.exe\" 00_verificar_entorno.R --instalar\n\n", sep = "")
    return(invisible(FALSE))
  }

  # --- Instalar (solo con --instalar)
  if (!r_ok) {
    cat("No se instala nada: primero hay que usar R ", r_req, ". Los binarios dependen de la versión de R.\n\n", sep = "")
    return(invisible(FALSE))
  }
  falta <- pk[difieren, ]
  for (repo in unique(falta$repositorio)) {
    pq <- falta$paquete[falta$repositorio == repo]
    cat("\nInstalando desde", repo, ":", paste(pq, collapse = ", "), "\n")
    utils::install.packages(pq, repos = repo, type = "binary")
  }
  verificar_entorno(archivo, instalar = FALSE)
}

# Carpeta del script: funciona con Rscript, con source() y con RStudio.
carpeta_script <- function() {
  arg <- grep("^--file=", commandArgs(FALSE), value = TRUE)
  if (length(arg)) return(dirname(normalizePath(sub("^--file=", "", arg))))
  if (!is.null(sys.frames()[[1]]$ofile)) return(dirname(normalizePath(sys.frames()[[1]]$ofile)))
  getwd()
}

# Con Rscript (o con Source en RStudio) revisa en el acto. Proyecto_PISA/.Rprofile solo carga la
# función y la llama él mismo.
if (!isTRUE(getOption("pisa.desde_rprofile"))) {
  ok <- verificar_entorno(file.path(carpeta_script(), "versiones_paquetes.csv"),
                          instalar = "--instalar" %in% commandArgs(trailingOnly = TRUE))
  if (!interactive()) quit(save = "no", status = if (ok) 0L else 1L)
}
