---
tipo: hipotesis
estado: por_verificar
lectura: "redactado por Claude; falta revisión del equipo"
pendientes: "Ninguno del paso 0.5: congeladas el 2026-10-12 (commit f53054d)"
verificado_por:
fecha_verificacion:
---

# Hipótesis preregistradas

Volver a [[00 Inicio]] · Objetivos en [[06 Objetivos PISA 2022]] · Criterio de hallazgo en [[08 Rúbrica de desarrollo]]

> [!warning] Regla
> Estas hipótesis se **fechan y congelan antes de estimar cualquier modelo** (paso 0.5). Si después se cambian, se
> deja la versión original tachada y se explica el cambio. Lo que no esté aquí y aparezca en los datos se reporta
> como **exploratorio**.

**Fecha de congelamiento:** 2026-10-12 · **Commit Git:** `f53054d` (Vanessa, 2026-10-12; anotado el 2026-10-16)

> [!note] Sobre el atraso frente al plan
> El plan original (`07 Plan de desarrollo PISA 2022`) programaba este paso en la semana 1 (5–11 oct). Se cierra
> en la semana 2, el 2026-10-12, antes de que F1 (ETL) haya arrancado — es decir, antes de estimar cualquier
> modelo, que es la condición que importa. El atraso queda anotado aquí, sin disimularlo.

| ID | Objetivo | Hipótesis | Cómo se prueba | Regla de decisión (fijada de antemano) | Estado |
|---|---|---|---|---|---|
| **H1** | O1 | El NSE de los estudiantes colombianos se representa mejor con **dos dimensiones** (económica y cultural) que con una | AFC 1 vs 2 factores en la mitad de confirmación | Se acepta si el modelo de 2 factores mejora CFI en ≥ 0,01 y la correlación entre factores es < 0,90 | **aceptada** (2026-10-18): CFI +0,107 *scaled* y +0,218 *robust*; r = 0,559 (`salidas/nse_h1_afc.csv`, D-18) |
| **H2** | O2 | **No hay invarianza escalar entre zona rural y urbana**: al menos un bien del hogar funciona distinto | Secuencia de invarianza + DIF de posesiones | Se acepta si el paso escalar empeora CFI en > 0,01 o RMSEA en > 0,015, y al menos un ítem tiene DIF con efecto no despreciable | **rechazada** (2026-10-18): el paso escalar rural–urbana cambia el CFI −0,003 y el RMSEA +0,001, y ningún ítem tiene DIF no despreciable (`salidas/inv_h2.csv`, D-26) |
| **H3** | O3 | Existen ítems de matemáticas con **DIF por NSE** no despreciable, concentrados en las competencias **interpretar y formular** | DIF cuartil bajo vs alto + tabla por proceso | Se acepta la primera parte si ≥ 1 ítem tiene DIF significativo (Benjamini-Hochberg 5 %) con efecto no despreciable; la segunda si la proporción de DIF en interpretar + formular es mayor que en emplear (prueba de independencia, α = 0,05) | **aceptada solo la primera parte** (2026-11-09): 3 de 154 ítems con DIF, los tres en emplear; la segunda se rechaza (interpretar + formular 0 de 66, Fisher p = 1) (`salidas/mat_h3.csv`, D-40) |
| **H4** | O3 | Tratar las **omisiones rápidas** como faltantes (en vez de incorrectas) **reduce la brecha** entre el cuartil alto y el bajo de NSE | Recalificación (D-05) y comparación de brechas | Se acepta si la brecha baja en ≥ 0,05 DE y la reducción es significativa | **rechazada** (2026-11-09): la brecha baja solo 0,007 DE en las cuatro competencias, sin significancia (Holm p = 0,237) (`salidas/mat_h4_brechas.csv`, D-41) |
| **H5** | O4 | El efecto del NSE es **mayor en interpretar que en emplear** | Prueba de igualdad de efectos en el SEM (puntajes propios y PV OCDE) | Se acepta si la diferencia es positiva y significativa (α = 0,05) en el modelo completo y en la mitad de confirmación | pendiente |
| **H6** | O4 | El efecto del NSE **difiere entre sectores o zonas** | Modelo multigrupo (si F4 lo permite) | Se acepta si liberar el efecto entre grupos mejora el ajuste (prueba de diferencia, α = 0,05) | pendiente |
| **H7** | O3 | Los **puntajes propios por competencia** son válidos: correlacionan con los valores plausibles de la OCDE de la misma competencia | Correlación ponderada puntaje propio – PV OCDE, por competencia | Se acepta si la correlación es ≥ 0,80 en las cuatro competencias y mayor con su propia competencia que con las otras | **rechazada** (2026-11-09): correlaciones de 0,653 a 0,752, y en formular y razonar la mayor es con emplear de la OCDE (`salidas/mat_h7.csv`, D-41) |
| **H8** | O3 | El desempeño matemático de los estudiantes colombianos es **multidimensional**: un modelo de 4 competencias ajusta mejor que uno unidimensional | MIRT confirmatorio de 4 dimensiones vs unidimensional | Se acepta si el modelo de 4 dimensiones tiene menor BIC y ninguna correlación entre competencias es > 0,95 | **rechazada** (2026-10-20): BIC 204.296,1 con 4 competencias frente a 204.268,8 con 1, y dos correlaciones > 0,95 (emplear–razonar 0,976; emplear–interpretar 0,951) (`salidas/mat_ajuste.csv`, D-27) |

