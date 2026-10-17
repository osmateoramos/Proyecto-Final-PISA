---
tipo: guia
estado: por_verificar
lectura: "redactado por Claude; falta revisión del equipo"
pendientes: "Cifras de la puerta G1 (382,7 · 79 · 16 %): confirmar en las fuentes enlazadas; 79 puntos sin origen"
verificado_por:
fecha_verificacion:
---

# Plan de desarrollo — PISA 2022 Colombia

Volver a [[00 Inicio]] · Objetivos en [[06 Objetivos PISA 2022]] · Cómo se evalúa cada paso en [[08 Rúbrica de desarrollo]]
Hipótesis a probar en [[09 Hipótesis preregistradas]] · Herramientas en [[10 Gestión de la información]]

## Cómo usar esta guía

- Cada paso tiene: **Teoría previa** (qué deben haber visto en clase) · **Por qué** (para defenderlo en la
  sustentación) · **Paso a paso** · **Salida** (archivo que lo demuestra) · **Listo cuando** · **Autoevaluación**.
- Un paso no se marca `[x]` sin su salida. Toda cifra nueva se anota con el script que la produce.
- Cada paso tiene un responsable y otro integrante lo revisa (reparto propuesto en [[00 Inicio]]). Toda decisión va
  primero a [[03 Registro de decisiones]].
- Al cerrar cada fase se pasa su **puerta** (ver [[08 Rúbrica de desarrollo]]): si no se cumple, no se avanza.
- Cursos: `[TRI]` · `[SEM]` · `[PY]` Python/APIs · `[CONS]` Consultoría.

## Calendario (8 semanas)

| Semana | Fechas | Fase | Puerta al cerrar |
|---|---|---|---|
| 1 | 5–11 oct | F0 Organización · F1 Datos y ETL | — |
| 2 | 12–18 oct | F2 Validación del diseño · inicio F3 | **G1** |
| 3 | 19–25 oct | F3 O1: medición del NSE | **G2** |
| 4 | 26 oct–1 nov | F4 O2: invarianza | — |
| 5 | 2–8 nov | F5 O3: calificar por competencias (TRI multidimensional), validación y DIF | **G3** |
| 6 | 9–15 nov | F6 O4: SEM por competencia | — |
| 7 | 16–22 nov | F7 Robustez y novedad · inicio F8 | **G4** (resultados congelados) |
| 8 | 23–29 nov | F8 Producto · F9 Informe y sustentación | — |

La holgura está en F7 (se puede recortar a los análisis de sensibilidad mínimos) y en el RAG (opcional).

## Estructura de carpetas (reorganizada el 2026-10-04, decisión D-08)

```
CONSULTORIA/
├── README.md                 ← guía del repositorio y flujo de trabajo con GitHub Desktop
├── CLAUDE.md                 ← reglas para Claude
├── .gitignore
├── Vault_PISA2022/           ← este vault (fuente de verdad)
├── Proyecto_PISA/            ← proyecto actual
│   ├── Proyecto_PISA.Rproj
│   ├── anteproyecto/         ← anteproyecto vigente (PISA 2022): .Rmd, .pdf, referencias.bib, apa.csl
│   ├── datos/                ← PISA 2022 (.SAV) + cachés de Colombia + revision_pisa2022_col.R (no va a Git, salvo .R)
│   ├── documentacion/        ← Technical Reports, rúbrica del curso, libro de de Ayala
│   ├── scripts/              ← 01_etl_pisa.R … 07_robustez.R
│   ├── salidas/              ← tablas .csv, figuras .png, resultados .json (van a Git)
│   ├── informe/              ← informe final .Rmd
│   └── api/                  ← FastAPI (+ tablero)
```

---

## F0 — Organización (semana 1)  `[CONS]`

> [!info] Teoría previa
> Ninguna. Leer [[10 Gestión de la información]].

- [x] **0.1 Zotero + Better BibTeX.** Zotero 10.0.5 + Better BibTeX + ZotLit Companion instalados (2026-10-04).
  Grupo privado **Proyecto Final PISA**, colección *Proyecto PISA*, con las referencias de `referencias.bib` importadas
  con sus claves (2026-10-05). Detalle y pendientes en [[12 Guía de Zotero]]:
  - [ ] Vanessa y Brayan: crear su cuenta de Zotero y aceptar la invitación al grupo.
  - [ ] Enviar a la papelera del grupo `icfes2018puntajes` e `icfes2024acceso` (ya no forman parte del proyecto).
  - [ ] Adjuntar los PDF a medida que se verifiquen las fuentes.
