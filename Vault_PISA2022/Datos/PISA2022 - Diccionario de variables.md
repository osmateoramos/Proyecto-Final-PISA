---
tipo: dato
estado: por_verificar
script: Proyecto_PISA/datos/diccionario_pisa2022.R
salida: Proyecto_PISA/salidas/diccionario_pisa2022.csv
fecha_calculo: 2026-10-04
verificado_por:
fecha_verificacion:
---

# Diccionario de variables PISA 2022 usadas en el proyecto (Colombia)

Volver a [[00 Inicio]] · Objetivos en [[06 Objetivos PISA 2022]]

Etiquetas tomadas de los archivos oficiales de la OCDE (`.SAV`). `% NA` = faltantes en los 7.804 estudiantes
(o 262 colegios) de Colombia. Versión inicial: se completa en el paso 1.4 del plan.

## Identificación y diseño

*Uso:* Unir archivos; pesos (W_FSTURWT1 representa las 80 réplicas) · Archivo: `STU`

| Variable | Etiqueta oficial (OCDE) | % NA Colombia |
|---|---|---|
| `CNT` | Country code 3-character | 0 |
| `CNTSCHID` | Intl. School ID | 0 |
| `CNTSTUID` | Intl. Student ID | 0 |
| `STRATUM` | Stratum ID 5-character (cnt + original stratum ID) | 0 |
| `W_FSTUWT` | FINAL TRIMMED NONRESPONSE ADJUSTED STUDENT WEIGHT | 0 |
| `W_FSTURWT1` | FINAL TRIMMED NONRESPONSE ADJUSTED STUDENT REPLICATE BRR-FAY WEIGHTS 1 | 0 |

## Grupos

*Uso:* O2 (sexo) y covariables de O4 · Archivo: `STU`

| Variable | Etiqueta oficial (OCDE) | % NA Colombia |
|---|---|---|
| `ST004D01T` | Student (Standardized) Gender | 0,0 |
| `GRADE` | Grade compared to modal grade in country | 0,0 |
| `IMMIG` | Index on immigrant background (OECD definition) | 8,4 |

## Colegio

*Uso:* O2: zona y sector · Archivo: `SCH`

| Variable | Etiqueta oficial (OCDE) | % NA Colombia |
|---|---|---|
| `SC001Q01TA` | Which of the following definitions best describes the community in which your school is located? | 4,2 |
| `SCHLTYPE` | School type | 1,1 |

## NSE: índices oficiales

*Uso:* Contraste y validación de O1 · Archivo: `STU`

| Variable | Etiqueta oficial (OCDE) | % NA Colombia |
|---|---|---|
| `ESCS` | Index of economic, social and cultural status | 4,4 |
| `HISEI` | Highest parental occupational status (ISEI) based on 4-digit human coded ISCO | 7,8 |
| `PAREDINT` | Index highest parental education (international years of schooling scale) | 4,6 |
| `HISCED` | Highest level of education of parents (ISCED) | 4,6 |
| `HOMEPOS` | Home possessions (WLE) | 4,2 |

## NSE: educación de los padres

*Uso:* O1: capital cultural · Archivo: `STU`

| Variable | Etiqueta oficial (OCDE) | % NA Colombia |
|---|---|---|
| `ST005Q01JA` | What is the [highest level of schooling] completed by your mother? | 5,3 |
| `ST007Q01JA` | What is the [highest level of schooling] completed by your father? | 7,9 |

## NSE: posesiones del hogar (HOMEPOS)

*Uso:* O1: indicadores del NSE latente · Archivo: `STU`

