# Pendientes del primer corte

> [!note] Archivado: corresponde a la etapa con Saber 11. El proyecto actual está en [[07 Plan de desarrollo PISA 2022]] (decisión D-11).

Volver a [[00 Inicio]] · Revisión del 2026-09-24, verificado con `Etapa1_Saber11/Proyecto/scripts/01_etl.R` (bloque 1.6).

- [ ] **El objetivo 2 no está identificado** tal como está escrito (un factor específico con un solo indicador) → [[03 Registro de decisiones]] D-05
- [ ] **WLSMV y "estimación con información completa"** no se pueden combinar en `lavaan` → D-04
- [ ] **Los faltantes se calcularon sobre la base equivocada.** En la muestra analítica (495.807), tratando "No sabe" y "Sin Estrato" como NA: entre 1,4 % y 11,0 % por indicador y 73,5 % de casos completos. El documento dice 11,8–16,3 % y 63,2 %, calculados sobre el archivo completo.
- [ ] **Validación externa por sector:** el documento dice 56,15 / 51,03; la muestra analítica da 56,52 / 51,37 y el archivo completo 56,01 / 50,98. Hay que encontrar el filtro que se usó o corregir la cifra.
- [ ] **Anomalía de estrato:** persiste en estudiantes con colegio y menores de 20 años (estrato 6 = 48,67; su INSE, 57,1, queda por debajo del de estrato 4, 60,1). Hay que añadir la explicación por selección: el calendario B presenta en el 1er semestre.
- [ ] **Mediadores vs grupos:** naturaleza y zona se usan en los objetivos 3 y 4, y la zona parece un antecedente más que un mediador.
- [ ] **Anidamiento:** 11.918 sedes → errores estándar agrupados o SEM multinivel.
- [x] Unificar `URBANA`/`URBANO` → hecho en `01_etl.R` (variable `zona`).
- [ ] Decidir qué hacer con las jornadas NOCHE/SABATINA → D-06.
- [ ] `fami_personashogar` está en la tabla del objetivo 1 pero no en la auditoría → ahora entra como `hacinamiento`.
- [ ] La correlación matemáticas–lectura es 0,757 en la muestra analítica; el documento dice 0,760.
- [x] Los 2 `estu_consecutivo` repetidos son personas distintas → D-09.
- [x] Las cifras del documento sin script ahora se calculan en `01_etl.R` (bloque 1.6).
