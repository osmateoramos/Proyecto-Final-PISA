---
tipo: fuente
clave_bib: oecd2023pisadb
zotero-key: 3L62M9REg6703955
clave_provisional: no
titulo: PISA 2022 Database
autores: OECD
año: "2023"
publicacion: OECD (base de datos pública)
doi_url: https://www.oecd.org/en/data/datasets/pisa-2022-database.html
bloque: Datos
metadatos: página de la base y servidor de archivos https://webfs.oecd.org/pisa2022/ (consultados 2026-09-29 y 2026-10-04)
estado: verificado
lectura: "IA: descarga y lectura de los archivos SPSS"
pdf_en_zotero: no
verificado_por: Mateo Ramos
fecha_verificacion: 2026-11-10
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

| #   | Afirmación (como la usamos)                                                                   | Página    | Cita textual (< 15 palabras) | Estado                                            |
| --- | --------------------------------------------------------------------------------------------- | --------- | ---------------------------- | ------------------------------------------------- |
| 1 | Colombia tiene 7.804 estudiantes en filas contiguas de los archivos de estudiantes y de ítems | no aplica (dato de la base; salidas/conteos_muestra.csv) |  | verificado · dato de `revision_pisa2022_col.R` · página escrita por Claude a pedido de Mateo (2026-11-10) |
| 2 | Los términos de la OCDE permiten descargar, copiar, adaptar y compartir los datos para cualquier fin, citando a la OCDE con la cita del conjunto de datos y la fecha de consulta | Terms & Conditions de la OCDE, sección 3 «Data», «Permitted Use» (https://www.oecd.org/en/about/terms-conditions.html) | «you can extract from, download, copy, adapt, print, distribute, share and embed Data» | por_verificar · origen: texto de la página oficial de la OCDE que Mateo copió en la sesión con Claude (2026-11-10); Claude escribió la afirmación y la ubicación |

## Dónde se usa
Toda la sección de datos del anteproyecto y los scripts de `Proyecto_PISA/datos/`.
