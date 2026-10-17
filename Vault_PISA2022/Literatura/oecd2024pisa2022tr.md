---
tipo: fuente
clave_bib: oecd2024pisa2022tr
zotero-key: A5GFC6CZg6703955
clave_provisional: no
titulo: "PISA 2022 Technical Report"
autores: "OECD"
año: "2024 (por verificar: el PDF muestra © 2024 y © 2025)"
publicacion: "OECD Publishing"
doi_url: https://www.oecd.org/content/dam/oecd/en/publications/reports/2024/03/pisa-2022-technical-report_599753f0/01820d6d-en.pdf
bloque: "B. Medición del NSE / diseño"
estado: por_verificar
lectura: "IA: búsqueda en el texto extraído del PDF (545 págs.)"
pdf_en_zotero: no
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
| 7 | Media de Colombia en matemáticas 382,70 (EE 3,03) | p. 301 (Annex Table 14.A.12; 303 del visor) | fila "Colombia 408.67 3.75 382.70 3.03 411.12 3.28" | por_verificar · confirmado contra el texto completo (Claude, 2026-10-16). Ojo: extraído con `pdftotext -layout` las filas salen corridas dos posiciones (382,70 queda en "Croatia"); en orden de flujo (`-raw`) la fila de Colombia es lectura 408,67, matemáticas 382,70, ciencias 411,12, y Australia da matemáticas 487,08. Coincide con [[Literatura/burns2026intest]] (tabla 2, p. 9). Mirar la tabla en el PDF al firmar |
| 9 | Anexo A (Excel `5nw02t.xlsx`, hoja *Mathematics-CBA*): clasifica 234 ítems de matemáticas por proceso, contenido, contexto y formato, con parámetros internacionales; 233 coinciden con los ítems de Colombia (emplear 75, interpretar 57, razonar 53, formular 48); el ítem 234, `CMA112Q02`, aparece como *(Dropped)*, de razonar y sin parámetros | anexo A (Excel) | | por_verificar · conteo de Claude 2026-10-04; el ítem retirado se encontró el 2026-10-05; copia en `Proyecto_PISA/documentacion/` |
| 8 | Sufijos de variables cognitivas: S calificada, C codificada, R respuesta, TT tiempo total, F primera acción, A acciones, V visitas | pendiente | | por_verificar · origen: IA: resumen automático del texto completo |
| 10 | Faltante del sistema (blanco) = no se le presentó la pregunta por diseño, terminó antes o hubo pérdida de datos (usado en D-13) | p. 264 ("Categorising missing data") | "not presented the question according to the survey design or ended the questionnaire early" | por_verificar · confirmado contra el texto completo (Claude, 2026-10-16); señalado antes por Mateo; falta firma del equipo |
| 11 | En los datos cognitivos, *Not Applicable* = ítem eliminado en la calibración y no usado en el escalamiento (D-13) | p. 265 | "dropped/deleted during item calibration and not used during scaling" | por_verificar · confirmado contra el texto completo (Claude, 2026-10-16); señalado antes por Mateo; falta firma del equipo |
| 12 | *Not Reached* = el estudiante probablemente no vio la pregunta y se trata así (D-13) | p. 265 | "unlikely to have seen the question and the response should be treated as such" | por_verificar · confirmado contra el texto completo (Claude, 2026-10-16); señalado antes por Mateo; falta firma del equipo |
| 13 | En el análisis de ítems, *not reached* = no respondió el ítem ni ninguno posterior de la sesión MSAT; *omitted* = no respondió el ítem pero sí alguno posterior (D-13) | p. 211 (cap. 11 "Scaling PISA data", "Item analysis") | "did not answer the item or any subsequent item in the cluster" | por_verificar · confirmado contra el texto completo (Claude, 2026-10-16); falta firma del equipo |
| 14 | En las estadísticas de ítems y el escalamiento, los no alcanzados se excluyen y los omitidos cuentan como incorrectos: es el criterio OCDE de D-05 (a) | p. 211 (cap. 11 "Scaling PISA data", "Item analysis") | "the omitted and off-task responses were treated as incorrect" | por_verificar · confirmado contra el texto completo (Claude, 2026-10-16); falta firma del equipo |
| 15 | Varianza muestral BRR (Fay): 0,05 × suma sobre las 80 réplicas de (θ_t − θ)², con θ_t estimado con el t-ésimo peso replicado (D-15) | p. 198 (Formula 10.9) | "The variance estimator for the BRR method is then calculated using the following formula" | por_verificar · confirmado contra el texto completo (Claude, 2026-10-16); los símbolos de la fórmula no se extraen bien: mirarla en el PDF; falta firma del equipo |
| 16 | Varianza de una estadística con PV = varianza muestral BRR + varianza de imputación (D-15) | p. 280 | "the sum of the sampling and the imputation variances, or VarBRR + MVar" | por_verificar · confirmado contra el texto completo (Claude, 2026-10-16); la fórmula de Rubin con (1 + 1/M) está en la p. 226, con símbolos ilegibles en el texto extraído; falta firma del equipo |

Páginas 7 y 10–16: numeración impresa, arriba de cada página (corregido el 2026-10-16: Claude la había leído como pie de página; lo detectó Mateo). Copia local en
`Proyecto_PISA/documentacion/PISA2022_TechnicalReport.pdf` (fuera de Git), descargada el 2026-10-16 del enlace de
`doi_url`. En el visor de PDF hay que sumar 2: la impresa 264 es la 266 del visor; la 211, la 213.

## Qué NO dice (para no citarlo mal)
No evalúa invarianza del NSE dentro de un país (solo entre países e idiomas).

## Dónde se usa
Diseño de F1–F5; validación G1