- [x] **0.2 Obsidian.** Vault abierto con Dataview, ZotLit (carpeta `Literatura`) y Git (Vinzent03). Las notas de
  fuente ya existen; se verifican siguiendo [[11 Protocolo de verificación]].
- [x] **0.3 Git + GitHub privado.** Repositorio **Proyecto-Final-PISA** (https://github.com/osmateoramos/Proyecto-Final-PISA,
  rama `main`), sin datos de estudiantes (`.gitignore`). Flujo de trabajo en `README.md` (GitHub Desktop).
  - [ ] Vanessa y Brayan: aceptar la invitación de GitHub, clonar el repositorio y seguir la sección *Primera vez* del
    `README.md` (Mateo invita a Brayan: *Settings → Collaborators* en GitHub).
- [x] **0.4 Carpeta `Proyecto_PISA/`** con la estructura de arriba (2026-10-04).
- [x] **0.5 Preregistro.** Completar y fechar [[09 Hipótesis preregistradas]] **antes** de estimar cualquier modelo.
  - *Hecho:* congeladas el 2026-10-12, commit `f53054d` (anotado el 2026-10-16).
- **Salida:** `.bib` sincronizado, vault en Git, nota 09 fechada.
- **Autoevaluación:** ¿Por qué se escriben las hipótesis antes de modelar? ¿Qué pasaría con H5 si no?

## F1 — Datos y ETL (semana 1)  `[CONS]`

> [!info] Teoría previa
> Estructura de PISA: estudiante / colegio / ítem; valores plausibles y pesos (lectura: capítulos de ponderación
> y de escalamiento del Technical Report 2022).

Script: `Proyecto_PISA/scripts/01_etl_pisa.R` — parte de `datos/revision_pisa2022_col.R` y sus cachés.

> [!note] Reparto de la F1 (2026-10-16)
> La F1 se divide en tres scripts para avanzar en paralelo:
> - `01a_etl_cognitivo.R` (Vanessa): paso 1.2;
> - `01b_etl_cuestionario.R` (Mateo): pasos 1.3 y 1.4, con las reglas de [[03 Registro de decisiones]] (D-12);
> - `01_etl_pisa.R`: consolidación, pasos 1.1 y 1.5.
>
> Los cachés no van a Git: quien consolide necesita en su máquina los cachés de los dos scripts.
> La tabla de variables recodificadas queda en [[Datos/PISA2022 - Variables recodificadas]].

- [ ] **1.1 Unir las tres fuentes.** `COL_estudiantes_qqq.rds` + `COL_matematicas_cog.rds` por `CNTSTUID`;
  `CY08MSP_SCH_QQQ.SAV` (solo `CNT == "COL"`) por `CNTSCHID`.
  - *Por qué:* NSE y pesos están en el cuestionario; ítems y tiempos en el cognitivo; zona y sector en el de colegios.
- [x] **1.2 Recuperar los códigos de faltante.** Releer las columnas de ítems con `haven::read_sav(..., user_na = TRUE)`
  y revisar `attr(x, "labels")` para distinguir **omitido**, **no alcanzado** y **no administrado**.
  - *Por qué:* hoy esos tres quedan como `NA`; O3 necesita separarlos (D-05).
  - *Hecho (2026-10-16):* regla en D-13; `scripts/01a_etl_cognitivo.R` → `datos/COL_cognitivo.rds` y
    `salidas/cognitivo_estados_*.csv`. Los pendientes de D-13 se resolvieron con el Technical Report
    (pp. 212, 265 y 266); quedan dos anomalías declaradas.
