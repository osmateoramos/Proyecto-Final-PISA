# Plan paso a paso

> [!note] Archivado: corresponde a la etapa con Saber 11. El proyecto actual está en [[07 Plan de desarrollo PISA 2022]] (decisión D-11).

Volver a [[00 Inicio]] · Teoría necesaria en [[05 Mapa teoría → proyecto]]

## Cómo usar esta guía

- Las fases **no tienen semana fija**: cada una se abre cuando en clase ya vieron la teoría que
  pide (recuadro *Teoría previa*). Si todavía no la vieron, se adelanta lectura, no código.
- Cada paso tiene:
  - **Por qué** — la razón, para poder defenderlo en la sustentación
  - **Paso a paso** — acciones pequeñas, en orden
  - **Salida** — el archivo que demuestra que se hizo
  - **Listo cuando** — la condición para marcarlo `[x]`
  - **Autoevaluación** — preguntas tipo sustentación; si alguno de los dos no las responde, no está listo
- Los dos hacen **todos** los pasos (uno maneja, el otro revisa). En la sustentación el profesor
  pregunta a cada uno por la parte que *no* hizo.
- Cursos: `[TRI]` Teoría de Respuesta al Ítem · `[SEM]` Ecuaciones estructurales · `[PY]` Python/APIs · `[CONS]` Consultoría

### Estado de las fases

| Fase | Tema | Se abre cuando… | Estado |
|---|---|---|---|
| 0 | Organización (vault, Git, lecturas) | ya | en curso |
| 1 | ETL y libro de códigos | ya | script listo, falta recorrerlo |
| 2 | Dimensionalidad de los ítems | vieron AFE y correlación policórica | ⏸ confirmar D-01 con el profesor |
| 3 | TRI sobre el cuestionario | vieron 2PL y GRM | ⏸ confirmar D-01 |
| 4 | AFC del NSE y del desempeño | vieron identificación, AFC, WLSMV | pendiente |
| 5 | Modelo estructural | vieron modelo estructural y mediación | pendiente |
| 6 | Invarianza / DIF | vieron invarianza multigrupo y DIF | pendiente |
| 7 | API, tablero y RAG | curso de Python a la altura de FastAPI | pendiente |
| 8 | Informe y sustentación | fases 1–7 cerradas | pendiente |

Estructura del proyecto:

```
CONSULTORIA/                 ← raíz del repositorio Git
├── .gitignore               ← deja fuera datos crudos, .rds, .xlsx, estado de Obsidian
├── Primer Corte/            ← lo entregado; no se modifica
├── Vault_PISA2022/           ← este vault
└── Proyecto/
    ├── Proyecto.Rproj       ← abrir SIEMPRE esto en RStudio
    ├── datos/crudos/        ← (opcional) copia local del .txt — no va a Git
    ├── datos/procesados/    ← .rds generados por scripts — no va a Git
    ├── scripts/             ← 01_etl.R, 02_…, 03_…
    └── salidas/             ← tablas .csv y figuras .png — SÍ van a Git
```

---

## Fase 0 — Organización  `[CONS]`

### 0.1 Abrir el vault en Obsidian
- **Paso a paso:** Obsidian → *Open folder as vault* → `CONSULTORIA/Vault_PISA2022`.
  Ajustes → *Files and links* → activar "Use [[Wikilinks]]" y poner como carpeta de
  plantillas `Plantillas` (Ajustes → *Core plugins* → *Templates*).
- **Listo cuando:** abren [[00 Inicio]] y los enlaces llevan a las otras notas.

### 0.2 Git + GitHub privado (lo ejecutan ustedes)
- **Por qué:** los dos editan scripts y notas; Git guarda el historial y evita que un cambio
  pise al otro sin avisar. El `.gitignore` ya está creado en `CONSULTORIA/`.
