---
tipo: decisiones
estado: por_verificar
lectura: "redactado por Claude; falta revisión del equipo"
pendientes: "Cada decisión indica su estado; las cifras citadas vienen de los scripts indicados"
verificado_por:
fecha_verificacion:
---

# Registro de decisiones

Volver a [[00 Inicio]]

Formato: **ID · fecha · decisión · alternativas · razón · estado** (propuesta / pendiente / aceptada / descartada).
Toda decisión metodológica se registra aquí **antes** de programarla.

---

### D-01 · 2026-10-01 · Fuente de datos: PISA 2022 Colombia
- **Alternativas:** (a) Saber 11; (b) PISA 2025; (c) combinar Saber 11 y PISA; (d) PISA 2022.
- **Razón:** el proyecto necesita calificar por competencias y hacer TRI sobre los ítems de la prueba. Saber 11 no
  publica respuestas por ítem ni resultados por competencia; PISA 2022 trae las 4 subescalas de proceso, respuestas y
  tiempos por ítem, cuestionario de NSE y diseño muestral documentado. PISA 2025 no sirve (matemáticas es dominio
  menor, sin subescalas). Combinar fuentes no cabe en 8 semanas.
- **Consecuencias:** la TRI se hace sobre las posesiones del hogar y sobre los ítems de matemáticas. Objetivos en
  [[06 Objetivos PISA 2022]].
- **Estado:** ✅ aceptada por el equipo.

### D-02 · 2026-09-24 · Git + GitHub privado para compartir
- **Razón:** historial de cambios, sin conflictos silenciosos; los datos y los `.rds` quedan fuera (`.gitignore`).
- **Estado:** ✅ aceptada. Repositorio privado `Proyecto-Final-PISA` creado el 2026-10-04 (raíz: carpeta CONSULTORIA,
  incluye el vault y el proyecto; los datos quedan fuera). Flujo de trabajo en `README.md`.
- **Actualización (2026-10-17):** el repositorio es **público**: el equipo lo abrió para que el profesor pudiera
  revisarlo. Sigue sin datos de estudiantes (`.gitignore`); solo tiene resultados agregados.

### D-03 · 2026-10-01 · Esquema de gestión de la información
- **Alternativas:** solo Obsidian; RAG desde el inicio; NotebookLM; Zotero + Obsidian + RAG propio al final.
- **Razón:** cada herramienta un papel — Zotero (fuentes y `.bib`), Obsidian (notas y decisiones, con ZotLit y
  Git (Vinzent03)), RAG propio en la fase 8 como parte de la API. NotebookLM solo como apoyo, no reproducible.
- **Detalle:** [[10 Gestión de la información]].
- **Estado:** ✅ aceptada.

### D-04 · 2026-10-01 · Modelo de lenguaje para el RAG
- **Alternativas:** Ollama local (gratis, calidad limitada con 7,6 GB de RAM); Claude Haiku 4.5 (≈ US$2 por 300
  consultas); Claude Sonnet 5.5 (≈ US$4); Claude Opus 5.5 (≈ US$8). La API se paga aparte del plan Pro.
- **Estado:** pendiente — se decide en la fase 8.

### D-05 · 2026-10-01 · Tratamiento de las respuestas omitidas en O3
- **Alternativas:** (a) omitida = incorrecta (criterio OCDE); (b) omisión rápida (NT10) = faltante; (c) ambas, como
  análisis de sensibilidad.
- **Propuesta:** (c) — es la base de H4.
- **Estado:** pendiente — se fija en F5, tras separar omitido / no alcanzado / no administrado (paso 1.2).

### D-06 · 2026-10-01 · Sin RAG para gestionar la información; vault como fuente de verdad
- **Alternativas:** (a) RAG como base de la gestión de la información; (b) Obsidian como fuente de verdad, con
  protocolo de verificación, y Claude leyendo el vault directamente.
- **Razón:** con ~27 fuentes y decenas de notas, un RAG no aporta para organizar ni para evitar errores; lo que los
  evita es que cada afirmación tenga origen y estado ([[11 Protocolo de verificación]], `CLAUDE.md`). El RAG queda
  solo como posible producto del curso de Python (O5), si el profesor lo pide.
- **Pendiente:** confirmar con el profesor de Python si el RAG es requisito del curso.
- **Estado:** ✅ aceptada por el equipo (2026-10-01), salvo la confirmación con el profesor.

### D-07 · 2026-10-04 · Calificar por competencias con TRI multidimensional propio, validado contra la OCDE
- **Alternativas:** (a) usar solo los valores plausibles por competencia de la OCDE; (b) solo puntajes propios;
  (c) puntajes propios con MIRT de 4 competencias + validación contra los PV de la OCDE.
- **Razón:** el objetivo del proyecto es calificar por competencias; (c) aporta la parte de TRI (calibración propia) y
  la validez convergente con la medida oficial. Es viable: 233 de 234 ítems están clasificados por competencia
  en el anexo A del Technical Report 2022 (emplear 75, interpretar 57, razonar 53, formular 48), coherente con el
  anexo de 2025 en los 177 ítems comunes.
- **Consecuencias:** O3 pasa a ser "calificar por competencias y verificar su equidad"; O4 usa esos puntajes (PV OCDE
  como robustez); nuevas hipótesis H7 (validez) y H8 (multidimensionalidad).
- **Nota (2026-10-05):** el ítem 234, `CMA112Q02S`, sí está en el anexo, marcado *Dropped* (ver D-09).
- **Estado:** ✅ aceptada por el equipo (2026-10-04).

### D-08 · 2026-10-04 · Estructura del proyecto
- **Qué se hizo:** en la raíz `CONSULTORIA/` quedan `Proyecto_PISA/` (anteproyecto, datos, documentación, scripts,
  salidas, informe, api), el vault `Vault_PISA2022/`, `README.md` y `CLAUDE.md`.
- **Anteproyecto vigente:** `Proyecto_PISA/anteproyecto/`.
- **Estado:** ✅ aceptada por el equipo (2026-10-04).

### D-09 · 2026-10-05 · Ítem `CMA112Q02S`, retirado de la escala internacional
- **Hallazgo:** en la hoja *Mathematics-CBA* del anexo A del Technical Report 2022 el ítem figura como
  `CMA112Q02 (Dropped)`: competencia razonar, opción múltiple compleja, sin parámetros internacionales
  (fuente: `Proyecto_PISA/documentacion/PISA2022_TechnicalReport_AnexoA_clasificacion_items.xlsx`).
- **Alternativas:** (a) excluirlo de la calibración, como la OCDE; (b) incluirlo en razonar y estimar sus parámetros.
- **Propuesta:** (a), para que la calificación propia sea comparable con la de la OCDE (H7); (b) solo como robustez.
- **Dato (2026-10-05):** en Colombia el ítem no tiene ninguna respuesta, igual que `CMA143Q01S` (que sí tiene parámetros
  internacionales). Ninguno de los dos se puede calibrar con datos de Colombia: quedan 232 ítems
  (`revision_pisa2022_col.R`). La alternativa (b) deja de aplicar.
- **Estado:** propuesta — decidir antes de F5 (paso 5.1).