- [ ] **1.3 Recodificar.**
  - Sexo: `ST004D01T` → Mujer / Hombre.
  - Zona: `SC001Q01TA` 1 → Rural (<3.000), 2 → Pueblo (3–15 mil), 3–6 → Urbana.
  - Sector: `SCHLTYPE` 3 → Público; 1–2 → Privado.
  - Posesiones (HOMEPOS 2022 usa ST250, ST251, ST253, ST254, ST255 y ST256; 27 ítems disponibles para Colombia):
    `ST250Q01–05JA` (Sí/No), `ST251Q01/02/03/04/06/07JA` (cantidades), `ST253Q01JA` (n.º de dispositivos digitales),
    `ST254Q01–06JA` (dispositivos), `ST255Q01JA` (libros), `ST256Q01/02/03/06/07/08/09/10JA` (tipos de libros).
  - Educación: `ST005Q01JA`, `ST007Q01JA` y `HISCED`; ocupación: `HISEI`.
  - Etiquetas de "Valid Skip", "Not Applicable", "Invalid", "No Response" → `NA`.
- [ ] **1.4 Diccionario.** Completar [[Datos/PISA2022 - Diccionario de variables]] (versión inicial del 2026-10-04,
  con `Proyecto_PISA/datos/diccionario_pisa2022.R`) con una tabla de variables recodificadas: variable original →
  variable nueva, regla de recodificación y % de `NA`.
- [ ] **1.5 Muestra analítica.** Definir y contar: con ESCS (7.459); con ≥10 ítems de matemáticas vistos (7.222);
  intersección. Comparar el puntaje medio de incluidos vs excluidos (¿la exclusión es aleatoria?).
  - *Ajuste (2026-10-16, D-14):* «visto» = respondido u omitido (D-13), no «tiene tiempo». Conteo exploratorio:
    7.198 con ≥10 vistos y 6.886 en la intersección con ESCS. El 7.222 de la revisión se reporta como control.
- **Salida:** `Proyecto_PISA/datos/COL_analitica.rds` (no va a Git), `salidas/conteos_muestra.csv`, diccionario.
- **Listo cuando:** el script corre desde cero y reproduce los conteos de la revisión del 29/09.
- **Autoevaluación:** ¿Qué diferencia hay entre una pregunta omitida y una no alcanzada? ¿A quién representa la
  muestra analítica?

## F2 — Validación del diseño muestral (semana 2)  `[CONS]` `[SEM]`

> [!info] Teoría previa
> Pesos muestrales, replicación BRR con ajuste de Fay (0,5), 10 valores plausibles y reglas de Rubin.

Script: `02_validacion_ocde.R` — reutiliza `pendiente()` y `estimar_pv()` de `Proyecto_PISA/datos/revision_pisa2022_col.R`.

- [ ] **2.1 Media de matemáticas de Colombia** con 10 PV + `W_FSTUWT` + 80 replicados. Objetivo publicado: **382,7
  (EE 3,0)** ([[Literatura/oecd2024pisa2022tr]]; el valor 382,70 coincide con [[Literatura/burns2026intest]], tabla 2,
  p. 9; falta la página del Technical Report).
- [ ] **2.2 Brecha por ESCS:** diferencia entre el cuartil más alto y el más bajo. Objetivo: **79 puntos** — ⚠️ cifra `sin_origen` hasta abrir [[Literatura/oecd2023fichacolombia]].
- [ ] **2.3 Varianza explicada por ESCS:** objetivo publicado **16 %** ([[Literatura/icfes2024pisa]]).
- [ ] **2.4 Alternativa de contraste:** repetir 2.1 con `EdSurvey` (su soporte de PISA 2022 es contribuido y no
  probado: si discrepa, manda la cifra de la OCDE).
- **Salida:** `salidas/validacion_ocde.csv` (nuestro vs publicado).
- **Listo cuando:** **Puerta G1** — las tres cifras coinciden dentro de ±1 punto (o ±1 punto porcentual).
- **Autoevaluación:** ¿Por qué no se puede promediar los 10 PV por estudiante y usar ese promedio?

## F3 — O1: medición del NSE (semanas 2–3)  `[TRI]` `[SEM]`

> [!info] Teoría previa
> Correlación policórica, análisis paralelo, AFE / AFC, 2PL y GPCM, función de información, omega.
> **Lectura:** [[Literatura/deayala2009theory|de Ayala]] caps. 4, 5 y 8 y pp. 131–133 · [[Literatura/chen2024structural|Chen y Yung]] caps. 2 y 5 (detalle en [[14 Libros de TRI y SEM]]).

