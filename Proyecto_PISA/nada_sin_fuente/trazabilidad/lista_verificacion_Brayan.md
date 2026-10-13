# Lista para verificar la trazabilidad de Brayan (18 filas)

Archivo que se llena: `trazabilidad/trazabilidad_Brayan.csv` (Excel → *Guardar como → CSV UTF-8*).
Los PDF están en `Proyecto_PISA/nada_sin_fuente/corpus/`. Las páginas y citas de abajo las encontró Claude en los
PDF: **son pistas**. Solo se firma lo que Brayan abrió y comprobó con sus propios ojos.

## Qué se escribe en cada fila

| Columna | Qué poner |
|---|---|
| `ubicacion` | `pág. N` (si la página impresa no se ve, `pág. PDF N`) + cita corta entre «» |
| `se_sostiene` | `sí` · `parcial` · `no` |
| `correccion_propuesta` | Solo si es `parcial` o `no`: cómo debe quedar la frase del anteproyecto |
| `verificado_por` | `Brayan David Barreto` |
| `fecha` | `2026-10-13` |

Si una fila no se pudo comprobar (sin PDF), se deja **sin firmar** y se declara en la memoria.

## A. Con PDF en `corpus/` (13 filas)

- [ ] **T-Bra-01 · collazos2021determinantes.pdf** — págs. PDF 2, 11, 14 y 15
  - Buscar: «modelo de combinación de corte transversal» (p. 2) · «3.247.429 observaciones» (p. 11) · estrato
    +0,81, madre con posgrado +7,44, internet +1,14 (p. 14) · computador +1,42 (p. 15).
  - Pista: **parcial**. Las cifras están, pero el artículo no dice «mínimos cuadrados ordinarios».
  - Corrección sugerida: «estiman, con un modelo de combinación de cortes transversales sobre 3 247 429 evaluados…».
- [ ] **T-Bra-02 · zabala2019impacto.pdf** — pág. 1 (resumen) y pág. 9
  - Buscar: «acceso a internet y nivel de escolaridad de los progenitores, presentan un impacto negativo y
    significativo».
  - Pista: **sí** (la frase sobre el internet se sostiene). Aparte: el año 2019 es el de los datos; el documento
    menciona 2020 (pág. 5). Anotar en `correccion_propuesta`: «corregir el año de la referencia (s. f. o fecha real)».
- [ ] **T-Bra-03 · rodriguez2024rural.pdf** — pág. PDF 3
  - Buscar: «observable factors emerged as pivotal drivers» y «more than 20% of the gap in mathematics».
  - Pista: **sí** con la redacción actual del anteproyecto.
- [ ] **T-Bra-04 · guerra2026digital.pdf** — pág. 1 (resumen)
  - Buscar: región ALC, PISA 2022, «multilevel models and LightGBM/SHAP».
  - El número **13 países no aparece escrito**: contarlos en la tabla o figura de países de ALC. Si no son 13,
    es **parcial** y se corrige el número.
  - «Sin TRI ni modelos estructurales»: en el texto no aparecen (búsqueda de «IRT» y «structural equation»).
- [ ] **T-Bra-05 · oecd2024pisa2022tr.pdf** — pág. PDF 345 (impresa 343) y pág. PDF 55 (impresa 53)
  - Buscar: «mathematical reasoning was "new" this cycle as a separate process scale».
  - Pista: **sí**.
- [ ] **T-Bra-06 · ingram2024mathematical.pdf** — pág. 1 (resumen)
  - Buscar: «relative strengths specifically in mathematical reasoning… while in other countries, this is an area
    of relative weakness».
  - Pista: **sí**.
- [ ] **T-Bra-07 · patsis2026instructional.pdf** — pág. 1 (resumen)
  - Buscar: «two-level structural equation models» · «TIMSS 2019» · «SES remained a robust predictor at both levels».
  - Pista: **sí**.
- [ ] **T-Bra-08 · icfes2024pisa.pdf** — pág. PDF 31 (sección 3.1.3.1, Figura 14)
  - Buscar: las subescalas de proceso solo como promedios de Colombia, la OCDE y Latinoamérica.
  - Pista: **sí**. Es una afirmación de ausencia: ninguna página cruza las subescalas con el ESCS.
- [ ] **T-Bra-10 · brandt2017calibracion.pdf** — pág. 1 (resumen)
  - Buscar: «aplica un modelo TRI unidimensional para el análisis de logros matemáticos y a su vez aplica un
    modelo TRI multidimensional para analizar cuatro sub-escalas».
  - Pista: **sí**.
- [ ] **T-Bra-12 · oecd2024pisa2022tr.pdf** — pág. PDF 495 (impresa 493)
  - Buscar: «Annex A. Item Pool Classification tables».
  - Pista: **sí**.
- [ ] **T-Bra-13 · oecd2024pisa2022tr.pdf** — págs. PDF 35 y 36 (impresas 33 y 34)
  - Buscar: «three stages and 234 mathematics items from a total of 99 units» · «the total number of mathematics
    items taken by each student ranged from 28-30» (los dos en la pág. PDF 35) · «adaptive parts - taken by 75%» /
    «linear parts - taken by 25%» (pág. PDF 36).
  - Pista: **sí**. *Corregido el 2026-10-13: la versión anterior de esta lista decía que «28 a 30» no aparecía, y
    sí aparece.*
- [ ] **T-Bra-17 · chalmers2012mirt.pdf** — pág. 1
  - Buscar: «mirt: A Multidimensional Item Response Theory Package for the R Environment». Pista: **sí**.
- [ ] **T-Bra-18 · rosseel2012lavaan.pdf** — pág. 1
  - Buscar: «lavaan: An R Package for Structural Equation Modeling». Pista: **sí**.

## B. Sin PDF en `corpus/` (5 filas)

- [ ] **T-Bra-09 · ekmekci2013** — abrir http://hdl.handle.net/2152/21338 en el navegador y leer el resumen.
  - Comprobar: AFC sobre ítems de matemáticas de PISA 2003, 2006 y 2009, con más evidencia a favor de una sola
    dimensión. Si solo se lee el resumen, escribir «(resumen)» en `ubicacion`.
- [ ] **T-Bra-11 · oecd2023pisadb** — es la base de datos. Abrir la página de descarga de PISA 2022 de la OCDE y
  comprobar que existen los archivos del cuestionario de estudiantes, cognitivo y de colegios.
- [ ] **T-Bra-14 · wu2016identification** — versión de autor en PubMed Central (PMC5458787), abrir en el navegador.
  - Comprobar: secuencia de invarianza para indicadores ordinales (umbrales, cargas, interceptos).
- [ ] **T-Bra-15 · chen2007sensitivity** — acceso cerrado. Leer el resumen en la página de la revista
  (https://doi.org/10.1080/10705510701301834).
  - Comprobar: propone cambios en CFI y RMSEA como criterio de invarianza. Si solo se lee el resumen, decirlo.
- [ ] **T-Bra-16 · rubin1987multiple** — libro de acceso cerrado. Si no se consigue, **no se firma**: se deja
  sin firmar y se declara («reglas de combinación de imputación múltiple; libro no consultado»).

## Al terminar

1. Guardar el CSV (UTF-8) y cerrarlo.
2. Avisar a Claude: corre `nsf_trazabilidad.R unir` y actualiza la tabla de la memoria.
