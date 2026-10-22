---
tipo: guia
estado: por_verificar
lectura: "redactado por Claude; falta revisión del equipo"
pendientes: "Cifras de la puerta G1 (382,7 · 79 · 16 %) ubicadas con página el 2026-10-16; por_verificar hasta la firma del equipo"
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
  - [ ] Brayan: crear su cuenta de Zotero y aceptar la invitación al grupo. *(Vanessa: hecho; al 2026-10-18 está en
    el grupo y adjuntó los PDF.)*
  - [ ] Enviar a la papelera del grupo `icfes2018puntajes` e `icfes2024acceso` (ya no forman parte del proyecto).
  - [ ] Adjuntar los PDF a medida que se verifiquen las fuentes.
- [x] **0.2 Obsidian.** Vault abierto con Dataview, ZotLit (carpeta `Literatura`) y Git (Vinzent03). Las notas de
  fuente ya existen; se verifican siguiendo [[11 Protocolo de verificación]].
- [x] **0.3 Git + GitHub privado.** Repositorio **Proyecto-Final-PISA** (https://github.com/osmateoramos/Proyecto-Final-PISA,
  rama `main`), sin datos de estudiantes (`.gitignore`). Flujo de trabajo en `README.md` (GitHub Desktop).
  - *Actualización (2026-10-17):* el repositorio es público, para que el profesor lo revise (ver D-02).
  - [x] Vanessa y Brayan: aceptar la invitación de GitHub y clonar el repositorio (los dos suben commits desde sus
    ramas; anotado el 2026-10-18).
  - [ ] Brayan: seguir la sección *Primera vez* del `README.md` (descargar PISA 2022 y correr la cadena; ver
    [[17 Plan de trabajo Brayan]]).
- [x] **0.4 Carpeta `Proyecto_PISA/`** con la estructura de arriba (2026-10-04).
- [x] **0.5 Preregistro.** Completar y fechar [[09 Hipótesis preregistradas]] **antes** de estimar cualquier modelo.
  - *Hecho:* congeladas el 2026-10-12, commit `f53054d` (anotado el 2026-10-16).
- **Salida:** `.bib` sincronizado, vault en Git, nota 09 fechada.
- **Autoevaluación:** ¿Por qué se escriben las hipótesis antes de modelar? ¿Qué pasaría con H5 si no?

## F1 — Datos y ETL (semana 1)  `[CONS]`

> [!info] Teoría previa
> Estructura de PISA: estudiante / colegio / ítem; valores plausibles y pesos (lectura: capítulos de ponderación
> y de escalamiento del Technical Report 2022).

Scripts: `Proyecto_PISA/scripts/01a_etl_cognitivo.R`, `01b_etl_cuestionario.R` y `01c_muestra_analitica.R`; parten
de `datos/revision_pisa2022_col.R` y sus cachés. El plan original preveía un solo `01_etl_pisa.R`; se dividió (ver la
nota de abajo).

> [!note] Reparto de la F1 (2026-10-16)
> La F1 se hizo en tres scripts, que se corren en este orden:
> - `01a_etl_cognitivo.R` (Vanessa): paso 1.2, con D-13;
> - `01b_etl_cuestionario.R` (Mateo): pasos 1.3 y 1.4, con las reglas de [[03 Registro de decisiones]] (D-12);
> - `01c_muestra_analitica.R` (Vanessa; revisado por Mateo en el PR #7): paso 1.1 (unión de los cachés de 01a y
>   01b) y paso 1.5 (muestra analítica con D-14).
>
> Después sigue `02_validacion_ocde.R` (F2). Funciones comunes de estimación en `scripts/utilidades_pisa.R`.
> Los cachés no van a Git: para correr 01c y 02 hacen falta en la máquina los cachés de 01a y 01b.
> La tabla de variables recodificadas queda en [[Datos/PISA2022 - Variables recodificadas]].