Script: `03_nse_medicion.R` · paquetes `psych`, `mirt`, `lavaan`, `semTools`.

- [ ] **3.1 Dividir la muestra** en dos mitades aleatorias estratificadas por colegio (`set.seed(2026)`):
  *exploración* y *confirmación*.
- [ ] **3.2 Exploración:** matriz policórica de los 27 ítems de posesiones + educación + ocupación (categorizada);
  `psych::fa.parallel(cor = "poly")`; AFE con 1–3 factores (`oblimin`, `fm = "wls"`). ¿Aparece una dimensión
  económica y otra cultural (libros, educación, ocupación)?
- [ ] **3.3 TRI:** `mirt` con `itemtype` por columna (`"2PL"` para ST250, que es Sí/No; `"graded"` o `"gpcm"` para
  ST251, ST253, ST254, ST255 y ST256, que preguntan cantidades, y para educación). Tabla de parámetros (`coef(m, IRTpars = TRUE, simplify = TRUE)`), `itemfit()` (S-X²),
  curvas de información. ¿En qué rango del NSE mide bien la escala?
- [ ] **3.4 AFC en la mitad de confirmación:** 1 vs 2 factores con `estimator = "WLSMV"`, `ordered = …`; ajuste,
  `lavTestLRT()`, `semTools::compRelSEM()`. Con n ≈ 3.700 el χ² rechaza: reportarlo y usar CFI/RMSEA/SRMR.
- [ ] **3.5 Validez:** correlación de las puntuaciones (EAP) con `HOMEPOS` y `ESCS` oficiales.
- **Salida:** `salidas/nse_parametros_tri.csv`, `salidas/nse_ajuste_afc.csv`, figuras de información.
- **Listo cuando:** **Puerta G2** — modelo elegido con ajuste aceptable (CFI ≥ 0,95, RMSEA ≤ 0,06, SRMR ≤ 0,08) o
  desajuste documentado y explicado; H1 resuelta.
- **Autoevaluación:** ¿Por qué el AFC se hace en la otra mitad? ¿Qué significa *a* alto en "carro"?

## F4 — O2: invarianza del NSE (semana 4)  `[SEM]` `[TRI]`

> [!info] Teoría previa
> Invarianza configural / umbrales / métrica / escalar para indicadores ordinales; invarianza parcial; DIF.
> **Lectura:** [[Literatura/chen2024structural|Chen y Yung]] cap. 7 · [[Literatura/deayala2009theory|de Ayala]] cap. 12.

Script: `04_invarianza.R`.

- [ ] **4.1 Grupos:** zona (3), sexo (2), sector (2). Verificar n por grupo y celdas vacías en categorías raras.
- [ ] **4.2 Secuencia** con `semTools::measEq.syntax(..., ID.cat = "Wu.Estabrook.2016")`: configural → umbrales →
  métrica (cargas) → escalar (interceptos). Criterio: ΔCFI ≤ 0,01 y ΔRMSEA ≤ 0,015.
- [ ] **4.3 Invarianza parcial:** liberar parámetros uno por uno (índices de modificación) y documentar cuáles.
- [ ] **4.4 DIF con TRI** (`mirt::multipleGroup` + `DIF()` con ítems ancla) y tamaño del efecto (diferencia en
  puntaje esperado). ¿Coincide con 4.3?
- **Salida:** `salidas/invarianza_tabla.csv`, `salidas/nse_items_no_invariantes.csv`.
- **Listo cuando:** H2 resuelta; queda decidido con qué restricciones entra el NSE a F6.
- **Autoevaluación:** Si "carro" no es invariante entre zonas, ¿qué consecuencia tiene comparar el NSE rural y urbano?

## F5 — O3: calificar por competencias con TRI multidimensional (semana 5)  `[TRI]`

> [!info] Teoría previa
> TRI multidimensional (estructura entre ítems), 2PL y GPCM, calibración con datos faltantes por diseño, diseño
> adaptativo multietapa, puntajes EAP y valores plausibles, DIF basado en TRI, comparaciones múltiples.
> **Lectura:** [[Literatura/deayala2009theory|de Ayala]] cap. 10, pp. 148–151 (respuestas faltantes), cap. 11 (enlace), cap. 12 (DIF) y apéndice D.

