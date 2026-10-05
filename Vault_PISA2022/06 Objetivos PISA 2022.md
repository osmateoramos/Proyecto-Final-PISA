---
tipo: guia
estado: por_verificar
lectura: "redactado por Claude; falta revisión del equipo"
pendientes: "Cifras de viabilidad: volver a correr Proyecto_PISA/datos/revision_pisa2022_col.R y comparar"
verificado_por:
fecha_verificacion:
---

# Objetivos — PISA 2022 Colombia

Volver a [[00 Inicio]] · Plan en [[07 Plan de desarrollo PISA 2022]] · Hipótesis en [[09 Hipótesis preregistradas]]
Decisión de fuente: D-11 en [[03 Registro de decisiones]]

## Pregunta de investigación

> **¿En qué medida el nivel socioeconómico (NSE) —modelado como constructo latente cuya medición es igual
> entre grupos— explica el desempeño de los estudiantes colombianos en cada una de las cuatro competencias
> matemáticas de PISA 2022, calificadas con un modelo de TRI propio, y cuánto de la brecha observada depende de
> cómo se califica el desempeño?**

## Objetivo general

**Determinar en qué medida el nivel socioeconómico, medido como constructo latente con invarianza verificada
entre grupos, explica el desempeño de los estudiantes colombianos de 15 años en las cuatro competencias
matemáticas evaluadas por PISA 2022 (formular, emplear, interpretar y razonar), calificadas por competencia con
un modelo de Teoría de Respuesta al Ítem multidimensional propio, y en qué medida la brecha socioeconómica
observada depende del funcionamiento de los ítems y del tratamiento de las respuestas omitidas.**

## Objetivos específicos

La secuencia es acumulativa: O1 construye la medida del NSE → O2 verifica que compara con justicia →
O3 hace lo mismo con la medida de matemáticas → O4 relaciona ambas → O5 las expone.

### O1. Medir el NSE — `[TRI]` `[SEM]`
**Estimar un modelo de medición del NSE como constructo latente**, calibrando los ítems del cuestionario con TRI
y contrastando una estructura unidimensional contra una de dos dimensiones (capital económico y cultural).
- **Datos:** 27 ítems de posesiones del hogar disponibles para Colombia (`ST250`, `ST251`, `ST253`, `ST254`, `ST255`,
  `ST256` — este último, 8 tipos de libros en casa: indicador de capital cultural), educación de los padres
  (`ST005`, `ST007`, `HISCED`) y ocupación (`HISEI`).
- **Método:** 2PL (ítems Sí/No) y GPCM / respuesta graduada (politómicos) con `mirt`; AFC con WLSMV en `lavaan`;
  contraste con el índice oficial ESCS y con HOMEPOS.
- **Cumplido cuando:** parámetros *a* y *b* + curvas de información; cargas estandarizadas, confiabilidad (omega)
  y ajuste (CFI, TLI, RMSEA, SRMR); prueba 1 vs 2 dimensiones; correlación con ESCS.

### O2. Verificar que el NSE se mide igual en todos los grupos — `[SEM]` `[TRI]`
**Evaluar la invarianza de medición del modelo de NSE** entre zona (rural / pueblo / urbana), sexo y sector
(público / privado).
- **Datos:** modelo de O1 + `SC001Q01TA` (zona), `SCHLTYPE` (sector), `ST004D01T` (sexo).
- **Método:** invarianza configural → umbrales → métrica → escalar (`semTools::measEq.syntax`); DIF de los ítems
  de posesiones con `mirt::multipleGroup`.
- **Cumplido cuando:** tabla de modelos anidados con ΔCFI y ΔRMSEA; lista de ítems no invariantes si la
  invarianza es parcial.

### O3. Calificar por competencias y verificar que la calificación es justa — `[TRI]`
**Calibrar un modelo de TRI multidimensional propio con las cuatro competencias matemáticas como dimensiones,
asignar a cada estudiante un puntaje por competencia, validarlo contra los valores plausibles de la OCDE y
verificar su equidad (DIF por NSE y sensibilidad al tratamiento de las omisiones).** (Decisión D-16.)
- **Datos:** ítems de matemáticas de Colombia (234 calificados; **233 clasificados por competencia** en la hoja
  *Mathematics-CBA* del anexo A del Technical Report 2022: emplear 75, interpretar 57, razonar 53, formular 48; falta
  `CMA112Q02S`). Valores plausibles OCDE `PV1–10 MPFS/MPEM/MPIN/MPRE`; tiempos (`TT`).