- **Paso a paso (Mateo, una sola vez):**
  1. Instalar Git para Windows si no está (`git --version` en una terminal).
  2. En la terminal, dentro de `CONSULTORIA/`:
     ```bash
     git init
     git add .
     git status
     ```
     Revisar que en `git status` **no** aparezcan `Examen_Saber_11_20252.txt`, `.rds`
     ni `.xlsx`. Si aparecen, parar y revisar el `.gitignore`.
     ```bash
     git commit -m "Primer corte, vault y fase 1"
     ```
  3. En GitHub: *New repository* → nombre `saber11-nse` → **Private** → sin README.
  4. Conectar y subir (GitHub muestra los dos comandos exactos: `git remote add origin …` y `git push -u origin main`).
  5. En GitHub → *Settings → Collaborators* → invitar a Vanessa.
- **Paso a paso (Vanessa):** aceptar la invitación, `git clone <url>`, descargar el `.txt` de
  DataIcfes y guardarlo en `Proyecto/datos/crudos/` (el script lo busca ahí o en `Primer Corte/`).
- **En Obsidian (los dos):** Ajustes → *Community plugins* → instalar **Git** (autor Vinzent03; antes llamado "Obsidian Git").
  Activar "Pull on startup" y dejar el commit/push manual al principio.
- **Regla de trabajo:** `git pull` antes de empezar, `git add`/`commit`/`push` al terminar.
  Mensajes de commit que digan qué cambió ("Fase 1: ocupación a prestigio").
- **Listo cuando:** un cambio que hace uno aparece en el equipo del otro después de un `pull`.
- **Autoevaluación:** ¿Por qué el archivo de datos no se sube a GitHub? (tamaño y Ley 1581 de 2012: datos de menores).

### 0.3 Notas de lectura (una por referencia)
- **Por qué:** en la sustentación preguntan de dónde sale cada argumento. Esto también será
  el material del RAG en la fase 7.
- **Paso a paso:** en `Literatura/`, crear una nota por clave de `referencias.bib` con la
  plantilla *Nota de lectura*. Orden sugerido:
  1. `icfes2019inse` — cómo se construye el INSE (es la base de las fases 2–3)
  2. `rolfe2021tailoring` — AFC + invarianza del NSE (fases 4 y 6)
  3. `eriksson2021socioeconomic` — dimensiones del NSE; la ocupación importa
  4. `hernandez2011modelo` — capital cultural vs económico con SEM
  5. `patsis2026instructional` — SEM de dos niveles en matemáticas
  6. el resto
- **Listo cuando:** cada nota tiene "qué hace", "método", "resultado con cifra" y "qué usamos nosotros".

### 0.4 Pregunta al profesor de TRI
- Llevar la tabla de [[02 Clasificación de ítems (TRI)]] y hacer la pregunta del recuadro.
- Registrar la respuesta en `Reuniones/AAAA-MM-DD TRI.md` y actualizar D-01 en [[03 Registro de decisiones]].
- **Esto desbloquea las fases 2 y 3.**

---

## Fase 1 — ETL y libro de códigos  `[CONS]`

> [!info] Teoría previa
> Ninguna específica. Conviene repasar: tipos de variable (nominal/ordinal), y por qué
> "No sabe" no es el nivel más bajo de una escala.

Script: `Proyecto/scripts/01_etl.R` (ya escrito y probado). **Tarea:** recorrerlo bloque a
bloque en RStudio, entender cada decisión y ajustar lo que no compartan.

### 1.1 Muestra analítica
- **Por qué:** sin cuestionario no hay indicadores del NSE. Quedan 495.807 de 576.213.
  Los excluidos sacan 48,88 en matemáticas frente a 52,56 → la exclusión **no es aleatoria**.
- **Listo cuando:** saben explicar qué población describen los resultados (la que respondió el cuestionario, no todos los evaluados).

### 1.2 Duplicados
- **Resultado:** los 2 consecutivos repetidos son **personas distintas** (un estudiante de colegio
  y un "individual", con distinto sexo y puntaje). Solo los de colegio quedan en la muestra
  analítica, así que ahí no hay duplicados. Registrado como D-09.