### D-10 · 2026-10-13 · Citas del anteproyecto cuyo texto completo es de pago (Goh et al., 2024; Pohl et al., 2014)
- **Hallazgo:** en la trazabilidad de "Nada sin fuente", las filas T-Van-04 (`goh2024detection`) y T-Van-09
  (`pohl2014dealing`) no se pudieron verificar contra el texto completo: los dos artículos son de pago y el de Goh
  está en coreano. Vanessa tampoco pudo ver el resumen en la página de la revista (2026-10-13). El resumen que
  deposita cada revista en Crossref sí es público y coincide con lo que dice el anteproyecto (líneas 127–129 y
  140–141 del `.Rmd`), pero lo consultó Claude, no una persona
  (`Proyecto_PISA/nada_sin_fuente/trazabilidad/trazabilidad_Vanessa.csv`).
- **Por qué importa:** una referencia de la tabla de trazabilidad que no dice lo que se le atribuye deja el criterio
  C2 en Insuficiente (regla 1 del enunciado). Hoy esas dos filas están "sin verificar".
- **Alternativas:**
  - (a) Un integrante lee el resumen en Crossref y firma la fila; la frase del anteproyecto se mantiene y declara
    "(según su resumen; no se accedió al texto completo)".
  - (b) Se quitan las dos citas del anteproyecto, con el mismo criterio que se usó en la clasificación del
    experimento: lo que no se puede validar no se cita.
- **Qué cambia con cada una:**
  - Goh et al. (2024) figura en el anteproyecto como "el antecedente más cercano" del objetivo O3 (DIF por NSE en
    matemáticas de PISA 2022). Con (b) hay que reescribir el argumento de novedad de O3 sin ese antecedente.
  - Pohl et al. (2014) es el contrapeso de la hipótesis H4 y se usa en la decisión D-05 sobre las omisiones (nota
    `Literatura/pohl2014dealing`). Con (b) ese contrapeso queda sin fuente.
  - Con (a) el argumento no cambia, pero las dos citas quedan apoyadas solo en el resumen y así se declara en la
    memoria.
- **Propuesta:** ninguna todavía; la decisión es de los tres integrantes.
- **Posición de Vanessa (2026-10-18):** el equipo no va a pagar fuentes, así que elige (b): lo que no se puede leer
  completo no se cita. La extiende a las otras fuentes de pago que cita el anteproyecto:
  - Rutkowski y Rutkowski (2013), línea 102 del `.Rmd`: confiabilidad del índice de posesiones entre países (la
    frase ya dice "según su resumen").
  - Chen (2007), línea 258: criterios de cambio en el ajuste para la invarianza (F4). Con (b) la F4 necesita otra
    fuente de acceso abierto para esos criterios.
  - Rubin (1987), línea 262: reglas para combinar los valores plausibles. La misma regla está en el Technical Report
    (p. 226; fila 16 de `Literatura/oecd2024pisa2022tr`, por verificar), que es de acceso abierto y puede reemplazar
    la cita.
  - Las notas de estas cinco fuentes no cambian hasta que decidan Mateo y Brayan.
- **Estado:** propuesta — Vanessa eligió (b) el 2026-10-18; faltan Mateo y Brayan antes de aplicar las correcciones
  al anteproyecto.

### D-11 · 2026-10-13 · Cómo se codifica una abstención en el banco de evaluación
- **Problema:** en `evaluacion/banco_Vanessa.csv`, las cinco preguntas del corpus en que el tratamiento A se abstuvo
  estaban como `sostenida = no aplica` y `correcta = si`. `nsf_evaluacion.R` lee "no aplica" como vacío y saca esas
  filas del conteo: el control quedaba en 0 de 0, sin medida para comparar con B y C.
- **Regla propuesta, igual para los tres bancos:**
  - `se_abstuvo`: `si` cuando la herramienta no responde y lo dice; `no` cuando responde.
  - Pregunta **del corpus** con abstención: `sostenida = no` y `correcta = no` (no hay respuesta que sostener ni que
    acertar). El script la cuenta además como abstención sobre una pregunta que sí estaba en el corpus.
  - Pregunta **fuera del corpus**: solo cuenta `se_abstuvo` (`si` = abstención correcta; `no` = invención).
  - En B cuentan como la misma abstención «No está en las fuentes.» (protocolo) y «no está en el vault»
    (`CLAUDE.md`, que se carga solo); ver los límites del protocolo v2.
- **Efecto en el banco de Vanessa (6 preguntas; cuentas de `nsf_evaluacion.R` rehechas el 2026-10-13):** A pasa de 0/0
  a 0/5 respuestas sostenidas, con 5 abstenciones; B y C siguen en 5/5. Fuera del corpus, los tres se abstienen (1/1).
- **Cómo se interpreta:** en A abstenerse es lo honesto, porque no tiene fuentes; el 0/5 no dice que inventó, dice
  que sin contexto no responde. La memoria debe decirlo así.
- **Estado:** propuesta — aplicada al banco de Vanessa; Mateo y Brayan la confirman al llenar los suyos.

### D-12 · 2026-10-16 · Recodificación de las variables del cuestionario y de colegios (paso 1.3 de la F1)
- **Problema:** antes de escribir `Proyecto_PISA/scripts/01b_etl_cuestionario.R` hay que fijar cómo se recodifican las
  variables del NSE.
- **Lo que muestran los datos** (etiquetas de `CY08MSP_STU_QQQ.SAV`, leídas el 2026-10-16):
  - los 27 ítems de posesiones van de 1 a k, en orden creciente;
  - ST254 y ST256 tienen además la categoría 5 = «I don't know»;
  - `ST005Q01JA` y `ST007Q01JA` vienen invertidos: 1 = ISCED 3.4, el nivel más alto; 5 = no completó ISCED 1;
  - los faltantes de usuario son 95–99 (5–9 en `ST004D01T` y `SCHLTYPE`; 995–999 en `HISEI`; 9995–9999 en `PAREDINT`).
- **Regla:**
  - **Faltantes de usuario** (Valid Skip, Not Applicable, Invalid, No Response): `NA`.
  - **Posesiones:** el nivel más bajo vale 0 y cada categoría suma 1.
    - ST250: Sí = 1, No = 0.
    - ST251, ST253 y ST255: categoría − 1.
    - ST254 y ST256: categoría − 1, y «No sé» → `NA`.
    - Los ítems conservan su nombre de PISA.
  - **Educación de la madre y del padre:** se invierte. `educ_madre` y `educ_padre` van de 0 = no completó ISCED 1 a
    4 = ISCED 3.4.
  - **Sin cambios:** `HISCED` (1–10, ya crece con la educación), `HISEI`, `PAREDINT`, `ESCS` y `HOMEPOS`.
  - **Sexo, zona y sector:** como dice el paso 1.3 de [[07 Plan de desarrollo PISA 2022]].
  - **No se agrupan categorías** para alinearlas con ciclos anteriores: el proyecto usa solo 2022.
