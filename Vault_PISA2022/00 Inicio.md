# Proyecto PISA 2022 Colombia — NSE latente y competencias matemáticas

Vanessa Acosta · Mateo Ramos · Brayan David Barreto · Consultoría Estadística USTA 2026-II
Proyecto integrador: Teoría de Respuesta al Ítem · Ecuaciones Estructurales · Python para APIs e IA

## Por dónde empezar

1. [[11 Protocolo de verificación]] — cómo se marca qué está verificado y qué no (leer primero).
2. [[06 Objetivos PISA 2022]] — pregunta, objetivo general y O1–O5.
3. [[07 Plan de desarrollo PISA 2022]] — paso a paso por semanas. **Estamos en la semana 3 (19–25 oct):** F0, F1 y
   F2 cerradas (la Puerta G1 pasa). En la F3 están hechos el 3.1 (en `main`), el 3.2, el 3.3 y el 3.5 (rama `Vanessa`,
   PR #12). Faltan el 3.3b (dependencia local), el 3.4 (AFC) y la Puerta G2.

## Estado del proyecto (al 2026-10-18)

| Fase | Estado | Scripts | Evidencia |
|---|---|---|---|
| F0 Organización | ✅ cerrada | — | hipótesis congeladas el 2026-10-12, commit `f53054d` ([[09 Hipótesis preregistradas]]) |
| F1 Datos y ETL | ✅ cerrada | `01a_etl_cognitivo.R` → `01b_etl_cuestionario.R` → `01c_muestra_analitica.R` | muestra analítica de 6.886 estudiantes (`salidas/conteos_muestra.csv`); D-12, D-13 y D-14 |
| F2 Validación del diseño | ✅ cerrada, **G1 pasa** | `02_validacion_ocde.R` + `utilidades_pisa.R` | `salidas/validacion_ocde.csv`; D-15 |
| F3 O1: medición del NSE | en curso: 3.1 en `main`; 3.2, 3.3 y 3.5 en el PR #12; faltan 3.3b, 3.4 y G2 | `03_explorar_items_nse.R`, `03_explorar_saltos.R`, `03_nse_medicion.R` (3.1 y 3.2) y `03_nse_tri.R` (3.3 y 3.5) | `salidas/nse_*.csv`; D-16, D-19 y D-20 aceptadas por Vanessa; reglas del 3.4 en D-18 y del 3.3b en D-21 |
| F4–F9 | pendientes | — | — |

Los pasos, las cifras y quién hizo cada script están en [[07 Plan de desarrollo PISA 2022]]; las razones, en
[[03 Registro de decisiones]].

## Repositorio en GitHub

- **Repositorio público**, para que el profesor lo revise: https://github.com/osmateoramos/Proyecto-Final-PISA (rama
  principal `main`). Los datos de PISA y los cachés `.rds` no se suben (`.gitignore`, Ley 1581 de 2012): en el
  repositorio solo hay resultados agregados.
- **Ramas:** una por integrante (`Mateo`, `Vanessa`, `Brayan`) y ramas por fase cuando hace falta (`Vanessa-F3`, ya
  fusionada en el #9).
- **Flujo:** cada rama llega a `main` por *Pull Request*; quien abre el PR no lo fusiona hasta que otro integrante
  lo apruebe. *Pull* antes de empezar (ver `README.md`).
- **Estado al 2026-10-17** (se actualiza al fusionar cada PR):
  - PR #1 a #6 fusionados en `main`: «Nada sin fuente» y la F1 de los pasos 1.2 a 1.4 (`01a` y `01b`).
  - PR #7 (`Vanessa` → `main`), fusionado el 2026-10-17: F1 pasos 1.1 y 1.5 (`01c`) y F2 completa (`02`,
    `utilidades_pisa.R`).
  - PR #8 (`Mateo` → `main`), fusionado el 2026-10-17: firmas de D-14 y D-15 y estado del proyecto en esta nota.
  - PR #9 (`Vanessa-F3` → `main`), fusionado el 2026-10-17: F3 paso 3.1 (`03_explorar_items_nse.R` y
    `03_nse_medicion.R`) y D-16.
  - PR #10 (`Mateo` → `main`), fusionado el 2026-10-17: versiones de R y de los paquetes (D-17) y repositorio
    público.
  - PR #12 (`Vanessa` → `main`), abierto desde el 2026-10-17 y sin revisar: pasos 3.2, 3.3 y 3.5, D-18 a D-23, firmas
    de fuentes del 18/10 y la corrección de la revisión de tutor del 2026-10-18.

## Equipo y reparto (propuesta, por confirmar)

