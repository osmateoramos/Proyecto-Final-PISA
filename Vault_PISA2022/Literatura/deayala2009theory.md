---
tipo: fuente
clave_bib: deayala2009theory
zotero-key: CAST3UL4g6703955
clave_provisional: no
titulo: "The Theory and Practice of Item Response Theory"
autores: "de Ayala, R. J."
año: "2009"
publicacion: "The Guilford Press (Methodology in the Social Sciences), ISBN 978-1-59385-869-8"
doi_url: "sin DOI"
bloque: "M. Métodos y software"
metadatos: "página de créditos del PDF (consultada 2026-10-05); Crossref solo tiene reseñas del libro"
estado: por_verificar
lectura: "IA: índice completo y secciones leídas (pp. 104–106, 131–133, 148–152, 291–292, 309–310, 324–327)"
pdf_en_zotero: no
verificado_por:
fecha_verificacion:
---

# The Theory and Practice of Item Response Theory (de Ayala, 2009)

Volver a [[Literatura/Matriz estado del arte]] · Protocolo en [[11 Protocolo de verificación]] · Uso en [[14 Libros de TRI y SEM]]

PDF: `Proyecto_PISA/documentacion/` (no va a Git). **Página impresa = página del PDF − 18.**

## Qué hace
Manual de TRI: modelos 1PL, 2PL y 3PL; modelos politómicos (PCM, RSM, GPCM, GRM, nominal); TRI multidimensional;
enlace de escalas; DIF; apéndice de pruebas adaptativas.

## Afirmaciones que usamos en el proyecto

| # | Afirmación (como la usamos) | Página | Cita textual (< 15 palabras) | Estado |
|---|---|---|---|---|
| 1 | Pauta orientativa para el 2PL con MMLE: al menos 500 personas y 20 o más ítems | p. 105 | "at least 500 persons and instruments of 20 or more items" | por_verificar · origen: IA, texto completo de la sección (2026-10-05) |
| 2 | Si se viola la independencia condicional, la información del instrumento se sobreestima | p. 131 | "the total instrument information is overestimated" | por_verificar · origen: IA (2026-10-05) |
| 3 | Ítems con estímulo común pueden tratarse como *testlet*; el índice Q3 de Yen detecta dependencia local | pp. 132–133 | "the Q3 index works reasonably well" | por_verificar · origen: IA (2026-10-05) |
| 4 | Lo no presentado por diseño (p. ej., pruebas adaptativas) se puede ignorar al estimar a la persona | p. 150 | "the missingness process may be ignored for purposes of person location estimation" | por_verificar · origen: IA (2026-10-05) |
| 5 | Los ítems no alcanzados pueden ignorarse al estimar a la persona (Lord, 1980) | p. 150 | "these not-reached items may be ignored for person location estimation" | por_verificar · origen: IA (2026-10-05) |
| 6 | Las omisiones no son ignorables; según De Ayala, Plake e Impara (2001), en ítems dicotómicos no deben tratarse como incorrectas ni ignorarse | p. 150 | "omits should not be treated as incorrect nor should they be ignored" | por_verificar · origen: IA (2026-10-05); el estudio de 2001 es cita secundaria |
| 7 | Alternativas para omisiones: valor fraccional 1/m, verosimilitud marginalizada, u omisión como categoría (modelo nominal); toda imputación da crédito parcial | p. 151 | — | por_verificar · origen: IA (2026-10-05) |
| 8 | Buena práctica: códigos distintos para no alcanzado, no presentado y omitido | p. 151 | — | por_verificar · origen: IA (2026-10-05) |
| 9 | El origen y la unidad de la métrica son arbitrarios (indeterminación); también en TRI multidimensional | pp. 106, 291–292 | — | por_verificar · origen: IA (2026-10-05) |
| 10 | Para poner dos calibraciones en la misma métrica se puede calibrar fijando parámetros ya estimados de otra forma | p. 310 | — | por_verificar · origen: IA (2026-10-05) |
| 11 | DIF uniforme y no uniforme; señalar DIF es necesario pero no suficiente para hablar de sesgo; depurar la variable de condicionamiento | pp. 324–327 | "a necessary but not sufficient condition for the item being considered to be biased" | por_verificar · origen: IA (2026-10-05) |

## Qué NO dice (para no citarlo mal)
No trata valores plausibles, pesos muestrales ni diseños de evaluaciones a gran escala como PISA (búsqueda en el texto
extraído, sin resultados). El modelo multidimensional del capítulo 10 es compensatorio y su ejemplo usa NOHARM, no `mirt`.

## Dónde se usa
Lecturas de F3, F4 y F5 del [[07 Plan de desarrollo PISA 2022]] y propuestas de [[14 Libros de TRI y SEM]].
