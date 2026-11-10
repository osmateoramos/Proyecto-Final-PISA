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
- **Estado:** ✅ cerrada en D-27 (2026-10-18). Se usan las dos, (a) y (b), y además una tercera sensibilidad.
  - La omisión rápida es la que tarda menos del 10 % del tiempo **medio** del ítem en Colombia (NT10, sin tope).
  - ~~El script de revisión usaba la mediana~~: era un error, ver [[11 Protocolo de verificación]].

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
- **Estado:** ✅ (a) aceptada por Vanessa (2026-10-18): `CMA112Q02S` se excluye, como en la OCDE. Quedan 232 ítems
  calibrables (paso 5.1).

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
    - No hay ítems duplicados: el par más alto es computador–portátiles (~~0,85~~ 0,84: `ST250Q02JA`–`ST254Q03JA`,
      0,836 en `salidas/nse_policorica_exploracion.csv`). *Corregido el 2026-10-18: el 0,85 no coincidía con la
      salida vigente y no se sabe de qué corrida salió (error de Claude).*
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

  Mateo y Brayan la revisan en el PR. Revisada por Mateo (2026-11-10): de acuerdo.

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
  - *Cadena completa, 2026-10-18 (máquina de Vanessa):*
    - `scripts/00_correr_todo.R` corrió los 9 scripts, de `01a_explorar_faltantes_cog.R` a `03_nse_tri.R`, en
      7,7 min;
    - `salidas/` quedó idéntica al commit `4297fe5`;
    - `01a_explorar_faltantes_cog.R`, `03_explorar_items_nse.R` y `03_explorar_saltos.R` leyeron los `.SAV` con
      `haven` 2.5.5, así que esa lectura ya está probada;
    - `01a` y `01b` usaron sus cachés crudos;
    - la única diferencia fue la fecha que `01b` escribe en [[Datos/PISA2022 - Variables recodificadas]]; el
      contenido se reprodujo igual.
- **Límites:** fija los paquetes, no sus dependencias. El `.Rprofile` no corre con Rscript desde `scripts/`: ahí se
  corre `00_verificar_entorno.R` a mano. Docker resuelve las dos cosas.
- **Para actualizar:** se cambia la fecha de la copia y las versiones del archivo en un PR, y se vuelve a correr la
  cadena.
- **Estado:** ✅ propuesta por Mateo y aprobada por Vanessa en el PR #10 (2026-10-17); falta la revisión de Brayan.

### D-18 · 2026-10-18 · Reglas del AFC en la mitad de confirmación (paso 3.4, H1)
- **Problema:** D-16 fija la estructura y la regla de H1 (puntos 7 y 8), pero no cómo se especifica y se reporta el
  AFC. Tampoco dice qué hacer si el ajuste no llega a los cortes de la Puerta G2 (CFI ≥ 0,95, RMSEA ≤ 0,06,
  SRMR ≤ 0,08), algo probable con 29 indicadores ordinales. Se fija aquí, **antes de correrlo**, para no ajustar el
  modelo después de ver el resultado.
- **Quién:** Mateo había reservado este número para el 3.4. Para avanzar, el 3.4 lo hace Vanessa y Mateo lo revisa
  en el PR.
- **Lo que muestra el software** (prueba con datos simulados, 2026-10-18; `lavaan` 0.7-3 y `semTools` 0.5-10, las de
  D-17):
  - `cfa()` con WLSMV acepta a la vez `ordered`, `sampling.weights` y `missing = "pairwise"`;
  - `lavTestLRT()` hace la prueba de diferencia escalada (método `satorra.2000` en la salida de `lavaan`);
  - `compRelSEM()` da el omega de cada factor con indicadores ordinales;
  - se pueden agregar residuos correlacionados entre indicadores ordinales.
- **Regla:**
  1. **Datos:** la mitad de confirmación (3.441) de `datos/COL_nse.rds`, con D-20 completa. Los 29 indicadores entran
     como ordinales.
  2. **Modelos:**
     - M1: 1 factor con los 29;
     - M2: 2 factores con la estructura de D-16 (cultural 12, económico 17);
     - M2-AFE: la estructura de `salidas/nse_estructura_afe.csv`, solo exploratoria.

     Factores con varianza 1 (`std.lv = TRUE`) y correlación libre; parametrización delta, la de `lavaan` por defecto.
  3. **Estimación:** WLSMV, `W_FSTUWT` normalizado a 3.441 (D-16 punto 5) y faltantes por pares (D-16 punto 6).
  4. **H1 se decide con M1 y M2 puros:** sin residuos correlacionados y sin índices de modificación. Se aplica la regla
     de D-16 punto 8: CFI *scaled* y *robust* mejoran los dos ≥ 0,01 de M1 a M2, y la correlación entre factores es
     < 0,90.
  5. **Se reporta:**
     - χ² escalado (se espera que rechace con n ≈ 3.400);
     - CFI, TLI y RMSEA, en versión *scaled* y *robust* (RMSEA con IC 90 %), y SRMR;
     - `lavTestLRT(M1, M2)`, que no decide H1;
     - correlación entre factores, cargas estandarizadas y omega por factor (`compRelSEM()`).

     Los errores estándar de `lavaan` no reflejan el diseño por colegios (D-16 punto 5): se usan las estimaciones
     puntuales.
  6. **Sensibilidades:**
     - (a) sin pesos (D-16);
     - (b) **exploratoria:** M1 y M2 con 10 residuos correlacionados, fijados hoy, entre ítems cuyo contenido se
       superpone:
       - `ST250Q02JA` (computador para tareas: portátil, de escritorio o tableta) con `ST254Q02JA` (computadores de
         escritorio), `ST254Q03JA` (portátiles) y `ST254Q04JA` (tabletas);
       - `ST250Q04JA` (celular propio con internet) con `ST254Q06JA` (celulares con internet);
       - `ST253Q01JA` (número de dispositivos con pantalla) con cada uno de los 6 `ST254`.

       Sirve para saber cuánto del desajuste viene de esa superposición. No decide H1.
  7. **Puerta G2:** el modelo pasa si cumple los tres cortes del plan. Si no, se documenta qué índice falla, cuánto
     mejora con la sensibilidad (b) y cuáles son los 10 residuos de correlación más grandes. El modelo de H1 no se
     modifica sin una decisión nueva.
     - *Aclaración (2026-10-18, antes de correr el 3.4):* como en H1 (D-16 punto 8), los cortes de CFI y RMSEA deben
       cumplirse en las dos versiones, *scaled* y *robust*. El SRMR tiene una sola versión. Se reportan las dos y se
       dice con cuál se cumple cada corte.
  8. **Problemas de estimación** (no convergencia, varianzas residuales negativas, matriz no definida positiva): se
     reportan tal cual y se resuelven con una decisión registrada.
- **Salidas previstas:** `scripts/03_nse_afc.R` → `salidas/nse_ajuste_afc.csv`, `salidas/nse_cargas_afc.csv` y
  `salidas/nse_omega_afc.csv`.
- **Estado:** ✅ aceptada por Vanessa (2026-10-18): H1 con los modelos puros y la sensibilidad (b). Mateo la revisa en el PR. Revisada por Mateo (2026-11-10): de acuerdo.
- **Resultado del 3.4** (`scripts/03_nse_afc.R` → `salidas/nse_ajuste_afc.csv`, `nse_h1_afc.csv`,
  `nse_cargas_afc.csv`, `nse_omega_afc.csv` y `nse_residuos_afc.csv`; mitad de confirmación, n = 3.441;
  2026-10-18; los 7 modelos convergieron y `lavaan` no dio avisos):
  - **H1 se acepta** (D-16 punto 8, con pesos).
    - De M1 a M2, el CFI *scaled* sube 0,107 y el *robust*, 0,218. La correlación entre factores es 0,559, menor que
      0,90.
    - La prueba de diferencia (`lavTestLRT`), que no decide H1, da Δχ² = 1.220,5 con 1 gl.
    - Se mantiene sin pesos (ΔCFI de 0,116 y 0,196; r = 0,577) y con la estructura del AFE (0,129 y 0,240;
      r = 0,523).
  - **Puerta G2: ningún modelo cumple los tres cortes en las dos versiones.**

    | Modelo | CFI *scaled* / *robust* | RMSEA *scaled* / *robust* | SRMR |
    |---|---|---|---|
    | M1, 1 factor | 0,814 / 0,514 | 0,108 / 0,160 | 0,137 |
    | **M2, D-16 (H1)** | **0,921 / 0,731** | **0,071 / 0,119** | **0,087** |
    | M2-AFE, exploratorio | 0,943 / 0,753 | 0,060 / 0,114 | 0,071 |
    | M2 sin pesos | 0,911 / 0,710 | 0,081 / 0,124 | 0,083 |
    | M2 con los 10 residuos (b) | 0,931 / 0,779 | 0,067 / 0,109 | 0,084 |

    - M2-AFE cumple el SRMR y el RMSEA *scaled* (0,0599), pero no el CFI ni las versiones *robust*.
    - Las versiones *robust* dan siempre un ajuste mucho peor que las *scaled*.
    - Con M1 más los 10 residuos, `lavaan` no pudo calcular los índices *robust* (NaN o Inf); el CFI *scaled* es
      0,844. Se reporta tal cual (D-18 punto 8).
  - **Sensibilidad (b):** los 10 pares fijados de antemano mejoran poco a M2: el CFI sube 0,010 (*scaled*) y 0,048
    (*robust*), y el SRMR baja 0,003. La superposición de esos ítems no explica el desajuste.
  - **De dónde viene el desajuste** (los 10 residuos más grandes de M2, `salidas/nse_residuos_afc.csv`):
    - educación y ocupación de los padres (`HISCED_c`–`HISEI_q`, 0,384). En D-16 están en factores distintos; el
      Q3 del 3.3b también los marcó (0,350);
    - residuos negativos entre lo digital y la vivienda: computador para tareas con sanitarios (−0,256) y con baños
      (−0,216), y software educativo con sanitarios (−0,203);
    - residuos positivos entre celular propio e internet (0,216), tabletas y lectores electrónicos (0,212), y
      computador para tareas y software educativo (0,205);
    - `HISCED_c` con dos tipos de libros (−0,231 y −0,213);
    - cargas muy bajas: motos (0,08), lectores electrónicos (0,19) y cuarto propio (0,37).
    - *Interpretación (equipo, por discutir en la G2):* el factor económico mezcla por lo menos lo digital y la
      vivienda, y la educación de los padres no se comporta como «cultural». Es coherente con el AFE del 3.2 y con el
      Q3 del 3.3b. Probar otra estructura con estos mismos datos ya sería exploratorio.
  - **Omega** (`salidas/nse_omega_afc.csv`):
    - M2: económico 0,925 y cultural 0,936;
    - M2-AFE: económico 0,888 y libros 0,929;
    - M1: 0,978.
  - **Cargas de M2** (`salidas/nse_cargas_afc.csv`):
    - cultural: libros de 0,74 a 0,88; arte 0,60, instrumentos 0,58 y `HISCED_c` 0,43;
    - económico: de 0,08 (motos) a 0,85 (computador para tareas).
  - **Qué falta:** la reunión de la G2 decide qué modelo pasa a la F4–F6 (D-16 punto 9), con este desajuste
    documentado.

### D-19 · 2026-10-17 · Detalles de la TRI del NSE que D-16 no fija (pasos 3.3 y 3.5)
- **Problema:** D-16 (punto 9) fija los modelos: 2PL + GPCM, unidimensional y bidimensional, ponderados,
  comparados con AIC/BIC, con el ajuste de los ítems (S-X²) y las curvas de información. Quedan detalles técnicos
  que cambian lo que se reporta. D-17 y D-18 las reservó Mateo (entorno de R y detalles del 3.4).
- **Lo que muestran el software y los datos** (`mirt` 1.46.1, la misma versión del entorno que propone Mateo):
  - `itemfit()` no recibe pesos ni imputa faltantes, y el S-X² exige casos completos (`na.rm = TRUE`);
  - en la mitad de exploración solo el 57 % tiene los 29 indicadores (1.966 de 3.445, cifra de antes de D-20;
    con D-20 completa, `salidas/nse_policorica_diagnostico.csv` da 2.362, el 69 %; aclarado el 2026-10-18). Estos faltantes vienen **sobre todo de los saltos del cuestionario**:
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
  - **Corrección (2026-10-18, error de Claude):** `salidas/nse_tri_cargas_2d.csv` está mal.
    - La columna `carga_CUL` sale en 0 en todos los ítems, y el `h2` de los ítems culturales también.
    - El factor cultural sí está estimado: en `datos/COL_nse_tri_modelos.rds`, la pendiente cultural de `ST255Q01JA`
      es 2,942 (D-16) y 2,976 (AFE).
    - `summary()` de `mirt` 1.46.1 devuelve 0 en esa columna en los dos modelos de 2 dimensiones, también con
      `rotate = "none"`, y el script no lo comprobó.
    - Ninguna cifra de esta decisión sale de ese archivo.
    - **Corregido el mismo día.**
      - *Causa:* un error de la función interna `Lambdas()` de `mirt` 1.46.1. En los ítems GPCM multiplica la carga
        por el signo de la pendiente del factor 1, que vale 0 en los ítems que solo cargan en el factor 2.
      - *Arreglo:* `03_nse_tri.R` calcula ahora las cargas con la misma fórmula, pero usa el signo de la pendiente que
        no es 0. Comprueba que el resultado coincide con `summary()` donde `mirt` no falla: todo el modelo 1D y los
        ítems del factor económico.
      - *Cargas culturales corregidas* (`salidas/nse_tri_cargas_2d.csv`): libros de 0,92 a 0,98 en los dos modelos;
        en el cultural de D-16, instrumentos 0,63, arte 0,51 y `HISCED_c` 0,26.
      - Las demás salidas del script se reprodujeron idénticas.
  - **Convergencia:** los tres modelos convergieron. El de 2 dimensiones de D-16 necesitó 811 iteraciones del EM.
  - **Comparación** (descriptiva, punto 4):
    - AIC de 344.517 (1D), 329.821 (2D de D-16) y 327.986 (2D del AFE); el BIC sigue el mismo orden;
    - correlación entre factores: 0,50 (D-16) y 0,48 (AFE);
    - la estructura del AFE salió de la mitad de exploración, que también está aquí, así que tiene ventaja. **H1 se
      decide en el 3.4.**
  - **Modelo de 1 dimensión:**
    - lo dominan los libros (*a* de 1,27 a 1,61 en ST255 y ST256), junto con computador y portátiles (1,56);
    - ~~los que menos discriminan son motos (*a* = 0,09), `HISCED_c` (0,19), lectores electrónicos (0,34) y
      `HISEI_q` (0,41).~~ *Corregido el 2026-10-18 (error de Claude):* las *a* de un 2PL y de un GPCM con distinto
      número de categorías no se pueden comparar entre sí. Con la información de cada ítem (área bajo su curva en θ de
      −4 a 4; columnas `info_1D` y `pct_info_1D` de `salidas/nse_parametros_tri.csv`):
      - los que menos aportan son motos (0,06 % de la información), lectores electrónicos (0,30 %), cuarto propio
        (0,55 %) y celular propio con internet (1,19 %);
      - los 9 ítems de libros aportan el 55,8 %; después siguen portátiles y número de dispositivos, con 4,1 % cada
        uno.
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
  del AFE. Revisada por Mateo (2026-11-10): de acuerdo.

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
- **Estado:** ✅ aceptada por Vanessa (2026-10-17). Mateo la revisa en el PR (afecta los datos de su 3.4). Revisada por Mateo (2026-11-10): de acuerdo.

### D-21 · 2026-10-18 · Mejoras P1–P6 de la nota 14 y dependencia local en la TRI del NSE (P1, F3)
- **Problema:** [[14 Libros de TRI y SEM]] propuso el 2026-10-05 siete mejoras al plan (P1–P7) y nadie las había
  aprobado ni rechazado. P1, revisar la dependencia local, estaba prevista para el paso 3.3, que se hizo sin ella.
- **Por qué importa ahora:** D-20 deja a los 1.002 estudiantes sin libros de la muestra analítica con 0 en los 9 ítems
  de libros a la vez (`ST255` y los 8 `ST256`; `salidas/nse_recodificacion.csv`). Hay tres señales compatibles con
  dependencia local, aunque no la prueban:
  - la información del factor cultural llega a 32–33 en θ = 1,4 (`salidas/nse_informacion_tri.csv`);
  - las cargas de los libros en el AFE subieron de 0,52–0,74 a 0,69–0,85 con D-20 (resultado del 3.2 en D-16);
  - el computador para tareas y los portátiles correlacionan 0,836 (`salidas/nse_policorica_exploracion.csv`).

  Si se viola la independencia condicional, la información se sobreestima (de Ayala, p. 131; por verificar).
- **Decisión** (Vanessa, 2026-10-18): se aprueban P1 a P6 de la nota 14, porque tienen sentido teórico y
  metodológico. P7 (SEM multinivel) queda opcional para la F7. Cada una entra al plan en su fase:
  - P1: F3 (paso 3.3b, ahora) y F5.3;
  - P2: F5.2 y F7;
  - P3: F5.5;
  - P4: F4.4, F5.6 y H3 (la magnitud está en D-22);
  - P5: D-05 y F5.7 (H4 no cambia);
  - P6: F4.1 y el paso nuevo F4.5.
- **Regla de P1 en la F3:**
  1. Q3 de Yen (`residuals(m, type = "Q3")` de `mirt`) en los tres modelos de D-19, en los 6.886.
     - Sin pesos, porque la función no los admite, igual que `itemfit()`.
     - Con todas las respuestas disponibles: la prueba con datos simulados del 2026-10-18 mostró que admite
       faltantes.
  2. Se marca un par con |Q3| > 0,2: de Ayala (p. 134) lo atribuye a Yen (1993) para instrumentos de al menos 17
     ítems, y aquí son 29. Como referencia, el Q3 esperado bajo independencia es −1/(L − 1) = −0,036 con L = 29
     (p. 133). Las dos páginas están por verificar
     ([[Literatura/deayala2009theory]]).
  3. Se reportan todos los pares, los marcados y un resumen por bloque: libros, dispositivos y el resto.
  4. Es **exploratorio**: H1 no cambia. Si hay pares marcados, en la G2 se discute un modelo alternativo (un
     *testlet* o sumar los ítems dependientes como un solo ítem politómico, como dice P1), que necesitaría una
     decisión nueva.
- **Salida prevista:** `scripts/03_nse_tri.R` (sección 3.3b) → `salidas/nse_q3_tri.csv`.
- **Estado:** ✅ aceptada por Vanessa (2026-10-18). Revisada por Mateo (2026-11-10): de acuerdo.
- **Resultado del 3.3b** (`scripts/03_nse_tri.R` → `salidas/nse_q3_tri.csv`; 6.886 estudiantes, sin pesos;
  2026-10-18; 406 pares por modelo):

  | Modelo | Pares con \|Q3\| > 0,2 | Rango del Q3 |
  |---|---|---|
  | 1 dimensión | 69 | −0,339 a 0,571 |
  | 2 dimensiones de D-16 | 10 | −0,284 a 0,463 |
  | 2 dimensiones del AFE | 13 | −0,266 a 0,463 |

  - **Modelo de 1 dimensión:** 6 pares positivos dentro de los libros, 50 negativos entre un ítem de libros y otro que
    no lo es, y 13 positivos sin libros.
    - Es el patrón que describe de Ayala (p. 133, citando a Yen, 1984) cuando se usa un modelo de una dimensión y
      hacen falta dos: dependencia positiva entre los ítems de la misma dimensión y negativa entre dimensiones.
    - Es evidencia **exploratoria** a favor de 2 dimensiones. H1 se decide en el 3.4.
  - **Modelos de 2 dimensiones:** la dependencia casi desaparece (10 y 13 de 406 pares).
    - Dentro de los libros ya no hay pares positivos. Los marcados son negativos: `ST255Q01JA` con varios `ST256`,
      de −0,21 a −0,27. Esos negativos no tienen explicación por ahora.
    - La sospecha de la revisión del 2026-10-18 no se confirma: no aparece dependencia **positiva** que infle la
      información del factor cultural.
    - *Interpretación:* el pico de información (32–33) viene de las cargas muy altas de los libros (0,92 a 0,98).
  - **Pares marcados en el modelo de D-16 (H1):**
    - positivos: baños y sanitarios (`ST251Q03JA`–`ST251Q04JA`, 0,463); educación y ocupación de los padres
      (`HISCED_c`–`HISEI_q`, 0,350); computador para tareas y software educativo (`ST250Q02JA`–`ST250Q03JA`, 0,203);
    - negativos: computador para tareas con celulares (−0,284) y con el número de dispositivos (−0,267); computadores
      de escritorio y portátiles (−0,228); `ST255Q01JA` con 4 de los `ST256` (−0,219 a −0,244).
    - *Interpretación (equipo, por discutir):* baños y sanitarios preguntan casi lo mismo, y la educación y la ocupación
      comparten la posición de los padres. Escritorio y portátil parecen sustituirse.
  - **Los 10 pares de la sensibilidad (b) de D-18 se fijaron antes de ver este Q3** (commit `e5cb408`) y no se cambian.
    Si en la G2 se quiere probar los pares que marcó el Q3, se registra como análisis exploratorio posterior a los
    datos.
  - **Para la G2:** no hace falta un modelo de *testlet* para los libros. Los pares con dependencia positiva
    (baños–sanitarios y educación–ocupación) se reportan como limitación: en ellos la información se sobreestima un
    poco (de Ayala, p. 131).

