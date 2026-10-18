---
tipo: fuente
clave_bib: chen2024structural
zotero-key: 6F2ZERNJg6703955
clave_provisional: no
titulo: "Structural Equation Modeling Using R/SAS: A Step-by-Step Approach with Real Data Analysis"
autores: "Chen, Ding-Geng; Yung, Yiu-Fai"
año: "2024 (página de créditos: first edition published 2024; Crossref registra publicación en línea el 2023-07-12)"
publicacion: "Chapman and Hall/CRC"
doi_url: https://doi.org/10.1201/9781003365860
bloque: "M. Métodos y software"
metadatos: "Crossref y página de créditos del PDF (consultados 2026-10-05)"
estado: por_verificar
lectura: "IA: índice completo y secciones leídas (pp. 220–224, 246, 370–375)"
pdf_en_zotero: sí, solo una muestra de 54 páginas de la editorial (comprobado por Claude en Zotero, 2026-10-18)
verificado_por:
fecha_verificacion:
---

# Structural Equation Modeling Using R/SAS (Chen y Yung, 2024)

Volver a [[Literatura/Matriz estado del arte]] · Protocolo en [[11 Protocolo de verificación]] · Uso en [[14 Libros de TRI y SEM]]

PDF: `Proyecto_PISA/documentacion/` (no va a Git). **Página impresa = página del PDF − 21.**

## Qué hace
Manual práctico de SEM con R (`lavaan`) y SAS, con datos reales: análisis de rutas, AFC, mediación, datos no
normales, datos categóricos, análisis multigrupo (continuo y categórico), SEM completo, curvas de crecimiento,
SEM multinivel y tamaño de muestra.

## Afirmaciones que usamos en el proyecto

| # | Afirmación (como la usamos) | Página | Cita textual (< 15 palabras) | Estado |
|---|---|---|---|---|
| 1 | Invarianza con datos categóricos: primero se ajusta el modelo en cada grupo por separado, luego el configural | pp. 221–222 | — | por_verificar · origen: IA, texto completo de la sección (2026-10-05) |
| 2 | En análisis multigrupo con datos categóricos se prefiere la parametrización *theta* en `lavaan` | p. 221 | "for multi-group analysis, it is preferred to use theta parameterization" | por_verificar · origen: IA (2026-10-05) |
| 3 | Con la invarianza establecida, se comparan las medias latentes entre grupos | p. 246 | — | por_verificar · origen: IA (2026-10-05) |
| 4 | El capítulo 7 pasa del modelo configural directamente a la invarianza estricta ("ideal"); no prueba los pasos intermedios uno por uno | pp. 221–246 | — | por_verificar · origen: IA, búsqueda en el capítulo (2026-10-05) |
| 5 | SEM multinivel en `lavaan` (`level: within` / `level: between`, `cluster =`), con un NSE latente medido por ocupación y educación de los padres en cada nivel | pp. 370–375 | "the within social economic status (denoted by wses) is a latent variable" | por_verificar · origen: IA (2026-10-05) |

## Qué NO dice (para no citarlo mal)
No trata pesos muestrales, réplicas BRR ni valores plausibles (búsqueda en el texto extraído, sin resultados): para eso
siguen mandando el Technical Report de PISA y el manual de análisis de la OCDE. El ejemplo multinivel usa estimación ML
con indicadores continuos.

## Dónde se usa
Lecturas de F3, F4 y F6 del [[07 Plan de desarrollo PISA 2022]] y propuestas de [[14 Libros de TRI y SEM]].