- **Método:** MIRT confirmatorio entre ítems (cada ítem carga en su competencia; 2PL/GPCM) con `mirt`, contra el modelo
  unidimensional; puntajes EAP/PV por competencia; validez convergente con los PV de la OCDE; DIF cuartil bajo vs alto
  de NSE dentro de cada competencia; recalificación de omisiones rápidas (D-14).
- **Cumplido cuando:** comparación 1 vs 4 dimensiones (AIC/BIC, ajuste), confiabilidad por competencia, correlación
  puntaje propio–PV OCDE por competencia, lista de ítems con DIF y brecha bajo ambos tratamientos de las omisiones.

### O4. Explicar el desempeño por competencia — `[SEM]`
**Estimar el modelo estructural en que el NSE latente de O1 predice el desempeño en cada una de las cuatro
competencias calificadas en O3**, y probar si su efecto es igual entre competencias y entre los grupos de O2.
- **Datos:** puntajes por competencia de O3 (principal) y valores plausibles de la OCDE (robustez); peso `W_FSTUWT` +
  80 replicados; colegio (`CNTSCHID`).
- **Método:** modelo estimado por cada conjunto de puntajes plausibles y combinado con reglas de Rubin; pesos y
  conglomerado por colegio; prueba de igualdad de efectos entre competencias; multigrupo si O2 lo permite.
- **Cumplido cuando:** coeficientes por competencia con su error estándar, prueba de igualdad e índices de ajuste,
  con ambos tipos de puntaje.

### O5. Poner los resultados a disposición — `[PY]`
**Desarrollar una API REST en FastAPI y un tablero** que permitan consultar los parámetros TRI (O1, O3), los
resultados de invarianza y DIF (O2, O3) y los coeficientes y puntajes agregados por competencia y subgrupo (O3, O4).
- **Cumplido cuando:** documentación OpenAPI/Swagger accesible, endpoints funcionando sobre resultados reales y
  pruebas automáticas.
- **Extensión opcional:** módulo de consulta en lenguaje natural (RAG) sobre el vault y los documentos de la OCDE
  (D-02, D-13).

## Viabilidad ya verificada en los datos (revisión del 2026-09-29)

| Objetivo | Dato comprobado en Colombia | Fuente |
|---|---|---|
| O1 | 27 ítems de posesiones (77–96 % de datos; ST256 tipos de libros ~78 %); educación y ocupación de padres disponibles; 7.459 estudiantes con ESCS | `datos/revision_pisa2022_col.R` |
| O2 | 1.038 rurales, 963 pueblo, 5.535 urbanos; 6.114 público, 1.590 privado; 4.014 mujeres, 3.790 hombres; 262 colegios | ídem |
| O3 | 175 de 234 ítems con ≥100 respuestas en ambos cuartiles extremos de ESCS; omisión Q1 11,5 % vs Q4 8,0 % | ídem |
| O3 | 233 de 234 ítems clasificados por competencia (48–75 por competencia); 0 discrepancias con el anexo 2025 en 177 ítems comunes | anexo A 2022 (`Proyecto_PISA/documentacion/`), conteo de Claude 2026-10-04 |
| O4 | Competencias (PV OCDE) correlacionan 0,70–0,83; NSE pesa 3,9 puntos más en *interpretar* que en *emplear* (z = 2,61) | `Proyecto_PISA/datos/revision_pisa2022_col.R` |

## Alcance — qué queda fuera y por qué
- **Comparación entre países:** solo Colombia (cabe en el semestre). Respaldo para O3 si falta potencia: agrupar
  países hispanohablantes.
- **PISA 2025:** matemáticas es dominio menor, sin subescalas de proceso.
- **Los 3 bienes nacionales de Colombia** (televisor, nevera, consola): no están en la base pública.
- **Afirmaciones causales:** diseño transversal de un solo ciclo.
- **Saber 11:** queda como antecedente y motivación (no publica resultados por competencias).

## Pendiente de verificar
- El ítem `CMA112Q02S` no aparece en el anexo A 2022: revisar si cambió de código o si se excluyó del escalamiento.
