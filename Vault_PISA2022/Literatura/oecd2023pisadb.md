---
tipo: fuente
clave_bib: oecd2023pisadb
zotero-key: 3L62M9REg6703955
clave_provisional: no
titulo: "PISA 2022 Database"
autores: "OECD"
año: "2023"
publicacion: "OECD (base de datos pública)"
doi_url: https://www.oecd.org/en/data/datasets/pisa-2022-database.html
bloque: "Datos"
metadatos: "página de la base y servidor de archivos https://webfs.oecd.org/pisa2022/ (consultados 2026-09-29 y 2026-10-04)"
estado: por_verificar
lectura: "IA: descarga y lectura de los archivos SPSS"
pdf_en_zotero: no
verificado_por:
fecha_verificacion:
---

# PISA 2022 Database (OCDE)

Volver a [[Literatura/Matriz estado del arte]] · Diccionario en [[Datos/PISA2022 - Diccionario de variables]]

## Qué es
Base pública de PISA 2022 con los archivos de estudiantes, ítems cognitivos, colegios y docentes, en SPSS y SAS.

## Archivos que usa el proyecto
| Archivo | Contenido | Descarga |
|---|---|---|
| `CY08MSP_STU_QQQ.SAV` | Cuestionario de estudiantes: índices, valores plausibles, pesos | `STU_QQQ_SPSS.zip` (≈ 682 MB) |
| `CY08MSP_STU_COG.SAV` | Ítems cognitivos: respuestas, tiempos, ruta adaptativa | `STU_COG_SPSS.zip` (≈ 481 MB) |
| `CY08MSP_SCH_QQQ.SAV` | Cuestionario de colegios | `SCH_QQQ_SPSS.zip` (≈ 6 MB) |

## Afirmaciones que usamos en el proyecto

| # | Afirmación (como la usamos) | Página | Cita textual (< 15 palabras) | Estado |
|---|---|---|---|---|
| 1 | Colombia tiene 7.804 estudiantes en filas contiguas de los archivos de estudiantes y de ítems | — | | por_verificar · dato de `revision_pisa2022_col.R` |
| 2 | Las condiciones de uso de la base se consultan en la página oficial | pendiente | | **sin_origen** hasta leer los términos de la OCDE |

## Dónde se usa
Toda la sección de datos del anteproyecto y los scripts de `Proyecto_PISA/datos/`.
