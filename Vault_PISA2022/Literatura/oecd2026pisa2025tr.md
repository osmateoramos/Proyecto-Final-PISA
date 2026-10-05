---
tipo: fuente
clave_bib: oecd2026pisa2025tr
clave_provisional: sí (confirmar al importar a Zotero)
titulo: "PISA 2025 Technical Report (versión borrador)"
autores: "OECD"
año: "2026"
publicacion: "OECD (borrador; archivos fechados 14/09/2026)"
doi_url: "copia local: Proyecto_PISA/documentacion/PISA 2025 Technical Report.zip"
bloque: "Diseño / clasificación de ítems"
metadatos: "portada de los PDF del zip (Draft version, © OECD 2026)"
estado: por_verificar
lectura: "IA: lectura del Excel del anexo A y búsqueda en el texto extraído de los PDF"
pdf_en_zotero: no
verificado_por:
fecha_verificacion:
---

# PISA 2025 Technical Report (borrador) — anexo A, clasificación de ítems

Volver a [[Literatura/Matriz estado del arte]] · Protocolo en [[11 Protocolo de verificación]]

## Qué hace
Documenta el ciclo PISA 2025. Su anexo A (Excel `AnnexA-PISA-2025-Technical Report-Tables_14092026.xlsx`) clasifica
cada ítem por dominio. La **tabla A.3 (Mathematics – Computer-based)** trae para cada ítem: formato, contenido,
contexto, **proceso (competencia)**, origen y parámetros internacionales (pendiente y dificultad).

## Datos y método
- Ítems de matemáticas por computador de 2025 = ítems de tendencia de 2022 (matemáticas es dominio menor en 2025).
- Técnica: clasificación del marco de evaluación + calibración internacional.

## Afirmaciones que usamos en el proyecto

| # | Afirmación (como la usamos) | Página | Cita textual (< 15 palabras) | Estado |
|---|---|---|---|---|
| 1 | La tabla A.3 clasifica 177 ítems de matemáticas por computador según proceso: emplear 47, razonar 45, formular 43, interpretar 42 | tabla A.3 (Excel) | | por_verificar · dato contado con `cobertura.py` (Claude, 2026-10-04) |
| 2 | Los 177 ítems de la tabla A.3 están entre los 234 ítems calificados de Colombia en PISA 2022; 57 no aparecen | tabla A.3 + `COL_matematicas_cog.rds` | | por_verificar · cruce hecho por Claude el 2026-10-04 |
| 3 | En 2025 matemáticas es dominio menor; las subescalas se reportan solo para ciencias y LDW | cap. 25 (Data products) | | por_verificar |

## Qué NO dice (para no citarlo mal)
No clasifica los 57 ítems de 2022 que no se usaron en 2025 (esos están en el anexo A del Technical Report 2022,
`https://stat.link/5nw02t`).

## Dónde se usa
Solo como contraste: la clasificación oficial que usa el proyecto es la del anexo A 2022
([[Literatura/oecd2024pisa2022tr]]); en los 177 ítems comunes no hay ninguna diferencia de competencia.