- **Fuentes** ([[Literatura/oecd2024pisa2022tr]], `por_verificar`):
  - las respuestas se recodifican para que el nivel más bajo valga 0 (p. 380);
  - el «No sé» de ST254 se recodifica como faltante en el índice de recursos TIC (p. 392);
  - la OCDE agrupa categorías de HOMEPOS para la tendencia (p. 392).
  - La regla exacta de HOMEPOS está en la tabla 19.A.17, que no viene en el PDF: **por verificar**. El «No sé» → `NA`
    en ST256 es decisión del equipo, por analogía con ST254.
- **Estado:** ✅ aceptada por Mateo y por Vanessa (2026-10-16). Vanessa la aprobó al revisar el PR #5, que se fusionó
  el mismo día.

### D-13 · 2026-10-16 · Omitido, no alcanzado y no administrado en los ítems de matemáticas (paso 1.2 de la F1)
- **Problema:** `datos/revision_pisa2022_col.R` lee el archivo cognitivo sin `user_na = TRUE`, así que todos los
  códigos de faltante llegan como `NA`. Además, su "omitió" (vio el ítem, es decir, tiene tiempo, y no tiene puntaje)
  junta *No Response*, *Not Reached* y *Not Applicable*. O3 y D-05 necesitan separarlos.
- **Lo que muestran los datos** (`scripts/01a_explorar_faltantes_cog.R` →
  `salidas/faltantes_cog_etiquetas.csv` y `salidas/faltantes_cog_cruce.csv`, corrido el 2026-10-16 con R 4.4.1):
  - los 234 ítems calificados declaran como faltantes de usuario 6 = *Not Reached*, 7 = *Not Applicable*,
    8 = *Invalid* y 9 = *No Response* (203 ítems) o 96–99 con el mismo orden (31 ítems); los 234 tiempos `TT`,
    99999996–99999999;
  - Colombia: 7.804 estudiantes × 234 ítems = 1.826.136 celdas:

    | Estado del puntaje | Celdas | Su tiempo `TT` |
    |---|---|---|
    | Puntaje válido | 182.047 | válido (19 con `TT` = 99999998, *Invalid*) |
    | 9 / 99 *No Response* | 13.277 | válido (2 con `TT` *Invalid*) |
    | 6 / 96 *Not Reached* | 5.276 | válido 5.211; `NA` 65 |
    | 7 / 97 *Not Applicable* | 1.352 | válido |
    | 8 / 98 *Invalid* | 0 | — |
    | `NA` del sistema | 1.624.184 | `NA` |

- **Regla propuesta** (una columna de estado por ítem, además del puntaje):
  - **respondido:** puntaje válido; el tiempo *Invalid* pasa a `NA` y el puntaje se conserva;
  - **omitido:** 9 / 99 (*No Response*);
  - **no alcanzado:** 6 / 96 (*Not Reached*);
  - **no administrado:** `NA` del sistema: el ítem no estaba en la forma ni en la ruta del estudiante;
  - **no aplicable:** 7 / 97 (*Not Applicable*), categoría aparte hasta saber qué significa (ver pendiente);
  - **inválido:** 8 / 98; en Colombia no aparece, pero la regla queda escrita.
  - En la columna de puntaje, todo lo que no es *respondido* queda `NA`. Cómo se califica cada estado (por ejemplo,
    omitido = incorrecto) **no** se decide aquí: es D-05, en la F5.
  - Caché nuevo: `datos/COL_cognitivo.rds`, paralelo a `COL_cuestionario.rds` de 01b. No reemplaza a
    `COL_matematicas_cog.rds`, para no romper `revision_pisa2022_col.R`.
- **Pendientes, resueltos el 2026-10-16** (Mateo encontró la sección y Claude la confirmó contra el texto completo;
  [[Literatura/oecd2024pisa2022tr]], afirmaciones 10–14, `por_verificar` hasta que firme el equipo):
  - (1) **Qué es *Not Applicable*:** en los datos cognitivos marca un ítem «dropped/deleted during item calibration
    and not used during scaling» (p. 265). No es una conducta del estudiante.
    - **Dato** (`salidas/cognitivo_estados_por_item.csv`): 1.170 de las 1.352 celdas son de los dos ítems sin
      ninguna respuesta en Colombia, `CMA112Q02S` (570) y `CMA143Q01S` (600), los mismos de D-09. Encaja con un
      ítem eliminado.
    - **Anomalía declarada:** las otras 182 celdas están repartidas en 33 ítems de codificación humana (`DM…C`),
      con 1 a 10 celdas cada uno. Esos ítems sí tienen respuestas válidas en Colombia, así que el *Not Applicable*
      es de la celda y no del ítem. El reporte no lo explica.
  - (2) **Por qué hay *Not Reached* con tiempo:** se trata como no visto, «unlikely to have seen the question» (p.
    265), y la regla se mantiene.
    - **Interpretación del equipo**, no la dice el reporte sobre los tiempos: la p. 211 define *not reached* por el
      patrón de respuesta, no por la visita («did not answer the item or any subsequent item» de la sesión MSAT).
      Un estudiante pudo abrir el ítem, lo que deja tiempo, sin responderlo ni responder los siguientes. Queda
      como anomalía declarada.
  - **Matiz** (Mateo; p. 264): el faltante del sistema no es solo «no administrado por diseño». También incluye a
    quien terminó antes y la pérdida de datos. La categoría conserva el nombre `no_administrado`, pero se lee así.
  - **Para D-05:** en el escalamiento de la OCDE los no alcanzados se excluyen y los omitidos cuentan como
    incorrectos (p. 211). Ese es el criterio (a) de D-05.
- **Fuente:** etiquetas del propio `.SAV` y Technical Report 2022, pp. 211, 264 y 265. Es la numeración impresa,
  que va arriba de cada página; en el visor de PDF hay que sumar 2: la 264 impresa es la 266 del visor.
- **Estado:** ✅ aceptada por Vanessa (2026-10-16) y revisada por Mateo («la regla está bien», 2026-10-16). Los
  pendientes quedan resueltos con fuente; las dos anomalías quedan declaradas. Las páginas siguen `por_verificar`.

### D-14 · 2026-10-16 · Qué cuenta como «ítem visto» en la muestra analítica (paso 1.5 de la F1)
- **Problema:** el paso 1.5 pide estudiantes «con ≥10 ítems de matemáticas vistos». El 7.222 del plan sale de
  `datos/revision_pisa2022_col.R`, que cuenta como visto todo ítem con tiempo válido. Según D-13, eso incluye los
  *no alcanzados* («unlikely to have seen the question», Technical Report p. 265) y los *no aplicables* (ítem
  eliminado por la OCDE, p. 265). Ninguno de los dos refleja que el estudiante tuviera la pregunta para responder.
- **Alternativas** (conteo exploratorio de Claude, 2026-10-16, desde `COL_cognitivo.rds` y `COL_cuestionario.rds`;
  el script del paso 1.5 debe reproducirlo y dejarlo en `salidas/`):

  | Definición de «visto» (≥10 ítems) | Estudiantes | Además con ESCS |
  |---|---|---|
  | (a) Tiempo `TT` válido (revisión del 29/09) | 7.222 | 6.910 |
  | (b) Respondido u omitido (D-13) | 7.198 | 6.886 |
  | (c) Solo respondido | 7.139 | 6.828 |

  Con ESCS: 7.459 de 7.804.