### 1.3 Recodificación
Revisen en la salida las tablas cruzadas "original → nueva". Cada regla está en el libro de códigos.
- **Educación:** 12 → 6 niveles; "No sabe"/"No Aplica" → NA.
- **Estrato:** "Sin Estrato" → NA.
- **Bienes:** Sí/No → 1/0.
- **Hacinamiento:** personas / cuartos.
- **Alimentación:** frecuencia 1–4.
- **Ocupación:** prestigio 1–5 (D-08, propuesta).
- **Máximo de los dos padres:** `educ_max` y `ocup_max`, como en PISA. Recupera faltantes:
  `ocup_madre` pierde 42,9 %, `ocup_max` 17,1 %.
- **Grupos:** sexo, sector, zona (URBANA + URBANO unificadas).
- **Bandera** `jornada_adultos` (40.229 casos en la muestra analítica).
- **Autoevaluación:**
  - ¿Por qué "Trabaja en el hogar" quedó como NA y qué problema trae eso?
  - ¿Por qué el hacinamiento es mejor indicador que el número de personas por sí solo?

### 1.4–1.5 Guardar y libro de códigos
- **Salida:** `datos/procesados/saber11_analitica.rds` (no va a Git), `salidas/diccionario.csv`
  (sí va a Git) y la nota [[Archivo Saber 11/Saber11 - Diccionario de variables recodificadas]].

### 1.6 Contraste con el anteproyecto
- **OK:** 495.807; NSE 1 = 47,22; NSE 4 = 61,81; correlación matemáticas–lectura 0,757 (el documento dice 0,760).
- **REVISAR:** medias por sector. El documento dice 56,15 / 51,03; la muestra analítica da 56,52 / 51,37
  y el archivo completo 56,01 / 50,98. Nadie reproduce la cifra del documento → buscar el filtro que se usó o corregirla.
- **Faltantes reales en la muestra analítica:** entre 1,4 % y 11,0 % por indicador (el 11 % es
  "No sabe" en la educación del padre); 73,5 % de casos completos en los 12 indicadores.
- **Listo cuando:** el script corre completo sin errores y ambos entienden cada línea `OK`/`REVISAR`.

---

## Fase 2 — Dimensionalidad de los ítems  `[TRI]` `[SEM]`  ⏸ D-01

> [!info] Teoría previa
> Correlación policórica/tetracórica · análisis factorial exploratorio · análisis paralelo ·
> unidimensionalidad como supuesto de la TRI.

Script: `scripts/02_dimensionalidad.R`

1. **Dividir la muestra** en dos mitades con semilla fija (`set.seed(2026)`): *exploración* y
   *confirmación*. **Por qué:** si el modelo se diseña y se evalúa con los mismos datos, el
   ajuste queda inflado.
2. **Submuestra de 20.000** de la mitad de exploración. **Por qué:** las policóricas con 250 mil
   casos son lentas y no cambian el resultado.
3. **Matriz policórica** (`psych::polychoric`) con los ítems de los grupos A–E de
   [[02 Clasificación de ítems (TRI)]].
4. **Análisis paralelo** (`psych::fa.parallel(..., cor = "poly")`) → cuántos factores.
5. **AFE con 1, 2, 3 y 4 factores** (`psych::fa(..., rotate = "oblimin", fm = "wls")`): ¿los ítems
   se agrupan como los grupos de contenido A–E?
6. **Por cada grupo:** 1er autovalor mucho mayor que el 2º y cargas > 0,30.
7. **Decidir** el número de dimensiones y los ítems que salen → registro.
- **Salida:** `salidas/afe_cargas.csv`, `salidas/paralelo.png`.
- **Autoevaluación:** ¿Por qué correlación policórica y no Pearson? ¿Qué pasa si se ajusta
  TRI unidimensional a ítems que miden dos cosas?

## Fase 3 — TRI sobre el cuestionario  `[TRI]`  ⏸ D-01

> [!info] Teoría previa
> 2PL (discriminación *a*, dificultad/umbral *b*) · modelo de respuesta graduada ·
> curva característica · función de información · ajuste de ítems.

Script: `scripts/03_tri.R` · paquete `mirt`

