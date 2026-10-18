# Proyecto PISA 2022: al abrir Proyecto_PISA.Rproj en RStudio, revisa que R y los paquetes tengan las
# versiones de scripts/versiones_paquetes.csv (scripts/00_verificar_entorno.R). Solo avisa: no instala nada.

# R lee un solo .Rprofile: este reemplaza al personal, así que se carga primero el de cada uno.
if (file.exists("~/.Rprofile")) source("~/.Rprofile")

if (interactive() && file.exists("scripts/00_verificar_entorno.R")) local({
  op <- options(pisa.desde_rprofile = TRUE)
  e <- new.env()
  tryCatch({
    sys.source("scripts/00_verificar_entorno.R", envir = e)
    e$verificar_entorno("scripts/versiones_paquetes.csv")
  }, error = function(err) message("No se pudo revisar las versiones del entorno: ", conditionMessage(err)),
  finally = options(op))
})