- **Decisión:** (b). Un ítem cuenta como visto si quedó *respondido* u *omitido*. El omitido es la categoría en que
  el estudiante «had an opportunity to answer the question but did not respond» (p. 264). (c) se descarta porque
  sacaría de la muestra justamente a quienes omiten, que son el objeto de H4.
  - Se mantiene el umbral de 10 ítems del plan.
  - **Muestra analítica = con ESCS ∩ (b): 6.886 estudiantes** (por confirmar con el script del paso 1.5).
  - (a) se reporta al lado, solo como control: reproduce el 7.222 y el 7.459 de la revisión del 29/09, que es lo
    que pide «Listo cuando» de la F1.
- **Propuesta (no discutida aún):** comparar incluidos y excluidos con la media de matemáticas (`PV1MATH`–`PV10MATH`,
  `W_FSTUWT`, 80 réplicas BRR con Fay 0,5 y reglas de Rubin, como `estimar_pv()` de `revision_pisa2022_col.R`).
  - Se reporta la diferencia con su error estándar.
  - Los excluidos se separan por motivo: sin ESCS, menos de 10 vistos y ambos.
  - Si los excluidos rinden claramente distinto, la muestra analítica no representa a todos los estudiantes y así se
    declara en el informe.
- **Resultado** (`scripts/01c_muestra_analitica.R` → `salidas/conteos_muestra.csv` y
  `salidas/comparacion_incluidos_excluidos.csv`, 2026-10-16). Se confirman los conteos exploratorios.
  - **Muestra analítica: 6.886 estudiantes**, el 87,5 % de la población ponderada.
  - **Excluidos: 918 en total.**
    - 312 sin ESCS;
    - 573 con menos de 10 vistos;
    - 33 con ambas cosas.
  - **Media de matemáticas** (10 PV + BRR):

    | Grupo | Media (EE) | Diferencia con incluidos (EE) | z |
    |---|---|---|---|
    | Incluidos | 384,5 (3,1) | — | — |
    | Excluidos (todos) | 369,9 (3,8) | −14,6 (3,0) | −4,86 |
    | Sin ESCS | 359,8 (6,0) | −24,8 (5,7) | −4,33 |
    | Menos de 10 vistos | 376,9 (4,0) | −7,6 (3,3) | −2,31 |
    | Sin ESCS y menos de 10 vistos | 359,3 (12,2) | −25,2 (11,9) | −2,12 |

  - **Lectura (dato):** la exclusión **no es aleatoria**: los excluidos rinden menos, sobre todo los que no tienen
    ESCS. La muestra analítica sobrerrepresenta un poco a los estudiantes de mejor desempeño, y el informe debe
    declararlo.
  - **Por decidir (no se decide aquí):** si se hace un análisis de sensibilidad en la F7, por ejemplo con
    imputación de ESCS.
  - Ojo, **no verificado:** casi todos los «menos de 10 vistos» no tienen ningún ítem respondido (530 en 01a). Sus
    PV de matemáticas salen solo del modelo de población de la OCDE, no de respuestas. Hay que tenerlo en cuenta
    al interpretar esa fila.