1. **Un modelo por grupo:** 2PL para bienes, GRM para cultural y vivienda (`itemtype` por columna si el grupo es mixto).
2. **Tabla de parámetros:** `coef(m, IRTpars = TRUE, simplify = TRUE)`. Interpretar *b* como "nivel de
   NSE en el que tener el bien pasa a ser más probable que no tenerlo".
3. **Ajuste:** `M2()` y `itemfit()`, más dependencia local con `residuals(m, type = "LD")`.
4. **Gráficos:** curvas características y de información. ¿En qué rango de NSE mide bien la escala?
5. **Unidimensional vs multidimensional:** `anova(m1, m2)`. Esta es la versión TRI del objetivo 1.
6. **Puntajes EAP** y su correlación con `estu_inse_individual`.
7. **DIF por sexo y zona:** `multipleGroup()` + `DIF()`. Hipótesis: la consola tiene DIF por sexo.
   Reportar tamaño de efecto, no solo el valor p.
- **Autoevaluación:** ¿Qué significa que un ítem tenga *a* alto y *b* alto? ¿Qué significa
  que la consola tenga DIF por sexo, en palabras de un periodista?

## Fase 4 — AFC del NSE y del desempeño  `[SEM]`

> [!info] Teoría previa
> Identificación · AFC · estimador WLSMV para ordinales · índices CFI/TLI/RMSEA/SRMR ·
> confiabilidad compuesta.

Script: `scripts/04_afc.R` · `lavaan`, `semTools` · **mitad de confirmación**

1. **AFC del NSE** con la estructura de la fase 2: `estimator = "WLSMV"`, `ordered = ...`,
   `missing = "pairwise"` (D-04).
2. **Comparar 1 vs 2+ factores:** `lavTestLRT()`.
3. **Reportar:** cargas estandarizadas, `semTools::compRelSEM()` e índices de ajuste. Con n
   grande el χ² siempre rechaza: explicarlo.
4. **AFC del desempeño:** factor *g* con las 5 áreas. Resolver D-05 (factor específico con un
   solo indicador: fijar la varianza de error con la confiabilidad del ICFES).
5. **Errores estándar agrupados por sede** (`cluster = "cole_cod_dane_sede"`).
- **Autoevaluación:** ¿Por qué WLSMV y no máxima verosimilitud? ¿Por qué un factor con un solo
  indicador no está identificado?

## Fase 5 — Modelo estructural  `[SEM]`

> [!info] Teoría previa
> Modelo estructural · efectos directos, indirectos y totales · mediación.

1. **Dibujar el diagrama** en `Datos/Modelo.md` antes de programar.
2. **Justificar cada flecha.** Zona: ¿antecedente o mediador? Mediadores del estudiante:
   lectura diaria, horas de trabajo.
3. **Estimar** con `:=` para los efectos indirectos.
4. **Opcional:** dos niveles (estudiante / colegio).

## Fase 6 — Invarianza multigrupo  `[SEM]` `[TRI]`

> [!info] Teoría previa
> Invarianza configural, métrica y escalar · invarianza parcial · relación entre invarianza y DIF.

1. **Modelos anidados** con `semTools::measEq.syntax()` por sexo, sector y zona.
2. **Criterios:** ΔCFI ≤ 0,01 y ΔRMSEA ≤ 0,015.
3. **Contrastar** los ítems no invariantes con el DIF de la fase 3.7.

## Fase 7 — API, tablero y RAG  `[PY]`

1. **Exportar** los resultados a `salidas/*.csv`: la API solo lee, no estima.
2. **FastAPI** con endpoints `/parametros-tri/{grupo}`, `/invarianza/{variable}`, `/dif` y `/docs`.
3. **Tablero** (Streamlit o HTML) que consuma la API.
4. **RAG (D-02):** indexar el vault (notas de lectura y decisiones) y los PDF del ICFES; un endpoint
   `/preguntar` que responda citando la nota de origen. El vault ya es el corpus.

## Fase 8 — Informe y sustentación
1. **Trazabilidad:** cada cifra del informe apunta a un script y a una salida.
2. **Ensayo cruzado:** cada uno expone la parte que no hizo; el otro pregunta con las autoevaluaciones de esta guía.
