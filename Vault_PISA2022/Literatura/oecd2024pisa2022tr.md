---
tipo: fuente
clave_bib: oecd2024pisa2022tr
zotero-key: A5GFC6CZg6703955
clave_provisional: no
titulo: PISA 2022 Technical Report
autores: OECD
año: "2024 (por verificar: el PDF muestra © 2024 y © 2025)"
publicacion: OECD Publishing
doi_url: https://www.oecd.org/content/dam/oecd/en/publications/reports/2024/03/pisa-2022-technical-report_599753f0/01820d6d-en.pdf
bloque: B. Medición del NSE / diseño
estado: por_verificar
lectura: "IA: búsqueda en el texto extraído del PDF (545 págs.)"
pdf_en_zotero: sí (dos copias en el grupo desde el 2026-10-12; comprobado por Claude con Better BibTeX, 2026-10-18)
verificado_por:
fecha_verificacion:
---

# PISA 2022 Technical Report

Volver a [[Literatura/Matriz estado del arte]] · Protocolo en [[11 Protocolo de verificación]]

## Qué hace
Documenta muestreo, escalamiento, índices del cuestionario y datos de PISA 2022.

## Datos y método
- País / datos / n: 80 países/economías
- Técnica: TRI (GPCM), MSAT, BRR, PV

## Afirmaciones que usamos en el proyecto