| Variable | Etiqueta oficial (OCDE) | % NA Colombia |
|---|---|---|
| `ST250Q01JA` | Which of the following are in your [home]: A room of your own |  5,2 |
| `ST250Q02JA` | Which of the following are in your [home]: A computer (laptop, desktop, or tablet) that you can use for school work |  5,3 |
| `ST250Q03JA` | Which of the following are in your [home]: Educational Software or Apps |  5,6 |
| `ST250Q04JA` | Which of the following are in your [home]: Your own [cell phone] with Internet access (e.g. smartphone) |  5,1 |
| `ST250Q05JA` | Which of the following are in your [home]: Internet access (e.g. Wi-fi) (excluding through smartphones) |  5,5 |
| `ST251Q01JA` | How many of these items are there at your [home]: Cars, vans, or trucks |  6,1 |
| `ST251Q02JA` | How many of these items are there at your [home]: Mopeds or motorcycles |  6,8 |
| `ST251Q03JA` | How many of these items are there at your [home]: Rooms with a bath or shower |  5,9 |
| `ST251Q04JA` | How many of these items are there at your [home]: Rooms with a [flush toilet] |  6,0 |
| `ST251Q06JA` | How many of these items are there at your [home]: Musical instruments (e.g. guitar, piano, [country-specific example]) |  5,9 |
| `ST251Q07JA` | How many of these items are there at your [home]: Works of art (e.g. paintings, sculptures, [country-specific example]) |  6,0 |
| `ST253Q01JA` | How many [digital devices] with screens are there in your [home]? |  4,3 |
| `ST254Q01JA` | How many of the following [digital devices] are in your [home]: Televisions |  8,1 |
| `ST254Q02JA` | How many of the following [digital devices] are in your [home]: Desktop computers | 10,6 |
| `ST254Q03JA` | How many of the following [digital devices] are in your [home]: Laptop computers or notebooks |  9,4 |
| `ST254Q04JA` | How many of the following [digital devices] are in your [home]: Tablets (e.g. [iPad®], [BlackBerry® Playbook™]) |  9,2 |
| `ST254Q05JA` | How many of the following [digital devices] are in your [home]: E-book readers (e.g. [Kindle™], [Kobo], [Bookeen]) |  9,7 |
| `ST254Q06JA` | How many of the following [digital devices] are in your [home]: [Cell phones] with Internet access (i.e. smartphones) |  8,1 |
| `ST255Q01JA` | How many books are there in your [home]? |  4,7 |
| `ST256Q01JA` | How many of these books at [home]: Religious books (e.g. [Bible], [Example 2]) | 21,2 |
| `ST256Q02JA` | How many of these books at [home]: Classical literature (e.g. [Shakespeare], [Example 2]) | 21,8 |
| `ST256Q03JA` | How many of these books at [home]: Contemporary literature | 22,3 |
| `ST256Q06JA` | How many of these books at [home]: Books on science | 21,7 |
| `ST256Q07JA` | How many of these books at [home]: Books on art, music, or design | 21,9 |
| `ST256Q08JA` | How many of these books at [home]: [Technical reference books] | 22,6 |
| `ST256Q09JA` | How many of these books at [home]: Dictionaries | 20,8 |
| `ST256Q10JA` | How many of these books at [home]: Books to help with your school work | 21,2 |

## Competencias: valores plausibles OCDE

*Uso:* O3 validación; O4 robustez (PV1 representa PV1–PV10) · Archivo: `STU`

| Variable | Etiqueta oficial (OCDE) | % NA Colombia |
|---|---|---|
| `PV1MATH` | Plausible Value 1 in Mathematics | 0 |
| `PV1MPFS` | Plausible Value 1 in Process Subscale of Mathematics - Formulating Situations Mathematically | 0 |
| `PV1MPEM` | Plausible Value 1 in Process Subscale of Mathematics - Employing Mathematical Concepts, Facts, and Procedures | 0 |
| `PV1MPIN` | Plausible Value 1 in Process Subscale of Mathematics - Interpreting, Applying, and Evaluating Mathematical Outcomes | 0 |
| `PV1MPRE` | Plausible Value 1 in Process Subscale of Mathematics - Reasoning | 0 |

## Ítems de matemáticas: diseño adaptativo

*Uso:* O3: ruta adaptativa · Archivo: `COG`

| Variable | Etiqueta oficial (OCDE) | % NA Colombia |
|---|---|---|
| `MPATH` | Math Path Assignment: Adaptive or Linear | 0 |
| `MS1_LEV` | Math Adaptive Level Assignment: Stage1 | 0 |
| `MS2_LEV` | Math Adaptive Level Assignment: Stage2 | 0 |

## Ítems de matemáticas: ejemplo de un ítem

*Uso:* O3: respuesta calificada (S/C), tiempo (TT), primera acción (F), acciones (A); igual para los 234 ítems · Archivo: `COG`

| Variable | Etiqueta oficial (OCDE) | % NA Colombia |
|---|---|---|
| `CM033Q01S` | A View Room - Q01 (Scored Response) | 84,1 |
| `CM033Q01TT` | A View Room - Q01 (Total Timing) | 83,6 |
| `CM033Q01F` | A View Room - Q01 (Time to First Action) | 83,9 |
| `CM033Q01A` | A View Room - Q01 (Number of Actions) | 83,6 |

