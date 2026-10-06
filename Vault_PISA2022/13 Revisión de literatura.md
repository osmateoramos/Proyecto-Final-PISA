---
tipo: guia
estado: por_verificar
lectura: "redactado por Claude el 2026-10-05 con las notas de fuente; falta revisión del equipo"
verificado_por:
fecha_verificacion:
---

# Revisión de literatura (2026-10-05)

Volver a [[00 Inicio]] · Matriz en [[Literatura/Matriz estado del arte]] · Protocolo en [[11 Protocolo de verificación]]

## Qué se hizo

1. Se cruzaron las claves citadas en el anteproyecto con `referencias.bib`: se citan 24 de las 26 entradas.
2. Se leyeron las fuentes marcadas † que tienen acceso abierto (PDF o HTML), para anotar página y cita textual.
3. Se buscó literatura faltante en Crossref, OpenAlex, Semantic Scholar y SciELO, en cinco temas:
   - omisiones en pruebas de competencias;
   - dimensionalidad de las subescalas de matemáticas de PISA;
   - medición e invarianza del ESCS;
   - DIF por NSE en matemáticas de PISA;
   - Colombia con PISA 2022.
4. Los metadatos de toda fuente nueva salen de Crossref, o de OpenAlex cuando no hay DOI.

**Nada se marcó `verificado`**: todo lo de esta nota sigue `por_verificar` hasta que un integrante lo coteje.

## 1. Qué quitar

| Clave | Por qué | Propuesta |
|---|---|---|
| `icfes2018puntajes` | Está en `referencias.bib`, pero el anteproyecto no la cita | Quitarla del `.bib` (hecho el 2026-10-05; la nota también salió del vault) |
| `icfes2024acceso` | Igual que la anterior | Quitarla del `.bib` (hecho el 2026-10-05; la nota también salió del vault) |
| `zabala2019impacto` | Sí se cita (bloque A), pero es un informe regional de Saber 11 sin revisión por pares. Collazos et al. ya cubren el enfoque econométrico con más de 3 millones de evaluados | **Se conserva** (decisión de Mateo, 2026-10-05) |

## 2. Qué se comprobó (Claude contra la fuente; sigue `por_verificar`)

| Fuente | Qué se leyó | Resultado | Efecto en el anteproyecto |
|---|---|---|---|
| [[Literatura/burns2026intest\|Burns et al. (2026)]] | PDF completo | Incluye a Colombia: n = 7.804 (tabla 1, p. 8) y matemáticas 382,70 (tabla 2, p. 9) | La frase es correcta. Cotejar la p. 1 y quitar [VERIFICAR] |
| [[Literatura/mittal2022assessing\|Mittal et al. (2022)]] | Resumen dentro del PDF (p. 1) | Coincide: invarianza y DIF de HOMEPOS por condición de inmigrante; varios ítems con DIF | La frase es correcta. Cotejar la p. 1 |
| [[Literatura/rodriguez2024rural\|Rodríguez-Gómez et al. (2024)]] | Texto completo (HTML de SciELO) | **Inconsistencia interna:** el "más del 40 %" se atribuye unas veces a los colegios y otras a colegios y familias juntos | **Cambiar la redacción** (propuesta 1) |
| [[Literatura/celik2025differential\|Çelik y Kaşık (2025)]] | Resumen dentro del PDF (p. 638) | Coincide: el DIF por NSE varía según país, pasaje y método | La frase es correcta. Cotejar la p. 638 |
| [[Literatura/rios2022investigation\|Rios y Soland (2022)]] | Resumen oficial | Coinciden las tres afirmaciones | Falta el texto completo para dar la página |
| [[Literatura/ingram2024mathematical\|Ingram et al. (2024)]] | Resumen oficial (repositorio ORA) | Coincide: el razonamiento es fortaleza relativa en unos países y debilidad en otros | La frase es correcta. El PDF está en ORA |

**Resultado:** 6 de las 8 marcas [VERIFICAR] del anteproyecto corresponden a fuentes; de esas 6, 5 coinciden con la
fuente y 1 (Rodríguez-Gómez) debe reescribirse. Las otras dos marcas no son de literatura:

- las condiciones de uso de la base de la OCDE;
- el reparto del trabajo.

Quitar una marca [VERIFICAR] le corresponde al equipo, después de cotejar la página indicada.

## 3. Qué agregar

### Prioridad alta: cambian o sostienen el argumento

