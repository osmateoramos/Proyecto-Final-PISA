# -----------------------------------------------------------------------------------------------------------------
# Copia en el proyecto (2026-11-10) de afc_2_permutaciones.R, que corrió en una copia aparte (scratchpad de Claude) del
# 2026-11-08 al 2026-11-10. Solo cambian las rutas y los nombres de los archivos de salida; el cálculo es el mismo.
# Exploratorio y posterior a la Puerta G4: no está en 00_correr_todo.R ni registrado en el 03 (ver Hallazgos.md y la
# nota 17, sección 10). Requiere datos/COL_mat_respuestas.rds, COL_mat_tri_1D.rds y COL_mat_tri_4D.rds, que genera
# 05_tri_competencias.R. Se corre desde Proyecto_PISA/scripts/ con Rscript.
# -----------------------------------------------------------------------------------------------------------------
# AFC de los ítems de matemáticas, parte 2 (lectura fijada en afc_0_lectura_y_viabilidad.R): control D.
# ¿La asignación de la OCDE separa las competencias mejor que una asignación al azar?
# Para que sea comparable y factible (cada 4D completo tarda de 20 a 45 min), en TODAS las asignaciones, también la real:
#   - los parámetros de los ítems se fijan en los del modelo de 1 dimensión del 5.3;
#   - solo se estiman las 6 correlaciones entre factores (varianzas en 1), con pesos y QMCEM con 1.000 puntos;
#   - la log-verosimilitud se recalcula con 10.000 puntos.
# La ganancia es log-verosimilitud del modelo de 4 factores menos la de 1 dimensión. La permutación es dentro de cada
# formato (S automático / C codificación humana), para no regalarle a la asignación real su concentración de preguntas
# abiertas en razonar. Semilla 2026, la del proyecto. Solo agregados.
suppressPackageStartupMessages({ library(data.table); library(mirt) })
carpeta_script <- function() { arg <- grep("^--file=", commandArgs(FALSE), value = TRUE)
  if (length(arg)) dirname(normalizePath(sub("^--file=", "", arg))) else getwd() }
DIR <- carpeta_script(); DATOS <- normalizePath(file.path(DIR, "..", "datos")); SALIDAS <- normalizePath(file.path(DIR, "..", "salidas"))
S <- SALIDAS
D <- DATOS; SAL <- file.path(S, "mat_afc_permutaciones_secuencial.csv")
M <- readRDS(file.path(D, "COL_mat_respuestas.rds")); ITEMS <- colnames(M$a); COMP <- M$competencia[ITEMS]; tipos <- unname(M$tipo[ITEMS])
nse <- readRDS(file.path(D, "COL_nse.rds")); peso <- nse$W_FSTUWT[match(M$CNTSTUID, nse$CNTSTUID)]; w <- peso * length(peso) / sum(peso)
X <- as.data.frame(M$a); m1 <- readRDS(file.path(D, "COL_mat_tri_1D.rds")); sv1 <- as.data.table(mod2values(m1))
fijo <- function(m, modelo, it, q) { sv <- mod2values(m); sv$est <- FALSE
  f <- mirt(X, modelo, itemtype = it, pars = sv, survey.weights = w, method = "QMCEM", quadpts = q, SE = FALSE, verbose = FALSE,
            technical = list(NCYCLES = 1, warn = FALSE)); extract.mirt(f, "logLik") }
ll1 <- fijo(m1, 1, tipos, 10000); cat("logLik 1D con 10.000 puntos:", round(ll1, 2), "\n"); flush.console()

