# Lista para verificar la trazabilidad de Brayan (18 filas)

Archivo que se llena: `trazabilidad/trazabilidad_Brayan.csv` (Excel → *Guardar como → CSV UTF-8*).
Los PDF están en `Proyecto_PISA/nada_sin_fuente/corpus/`. Las páginas y frases de abajo las encontró Claude en los
PDF y las volvió a comprobar el 2026-10-13: **son pistas**. Solo se firma lo que Brayan abrió y vio.

«Pág.» es el número que muestra el visor del PDF, no el número impreso en la hoja. Para buscar: `Ctrl+F`.

## En todas las filas que se firman

| Columna | Qué poner |
|---|---|
| `ubicacion` | lo que dice cada fila abajo |
| `se_sostiene` | `sí` · `parcial` · `no` |
| `correccion_propuesta` | solo si es `parcial` o `no` |
| `verificado_por` | `Brayan David Barreto` |
| `fecha` | `2026-10-13` |

## A. Con PDF en `corpus/` (13 filas)

- [ ] **T-Bra-01 · collazos2021determinantes.pdf**
  - Pág. 2: «combinación de corte transversal» · pág. 11: «3.247.429» · pág. 14: «1,14 puntos», «0,81», «7,44» ·
    pág. 15: «1,42».
  - Pista: **parcial**. Las cifras están, pero el artículo no dice «mínimos cuadrados ordinarios».
  - Corrección: cambiar «con mínimos cuadrados ordinarios» por «con un modelo de combinación de cortes transversales».
- [ ] **T-Bra-02 · zabala2019impacto.pdf**
  - Pág. 1 (resumen): «negativo y significativo» (internet y escolaridad de los padres) y «Norte de Santander».
  - Pista: **sí**. Aparte: los datos son de 2019, pero el documento habla de hechos de 2020 (pág. 5, la pandemia),
    así que no puede ser de 2019. Corrección: «corregir el año de la referencia».
- [ ] **T-Bra-03 · rodriguez2024rural.pdf**
  - Pág. 3: «pivotal drivers», «over 40%» (colegios) y «more than 20% of the gap» (familias).
  - Pista: **sí**.
- [ ] **T-Bra-04 · guerra2026digital.pdf**
  - Pág. 1: «LightGBM» y «multilevel». Pág. 13: la **Tabla 4** («Latin America and the Caribbean: country-level ESCS
    achievement gradients in mathematics»): contar los países. Son 13 (no está Costa Rica).
  - «Sin TRI ni modelos estructurales»: buscar «structural equation» e «item response»; no aparecen.
  - Pista: **sí**.
- [ ] **T-Bra-05 · oecd2024pisa2022tr.pdf**
  - Pág. 345: «as a separate process scale» (la frase dice que el razonamiento matemático fue «new» en este ciclo).
    Pág. 55: «mathematical reasoning as a separate process classification».
  - Pista: **sí**.
- [ ] **T-Bra-06 · ingram2024mathematical.pdf**
  - Pág. 1: «relative weakness». Pista: **sí**.
- [ ] **T-Bra-07 · patsis2026instructional.pdf**
  - Pág. 1: «two-level structural equation» y «robust predictor». Pista: **sí**.
- [ ] **T-Bra-08 · icfes2024pisa.pdf**
  - Pág. 31: «Subescalas de proceso» y la Figura 14: solo promedios de Colombia, la OCDE y Latinoamérica.
  - Pista: **sí** (es una afirmación de ausencia).
- [ ] **T-Bra-10 · brandt2017calibracion.pdf**
  - Pág. 1: «cuatro sub-escalas» (la frase dice TRI unidimensional para el logro y multidimensional para las
    subescalas). Pista: **sí**.
- [ ] **T-Bra-12 · oecd2024pisa2022tr.pdf**
  - Pág. 495: «Item Pool Classification tables» (índice del anexo A). La clasificación está en el Excel del anexo:
    `Proyecto_PISA/documentacion/PISA2022_TechnicalReport_AnexoA_clasificacion_items.xlsx`, hoja *Mathematics-CBA*,
    columnas *Item Format*, *Content*, *Context* y *Process*.
  - Pista: **sí**.
- [ ] **T-Bra-13 · oecd2024pisa2022tr.pdf**
  - Pág. 35: «234 mathematics items» y «ranged from 28-30». Pág. 36: «taken by 75%» y «taken by 25%».
  - Pista: **sí**. *Corregido el 2026-10-13: una versión anterior de esta lista decía que «28 a 30» no aparecía.*
- [ ] **T-Bra-17 · chalmers2012mirt.pdf**
  - Pág. 1: el título del artículo. Pista: **sí**.
- [ ] **T-Bra-18 · rosseel2012lavaan.pdf**
  - Pág. 1: el título del artículo. Pista: **sí**.

## B. Sin PDF en `corpus/` (5 filas)

- [ ] **T-Bra-09 · Ekmekci (2013)**: http://hdl.handle.net/2152/21338. Comprobar en el resumen: AFC con ítems de
  matemáticas de PISA 2003, 2006 y 2009, más evidencia a favor de una sola dimensión. Ubicación: «resumen (repositorio
  UT Austin)».
- [ ] **T-Bra-11 · base de PISA 2022**: https://www.oecd.org/en/data/datasets/pisa-2022-database.html. Comprobar que
  están los archivos del cuestionario de estudiantes, el cognitivo y el de colegios, en SPSS. Ubicación: «página de
  descarga de la OCDE».
- [ ] **T-Bra-14 · Wu y Estabrook (2016)**: buscar en Google «Wu Estabrook 2016 Identification of confirmatory factor
  analysis models ordered categorical PMC». Comprobar en el resumen: la identificación de los modelos de invarianza
  para indicadores ordinales. Ubicación: «resumen (PMC)».
- [ ] **T-Bra-15 · Chen (2007)**: https://doi.org/10.1080/10705510701301834. Comprobar en el resumen: propone cambios
  en CFI y RMSEA como criterio de invarianza. Ubicación: «resumen (página de la revista)».
- [ ] **T-Bra-16 · Rubin (1987)**: libro cerrado. **No se firma**: la fila se deja vacía y se declara.

## Al terminar

1. Guardar el CSV (UTF-8) y cerrarlo.
2. Avisar a Claude: corre `nsf_trazabilidad.R unir` y actualiza la memoria.