| Fuente | Por qué importa | Objetivo |
|---|---|---|
| [[Literatura/goh2024detection\|Goh et al. (2024)]] | **DIF por NSE en matemáticas de PISA 2022** (Corea, árboles de Rasch, 2 subpruebas). Es el antecedente más cercano a O3 y **obliga a acotar la novedad** | O3, H3 |
| [[Literatura/avvisati2024measurement\|Avvisati y Wuyts (2024, OCDE)]] | La misma OCDE dice que HOMEPOS se escala como unidimensional (p. 11) y que una amenaza es "the lack of a theoretical framework for item selection and scale validation" (p. 48). También muestra una anomalía de Colombia en la educación de los padres (p. 20) | O1, H1 |
| [[Literatura/pohl2014dealing\|Pohl, Gräfe y Rose (2014)]] | Omisiones y no alcanzados: la tendencia a omitir se correlaciona con la habilidad, pero en sus datos ignorarla bastó para estimar los parámetros. **Contrapeso a H4** | O3, H4, D-05 |
| [[Literatura/kohler2015taking\|Köhler, Pohl y Carstensen (2015)]] | Modelo con propensión latente a omitir: cambia las estimaciones de habilidad | O3, D-05 |
| [[Literatura/ekmekci2013mathematical\|Ekmekci (2013)]] | Dimensionalidad de matemáticas de PISA 2003–2009: la evidencia favorece más a 1 dimensión | F5.3 |
| [[Literatura/brandt2017calibracion\|Brandt (2017)]] | Crítica a que PISA use un modelo unidimensional para el total y uno multidimensional para las subescalas. Revista latinoamericana | F5.3 |

### Prioridad media

- [[Literatura/kucam2023examination|Kucam y Gülleroğlu (2023)]]: DIF en matemáticas de PISA 2018 por educación de los padres (Turquía).
- [[Literatura/avvisati2020measure|Avvisati (2020)]]: revisión anterior del ESCS. Basta citar esta o la de 2024.
- [[Literatura/okubo2022theoretical|Okubo (2022, OCDE)]]: escalamiento de PISA. Baja prioridad.

### Referencias metodológicas, para citar cuando el texto mencione el método o el paquete

Metadatos de Crossref, consultados el 2026-10-05. El anteproyecto ya nombra `mirt`, `lavaan`, `lavaan.mi`,
`semTools` y las reglas de Rubin, sin citarlos.

| Clave propuesta | Referencia | Para qué |
|---|---|---|
| `chalmers2012mirt` | Chalmers, R. P. (2012). mirt: A Multidimensional Item Response Theory Package for the R Environment. *Journal of Statistical Software, 48*(6). https://doi.org/10.18637/jss.v048.i06 | TRI y MIRT |
| `rosseel2012lavaan` | Rosseel, Y. (2012). lavaan: An R Package for Structural Equation Modeling. *Journal of Statistical Software, 48*(2). https://doi.org/10.18637/jss.v048.i02 | AFC y SEM |
| `wu2016identification` | Wu, H., y Estabrook, R. (2016). Identification of Confirmatory Factor Analysis Models of Different Levels of Invariance for Ordered Categorical Outcomes. *Psychometrika, 81*(4), 1014–1045. https://doi.org/10.1007/s11336-016-9506-0 | Secuencia de invarianza ordinal (O2) |
| `chen2007sensitivity` | Chen, F. F. (2007). Sensitivity of Goodness of Fit Indexes to Lack of Measurement Invariance. *Structural Equation Modeling, 14*(3), 464–504. https://doi.org/10.1080/10705510701301834 | Criterios de cambio en CFI y RMSEA (O2) |
| `muraki1992generalized` | Muraki, E. (1992). A Generalized Partial Credit Model: Application of an EM Algorithm. *Applied Psychological Measurement, 16*(2), 159–176. https://doi.org/10.1177/014662169201600206 | Ítems politómicos (GPCM) |
| `rubin1987multiple` | Rubin, D. B. (1987). *Multiple Imputation for Nonresponse in Surveys*. Wiley. https://doi.org/10.1002/9780470316696 | Combinar los 10 valores plausibles |
| `oecd2009analysis` | OECD (2009). *PISA Data Analysis Manual: SPSS, Second Edition*. https://doi.org/10.1787/9789264056275-en | Pesos, réplicas BRR y valores plausibles |

`semTools` y `lavaan.mi` no tienen DOI: se citan con `citation("semTools")` en R.

## 4. Qué cambia en el argumento

Lo que sigue es interpretación de Claude, para discutir con los tutores.

- **Novedad de O3.**
  - *Antes:* "el DIF por NSE no se ha estudiado en PISA ni en Colombia". Era un error, porque Liu y Bradley ya estaban en la matriz.
  - *Ahora:* el DIF por NSE en matemáticas de PISA 2022 se estudió en Corea, con dos subpruebas y árboles de Rasch.
  - *Lo que sigue sin hacerse:*
    - Colombia;
    - todo el banco de 234 ítems del diseño adaptativo;
    - si el DIF se concentra en una competencia;
    - el cruce con el tratamiento de las omisiones.
  - La novedad de la **combinación** se mantiene.