> [!note] Sobre H5
> H5 es **exploratoria en origen**: la diferencia (3,9 puntos, z = 2,61) ya se vio en la revisión del 29/09 sobre
> toda la muestra. Por eso solo cuenta como confirmada si se mantiene en el modelo completo **y** en la mitad de
> confirmación. Así debe declararse en el informe.

> [!note] H7 y H8
> Agregadas el 2026-10-04 al definir que el proyecto califica por competencias (D-07), **antes** de estimar cualquier
> modelo de TRI. ~~La fecha de congelamiento de todas las hipótesis sigue pendiente (paso 0.5).~~
> *Actualización 2026-10-16:* congeladas el 2026-10-12 (commit `f53054d`). La nota tachada era anterior al
> congelamiento; no cambia ninguna hipótesis.

> [!warning] Desviación del preregistro (2026-11-08, D-32)
> La tabla **no cambia**. Después de rechazar H8 y de que V1 fallara, Vanessa decidió (D-32) que **H5 y H6 se prueban
> con los valores plausibles de proceso de la OCDE como análisis principal** y los puntajes propios quedan como
> robustez, si el 5.4 se valida (D-33). La tabla decía lo contrario para O4. Las reglas de decisión no cambian.
> - H4 y H7 dependen de los puntajes propios: si el 5.4 no se valida antes del 2026-11-12 (D-33), se reportan como
>   **no evaluables**. *Actualización 2026-11-09:* el 5.4 se validó (D-39) y las dos se evaluaron con su regla; las dos
>   se rechazan (D-41). En H7, el umbral de 0,80 sin corregir por atenuación era exigente frente a confiabilidades de
>   0,76–0,82; cualquier corrección sería exploratoria y posterior a los resultados.
> - H5 se declara **exploratoria** (Vanessa, 2026-11-08): la mitad de confirmación forma parte de la muestra del
>   2026-09-29 en la que se originó. Se reporta con su regla, pero no cuenta como confirmación.
> - El DIF de H3 se calibra con el modelo conjunto de 1 dimensión, no por competencia (D-36). La regla de H3 no cambia.
> - **Resultados de la F6 (2026-11-08, D-42, VP de la OCDE):** H5 cumple su regla (interpretar − emplear = 5,57 puntos, p = 0,001; en la mitad de confirmación 6,33, p < 0,001), pero es exploratoria. **H6 se acepta** por sector (Holm p = 0,007); por zona no (p = 0,082). Salidas: `salidas/sem_h5.csv` y `sem_h6.csv`.
>   *Robustez con los puntajes propios (2026-11-09, D-44):* H5 y H6 por sector se repiten; H6 por zona sale significativa
>   con los propios (Holm p < 10⁻¹³) y no con los de la OCDE, así que queda sin resolver entre fuentes. Las decisiones
>   no cambian (D-32). Salida: `salidas/sem_comparacion_fuentes.csv`.
> - H2 se rechaza por su regla. Eso **no** demuestra la invarianza: la prueba χ² la rechaza en 10 de 12 pasos y el
>   ajuste de partida es pobre (D-35).

## Anexo: definiciones operativas (2026-10-18, D-22)

> [!note] Qué es este anexo
> La tabla de arriba **no cambia**. Algunos términos quedaron sin definir al congelarla, y este anexo los define. Se
> escribió el 2026-10-18, **después del congelamiento pero antes de estimar cualquier modelo de la F4 a la F6**, y así
> debe declararse en el informe. El detalle y las fuentes están en D-22 de [[03 Registro de decisiones]].

| Término | Definición |
|---|---|
| «Efecto no despreciable» (H2, H3), ítems dicotómicos | Categoría B o C del ETS: prueba MH significativa y \|ΔMH\| > 1 (Calderón et al., 2026, p. 8; Çelik y Kaşık, 2025, p. 643) |
| «Efecto no despreciable», ítems ordinales o de crédito parcial | ΔR² ≥ 0,035 (Jodoin y Gierl, 2001, citados por Kucam y Gülleroğlu, 2023, p. 130) |
| H3, ítem con DIF | Prueba TRI significativa con Benjamini-Hochberg al 5 % **y** efecto no despreciable |
| H4, brecha y reducción | Brecha Q4 − Q1 en DE ponderadas del puntaje con la calificación (a); reducción = brecha (a) − brecha (b) |
| H4, «significativa» | IC 95 % bilateral de la reducción que excluye 0 (80 réplicas BRR y 10 PV, mismos estudiantes). Queda por decidir antes de la F5 si exige las 4 competencias |
| H5 y H6 con un NSE de 2 dimensiones | Se deciden con el factor económico; el de libros es secundario y exploratorio |
| H7, correlación | Promedio de las 10 correlaciones ponderadas PV propio *m* – PV OCDE *m*, por competencia; sin promediar PV ni corregir por atenuación |