### D-22 · 2026-10-18 · Definiciones operativas de H2 a H7 (las hipótesis no cambian)
- **Problema:** desde el congelamiento (2026-10-12) hay términos sin definir:
  - «efecto no despreciable» en H2 y H3; lo señalaron Brayan ([[17 Plan de trabajo Brayan]], sección 4, 2026-10-12) y
    la P4 de la nota 14;
  - en H4, las unidades de la brecha y qué prueba hace «significativa» la reducción;
  - en H7, cómo se calcula la correlación;
  - H5 y H6 suponen un NSE de una dimensión, y la G2 puede elegir dos.

  Se definen aquí **antes de estimar cualquier modelo de la F4 a la F6**: no se ha visto ningún resultado de esas
  fases. Las hipótesis de [[09 Hipótesis preregistradas]] no cambian; se les agrega esta definición.
- **Definiciones** (Vanessa, 2026-10-18):
  - **Efecto no despreciable (H2 y H3):**
    - Ítems dicotómicos de matemáticas (H3): categoría B o C de la clasificación del ETS, es decir, prueba MH
      significativa y |ΔMH| > 1, con ΔMH = −2,35 ln(α_MH). Las categorías son A (no significativa o |ΔMH| ≤ 1),
      B (1 < |ΔMH| ≤ 1,5) y C (|ΔMH| > 1,5). Fuente: [[Literatura/calderon2026differential]], p. 8, y
      [[Literatura/celik2025differential]], p. 643. En las dos notas, Vanessa verificó las filas 1 y 2; la fila 3,
      con estos cortes, está por verificar.
    - Ítems ordinales de posesiones (H2) e ítems de crédito parcial de matemáticas: ΔR² ≥ 0,035 (niveles B o C) de
      Jodoin y Gierl (2001), citados por [[Literatura/kucam2023examination]], p. 130 (por verificar). *Matiz:* de
      Ayala (p. 334) dice que esos cortes se propusieron para el R² de mínimos cuadrados ponderados; el tipo de R² se
      fija en la decisión de la F4.
    - Con el diseño adaptativo, el emparejamiento se hace con el θ de la TRI, no con el puntaje total. El estimador
      exacto (estratos y depuración de anclas, P4) se fija en las decisiones de la F4 y la F5, antes de correrlas.
    - En H3, un ítem cuenta si su prueba TRI es significativa con Benjamini-Hochberg al 5 % **y** su efecto es no
      despreciable.
  - **H4:**
    - la brecha Q4 − Q1 se expresa en desviaciones estándar: diferencia de medias dividida por la DE ponderada del
      puntaje con la calificación (a), omitida = incorrecta, en cada competencia;
    - la reducción es la brecha con (a) menos la brecha con (b), omisión rápida = faltante. «≥ 0,05 DE» se aplica a
      esa diferencia;
    - «significativa» quiere decir que el IC 95 % bilateral de la diferencia excluye 0. Se calcula con las 80 réplicas
      BRR (Fay 0,5) y los 10 PV (Rubin), con los mismos estudiantes en las dos calificaciones;
    - **por decidir antes de la F5:** si H4 exige las cuatro competencias o basta una, con corrección por
      multiplicidad.
  - **H5 y H6, si la G2 elige 2 dimensiones:** se deciden con el **factor económico**, que mide en todo el rango del
    NSE y es el más cercano al índice de la OCDE (0,96 con HOMEPOS, `salidas/nse_validez.csv`). El de libros se
    reporta como secundario y exploratorio. Si la G2 elige 1 dimensión, se aplican tal como están escritas.
    - *Por coherencia (propuesta, por confirmar):* los cuartiles de NSE de H3 y H4 salen del mismo NSE elegido en la
      G2 (el factor económico si es 2D), con ESCS como robustez (F7.1).
  - **H7:** la correlación es el promedio de las 10 correlaciones ponderadas entre el PV propio *m* y el PV de la OCDE
    *m* (*m* = 1…10), por competencia. No se promedian los PV por estudiante ni se corrige por atenuación. La segunda
    parte de H7 (más alta con la propia competencia que con las otras) se calcula igual.
- **Estado:** ✅ aceptada por Vanessa (2026-10-18), salvo los dos puntos marcados «por decidir» y «propuesta». Se
  copian como anexo en [[09 Hipótesis preregistradas]]. Revisada por Mateo (2026-11-10): de acuerdo.

### D-23 · 2026-10-18 · Pendientes de la F5 y la F6 detectados en la revisión del 2026-10-18
- **Problema:** la revisión de tutor del 2026-10-18 encontró puntos del plan que hay que decidir antes de que
  lleguen sus fases. Se registran ahora para no improvisarlos.
- **Propuestas:**
  1. **Valores plausibles propios condicionados (5.4).** El plan los genera con `fscores(plausible.draws = 10)` desde
     un MIRT sin covariables.
     - Si el NSE no está en el modelo que genera los PV, su efecto en la F6 sale atenuado hacia 0 (interpretación
       técnica de Claude; **falta la fuente**: buscar en el capítulo de escalamiento del Technical Report cómo
       condiciona la OCDE sus PV y registrarlo).
     - `mirt` 1.46.1 tiene los argumentos `covdata` y `formula` de regresión latente (comprobado el 2026-10-18).
     - Propuesta: generar los PV con regresión latente sobre el NSE elegido en la G2 y las covariables del SEM
       (sexo, grado, zona, sector).
     - También afecta a H7: los PV de la OCDE están condicionados.
  2. **Muestra de calibración (5.2).** El plan dice 7.222 estudiantes, pero la muestra del proyecto es la de 6.886
     (D-14, D-16). Alternativas: calibrar en los 6.886, o calibrar con todos los que tienen respuestas y calificar a
     los 6.886.
  3. **Ítems con ≥ 100 respuestas por grupo (5.6).** El 175 viene de la revisión del 29/09, anterior a D-13 y D-14:
     hay que recontarlos con la muestra y las definiciones vigentes.
  4. **Corrida piloto de tiempos** en la semana 4. La F5 es costosa: 232 ítems, 4 dimensiones, todo dos veces por D-05,
     más el DIF.
  5. **Errores estándar de la F6.** Pesos con conglomerado no es BRR; un BRR completo son unos 810 ajustes (10 PV ×
     81 pesos). Con menos que BRR, el criterio C2 de [[08 Rúbrica de desarrollo]] no llega a «Ejemplar», y hay que
     declararlo.
  6. **Criterios ΔCFI y ΔRMSEA de la F4.** Si D-10 queda en (b), Chen (2007) sale del proyecto y hace falta otra
     fuente de acceso abierto.
- **Estado:** propuesta. Cada punto se decide antes de su fase: el 6, antes de la F4; del 1 al 4, antes de la F5; el
  5, antes de la F6. Revisada por Mateo (2026-11-10): de acuerdo.
  - *2026-10-18:* el punto 6 quedó cerrado en D-25 y los puntos 1 a 4, en D-27. ~~Sigue abierto el 5 (errores
    estándar de la F6).~~ *2026-11-08:* el punto 5 se cierra en D-34 (BRR en las cifras finales).

### D-24 · 2026-10-18 · Puerta G2: modelo del NSE que pasa a la F4–F6
- **Problema:** según D-16 (punto 9), las puntuaciones del NSE que se usan en la F4–F6 salen del modelo que se elija en
  la Puerta G2. La condición de la G2 ([[08 Rúbrica de desarrollo]]) es un modelo con ajuste aceptable o con el
  desajuste documentado, y H1 resuelta.
