---
tipo: guia
estado: por_verificar
lectura: "borrador de Claude (2026-11-09; K5 actualizado el 2026-11-10) con las salidas de la F6-F7 (salidas/f7_robustez.csv y f7_sensibilidad_detalle.csv); las frases para el Ministerio las aprueba el equipo"
verificado_por:
fecha_verificacion:
---

# Hallazgos (paso 7.3, D-45 punto 5)

Volver a [[00 Inicio]] · Criterio en [[08 Rúbrica de desarrollo]] · Hipótesis en [[09 Hipótesis preregistradas]] ·
Novedad en [[Literatura/Búsqueda de novedad F7]]

> [!warning] Cómo leer esta nota
> - Cada candidato se clasifica con los 5 criterios de la rúbrica: (1) hipótesis preregistrada o exploratoria declarada;
>   (2) efecto relevante según el umbral fijado antes; (3) robusto según D-45 (≥ 75 % de las sensibilidades que le
>   aplican, mínimo 3); (4) no está en la matriz para Colombia; (5) se explica en una frase.
> - El criterio 4 es **provisional**: la búsqueda 7.2 cubrió las cuatro fuentes del plan (buscador web con SciELO y
>   Redalyc, **Scopus** y **Google Académico**, 2026-11-10) y ninguna encontró un antecedente para Colombia de K1, K2,
>   K4 ni K5. Pero hay estudios del mismo análisis en otros países o poblaciones, y 4 posibles antecedentes siguen sin
>   leerse ([[Literatura/Búsqueda de novedad F7]]).
> - **K2:** el antecedente más cercano es Duarte, Bos y Moreno (2010, BID; [[Literatura/duarte2010ensenan]], leído por
>   Claude en texto completo, por verificar). Con el SERCE de 2006 (primaria) probaron la misma interacción: **para
>   Colombia no fue significativa** en ninguna de las 4 pruebas (pág. 21), y en América Latina solo en matemáticas de
>   3.º, en la misma dirección que K2. K2 sigue siendo nuevo para Colombia con PISA y en secundaria, pero el informe
>   debe citarlo.
> - El diseño es transversal: «asociación», no «efecto» (plan 9.1). Las frases son **borradores** de Claude.

## Resumen

| Candidato | (1) | (2) | (3) Robustez | (4) Novedad | Clasificación (borrador) |
|---|---|---|---|---|---|
| **K1** El NSE económico se asocia más con *interpretar* que con *emplear*, y su asociación no es igual entre competencias | H5 **exploratoria** (D-32) | Cumple la regla de H5 (positiva y significativa en la muestra completa y en la mitad de confirmación); H5 no fijó un umbral de magnitud | 3 de 3 (cerca del límite con ESCS y sin la ruta lineal) | No se encontró antecedente para Colombia | **Hallazgo exploratorio**, que necesita confirmarse en otra muestra o ciclo |
| **K2** La pendiente del NSE es mayor en los colegios privados | H6 preregistrada | Cumple la regla de H6 (Holm p = 0,007); la pendiente es entre 12,3 y 20,3 puntos mayor por unidad de EAP según la competencia (D-42) | 4 de 4; coincide con los puntajes propios (D-44) | No se encontró antecedente que pruebe la interacción en Colombia con PISA. En primaria (SERCE 2006), Duarte et al. (2010) no la encontraron significativa para Colombia | **Hallazgo** (criterio 4 provisional) |
| **K3** El NSE económico se asocia con las 4 competencias | No es una hipótesis: es el punto de partida de O4 | 24,2 a 29,4 puntos por DE de la EAP (D-42) | 3 de 3 | Ya se sabe para matemáticas en total (OCDE; Icfes, 2024) | **Réplica** en Colombia, extendida a las 4 competencias |
| **K4** Tratar las omisiones rápidas como faltantes no reduce la brecha Q4 − Q1 | H4 preregistrada | **No**: reducción de 0,007 DE frente al umbral de 0,05 | 5 de 5 | No se encontró antecedente para Colombia | **Resultado nulo bien medido** (falla el criterio 2, es robusto) |
| **K5** DIF por NSE escaso (3 de 154 ítems) y no concentrado en interpretar y formular | H3 preregistrada | Primera parte sí (efectos B y C del ETS, el umbral de H3); segunda parte no | 4 de 4 (2 a 6 ítems con DIF según la variante: ESCS 6 de 155, sin ruta lineal 2 de 152, sin BH 8 de 154, D-38 3 de 154; nunca concentrado en interpretar y formular). `CMA135Q04S` tiene DIF en las cinco versiones | No se encontró DIF por NSE con ítems de PISA en Colombia | **Hallazgo parcial**: la primera parte de H3 se sostiene; el patrón por competencia que planteaba H3 no aparece (nulo en esa parte). Criterio 4 provisional |

## Frases para el Ministerio de Educación (borradores de Claude, criterio 5)

- **K1 (exploratorio):** «En Colombia, la ventaja de los estudiantes de hogares con más recursos es algo mayor cuando
  deben interpretar resultados matemáticos que cuando deben aplicar procedimientos.»
- **K2:** «En los colegios privados, la diferencia de desempeño en matemáticas entre estudiantes de hogares con más y
  con menos recursos es mayor que en los públicos.»
- **K3 (réplica):** «Los estudiantes de hogares con más recursos rinden más en las cuatro formas de usar las
  matemáticas que mide PISA, no solo en el puntaje total.»
- **K4 (nulo):** «Las respuestas dejadas en blanco muy rápido no explican la brecha socioeconómica en matemáticas: la
  brecha es real y no un efecto de desgano en la prueba.»
- **K5 (parcial):** «Muy pocas preguntas de matemáticas de PISA funcionan distinto para estudiantes de hogares con más
  o con menos recursos, y las que lo hacen no favorecen de forma sistemática a los de más recursos.» (En la versión
  base, 2 de los 3 ítems con DIF favorecen al cuartil bajo y 1 al alto: `salidas/mat_dif.csv`, columna `favorece`.)

## Lectura para política y riesgos de mal uso (criterio C7)

- **K2** no dice que los colegios privados «causen» desigualdad: puede reflejar cómo se reparten los estudiantes entre
  colegios (composición y selección), algo que este diseño no separa. Los antecedentes encontrados en la búsqueda
  apuntan a la composición de los colegios (por verificar).
- **K1 y K3** no deben leerse como que los estudiantes de NSE bajo «no pueden» interpretar: describen promedios
  condicionados, no capacidades individuales. Riesgo de estigmatización si se reportan sin esa salvedad.
- **K4** no autoriza a ignorar el desenganche: dice que no explica la brecha por NSE en esta muestra.
- **K5** no dice que la prueba sea «justa» en todo: un ítem con DIF no es necesariamente injusto, y la revisión de
  contenido de los ítems marcados (P4, D-21) sigue pendiente; `CMA135Q04S` aparece en todas las variantes (D-45).
  Tampoco descarta un sesgo común a todos los ítems: el DIF compara cada ítem con el resto de la prueba. Y el número de
  ítems con DIF depende de cómo se mida el NSE (3 con la EAP y 6 con ESCS): lo robusto es que son pocos, no cuáles son.

## Resultados que no fueron candidatos (se reportan igual)
- H1 aceptada (2 dimensiones del NSE, D-18); H2 rechazada, sin demostrar la invarianza (D-35); H7 y H8 rechazadas
  (D-27, D-41). No pasaron por las sensibilidades de la F7 (D-45) y así se declara.
- H6 por zona: sin resolver entre fuentes (D-44); con ESCS sale significativa (D-45). No es hallazgo.
