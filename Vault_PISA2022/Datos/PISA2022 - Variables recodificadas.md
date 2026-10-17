---
tipo: datos
generado_por: Proyecto_PISA/scripts/01b_etl_cuestionario.R
fecha: 2026-10-16
estado: por_verificar
---

# Variables recodificadas del cuestionario (Colombia, PISA 2022)

Volver a [[Datos/PISA2022 - Diccionario de variables]] · Reglas en [[03 Registro de decisiones]] (D-12) ·
Plan en [[07 Plan de desarrollo PISA 2022]] (pasos 1.3 y 1.4).

Nota generada por el script: no se edita a mano. % NA sobre los 7.804 estudiantes, antes y después de
recodificar. Antes: los faltantes de usuario (Valid Skip, Not Applicable, Invalid, No Response) ya cuentan como NA.
Después: además, el «No sé» de ST254 y ST256 pasa a NA.

| Original | Nueva | Regla | % NA antes | % NA después |
|---|---|---|---|---|
| `ST004D01T` | `sexo` | 1 = Mujer, 2 = Hombre | 0,0 | 0,0 |
| `SC001Q01TA` | `zona` | 1 = Rural (<3.000); 2 = Pueblo (3-15 mil); 3 a 6 = Urbana (>15 mil) | 3,4 | 3,4 |
| `SCHLTYPE` | `sector` | 3 = Público; 1 y 2 = Privado | 1,3 | 1,3 |
| `ST005Q01JA` | `educ_madre` | Se invierte: 5 - valor (0 = no completó ISCED 1 ... 4 = ISCED 3.4) | 5,3 | 5,3 |
| `ST007Q01JA` | `educ_padre` | Se invierte: 5 - valor (0 = no completó ISCED 1 ... 4 = ISCED 3.4) | 7,9 | 7,9 |
| `HISCED` | `HISCED` | Sin cambios (solo faltantes de usuario a NA) | 4,6 | 4,6 |
| `HISEI` | `HISEI` | Sin cambios (solo faltantes de usuario a NA) | 7,8 | 7,8 |
| `PAREDINT` | `PAREDINT` | Sin cambios (solo faltantes de usuario a NA) | 4,6 | 4,6 |
| `ESCS` | `ESCS` | Sin cambios (solo faltantes de usuario a NA) | 4,4 | 4,4 |
| `HOMEPOS` | `HOMEPOS` | Sin cambios (solo faltantes de usuario a NA) | 4,2 | 4,2 |
| `ST250Q01JA` | `ST250Q01JA` | Sí = 1, No = 0 | 5,2 | 5,2 |
| `ST250Q02JA` | `ST250Q02JA` | Sí = 1, No = 0 | 5,3 | 5,3 |
| `ST250Q03JA` | `ST250Q03JA` | Sí = 1, No = 0 | 5,6 | 5,6 |
| `ST250Q04JA` | `ST250Q04JA` | Sí = 1, No = 0 | 5,1 | 5,1 |
| `ST250Q05JA` | `ST250Q05JA` | Sí = 1, No = 0 | 5,5 | 5,5 |
| `ST251Q01JA` | `ST251Q01JA` | Categoría - 1 (0 = ninguno) | 6,1 | 6,1 |
| `ST251Q02JA` | `ST251Q02JA` | Categoría - 1 (0 = ninguno) | 6,8 | 6,8 |
| `ST251Q03JA` | `ST251Q03JA` | Categoría - 1 (0 = ninguno) | 5,9 | 5,9 |
| `ST251Q04JA` | `ST251Q04JA` | Categoría - 1 (0 = ninguno) | 6,0 | 6,0 |
| `ST251Q06JA` | `ST251Q06JA` | Categoría - 1 (0 = ninguno) | 5,9 | 5,9 |
| `ST251Q07JA` | `ST251Q07JA` | Categoría - 1 (0 = ninguno) | 6,0 | 6,0 |
| `ST253Q01JA` | `ST253Q01JA` | Categoría - 1 (0 = ninguno) | 4,3 | 4,3 |
| `ST255Q01JA` | `ST255Q01JA` | Categoría - 1 (0 = ninguno) | 4,7 | 4,7 |
| `ST254Q01JA` | `ST254Q01JA` | Categoría - 1 (0 = ninguno); «No sé» (5) a NA | 8,1 | 8,4 |
| `ST254Q02JA` | `ST254Q02JA` | Categoría - 1 (0 = ninguno); «No sé» (5) a NA | 10,6 | 10,8 |
| `ST254Q03JA` | `ST254Q03JA` | Categoría - 1 (0 = ninguno); «No sé» (5) a NA | 9,4 | 9,7 |
| `ST254Q04JA` | `ST254Q04JA` | Categoría - 1 (0 = ninguno); «No sé» (5) a NA | 9,2 | 9,5 |
| `ST254Q05JA` | `ST254Q05JA` | Categoría - 1 (0 = ninguno); «No sé» (5) a NA | 9,7 | 11,0 |
| `ST254Q06JA` | `ST254Q06JA` | Categoría - 1 (0 = ninguno); «No sé» (5) a NA | 8,1 | 8,6 |
| `ST256Q01JA` | `ST256Q01JA` | Categoría - 1 (0 = ninguno); «No sé» (5) a NA | 21,2 | 23,8 |
| `ST256Q02JA` | `ST256Q02JA` | Categoría - 1 (0 = ninguno); «No sé» (5) a NA | 21,8 | 25,8 |
| `ST256Q03JA` | `ST256Q03JA` | Categoría - 1 (0 = ninguno); «No sé» (5) a NA | 22,3 | 28,6 |
| `ST256Q06JA` | `ST256Q06JA` | Categoría - 1 (0 = ninguno); «No sé» (5) a NA | 21,7 | 25,2 |
| `ST256Q07JA` | `ST256Q07JA` | Categoría - 1 (0 = ninguno); «No sé» (5) a NA | 21,9 | 25,9 |
| `ST256Q08JA` | `ST256Q08JA` | Categoría - 1 (0 = ninguno); «No sé» (5) a NA | 22,6 | 27,3 |
| `ST256Q09JA` | `ST256Q09JA` | Categoría - 1 (0 = ninguno); «No sé» (5) a NA | 20,8 | 21,9 |
| `ST256Q10JA` | `ST256Q10JA` | Categoría - 1 (0 = ninguno); «No sé» (5) a NA | 21,2 | 24,3 |