- **Evidencia** (todo de esta misma fecha):
  - H1 se acepta con la estructura de D-16 (resultado de D-18).
  - Ningún modelo llega a los cortes en las dos versiones (D-18).
  - Comparación entre la estructura del AFE y la de D-16:

    | Criterio | 2D del AFE | 2D de D-16 | Fuente |
    |---|---|---|---|
    | AFC en la mitad de confirmación: CFI *scaled* / *robust* | 0,943 / 0,753 | 0,921 / 0,731 | `salidas/nse_ajuste_afc.csv` |
    | AFC: RMSEA *scaled* / *robust* | 0,060 / 0,114 | 0,071 / 0,119 | ídem |
    | AFC: SRMR | 0,071 | 0,087 | ídem |
    | TRI en los 6.886: AIC / BIC (no independiente: ver la nota) | 327.986 / 328.765 | 329.821 / 330.600 | `salidas/nse_ajuste_tri.csv` |
    | Factor económico: correlación con ESCS / HOMEPOS | 0,81 / 0,96 | 0,77 / 0,96 | `salidas/nse_validez.csv` |
    | Omega (AFC): económico / segundo factor | 0,888 / 0,929 | 0,925 / 0,936 | `salidas/nse_omega_afc.csv` |

    *Nota (revisión de Brayan, PR #12, 2026-10-18; anotada el 2026-10-19):* la fila del AIC/BIC no es una evidencia
    independiente a favor del AFE. Como advierte D-19, su estructura salió de la mitad de exploración, que está
    dentro de los 6.886. La comparación justa es el AFC en la mitad de confirmación, y ahí el AFE también gana:
    CFI *scaled* 0,943 frente a 0,921 y SRMR 0,071 frente a 0,087. La decisión no cambia.

- **Decisión** (Vanessa, 2026-10-18):
  1. **Pasa a la F4–F6 el modelo de 2 dimensiones del AFE:**
     - económico (19): los 5 `ST250`, `ST251Q01JA`–`Q04JA`, `ST253Q01JA`, `ST254Q01JA`–`Q04JA` y `Q06JA`,
       `HISEI_q`, instrumentos (`ST251Q06JA`), arte (`ST251Q07JA`) y `HISCED_c`;
     - libros (10): `ST255Q01JA`, los 8 `ST256` y lectores electrónicos (`ST254Q05JA`).

     Las puntuaciones son `eap_AFE_ECO` y `eap_AFE_CUL` de `datos/COL_nse_tri.rds`, y el AFC es M2-AFE de
     `03_nse_afc.R`.
  2. **Se declara como estructura empírica:** salió de la mitad de exploración (3.2) y se comprobó en la de
     confirmación (3.4), sin llegar a los cortes *robust*. H1 se decidió con la estructura de D-16 y no cambia.
  3. **H5 y H6** se deciden con el factor económico de este modelo, y el de libros es secundario (D-22).
  4. **Motos** (`ST251Q02JA`) se mantiene: quedan los 29 indicadores de D-16. Se reporta como ítem poco informativo
     (carga 0,08 en el AFC; 0,06 % de la información en la TRI) y en la F4 se revisa como candidata a no invarianza
     entre lo rural y lo urbano (H2).
  5. **Limitaciones para el informe:** el desajuste y sus fuentes (D-18): educación y ocupación de los padres, lo
     digital frente a la vivienda, e ítems con cargas bajas.
- **Interpretación (equipo, por discutir):** el factor «económico» del AFE junta bienes, educación y ocupación de los
  padres. En la práctica es un NSE general, muy parecido a HOMEPOS (0,96), y el segundo factor es el de libros en casa.
- **Propuesta (por confirmar):** repetir en la F7 los resultados principales con la estructura de D-16, como
  robustez.
- **Estado:** ✅ **la Puerta G2 pasa con el desajuste documentado** (Vanessa, 2026-10-18). Mateo y Brayan revisan y
  firman el acta ([[Reuniones/2026-10-18 Puerta G2]]). Revisada por Mateo (2026-11-10): de acuerdo.

### D-25 · 2026-10-18 · Cómo se prueba la invarianza del NSE (F4, O2, H2)
- **Problema:** el plan (F4) y D-22/D-23 dejan abiertos varios puntos que cambian los resultados de la invarianza:
  - con qué estudiantes;
  - qué grupos prueban H2, que habla de rural frente a urbana cuando la zona tiene 3 categorías;
  - qué se hace con las categorías escasas por grupo;
  - con qué criterios y fuente;
  - cómo se mide el DIF.

  Se fijan aquí **antes de estimar cualquier modelo de invarianza**.
- **Lo que muestran los datos** (`scripts/04_explorar_grupos.R` → `salidas/inv_grupos_n.csv` y
  `salidas/inv_categorias_grupo.csv`, 2026-10-18; solo cuenta, no estima):

  | Grupo | Muestra completa (6.886) | Mitad de confirmación (3.441) | % ponderado (completa) |
  |---|---|---|---|
  | Rural (< 3.000) | 904 | 458 | 14,8 |
  | Pueblo (3–15 mil) | 843 | 418 | 13,3 |
  | Urbana (> 15 mil) | 4.927 | 2.458 | 68,7 |
  | Zona sin dato | 212 | 107 | 3,2 |
  | Mujer / Hombre | 3.541 / 3.345 | 1.769 / 1.672 | 52,1 / 47,9 |
  | Público / Privado | 5.354 / 1.442 | 2.676 / 720 | 79,0 / 19,3 |
  | Sector sin dato | 90 | 45 | 1,7 |

  - **Muestra completa:** ninguna categoría queda vacía en ningún grupo. Con menos de 10 respuestas en el grupo más
    chico hay 3 ítems:
    - `ST254Q02JA`, «2 o más» computadores de escritorio: 5 en el pueblo;
    - `ST251Q01JA`, «3 o más» carros: 6 en el pueblo;
    - `HISCED_c`, el nivel más bajo: 6 en el sector privado.

    Con menos de 20 respuestas hay 8 ítems.
  - **Mitad de confirmación:** en zona hay 7 ítems con menos de 10 respuestas en alguna categoría (el mínimo es 2), y
    en sector, 3.
- **Lo que muestra el software** (prueba con datos simulados, 2026-10-18; `lavaan` 0.7-3, `semTools` 0.5-10, `mirt`
  1.46.1):
  - corren la secuencia de `measEq.syntax(ID.cat = "Wu.Estabrook.2016", parameterization = "theta")` con WLSMV, pesos
    y faltantes por pares, `lavTestScore()` y las medias latentes;
  - **con restricciones de igualdad, `lavaan` no calcula las versiones *robust*** del CFI y del RMSEA (salen NA);
  - `mirt::multipleGroup()` admite `survey.weights`, y `DIF()` corre;
  - `MASS::polr()` (regresión logística ordinal) admite pesos.
- **Propuesta:**
  1. **Muestra:** los 6.886 de la muestra analítica, no la mitad de confirmación. La mitad deja categorías con 2 a 9
     respuestas en el pueblo y en el privado, y los umbrales no se podrían estimar bien. La invarianza es otra pregunta
     (H2), distinta de la que decidió la mitad de confirmación (H1).
     - Quienes no tienen dato de zona (212) o de sector (90) quedan fuera solo de ese análisis.
  2. **Grupos:** cada variable por separado, nunca cruzadas.
     - **O2:** zona con 3 grupos, sexo y sector.
     - **H2 se decide con un modelo de 2 grupos: rural (904) frente a urbana (4.927)**, como dice la hipótesis. El
       pueblo entra en la secuencia de 3 zonas de O2.
  3. **Categorías escasas:** una categoría con menos de 10 respuestas en algún grupo (zona, sexo o sector, en los
     6.886) se une con su vecina hacia el centro **en todos los grupos**. Se repite hasta que ninguna quede por debajo.
     - Con los datos de arriba cambian 3 ítems: `ST254Q02JA` queda en 0–1, `ST251Q01JA` en 0–2 y `HISCED_c` une sus
       dos niveles más bajos.
     - Solo para los modelos de la F4. Las puntuaciones de la G2 (D-24) no cambian.
     - *Por qué:* la invarianza de umbrales exige las mismas categorías en todos los grupos (plan, paso 4.1).
  4. **Modelo y secuencia** (pasos 4.2 y 4.3):
     - el AFC de 2 dimensiones del AFE (D-24), con WLSMV, `W_FSTUWT` normalizado a cada análisis y faltantes por
       pares;
     - parametrización theta (P6) e identificación de Wu y Estabrook (`semTools::measEq.syntax`);
     - secuencia: configural → umbrales → cargas → interceptos (escalar). Antes se ajusta el modelo en cada grupo por
       separado (P6).
  5. **Criterios de cada paso:** un paso no se sostiene si el CFI empeora más de 0,01 o el RMSEA más de 0,015 frente
     al paso anterior. Son los cortes que ya fija H2.
     - **Se usan las versiones *scaled*:** con restricciones de igualdad, `lavaan` no calcula las *robust*. Se
       reportan cuando existan.
     - *Fuente:* [[Literatura/putnick2016measurement]] (acceso abierto), que reporta los cortes de Chen (2007).
       Matices de la misma fuente: no hay consenso sobre los cortes, y la revisión se centra en ítems continuos.
       Por verificar.
  6. **Invarianza parcial (4.3):** si un paso no se sostiene, se libera de a una la restricción con el mayor
     estadístico de `lavTestScore()`, hasta que el paso cumpla los cortes. Se documenta cada parámetro liberado.
  7. **DIF con TRI (4.4, P4):**
     - un modelo unidimensional por factor del AFE (económico 19 ítems; libros 10), con 2PL y GPCM como en la F3,
       `mirt::multipleGroup()` con pesos;
     - `DIF()` con anclas depuradas: primero todos los demás ítems; luego, solo los que no salieron con DIF. Como
       máximo 2 vueltas;
     - Benjamini-Hochberg al 5 % dentro de cada factor y variable de grupo;
     - **magnitud (D-22):** ΔR² de Nagelkerke de una regresión logística ordinal (`MASS::polr`, con pesos) del ítem
       sobre la EAP de su factor, el grupo y su interacción, frente al modelo con la EAP sola. Corte ΔR² ≥ 0,035;
     - *Matiz por declarar:* de Ayala (p. 334) dice que los cortes de Jodoin y Gierl se propusieron para el R² de
       mínimos cuadrados ponderados, y el que se usa aquí es el de Nagelkerke;
     - un ítem tiene DIF si su prueba TRI es significativa (BH) **y** su ΔR² ≥ 0,035.
  8. **H2:** se acepta si, en el modelo rural–urbana, el paso escalar empeora el CFI en más de 0,01 o el RMSEA en más
     de 0,015 (versiones *scaled*), **y** al menos un ítem tiene DIF no despreciable en ese contraste. Es la regla del
     preregistro, con los puntos 5 y 7.
     - *Resultado (anotado el 2026-10-19, por la revisión de Brayan):* como la regla pide las dos condiciones a la
       vez, H2 ya se rechaza por la primera: el paso escalar rural–urbana no empeora (ΔCFI −0,0027 y ΔRMSEA
       +0,0007, `salidas/inv_h2.csv`). El DIF del 4.4 describe O2, pero no cambia H2.
  9. **Medias latentes (4.5, P6):** con el nivel de invarianza que se sostenga, total o parcial, la diferencia de
     medias latentes del NSE entre grupos (el grupo de referencia con media 0), sin EE de diseño (D-16 punto 5).
- **Salidas previstas:** `scripts/04_invarianza.R` → `salidas/invarianza_tabla.csv`,
  `salidas/nse_items_no_invariantes.csv`, `salidas/nse_dif_posesiones.csv` y `salidas/nse_medias_latentes.csv`.
- **Estado:** ✅ aceptada por Vanessa (2026-10-18), tal cual:
  - muestra completa (6.886);
  - H2 con rural frente a urbana y O2 con las 3 zonas;
  - categorías con menos de 10 respuestas unidas;
  - lo demás como está propuesto.

  Mateo y Brayan la revisan en el PR. Revisada por Mateo (2026-11-10): de acuerdo.
- *El punto 7 se corrige en D-26:* la prueba TRI del DIF va sin pesos.

### D-26 · 2026-10-18 · La prueba TRI del DIF va sin pesos (corrige D-25 punto 7)
- **Problema:** la primera corrida del DIF (`04_invarianza.R`, 2026-10-18) dio X² negativos en todos los ítems,
  de −760 a −2.930, y valores p vacíos. Con modelos anidados eso es imposible.
  - *Causa, comprobada en el código de `mirt` 1.46.1:* `DIF()` re-estima cada modelo con `multipleGroup()` **sin
    pasarle `survey.weights`**. El modelo base estaba ponderado y los de la prueba no, así que se comparaban
    verosimilitudes de escalas distintas.
  - Esa corrida no da ningún resultado de DIF y no se usa. Los ΔR² de magnitud sí son válidos: se calculan aparte, con
    pesos, y no dependen de `DIF()`.
- **Alternativas:**
  - (a) prueba TRI sin pesos;
  - (b) razón de verosimilitudes ponderada, re-estimando a mano;
  - (c) pruebas de Wald sobre el modelo ponderado.
- **Decisión** (Vanessa, 2026-10-18): **(a)**.
  - La prueba TRI del DIF (`multipleGroup()` y `DIF()`, en las dos vueltas) se hace **sin pesos**. Así es una prueba
    de razón de verosimilitudes válida para la muestra.
  - La magnitud sigue como en D-25: ΔR² de Nagelkerke **con pesos**. Un ítem tiene DIF si cumple las dos.
  - *Por qué:* con pesos, la verosimilitud es una pseudo-verosimilitud y compararla es descriptivo, no una prueba
    (D-19 punto 4). Las pruebas de Wald necesitarían errores estándar que con pesos no reflejan el diseño (D-16
    punto 5).
- **Estado:** ✅ aceptada por Vanessa (2026-10-18). Mateo y Brayan la revisan en el PR. Revisada por Mateo (2026-11-10): de acuerdo.
- **Resultado del 4.4 y de H2** (`scripts/04_invarianza.R` → `salidas/nse_dif_posesiones.csv` e `inv_h2.csv`,
  2026-10-18; 116 pruebas en 8 análisis, 4 contrastes por 2 factores; todos los X² positivos):

  | Contraste | Factor | Probados | Significativos (BH) | ΔR² ≥ 0,035 | Con DIF |
  |---|---|---|---|---|---|
  | Zona, 3 grupos | económico | 19 | 14 | 1 | **1: motos (`ST251Q02JA`), ΔR² = 0,042** |
  | Zona, 3 grupos | libros | 10 | 5 | 0 | 0 |
  | Rural vs urbana (H2) | económico | 19 | 13 | 0 | 0 |
  | Rural vs urbana (H2) | libros | 10 | 4 | 0 | 0 |
  | Sexo | económico / libros | 19 / 10 | 11 / 5 | 0 | 0 |
  | Sector | económico / libros | 19 / 10 | 15 / 9 | 0 | 0 |

  - Con miles de estudiantes, la prueba TRI marca casi todos los ítems. La magnitud es la que separa: el ΔR² más alto
    fuera de motos es 0,019 (celulares, por sector).
  - Motos tiene el ΔR² más alto en los tres contrastes en que aparece: 0,042 (zona), 0,033 (sector) y 0,028
    (rural–urbana). Solo en zona pasa el corte. *Interpretación (equipo, por discutir):* la diferencia está sobre
    todo en el pueblo, y motos funciona distinto según el entorno, como se había anticipado en D-24.
  - **H2 se rechaza** (regla del preregistro con D-22 y D-25): en rural–urbana, el paso escalar empeora el CFI 0,003
    y el RMSEA 0,001 (no más de 0,01 ni de 0,015), y ningún ítem tiene DIF no despreciable. Fallan las dos
    condiciones.
  - *Corrección (2026-11-08, D-35):* el párrafo siguiente dice más de lo que muestran los datos. Con el criterio
    preregistrado no se detectó no invarianza relevante; no es invarianza demostrada (el χ² la rechaza en 10 de 12 pasos
    y el ajuste de partida es pobre). Las comparaciones de medias y efectos entre grupos se hacen declarando ese límite.
  - **Qué implica para la F6:** el NSE entra con invarianza escalar total entre zonas, sexos y sectores, así que sus
    medias y sus efectos se pueden comparar entre grupos (H6). Motos se reporta como el único ítem con DIF no
    despreciable, en zona.
  - *Nota técnica:* el resumen de la corrida terminó con un error de lectura porque Claude editó el script mientras
    corría. Los cálculos estaban guardados en el caché; las salidas se escribieron de nuevo desde ahí en una corrida
    limpia (2026-10-18, 19:54).

### D-27 · 2026-10-18 · Cómo se califica por competencias (F5, O3; H3, H4, H7, H8; cierra D-05 y D-23 puntos 1 a 4)
- **Problema:** antes de calibrar el modelo de 4 competencias hay que fijar:
  - cómo se puntúan los ítems y con qué estudiantes se calibra;
  - el modelo y cómo se generan los valores plausibles;
  - qué es una omisión rápida (D-05);
  - cómo se decide H4 por competencia;
  - cómo se mide el DIF de matemáticas (H3) y cómo se enlaza con la OCDE (P3).
- **Lo que muestran los datos** (`scripts/05_explorar_items.R` → `salidas/items_competencia.csv`,
  `items_respuestas.csv` e `items_resumen_competencia.csv`, 2026-10-18; solo clasifica y cuenta, en la muestra
  analítica de 6.886):

  | Competencia | Calibrables | < 500 respuestas | Elegibles DIF: NSE económico / ESCS | Crédito parcial |
  |---|---|---|---|---|
  | Emplear | 75 | 6 | 59 / 59 | 13 |
  | Formular | 47 | 9 | 31 / 34 | 12 |
  | Interpretar | 57 | 9 | 39 / 42 | 19 |
  | Razonar | 53 | 10 | 36 / 39 | 18 |
  | **Total** | **232** | **34** | **165 / 174** | **62** |

  - *Elegible para DIF:* al menos 100 respuestas en el cuartil bajo y en el alto (ponderados).
  - El paso 5.1 queda hecho (`items_competencia.csv`): los 234 ítems de Colombia están en el anexo A.
    - `CMA112Q02S` está retirado (D-09).
    - `CMA143Q01S` no tiene respuestas.
  - **Puntaje:** 19 ítems usan códigos de dos dígitos (11, 12, 21…): 18 de crédito parcial y 1 dicotómico.
    - Leer el primer dígito como crédito coincide con el anexo en los 232 ítems: los de puntaje 0/1/2 son justo los
      que tienen pasos de crédito parcial.
    - En `DM462Q01C`, los códigos 1 y 2 son «01 – No credit» y «02 – No credit» (etiquetas del `.SAV`).
  - **Ítems vistos por estudiante:** mediana 29 (de 10 a 30).
  - **Omisiones:** 12.490.
    - Con el NT10 (menos del 10 % del tiempo **medio** del ítem entre quienes lo vieron), 4.852 son rápidas (38,8 %);
      con el tope de 10 s, 4.426.
    - En el cuartil bajo del NSE económico es rápida el 39,7 % de las omisiones (1.342 de 3.381); en el alto, el
      36,8 % (954 de 2.594).
    - Umbral NT10: mediana 10,7 s (de 3,5 a 26,9 s).
- **Fuentes** (todas por verificar):
  - el primer dígito del código es el crédito: [[Literatura/oecd2024pisa2022tr]], p. 313;
  - NT10 = menos del 10 % del tiempo medio del ítem en cada país, sin el tope de 10 s que propusieron Wise y Ma
    (2012): [[Literatura/rios2022investigation]], p. 18;
  - omitidos como incorrectos y no alcanzados excluidos en el escalamiento de la OCDE: TR, p. 211 (ya en D-13);
  - alternativas para las omisiones: [[Literatura/deayala2009theory]], pp. 150–151.
- **Propuesta:**
  1. **Puntaje (5.2):** el crédito es el primer dígito en los ítems con códigos de dos dígitos, y en ellos 1 y 2
     valen 0. Quedan 170 ítems dicotómicos y 62 de crédito parcial (0/1/2).
  2. **Muestra (D-23 punto 2):** se calibra y se califica a los 6.886 de la muestra analítica.
     - Es la población de todo el proyecto (D-14, D-16).
     - Los valores plausibles condicionados (punto 4) necesitan el NSE de cada estudiante, y solo esos 6.886 lo
       tienen.
     - *Alternativa:* calibrar con todos los que tienen respuestas y calificar solo a los 6.886.
  3. **Modelo (5.3, H8):**
     - TRI multidimensional confirmatoria de 4 dimensiones correlacionadas, en la que cada ítem carga solo en su
       competencia; 2PL para los dicotómicos y GPCM para los de crédito parcial, como en la F3;
     - frente a un modelo unidimensional;
     - pesos normalizados, como en la F3 (D-16 punto 5); con pesos, el BIC de H8 es descriptivo (D-19 punto 4);
     - estimación con `QMCEM`, o `MHRM` si no converge. Antes se hace un **piloto de tiempos** (D-23 punto 4).
  4. **Valores plausibles (5.4, D-23 punto 1):**
     - EAP y 10 PV por competencia, de un modelo con **regresión latente** (`covdata` y `formula` de `mirt`) sobre las
       EAP del NSE de la G2 (económico y libros), sexo, grado (`GRADE`), zona y sector;
     - la zona y el sector sin dato entran como una categoría propia;
     - se reporta la confiabilidad empírica por competencia.
  5. **Omisiones (D-05, 5.7, H4):** se califica de tres formas.
     - (a) la omitida vale 0, como la OCDE, y el no alcanzado es faltante;
     - (b) la omisión rápida (NT10 con la media, sin tope, calculado en la muestra analítica de Colombia) es faltante y
       las demás omisiones valen 0;
     - (c) *sensibilidad (P5):* toda omisión es faltante (verosimilitud marginalizada, de Ayala, pp. 150–151).
     - En las tres se usan los mismos parámetros de los ítems, los de (a). Así la brecha cambia solo por cómo se trata
       la omisión. El NT10 con tope, el NT15 y 5 s quedan para la F7 (paso 7.1).
  6. **H4 por competencia (lo que D-22 dejó por decidir):** se acepta si en **al menos una** competencia la
     reducción es ≥ 0,05 DE y significativa, después de corregir por las 4 competencias con Holm. Se reportan las
     cuatro.
  7. **DIF de matemáticas (5.6, H3, P4):**
     - cuartil bajo frente al alto del NSE económico de la G2, con ESCS como robustez (D-22);
     - solo los ítems elegibles: 165;
     - un modelo unidimensional por competencia con todos sus ítems, `multipleGroup()` sin pesos (lógica de D-26),
       anclas depuradas en 2 vueltas y BH al 5 % dentro de cada competencia;
     - magnitud (D-22):
       - en los dicotómicos, Mantel-Haenszel estratificado por deciles de la EAP de la competencia, con categoría B o
         C del ETS;
       - en los de crédito parcial, ΔR² de Nagelkerke ≥ 0,035;
     - segunda parte de H3: la proporción de ítems con DIF en interpretar más formular frente a emplear, con la prueba
       exacta de Fisher (α = 0,05).
  8. **Validación (5.5, H7, P3):**
     - H7 como en D-22;
     - P3: se enlazan las dificultades propias con las internacionales del anexo A por media–sigma, y se reportan la
       correlación y la diferencia cuadrática media por competencia.
  9. **Dependencia local (P1):** Q3 en los pares de la misma unidad, con |Q3| > 0,2 (D-21).
  10. **P2:** en la F7 se re-calibra sin los 34 ítems con menos de 500 respuestas.
- **Salidas previstas:** `scripts/05_tri_competencias.R` → `salidas/mat_parametros_mirt.csv`, `mat_ajuste.csv`,
  `validacion_ocde_competencias.csv`, `mat_dif.csv`, `brecha_omisiones.csv`; puntajes en
  `datos/COL_puntajes_competencia.rds` (no va a Git).
- **Estado:** ✅ aceptada por Vanessa (2026-10-18), tal cual:
  - los 6.886;
  - valores plausibles condicionados;
  - NT10 con la media y sin tope;
  - H4 con al menos una competencia, con Holm;
  - el resto como está propuesto.

  Con esto quedan cerrados D-05 y los puntos 1 a 4 de D-23. Mateo y Brayan la revisan en el PR.
- **Piloto de tiempos** (D-23 punto 4; script del scratchpad, no del proyecto; 2026-10-18, con el DIF de la F4
  corriendo al mismo tiempo, así que los tiempos están inflados):
  - matriz de 6.886 × 232 (170 ítems 2PL y 62 GPCM), con dato en el 11,7 % de las celdas por el diseño adaptativo;
  - 1 dimensión, con pesos: unos 2 s por ciclo del EM;
  - 4 dimensiones, `QMCEM` con pesos y los puntos de integración por defecto: unos 70 s por ciclo, es decir,
    varias horas;
  - 4 dimensiones, `QMCEM` con pesos y 1.000 puntos: unos 13 s por ciclo, del orden de 1 a 2 horas;
  - **`MHRM` no admite pesos en `mirt` 1.46.1** (el ajuste se detiene con un error). Sin pesos, el piloto se detuvo
    antes de terminar.
  - *Por decidir al retomar (cambia el punto 3):* cuántos puntos de integración usa `QMCEM`. La propuesta es 1.000,
    con pesos, en segundo plano y con caché.
  - ✅ **Decidido por Vanessa (2026-10-20):** `QMCEM` con **1.000 puntos de integración**, con pesos, en segundo plano
    y con caché, igual para el modelo de 1 y el de 4 dimensiones, para que la comparación de H8 sea pareja.
    - Por qué: con los puntos por defecto el piloto tardaba unos 70 s por ciclo (varias horas), y con 1.000 unos 13 s
      (de 1 a 2 horas). Los tiempos del piloto están inflados porque el DIF de la F4 corría al mismo tiempo.
    - `MHRM` sigue descartado: no admite pesos en `mirt` 1.46.1.
    - El caché del modelo guarda una huella de los datos y de esta configuración, como en la F3 y la F4 (observación 2
      de Brayan, PR #12): si cambia alguna de las dos, se reestima.
    - Mateo y Brayan la revisan en el PR. Revisada por Mateo (2026-11-10): de acuerdo.
  - ✅ **Puntajes del 5.4 con regresión latente (Vanessa, 2026-10-20), antes de programar.**
    - *Verificación técnica (2026-10-20, scripts de prueba del scratchpad, no del proyecto):*
      - con `mirt` 1.46.1, la regresión latente se estima con los ítems **fijos** en los parámetros del modelo de 4
        competencias (`pars` con `est = FALSE`), con pesos y `QMCEM`: los ítems quedan idénticos;
      - con los ítems fijos, la especificación por defecto deja la media en 0 y la varianza en 1, lo que es
        inconsistente con la escala de los ítems: se estiman **las 4 medias y las 4 varianzas residuales** (62
        parámetros con las 6 covarianzas y 48 coeficientes);
      - `fscores()` no puede calcular EAP ni valores plausibles con regresión latente e integración QMC (error de
        dimensiones por las tres vías probadas); Metropolis-Hastings no está soportado con regresión latente; la
        cuadratura fija de 9 y 11 puntos funciona, pero es imprecisa (frente a QMC en el modelo sin covariables:
        r de 0,956 a 0,960 y diferencias de hasta 0,97 DE); con más puntos se agota la memoria; la MAP funciona, pero
        no es la EAP y 2 estudiantes no convergen.
    - *Alternativas:* (A) posterior con código propio e integración QMC; (B) MAP con aproximación normal; (C) puntajes
      sin regresión latente.
    - **Decisión: (A).** (B) no es equivalente a D-27, porque MAP y EAP son estimadores distintos, y ya hay dos
      estudiantes sin converger; (C) abandona la regresión latente prevista y puede atenuar los efectos del NSE (D-23
      punto 1). La ventaja de (A) depende de validar el código independiente con rigor: no basta con reproducir las
      EAP de `mirt` en un caso sencillo; hay que verificar la estabilidad numérica en el modelo definitivo.
    - **Criterios de aceptación, fijados antes de evaluar los resultados definitivos:**

      | Criterio | Regla de aceptación |
      |---|---|
      | V1. Validación frente a `mirt` | Sin covariables: correlación de las EAP ≥ 0,999 en cada competencia y diferencia absoluta máxima ≤ 0,02 DE latentes |
      | V2. Estabilidad de las EAP | Al duplicar los puntos QMC: correlación ≥ 0,995 por competencia, diferencia absoluta media ≤ 0,02 DE y percentil 95 de la diferencia absoluta ≤ 0,05 DE |
      | V3. Estabilidad de la incertidumbre | Diferencia relativa de los errores estándar posteriores entre las dos resoluciones: mediana ≤ 2 % y percentil 95 ≤ 5 %; los casos con denominador cercano a cero se evalúan aparte |

      - Son criterios operativos del proyecto, no estándares universales.
      - Si se incumplen, los puntajes no se aceptan automáticamente: se documenta el problema y se investiga su origen.
    - **Valores plausibles:** se comprueba que salen de la posterior conjunta, condicionada a las covariables y a las
      respuestas. No se exige que los valores individuales coincidan al duplicar los puntos, porque son extracciones
      aleatorias: se evalúa la estabilidad de sus distribuciones y resúmenes.
    - **Plan:** (1) este registro; (2) validar el código sin covariables frente a `mirt` (V1); (3) estabilidad al
      duplicar los puntos (V2, V3), antes de producir los puntajes definitivos; (4) si se cumplen, EAP, errores
      estándar y 10 valores plausibles por estudiante; (5) documentar cualquier incumplimiento y no presentar los
      puntajes como suficientemente precisos hasta resolverlo.
    - **Detalles de implementación** (propuestos por Claude; confirmados por Vanessa el 2026-10-20 con precisiones,
      antes de correr V1):
      1. *Puntos QMC:* secuencia de Halton de 4 dimensiones transformada a normal; 5.000 puntos en la resolución base
         y 10.000 en la duplicada, con **puntos comunes**: los primeros 5.000 de la secuencia de 10.000 son los de la
         base. *Precisión de Vanessa:* centrar los puntos en la predicción de las covariables no garantiza representar
         toda la posterior; la integración usa la densidad posterior y sus pesos, y la dispersión de los puntos es la de
         la distribución latente especificada (media y covarianza residual del modelo).
      2. *Referencia de V1:* `fscores()` del modelo de 4 competencias sin covariables, con QMC y 10.000 puntos.
         *Precisión de Vanessa:* la comparación usa exactamente los mismos estudiantes, ítems, codificación y
         tratamiento de los faltantes; V1 comprueba la implementación en ese escenario, pero no demuestra por sí sola
         que la regresión latente esté bien implementada.
      3. *Valores plausibles:* normal multivariada con la EAP y la covarianza posterior conjunta de cada estudiante
         (como `plausible.type = "normal"` de `fscores()`), **aceptada de forma condicionada**: no se asume que
         reproduce exactamente la posterior, y si es asimétrica o multimodal puede ser insuficiente. Comprobaciones,
         con tolerancia a la variabilidad Monte Carlo (no se exige igualdad exacta):
         - la media de los valores plausibles se aproxima a la media de las EAP;
         - la covarianza total de los valores plausibles se aproxima a la covarianza entre las EAP más la covarianza
           posterior media;
         - la dependencia entre competencias se contrasta con esa covarianza total, no solo con las correlaciones de
           los factores del modelo.
    - **Si V1 falla** (Vanessa): no se continúa con la estimación definitiva. Primero se identifica si la discrepancia
      viene de la integración QMC, de la implementación de la posterior o de diferencias de configuración entre
      `mirt` y el código propio.
    - **Resultado de V1 (2026-10-20, `salidas/mat_posterior_V1.csv`): no se cumple.**
      - Correlación de las EAP de 0,99996 a 0,99998 (cumple ≥ 0,999), pero diferencia máxima de 0,206 a 0,254 DE (no
        cumple ≤ 0,02). La diferencia media es de 0,001 a 0,0015 DE: el problema está en pocos estudiantes.
      - Tamaño efectivo de los puntos (código propio, 5.000): mediana 1.812, mínimo 6. Errores estándar, solo como
        información: correlación con `mirt` de 0,997 a 0,999 y diferencia máxima de 0,07 a 0,13.
      - Por la regla de Vanessa no se continuó con V2, V3 ni la estimación definitiva.
    - **Diagnóstico (2026-10-20; script de prueba del scratchpad, no del proyecto):** *Aviso de trazabilidad
      (2026-11-08):* las cifras de este diagnóstico, las del piloto de tiempos y las de la «verificación técnica» de
      arriba salieron de scripts que no están en el repositorio (se corrieron en otro equipo), así que **no se pueden
      reproducir** y no deben ir al informe tal cual (regla 2 del `README.md`). Los conteos de tamaño efectivo (< 50 y
      < 100) los recalcula `scripts/05_puntajes_e1.R` (D-33). Diferencia máxima de las EAP por
      competencia (emplear, formular, interpretar, razonar):

      | Comparación | Diferencia máxima (DE) |
      |---|---|
      | propio 5.000 frente a propio 10.000 | 0,13 / 0,15 / 0,16 / 0,10 |
      | `mirt` 20.000 frente a `mirt` 10.000 | 0,13 / 0,21 / 0,30 / 0,08 |
      | `mirt` 40.000 frente a `mirt` 20.000 | 0,28 / 0,15 / 0,10 / 0,41 |
      | propio 10.000 frente a `mirt` 40.000 | 0,50 / 0,42 / 0,41 / 0,65 |

      - **Ni el código propio ni la referencia de `mirt` se estabilizan** al aumentar los puntos en los estudiantes más
        afectados: la propia referencia cambia hasta 0,41 DE entre 20.000 y 40.000 puntos.
      - Los casos con mayor diferencia son estudiantes con **EAP extremas** (de 2,8 a 3,9 DE en valor absoluto) que
        respondieron casi todos sus ítems (de 17 a 30) y tienen **tamaño efectivo muy bajo** (de 6 a 31 puntos de
        5.000). La correlación de Spearman entre el tamaño efectivo y la diferencia es −0,75; hay 36 estudiantes con
        tamaño efectivo menor que 50 y 77 con menos de 100.
      - *Lectura técnica (Claude, por discutir con Vanessa):* el origen es la **integración en las colas**. Los
        puntos se generan desde la distribución latente centrada en la media; cuando la posterior de un estudiante
        está en la cola, pocos puntos caen cerca de ella y la EAP depende de esos pocos puntos. Eso afecta igual a la
        integración QMC de `fscores()`, así que **la referencia de V1 tampoco es exacta para esos estudiantes**. No
        hay evidencia de un error de implementación: en la mayoría de estudiantes los dos métodos coinciden en
        milésimas.
  - Calibrar cada competencia por separado se descarta: la ruta adaptativa depende de ítems de otras competencias, y la
    falta de datos solo es ignorable si se calibran todas juntas (plan, paso 5.2).

### D-28 · 2026-10-19 · Prueba de diferencia escalada en cada paso de la invarianza (F4; observación 1 de Brayan)
- **Hallazgo** (revisión de Brayan de la F4, PR #12, 2026-10-18): en los 4 análisis, al restringir las cargas el
  ajuste *scaled* **mejora**: el CFI sube entre 0,004 y 0,006, el RMSEA baja y el χ² *scaled* también baja (de 9.646 a
  8.917 en zona), aunque el modelo tiene más restricciones (`salidas/invarianza_tabla.csv`).
- **Por qué importa** (*interpretación de Claude, sin fuente en el vault, por verificar*): con WLSMV, la corrección de
  escala cambia entre modelos anidados, así que el χ² y los índices *scaled* no tienen por qué empeorar al restringir.
  Eso le quita fuerza a la regla ΔCFI/ΔRMSEA de D-25 punto 5, que la propia fuente describe para ítems continuos
  ([[Literatura/putnick2016measurement]], por verificar).
- **Alternativas:**
  - (a) no cambiar nada y declarar la limitación en el informe;
  - (b) agregar en cada paso la **prueba de diferencia escalada** (`lavTestLRT()`, método `satorra.2000`), igual que
    en el 3.4 (D-18), como complemento que **no decide** ni H2 ni la invarianza parcial;
  - (c) usar esa prueba como criterio de decisión.
- **Propuesta:** (b).
  - La regla de H2 está preregistrada y no cambia ([[09 Hipótesis preregistradas]]). Por eso se descarta (c).
  - *Interpretación (por verificar):* con muestras del tamaño de la F4 (de 5.831 a 6.886), la prueba χ² tiende a
    rechazar diferencias pequeñas, otra razón para no usarla como criterio.
  - Qué cambia: `invarianza_tabla.csv` gana tres columnas (Δχ², Δgl y p de la prueba) en cada paso frente al
    anterior.
  - Costo: el caché `COL_inv_cfa.rds` guarda solo las tablas, no los modelos ajustados, así que hay que rehacer el
    AFC una vez (unos 11 minutos, `REHACER_INV = 1`). El DIF no se toca.
- **Estado:** ✅ (b) aceptada por Vanessa (2026-10-19). Mateo y Brayan la revisan en el PR. Revisada por Mateo (2026-11-10): de acuerdo.
  - Para que los cachés anteriores se rehagan solos en cualquier máquina, la huella del caché del AFC incluye la
    marca «D-28» (observaciones 2 y 4 de Brayan, PR #12).
  - **Resultado (2026-10-19, `salidas/invarianza_tabla.csv`):** la prueba de diferencia sale significativa en 10 de
    los 12 pasos, aunque los 12 se sostienen por ΔCFI/ΔRMSEA. Solo no lo es en sexo, umbrales (Δχ² = 33,0 con 29 gl,
    p = 0,28) y cargas (Δχ² = 33,5 con 27 gl, p = 0,18). En el paso escalar rural–urbana, el que decide H2, da
    Δχ² = 273,4 con 21 gl (p = 8,1e−46).
    - **No cambia nada:** la regla preregistrada de H2 y de la invarianza parcial es ΔCFI/ΔRMSEA (D-25 punto 5), y
      H2 sigue rechazada (`salidas/inv_h2.csv`, sin cambios).
    - Se reporta como discrepancia entre los dos criterios. *Interpretación (por verificar):* con n de 5.831 a 6.886,
      la prueba detecta diferencias que los índices de ajuste consideran pequeñas.

### D-29 · 2026-10-20 · Con qué se califica por competencia después de rechazar H8 (F5, O3; Puerta G3)
- **Problema:** H8 se rechazó (2026-10-20, `salidas/mat_ajuste.csv`): el BIC es menor con 1 dimensión y dos
  correlaciones entre competencias pasan de 0,95 (emplear–razonar 0,976; emplear–interpretar 0,951). El plan necesita
  puntajes por competencia para H4, H5, H6 y H7, y la Puerta G3 pide el modelo de 4 competencias «elegido o descartado
  con argumento».
- **Alternativas:**
  - (a) calificar con el modelo de 4 competencias, declarando la correlación alta;
  - (b) abandonar la calificación por competencias y usar un solo puntaje;
  - (c) un modelo unidimensional por competencia (descartado ya en D-27: la ruta adaptativa depende de ítems de otras
    competencias y la falta de datos solo es ignorable si se calibran todos juntos);
  - (d) lo de (a), más un modelo bifactor exploratorio: un factor general de matemáticas y cuatro específicos.
- **Decisión** (Vanessa, 2026-10-20): **(d)**, siempre que se verifique su viabilidad estadística con los datos
  reales. Se conserva el análisis de H4, H5, H6 y H7 como se preregistró, se evalúa si las cuatro competencias aportan
  información diferenciada y se profundiza en la comparación con un puntaje único. Criterios:
  1. **Validar el modelo de 4 competencias:** ajuste, convergencia, identificación, precisión de las puntuaciones y
     correlaciones entre factores. Las correlaciones altas se reconocen como limitación, pero no implican por sí
     solas que el modelo sea inválido.
  2. **Estimar el bifactor exploratorio:** comprobar que es compatible con la estructura adaptativa, los datos
     faltantes y los pesos del diseño, y evaluar cuánto aporta cada competencia después de controlar la habilidad
     matemática general.
  3. **Preservar el preregistro:** las hipótesis confirmatorias no cambian; el bifactor se documenta como
     exploratorio y no se usa para modificar retrospectivamente las decisiones originales.
  4. **Criterios de viabilidad:** si el bifactor no converge, no se identifica o sus factores específicos no son
     interpretables, se documenta el resultado sin forzar conclusiones.
  - *Propósito (Vanessa):* no se trata de conservar cuatro competencias a toda costa, sino de investigar si aportan
    información frente a un puntaje global. Si su contribución específica es limitada, ese resultado también es un
    hallazgo del proyecto.
- **Operacionalización del bifactor** (propuesta de Claude, aceptada por Vanessa con ajustes el 2026-10-20):
  - *Ajuste de Vanessa:* no se da por garantizado que el bifactor podrá estimarse ni que las cuatro subescalas tendrán
    fiabilidad específica suficiente. El resultado se decide con la evidencia, no con umbrales escogidos después de
    observarla. Por eso los criterios de viabilidad quedan fijados **aquí, antes de estimar**, y no se cambian después.
  - *Modelo:* `bfactor()` de `mirt`: cada ítem carga en el factor general y en el específico de su competencia, con
    factores ortogonales. Mismos ítems, tipos (2PL y GPCM), versión (a) de la matriz y pesos normalizados que el 5.3;
    integración por defecto de `bfactor()`. Las cargas se calculan con `cargas_mirt()` de la F3, porque `summary()`
    de `mirt` 1.46.1 anula cargas de ítems GPCM (D-19).
  - *Viabilidad (punto 4):* el bifactor es viable solo si se cumplen las tres condiciones:
    - V1: converge dentro de 2.000 ciclos;
    - V2: no hay parámetros no finitos ni ítems con comunalidad (h² = carga general² + carga específica²) ≥ 0,99;
    - V3: cada uno de los cuatro factores específicos tiene al menos 3 ítems con carga estandarizada ≥ 0,30 en valor
      absoluto.
    - *Los cortes de V2 y V3 los propuso Claude antes de estimar; no tienen fuente en el vault.* Si alguna condición
      falla, se documenta que el bifactor no es viable y no se interpretan sus factores específicos.
  - *Confirmación de Vanessa (2026-10-20), antes de estimar:* V1 y V2 se aceptan; V3 se ajusta.
    - **V1** es un límite computacional operativo: si se alcanza sin convergencia, se registra y se examina la causa.
    - **V2** exige parámetros finitos y una solución admisible. Una comunalidad ≥ 0,99 es una señal de alerta muy
      fuerte; además se verifican los errores estándar (que se puedan calcular y sean finitos), las varianzas de los
      factores (fijas en 1 por identificación en el bifactor) y posibles soluciones de frontera, que se reportan.
    - **V3** se mantiene (al menos 3 ítems por competencia con carga específica ≥ 0,30 en valor absoluto), pero como
      **criterio operativo de viabilidad, no como prueba de validez ni de fiabilidad**: una carga de 0,30 no garantiza
      que el factor específico esté bien medido. Se registran cuántos ítems lo cumplen y los errores estándar de las
      pendientes específicas, sin agregar nuevos umbrales de aceptación después de ver los resultados.
    - Los tres cortes son decisiones metodológicas del proyecto, no estándares universales. Antes del informe se
      incorporan fuentes verificadas sobre modelos bifactor, cargas factoriales e índices de fiabilidad.
    - Si el modelo falla algún criterio, se documenta qué ocurrió y por qué. Si los supera, el ECV y el omega
      jerárquico de subescala se interpretan de forma exploratoria, sin modificar el modelo de 4 competencias ni las
      hipótesis preregistradas.
  - *Aporte de cada competencia (punto 2), solo si es viable:* la proporción de varianza común que explica el factor
    general (ECV) y la confiabilidad propia de cada competencia descontado el general (omega jerárquico de subescala).
    - Se reportan sin cortes: es un análisis exploratorio que no decide hipótesis, y el modelo de calificación sigue
      siendo el de 4 competencias.
    - *Fuente:* no está en el vault. Son índices usuales del análisis bifactor; hay que buscar y verificar una
      referencia antes de usarlos en el informe.
  - *Validación del modelo de 4 competencias (punto 1):* la confiabilidad empírica por competencia se calcula en el
    5.4, junto con los puntajes.
- **Resultado de la prueba de viabilidad (2026-10-20; `salidas/mat_bifactor_viabilidad.csv`, `mat_bifactor_frontera.csv`
  y `mat_bifactor_items.csv`):** el bifactor **no es viable** según los criterios fijados antes de estimar.
  - **Incumplidos:** V1, porque llegó a los 2.000 ciclos sin converger (174,6 min), y V2b, porque no se pudo calcular
    ningún error estándar. `mirt` avisó que no pudo invertir la matriz de información y que el modelo podría no estar
    identificado empíricamente con estos datos.
  - **Cumplidos:** V2a (parámetros finitos), V2c (comunalidad máxima 0,981) y V3 en las cuatro competencias (emplear 15
    de 75 ítems, formular 13 de 47, interpretar 15 de 57 y razonar 23 de 53). Sin convergencia ni errores estándar,
    esas cargas no son estimaciones confiables.
  - **Reportado sin umbral:** varianzas de los factores fijas en 1; carga general máxima 0,939; carga específica
    máxima 0,903; pendiente específica máxima 4,795.
- **Interpretación del equipo (Vanessa, 2026-10-20):**
  - El bifactor no cumplió los criterios de viabilidad. Esto impide interpretar de forma confiable las cargas
    específicas y cuantificar con este modelo el aporte independiente de cada competencia.
  - Tres explicaciones plausibles, que podrían actuar juntas; son compatibles con los resultados, pero no se puede
    establecer cuál explica el fallo sin análisis adicionales:
    1. **Alta dispersión de las respuestas:** cada estudiante respondió una mediana de 29 de los 232 ítems, con el
       11,7 % de las celdas observadas, lo que podría dificultar estimar un modelo con tantos parámetros.
    2. **Elevada correlación entre competencias:** las correlaciones de 0,90 a 0,98 del modelo de 4 competencias
       sugieren poca diferenciación empírica entre algunas dimensiones, lo que podría dificultar identificar los
       factores específicos.
    3. **Posibles problemas de estimación en algunos ítems:** la comunalidad de 0,981 y la pendiente específica de
       4,795 justifican examinar soluciones próximas a la frontera, aunque por sí solos no demuestran una solución
       impropia.
  - **Conclusión:** el bifactor no es viable bajo los criterios preregistrados. Esto no demuestra por sí mismo que el
    modelo de 4 competencias sea inválido ni confirma automáticamente el rechazo de H8: es un resultado metodológico
    que se documenta con transparencia.
- **Decisiones que siguen del resultado (Vanessa, 2026-10-20):**
  - no se interpretan las cargas específicas ni se reportan el ECV ni el omega jerárquico de subescala;
    `mat_bifactor_items.csv` lleva un aviso en cada fila y los errores estándar dicen «No calculable»;
  - no se amplía el límite de iteraciones ni se cambia la configuración para buscar un resultado favorable después
    de conocer el fallo;
  - se continúa con el paso 5.4 y el modelo de 4 competencias, verificando su ajuste, convergencia y precisión, y
    reconociendo las limitaciones de las correlaciones altas.
- **Estado:** ✅ (d) aceptada por Vanessa (2026-10-20), con la operacionalización y sus ajustes; los cortes de V2 y V3
  se fijan antes de estimar el bifactor. Mateo y Brayan la revisan en el PR. Revisada por Mateo (2026-11-10): de acuerdo.

### D-30 · 2026-10-20 · Estrategia de integración adaptativa para la posterior del 5.4 (posterior al resultado de V1)
- **Contexto:** V1 no se cumplió (D-27, 2026-10-20). El diagnóstico apunta a la integración en las colas: los
  estudiantes con EAP extremas tienen un tamaño efectivo de puntos muy bajo y ni el código propio ni `fscores()` se
  estabilizan al aumentar los puntos. **Esta decisión se toma después de conocer ese resultado**, y así se declara.
- **Decisión de Vanessa (2026-10-20):**
  1. V1 queda documentada como **fallida**. Se conservan los resultados, los diagnósticos y los umbrales originales; no
     se modifican retroactivamente para conseguir la aprobación.
  2. No se aprueba V1 ni se sigue aumentando indiscriminadamente el número de puntos QMC.
  3. Se autoriza **evaluar** una estrategia de integración adaptativa, que centre la distribución de propuesta en la
     región de mayor probabilidad posterior de cada estudiante, en lugar de usar solo puntos de la distribución latente
     general.
  4. La validación debe ser **independiente**: comparar casos ordinarios y extremos con una referencia numérica más
     precisa, por ejemplo integración adaptativa o simulación independiente de la posterior, según sea viable. No se
     valida contra la misma aproximación que está fallando.
  5. Los criterios de precisión originales (V1 a V3) se mantienen como objetivo, sin garantizar que la nueva
     estrategia los cumpla. Si no se demuestra precisión suficiente, esos puntajes no se presentan como fiables.
  - *Precisión de Vanessa:* que el código propio y `mirt` fallen igual no demuestra que la implementación sea
    correcta; sí sugiere que la referencia de `mirt` no es estable en los casos extremos. Un tamaño efectivo bajo
    indica integración insuficiente, pero no determina por sí solo el error de las EAP: se evalúa junto con la
    estabilidad de los puntajes y la incertidumbre posterior.
  - *Lo que no cambia:* no se descarta el modelo de 4 competencias por este fallo numérico, ni se pasa a la MAP ni a
    puntajes sin regresión latente.
- **Siguiente paso:** comparar dos o tres estrategias de integración adaptativa, sus requisitos computacionales y cómo
  validarlas sin depender de la aproximación que falla. La generación definitiva de puntajes queda detenida hasta
  resolver la validación.
- **Estado:** ✅ aceptada por Vanessa (2026-10-20); la estrategia concreta está por decidir. Mateo y Brayan la revisan
  en el PR. Revisada por Mateo (2026-11-10): de acuerdo.

### D-31 · 2026-10-20 · Métodos, referencia independiente y contingencias para la posterior del 5.4 (posterior al resultado de V1)
- **Contexto:** sigue de D-30. Se decide **después** de conocer el fallo de V1, y así se declara. Ningún código de esta
  decisión se ha escrito ni ejecutado al registrarla.
- **Decisión de Vanessa (2026-10-20):**
  1. **Métodos.**
     - **E1, cuadratura de Gauss-Hermite adaptativa:** método principal, condicionado a que la moda y la curvatura de
       cada estudiante se estimen de forma fiable y a que la cuadratura alcance estabilidad. Se elige porque ofrece una
       integración determinista cuyo error se estudia refinando la cuadratura, **no** porque se suponga que la
       posterior es normal; eso se comprueba. Si las posteriores resultan asimétricas, multimodales o difíciles de
       aproximar, se reconsidera su idoneidad.
     - **E2, muestreo de importancia adaptativo:** contraste numérico en los estudiantes y competencias donde E1 muestre
       dificultades, y comparación más amplia si el costo lo permite.
     - **E3, MCMC:** referencia independiente para evaluar E1 y E2 en casos extremos y ordinarios. No es válida solo
       por ser independiente de la cuadratura: tiene que demostrar convergencia y precisión.
  2. **Submuestra de E3: 277 estudiantes.**
     - Los 77 con tamaño efectivo de puntos menor que 100 en V1, donde falló la integración.
     - 200 elegidos al azar entre los demás, con semilla registrada y sin repetir a los 77. *Semilla propuesta:*
       `set.seed(2026)`, la de la división de mitades del 3.1.
     - Se amplía solo si los diagnósticos muestran problemas.
  3. **Criterios para aceptar E3 como referencia**, fijados antes de ejecutarla y aplicados **por estudiante y
     competencia**, no como promedio global:
     - 4 cadenas por estudiante, con R̂ ≤ 1,01 en los parámetros relevantes;
     - error estándar Monte Carlo de cada EAP ≤ 0,005 DE latente, pequeño frente al umbral de 0,02 de V1;
     - diagnósticos de mezcla y tamaño efectivo suficientes: no se acepta una referencia solo porque las cadenas
       terminaron;
     - si un caso no cumple, se prolongan o ajustan las cadenas; si el problema persiste, queda como referencia no
       validada.
     - La comparación mantiene constantes los parámetros de los ítems y de la regresión latente, para que los tres
       métodos estimen la misma posterior.
  4. **Protocolo si la moda no converge:**
     1. optimizar desde varios valores iniciales, incluido el centro de la distribución latente y estimaciones
        alternativas;
     2. verificar que el gradiente sea suficientemente pequeño y la curvatura válida: que el optimizador termine no
        basta para certificar la moda;
     3. si sigue fallando, no descartar al estudiante ni asignarle un puntaje automático: intentar E2 con una propuesta
        robusta que cubra varias regiones plausibles de la posterior y verificar su tamaño efectivo y su estabilidad;
     4. si E2 no se valida, usar E3 para ese caso si es viable y converge; si ningún método cumple los criterios, el
        puntaje queda como **no validado** y no se incluye silenciosamente en los resultados.
  5. **Criterios de precisión:** se conservan los umbrales originales de V1, V2 y V3 sin modificarlos. E1 se compara con
     E3 con los umbrales de V1, y su estabilidad se evalúa con V2 y V3. La comparación entre E1 y E2 es evidencia
     adicional, pero no sustituye la validación independiente.
  6. **Condición para avanzar:** no se generan ni publican puntajes definitivos hasta que la referencia independiente y
     los diagnósticos de estabilidad justifiquen que el método elegido es suficientemente preciso.
- **Pendientes resueltos por Vanessa (2026-10-20), antes de programar:**
  - **Semilla:** `set.seed(2026)` se mantiene. Que coincida con la del 3.1 no es un problema metodológico: la selección
    tiene que ser reproducible y quedar identificada en el código.
  - **Tamaño efectivo mínimo de las cadenas de E3:** ESS ≥ 1.000 por estudiante y competencia en los estimandos
    principales. Es un criterio operativo, no una garantía universal: complementa, no sustituye, el error Monte Carlo
    de la EAP ≤ 0,005 DE. Se mantienen R̂ ≤ 1,01 y los diagnósticos de mezcla; si discrepan, manda la evidencia de
    precisión, no el ESS aislado.
  - **Tolerancia de la moda:** norma infinita del gradiente de la log-posterior escalada ≤ 10⁻⁵, con una comprobación
    de curvatura válida. Se aplica en una parametrización y una escala documentadas; no basta con que el optimizador
    diga que convergió.
  - **E3 con un paquete, no con un Metropolis propio:** un Metropolis artesanal añade código crítico que habría que
    validar justo cuando se necesita una referencia confiable. El paquete se incorpora con un cambio documentado de
    D-17, coordinado con Mateo y Brayan. No se elige solo porque haga MCMC: tiene que permitir definir la posterior
    multivariada de cada estudiante y dar diagnósticos robustos. El R̂ calculado a mano no es la primera opción, por
    las limitaciones del diagnóstico tradicional que señalan Vehtari et al. (2021).
    - *Lo que hay que verificar al elegirlo (nota de Claude):* `rstan` y `cmdstanr` compilan cada modelo en C++ y
      necesitan Rtools, que este equipo no tiene (D-17 ya lo evitó con `mirt`). Hay paquetes que corren en R sin
      compilar y aceptan una log-densidad escrita en R, y existe el paquete `posterior`, que implementa los
      diagnósticos de Vehtari et al. (2021). Ninguno se ha instalado ni probado.
  - **Referencias candidatas, propuestas por Vanessa.** Están **por verificar** y no se agregan al vault hasta que el
    equipo las revise. Claude comprobó solo que existen y que sus datos bibliográficos coinciden (Crossref y PMLR,
    2026-10-20); no leyó su contenido.

    | Método | Referencia | Comprobación |
    |---|---|---|
    | E1 | Haberman, S. J. (2006). *Adaptive quadrature for item response models.* ETS Research Report Series. | Existe en Crossref, DOI 10.1002/j.2333-8504.2006.tb02035.x; el número RR-06-29 no aparece en los metadatos |
    | E1 | Antal, T., y Oranje, A. (2007). *Adaptive numerical integration for item response theory.* ETS Research Report Series. | Existe en Crossref, DOI 10.1002/j.2333-8504.2007.tb02048.x |
    | E2 | Guilmeau, T., Branchini, N., Chouzenoux, E., y Elvira, V. (2024). *Adaptive importance sampling for heavy-tailed distributions via α-divergence minimization.* PMLR, 238, 3871–3879. | Existe en la página de PMLR, con esos autores y páginas; no es específica de TRI |
    | E3 | Vehtari, A., Gelman, A., Simpson, D., Carpenter, B., y Bürkner, P.-C. (2021). *Rank-normalization, folding, and localization: An improved R̂ for assessing convergence of MCMC.* Bayesian Analysis, 16(2), 667–718. | Existe en Crossref, DOI 10.1214/20-BA1221 |
    | E3 | Hastings, W. K. (1970). *Monte Carlo sampling methods using Markov chains and their applications.* Biometrika, 57(1), 97–109. | Existe en Crossref, DOI 10.1093/biomet/57.1.97 |

  - **Orden de ejecución aprobado:**
    1. registrar estos umbrales y la decisión del paquete en un commit, antes de programar;
    2. revisar las fuentes con el equipo y agregarlas al vault solo después de su aprobación;
    3. probar E3 primero en unos pocos casos ordinarios y extremos: que las cadenas converjan y que el error Monte
       Carlo cumpla el límite;
    4. solo entonces correr la submuestra de 277 y contrastar E1 y E2.
  - *Precisión de Vanessa:* cuatro cadenas y ESS ≥ 1.000 no garantizan por sí solos la calidad de E3. Se evalúan juntos
    la convergencia, la mezcla, el error Monte Carlo de las EAP y la cobertura de la posterior. Si E3 no se puede
    validar, no se convierte en referencia: se documenta el fallo y se revisa el diseño antes de producir puntajes.
- **Estado:** ✅ aceptada por Vanessa (2026-10-20), con los pendientes resueltos; falta elegir el paquete de MCMC. Mateo y Brayan la revisan en el PR. Revisada por Mateo (2026-11-10): de acuerdo.
  - *Modificada por D-33 (2026-11-08):* solo E1, con plazo; E2, E3 y el paquete de MCMC no se hacen.

### D-32 · 2026-11-08 · Con qué puntajes se responde O4 después de rechazar H8 (F5–F6; desviación del preregistro)
- **Contexto:** evaluación del avance del 2026-11-08 (Claude, en el papel de profesor de doctorado; pedida por
  Vanessa). Se decide **después** de conocer el rechazo de H8 y el fallo de V1, y así se declara.
- **Lo que muestran los datos:**
  - H8 rechazada: correlaciones entre competencias de 0,897 a 0,976 (`salidas/mat_ajuste.csv`, D-27);
  - el modelo de 4 competencias tiene solo 6 parámetros más que el de 1 (532 frente a 526: las 6 correlaciones) y
    mejora la log-pseudoverosimilitud en 12,9 (−99.797,3 frente a −99.810,2; `salidas/mat_ajuste.csv`);
  - mediana de ítems por estudiante: emplear 9, formular 5, interpretar 7 y razonar 6
    (`salidas/mat_matriz_resumen.csv`);
  - el 5.4 está detenido desde el 2026-10-20 (V1 no se cumple; D-27, D-30 y D-31);
  - la bitácora de la rama `Vanessa` (fila del 2026-10-23, borrador, scripts del scratchpad) anota que con
    integración exacta la correlación emplear–razonar llega a la frontera (ρ → 1). **No está en el repositorio ni se
    ha verificado.**
- **Problema (interpretación de Claude):** con tan pocos ítems por competencia y correlaciones tan altas, el puntaje
  propio de cada competencia depende sobre todo de las otras competencias y del modelo de condicionamiento. Con esos
  puntajes, H5 (que compara interpretar con emplear, r = 0,951) y la segunda parte de H7 (correlación mayor con la
  propia competencia) casi no se pueden identificar.
- **Alternativas:**
  - (a) la F6 con los valores plausibles (VP) de proceso de la OCDE como análisis principal y los puntajes propios como
    secundarios;
  - (b) mantener el plan: puntajes propios como principal y VP de la OCDE como robustez;
  - (c) un puntaje global propio (modelo de 1 dimensión) y las competencias solo con los VP de la OCDE.
- **Decisión (Vanessa, 2026-11-08): (a).**
  1. La F6 (O4, H5 y H6) se estima con los 10 VP de proceso de la OCDE (`PV1MPEM`–`PV10MPEM`, `MPFS`, `MPIN` y
     `MPRE`, que ya están en `datos/COL_cuestionario.rds`: `01b_etl_cuestionario.R`, línea 61), con `W_FSTUWT`, las 80
     réplicas y las reglas de Rubin (D-34).
  2. Los puntajes propios, si el 5.4 se valida (D-33), pasan a análisis secundario: robustez de la F6 y base de H4 y H7.
  3. **Desviación del preregistro:** [[09 Hipótesis preregistradas]] dice que H5 se prueba «puntajes propios y PV
     OCDE», y [[06 Objetivos PISA 2022]] pone los puntajes de O3 como principales en O4. Se invierte el orden. Las
     reglas de decisión de H5 y H6 no cambian. Se anota en la nota 09.
  4. **Lo que no cambia:** H3 (DIF; no usa puntajes), H4 (necesita la recalificación propia y depende de D-33) y H7
     (depende de D-33).
- **Límites que hay que declarar (interpretación, por verificar en el Technical Report):** los VP de la OCDE están
  condicionados con el modelo de población de la OCDE, no con el NSE latente de la G2. Si ese modelo no incluye
  interacciones del NSE con la zona o el sector, las diferencias de pendiente que busca H6 salen atenuadas hacia la
  igualdad. Falta la página del Technical Report que describe el condicionamiento.
- **Propuesta de Claude (por confirmar por Vanessa):** declarar **H5 exploratoria** en el informe. La hipótesis salió
  de la revisión del 2026-09-29 sobre los 7.804 estudiantes, que incluyen a la mitad de confirmación, así que ninguna
  parte de estos datos es independiente de su origen. La nota de H5 en la nota 09 ya la llama «exploratoria en origen».
- **Estado:** ✅ (a) aceptada por Vanessa (2026-11-08). ~~La propuesta sobre H5, por confirmar.~~ *H5 exploratoria:
  confirmada por Vanessa el mismo día.* Mateo y Brayan la revisan en el PR. Revisada por Mateo (2026-11-10): de acuerdo.

### D-33 · 2026-11-08 · El 5.4 sigue solo con E1 y con plazo (modifica D-31)
- **Contexto:** V1 no se cumple (`salidas/mat_posterior_V1.csv`: diferencia máxima de 0,206 a 0,254 DE). D-31 preveía
  tres métodos (E1, E2 y E3) y un paquete de MCMC que obligaba a cambiar D-17. Con D-32, los puntajes propios son
  secundarios. Se decide **después** de conocer el fallo de V1.
- **Decisión (Vanessa, 2026-11-08):**
  1. **Solo E1:** cuadratura de Gauss-Hermite adaptativa programada en el proyecto, centrada en la moda de la posterior
     de cada estudiante y escalada con su curvatura (D-31 punto 1). No se instalan paquetes nuevos; E2 y E3 no se hacen.
  2. **Validación contra una malla fina** en la submuestra de D-31 punto 2 (los 77 estudiantes con tamaño efectivo
     menor que 100 en V1 y 200 al azar con `set.seed(2026)`).
  3. **Plazo: 2026-11-12.** Si para esa fecha E1 no cumple V1 a V3 (umbrales de D-27, sin cambios), se documenta, el 5.4
     se suspende y H4 y H7 se reportan como **no evaluables**.
- **Detalles de implementación (propuestos por Claude y fijados antes de correr; Vanessa puede ajustarlos):**
  - *Moda:* `optim()` con BFGS desde la media latente del estudiante; se acepta si la norma infinita del gradiente es
    ≤ 10⁻⁵ y la Hessiana negativa es definida positiva (D-31 punto 4). Si no, se reintenta desde el origen y desde la
    EAP sin covariables; si sigue fallando, el estudiante queda como **no validado** (D-31 punto 4.4).
  - *E1:* malla producto de Gauss-Hermite con 5 puntos por dimensión (625) en las coordenadas de la moda y de la
    Cholesky de la inversa de la Hessiana; resolución duplicada para V2 y V3: 7 puntos por dimensión (2.401).
  - *Referencia (V1):* regla del rectángulo en una malla de 21 puntos por dimensión sobre ± 6 desviaciones posteriores
    alrededor de la moda (194.481 puntos). No supone que la posterior sea normal y es determinista. Se comprueba que
    ampliar a ± 8 no cambia la EAP en más de 0,005 DE.
  - *Orden:* (1) E1 sin covariables frente a la referencia en los 277; (2) V2 y V3 en los 6.886; (3) solo si se
    cumplen, la regresión latente de D-27 punto 4 con los ítems fijos, y E1 con covariables.
- **Estado:** ✅ aceptada por Vanessa (2026-11-08); detalles de implementación por confirmar. Mateo y Brayan la revisan
  en el PR. Revisada por Mateo (2026-11-10): de acuerdo.
- **Reproducción previa (2026-11-08, en este equipo, donde no estaban los cachés de la F5):** `05_tri_competencias.R`
  (sin el bifactor) re-estimó los modelos de 1 y 4 dimensiones y V1. `mat_matriz_resumen.csv`, `mat_ajuste.csv` y
  `mat_posterior_V1.csv` salieron idénticos a los del commit, salvo los minutos de cálculo.
- **Resultado de E1 sin covariables** (`scripts/05_puntajes_e1.R` → `salidas/mat_e1_validacion.csv` y
  `mat_e1_resumen.csv`; 2026-11-08): **se cumplen V1, V2, V3 y la cobertura.**
  - Moda aceptada en los 6.886 (gradiente máximo 1,0 · 10⁻¹⁰; hasta 13 iteraciones de Newton). Las probabilidades
    programadas coinciden con `probtrace()` (diferencia máxima 2,2 · 10⁻¹⁶).
  - La submuestra reproduce los conteos de V1: 36 estudiantes con tamaño efectivo < 50 y **77 con < 100** (D-27), más
    200 al azar.

  | Competencia | V1: dif. máx. con la referencia (277 / solo los 77) | V2: dif. media / P95 (5 vs 7 puntos) | V3: dif. relativa del EE, mediana / P95 |
  |---|---|---|---|
  | Emplear | 0,0019 / 0,0012 | 0,0003 / 0,0009 | 0,05 % / 0,25 % |
  | Formular | 0,0016 / 0,0010 | 0,0002 / 0,0008 | 0,04 % / 0,16 % |
  | Interpretar | 0,0016 / 0,0011 | 0,0002 / 0,0008 | 0,04 % / 0,20 % |
  | Razonar | 0,0019 / 0,0011 | 0,0003 / 0,0009 | 0,04 % / 0,22 % |

  - La correlación con la referencia y entre resoluciones redondea a 1,000000. Ampliar la referencia de ± 6 a ± 8
    cambia la EAP como máximo en 0,00001 DE.
  - **Lectura (dato):** con la integración centrada en la moda, la diferencia máxima baja de 0,21–0,25 DE (V1 original)
    a menos de 0,002 DE, también en los 77 casos extremos. El fallo de V1 venía de integrar con puntos de la previa,
    como anticipaba el diagnóstico de D-27; E1 lo resuelve.
  - Sigue el paso 3 de D-33: la regresión latente con los ítems fijos y E1 con covariables (con las interacciones de
    D-37).

### D-34 · 2026-11-08 · Errores estándar con BRR para las cifras finales (cierra D-23 punto 5)
- **Problema:** después de la F2 ninguna cifra tiene un error estándar que refleje el diseño por colegios (D-16
  punto 5). `salidas/nse_medias_latentes.csv` lo advierte en cada fila, y las correlaciones entre competencias no
  tienen error estándar (`SE = FALSE`).
- **Alternativas:** (a) BRR con las 80 réplicas y Fay 0,5 solo en las cifras finales; (b) *bootstrap* por colegio;
  (c) declarar la limitación sin corregirla.
- **Decisión (Vanessa, 2026-11-08): (a).**
  1. **Medias latentes de la F4:** en cada réplica se re-estima el modelo escalar de cada análisis (zona, rural–urbana,
     sexo y sector) con el peso replicado normalizado y las mismas restricciones, partiendo de la solución de la
     muestra completa. Varianza con la fórmula de `utilidades_pisa.R`: 0,05 · Σ (θ_t − θ)².
     - Si una réplica no converge se excluye y se reporta. Si fallan más de 4 de 80 (5 %), ese análisis no tiene error
       BRR y se dice.
  2. **Coeficientes de la F6:** cada modelo con cada uno de los 10 VP de la OCDE y los 81 pesos (810 ajustes por
     modelo), combinados con Rubin.
  3. Lo demás (AFC, TRI, DIF) queda como estimación puntual descriptiva, con el aviso de que sus errores no reflejan el
     diseño.
- **Estado:** ✅ aceptada por Vanessa (2026-11-08). Mateo y Brayan la revisan en el PR. Revisada por Mateo (2026-11-10): de acuerdo.
- **Resultado del punto 1 (2026-11-09, `04_medias_brr.R` → `salidas/nse_medias_latentes_brr.csv`):** las 80 réplicas
  convergieron en los cuatro análisis (ninguna exclusión).

  | Contraste | Económico: diferencia (EE BRR) | IC 95 % BRR | Libros: diferencia (EE BRR) | IC 95 % BRR |
  |---|---|---|---|---|
  | Pueblo − urbana | −0,630 (0,108) | −0,841 a −0,419 | −0,194 (0,077) | −0,344 a −0,044 |
  | Rural − urbana (H2) | −0,950 (0,142) | −1,230 a −0,671 | −0,173 (0,088) | −0,346 a 0,000 |
  | Hombre − mujer | 0,052 (0,033) | −0,014 a 0,117 | −0,123 (0,037) | −0,195 a −0,051 |
  | Privado − público | 1,433 (0,161) | 1,118 a 1,748 | 0,604 (0,103) | 0,402 a 0,806 |

  - **Lectura (dato):** el EE BRR es de 1,16 a 3,66 veces el de `lavaan` (columna `razon_ee`); la subestimación es
    mayor en zona y sector, que se agrupan por colegio, y casi nula en sexo, que varía dentro del colegio.
  - **Qué cambia frente a la F4:** las diferencias económicas por zona y sector y la de libros por sector, pueblo y sexo
    siguen excluyendo el 0. La de **libros rural − urbana pasa a estar en el límite** (el IC toca 0), así que ya no se
    puede afirmar con el 95 %. La económica por sexo no excluía el 0 ni con el EE de `lavaan` (z ≈ 1,86).
  - Los minutos de la tabla incluyen la suspensión del equipo de esa noche en el análisis rural–urbana (496,5); no son
    tiempo de cálculo.
  - Las cifras puntuales coinciden con `nse_medias_latentes.csv` (lo que cambia es el error).

### D-35 · 2026-11-08 · Conclusiones de la F3–F4 corregidas y dos sensibilidades exploratorias
- **Problema (errores de redacción de Claude en el vault):**
  - «La invarianza escalar total se sostiene» ([[00 Inicio]], [[07 Plan de desarrollo PISA 2022]]) dice más de lo que
    muestran los datos. Con ΔCFI y ΔRMSEA *scaled* (D-25) ningún paso pasa los cortes, pero:
    - la prueba de diferencia escalada rechaza en 10 de 12 pasos (D-28; rural–urbana escalar: Δχ² = 273,4 con 21 gl);
    - el CFI *scaled* **mejora** al restringir las cargas, de +0,004 a +0,006, así que no se comporta como medida de
      ajuste (`salidas/invarianza_tabla.csv`);
    - el ajuste configural es pobre en las versiones *robust*: CFI de 0,68 a 0,71 donde se pudo calcular, y no sale en
      4 de los 7 grupos (`salidas/invarianza_por_grupo.csv`).
  - H1 se acepta por su regla, pero los dos modelos desajustan en las versiones *robust* (CFI 0,514 con 1 factor y
    0,731 con 2; `salidas/nse_ajuste_afc.csv`).
- **Redacción corregida (se aplica en las notas 00, 07 y 09):** «Con el criterio preregistrado (ΔCFI/ΔRMSEA *scaled*)
  no se detectó no invarianza de magnitud relevante. No equivale a demostrar la invarianza: la prueba χ² la rechaza y
  el ajuste de partida es pobre». H2 sigue rechazada por su regla.
- **Sensibilidades exploratorias (decisión de Vanessa, 2026-11-08; no cambian el modelo de la G2, H1 ni H2):**
  - **S1, ceros de D-20.** Se re-estima la TRI de 2 dimensiones del AFE con los saltos de ST256 y ST254 como
    faltantes, como antes de D-20. Esa falta depende solo de ST255 y ST253, que están observados, así que es ignorable
    en una TRI por verosimilitud (interpretación). Se comparan: cargas de los libros (hoy 0,92 a 0,98,
    `salidas/nse_tri_cargas_2d.csv`), información máxima, confiabilidad, validez con HOMEPOS y ESCS, correlación entre
    las EAP de las dos versiones y los Q3 negativos ST255–ST256 (hoy −0,21 a −0,27, `salidas/nse_q3_tri.csv`).
  - **S2, emparejamiento del DIF.** El ΔR² del DIF de posesiones se calcula con EAP de un modelo de un solo grupo, que
    contrae a todos hacia una media común aunque los grupos difieren hasta 1,4 DE (`salidas/nse_medias_latentes.csv`).
    Se repite el ΔR² con EAP de un modelo multigrupo con todos los ítems iguales y medias y varianzas libres por grupo
    (`mirt::multipleGroup`, con pesos), con el mismo corte (0,035).
    - De paso se corrige que la vuelta 2 del DIF aplicaba Benjamini-Hochberg solo a los ítems probados, mientras las
      anclas conservaban el valor de la vuelta 1 (`04_invarianza.R`, líneas 278–283): se recalcula sobre los valores p
      finales de cada análisis y factor, como una sola familia.
- **Estado:** ✅ aceptada por Vanessa (2026-11-08). Mateo y Brayan la revisan en el PR. Revisada por Mateo (2026-11-10): de acuerdo.
- **Resultado de S1** (`scripts/03_nse_sens_d20.R` → `salidas/nse_sens_d20_resumen.csv` y `nse_sens_d20_items.csv`;
  2026-11-08; 1.002 estudiantes sin libros y 182 sin dispositivos con los saltos como faltantes; el EM convergió):

  | Medida | Con D-20 (saltos = 0) | S1 (saltos = faltante) |
  |---|---|---|
  | Información máxima del factor libros (θ) | 33,1 (1,4) | 13,2 (1,6) |
  | Rango con información ≥ 4, libros | −1,5 a 2,6 | −0,9 a 2,9 |
  | Confiabilidad empírica, libros / económico | 0,902 / 0,898 | 0,813 / 0,894 |
  | Correlación entre factores | 0,483 | 0,569 |
  | Libros: r con HOMEPOS / ESCS | 0,618 / 0,473 | 0,748 / 0,581 |
  | Económico: r con HOMEPOS / ESCS | 0,962 / 0,809 | 0,969 / 0,821 |
  | Q3 ST255–ST256: mínimo / pares con \|Q3\| > 0,2 | −0,266 / 5 | −0,217 / 3 |

  - Las cargas de los tipos de libros bajan: de 0,918 a 0,668 en `ST256Q01JA` (religiosos) y entre 0,03 y 0,11 en los
    demás. Las EAP de las dos versiones correlacionan 0,995 (económico) y 0,923 (libros).
  - **Lectura (dato):** los ceros de D-20 **inflaban la precisión del factor libros** (la información máxima baja a
    menos de la mitad y la confiabilidad de 0,90 a 0,81) y achicaban su relación con el NSE oficial. El factor
    económico, el que deciden H5, H6 y los cuartiles de H3 y H4 (D-22, D-24), **casi no cambia**.
  - *Interpretación (Claude, por discutir):* para el factor económico, D-20 no importa. El factor libros es más
    impreciso de lo reportado en la G2. Si se usa en el informe, conviene reportarlo con la versión S1 o con las dos.
    No cambia nada sin una decisión nueva.
- **Resultado de S2** (`scripts/04_dif_emparejamiento.R` → `salidas/nse_dif_sens_emparejamiento.csv`; 2026-11-08; los
  8 modelos multigrupo convergieron):
  - Las EAP multigrupo correlacionan de 0,9955 a 0,9979 con las de la G2, y el ΔR² cambia como máximo en la tercera
    cifra decimal.
  - Motos (`ST251Q02JA`) sigue con DIF por zona (ΔR² 0,0416 → 0,0435) y **pasa el corte por sector** (0,0329 → 0,0350).
    Ningún otro ítem cambia de clasificación.
  - Benjamini-Hochberg como una sola familia no cambia la significancia de ningún ítem (0 de 116).
  - **H2 no cambia:** se rechaza por la primera condición (`salidas/inv_h2.csv`).
  - *Lectura:* la contracción de las EAP no fabricaba ni tapaba DIF de magnitud relevante, salvo motos por sector,
    que queda en el límite. Se reporta motos con DIF por zona y, con el emparejamiento multigrupo, también por sector.

### D-36 · 2026-11-08 · El DIF de H3 se calibra con el modelo conjunto de 1 dimensión (corrige D-27 punto 7)
- **Problema (evaluación del 2026-11-08):** D-27 punto 7 hace el DIF de matemáticas con «un modelo unidimensional por
  competencia», pero D-27 (al final) y D-29 (c) descartan calibrar por competencia porque la ruta adaptativa depende de
  ítems de otras competencias y la falta de datos solo es ignorable si se calibran todos juntos. Son incompatibles.
- **Decisión (Vanessa, 2026-11-08):** el DIF del paso 5.6 usa `multipleGroup()` con **los 232 ítems en 1 dimensión**
  (el modelo que gana por BIC en `salidas/mat_ajuste.csv`), cuartil bajo frente al alto del NSE económico, con medias y
  varianzas libres por grupo y sin pesos (lógica de D-26).
  - Se prueban los ítems elegibles de cada competencia (165, D-27) con anclas depuradas en 2 vueltas; Benjamini-Hochberg
    al 5 % dentro de cada competencia, como **una sola familia** por competencia (D-35).
  - La magnitud no cambia (D-22): Mantel-Haenszel en los dicotómicos, estratificado por deciles de la EAP **del modelo
    multigrupo** (D-35, S2), y ΔR² ≥ 0,035 en los de crédito parcial.
  - La segunda parte de H3 (Fisher, interpretar + formular frente a emplear) no cambia.
- **Estado:** ✅ aceptada por Vanessa (2026-11-08). Mateo y Brayan la revisan en el PR. Revisada por Mateo (2026-11-10): de acuerdo.

### D-37 · 2026-11-08 · Interacciones en la regresión latente de los puntajes propios (modifica D-27 punto 4)
- **Problema:** el modelo de condicionamiento de D-27 punto 4 solo tiene efectos principales (NSE, sexo, grado, zona y
  sector). Si las pendientes del NSE difieren por zona o sector (H6), unos valores plausibles generados sin esas
  interacciones las atenúan hacia la igualdad (interpretación; la regla general es que el modelo de imputación incluya
  lo que va a analizarse).
- **Decisión (Vanessa, 2026-11-08):** si E1 se valida (D-33), la regresión latente incluye además **NSE económico ×
  zona y NSE económico × sector** (con las categorías «sin dato» de D-27). Solo afecta a los puntajes propios, que son
  secundarios (D-32). Con los VP de la OCDE no se puede cambiar el condicionamiento: se declara como límite de H6.
- **Estado:** ✅ aceptada por Vanessa (2026-11-08). Mateo y Brayan la revisan en el PR. Revisada por Mateo (2026-11-10): de acuerdo.

### D-38 · 2026-11-08 · Sensibilidad de la F7 a la exclusión no aleatoria: reponderación por colegio (D-14)
- **Problema:** los 918 excluidos de la muestra analítica rinden 14,6 puntos menos (EE 3,0; z = −4,86;
  `salidas/comparacion_incluidos_excluidos.csv`), y los análisis usan `W_FSTUWT` sin ajustar: describen la población
  analítica (87,5 % de la ponderada), no a todos los estudiantes.
- **Decisión (Vanessa, 2026-11-08):** en la F7 (paso 7.1) se repiten los resultados principales con un **ajuste de no
  respuesta por colegio**: el peso de cada incluido (y cada réplica) se multiplica por la suma de los pesos de todos los
  estudiantes de su colegio entre la suma de los pesos de los incluidos de ese colegio. Los colegios sin ningún incluido
  se reportan aparte.
  - *Por qué así:* es simple y sigue la lógica del ajuste de no respuesta dentro de las celdas del diseño; corrige la
    parte de la exclusión que se explica por el colegio, no la que ocurre dentro de él (interpretación).
- **Estado:** ✅ aceptada por Vanessa (2026-11-08). Mateo y Brayan la revisan en el PR. Revisada por Mateo (2026-11-10): de acuerdo.

### D-39 · 2026-11-08 · Cómo se estima la regresión latente del 5.4 (paso 3 de D-33)
- **Problema:** con E1 validado (D-33), falta estimar la regresión latente de D-27 punto 4 (con las interacciones de
  D-37) con los ítems fijos en el modelo de 4 competencias. D-27 preveía `covdata` y `formula` de `mirt`, pero esa vía
  integra con puntos de la previa, la misma que falló en V1 en los casos extremos.
- **Decisión (Vanessa, 2026-11-08):**
  1. **EM propio con E1.** Paso E: la posterior de cada estudiante con E1 (5 puntos por dimensión), con media
     x_i'Γ y covarianza Σ. Paso M: Γ por mínimos cuadrados ponderados de las EAP sobre las covariables, y Σ = promedio
     ponderado de (EAP − x_i'Γ)(EAP − x_i'Γ)' + covarianza posterior. Pesos `W_FSTUWT` normalizados. Es el algoritmo
     clásico de los valores plausibles condicionados (interpretación; falta la fuente: el capítulo de escalamiento del
     Technical Report, por ubicar).
  2. **Covariables** (18 columnas por competencia): intercepto; EAP económico y de libros de la G2 (D-24); sexo;
     **`GRADE` categórico** (5 niveles, el modal como referencia); zona (pueblo, rural y sin dato; referencia urbana);
     sector (privado y sin dato; referencia público); NSE económico × zona y NSE económico × sector (D-37).
- **Detalles de implementación (propuestos por Claude, fijados antes de correr):**
  - Inicio: ~~Γ = 0~~ Γ de la regresión ponderada de las EAP sin covariables (`05_puntajes_e1.R`) sobre las
    covariables (cambiado antes de correr, el mismo día: es el mismo algoritmo y el mismo punto de llegada, pero
    converge en menos iteraciones) y Σ = la covarianza latente del modelo de 4 competencias. Convergencia: el cambio máximo de Γ y de
    Σ entre iteraciones ≤ 10⁻⁴, con un máximo de 300 iteraciones; cada iteración se guarda en un caché para retomar.
  - *Aceleración (2026-11-08, durante la corrida):* el EM convergía con una razón de ~0,93 por iteración (cambio de Γ
    0,0133 → 0,0123 en las iteraciones 8 y 9), lo que suponía unas 6 horas más. Desde la iteración 9 se acelera con
    **SQUAREM** (esquema S3; Varadhan y Roland, 2008, referencia que no está en el vault y que hay que verificar): dos
    pasos del EM, una extrapolación y un paso de estabilización por ciclo. Llega al mismo punto fijo que el EM, y el
    criterio de convergencia no cambia (un paso del EM ≤ 10⁻⁴). Si la extrapolación deja una Σ no definida positiva, se
    usa el paso del EM sin acelerar.
  - Con los parámetros finales: V2 y V3 con covariables (5 frente a 7 puntos, los 6.886) y V1 con covariables (E1
    frente a la malla fina en los mismos 277), con los umbrales de D-27.
  - Valores plausibles: 10 por estudiante de la normal con la EAP y la covarianza posterior (D-27, detalle 3),
    `set.seed(2026)`, con los controles de D-27 (media de los VP frente a la media de las EAP; covarianza total frente a
    la covarianza de las EAP más la covarianza posterior media).
  - Los coeficientes de Γ se reportan sin errores estándar: son parámetros del modelo de imputación, no estimaciones
    para interpretar (las inferencias van en la F6 con BRR, D-34).
- **Estado:** ✅ aceptada por Vanessa (2026-11-08): EM propio y `GRADE` categórico. Mateo y Brayan la revisan en el PR. Revisada por Mateo (2026-11-10): de acuerdo.
- **Resultado (2026-11-09, `05_puntajes_rl.R`; log de la corrida en el scratchpad de Claude, no en el repositorio):**
  - **Convergencia:** el EM convergió en 45 iteraciones (último paso: cambio de Γ 0,0000948 y de Σ 0,0000266). Los
    530,8 minutos de `minutos_EM_esta_corrida` incluyen unas 6 horas en que el equipo estuvo suspendido; no es el
    tiempo de cálculo. *Nota de Claude:* el criterio mide un paso del EM, no la distancia al punto fijo; con la razón
    de ~0,93 observada antes de acelerar, esa distancia puede ser ~14 veces el último paso (≈ 0,0013 DE en Γ), que es
    despreciable frente a coeficientes de 0,1 a 0,3 (interpretación).
  - **Validación con covariables** (`salidas/mat_rl_validacion.csv`): las cuatro competencias cumplen V1, V2 y V3.
    Diferencia máxima de V1 entre 0,00135 y 0,00156 DE; diferencia media de V2 ≤ 0,00016 DE; los casos extremos quedan
    cubiertos (diferencia 0).
  - **Ajuste** (`salidas/mat_rl_ajuste.csv`): R² latente entre 0,360 (razonar) y 0,386 (emplear); varianza residual
    entre 0,599 y 0,622.
  - **Confiabilidad empírica** (`salidas/mat_confiabilidad_competencias.csv`): con covariables, entre 0,760 (formular) y
    0,817 (emplear); sin covariables, entre 0,741 y 0,793.
  - **Controles de los VP** (`salidas/mat_pv_controles.csv`): diferencia de medias VP − EAP ≤ 0,0034 y razón de
    varianzas entre 0,9987 y 1,0014; las correlaciones totales de los VP coinciden con las esperadas al tercer decimal.
  - **Coeficientes** (`salidas/mat_rl_coeficientes.csv`, sin EE por el punto anterior): NSE económico entre 0,256 y
    0,315 DE, el mayor en interpretar, como en la F6 (D-42); libros entre 0,103 y 0,162.
  - Las correlaciones entre competencias siguen muy altas (emplear–razonar 0,979 entre VP), coherente con el rechazo de
    H8 (D-27).
  - **Conclusión:** los puntajes propios son **válidos según V1–V3** y el paso 5.4 queda cerrado antes del plazo de
    D-33 (2026-11-12). H4 y H7 pasan a ser evaluables (`05_h4_h7.R`).

### D-40 · 2026-11-08 · Detalles del DIF de matemáticas y de H3 (paso 5.6; completa D-22, D-27 punto 7 y D-36)
- **Problema:** D-22, D-27 y D-36 fijan el método del DIF de H3, pero dejan abiertos el sentido de la prueba de Fisher,
  los pesos y qué ítems entran a la calibración. Se fijan **antes de correrlo**.
- **Decisión (Vanessa, 2026-11-08):**
  1. **Grupos:** cuartil bajo (Q1, focal) y alto (Q4, referencia) del NSE económico de la G2 (`eap_AFE_ECO`), con los
     cuartiles ponderados de `05_explorar_items.R` (línea 88). Solo entran los estudiantes de Q1 y Q4.
  2. **Ítems de la calibración:** los de la versión (a) de la matriz (D-27) con todas sus categorías observadas en Q1 y en
     Q4. Se **prueban** solo los 165 elegibles (≥ 100 respuestas en cada cuartil, `salidas/items_respuestas.csv`); los
     demás son siempre anclas. Se reporta cuántos quedan fuera.
  3. **Modelo y prueba (D-36):** `multipleGroup()` de 1 dimensión, 2PL y GPCM, **sin pesos** (D-26), con medias y
     varianzas libres. Vuelta 1: todos los ítems como anclas y `DIF(scheme = "drop")`. Vuelta 2: anclas = los que no
     salieron significativos y `DIF(scheme = "add")` para los significativos. Benjamini-Hochberg al 5 % como **una sola
     familia por competencia** sobre los valores p finales (D-35).
  4. **Magnitud, como en la F4: con pesos** (`W_FSTUWT` normalizado). Emparejamiento: EAP del modelo multigrupo de la
     vuelta 1, con la media de cada grupo (D-35, S2).
     - Dicotómicos: ΔMH = −2,35 ln(α_MH), con α_MH ponderado y 10 estratos por deciles de esa EAP (Q4 de referencia: un
       ΔMH negativo favorece al cuartil alto). La prueba χ² de Mantel-Haenszel va **sin pesos**. Categorías del ETS
       (D-22): A si la prueba MH no es significativa o |ΔMH| ≤ 1; B si es significativa y 1 < |ΔMH| ≤ 1,5; C si es
       significativa y |ΔMH| > 1,5.
     - Crédito parcial: ΔR² de Nagelkerke ≥ 0,035 (la misma función que la F4).
  5. **Un ítem tiene DIF** si su prueba TRI es significativa con BH **y** su efecto es no despreciable (B o C, o
     ΔR² ≥ 0,035).
  6. **H3, primera parte:** se acepta si al menos 1 ítem tiene DIF. **Segunda parte:** prueba exacta de Fisher de **una
     cola** («mayor»), con los ítems elegibles: proporción con DIF en interpretar + formular frente a emplear, α = 0,05.
- **Salidas previstas:** `scripts/05_dif_matematicas.R` → `salidas/mat_dif.csv`, `mat_dif_resumen.csv` y `mat_h3.csv`.
- *Al correrlo (2026-11-08):* en Q1 quedan 1.473 estudiantes y en Q4, 1.975 (los cuartiles son ponderados). Entran a la
  calibración 213 de los 232 ítems. **11 de los 165 elegibles no tienen todas sus categorías en los dos grupos** y no se
  pueden probar con el modelo multigrupo (punto 2): `CM948Q03S`, `CM955Q03S`, `CMA152Q02S`, `DM949Q03C`, `DMA136Q02C`,
  `DMA142Q02C`, `CM464Q01S`, `CM943Q02S`, `DM462Q01C`, `DMA146Q03C` y `DMA156Q01C`. Se prueban 154.
- **Estado:** ✅ aceptada por Vanessa (2026-11-08): Fisher de una cola, pesos como en la F4 e ítems con todas sus
  categorías en los dos grupos. Mateo y Brayan la revisan en el PR. Revisada por Mateo (2026-11-10): de acuerdo.
- **Resultado (2026-11-09, `05_dif_matematicas.R` → `salidas/mat_dif.csv`, `mat_dif_resumen.csv` y `mat_h3.csv`):**
  - Vuelta 1: 14 de 154 significativos con BH; vuelta 2 con 199 anclas depuradas. Media latente de Q1 frente a Q4 en el
    modelo de la vuelta 1: −1,207 DE.
  - Por competencia (elegibles probados / significativos con BH / con DIF): emplear 57 / 6 / **3**; formular 29 / 0 / 0;
    interpretar 37 / 3 / 0; razonar 31 / 1 / 0.
  - **Ítems con DIF** (los tres de emplear, dicotómicos): `CMA113Q03S` (ΔMH 1,13, B, favorece a Q1), `CMA131Q02S`
    (ΔMH −1,33, B, favorece a Q4) y `CMA135Q04S` (ΔMH 2,07, C, favorece a Q1).
  - **H3 se acepta solo en su primera parte:** hay 3 de 154 ítems con DIF. La segunda se rechaza: interpretar +
    formular tienen 0 de 66 frente a 3 de 57 en emplear (Fisher de una cola, p = 1). El DIF que hay va **en contra**
    de lo que planteaba H3, y dos de los tres ítems favorecen al cuartil bajo.
  - *Interpretación de Claude (por discutir):* (i) con 3 de 154 (≈ 2 %) y efectos en dos sentidos, el DIF por NSE es
    escaso y no apunta a un sesgo sistemático contra el cuartil bajo; (ii) `CMA131Q02S` es el ítem con discriminación
    casi nula en el modelo de 4 competencias (a = 0,002, D-41), así que su DIF puede reflejar un mal funcionamiento
    general del ítem en Colombia más que un sesgo por NSE; (iii) el error de la prueba no refleja el diseño por
    colegios (D-34 punto 3).
  - *Salvedad encontrada por Claude al construir la API (2026-11-09):* en `mat_dif.csv`, `DM446Q02C` (formular) y
    `CM00GQ01S` (razonar) tienen ΔMH infinito (`Inf`) y la prueba MH no se pudo calcular (`p_MH` vacío),
    probablemente por celdas vacías en algún estrato. `05_dif_matematicas.R` los clasifica como A porque trata un MH no
    calculable como no significativo. No cambia H3 (su prueba TRI no es significativa: p_BH 0,155 y 0,596), pero su
    categoría A no es una magnitud observada y así debe decirse. En la API quedan con `delta_mh = null` y
    `mh_calculable = false` (D-46).

### D-41 · 2026-11-08 · Detalles de H4 (paso 5.7) y de H7 con el enlace P3 (paso 5.5)
- **Problema:** D-22 y D-27 fijan H4 y H7, pero dejan abiertos qué parte del modelo se mantiene fija al recalificar, cómo
  se generan los VP de las tres calificaciones y qué ítems entran al enlace con los parámetros internacionales (P3). Se
  fijan **antes de correrlos**, con los puntajes de D-39.
- **Decisión (Vanessa, 2026-11-08):**
  1. **H4, modelo fijo:** las calificaciones (b) omisión rápida = faltante y (c) toda omisión = faltante usan los mismos
     ítems **y la misma regresión latente** (Γ y Σ) que la (a) (D-27 punto 5): solo cambian los datos. La posterior de
     cada versión se calcula con E1.
  2. **H4, números aleatorios comunes:** los 10 VP de (a), (b) y (c) salen de las mismas extracciones normales
     (`set.seed(2026)`, en el mismo orden que en `05_puntajes_rl.R`), para que la diferencia refleje la calificación y no
     el ruido de Monte Carlo.
  3. **H4, cálculo (D-22, D-27 punto 6):** cuartiles del NSE económico como en H3 (D-40). Brecha = (media ponderada de Q4 −
     media de Q1) / DE ponderada del puntaje (a), en cada VP; reducción = brecha (a) − brecha (b). Error con las 80
     réplicas BRR (cuartiles fijos, la DE se recalcula en cada réplica) y Rubin. Se acepta si en al menos una competencia
     la reducción es ≥ 0,05 DE y significativa después de Holm sobre las 4 (p bilateral). (c) se reporta como
     sensibilidad.
  4. **H7 (D-22):** promedio de las 10 correlaciones ponderadas VP propio *m* – VP de la OCDE *m* (emplear `MPEM`,
     formular `MPFS`, interpretar `MPIN`, razonar `MPRE`), en una matriz de 4 × 4. Primera parte: ≥ 0,80 en las cuatro.
     Segunda: en cada competencia propia, la correlación con la misma competencia de la OCDE es mayor que con las otras
     tres.
  5. **P3:** enlace media–sigma por competencia **solo con los ítems dicotómicos**: b propio = −d / a (modelo de 4
     competencias) frente a `b_int` del anexo A (`salidas/items_competencia.csv`). Se reportan la correlación y la
     diferencia cuadrática media después del enlace. Los de crédito parcial se reportan aparte, sin enlazar.
- **Salidas previstas:** `scripts/05_h4_h7.R` → `salidas/mat_h4_brechas.csv`, `mat_h4.csv`, `mat_h7_correlaciones.csv`,
  `mat_h7.csv` y `mat_p3_enlace.csv`.
- **Estado:** ✅ aceptada por Vanessa (2026-11-08): regresión latente fija, números comunes y P3 con los dicotómicos.
  Mateo y Brayan la revisan en el PR. Revisada por Mateo (2026-11-10): de acuerdo.
- **Resultado (2026-11-09, `05_h4_h7.R`, con los puntajes validados de D-39):**
  - **H4 se rechaza** (`salidas/mat_h4_brechas.csv` y `mat_h4.csv`). La brecha Q4 − Q1 con la calificación (a) es de
    1,17 a 1,23 DE. Tratar las omisiones rápidas como faltantes la reduce solo **0,0073 a 0,0075 DE** (EE ≈ 0,004),
    lejos de 0,05 y no significativa (p de 0,059 a 0,063; Holm 0,237 en las cuatro; todos los IC 95 % incluyen 0).
    Sensibilidad (c), con toda omisión como faltante: reducción de 0,015 a 0,020 DE, también < 0,05. Se recalificaron
    4.852 omisiones rápidas de 12.490 omisiones (conteos de respuestas, no de estudiantes).
  - **H7 se rechaza** (`salidas/mat_h7_correlaciones.csv` y `mat_h7.csv`). La correlación con la misma competencia de
    la OCDE va de 0,653 (formular) a 0,752 (emplear): ninguna llega a 0,80. Además, en formular y razonar la
    correlación es mayor con el VP de **emplear** de la OCDE (0,717 y 0,740) que con el propio (0,653 y 0,680).
  - *Interpretación de Claude (para discutir en el informe, no cambia la regla):* (i) la columna de la OCDE manda más
    que la fila propia (la de emplear de la OCDE es la más alta en las cuatro filas), coherente con que las competencias
    casi no se distinguen (H8, D-27); (ii) aun si los constructos coincidieran del todo, la correlación entre dos VP
    con errores independientes queda acotada, de forma aproximada, por la raíz del producto de las confiabilidades;
    con 0,76–0,82 en los propios (D-39), el umbral de 0,80 era difícil de alcanzar. La confiabilidad de los VP de proceso
    de la OCDE para Colombia **no está en el vault / no la he verificado**. D-22 fijó la correlación sin corregir por
    atenuación; cualquier versión corregida sería **exploratoria y posterior a los resultados**.
  - **P3** (`salidas/mat_p3_enlace.csv`), con el método fijado: correlación de las dificultades de 0,909 (formular) y
    0,918 (interpretar), pero de 0,296 (emplear) y −0,003 (razonar), con pendientes del enlace de 0,011 a 0,503.
  - ⚠️ **Error de diseño de Claude en el punto 5:** el enlace media–sigma con b = −d/a no anticipó ítems con
    discriminación casi nula en Colombia (25 dicotómicos con a ≤ 0,3; el mínimo es 0,002 en CMA131Q02S, con b = 460).
    Esos ítems dominan las DE y la correlación de Pearson. Diagnóstico (script en el scratchpad de Claude, no en el
    repositorio): la correlación de Spearman es 0,703 (razonar), 0,877 (formular), 0,932 (interpretar) y 0,932
    (emplear), y la de Pearson sin los ítems con a ≤ 0,3 es de 0,776 a 0,976. **El resultado de P3 tal como se fijó no
    sirve para concluir que las dificultades no concuerdan**; un enlace robusto queda como propuesta (D-43).

### D-42 · 2026-11-08 · Cómo se estima la F6 (O4, H5 y H6)
- **Problema:** con D-32 (VP de la OCDE como principal) y D-34 (BRR), un SEM completo con WLSMV costaría 10 VP × 81 pesos
  = 810 ajustes por modelo (más de 13 h cada uno en este equipo). Hay que fijar el enfoque, las covariables y cómo se
  prueban H5 y H6 **antes de programar la F6**.
- **Decisión (Vanessa, 2026-11-08):**
  1. **Enfoque en dos pasos (plan 6.2) como análisis principal.** Para cada competencia y cada VP de la OCDE
     (`PV1–10 MPEM`, `MPFS`, `MPIN`, `MPRE`), regresión lineal ponderada sobre las EAP del NSE de la G2 (`eap_AFE_ECO` y
     `eap_AFE_CUL`, D-24) y las covariables. Errores con las 80 réplicas BRR (Fay 0,5) y Rubin (D-34). Muestra: los
     6.886 de la muestra analítica (D-14).
     - *Límite que hay que declarar (interpretación):* usar la EAP del NSE como predictor es una calibración de
       regresión. Con confiabilidad de ~0,90 (`salidas/nse_confiabilidad_tri.csv`), la atenuación esperada es pequeña,
       pero la EAP no se calculó condicionando en las demás covariables. Por eso va la robustez del punto 4.
  2. **Covariables (plan 6.1):** sexo y **grado categórico** (5 niveles, el modal de referencia), como en D-39.
  3. **Pruebas:**
     - *Igualdad de efectos entre competencias (6.4):* prueba de Wald conjunta de que el coeficiente del NSE económico es
       igual en las 4 competencias (3 gl).
     - *H5 (exploratoria, D-32):* diferencia entre los coeficientes del NSE económico en interpretar y en emplear, con su
       error BRR + Rubin. Se reporta con la regla preregistrada (positiva y significativa, α = 0,05, bilateral) en la
       muestra completa y en la mitad de confirmación.
     - *H6 (6.5):* el multigrupo se reemplaza por interacciones en la regresión, que es equivalente para las pendientes
       (interpretación). Modelo con zona, sector, NSE económico × zona y NSE económico × sector, sin los estudiantes sin
       dato de zona (212) o de sector (90). **Una prueba de Wald conjunta por variable** en las 4 competencias (zona 8 gl,
       sector 4 gl), con la covarianza BRR + Rubin; **Holm sobre las 2**. H6 se acepta si al menos una es significativa.
       La prueba χ² con la covarianza de Rubin es una aproximación, y así se declara.
  4. **Robustez del punto 1 (no decide hipótesis):** SEM con el NSE latente (estructura del AFE, D-24; WLSMV con los 29
     indicadores ordinales) que predice las 4 competencias con las mismas covariables, solo con el peso final, una vez
     por cada VP. Se promedian los coeficientes y se comparan con los del punto 1. Sin errores BRR (costo).
  5. **Unidades:** coeficientes en puntos de PISA por unidad de la EAP y por desviación estándar ponderada de la EAP.
- **Salidas previstas:** `scripts/06_sem_competencias.R` → `salidas/sem_coeficientes.csv`, `sem_igualdad.csv`,
  `sem_h5.csv`, `sem_h6.csv` y `sem_robustez_latente.csv`.
- **Estado:** ✅ aceptada por Vanessa (2026-11-08): dos pasos con SEM de robustez, Wald conjunto por variable con Holm y
  grado categórico. Mateo y Brayan la revisan en el PR. Revisada por Mateo (2026-11-10): de acuerdo.
- **Resultado del análisis principal** (`scripts/06_sem_competencias.R` → `salidas/sem_coeficientes.csv`, `sem_igualdad.csv`,
  `sem_h5.csv`, `sem_h6.csv` y `sem_h6_interacciones.csv`; 2026-11-08; 10 VP de la OCDE × 81 pesos; 6.886 estudiantes):

  | Competencia | NSE económico: puntos por unidad de EAP (EE BRR) | Libros (EE) | R² medio |
  |---|---|---|---|
  | Emplear | 25,5 (1,9) | 7,3 (1,9) | 0,298 |
  | Formular | 26,2 (3,1) | 12,8 (2,5) | 0,244 |
  | Interpretar | 31,0 (2,3) | 8,5 (1,8) | 0,310 |
  | Razonar | 25,6 (2,8) | 9,9 (2,1) | 0,238 |

  - **Igualdad entre competencias (6.4):** se rechaza; Wald χ² = 11,32 con 3 gl, p = 0,010.
  - **H5 (exploratoria, D-32):** interpretar − emplear = 5,57 puntos (EE 1,70; IC 95 % 2,24 a 8,89) en la muestra completa
    y 6,33 (EE 1,78) en la mitad de confirmación (3.441). Cumple la regla en las dos, pero se presenta como exploratoria.
  - **H6 se acepta**, por sector: Wald χ² = 15,58 con 4 gl, p = 0,0036 (Holm 0,0073). Por zona no: χ² = 13,99 con 8 gl,
    p = 0,082 (Holm 0,082). La pendiente del NSE es entre 12,3 y 20,3 puntos mayor en los colegios privados, según la
    competencia (6.674 estudiantes con zona y sector).
  - *Interpretación (Claude, por discutir):* el NSE se asocia más con interpretar que con emplear, y su asociación es
    más fuerte dentro del sector privado. No son efectos causales (diseño transversal) y descansan en el límite de
    invarianza de D-35.
- **Resultado de la robustez (punto 4)** (`salidas/sem_robustez_latente.csv`; 2026-11-09; los 10 SEM convergieron):

  | Competencia | NSE económico: latente / dos pasos (puntos por DE) | Libros: latente / dos pasos |
  |---|---|---|
  | Emplear | 23,20 / 24,15 | 7,82 / 6,96 |
  | Formular | 23,59 / 24,84 | 13,79 / 12,10 |
  | Interpretar | 28,69 / 29,43 | 8,68 / 8,06 |
  | Razonar | 23,12 / 24,27 | 10,89 / 9,38 |

  - **Lectura (dato):** en el NSE económico los dos enfoques casi coinciden (el de dos pasos queda entre 2,6 % y 5,3 %
    por encima), así que la calibración de regresión no atenúa el coeficiente principal, y el orden de las competencias
    (interpretar la más alta) se mantiene. En libros, el de dos pasos queda entre 7 % y 14 % por debajo del latente.
  - *Aviso de `lavaan` en los 10 ajustes:* la correlación entre `ST254Q03JA` (portátiles) y `ST250Q02JA` (computador
    para tareas) es casi 1 en el modelo con covariables. Es el par más alto de la policórica del 3.2 (0,836).
  - *Matiz:* las unidades no son idénticas (DE de la EAP frente a DE del factor latente); la comparación es aproximada.

### D-43 · 2026-11-09 · Enlace robusto para P3 (corrige el punto 5 de D-41)
- **Problema:** el enlace media–sigma de D-41 punto 5 queda dominado por los ítems dicotómicos con discriminación casi
  nula en Colombia (b = −d/a se dispara). Ver el resultado de D-41. Es un error de diseño de Claude, detectado después
  de correr; el resultado de D-41 se conserva y se reporta tal como se fijó.
- **Propuesta de Claude (no programada):**
  1. Reportar como análisis principal de P3 la correlación de **Spearman** de las dificultades por competencia (no
     depende de la escala y no la dominan los valores extremos).
  2. Repetir el enlace media–sigma **solo con los ítems con a ≥ 0,3** en el modelo propio, y reportar cuántos quedan
     por competencia y cuáles se excluyen.
  3. Reportar aparte, como hallazgo de calidad de los ítems, los dicotómicos con a < 0,3 en Colombia y compararlos con
     su `a_int`.
  - Alternativa: enlace de Stocking-Lord con las curvas características, que pondera los ítems por su información. Es
    más estándar, pero más largo de programar y de explicar.
  - Todo esto es **posterior a ver los resultados** y debe declararse así en el informe. P3 no tiene regla de decisión
    preregistrada; es un análisis descriptivo del paso 5.5.
- **Salidas previstas:** `scripts/05_p3_robusto.R` → `salidas/mat_p3_robusto.csv` (por competencia) y
  `mat_p3_baja_discriminacion.csv` (ítems con a < 0,3; parámetros de ítems, sin datos de estudiantes).
- **Estado:** ✅ aceptada por Vanessa (2026-11-09): Spearman como principal, media–sigma con a ≥ 0,3 y la lista de
  ítems de baja discriminación. Mateo y Brayan la revisan en el PR. Revisada por Mateo (2026-11-10): de acuerdo.
- **Resultado (2026-11-09, `05_p3_robusto.R`):**

  | Competencia | Spearman (todos) | Ítems con a ≥ 0,3 / excluidos | Pearson (a ≥ 0,3) | Pendiente A | Intercepto B | RMSD |
  |---|---|---|---|---|---|---|
  | Emplear | 0,932 | 52 / 10 | 0,888 | 0,440 | −0,934 | 0,269 |
  | Formular | 0,877 | 27 / 8 | 0,794 | 0,548 | −0,978 | 0,373 |
  | Interpretar | 0,932 | 36 / 2 | 0,976 | 0,565 | −0,922 | 0,211 |
  | Razonar | 0,703 | 30 / 5 | 0,776 | 0,416 | −0,682 | 0,543 |

  - **Dato:** el orden de dificultad de los ítems en Colombia concuerda con el internacional (Spearman de 0,70 a
    0,93), y las discriminaciones también (Spearman de a propio con `a_int` = 0,812). Razonar es la que menos
    concuerda. 25 dicotómicos tienen a < 0,3 en Colombia (`salidas/mat_p3_baja_discriminacion.csv`); en todos, la
    `a_int` es mayor.
  - *Interpretación de Claude (no verificada contra la métrica del anexo A):* si el b propio está en DE de Colombia, A
    y B estiman, de forma aproximada, la DE y la media de Colombia en la métrica internacional (A ≈ 0,4–0,6 y
    B ≈ −0,7 a −1,0), lo que sería coherente con un desempeño por debajo y menos disperso que el internacional. No he
    verificado en qué métrica están `a_int` y `b_int` en el anexo A, así que esta lectura queda por confirmar.

### D-44 · 2026-11-09 · Robustez de la F6 con los puntajes propios, ajuste y diagrama (cierra el 6.3 y la F6)
- **Problema:** D-32 deja los puntajes propios como robustez de O4 si el 5.4 se valida, y se validó (D-39). D-42 no fija
  cómo se hace. El «Listo cuando» de la F6 pide además el ajuste con los dos tipos de puntaje y un diagrama del modelo.
- **Propuesta de Claude, aplicada por encargo de Vanessa («cierra la F6», 2026-11-09); falta que ella la confirme:**
  1. **Mismo análisis, otra variable de respuesta.** Se repiten los puntos 1 a 3 de D-42 (coeficientes, igualdad entre
     competencias, H5 en la muestra completa y en la mitad de confirmación, H6 con Wald por variable y Holm) cambiando
     los 10 VP de la OCDE por los 10 VP propios de cada competencia (`datos/COL_puntajes_competencia.rds`, D-39). Mismas
     covariables, misma muestra (6.886), los 81 pesos y Rubin.
     - *Límites que hay que declarar (interpretación):* (i) los VP propios se generaron con la regresión latente de la
       muestra completa, no re-estimada en cada réplica, así que el error BRR puede quedar algo corto (la OCDE hace lo
       mismo con sus VP); (ii) el modelo de condicionamiento incluye todas las variables de la F6, con NSE × zona y NSE ×
       sector (D-37), así que los coeficientes no quedan atenuados por omitirlas.
  2. **Unidades y comparación.** Los VP propios están en DE latentes de Colombia; los de la OCDE, en puntos PISA. Para
     comparar se agrega el **coeficiente estandarizado** del NSE: coeficiente × DE ponderada de la EAP del NSE / DE
     ponderada de la competencia (promedio de los 10 VP), en las dos fuentes. Es una estimación puntual, sin EE.
  3. **Criterio de concordancia (fijado antes de correr):** la conclusión es robusta si coinciden el signo y la decisión
     (p < 0,05 o no) en la igualdad entre competencias, en H5 (las dos muestras) y en H6 (cada variable, después de
     Holm). La robustez **no cambia** la decisión de ninguna hipótesis (D-32).
  4. **Ajuste.** De la regresión en dos pasos: R² medio con las dos fuentes. Del SEM latente de D-42 punto 4: CFI, TLI y
     RMSEA (*scaled* y *robust*, donde se puedan calcular) y SRMR, **solo con el VP1 de la OCDE** y el peso final
     (costo: un ajuste con estadístico de prueba). Es descriptivo y no decide nada.
  5. **Diagrama** del modelo en `salidas/sem_diagrama.png`, dibujado con R base (sin paquetes nuevos).
- **Salidas previstas:** `scripts/06_sem_competencias.R` → `salidas/sem_propios_coeficientes.csv`,
  `sem_propios_igualdad.csv`, `sem_propios_h5.csv`, `sem_propios_h6.csv`, `sem_propios_h6_interacciones.csv`
  (agregada al programar), `sem_comparacion_fuentes.csv`,
  `sem_ajuste_latente.csv` y `sem_diagrama.png`. Las salidas del análisis principal no deben cambiar (se comprueba con
  `git diff`).
- **Estado:** ⏳ aplicada por encargo de Vanessa («cierra la F6»); falta que confirme los puntos 1 a 5. Mateo y Brayan la
  revisan en el PR. Revisada por Mateo (2026-11-10): de acuerdo.
- **Resultado de los puntos 1 a 3 (2026-11-09, `06_sem_competencias.R` → `salidas/sem_comparacion_fuentes.csv` y
  `sem_propios_*.csv`):** las salidas del análisis principal no cambiaron (`git status` sin cambios en ellas).

  | Prueba | VP de la OCDE | VP propios | ¿Coincide? |
  |---|---|---|---|
  | NSE económico, coeficiente estandarizado (emplear / formular / interpretar / razonar) | 0,327 / 0,280 / 0,350 / 0,283 | 0,335 / 0,322 / 0,367 / 0,315 | sí (todos p < 10⁻¹⁶) |
  | R² medio (mismo orden) | 0,298 / 0,244 / 0,310 / 0,238 | 0,364 / 0,338 / 0,350 / 0,337 | — |
  | Igualdad entre competencias (6.4) | χ² = 11,32; p = 0,010 | χ² = 38,08; p = 2,7 · 10⁻⁸ | sí: se rechaza |
  | H5, muestra completa | 5,57 puntos; p = 0,001 | 0,035 DE latentes; p = 8,5 · 10⁻⁶ | sí |
  | H5, mitad de confirmación | 6,33 puntos; p = 0,0004 | 0,039 DE latentes; p = 0,0007 | sí |
  | H6, sector (Holm) | p = 0,0073 | p = 4,6 · 10⁻¹⁴ | sí: se acepta |
  | H6, zona (Holm) | p = 0,082 | p = 1,9 · 10⁻¹⁴ | **no** |

  - **Lectura (dato):** con los puntajes propios se repiten el orden de las competencias (interpretar la más alta),
    el rechazo de la igualdad, H5 y H6 por sector. La única discrepancia es la interacción NSE × zona, que con los
    propios es muy significativa y con los de la OCDE no.
  - *Interpretación de Claude (por discutir; no cambia ninguna decisión, D-32):* hay dos sesgos posibles, en sentidos
    opuestos. (i) Los VP propios se condicionaron con NSE × zona (D-37) y con Γ fija en todas las réplicas, así que su
    error BRR no recoge la incertidumbre de Γ y con ~5 a 9 ítems por competencia la previa pesa mucho: su valor p
    queda **demasiado pequeño** (límite (i) del punto 1). (ii) Si el modelo de condicionamiento de la OCDE no incluye
    esa interacción, sus VP la **atenúan** hacia 0; **no he verificado** en el Technical Report qué variables usa la
    OCDE para condicionar. Con esto, H6 por zona queda **sin resolver** entre fuentes y así se reporta; H6 se sigue
    aceptando por sector, que coincide en las dos.
  - Los R² con los propios son más altos en parte por el mismo condicionamiento (interpretación).
- **Resultado de los puntos 4 y 5 (2026-11-09, `salidas/sem_ajuste_latente.csv` y `sem_diagrama.png`):** el SEM latente
  con el VP1 convergió (n = 6.886; 5 min). χ² *scaled* = 11.352,1 con 629 gl (p < 0,001); CFI *scaled* 0,927; TLI
  *scaled* 0,939; RMSEA *scaled* 0,050; SRMR 0,070. `lavaan` **no pudo calcular** los índices *robust* (salen vacíos),
  como ya pasó en partes de la F3–F4.
  - *Interpretación de Claude:* los índices *scaled* con WLSMV tienden a ser optimistas, y el AFC del NSE tuvo CFI
    *robust* de 0,753 (D-24); el ajuste de este SEM no se puede leer como bueno sin los *robust*. Se reporta como
    descriptivo, con esa salvedad. Se repite el aviso de `lavaan` de correlación casi 1 entre `ST254Q03JA` y
    `ST250Q02JA` (D-42).

### D-45 · 2026-11-09 · Diseño de la F7: candidatos, sensibilidades, regla de robustez, búsqueda de novedad y G4
- **Problema:** el paso 7.1 lista cinco sensibilidades y la rúbrica (criterio 3) pide que un hallazgo se mantenga «en al
  menos 3 de los 4 análisis de sensibilidad». No está fijado qué resultados son candidatos, qué sensibilidad aplica a
  cada uno ni cómo se cuenta cuando aplican menos de 4. Se fija **antes de correr**, el 2026-11-09.
- **Decisión (Vanessa, 2026-11-09):**
  1. **Candidatos** (cada uno con la conclusión que se pone a prueba):
     - **K1 (O4, H5 exploratoria):** la igualdad del NSE económico entre competencias se rechaza **y** H5 cumple su regla
       (interpretar − emplear > 0 con p < 0,05) en la muestra completa y en la mitad de confirmación.
     - **K2 (O4, H6):** la interacción NSE × sector es significativa (Wald, 4 gl; Holm sobre zona y sector).
     - **K3 (O4):** el coeficiente del NSE es positivo y significativo (p < 0,05) en las 4 competencias.
     - **K4 (O3, H4):** H4 se rechaza: ninguna competencia tiene reducción ≥ 0,05 DE y significativa (Holm).
     - **K5 (O3, H3):** misma decisión de H3: primera parte aceptada y segunda rechazada.
  2. **Sensibilidades** (plan 7.1) y a qué candidato aplican:

     | Sensibilidad | Qué cambia | K1 | K2 | K3 | K4 | K5 |
     |---|---|---|---|---|---|---|
     | S-A ESCS | ESCS oficial en lugar de las EAP del NSE de la G2 (como predictor en la F6; para formar los cuartiles en H3 y H4) | ✓ | ✓ | ✓ | ✓ | ✓ (TRI completo) |
     | S-B Sin ruta lineal | Se excluyen los 1.699 estudiantes con `MPATH` = *Linear*; los cuartiles de H3 y H4 se mantienen fijos (los de la muestra completa) | ✓ | ✓ | ✓ | ✓ | ✓ (TRI completo) |
     | S-C Umbral de omisión | Omisión rápida con NT15 y con 5 s fijos; vale si se mantiene con **los dos** | — | — | — | ✓ | — |
     | S-D Sin corrección múltiple | Valores p sin Holm (H4, H6) ni BH (H3) | — | ✓ | — | ✓ | ✓ |
     | S-E Reponderación (D-38) | Pesos y réplicas ajustados por no respuesta dentro del colegio | ✓ | ✓ | ✓ | ✓ | ✓ (solo la magnitud: la prueba TRI va sin pesos, D-26) |

     - En S-A, la F6 usa ESCS en lugar de las dos EAP (ESCS es de 1 dimensión, así que no hay coeficiente de libros), y en
       H6 las interacciones son ESCS × zona y ESCS × sector.
     - En H3 (S-A y S-B) se prueban los mismos 165 elegibles, salvo los que pierdan alguna categoría en un grupo, que se
       listan. El DIF se re-estima con el método de D-40 completo, en segundo plano (~5 h por corrida).
     - En H4 se usan los mismos ítems, la misma regresión latente y los mismos números aleatorios de D-41; los VP de las
       versiones NT15 y 5 s se calculan con E1.
  3. **Regla de robustez (criterio 3 de la rúbrica, definición operativa):** un candidato es robusto si su conclusión se
     mantiene en al menos el **75 % de las sensibilidades que le aplican, con un mínimo de 3**: K1 y K3, 3 de 3; K2 y K5,
     3 de 4; K4, 4 de 5.
  4. **Paso 7.2:** Claude hace una búsqueda web documentada (Google Scholar, SciELO, Redalyc y buscador general; fecha y
     cadenas por candidato). Scopus no está disponible desde la herramienta: lo completa el equipo. Los antecedentes nuevos
     entran a la matriz como † y `por_verificar`, solo con lo que muestre la búsqueda.
  5. **Paso 7.3:** cada candidato se clasifica con los 5 criterios de la rúbrica como hallazgo, réplica o resultado nulo
     o frágil; la frase para el Ministerio queda como borrador de Claude para que el equipo la apruebe.
  6. **Puerta G4:** el acta se deja lista; la etiqueta `resultados-v1` se crea **sobre `main` cuando Mateo o Brayan aprueben
     y fusionen el PR**, no antes.
- **Salidas previstas:** `scripts/07_sensibilidad.R` → `salidas/f7_sensibilidad_detalle.csv` y `f7_robustez.csv`;
  `scripts/05_dif_matematicas.R` con la variable de entorno `F7_VARIANTE` (`escs`, `sin_lineal`, `d38`) →
  `salidas/f7_dif_<variante>.csv` y `f7_h3_<variante>.csv`; nota `Vault_PISA2022/Hallazgos.md`; acta de la G4.
- **Estado:** ✅ aceptada por Vanessa (2026-11-09): 5 candidatos con regla del 75 %, DIF con TRI completo, búsqueda
  documentada por Claude y etiqueta después del PR. Mateo y Brayan la revisan en el PR. Revisada por Mateo (2026-11-10): de acuerdo.
- *Al programar (2026-11-09, antes de ver resultados):* en S-E, los cuartiles de H4 se recalculan con el peso final
  ajustado. `wls81()`, `rubin_vec()` y `wald()` pasan de `06_sem_competencias.R` a `utilidades_pisa.R` (las salidas de la
  F6 no cambian). Variantes del DIF también en `f7_dif_resumen_<variante>.csv`.
- **Resultado de K1 a K4 (2026-11-09, `07_sensibilidad.R` → `salidas/f7_sensibilidad_detalle.csv` y
  `f7_robustez.csv`):** la versión base reproduce `sem_h5.csv`, `sem_h6.csv` y `mat_h4_brechas.csv` (comprobado en el
  script). Ruta lineal: 1.699 estudiantes de la muestra analítica. Factor de D-38 sobre el peso final: de 1 a 11,7.
  Omisiones rápidas: 4.852 con NT10, 5.677 con NT15 y 3.083 con 5 s.

  | Candidato | Base | S-A ESCS | S-B sin ruta lineal | S-C NT15 / 5 s | S-D sin corrección | S-E D-38 | Robusto |
  |---|---|---|---|---|---|---|---|
  | K1 igualdad + H5 | igualdad p = 0,010; H5 5,57 (p = 0,001) y 6,33 (p < 0,001) | p = 0,042; 3,72 (p = 0,016) y 3,79 (p = 0,021) | p = 0,049; 5,19 (p = 0,005) y 5,60 (p = 0,008) | — | — | p = 0,010; 5,48 y 6,09 (p = 0,001) | **sí, 3 de 3** |
  | K2 NSE × sector | Holm p = 0,0073 | 0,0007 | 0,0041 | — | sin Holm 0,0036 | 0,0097 | **sí, 4 de 4** |
  | K3 NSE > 0 en las 4 | 25,5 a 31,0 puntos por unidad de EAP | 19,1 a 22,8 por unidad de ESCS | 25,1 a 30,3 | — | — | 25,6 a 31,1 | **sí, 3 de 3** |
  | K4 H4 nulo | reducción 0,007 DE; Holm p = 0,24 | 0,003–0,004; p = 1 | 0,007; p = 0,35 | NT15 0,008 (p = 0,18); 5 s 0,004 (p = 0,47) | 0,007; p 0,059–0,063 | 0,006; p = 0,52 | **sí, 5 de 5** |
  | K5 H3 (parte 1 sí, 2 no) | 3 de 154 con DIF | 6 de 155 (4 emplear, 1 formular, 1 interpretar); Fisher p = 0,929; se mantiene | 2 de 152 (los 2 en emplear); p = 1; se mantiene | — | sin BH: 8 de 154 (6 emplear, 1 formular, 1 interpretar); se mantiene | 3 de 154; se mantiene | **sí, 4 de 4** (2026-11-10) |

  - *Lectura (dato):* K1 queda cerca del límite en dos sensibilidades: con ESCS la diferencia H5 baja a ~3,7 puntos, y
    sin la ruta lineal la igualdad sale con p = 0,049. Con ESCS, la interacción NSE × zona también sale significativa
    (p = 0,0045), a diferencia de la base (0,082).
  - *Interpretación de Claude:* el factor máximo de 11,7 en D-38 viene de colegios con pocos incluidos; S-E da casi los
    mismos resultados, así que esos pesos grandes no mueven las conclusiones.
- **Resultado de K5 (2026-11-10, DIF con TRI completo, `05_dif_matematicas.R` con `F7_VARIANTE` →
  `salidas/f7_dif_*.csv` y `f7_h3_*.csv`; `07_sensibilidad.R` repetido → `f7_robustez.csv`):** las dos corridas largas se
  cortaron una vez por un apagado del equipo (2026-11-09) y se relanzaron desde cero (229 y 243 min). **Los cinco
  candidatos son robustos.**
  - Con cuartiles de ESCS: 6 de 155 ítems con DIF; de los 5 dicotómicos, los 5 favorecen al cuartil bajo
    (`CMA117Q03S`, de crédito parcial, se lee en sus curvas). Media latente de Q1 frente a Q4: −1,024.
  - Sin la ruta lineal: 2 de 152 ítems con DIF (`CMA131Q02S` favorece al cuartil alto y `CMA135Q04S` al bajo).
    Elegibles sin todas sus categorías en los dos grupos: 10 con ESCS y 13 sin la ruta lineal (listados en el log; no
    se prueban, D-45 punto 2).
  - *Lectura (dato):* con ESCS el número de ítems con DIF se duplica (6) y aparece uno de formular y otro de
    interpretar; aun así, la proporción en interpretar + formular (2 de 67) es menor que en emplear (4 de 57).
  - *Interpretación de Claude:* `CMA135Q04S` tiene DIF en todas las variantes y siempre favorece al cuartil bajo; es el
    candidato más claro para la revisión de contenido de P4 que sigue pendiente.
- **Reproducción independiente (2026-11-10, equipo de Mateo):** las dos variantes se corrieron otra vez desde cero, en
  otro equipo y sin sus cachés (84 a 94 min cada una, las dos a la vez; cuartiles Q1 1.502 y Q4 1.896 con ESCS, Q1 1.118
  y Q4 1.505 sin la ruta lineal). Marcan los **mismos ítems con DIF** (6 y 2) y ninguna columna de decisión
  (`DIF`, `TRI_significativo`, `no_despreciable`, `categoria_ETS`, `favorece`) difiere en los 155 y 152 ítems; `f7_dif_d38.csv`
  tampoco. Solo cambian decimales (p. ej., X² 1,6 frente a 1,61).
- **Reproducción completa (2026-11-10):** `00_correr_todo.R` corrió los 29 scripts en el equipo de Mateo (02:17 a
  06:47, código 0). Reestimó sin caché las medias con BRR de la F4, E1, la regresión latente, el DIF y el SEM de la F6.
  Los modelos TRI de la F3 y del 5.3 y las variantes del DIF de esa noche se leyeron del caché. Frente a las salidas
  del repositorio (las de la rama `Vanessa`, hoy en `main`), 23 salidas cambiaron solo en decimales o en columnas de
  minutos, y **ninguna conclusión cambió** (ninguna columna lógica de decisión cambió).
  - Las diferencias mayores están en los puntajes propios: χ² de H6 83,58 → 84,99 (zona) y 68,54 → 69,39 (sector), e
    igualdad entre competencias 38,08 → 38,47.
  - La regresión latente convergió en 39 iteraciones de EM, frente a 45 en la primera corrida. Sus correlaciones
    residuales cambian como máximo 0,002 y sus coeficientes 0,0035. En las demás salidas, las estimaciones cambian como
    máximo 0,0011 y los valores p 0,003.
  - *Qué se congela (propuesta de Claude, 2026-11-10; el equipo la confirma en el PR):* `salidas/` conserva los archivos
    de la primera corrida (los de `main`), porque son los que citan D-39, D-42, D-44 y el informe. La reproducción
    queda como evidencia de que la cadena es reproducible; sus archivos no se suben.
- **Puerta G4 (punto 6), 2026-11-10:** el PR #14 (rama `Vanessa`) lo fusionó Mateo y el PR #15 (rama `Mateo`) lo
  fusionó Vanessa, con la integración continua en verde; ninguno registra una revisión aprobada en GitHub. Mateo pidió
  crear la etiqueta, y Claude creó y subió `resultados-v1` sobre `main` (commit `e176fb5`). Desde aquí `salidas/` solo
  cambia si se corrige un error.
- **Punto 4 en Scopus (2026-11-10):** con el acceso del CRAI USTA de Mateo, Claude corrió las 10 cadenas en Scopus a su
  pedido: 7 dieron 0 resultados y 3 dieron 1 documento cada una, ninguno sobre Colombia ni antecedente de K1, K2, K4 o K5
  ([[Literatura/Búsqueda de novedad F7]]). La búsqueda no cambia ningún resultado congelado.
  - *Google Académico (2026-11-10):* Mateo corrió las 10 cadenas desde otro computador (en el suyo Google bloqueó las
    consultas) y Claude revisó la página 1 de cada una: ningún antecedente para Colombia. Hay análisis parecidos en otros
    países o poblaciones; el más cercano a K2, según su resumen, es Duarte, Bos y Moreno (2010, BID), con el SERCE en
    primaria y el resultado contrario (por verificar). El criterio 4 sigue provisional hasta leer esos antecedentes.

### D-46 · 2026-11-09 · Diseño de la API (F8, paso 8.2): stack, persistencia y endpoint de predicción
- **Problema:** la F8 debe cumplir las buenas prácticas del curso de Python (documento del curso que Vanessa dio a
  Claude, que **no** se sube al repositorio): Python 3.11.9, FastAPI, Pydantic v2, SQLAlchemy con SQLite, pytest con
  TestClient, Docker, integración continua y un endpoint de predicción con Singleton. La API del plan 8.2 solo lee
  resultados y nunca estima.
- **Decisión (Vanessa, 2026-11-09):**
  1. **Python 3.11.9** en un `.venv` propio de `Proyecto_PISA/api/` (instalado junto a 3.13); dependencias fijadas en
     `requirements.txt`.
  2. **Persistencia:** un script de carga lee los CSV **agregados** de `salidas/`, valida cada fila con Pydantic y la
     guarda en SQLite con SQLAlchemy 2.0; la API consulta esa base. Nunca datos por estudiante (Ley 1581 de 2012).
  3. **Predicción:** `POST /v1/modelo/prediccion` devuelve el **puntaje esperado** de las 4 competencias para un perfil
     (EAP del NSE económico y de libros, sexo y grado) con los coeficientes del modelo principal de la F6
     (`salidas/sem_coeficientes.csv`, D-42). El modelo se carga una vez al iniciar (Singleton).
     - *Lo que es y lo que no es (interpretación):* es una media condicional estimada, no el puntaje de una persona ni un
       efecto causal; no lleva intervalo porque la covarianza de los coeficientes no se exporta. Así se dice en la
       respuesta.
     - *Validación de la entrada:* NSE entre −4 y 4 (métrica de la EAP, media 0 y DE ≈ 0,95, D-42), sexo `Mujer` u
       `Hombre`, grado relativo al modal (−3, −2, −1, 0 o 1). Fuera de eso: error 422.
  4. **Rama:** `Vanessa`, en el mismo PR; Brayan la revisa y la continúa (la API y el tablero son su área según el reparto
     de [[17 Plan de trabajo Brayan]], línea 18).
- **Estado:** ✅ aceptada por Vanessa (2026-11-09): 3.11.9, SQLite desde `salidas/`, endpoint de predicción y rama
  `Vanessa`. Brayan la revisa en el PR. Revisada por Mateo (2026-11-10): de acuerdo.
- **Resultado (2026-11-09):** `Proyecto_PISA/api/` con 11 endpoints, carga validada de 8 archivos de `salidas/` a SQLite
  (29 + 234 + 16 + 10 + 154 + 32 + 12 + 5 filas y las 8 hipótesis) y 33 pruebas con pytest que pasan en Python 3.11.9.
  El servidor real (uvicorn) responde: con NSE económico 1 y lo demás en la referencia, emplear da 410,1 = 384,62 +
  25,47 (`sem_coeficientes.csv`). La validación encontró dos cosas: los ΔMH infinitos de D-40 y que un `NaN` en la
  entrada producía un error 500 en lugar de 422 (corregido con un manejador propio). Docker no está instalado en este
  equipo: la imagen se prueba en la integración continua (`.github/workflows/api.yml`). El primer run falló porque
  `ubuntu-latest` (Ubuntu 26.04) no trae Python 3.11.9; con las pruebas dentro de `python:3.11.9-slim`, el run
  42743515918 pasó completo: 33 pruebas y construcción de la imagen.
- **Tablero (paso 8.4, 2026-11-09):** `Proyecto_PISA/tablero/` en Streamlit 1.40.2 sobre la API, con Python 3.11.9 y su
  propio `.venv`: 5 páginas (resumen de H1-H8 y robustez, NSE e invarianza, DIF, modelo estructural y puntaje
  esperado). No lee archivos: todo por HTTP, con contrato Pydantic, reintentos y caché de 5 min. Gráficos con la paleta
  de referencia de la guía de visualización de Claude (azul = NSE económico, naranja = libros) y tabla al lado de cada
  gráfico; el validador de paleta no se pudo correr (no hay Node.js en el equipo), así que la validación es la que
  documenta la paleta. 16 pruebas pasan contra la API real; los gráficos se revisaron a ojo exportados a PNG (se
  corrigió el del DIF: rótulos encimados y cortes del ETS confundidos con la cuadrícula).

### D-47 · 2026-11-09 · Tablero explicativo de todo el proyecto y catálogo de resultados en la API (F8)
- **Problema:** Vanessa pidió (2026-11-09) que el tablero explique lo que muestra, que incluya los modelos estructurales
  con sus cargas y que recorra **todo** lo avanzado del proyecto para explicarlo de forma fácil e interactiva. La API
  de D-46 solo sirve 8 archivos de `salidas/`, y el tablero no puede leer archivos (D-46).
- **Decisión (Vanessa, 2026-11-09, al pedirlo; los detalles técnicos los propone Claude):**
  1. **Catálogo de resultados en la API:** cada archivo agregado de `salidas/` que el tablero necesita se declara una
     vez (ruta, archivo, esquema Pydantic de sus filas, título, decisión del registro) y una sola función crea su
     endpoint `GET /v1/...` con su contrato en `/docs`. Las filas se validan al cargar, como en D-46, y se guardan en una
     tabla genérica de SQLite. `GET /v1/catalogo` lista qué hay y de dónde sale.
  2. **Tablero como recorrido por fases** (F1-F2 datos y diseño, F3 NSE, F4 invarianza, F5 competencias, F6 modelo
     estructural, F7 robustez y hallazgos, más el puntaje esperado). Cada sección tiene tres textos: qué se hizo, cómo
     se lee y qué significa, con la decisión del registro que lo sostiene.
  3. **Diagrama del modelo estructural interactivo:** el NSE de 2 dimensiones del AFE (D-24) con las cargas
     estandarizadas de sus 29 indicadores, la correlación entre factores y las rutas hacia las 4 competencias con los
     coeficientes de la F6 (D-42); al pasar el cursor se ve el valor y la etiqueta oficial de cada indicador.
  - *Regla de los textos:* las cifras que aparecen en los textos se leen de la API, no se escriben a mano; las
    interpretaciones repiten las del registro (D-xx) y se marcan como tales.
- **Estado:** ✅ pedido por Vanessa (2026-11-09). Brayan lo revisa en el PR. Revisada por Mateo (2026-11-10): de acuerdo.

### D-48 · 2026-11-10 · Análisis confirmatorio de los ítems por competencia (exploratorio; sugerencia del profesor de SEM)
- **Contexto:** en la clase de Modelación de Ecuaciones Estructurales, el profesor sugirió un análisis factorial
  confirmatorio de los ítems de cada competencia, para ver si cada ítem representa su competencia y no otra. Se decide
  **después** de conocer H8 (D-27) y el resto de la F5, y así se declara: es **exploratorio** y no cambia ninguna
  hipótesis.
- **Lo que muestran los datos** (`scripts/05_afc_competencias.R` → `salidas/mat_pares_cobertura.csv`; versión (a) de la
  matriz, 6.886 estudiantes × 232 ítems): de 26.796 pares de ítems, **5.719 (21,3 %) nunca los respondió el mismo
  estudiante** y 12.303 (45,9 %) los respondieron juntos menos de 50; mediana de 59 estudiantes por par. Pasa igual
  dentro de una misma competencia (21,5 % y 46,3 %).
- **Alternativas:**
  - (a) AFC con WLSMV en `lavaan` por competencia: parte de las correlaciones policóricas por pares, que no existen para
    el 21 % de los pares y son muy inestables para casi la mitad. **No se puede estimar** con la prueba adaptativa.
  - (b) Usar el modelo de 4 competencias del 5.3, que **ya es un AFC a nivel de ítem con información completa** (cada
    ítem carga solo en su competencia; `mirt`, QMCEM con 1.000 puntos y pesos; D-27), y reportar sus cargas y su matriz
    de correlaciones sin volver a estimar.
  - (c) Además, un modelo exploratorio de 4 factores con rotación hacia la estructura teórica (horas de cálculo, sin
    garantía de convergencia).
  - (d) Probar cada ítem en las otras competencias (unos 700 modelos): no cabe en el calendario.
- **Decisión (Mateo, 2026-11-10): (b).** (c) y (d) quedan como trabajo futuro.
  1. Cargas estandarizadas de cada ítem en su competencia con `cargas_mirt()` (la falla de `summary()` de `mirt`
     1.46.1 con los GPCM, D-19), la matriz completa Φ y la cobertura de pares.
  2. Se marcan los ítems con carga < 0,30, el criterio operativo de D-29 (V3). Solo se reporta: no se excluye ningún
     ítem ni se recalibra.
  3. En el informe se contrasta con el análisis de dimensionalidad de la OCDE (Technical Report, pp. 228–230 impresas:
     modelo de 2 dimensiones con los ítems de tendencia y los nuevos; el AIC prefiere 2 y el BIC 1, el modelo de 1
     dimensión logra el 99,8 % de la mejora y las correlaciones entre los dos conjuntos van de 0,91 a 0,99). Leído por
     Claude en el texto completo el 2026-11-10; **por verificar** por el equipo.
- **Resultado** (`salidas/mat_afc_cargas.csv`, `mat_afc_resumen.csv` y `mat_afc_phi.csv`; 2026-11-10):
  - Cada ítem carga en la competencia que le asigna el anexo A (el script lo comprueba).
  - Mediana de las cargas: 0,48 (emplear), 0,50 (formular), 0,53 (interpretar), 0,63 (razonar); 0,52 en total.
  - **56 de 232 ítems (24,1 %) tienen carga < 0,30**, todos dicotómicos: 22 de emplear, 17 de formular, 6 de interpretar
    y 11 de razonar. **5 tienen carga negativa** (la mínima, −0,21 en emplear).
  - Φ: emplear–formular 0,940, emplear–interpretar 0,951, emplear–razonar 0,976, formular–interpretar 0,897,
    formular–razonar 0,945 e interpretar–razonar 0,906 (las mismas de H8).
  - *Interpretación (Claude, por discutir):* los ítems sí cargan en su competencia, pero las competencias casi no se
    separan (Φ) y una cuarta parte de los ítems discrimina poco en Colombia. Es coherente con D-43, que encontró 25
    ítems dicotómicos con discriminación < 0,3 y dificultades muy altas (`salidas/mat_p3_baja_discriminacion.csv`):
    ítems que casi nadie responde bien en Colombia informan poco (efecto piso).
- **Estado:** ✅ (b) aceptada por Mateo (2026-11-10, en la sesión con Claude). Vanessa y Brayan la revisan en el PR.