Script: `05_tri_competencias.R` · `mirt`.

- [ ] **5.1 Clasificación de ítems por competencia.** Tabla ítem → competencia / contenido / formato desde la hoja
  *Mathematics-CBA* del anexo A del Technical Report 2022 (`Proyecto_PISA/documentacion/PISA2022_TechnicalReport_AnexoA_clasificacion_items.xlsx`):
  233 de 234 ítems con parámetros; `CMA112Q02S` figura como *Dropped* (retirado de la escala internacional; ver D-09).
  En Colombia, `CMA112Q02S` y `CMA143Q01S` no tienen ninguna respuesta: **quedan 232 calibrables** (emplear 75,
  interpretar 57, razonar 53, formular 47; `revision_pisa2022_col.R`, 2026-10-05).
  Guardar `salidas/items_competencia.csv`.
- [ ] **5.2 Matriz de respuestas:** 7.222 estudiantes × ítems clasificados (S y C); categorías parciales para los
  politómicos. Las celdas vacías por la ruta adaptativa se dejan `NA` (la ruta depende de respuestas observadas:
  es ignorable si se calibra con todas las etapas juntas).
- [ ] **5.3 Calibración unidimensional vs multidimensional.** (a) `mirt(datos, 1, …)`; (b) modelo confirmatorio de 4
  dimensiones, cada ítem cargando solo en su competencia (`mirt.model()` con `COV = F1*F2*F3*F4`, método
  `QMCEM` o `MHRM` por la dimensionalidad). Comparar AIC/BIC y ajuste → **H8**.
- [ ] **5.4 Calificar:** puntajes por competencia para cada estudiante (EAP y 10 valores plausibles con
  `fscores(..., plausible.draws = 10)`); confiabilidad empírica por competencia.
- [ ] **5.5 Validar contra la OCDE:** correlación ponderada entre el puntaje propio y los PV oficiales de la misma
  competencia (`MPFS`, `MPEM`, `MPIN`, `MPRE`) → **H7**. Comparar dificultades propias con los parámetros
  internacionales de la tabla A.3.
- [ ] **5.6 DIF por NSE dentro de cada competencia:** cuartil bajo vs alto de ESCS (o del NSE de O1); solo ítems con
  ≥100 respuestas por grupo (175 en la revisión); `multipleGroup` con anclas + `DIF()`; Benjamini-Hochberg; tamaño del
  efecto. ¿En qué competencia se concentra? → **H3**.
- [ ] **5.7 Omisiones (D-05):** calificar dos veces — (a) omitida = 0 (criterio OCDE); (b) omisión rápida (NT10) = `NA`
  — y comparar la brecha Q4–Q1 por competencia en desviaciones estándar → **H4**.
- **Salida:** `salidas/items_competencia.csv`, `salidas/mat_parametros_mirt.csv`, `salidas/puntajes_competencia.rds`
  (no va a Git), `salidas/validacion_ocde_competencias.csv`, `salidas/mat_dif.csv`, `salidas/brecha_omisiones.csv`.
- **Listo cuando:** **Puerta G3** — modelo de 4 competencias elegido o descartado con argumento; ítems con n
  insuficiente excluidos y documentados; H3, H4, H7 y H8 resueltas.
- **Autoevaluación:** ¿Qué gana la calificación por competencias frente a un puntaje único? ¿Por qué un ítem con DIF
  no significa automáticamente que sea injusto?

## F6 — O4: SEM por competencia (semana 6)  `[SEM]`

> [!info] Teoría previa
> Modelo estructural, valores plausibles como imputación múltiple, pesos y conglomerados en SEM.
> **Lectura:** [[Literatura/chen2024structural|Chen y Yung]] caps. 8 y 11. Pesos y valores plausibles: Technical Report (los libros no los tratan).

Script: `06_sem_competencias.R` · `lavaan`, `lavaan.mi`, `semTools`.

- [ ] **6.1 Modelo:** NSE latente (estructura y restricciones de F3–F4) → las 4 competencias calificadas en F5, con
  residuos correlacionados entre competencias; covariables: sexo, grado.