| Persona | Responsable de | Revisa |
|---|---|---|
| Mateo Ramos | O1–O2: medir el NSE e invarianza | O3 y O5 |
| Vanessa Acosta | O3: calificar por competencias y DIF | O4 |
| Brayan David Barreto | O4–O5: modelo estructural, API y tablero | O1–O2 |

La verificación de las 44 fuentes se reparte entre los tres; al 2026-10-18 hay 10 verificadas (ver
[[Literatura/_Léeme]]). Cada uno trabaja en sus notas y scripts.

**En la práctica (al 2026-10-18):** para no atrasar el calendario, Vanessa adelantó la F1 (`01a`, `01c`), la F2 y la
F3 (3.1, 3.2, 3.3 y 3.5), y hará el 3.4. Mateo hizo `01b` y D-17 y revisa los PR. Brayan hizo su parte de «Nada sin
fuente». Mateo y Brayan se ponen al día revisando los PR. Para la sustentación, cada uno debe poder explicar las fases
que no hizo (paso 9.3).

## Notas del proyecto

- **Anteproyecto vigente:** `Proyecto_PISA/anteproyecto/anteproyecto_VanessaAcosta_MateoRamos.pdf`
  (fuente `.Rmd` y `referencias.bib` en la misma carpeta; 4 marcas [VERIFICAR] por revisar antes de entregar; ver [[13 Revisión de literatura]])
- [[03 Registro de decisiones]] — toda decisión, con fecha y razón (D-01 a D-23: en `main` hasta D-17; D-18 a D-23
  en la rama `Vanessa`, PR #12; D-16 y D-17 aún sin todas las firmas)
- **Versiones de R y de los paquetes:** `Proyecto_PISA/scripts/versiones_paquetes.csv` (D-17). Al abrir
  `Proyecto_PISA.Rproj` en RStudio, la consola avisa si alguna no coincide; para instalarlas, paso 3 de «Primera vez»
  del `README.md`.
- [[08 Rúbrica de desarrollo]] — cómo autoevaluarse, puertas de fase y criterio de hallazgo innovador
- [[09 Hipótesis preregistradas]] — H1–H8, congeladas el 2026-10-12
- [[10 Gestión de la información]] — Zotero + Obsidian, instalación y reglas
- [[12 Guía de Zotero]] — qué hace Zotero, el ciclo de una fuente y cómo compartir con un grupo
- [[13 Revisión de literatura]] — revisión del 2026-10-05: qué se quitó, qué se comprobó y qué se agregó
- [[14 Libros de TRI y SEM]] — qué leer de de Ayala y de Chen y Yung en cada fase, y mejoras propuestas al plan
- [[15 Bitácora de uso de IA]] — registro para la actividad "Nada sin fuente" (Consultoría, 30 % del corte)
- [[16 Experimento Nada sin fuente]] — consulta, tratamientos, clasificación de referencias y caso de fallo
- [[17 Plan de trabajo Brayan]] — tareas de Brayan en "Nada sin fuente" y en el proyecto
- [[Literatura/Matriz estado del arte]] — antecedentes vs este proyecto (cada fila enlaza a su nota de fuente)
- [[Literatura/_Léeme]] — todas las fuentes con su estado de verificación
- [[Datos/PISA2022 - Diccionario de variables]] — variables de PISA 2022 que usa el proyecto (etiquetas oficiales)
- [[Datos/PISA2022 - Variables recodificadas]] — variable original → variable nueva, regla y % de `NA` (D-12)
- Proyecto: `CONSULTORIA/Proyecto_PISA/` — anteproyecto, datos (`revision_pisa2022_col.R` y cachés de Colombia),
  scripts (cadena `01a` → `01b` → `01c` → `02` → `03`, más `00_verificar_entorno.R`), salidas, informe, API, documentación, exposiciones y
  `nada_sin_fuente/` (actividad de Consultoría).

## Carpetas

- `Literatura/` — una nota por fuente (ZotLit o `Plantillas/Nota de lectura`)
- `Reuniones/` — una nota por reunión con tutores o entre ustedes
- `Datos/` — diccionario de variables de PISA 2022 y tabla de variables recodificadas
- `Plantillas/` — nota de lectura y nota de dato

## Reglas del vault

Las reglas completas están en [[11 Protocolo de verificación]]; las que sigue Claude, en `CONSULTORIA/CLAUDE.md`.

1. Una idea = una nota. Se enlazan con `[[doble corchete]]`.
2. Toda cifra que vaya al informe se anota con el script que la produce.
3. Toda decisión va a [[03 Registro de decisiones]] antes de programarla.
4. Los datos y los scripts NO viven aquí: viven en `Proyecto_PISA/`. Aquí se enlazan.
5. Nada de datos individuales de estudiantes en el vault (Ley 1581 de 2012).