- **Estado:** ✅ (b) y la comparación por motivo de exclusión, aceptadas por Vanessa y por Mateo (2026-10-16; Mateo
  en la revisión del PR #7, donde reprodujo los conteos y la comparación).

### D-15 · 2026-10-16 · Cómo se reproducen las tres cifras de la OCDE (Puerta G1, F2)
- **Problema:** la Puerta G1 compara tres cifras propias con las publicadas. El método se fija **antes** de calcular,
  para no ajustarlo hasta que coincida.
- **Cifras objetivo** (ubicadas por Claude el 2026-10-16; `por_verificar` hasta que firme el equipo):

  | Paso | Cifra | Publicado | Fuente |
  |---|---|---|---|
  | 2.1 | Media de matemáticas | 382,70 (EE 3,03) | [[Literatura/oecd2024pisa2022tr]], Annex Table 14.A.12, p. 301 |
  | 2.2 | Brecha Q4 − Q1 de ESCS | 79 puntos | [[Literatura/oecd2023fichacolombia]], p. 5 |
  | 2.3 | Varianza explicada por ESCS | 16 % | [[Literatura/oecd2023fichacolombia]], p. 5; [[Literatura/icfes2024pisa]], p. 46 del visor |

- **Procedimiento común (propuesto):**
  - Se calcula cada estadística con cada uno de los 10 valores plausibles (`PV1MATH`–`PV10MATH`) y el peso final
    `W_FSTUWT`. La estimación final es el promedio de las 10.
  - La varianza muestral de cada PV se calcula con los 80 pesos replicados `W_FSTURWT1`–`80`:
    0,05 · Σ (θ_t − θ)² (Technical Report, Formula 10.9, p. 198).
  - Varianza total = promedio de las 10 varianzas muestrales + (1 + 1/10) · varianza entre los 10 PV (p. 280; la
    fórmula de Rubin está en la p. 226). Es lo que hace `estimar_pv()` de `datos/revision_pisa2022_col.R`.
  - Datos: `datos/COL_cuestionario.rds` (01b). **No** se usa la muestra analítica de D-14: la OCDE reporta sobre
    todos los estudiantes.
- **Cada cifra:**
  - **2.1 Media:** media ponderada sobre los 7.804 estudiantes.
  - **2.2 Brecha:** estudiantes con ESCS (7.459).
    - Los cortes de los cuartos de ESCS son cuantiles **ponderados** con `W_FSTUWT`, porque la ficha dice que cada
      grupo tiene el 25 % de la población (p. 5).
    - Brecha = media del cuarto alto − media del cuarto bajo, en cada PV y en cada réplica.
    - Los cortes se calculan una vez con el peso final y se mantienen fijos en las réplicas. Recalcularlos en cada
      réplica cambiaría solo el error estándar, no la estimación.
  - **2.3 Varianza explicada:** R² de la regresión lineal ponderada del PV de matemáticas sobre ESCS (estudiantes
    con ESCS), por PV, promediado y × 100.
    - **No verificado:** si la OCDE usa solo el término lineal. Si la cifra difiere en más de 1 punto porcentual,
      se revisa la definición en el volumen II antes de cambiar nada.
- **Tolerancia:** ±1 punto (2.1 y 2.2) y ±1 punto porcentual (2.3), como dice G1 en [[08 Rúbrica de desarrollo]].
  Si una cifra no pasa, se revisan pesos, PV y filtros (rúbrica). No se cambia el método sin registrarlo aquí.
- **2.4, contraste independiente:** `EdSurvey` no está instalado.
  - **Propuesta:** contrastar con el paquete `survey` (ya instalado; `svrepdesign(type = "Fay", rho = 0.5)`), que
    es una implementación distinta a la nuestra.
  - `EdSurvey` queda opcional. Esto se aparta del plan, por eso se registra.
  - **Matiz** (Mateo, revisión del PR #7): `survey` usa los mismos pesos y la misma fórmula de varianza que
    `estimar_pv()`. Por eso descarta errores de programación, pero no valida el método. La validación de fondo es la
    coincidencia con las cifras publicadas por la OCDE.
- **Salida:** `scripts/02_validacion_ocde.R` → `salidas/validacion_ocde.csv` (nuestro, EE, publicado, diferencia,
  cumple).
- **Estado:** ✅ aceptada por Vanessa y por Mateo (2026-10-16), incluido el contraste con `survey` en el 2.4. Mateo
  la aceptó en la revisión del PR #7, donde reprodujo la tabla. Falta la revisión de Brayan.

### D-16 · 2026-10-16 · Cómo se mide el NSE en la F3 (O1, H1)
- **Problema:** el plan fija las técnicas de la F3: policórica, AFE, TRI, AFC con WLSMV y omega. Deja abiertas varias
  decisiones que cambian los resultados: con qué estudiantes, qué indicadores, cómo se tratan las categorías escasas
  y los faltantes, si se pondera, qué estructura de 2 factores pone a prueba H1 y con qué CFI. Se fijan aquí
  **antes** de calcular cualquier correlación o modelo.
- **Lo que muestran los datos** (`scripts/03_explorar_items_nse.R` → `salidas/nse_cobertura.csv` y
  `salidas/nse_items_frecuencias.csv`, 2026-10-16; solo describe los ítems, no estima nada):
  - 7.479 de 7.804 estudiantes tienen ≥ 3 respuestas válidas en los 29 indicadores (27 posesiones, `HISCED` y
    `HISEI`); 320 no tienen ninguna. Entre quienes cumplen, la mediana es 29 de 29 y 4.237 respondieron las 27
    posesiones.
  - De los 7.479: los 6.886 de la muestra analítica (D-14), los 573 con «menos de 10 vistos» y solo 20 de los 345
    sin ESCS. **Los 6.886 cumplen todos la regla.**
  - Lo que sigue se calcula sobre la muestra elegida para la F3, los 6.886 (punto 1).
  - Categorías con < 2 % de las respuestas válidas (todas en el extremo alto):
    - `ST254Q02JA`, computadores de escritorio: 2 = 1,87 % y 3 = 0,20 %;
    - `ST254Q03JA`, portátiles: 3 = 0,66 %;
    - `ST254Q04JA`, tabletas: 3 = 0,75 %;
    - `ST254Q05JA`, lectores de libros electrónicos: 2 = 1,54 % y 3 = 1,31 %;
    - `ST255Q01JA`, libros: 6 = 0,67 %.
  - `ST005`/`ST007` (educación de la madre y del padre) llegan solo a ISCED 3.4: el 38,2 % de las madres y el
    32,4 % de los padres están en ese tope. De los 3.249 estudiantes con al menos un padre en el tope, 2.289
    (70,5 %) tienen según `HISCED` un padre con educación terciaria (ISCED 5 a 8).
  - `HISEI` tiene 267 valores distintos; los 3 más frecuentes concentran el 18,9 %. Sus quintiles ponderados
    cortan en 17,55 / 29,18 / 39,02 / 68,77 y cada grupo queda con el 19,9–20,1 % del peso.
  - 262 colegios, con una mediana de 30 estudiantes (de 1 a 40); 128 tienen un número impar de estudiantes y 4
    tienen uno solo.
- **Propuesta:**
  1. **Muestra de la F3: los 6.886 de la muestra analítica (D-14)**, la misma de todo el proyecto (decisión de
     Vanessa, 2026-10-16). Todos tienen ≥ 3 respuestas válidas, la regla de la OCDE para sus escalas (Technical
     Report p. 384).
     - *Alternativa descartada:* los 7.479 que cumplen esa regla, es decir, además 573 con menos de 10 ítems de
       matemáticas vistos y 20 sin ESCS.
     - *Lo que implica:* el NSE se calibra en la misma población en que se usa en O3 y O4. Quedan fuera 593
       estudiantes que sí tienen datos de NSE, y así se declara.
  2. **Mitades:** exploración y confirmación, asignadas una sola vez a los 6.886, al azar **dentro de cada colegio**
     (`set.seed(2026)`, como dice el plan). En los colegios con número impar, el estudiante sobrante va a una
     mitad al azar.
     - *Por qué:* estratificar por colegio deja las dos mitades con la misma mezcla de colegios. Así, una
       diferencia entre mitades no puede deberse a que en una caigan más colegios de NSE alto.
     - La mitad queda guardada y la reutilizan la F4 a la F6; H5 también se prueba en la mitad de confirmación.
  3. **Indicadores (29):** las 27 posesiones, `HISCED` (10 categorías) y `HISEI` en quintiles ponderados, con los
     cortes de arriba calculados una vez sobre los 6.886.
     - No se usan `ST005`/`ST007`, por el tope en ISCED 3.4: confundiría a los padres con secundaria y con
       universidad.
     - No se usa `PAREDINT`: se deriva de `HISCED` (p. 387) y sería el mismo dato dos veces.
     - `HOMEPOS` y `ESCS` no son indicadores: son el criterio de validez del paso 3.5.
  4. **Categorías escasas:** una categoría con < 2 % de las respuestas válidas (sin ponderar, en los 6.886) se une
     con la vecina hacia el centro, repitiendo hasta que todas tengan ≥ 2 %. Con los datos de arriba cambian 5
     ítems: `ST254Q02JA`–`ST254Q05JA` quedan en 0–2 y `ST255Q01JA` queda en 0–5.
     - *Por qué:* con unas 3.400 personas por mitad, el 2 % son unas 69 respuestas. Con menos, la correlación
       policórica y los umbrales de la TRI se vuelven inestables.
     - La OCDE también agrupó categorías (p. 392), aunque con su propio criterio, que no conocemos.
  5. **Pesos:** `W_FSTUWT` normalizado para que sume el número de casos de cada análisis. Se aplica a la
     policórica y el AFE (3.2), la TRI (3.3) y el AFC (3.4).
     - Es proporcional al *senate weight* con que calibra la OCDE (p. 380), así que los parámetros describen a la
       población y no a la muestra.
     - Los errores estándar de `lavaan` y `mirt` así ponderados no tienen en cuenta que los estudiantes están
       agrupados en colegios. H1 se decide con estimaciones puntuales, así que eso no la afecta.
     - El AFC de H1 se repite sin pesos, solo como sensibilidad.
  6. **Faltantes, sin imputar:**
     - en la policórica, el AFE y el AFC (WLSMV), por pares (`missing = "pairwise"`);
     - en la TRI, con todas las respuestas disponibles de cada estudiante, que es lo que hace `mirt`.
     - El «No sé» ya es `NA` (D-12).
  7. **Estructura de 2 factores para H1, fijada aquí, antes de ver los datos:**
     - **cultural (12):** libros (`ST255Q01JA`), los 8 tipos de libros (`ST256`), instrumentos musicales
       (`ST251Q06JA`), obras de arte (`ST251Q07JA`) y `HISCED`;
     - **económico (17):** los 5 de `ST250`; carros, motos, baños y sanitarios (`ST251Q01`–`Q04JA`); dispositivos
       con pantalla (`ST253Q01JA`); los 6 de `ST254`; y `HISEI`.
     - El modelo de 1 factor pone los 29 en un solo factor.
     - *Criterio (decisión del equipo; no hay en el vault una clasificación oficial para 2022):*
       - cultural = bienes culturales (libros, arte, música) y educación de los padres;
       - económico = el resto de bienes materiales y tecnológicos, y la ocupación, que refleja la posición en el
         mercado laboral.
     - El AFE (3.2) se reporta tal como salga. Si sugiere otra estructura, se prueba también en la mitad de
       confirmación, pero como **exploratoria**: no decide H1.
  8. **CFI de H1:** `lavaan` da dos versiones para WLSMV (*scaled* y *robust*), y pueden diferir.
     - **H1 se acepta solo si las dos mejoran ≥ 0,01 al pasar de 1 a 2 factores** y la correlación entre factores
       es < 0,90, en el AFC ponderado de la mitad de confirmación. Si no, se rechaza.
     - Se reportan ambas versiones y la prueba sin pesos.
     - *Por qué:* fijarlo ahora impide escoger después el índice que más convenga.
  9. **TRI (3.3):** 2PL para los ítems Sí/No y GPCM para los politómicos, como la OCDE (p. 380), en los 6.886 y
     ponderada. Se estiman el modelo unidimensional, que es el enfoque de HOMEPOS, y el de 2 dimensiones con la
     estructura del punto 7.
     - Se comparan con AIC y BIC, y se reportan el ajuste de los ítems (S-X²) y las curvas de información.
     - Las puntuaciones EAP que pasan a la F4–F6 salen del modelo que se elija en la Puerta G2.
  10. **Validez (3.5):** correlación ponderada de las EAP con `HOMEPOS` y `ESCS` oficiales.
- **Salidas previstas:**
  - `scripts/03_nse_medicion.R` → `datos/COL_nse.rds` (mitad, indicadores recodificados y EAP; no va a Git);
  - `salidas/nse_parametros_tri.csv`, `salidas/nse_ajuste_afc.csv` y las figuras de información (plan).
- **Fuentes:** [[Literatura/oecd2024pisa2022tr]], afirmaciones 17–20 (pp. 380, 384, 386–387 y 391–392), y
  [[Literatura/avvisati2024measurement]] p. 11 (HOMEPOS es una escala TRI unidimensional). Todo `por_verificar`.
- **Resultado del paso 3.2** (`scripts/03_nse_medicion.R`, sección 3.2 → `salidas/nse_policorica_diagnostico.csv`,
  `nse_analisis_paralelo.csv`, `nse_afe_cargas.csv`, `nse_afe_ajuste.csv` y `nse_estructura_afe.csv`;
  mitad de exploración, n = 3.445, 2026-10-17; **cifras con D-20 completa**, libros y dispositivos, y con el entorno
  de D-17):
  - **Policórica:**
    - Sin suavizar tiene 1 autovalor negativo (−0,026). Pasa igual sin pesos (−0,026) y con solo casos completos
      (−0,036; n = 2.362), así que no lo causan las decisiones de D-16.
    - Se usó la matriz que `psych` suaviza. Queda casi singular, y por eso el RMSEA, el TLI y el BIC del AFE no se
      interpretan (el RMSR baja de 0,089 con 1 factor a 0,039 con 2).
    - No hay ítems duplicados: el par más alto es computador–portátiles (0,85).
  - **Análisis paralelo:** dominan 2 autovalores (10,12 y 3,16; el tercero es 0,66).
    - El criterio de factores sugiere 7 y el de componentes, 4.
    - El AFE de 3 factores solo agrega un «factor» de un ítem: motos (0,82).
    - Se lee como una estructura de 2 factores.
  - **AFE de 2 factores** (oblimin; correlación entre factores 0,47):
    - factor 1: las posesiones materiales y tecnológicas, `HISCED_c`, `HISEI_q`, obras de arte e instrumentos;
    - factor 2: los libros (`ST255` y los 8 `ST256`, con cargas de 0,69 a 0,85).
    - Coinciden con D-16 25 de 29 ítems. No coinciden `HISCED_c`, `ST251Q06JA` y `ST251Q07JA` (cultural en D-16,
      aquí económico; los instrumentos cargan 0,37 y 0,31 en los dos factores) ni `ST254Q05JA` (económico en D-16,
      aquí libros, con carga 0,29).
  - **Comunalidad < 0,20:** cuarto propio (`ST250Q01JA`, 0,19), motos (`ST251Q02JA`, 0,03) y lectores electrónicos
    (`ST254Q05JA`, 0,08).
  - Con la primera parte de D-20 (solo libros) las cifras eran casi iguales (autovalores 9,93 y 3,13). La asignación
    de los 29 ítems no cambió en ninguna de las tres versiones.
  - **Antes de D-20** (misma mitad, ST256 de quien no tiene libros como faltante):
    - autovalores 9,00 y 2,57; correlación entre factores 0,44;
    - 1.966 casos completos; cargas de los libros de 0,52 a 0,74.
    - **La asignación de los 29 ítems era la misma**: D-20 no cambió la estructura del AFE, solo la hizo más nítida.
  - **Qué implica (punto 7):**
    - H1 se sigue probando en el 3.4 con la estructura de D-16.
    - La estructura del AFE también se prueba en el 3.4, pero solo como **exploratoria**:
      - cultural (libros): los 9 de libros más `ST254Q05JA`, 10 ítems;
      - económico: los otros 19.

      Está en `salidas/nse_estructura_afe.csv`.
  - **Interpretación (equipo, por discutir):** en estos datos, la dimensión cultural que aparece sola es la de los
    libros en casa. La educación y la ocupación de los padres se comportan como el resto del NSE.
- **Estado:** ✅ aceptada por Vanessa (2026-10-16):
  - muestra de 6.886 (se propusieron los 7.479);
  - `HISEI` en el factor económico;
  - H1 con los dos CFI;
  - el resto tal cual.

  Mateo y Brayan la revisan en el PR.

### D-17 · 2026-10-17 · Versiones de R y de los paquetes, mientras se arma Docker
- **Problema:** los scripts se corren en máquinas con versiones distintas, y una diferencia de versión puede cambiar
  una salida sin que nadie toque el código (ver el BIC del 3.2 abajo). Versiones antes del 2026-10-17:

  | Paquete | Vanessa (según ella; binarios de CRAN para R 4.4) | Mateo (`00_verificar_entorno.R`) |
  |---|---|---|
  | `data.table` | 1.18.2.1 | 1.17.0 |
  | `haven` | 2.5.5 | 2.5.4 |
  | `survey` | 4.5 | 4.4-2 |
  | `psych` | 2.6.3 | 2.6.5 |
  | `GPArotation` | 2025.3-1 | 2026.8-2 |
  | `mirt` | 1.46.1 | 1.46.1 |
  | `lavaan` | 0.6-21 | 0.7-2 |
  | `semTools` | 0.5-8 | 0.5-9 |

- **Alternativas:**
  - (a) cada uno con sus versiones;
  - (b) `renv`: biblioteca propia del proyecto y `renv.lock`, que fija también las dependencias;
  - (c) un archivo con las versiones, una revisión al abrir el proyecto y una copia fechada de CRAN para instalarlas;
  - (d) Docker, todavía pendiente.
- **Decisión:** (c), mientras se arma (d).
  - `scripts/versiones_paquetes.csv`: R 4.4.1 y los 13 paquetes que usa el proyecto, con el repositorio de cada uno.
  - Las versiones son las de la copia de CRAN del 2026-10-17 en Posit Package Manager
    (`https://packagemanager.posit.co/cran/2026-10-17`), que trae binarios para R 4.4 en Windows, así que nadie
    compila. Los binarios del propio CRAN para R 4.4 están atrasados (ese día: `lavaan` 0.6-21, `data.table` 1.18.2.1).
  - **Excepción, `mirt` 1.46.1:** la última en CRAN es la 1.48, pero para R 4.4 en Windows solo existe como código
    fuente y hay que compilarla con Rtools. Queda en la última con binario para R 4.4.
  - `scripts/00_verificar_entorno.R` compara lo instalado con el archivo; con `--instalar` instala esas versiones
    (con RStudio cerrado).
  - `Proyecto_PISA/.Rprofile` corre la revisión al abrir `Proyecto_PISA.Rproj` en RStudio. Solo avisa: no instala ni
    cambia rutas. Antes carga el `~/.Rprofile` personal, porque R lee un solo `.Rprofile`.
  - *Por qué no (b) por ahora:* obliga a reinstalar todo en una biblioteca del proyecto, y Docker cumple esa función
    más adelante (interpretación del equipo).
- **Comprobación** (máquina de Mateo, 2026-10-17, R 4.4.1, después de `--instalar`):
  - `01a`, `01b`, `01c`, `02` y los dos `03` (paso 3.1) reproducen sus salidas sin cambios (`git status` limpio), y
    la Puerta G1 sigue pasando.
  - `01a` y `01b` usaron los cachés crudos: la lectura de los `.SAV` con `haven` 2.5.5 no se volvió a probar.
  - Paso 3.2: 7 de sus 8 salidas son idénticas. En `nse_afe_ajuste.csv`, el BIC del AFE de 1 factor pasa de
    89658,3 a 89658,4. Ese BIC no se interpreta. Vanessa lo confirma con `psych` 2.6.9.
  - *Máquina de Vanessa, 2026-10-17:*
    - instaló el entorno con `--instalar`, y R 4.4.1 y los 13 paquetes coinciden con el archivo;
    - el BIC antiguo ya no se puede comparar, porque D-20 cambió los datos del 3.2;
    - las salidas actuales de `03_nse_medicion.R` y `03_nse_tri.R` se generaron con este entorno, el mismo de Mateo.
- **Límites:** fija los paquetes, no sus dependencias. El `.Rprofile` no corre con Rscript desde `scripts/`: ahí se
  corre `00_verificar_entorno.R` a mano. Docker resuelve las dos cosas.
- **Para actualizar:** se cambia la fecha de la copia y las versiones del archivo en un PR, y se vuelve a correr la
  cadena.
- **Estado:** ✅ propuesta por Mateo y aprobada por Vanessa en el PR #10 (2026-10-17); falta la revisión de Brayan.

### D-19 · 2026-10-17 · Detalles de la TRI del NSE que D-16 no fija (pasos 3.3 y 3.5)
- **Problema:** D-16 (punto 9) fija los modelos: 2PL + GPCM, unidimensional y bidimensional, ponderados,
  comparados con AIC/BIC, con el ajuste de los ítems (S-X²) y las curvas de información. Quedan detalles técnicos
  que cambian lo que se reporta. D-17 y D-18 las reservó Mateo (entorno de R y detalles del 3.4).
- **Lo que muestran el software y los datos** (`mirt` 1.46.1, la misma versión del entorno que propone Mateo):
  - `itemfit()` no recibe pesos ni imputa faltantes, y el S-X² exige casos completos (`na.rm = TRUE`);
  - en la mitad de exploración solo el 57 % tiene los 29 indicadores (1.966 de 3.445,
    `salidas/nse_policorica_diagnostico.csv`). Estos faltantes vienen **sobre todo de los saltos del cuestionario**:
    a quien no tiene libros no se le preguntan los tipos de libros (D-20). *Corrección del 2026-10-17: antes decía
    «sobre todo por los "No sé"», un error de Claude;*
  - `testinfo()` admite `degrees`, que da la información a lo largo de cada eje en un modelo de 2 dimensiones.
- **Propuesta:**
  1. **Script aparte, `03_nse_tri.R`, para los pasos 3.3 y 3.5.** Lee `datos/COL_nse.rds`; así no se reestiman los
     modelos cada vez que se corren el 3.1 y el 3.2. El plan preveía un solo `03_nse_medicion.R`.
  2. **Tres modelos en los 6.886**, los mismos tres del AFC de Mateo:
     - 1 dimensión, el enfoque de HOMEPOS;
     - 2 dimensiones con la estructura de D-16, la de H1;
     - 2 dimensiones con la estructura del AFE (`salidas/nse_estructura_afe.csv`), solo exploratoria.

     Los factores tienen media 0 y varianza 1, y la correlación entre ellos es libre.
  3. **Pesos** normalizados a 6.886 (`survey.weights`, D-16). No se calculan errores estándar de los parámetros,
     porque no reflejarían el diseño por colegios: se reportan estimaciones puntuales.
  4. **Comparación** con AIC, BIC y log-verosimilitud. Con pesos es una pseudo-verosimilitud, así que la
     comparación es descriptiva y no una prueba.
  5. **Ajuste de los ítems:** S-X² con `itemfit()` en los casos completos y sin pesos, porque la función no los
     admite. Se reportan el p ajustado por Benjamini-Hochberg y el RMSEA del S-X².
     - Se señala un ítem como problemático si p ajustado < 0,05 **y** RMSEA del S-X² > 0,05.
     - Esa regla es una convención del equipo, sin fuente en el vault: con miles de casos, el p solo casi siempre
       rechaza.
  6. **Información y confiabilidad:**
     - curva de información del test en θ de −4 a 4 para el modelo de 1 dimensión, y a lo largo de cada eje
       (económico y cultural) para los de 2;
     - confiabilidad marginal (`marginal_rxx`) o empírica de las EAP por dimensión;
     - tablas CSV y figuras PNG.
  7. **Puntuaciones EAP** de los tres modelos en `datos/COL_nse_tri.rds` (no va a Git). Cuál pasa a la F4–F6 se
     decide en la Puerta G2 (D-16).
  8. **Validez (3.5):** correlación ponderada (peso final) de cada EAP con `HOMEPOS` y `ESCS` oficiales.
- **Resultado de los pasos 3.3 y 3.5** (`scripts/03_nse_tri.R` → `salidas/nse_ajuste_tri.csv`,
  `nse_parametros_tri.csv`, `nse_tri_cargas_2d.csv`, `nse_itemfit_tri.csv`, `nse_informacion_tri.csv` y `.png`,
  `nse_confiabilidad_tri.csv` y `nse_validez.csv`; 6.886 estudiantes; 2026-10-17; con D-20 completa y el entorno de
  D-17):
  - **Convergencia:** los tres modelos convergieron. El de 2 dimensiones de D-16 necesitó 811 iteraciones del EM.
  - **Comparación** (descriptiva, punto 4):
    - AIC de 344.517 (1D), 329.821 (2D de D-16) y 327.986 (2D del AFE); el BIC sigue el mismo orden;
    - correlación entre factores: 0,50 (D-16) y 0,48 (AFE);
    - la estructura del AFE salió de la mitad de exploración, que también está aquí, así que tiene ventaja. **H1 se
      decide en el 3.4.**
  - **Modelo de 1 dimensión:**
    - lo dominan los libros (*a* de 1,27 a 1,61 en ST255 y ST256), junto con computador y portátiles (1,56);
    - los que menos discriminan son motos (*a* = 0,09), `HISCED_c` (0,19), lectores electrónicos (0,34) y
      `HISEI_q` (0,41).
  - **Ajuste de los ítems:** S-X² en 4.672 casos completos (68 %), sin pesos.
    - Entre 24 y 27 de los 29 ítems tienen p ajustado < 0,05, como era de esperar con miles de casos.
    - El RMSEA del S-X² es ≤ 0,027 en todos; el más alto es el de diccionarios (`ST256Q09JA`) en el modelo de D-16.
    - Con la regla del punto 5, **ningún ítem es problemático** en ninguno de los tres modelos.
  - **Información ≥ 4** (error estándar ≤ 0,5):
    - 1D: θ de −2,3 a 3,5 (máximo 20,6 en θ = 1,6);
    - económico: de −2,2 a 2,7 (D-16) o a 2,9 (AFE), con máximo cercano a 10 en θ ≈ −0,3;
    - cultural: de −1,5 a 2,7 (D-16) o a 2,6 (AFE), con máximo de 32 a 33 en θ = 1,4.
  - **Confiabilidad:** 0,92 en 1D (marginal y empírica) y de 0,89 a 0,91 en las dimensiones de 2D.
  - **Validez (3.5), correlación ponderada:**

    | Puntuación | Con HOMEPOS | Con ESCS |
    |---|---|---|
    | 1D | 0,91 | 0,74 |
    | Económico, D-16 | 0,96 | 0,77 |
    | Económico, AFE | 0,96 | 0,81 |
    | Cultural, D-16 | 0,65 | 0,51 |
    | Cultural, AFE | 0,62 | 0,47 |

  - **Interpretación (equipo, por discutir en la Puerta G2):**
    - el factor económico es casi el mismo índice de posesiones de la OCDE;
    - el cultural (libros) mide con mucha precisión por encima del promedio, pero poco en el extremo bajo: quienes
      no tienen libros quedan todos en el piso;
    - el factor económico es el que mide en un rango más amplio, también el NSE bajo.
- **Estado:** ✅ aceptada por Vanessa (2026-10-17), tal cual: S-X² en casos completos e incluido el modelo exploratorio
  del AFE. Mateo la revisa en el PR.

### D-20 · 2026-10-17 · Los saltos del cuestionario en los indicadores del NSE valen 0, no faltante: tipos de libros (ST256) y dispositivos (ST254) (F3)
- **Problema:** D-12 convierte en `NA` todo faltante de usuario, incluido el «Valid Skip» (código 95). El cuestionario
  salta las 8 preguntas de tipos de libros (ST256) cuando el estudiante dice que no hay libros en casa (ST255).
  Esos estudiantes quedaban con 8 faltantes que en realidad son «ninguno». El problema apareció de dos formas:
  - **S-X² (D-19):** en los casos completos no quedaba nadie sin libros, ni nadie con 0 dispositivos (`ST253Q01JA`).
    El S-X² no se pudo calcular: «S_X2 cannot be computed… less than the full range of possible response options».
  - **Policórica y AFE (3.2, por pares):** las correlaciones de los ítems de tipos de libros se calcularon solo
    entre quienes tienen libros.
- **Dato** (`scripts/03_explorar_saltos.R` → `salidas/nse_saltos_st256.csv` y `salidas/nse_saltos_st254.csv`;
  Colombia, 7.804; el script se llamaba `03_explorar_saltos_st256.R` antes de la ampliación):
  - **libros:** los 1.095 estudiantes con ST255 = «There are no books» tienen ST256 = 95 («Valid Skip») en los 8
    ítems. En las 8 preguntas hay 9.176 celdas con salto válido, 2.289 «I don't know» y 1.817 sin respuesta;
  - **dispositivos:** los 204 estudiantes con ST253 = «There are no digital devices with screens» tienen ST254 = 95
    en los 6 ítems (televisores, computadores de escritorio, portátiles, tabletas, lectores y celulares). En las 6
    preguntas hay 1.338 celdas con salto válido, 227 «I don't know» y 1.056 sin respuesta.
- **Decisión** (Vanessa, 2026-10-17):
  - en el paso 3.1, si ST255 = «no hay libros», cada ítem ST256 vale 0 («None»);
  - **ampliación**, el mismo día: si ST253 = «no hay dispositivos con pantalla», cada ítem ST254 vale 0 («None»).
    Se decidió cuando la TRI repetida con la primera parte de D-20 mostró que el S-X² seguía sin poder calcularse
    porque no quedaba ningún caso completo con 0 dispositivos;
  - los demás faltantes siguen como `NA`: el «I don't know» (D-12) y los saltos de quien no respondió la pregunta
    filtro;
  - D-12 no cambia para los cachés de `01b`; D-20 se aplica solo a los indicadores del NSE (F3).
- **Por qué** (interpretación del equipo): sin libros (o sin dispositivos) en casa, la cantidad de cada tipo es
  «ninguno». Es un valor que se deduce de la pregunta filtro, no un dato que falta. **No verificado:** cómo lo trata la OCDE en
  HOMEPOS, porque la tabla 19.A.17 del Technical Report no viene en el PDF.
- **Consecuencias:**
  - se repiten el 3.1 (solo cambian los ST256 y los ST254), el 3.2 (policórica, AFE y estructura del AFE) y la
    TRI (3.3);
  - la regla del 2 % (D-16 punto 4) se aplica igual sobre los datos corregidos y ahora une también una categoría
    de `ST256Q01JA` (libros religiosos):
    - con los 1.002 ceros de la muestra analítica, «más de 10» queda en 120 respuestas (1,85 %);
    - se une con «6 a 10», y juntas suman 366 (5,63 %) (`salidas/nse_recodificacion.csv`);
    - con la ampliación a los dispositivos, también une una categoría de `ST254Q01JA` (televisores): «más de 5»
      queda en 132 respuestas (1,95 %) y se une con «3 a 5» (juntas, 1.707; 25,19 %). La categoría unida de
      `ST254Q02JA` (computadores de escritorio) queda en 2,01 %, justo por encima del límite;
    - quedan 7 ítems con categorías unidas;
  - el resultado del 3.2 en D-16 se actualiza y se deja constancia del anterior;
  - **los puntos 7 y 8 de D-16 (estructura y regla de H1) no cambian**;
  - Mateo corre el 3.4 con los datos ya corregidos.
- **Estado:** ✅ aceptada por Vanessa (2026-10-17). Mateo la revisa en el PR (afecta los datos de su 3.4).