- [x] **1.1 Unir las tres fuentes.** `COL_estudiantes_qqq.rds` + `COL_matematicas_cog.rds` por `CNTSTUID`;
  `CY08MSP_SCH_QQQ.SAV` (solo `CNT == "COL"`) por `CNTSCHID`.
  - *Por qué:* NSE y pesos están en el cuestionario; ítems y tiempos en el cognitivo; zona y sector en el de colegios.
  - *Hecho (2026-10-16):* colegios unidos en `01b` (Mateo). Cuestionario + cognitivo por `CNTSTUID` en
    `01c_muestra_analitica.R` (Vanessa), con los cachés nuevos `COL_cuestionario.rds` + `COL_cognitivo.rds`: 7.804
    estudiantes, IDs iguales y `CNTSCHID` coincidente. Se hizo en 01c para no esperar; revisado por Mateo (PR #7).
- [x] **1.2 Recuperar los códigos de faltante.** Releer las columnas de ítems con `haven::read_sav(..., user_na = TRUE)`
  y revisar `attr(x, "labels")` para distinguir **omitido**, **no alcanzado** y **no administrado**.
  - *Por qué:* hoy esos tres quedan como `NA`; O3 necesita separarlos (D-05).
  - *Hecho (2026-10-16):* regla en D-13; `scripts/01a_etl_cognitivo.R` → `datos/COL_cognitivo.rds` y
    `salidas/cognitivo_estados_*.csv`. Los pendientes de D-13 se resolvieron con el Technical Report
    (pp. 211, 264 y 265); quedan dos anomalías declaradas.
- [x] **1.3 Recodificar.** *Hecho por Mateo (`01b_etl_cuestionario.R`, D-12, PR #5; marcado el 2026-10-16).*
  - Sexo: `ST004D01T` → Mujer / Hombre.
  - Zona: `SC001Q01TA` 1 → Rural (<3.000), 2 → Pueblo (3–15 mil), 3–6 → Urbana.
  - Sector: `SCHLTYPE` 3 → Público; 1–2 → Privado.
  - Posesiones (HOMEPOS 2022 usa ST250, ST251, ST253, ST254, ST255 y ST256; 27 ítems disponibles para Colombia):
    `ST250Q01–05JA` (Sí/No), `ST251Q01/02/03/04/06/07JA` (cantidades), `ST253Q01JA` (n.º de dispositivos digitales),
    `ST254Q01–06JA` (dispositivos), `ST255Q01JA` (libros), `ST256Q01/02/03/06/07/08/09/10JA` (tipos de libros).
  - Educación: `ST005Q01JA`, `ST007Q01JA` y `HISCED`; ocupación: `HISEI`.
  - Etiquetas de "Valid Skip", "Not Applicable", "Invalid", "No Response" → `NA`.
- [x] **1.4 Diccionario.** Completar [[Datos/PISA2022 - Diccionario de variables]] (versión inicial del 2026-10-04,
  con `Proyecto_PISA/datos/diccionario_pisa2022.R`) con una tabla de variables recodificadas: variable original →
  variable nueva, regla de recodificación y % de `NA`.
  - *Hecho por Mateo:* [[Datos/PISA2022 - Variables recodificadas]] y `salidas/diccionario_cuestionario.csv`
    (PR #5). Las variables cognitivas están descritas en el encabezado de `01a_etl_cognitivo.R`.
- [x] **1.5 Muestra analítica.** Definir y contar: con ESCS (7.459); con ≥10 ítems de matemáticas vistos (7.222);
  intersección. Comparar el puntaje medio de incluidos vs excluidos (¿la exclusión es aleatoria?).
  - *Ajuste (2026-10-16, D-14):* «visto» = respondido u omitido (D-13), no «tiene tiempo». Conteo exploratorio:
    7.198 con ≥10 vistos y 6.886 en la intersección con ESCS. El 7.222 de la revisión se reporta como control.
  - *Hecho (2026-10-16):* `01c_muestra_analitica.R` → **6.886 estudiantes** (87,5 % de la población ponderada).
    La exclusión no es aleatoria: los excluidos rinden 14,6 puntos menos (EE 3,0), ver D-14.
- **Salida:** `Proyecto_PISA/datos/COL_analitica.rds` (no va a Git), `salidas/conteos_muestra.csv`, diccionario.
- **Listo cuando:** el script corre desde cero y reproduce los conteos de la revisión del 29/09.
  - ✅ *Cumplido:* 01c se detiene si no da 7.459 con ESCS y 7.222 con tiempo válido; los reproduce. Para correr desde
    cero: `01a` → `01b` → `01c` (cada uno lee el `.SAV` solo si falta su caché).
- **Autoevaluación:** ¿Qué diferencia hay entre una pregunta omitida y una no alcanzada? ¿A quién representa la
  muestra analítica?

## F2 — Validación del diseño muestral (semana 2)  `[CONS]` `[SEM]`

> [!info] Teoría previa
> Pesos muestrales, replicación BRR con ajuste de Fay (0,5), 10 valores plausibles y reglas de Rubin.

Script: `02_validacion_ocde.R` — reutiliza `pendiente()` y `estimar_pv()` de `Proyecto_PISA/datos/revision_pisa2022_col.R`.

- [x] **2.1 Media de matemáticas de Colombia** con 10 PV + `W_FSTUWT` + 80 replicados. Objetivo publicado: **382,7
  (EE 3,0)** ([[Literatura/oecd2024pisa2022tr]]; el valor 382,70 coincide con [[Literatura/burns2026intest]], tabla 2,
  p. 9; Technical Report, Annex Table 14.A.12, p. 301).
- [x] **2.2 Brecha por ESCS:** diferencia entre el cuartil más alto y el más bajo. Objetivo: **79 puntos** ([[Literatura/oecd2023fichacolombia]], p. 5; era `sin_origen` hasta que se abrió la ficha el 2026-10-16).
- [x] **2.3 Varianza explicada por ESCS:** objetivo publicado **16 %** ([[Literatura/icfes2024pisa]], p. 46 del visor; [[Literatura/oecd2023fichacolombia]], p. 5).
- [x] **2.4 Alternativa de contraste:** repetir 2.1 con `EdSurvey` (su soporte de PISA 2022 es contribuido y no
  probado: si discrepa, manda la cifra de la OCDE).
- **Salida:** `salidas/validacion_ocde.csv` (nuestro vs publicado).
- **Listo cuando:** **Puerta G1** — las tres cifras coinciden dentro de ±1 punto (o ±1 punto porcentual).
  - *Hecho (2026-10-16, D-15):* **G1 pasa.** `scripts/02_validacion_ocde.R` → `salidas/validacion_ocde.csv`:
    - media 382,70 (EE 3,03), frente a 382,70 (3,03);
    - brecha 78,56 (EE 5,74), frente a 79;
    - varianza explicada 16,16 % (EE 2,09), frente a 16 %.

    El 2.4 se hizo con el paquete `survey` en vez de `EdSurvey` (D-15) y da las mismas cifras y errores estándar.
    Mateo lo revisó en el PR #7 y reprodujo la tabla en su máquina; falta la revisión de Brayan.
- **Autoevaluación:** ¿Por qué no se puede promediar los 10 PV por estudiante y usar ese promedio?

## F3 — O1: medición del NSE (semanas 2–3)  `[TRI]` `[SEM]`

> [!info] Teoría previa
> Correlación policórica, análisis paralelo, AFE / AFC, 2PL y GPCM, función de información, omega.
> **Lectura:** [[Literatura/deayala2009theory|de Ayala]] caps. 4, 5 y 8 y pp. 131–133 · [[Literatura/chen2024structural|Chen y Yung]] caps. 2 y 5 (detalle en [[14 Libros de TRI y SEM]]).

Scripts: `03_nse_medicion.R` (3.1 y 3.2), `03_nse_tri.R` (3.3, 3.3b y 3.5; D-19 y D-21) y `03_nse_afc.R` (3.4, D-18) · paquetes `psych`, `mirt`, `lavaan`, `semTools` (instalados en R 4.4.1 el 2026-10-16,
con `GPArotation` para la rotación oblimin).

> [!note] Decisiones de la F3 en [[03 Registro de decisiones]] (D-16, aceptada por Vanessa el 2026-10-16)
> - Muestra analítica de 6.886 y mitades al azar dentro de cada colegio.
> - 29 indicadores: las 27 posesiones, `HISCED` y `HISEI` en quintiles.
> - Categorías con < 2 % unidas a su vecina; pesos normalizados; faltantes por pares.
> - Estructura de 2 factores fijada antes de ver los datos: cultural (12) y económico (17).
> - H1 exige que los dos CFI (*scaled* y *robust*) mejoren ≥ 0,01.
> - TRI 2PL + GPCM, unidimensional y bidimensional.
>
> Exploración previa: `scripts/03_explorar_items_nse.R`.

- [x] **3.1 Dividir la muestra** en dos mitades aleatorias estratificadas por colegio (`set.seed(2026)`):
  *exploración* y *confirmación*.
  - *Hecho (2026-10-17, D-16):* `03_nse_medicion.R` (sección 3.1) → `datos/COL_nse.rds`,
    `salidas/nse_recodificacion.csv` y `salidas/nse_mitades.csv`.
    - **Mitades:** exploración 3.445 y confirmación 3.441. Quedan equilibradas en peso (49,9 / 50,1 %), ESCS
      medio (−1,065 / −1,040), HOMEPOS (−1,351 / −1,381), % rural (15,1 / 15,6) y % público (80,3 / 80,4).
    - **Recodificación:** la regla del 2 % unió categorías en 7 ítems: `ST254Q01JA` a `ST254Q05JA`, `ST255Q01JA`
      y `ST256Q01JA` (`salidas/nse_recodificacion.csv`). Eran 5 en la primera corrida; con D-20 son 7.
      `HISCED_c` (0–9) no se tocó. `HISEI_q` quedó en quintiles con el ~20 % del peso cada uno.
      *Revisión de Brayan (PR #12, 2026-10-18), corregido el 2026-10-19:* decía «solo los 5 ítems previstos en D-16».
- [x] **3.2 Exploración:** matriz policórica de los 27 ítems de posesiones + educación + ocupación (categorizada);
  `psych::fa.parallel(cor = "poly")`; AFE con 1–3 factores (`oblimin`, `fm = "wls"`). ¿Aparece una dimensión
  económica y otra cultural (libros, educación, ocupación)?
  - *Hecho (2026-10-17):* `03_nse_medicion.R` (sección 3.2), en la mitad de exploración (3.445).
    - Por D-16, el análisis paralelo se hizo sobre la policórica **ponderada**, no con `cor = "poly"`, que no
      admite pesos.
    - **Análisis paralelo:** el criterio de factores sugiere 7 y el de componentes, 4
      (`salidas/nse_analisis_paralelo.csv`). Dominan 2 autovalores (10,12 y 3,16; el tercero es 0,66) y el AFE de
      3 factores solo agrega un factor de un ítem (motos), así que se leyó como estructura de 2 factores (D-16).
      *Revisión de Brayan (PR #12, 2026-10-18), corregido el 2026-10-19:* faltaba anotar los 7 factores.
    - **Respuesta:** aparecen 2 factores (r = 0,47 con D-20; 0,44 antes), pero el cultural es solo de **libros**. La educación, la
      ocupación, el arte y los instrumentos cargan con lo económico; 25 de 29 ítems coinciden con D-16.
    - Detalle y salidas en el resultado del 3.2 dentro de D-16. La estructura del AFE pasa al 3.4 como
      exploratoria.
- [x] **3.3 TRI:** `mirt` con `itemtype` por columna (`"2PL"` para ST250, que es Sí/No; `"graded"` o `"gpcm"` para
  ST251, ST253, ST254, ST255 y ST256, que preguntan cantidades, y para educación). Tabla de parámetros (`coef(m, IRTpars = TRUE, simplify = TRUE)`), `itemfit()` (S-X²),
  curvas de información. ¿En qué rango del NSE mide bien la escala?
  - *Hecho (2026-10-17, D-19 y D-20):* `03_nse_tri.R`, un script aparte para no reestimar los modelos.
    - Tres modelos: 1D, 2D de D-16 y 2D del AFE.
    - Por AIC y BIC, los dos modelos de 2 dimensiones quedan por debajo del de 1 (`salidas/nse_ajuste_tri.csv`).
      Es una comparación descriptiva en los 6.886 (D-19): la prueba de H1 es el AFC del 3.4.
      *Revisión de Brayan (PR #12, 2026-10-18), corregido el 2026-10-19:* decía «ajustan mucho mejor que una».
    - Ningún ítem es problemático: el RMSEA del S-X² es ≤ 0,027.
    - **Respuesta:** la escala mide bien (información ≥ 4) en θ de −2,3 a 3,5 con 1 dimensión. En 2 dimensiones, lo
      económico mide en un rango amplio (−2,2 a 2,7) y lo cultural (libros) mide muy bien sobre el promedio y poco
      en el extremo bajo (−1,5 a 2,7).
    - Detalle en el resultado de D-19.
- [x] **3.3b Dependencia local (P1 de [[14 Libros de TRI y SEM]], D-21):** Q3 de Yen en los tres modelos del 3.3, en
  los 6.886 y sin pesos. Se marca un par con |Q3| > 0,2 (de Ayala, p. 134). Es exploratorio: no cambia H1.
  - *Por qué:* D-20 deja a quien no tiene libros con 0 en los 9 ítems de libros a la vez. Si se viola la independencia
    condicional, la información y la confiabilidad se sobreestiman (de Ayala, p. 131).
  - *Hecho (2026-10-18):* `03_nse_tri.R` (sección 3.3b) → `salidas/nse_q3_tri.csv`.
    - Pares marcados de 406: 69 con 1 dimensión, 10 con la de D-16 y 13 con la del AFE.
    - El patrón de 1D (positivos dentro de los libros, negativos entre los libros y el resto) es el de un modelo al
      que le falta una dimensión.
    - No hay dependencia positiva dentro de los libros en 2D. Sí la hay en baños–sanitarios (0,46) y en
      educación–ocupación de los padres (0,35). Detalle en D-21.
    - **Pendiente menor** (revisión de Brayan, PR #12, 2026-10-18; anotado el 2026-10-19): en 2D quedan marcados pares **negativos** entre
      `ST255Q01JA` y varios `ST256`, de −0,21 a −0,27 (`salidas/nse_q3_tri.csv`), que D-21 no explica.
  - *De paso se corrigieron* las cargas del modelo 2D (error de `mirt`, D-19) y se agregó la información de cada ítem.
- [x] **3.4 AFC en la mitad de confirmación:** 1 vs 2 factores con `estimator = "WLSMV"`, `ordered = …`; ajuste,
  `lavTestLRT()`, `semTools::compRelSEM()`. Con n ≈ 3.400 el χ² rechaza: reportarlo y usar CFI/RMSEA/SRMR.
  - *Reglas fijadas en D-18 (2026-10-18), antes de correrlo:* H1 con los modelos puros de D-16; sensibilidad sin pesos
    y otra, exploratoria, con 10 residuos correlacionados entre ítems que se superponen.
  - *Hecho (2026-10-18, Vanessa):* `03_nse_afc.R` → `salidas/nse_ajuste_afc.csv`, `nse_h1_afc.csv`,
    `nse_cargas_afc.csv`, `nse_omega_afc.csv` y `nse_residuos_afc.csv` (n = 3.441).
    - **H1 se acepta:** el CFI sube 0,107 (*scaled*) y 0,218 (*robust*) de 1 a 2 factores, y la correlación entre
      factores es 0,559.
    - **El ajuste no llega a los cortes de la G2.** M2 (D-16): CFI 0,921 / 0,731, RMSEA 0,071 / 0,119, SRMR 0,087.
      La estructura del AFE ajusta mejor (CFI 0,943 / 0,753, RMSEA 0,060 / 0,114, SRMR 0,071).
    - El desajuste viene sobre todo de educación–ocupación de los padres y de lo digital frente a la vivienda. Detalle
      en el resultado de D-18.
- [x] **3.5 Validez:** correlación de las puntuaciones (EAP) con `HOMEPOS` y `ESCS` oficiales.
  - *Hecho (2026-10-17):* `03_nse_tri.R` → `salidas/nse_validez.csv` (correlación ponderada, 6.886).
    - El factor económico correlaciona 0,96 con HOMEPOS y entre 0,77 y 0,81 con ESCS.
    - El cultural (libros), entre 0,62 y 0,65 con HOMEPOS y entre 0,47 y 0,51 con ESCS.
    - El modelo de 1 dimensión, 0,91 y 0,74.
- **Salida:** `salidas/nse_parametros_tri.csv`, `salidas/nse_q3_tri.csv`, `salidas/nse_ajuste_afc.csv`,
  `salidas/nse_cargas_afc.csv`, `salidas/nse_omega_afc.csv`, figuras de información.
- **Listo cuando:** **Puerta G2** — modelo elegido con ajuste aceptable (CFI ≥ 0,95, RMSEA ≤ 0,06, SRMR ≤ 0,08) o
  desajuste documentado y explicado; H1 resuelta.
  - ✅ *G2 pasa con el desajuste documentado (2026-10-18; D-24; acta en [[Reuniones/2026-10-18 Puerta G2]]).*
    - H1 se acepta.
    - Pasa a la F4–F6 el modelo de 2 dimensiones del AFE: económico (19) y libros (10). Motos se mantiene y se
      reporta.
    - Mateo y Brayan firman el acta.
- **Autoevaluación:** ¿Por qué el AFC se hace en la otra mitad? ¿Qué significa *a* alto en "carro"?

## F4 — O2: invarianza del NSE (semana 4)  `[SEM]` `[TRI]`

> [!info] Teoría previa
> Invarianza configural / umbrales / métrica / escalar para indicadores ordinales; invarianza parcial; DIF.
> **Lectura:** [[Literatura/chen2024structural|Chen y Yung]] cap. 7 · [[Literatura/deayala2009theory|de Ayala]] cap. 12.

Script: `04_invarianza.R`.

> [!success] Decidido en D-25 (2026-10-18, antes de estimar)
> - Muestra completa (6.886).
> - H2 con rural (904) frente a urbana (4.927); O2 con las 3 zonas, el sexo y el sector.
> - Categorías con menos de 10 respuestas unidas en todos los grupos: cambian `ST254Q02JA`, `ST251Q01JA` y
>   `HISCED_c`.
> - Wu y Estabrook con parametrización theta.
> - ΔCFI 0,01 y ΔRMSEA 0,015 en versión *scaled* ([[Literatura/putnick2016measurement]]).
> - DIF por factor con anclas depuradas, y magnitud ΔR² de Nagelkerke ≥ 0,035.
>
> Exploración: `scripts/04_explorar_grupos.R` → `salidas/inv_grupos_n.csv` e `inv_categorias_grupo.csv`.
>
> *Lo que quedaba abierto antes de D-25:*
> - **Grupos de H2:** H2 habla de zona rural frente a urbana, pero la zona tiene 3 categorías (rural / pueblo / urbana).
> - **Muestra:** completa (6.886) o mitad de confirmación; D-16 punto 2 no lo dice.
> - **Categorías vacías por grupo:** qué se hace si una categoría no aparece en un grupo (la invarianza de umbrales
>   exige las mismas categorías en todos).
> - **Magnitud del DIF:** ΔR² ≥ 0,035 (D-22); falta fijar el tipo de R² y el estimador.
> - **Criterios ΔCFI y ΔRMSEA:** fuente de acceso abierto si D-10 queda en (b) (D-23 punto 6).

- [x] **4.1 Grupos:** zona (3), sexo (2), sector (2). Verificar n por grupo y celdas vacías en categorías raras.
  Ajustar primero el modelo en cada grupo por separado (P6, D-21).
- [x] **4.2 Secuencia** con `semTools::measEq.syntax(..., ID.cat = "Wu.Estabrook.2016")`: configural → umbrales →
  métrica (cargas) → escalar (interceptos). Criterio: ΔCFI ≤ 0,01 y ΔRMSEA ≤ 0,015.
- [x] **4.3 Invarianza parcial:** liberar parámetros uno por uno (índices de modificación) y documentar cuáles.
- [x] **4.4 DIF con TRI** (`mirt::multipleGroup` + `DIF()` con ítems ancla) y tamaño del efecto. ¿Coincide con 4.3?
  - *P4 (D-21):* DIF uniforme y no uniforme, depuración iterativa de las anclas y un segundo método como robustez.
  - *Magnitud (D-22):* «no despreciable» = ΔR² ≥ 0,035 en las posesiones (ítems ordinales).
- [x] **4.5 Medias latentes del NSE (P6, D-21):** con el nivel de invarianza que se sostenga (total o parcial), comparar
  las medias latentes del NSE entre zonas y sectores, con la parametrización theta.
- **Salida:** `salidas/invarianza_tabla.csv`, `salidas/nse_items_no_invariantes.csv`, `salidas/nse_medias_latentes.csv`.
- *Hecho (2026-10-18, Vanessa):* `04_invarianza.R` → `salidas/invarianza_por_grupo.csv`, `invarianza_tabla.csv`,
  `nse_items_no_invariantes.csv` y `nse_medias_latentes.csv` (muestra completa; D-25).
  - **4.1:** el AFC del AFE converge en los 7 grupos (CFI *scaled* de 0,929 a 0,954).
    - **Limitación** (revisión de Brayan, PR #12, 2026-10-18; anotado el 2026-10-19): que converja no quiere decir que ajuste bien en cada
      grupo. En 4 de los 7 grupos (urbana, rural, mujer y privado) `lavaan` no da el CFI ni el RMSEA *robust*,
      aunque el 4.1 no tiene restricciones de igualdad. Donde sí salen, el CFI *robust* va de 0,68 a 0,71 y el
      RMSEA *robust* de 0,12 a 0,14 (`salidas/invarianza_por_grupo.csv`), tan lejos de los cortes como en la G2.
  - **4.2:** la invarianza **escalar total** se sostiene en zona, rural–urbana, sexo y sector. El peor cambio es del
    sector: ΔCFI −0,007 y ΔRMSEA +0,002, dentro de los cortes.
  - **4.3:** no hizo falta liberar ningún parámetro.
  - **Prueba de diferencia escalada (D-28, 2026-10-19):** complemento que no decide. Sale significativa en 10 de los 12
    pasos (solo no en umbrales y cargas de sexo); en el escalar rural–urbana, Δχ² = 273,4 con 21 gl. La invarianza y
    H2 siguen decidiéndose con ΔCFI/ΔRMSEA, como dice D-25 (`salidas/invarianza_tabla.csv`).
  - **4.5:** diferencias de medias latentes en DE frente al grupo de referencia:
    - rural frente a urbana: −0,95 en el factor económico y −0,17 en libros;
    - pueblo frente a urbana: −0,63 y −0,19;
    - privado frente a público: +1,43 y +0,60;
    - hombre frente a mujer: +0,05 y −0,12.
    - **Ojo** (revisión de Brayan, PR #12, 2026-10-18; anotado el 2026-10-19): los `ee` y los IC 95 % de `nse_medias_latentes.csv` son los de
      `lavaan` y no reflejan el diseño por colegios (D-16 punto 5; D-25 punto 9). No se leen como intervalos
      válidos hasta tener errores con BRR.
  - **4.4 (DIF, D-26):** solo motos tiene DIF no despreciable, por zona (ΔR² = 0,042). **H2 se rechaza**: el paso
    escalar rural–urbana no empeora y ningún ítem tiene DIF no despreciable en ese contraste. F4 cerrada (2026-10-18).
  - *Antes:* la primera corrida del DIF fue inválida (D-26); la corregida estaba en curso al
    cerrar la sesión del 2026-10-18. Aun así, el paso escalar rural–urbana no empeora (ΔCFI −0,003), así que la primera
    condición de H2 no se cumple.
- **Listo cuando:** H2 resuelta; queda decidido con qué restricciones entra el NSE a F6.
- **Autoevaluación:** Si "carro" no es invariante entre zonas, ¿qué consecuencia tiene comparar el NSE rural y urbano?

## F5 — O3: calificar por competencias con TRI multidimensional (semana 5)  `[TRI]`

> [!info] Teoría previa
> TRI multidimensional (estructura entre ítems), 2PL y GPCM, calibración con datos faltantes por diseño, diseño
> adaptativo multietapa, puntajes EAP y valores plausibles, DIF basado en TRI, comparaciones múltiples.
> **Lectura:** [[Literatura/deayala2009theory|de Ayala]] cap. 10, pp. 148–151 (respuestas faltantes), cap. 11 (enlace), cap. 12 (DIF) y apéndice D.

Script: `05_tri_competencias.R` · `mirt`.

- [x] **5.1 Clasificación de ítems por competencia.** *Hecho (2026-10-18):* `scripts/05_explorar_items.R` →
  `salidas/items_competencia.csv`. Las reglas de la F5 están en D-27. Tabla ítem → competencia / contenido / formato desde la hoja
  *Mathematics-CBA* del anexo A del Technical Report 2022 (`Proyecto_PISA/documentacion/PISA2022_TechnicalReport_AnexoA_clasificacion_items.xlsx`):
  233 de 234 ítems con parámetros; `CMA112Q02S` figura como *Dropped* (retirado de la escala internacional; ver D-09).
  En Colombia, `CMA112Q02S` y `CMA143Q01S` no tienen ninguna respuesta: **quedan 232 calibrables** (emplear 75,
  interpretar 57, razonar 53, formular 47; `revision_pisa2022_col.R`, 2026-10-05).
  Guardar `salidas/items_competencia.csv`. *D-09 cerrada (2026-10-18): `CMA112Q02S` se excluye, como en la OCDE.*
- [x] **5.2 Matriz de respuestas:** ~~7.222~~ estudiantes × ítems clasificados (S y C); categorías parciales para los
  politómicos. Las celdas vacías por la ruta adaptativa se dejan `NA` (la ruta depende de respuestas observadas:
  es ignorable si se calibra con todas las etapas juntas).
  - *Muestra por decidir (D-23 punto 2):* el 7.222 es el conteo de la revisión del 29/09; la muestra del proyecto es la
    de 6.886 (D-14, D-16).
  - *P2 (D-21):* calibrar los 232 ítems y repetir sin los que tienen menos de 500 respuestas, como robustez (F7).
  - *Hecho (2026-10-20, Vanessa; reglas de D-27 puntos 1, 2 y 5):* `scripts/05_tri_competencias.R` (sección 5.2) →
    `datos/COL_mat_respuestas.rds` (no va a Git) y `salidas/mat_matriz_resumen.csv`.
    - Matriz de los 6.886 de la muestra analítica × 232 ítems: 170 dicotómicos y 62 de crédito parcial.
    - Dato en el 11,66 % de las celdas; mediana de 29 ítems por estudiante.
    - Tres versiones según la omisión: (a) omitida = 0, (b) omisión rápida (NT10) faltante y (c) toda omisión
      faltante. Hay 12.490 omisiones, de las que 4.852 son rápidas: las mismas cifras que D-27.
- [x] **5.3 Calibración unidimensional vs multidimensional.** (a) `mirt(datos, 1, …)`; (b) modelo confirmatorio de 4
  dimensiones, cada ítem cargando solo en su competencia (`mirt.model()` con `COV = F1*F2*F3*F4`, método
  `QMCEM` o `MHRM` por la dimensionalidad). Comparar AIC/BIC y ajuste → **H8**.
  - *P1 (D-21):* revisar la dependencia local con el Q3 dentro de cada unidad (estímulo común). En Colombia, 211 de los
    234 ítems están en unidades de 2 o más ítems ([[14 Libros de TRI y SEM]]).
  - *D-23 punto 4:* hacer antes una corrida piloto de tiempos (semana 4).
  - *Hecho (2026-10-20, Vanessa):* `scripts/05_tri_competencias.R` (sección 5.3) → `salidas/mat_ajuste.csv`; modelos en
    `datos/COL_mat_tri_1D.rds` y `COL_mat_tri_4D.rds` (no van a Git). Versión (a) de la matriz, pesos y `QMCEM` con
    1.000 puntos en los dos (D-27).
    - 1 dimensión: convergió en 123 iteraciones (7 min); BIC 204.268,8. 4 competencias: convergió en 258 iteraciones
      (45 min); BIC 204.296,1. El AIC favorece por poco al de 4 (200.658,6 frente a 200.672,4).
    - Correlaciones entre competencias: de 0,897 (formular–interpretar) a 0,976 (emplear–razonar); emplear–
      interpretar, 0,951.
    - **H8 se rechaza** por las dos condiciones: el BIC es menor con 1 dimensión y dos correlaciones pasan de 0,95.
    - `mirt` avisó que la log-verosimilitud bajaba cerca de la solución del modelo de 4 dimensiones.
      *Interpretación del equipo (Vanessa):* es ruido de la integración con 1.000 puntos, así que la diferencia de BIC
      se lee con cautela; la condición de las correlaciones (0,976) sostiene el rechazo por sí sola.
    - *Decidido en D-29 (Vanessa, 2026-10-20):* se califica con el modelo de 4 competencias y se agrega un bifactor
      exploratorio.
  - **5.3b Bifactor exploratorio (D-29):** `scripts/05_tri_competencias.R` (sección 5.3b) →
    `salidas/mat_bifactor_viabilidad.csv`, `mat_bifactor_frontera.csv` y `mat_bifactor_items.csv`.
    - **No es viable** según los criterios fijados antes de estimar: no convergió en 2.000 ciclos (174,6 min) y no se
      pudo calcular ningún error estándar; `mirt` advirtió que el modelo podría no estar identificado empíricamente.
    - No se interpretan sus cargas específicas ni se reportan el ECV ni el omega. Las explicaciones plausibles y la
      interpretación del equipo están en D-29.
- [ ] **5.4 Calificar:** *(en curso, 2026-10-20: V1 de la posterior propia no se cumple; diagnóstico en D-27)* puntajes por competencia para cada estudiante (EAP y 10 valores plausibles con
  `fscores(..., plausible.draws = 10)`); confiabilidad empírica por competencia.
  - **Riesgo (D-23 punto 1):** sin condicionar en el NSE, los PV propios atenúan el efecto del NSE en la F6. Propuesta:
    regresión latente (`covdata` y `formula` de `mirt`) sobre el NSE de la G2 y las covariables del SEM. Decidirlo
    antes de la F5.
- [ ] **5.5 Validar contra la OCDE:** correlación ponderada entre el puntaje propio y los PV oficiales de la misma
  competencia (`MPFS`, `MPEM`, `MPIN`, `MPRE`) → **H7**, calculada como en D-22 (promedio de las 10 correlaciones PV a
  PV). Comparar dificultades propias con los parámetros internacionales de la tabla A.3.
  - *P3 (D-21):* antes de comparar dificultades, llevar la métrica propia a la de la OCDE (enlace). La correlación de H7
    no necesita enlace.
- [ ] **5.6 DIF por NSE dentro de cada competencia:** cuartil bajo vs alto del NSE elegido en la G2 (con ESCS como
  robustez; D-22); solo ítems con ≥100 respuestas por grupo (175 en la revisión del 29/09: recontar, D-23 punto 3);
  `multipleGroup` con anclas + `DIF()`; Benjamini-Hochberg; tamaño del efecto. ¿En qué competencia se concentra? →
  **H3**.
  - *Magnitud (D-22):* categoría B o C del ETS (|ΔMH| > 1) en los ítems dicotómicos; ΔR² ≥ 0,035 en los de crédito
    parcial; emparejando con el θ de la TRI.
  - *P4 (D-21):* DIF uniforme y no uniforme, depuración de anclas, segundo método y revisión del contenido antes de
    hablar de sesgo.
- [ ] **5.7 Omisiones (D-05):** calificar dos veces — (a) omitida = 0 (criterio OCDE); (b) omisión rápida (NT10) = `NA`
  — y comparar la brecha Q4–Q1 por competencia en desviaciones estándar → **H4**, con la prueba de D-22.
  - *P5 (D-21):* un tercer tratamiento como sensibilidad (crédito fraccional 1/m, o la omisión como categoría en un
    modelo nominal). H4 no cambia.
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
  - *Comprobado con datos simulados (D-18, 2026-10-18):* `lavaan` 0.7-3 acepta WLSMV con `sampling.weights` y
    faltantes por pares.
  - *Por decidir antes de la F6 (D-23 punto 5):* errores estándar con BRR completo (≈ 810 ajustes) o cluster-robustos.
- [ ] **6.3 Robustez:** repetir con los PV oficiales de la OCDE (`MPEM`, `MPFS`, `MPIN`, `MPRE`).
- [ ] **6.4 Igualdad de efectos** entre competencias (prueba de Wald o modelo restringido vs libre). Contrastar con el
  resultado exploratorio: interpretar − emplear = 3,9 (z = 2,61, PV OCDE) → H5. Si la G2 elige 2 dimensiones, H5 y H6
  se deciden con el factor económico y el de libros es secundario (D-22).
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