K <- c("emplear", "formular", "interpretar", "razonar"); FACT <- setNames(c("EMP", "FOR", "INT", "RAZ"), K)
corre <- function(etq, nombre) { t0 <- Sys.time()
  sx <- vapply(K, function(k) paste0(FACT[[k]], " = ", paste(ITEMS[etq == k], collapse = ", ")), "")
  modelo <- mirt.model(paste0(paste(sx, collapse = "\n"), "\nCOV = ", paste(FACT, collapse = "*")), itemnames = ITEMS)
  v <- as.data.table(mirt(X, modelo, itemtype = tipos, pars = "values"))
  for (j in ITEMS) { s1 <- sv1[item == j]; ia <- which(v$item == j & grepl("^a[1-4]$", v$name) & v$est)
    stopifnot(length(ia) == 1); v$value[ia] <- s1[name == "a1", value]
    for (nm in s1[grepl("^d", name), name]) v$value[v$item == j & v$name == nm] <- s1[name == nm, value] }
  v$est[v$item != "GROUP"] <- FALSE
  ic <- v$item == "GROUP" & grepl("^COV_", v$name)
  dg <- substr(v$name, 5, 5) == substr(v$name, 6, 6)
  v$value[ic & dg] <- 1; v$est[ic & dg] <- FALSE; v$value[ic & !dg] <- 0.9; v$est[ic & !dg] <- TRUE
  v$est[v$item == "GROUP" & grepl("^MEAN_", v$name)] <- FALSE
  m <- tryCatch(mirt(X, modelo, itemtype = tipos, pars = as.data.frame(v), survey.weights = w, method = "QMCEM", quadpts = 1000, SE = FALSE,
                     verbose = FALSE, technical = list(NCYCLES = 500)), error = function(e) conditionMessage(e))
  if (is.character(m)) return(data.table(asignacion = nombre, convergio = NA, iteraciones = NA_integer_, logLik_10000 = NA_real_, ganancia = NA_real_,
                                         r_min = NA_real_, r_max = NA_real_, minutos = NA_real_, error = substr(m, 1, 120)))
  r <- cov2cor(coef(m, simplify = TRUE)$cov); rs <- r[upper.tri(r)]; ll <- fijo(m, modelo, tipos, 10000)
  data.table(asignacion = nombre, convergio = extract.mirt(m, "converged"), iteraciones = extract.mirt(m, "iterations"), logLik_10000 = ll,
             ganancia = ll - ll1, r_min = min(rs), r_max = max(rs), minutos = round(as.numeric(Sys.time() - t0, units = "mins"), 1), error = "")
}
fmt <- ifelse(grepl("C$", ITEMS), "C", "S"); set.seed(2026)
perms <- lapply(1:19, function(b) { e <- COMP; for (g in c("S", "C")) e[fmt == g] <- sample(COMP[fmt == g]); e })
cat("Coinciden con la real, en promedio:", round(mean(sapply(perms, function(e) mean(e == COMP))) * 100, 1), "% de los ítems\n")
res <- list(corre(COMP, "OCDE")); print(res[[1]]); fwrite(rbindlist(res), SAL); flush.console()
for (b in 1:19) { res[[b + 1]] <- corre(perms[[b]], paste0("azar_", b)); print(res[[b + 1]]); fwrite(rbindlist(res), SAL); flush.console() }

r <- rbindlist(res); az <- r[asignacion != "OCDE" & !is.na(ganancia)]
cat("\n=== D. Control con asignaciones al azar ===\n")
cat("Ganancia OCDE:", round(r[asignacion == "OCDE", ganancia], 2), "| r máx.:", round(r[asignacion == "OCDE", r_max], 3), "\n")
cat("Azar (", nrow(az), "): ganancia mínima", round(min(az$ganancia), 2), "mediana", round(median(az$ganancia), 2), "máxima", round(max(az$ganancia), 2), "\n")
cat("Azar: r máx. mediana", round(median(az$r_max), 3), "| r mín. mediana", round(median(az$r_min), 3), "\n")
cat("Asignaciones al azar con ganancia igual o mayor que la OCDE:", sum(az$ganancia >= r[asignacion == "OCDE", ganancia]), "de", nrow(az), "\n")
cat("p de permutación:", round((1 + sum(az$ganancia >= r[asignacion == "OCDE", ganancia])) / (1 + nrow(az)), 3), "\n")
