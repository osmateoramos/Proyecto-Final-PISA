---
tipo: hipotesis
estado: por_verificar
lectura: "redactado por Claude; falta revisión del equipo"
pendientes: "Fechar y congelar antes de modelar (paso 0.5)"
verificado_por:
fecha_verificacion:
---

# Hipótesis preregistradas

Volver a [[00 Inicio]] · Objetivos en [[06 Objetivos PISA 2022]] · Criterio de hallazgo en [[08 Rúbrica de desarrollo]]

> [!warning] Regla
> Estas hipótesis se **fechan y congelan antes de estimar cualquier modelo** (paso 0.5). Si después se cambian, se
> deja la versión original tachada y se explica el cambio. Lo que no esté aquí y aparezca en los datos se reporta
> como **exploratorio**.

**Fecha de congelamiento:** ____ (completar en F0) · **Commit Git:** ____

| ID | Objetivo | Hipótesis | Cómo se prueba | Regla de decisión (fijada de antemano) | Estado |
|---|---|---|---|---|---|
| **H1** | O1 | El NSE de los estudiantes colombianos se representa mejor con **dos dimensiones** (económica y cultural) que con una | AFC 1 vs 2 factores en la mitad de confirmación | Se acepta si el modelo de 2 factores mejora CFI en ≥ 0,01 y la correlación entre factores es < 0,90 | pendiente |
| **H2** | O2 | **No hay invarianza escalar entre zona rural y urbana**: al menos un bien del hogar funciona distinto | Secuencia de invarianza + DIF de posesiones | Se acepta si el paso escalar empeora CFI en > 0,01 o RMSEA en > 0,015, y al menos un ítem tiene DIF con efecto no despreciable | pendiente |
| **H3** | O3 | Existen ítems de matemáticas con **DIF por NSE** no despreciable, concentrados en las competencias **interpretar y formular** | DIF cuartil bajo vs alto + tabla por proceso | Se acepta la primera parte si ≥ 1 ítem tiene DIF significativo (Benjamini-Hochberg 5 %) con efecto no despreciable; la segunda si la proporción de DIF en interpretar + formular es mayor que en emplear (prueba de independencia, α = 0,05) | pendiente |
| **H4** | O3 | Tratar las **omisiones rápidas** como faltantes (en vez de incorrectas) **reduce la brecha** entre el cuartil alto y el bajo de NSE | Recalificación (D-14) y comparación de brechas | Se acepta si la brecha baja en ≥ 0,05 DE y la reducción es significativa | pendiente |
| **H5** | O4 | El efecto del NSE es **mayor en interpretar que en emplear** | Prueba de igualdad de efectos en el SEM (puntajes propios y PV OCDE) | Se acepta si la diferencia es positiva y significativa (α = 0,05) en el modelo completo y en la mitad de confirmación | pendiente |
| **H6** | O4 | El efecto del NSE **difiere entre sectores o zonas** | Modelo multigrupo (si F4 lo permite) | Se acepta si liberar el efecto entre grupos mejora el ajuste (prueba de diferencia, α = 0,05) | pendiente |
| **H7** | O3 | Los **puntajes propios por competencia** son válidos: correlacionan con los valores plausibles de la OCDE de la misma competencia | Correlación ponderada puntaje propio – PV OCDE, por competencia | Se acepta si la correlación es ≥ 0,80 en las cuatro competencias y mayor con su propia competencia que con las otras | pendiente |
| **H8** | O3 | El desempeño matemático de los estudiantes colombianos es **multidimensional**: un modelo de 4 competencias ajusta mejor que uno unidimensional | MIRT confirmatorio de 4 dimensiones vs unidimensional | Se acepta si el modelo de 4 dimensiones tiene menor BIC y ninguna correlación entre competencias es > 0,95 | pendiente |

> [!note] Sobre H5
> H5 es **exploratoria en origen**: la diferencia (3,9 puntos, z = 2,61) ya se vio en la revisión del 29/09 sobre
> toda la muestra. Por eso solo cuenta como confirmada si se mantiene en el modelo completo **y** en la mitad de
> confirmación. Así debe declararse en el informe.

> [!note] H7 y H8
> Agregadas el 2026-10-04 al definir que el proyecto califica por competencias (D-16), **antes** de estimar cualquier
> modelo de TRI. La fecha de congelamiento de todas las hipótesis sigue pendiente (paso 0.5).