- **O1.** La revisión de la OCDE de 2024 refuerza la razón de construir un NSE latente con teoría y validación propias.
- **F5.** Es posible que el modelo de 4 competencias no supere claramente al unidimensional (Ekmekci). Eso sería un
  resultado, no un fracaso. El plan ya compara 1 y 4 dimensiones en el paso 5.3.
- **H4.** Pohl et al. sugieren que el efecto de las omisiones podría ser pequeño. **H4 no se cambia**, porque está
  preregistrada; se discute en el informe.
- **D-05.** Köhler et al. ofrecen una tercera alternativa: modelar la propensión a omitir. Si el equipo la quiere, se
  registra como decisión antes de programarla.

**No se cambió ninguna hipótesis ni decisión.**

## 5. Cambios propuestos al anteproyecto y al `.bib`

> **Estado (2026-10-05):** Mateo aprobó las 8 propuestas, **excepto quitar `zabala2019impacto`, que se conserva**. Aplicadas el mismo día en el `.Rmd` y en `referencias.bib`; el PDF se regeneró (10 páginas, 36 referencias). Las fuentes nuevas entraron con marca [VERIFICAR]: el anteproyecto pasó de 8 a 15 marcas. Claude agregó además, y lo avisó, este error a la declaración de uso de IA y cambió "unas treinta fuentes" por "menos de cuarenta fuentes".

1. **Rodríguez-Gómez** (estado del arte, enfoque econométrico).
   - *Cambiar:* "atribuyen más del 40 % a características de los colegios [VERIFICAR]".
   - *Por:* "encuentran que la brecha se explica sobre todo por características observables de los colegios y de las familias".
2. **Tabla de vacío, fila "DIF de matemáticas por NSE".**
   - *Cambiar:* "No estudiado en PISA ni en Colombia".
   - *Por:* "Estudiado en PISA 2022 solo en Corea, con dos subpruebas; no en Colombia ni por competencia".
   - Agregar Goh et al. como antecedente más cercano.
3. **Sección DIF.** Agregar una frase con Goh et al. (2024) y Kucam y Gülleroğlu (2023).
4. **Sección NSE.**
   - Agregar a Avvisati y Wuyts (2024): HOMEPOS es unidimensional y no tiene marco teórico para elegir ítems.
   - Cambiar "el único antecedente que prueba invarianza dentro de un país" por "**entre grupos de estudiantes**
     dentro de un país", porque Rolfe la prueba dentro de Suecia, pero entre ciclos.
5. **Sección de competencias.** Agregar a Ekmekci (2013) y Brandt (2017) sobre la dimensionalidad.
6. **Sección de desenganche.** Agregar a Pohl et al. (2014) y Köhler et al. (2015).
7. **Metodología.** Citar `mirt`, `lavaan`, Wu y Estabrook, Chen y Rubin.
8. **`.bib`.**
   - Quitar `icfes2018puntajes` e `icfes2024acceso`, y `zabala2019impacto` si se aprueba.
   - Agregar las claves aprobadas y luego importarlas al grupo de Zotero (importando el `.bib`, no arrastrando).

## 6. Pendientes para el equipo

- [ ] Cotejar las páginas anotadas y marcar `verificado` en cada nota:
  - Burns: p. 1, 8 y 9;
  - Mittal: p. 1;
  - Çelik: p. 638;
  - Avvisati y Wuyts: p. 9, 11, 20, 21 y 48.
- [ ] Rodríguez-Gómez: abrir el PDF (págs. 59–75) y ver cuál versión del 40 % es la correcta.
- [ ] Conseguir los textos completos de Goh et al. (¿en coreano?) y de Rios y Soland, por la biblioteca de la USTA.
- [ ] Pista secundaria: Odabaşı (2019), DIF por NSE con PISA 2015 de Turquía, citado por Çelik y Kaşık (p. 640). No se ha buscado.
- [x] Aprobar, cambiar o rechazar las propuestas de la sección 5 (aprobadas el 2026-10-05, sin quitar a Zabala).
- [ ] Importar al grupo de Zotero las 12 referencias nuevas con `Proyecto_PISA/anteproyecto/importar_zotero_2026-10-05.bib` (pasos en [[12 Guía de Zotero]]).
- [ ] En F7, repetir la búsqueda formal de novedad, sobre todo en DIF por NSE con PISA 2022.
