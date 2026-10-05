# Mapa teoría → proyecto

> [!note] Archivado: corresponde a la etapa con Saber 11. El proyecto actual está en [[07 Plan de desarrollo PISA 2022]] (decisión D-11).

Volver a [[00 Inicio]] · Guía en [[01 Plan paso a paso]]

Qué concepto de clase se usa en qué paso. Antes de abrir una fase, marquen como vistos
en clase los conceptos que pide. Una nota por concepto en `Conceptos/` (opcional) ayuda
a preparar la sustentación.

## Teoría de Respuesta al Ítem

| Concepto | Qué hay que saber explicar | Dónde se usa |
|---|---|---|
| Unidimensionalidad | TRI supone que todos los ítems de una escala miden un solo rasgo | Fase 2.6, 3.1 |
| Tipos de ítem | dicotómico / ordinal / nominal → cada uno pide un modelo distinto | [[02 Clasificación de ítems (TRI)]] |
| Modelo 2PL | *a* = discriminación, *b* = ubicación; curva logística | Fase 3.1–3.2 (bienes) |
| Respuesta graduada (GRM) | un umbral *b* por cada paso entre categorías | Fase 3.1 (educación, libros, vivienda) |
| Respuesta nominal | categorías sin orden; alternativa para la ocupación | D-08 |
| Curva característica (ICC) | probabilidad de respuesta según el nivel del rasgo | Fase 3.4 |
| Información del test | precisión de la escala en cada nivel del rasgo | Fase 3.4 |
| Ajuste (M2, S-X²) | el modelo reproduce o no las respuestas | Fase 3.3 |
| Puntajes EAP | estimación del rasgo de cada persona | Fase 3.6 |
| DIF | a igual nivel del rasgo, un grupo responde distinto | Fase 3.7, 6.3 |

## Ecuaciones estructurales

| Concepto | Qué hay que saber explicar | Dónde se usa |
|---|---|---|
| Correlación policórica | correlación entre ordinales, suponiendo una variable continua subyacente | Fase 2.3 |
| AFE vs AFC | explorar la estructura vs ponerla a prueba | Fases 2 y 4 |
| Análisis paralelo | cuántos factores retener | Fase 2.4 |
| Identificación | un factor necesita suficientes indicadores / restricciones | Fase 4.4 (D-05) |
| WLSMV | estimador para indicadores ordinales; cómo maneja los faltantes | Fase 4.1 (D-04) |
| Índices de ajuste | CFI, TLI, RMSEA, SRMR, y por qué el χ² falla con n grande | Fase 4.3 |
| Confiabilidad compuesta | consistencia de un factor | Fase 4.3 |
| Modelo estructural | regresiones entre variables latentes | Fase 5 |
| Mediación | efectos directos, indirectos y totales | Fase 5.3 |
| Invarianza de medición | configural → métrica → escalar; invarianza parcial | Fase 6 |
| Datos anidados | estudiantes dentro de colegios; errores estándar agrupados; SEM multinivel | Fase 4.5, 5.4 |

## Puente TRI ↔ SEM

Un AFC con indicadores ordinales y un modelo TRI (2PL/GRM) son **el mismo modelo con otra
parametrización**: las cargas del AFC se convierten en discriminaciones *a* y los umbrales en *b*.
Por eso el DIF (fase 3.7) y la no invarianza escalar (fase 6) deberían señalar los mismos ítems.
Es un buen argumento para la sustentación de las dos materias.

## Python / APIs

| Concepto | Dónde se usa |
|---|---|
| FastAPI, rutas, esquemas | Fase 7.2 |
| OpenAPI / Swagger | Fase 7.2 |
| RAG: fragmentar, embeddings, recuperar, generar con citas | Fase 7.4 |