- [ ] **6.2 Estimación por cada conjunto de puntajes plausibles** (los 10 propios de F5) con
  `sampling.weights = "W_FSTUWT"` y `cluster = "CNTSCHID"`; combinar con `lavaan.mi` (Rubin). **Verificar** que
  `lavaan` acepta pesos con WLSMV; si no: **alternativa en dos pasos** (puntuaciones del NSE + regresiones con BRR).
- [ ] **6.3 Robustez:** repetir con los PV oficiales de la OCDE (`MPEM`, `MPFS`, `MPIN`, `MPRE`).
- [ ] **6.4 Igualdad de efectos** entre competencias (prueba de Wald o modelo restringido vs libre). Contrastar con el
  resultado exploratorio: interpretar − emplear = 3,9 (z = 2,61, PV OCDE) → H5.
- [ ] **6.5 Multigrupo** por zona o sector si F4 lo permite → H6.
- **Salida:** `salidas/sem_coeficientes.csv`, `salidas/sem_igualdad.csv`, diagrama del modelo.
- **Listo cuando:** coeficientes con EE, prueba de igualdad y ajuste reportados con ambos tipos de puntaje; H5 y H6
  resueltas.
- **Autoevaluación:** ¿Por qué estimar 10 veces y combinar, en vez de usar solo el primer puntaje plausible?

## F7 — Robustez y verificación de novedad (semana 7)  `[CONS]`

- [ ] **7.1 Sensibilidad** de cada hallazgo candidato:
  - NSE latente vs ESCS oficial;
  - con y sin estudiantes de la ruta lineal (1.793);
  - umbrales de omisión rápida NT10, NT15 y 5 s;
  - con y sin corrección por comparaciones múltiples.
- [ ] **7.2 Búsqueda formal de novedad** en Scopus / Google Scholar / Scielo / Redalyc para cada hallazgo;
  actualizar la [[Literatura/Matriz estado del arte|matriz]] (pasar las † a ✓ o corregir).
- [ ] **7.3 Aplicar el criterio de hallazgo innovador** de [[08 Rúbrica de desarrollo]] y redactar cada hallazgo en
  una frase para Colombia.
- **Salida:** `salidas/robustez.csv`, matriz actualizada, nota `Hallazgos.md`.
- **Listo cuando:** **Puerta G4** — resultados congelados (etiqueta Git `resultados-v1`); a partir de aquí solo se
  cambian si hay un error.

## F8 — Producto: API, tablero y RAG (semanas 7–8)  `[PY]`

> [!info] Teoría previa
> FastAPI, pydantic, pruebas con pytest; RAG (fragmentación, embeddings, recuperación, generación con citas).

- [ ] **8.1 Exportar** todos los resultados congelados a `salidas/*.csv|json` (la API solo lee; nunca estima).
- [ ] **8.2 API** en `Proyecto_PISA/api/`: `/nse/items`, `/matematicas/items`, `/invarianza/{grupo}`, `/dif`,
  `/modelo/procesos?grupo=`, `/docs`. Esquemas pydantic; respuestas agregadas por grupo (nunca por estudiante:
  Ley 1581 de 2012).
- [ ] **8.3 Pruebas** con `pytest` (un test por endpoint con datos reales).
- [ ] **8.4 Tablero** (Streamlit) que consume la API.
- [ ] **8.5 RAG (opcional, D-04):** LlamaIndex + Chroma; corpus = notas del vault + PDF de Zotero + Technical Report;
  embeddings locales; endpoint `/preguntar` que responde citando la fuente; evaluación con 15 preguntas cuya
  respuesta ya conocen.
- **Listo cuando:** `/docs` funciona, pruebas pasan, tablero muestra resultados reales.

## F9 — Informe y sustentación (semana 8)  `[CONS]`

- [ ] **9.1 Informe** en `Proyecto_PISA/informe/informe.Rmd` con citas de `referencias.bib`; cada cifra con su
  script y salida.
- [ ] **9.2 Declaración de uso de IA** y reparto del trabajo (igual que en el anteproyecto).
- [ ] **9.3 Ensayo cruzado:** cada uno expone una parte que no hizo; los otros dos preguntan con las autoevaluaciones de
  esta guía.