| # | Afirmación (como la usamos) | Página | Cita textual (< 15 palabras) | Estado |
|---|---|---|---|---|
| 1 | Matemáticas: diseño adaptativo multietapa con 234 ítems; cada estudiante responde 28–30 | pendiente | | por_verificar · origen: IA: resumen automático del texto completo |
| 2 | 25 % de los estudiantes asignados a la ruta lineal y 75 % a la adaptativa | pendiente | | por_verificar · origen: IA: resumen automático del texto completo |
| 3 | Correlaciones internacionales entre subescalas de proceso: 0,79–0,87 | pendiente | | por_verificar · origen: IA: resumen automático del texto completo |
| 4 | No es apropiado correlacionar subescalas de proceso con las de contenido ni con la escala total | pendiente | | por_verificar · origen: IA: resumen automático del texto completo |
| 5 | Colombia: 7,6 % de estudiantes excedió el tiempo límite | pendiente | | por_verificar · origen: IA: resumen automático del texto completo |
| 6 | Bienes nacionales de Colombia en HOMEPOS: televisor, nevera, consola (Anexo D); no están en la base pública | pendiente | | por_verificar · origen: IA: resumen automático del texto completo |
| 7 | Media de Colombia en matemáticas 382,70 (EE 3,03) | p. 301 (Annex Table 14.A.12; 303 del visor) | fila "Colombia 408.67 3.75 382.70 3.03 411.12 3.28" | verificado (Vanessa, 18/10/2026) · confirmado antes por Claude contra el texto completo (2026-10-16). Ojo: extraído con `pdftotext -layout` las filas salen corridas dos posiciones (382,70 queda en "Croatia"); en orden de flujo (`-raw`) la fila de Colombia es lectura 408,67, matemáticas 382,70, ciencias 411,12, y Australia da matemáticas 487,08. Coincide con [[Literatura/burns2026intest]] (tabla 2, p. 9) |
| 9 | Anexo A (Excel `5nw02t.xlsx`, hoja *Mathematics-CBA*): clasifica 234 ítems de matemáticas por proceso, contenido, contexto y formato, con parámetros internacionales; 233 coinciden con los ítems de Colombia (emplear 75, interpretar 57, razonar 53, formular 48); el ítem 234, `CMA112Q02`, aparece como *(Dropped)*, de razonar y sin parámetros | anexo A (Excel) | | por_verificar · conteo de Claude 2026-10-04; el ítem retirado se encontró el 2026-10-05; copia en `Proyecto_PISA/documentacion/` |
| 8 | Sufijos de variables cognitivas: S calificada, C codificada, R respuesta, TT tiempo total, F primera acción, A acciones, V visitas | pendiente | | por_verificar · origen: IA: resumen automático del texto completo |
| 10 | Faltante del sistema (blanco) = no se le presentó la pregunta por diseño, terminó antes o hubo pérdida de datos (usado en D-13) | p. 264 ("Categorising missing data") | "not presented the question according to the survey design or ended the questionnaire early" | verificado (Vanessa, 18/10/2026) · confirmado antes por Claude contra el texto completo (2026-10-16); señalado antes por Mateo |
| 11 | En los datos cognitivos, *Not Applicable* = ítem eliminado en la calibración y no usado en el escalamiento (D-13) | p. 265 | "dropped/deleted during item calibration and not used during scaling" | verificado (Vanessa, 18/10/2026) · confirmado antes por Claude contra el texto completo (2026-10-16); señalado antes por Mateo |
| 12 | *Not Reached* = el estudiante probablemente no vio la pregunta y se trata así (D-13) | p. 265 | "unlikely to have seen the question and the response should be treated as such" | verificado (Vanessa, 18/10/2026) · confirmado antes por Claude contra el texto completo (2026-10-16); señalado antes por Mateo |
| 13 | En el análisis de ítems, *not reached* = no respondió el ítem ni ninguno posterior de la sesión MSAT; *omitted* = no respondió el ítem pero sí alguno posterior (D-13) | p. 211 (cap. 11 "Scaling PISA data", "Item analysis") | "did not answer the item or any subsequent item in the cluster" | verificado (Vanessa, 18/10/2026) · confirmado antes por Claude contra el texto completo (2026-10-16) |
| 14 | En las estadísticas de ítems y el escalamiento, los no alcanzados se excluyen y los omitidos cuentan como incorrectos: es el criterio OCDE de D-05 (a) | p. 211 (cap. 11 "Scaling PISA data", "Item analysis") | "the omitted and off-task responses were treated as incorrect" | verificado (Vanessa, 18/10/2026) · confirmado antes por Claude contra el texto completo (2026-10-16) |
| 15 | Varianza muestral BRR (Fay): 0,05 × suma sobre las 80 réplicas de (θ_t − θ)², con θ_t estimado con el t-ésimo peso replicado (D-15) | p. 198 (Formula 10.9) | "The variance estimator for the BRR method is then calculated using the following formula" | verificado (Vanessa, 18/10/2026) · confirmado antes por Claude contra el texto completo (2026-10-16); los símbolos de la fórmula no se extraen bien: mirarla en el PDF |
| 16 | Varianza de una estadística con PV = varianza muestral BRR + varianza de imputación (D-15) | p. 280 | "the sum of the sampling and the imputation variances, or VarBRR + MVar" | verificado (Vanessa, 18/10/2026) · confirmado antes por Claude contra el texto completo (2026-10-16); la fórmula de Rubin con (1 + 1/M) está en la p. 226, con símbolos ilegibles en el texto extraído |
| 17 | Las escalas TRI de los cuestionarios usan 2PL para ítems de dos categorías y GPCM para los politómicos; la calibración pondera con el *senate weight*, una transformación lineal de `W_FSTUWT` que suma 5.000 por país (D-16) | p. 380 (cap. 19) | "Each country/economy was included in the analysis using a senate weight (SENWT)" | verificado (Vanessa, 18/10/2026) · confirmado antes por Claude contra el texto completo (2026-10-16) |
| 18 | Si un estudiante tiene menos de tres respuestas válidas en una escala, no se le calcula puntaje (D-16) | p. 384 | "if an individual had fewer than three valid responses for a scale" | verificado (Vanessa, 18/10/2026) · confirmado antes por Claude contra el texto completo (2026-10-16) |
| 19 | `HISCED` es el nivel ISCED más alto de los dos padres, con ST005–ST008 (incluye calificaciones postsecundarias), de 1 = menos que ISCED 1 a 10 = ISCED 8; `PAREDINT` se deriva de `HISCED` (D-16) | pp. 386–387 | "The index is equal to the highest ISCED level of either parent" | verificado (Vanessa, 18/10/2026) · confirmado antes por Claude contra el texto completo (2026-10-16) |
| 20 | HOMEPOS incluye ST250, ST251, ST253, ST254, ST255 y ST256 (31 ítems, 4 nacionales); algunas categorías se agruparon antes de escalar (tabla 19.A.17, que no viene en el PDF) | pp. 391–392 | "for some items, the response categories were collapsed to align" | verificado (Vanessa, 18/10/2026) · confirmado antes por Claude contra el texto completo (2026-10-16) |
| 21 | En la codificación, el primer dígito del código asignado indica el crédito (completo, parcial o ninguno) | p. 313 (315 del visor) | "the first digit of assigned codes, denoting full, partial, and no credit" | por_verificar · origen: IA (Claude, 2026-10-18; usada en D-27) |

Páginas 7 y 10–20: numeración impresa, arriba de cada página (corregido el 2026-10-16: Claude la había leído como pie de página; lo detectó Mateo). Copia local en
`Proyecto_PISA/documentacion/PISA2022_TechnicalReport.pdf` (fuera de Git), descargada el 2026-10-16 del enlace de
`doi_url`. En el visor de PDF hay que sumar 2: la impresa 264 es la 266 del visor; la 211, la 213.

## Qué NO dice (para no citarlo mal)
No evalúa invarianza del NSE dentro de un país (solo entre países e idiomas).

## Dónde se usa
Diseño de F1–F5; validación G1
