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

> D-01 a D-10 corresponden a la etapa con Saber 11 (archivo). Desde D-11, proyecto con PISA 2022.

---

### D-11 · 2026-10-01 · Cambio de fuente: de Saber 11 2025-2 a PISA 2022 Colombia
- **Alternativas:** (a) seguir con Saber 11 y desenlace = puntaje total de matemáticas; (b) PISA 2025;
  (c) mixto Saber 11 + PISA; (d) PISA 2022.
- **Razón:** Saber 11 no publica resultados por competencias ni respuestas por ítem; PISA 2022 trae las 4 subescalas
  de proceso, respuestas y tiempos por ítem, cuestionario de NSE y diseño muestral documentado. PISA 2025 no sirve
  (matemáticas es dominio menor, sin subescalas). El mixto no cabe en 8 semanas.
- **Consecuencias:** D-01 queda reemplazada (la TRI se hace sobre posesiones del hogar y sobre los ítems de
  matemáticas); D-03 a D-10 quedan como archivo. Objetivos en [[06 Objetivos PISA 2022]].
- **Estado:** ✅ aceptada por el equipo.

### D-12 · 2026-10-01 · Esquema de gestión de la información
- **Alternativas:** solo Obsidian; RAG desde el inicio; NotebookLM; Zotero + Obsidian + RAG propio al final.
- **Razón:** cada herramienta un papel — Zotero (fuentes y `.bib`), Obsidian (notas y decisiones, con ZotLit y
  Git (Vinzent03)), RAG propio en la fase 8 como parte de la API. NotebookLM solo como apoyo, no reproducible.
- **Detalle:** [[10 Gestión de la información]]. Amplía D-02.
- **Estado:** ✅ aceptada.

### D-13 · 2026-10-01 · Modelo de lenguaje para el RAG
- **Alternativas:** Ollama local (gratis, calidad limitada con 7,6 GB de RAM); Claude Haiku 4.5 (≈ US$2 por 300
  consultas); Claude Sonnet 5.5 (≈ US$4); Claude Opus 5.5 (≈ US$8). La API se paga aparte del plan Pro.
- **Estado:** pendiente — se decide en la fase 8.

### D-16 · 2026-10-04 · Calificar por competencias con TRI multidimensional propio, validado contra la OCDE
- **Alternativas:** (a) usar solo los valores plausibles por competencia de la OCDE; (b) solo puntajes propios;
  (c) puntajes propios con MIRT de 4 competencias + validación contra los PV de la OCDE.
- **Razón:** el objetivo del proyecto es calificar por competencias; (c) aporta la parte de TRI (calibración propia) y
  la validez convergente con la medida oficial. Es viable: 233 de 234 ítems están clasificados por competencia
  en el anexo A del Technical Report 2022 (emplear 75, interpretar 57, razonar 53, formular 48), coherente con el
  anexo de 2025 en los 177 ítems comunes.
- **Consecuencias:** O3 pasa a ser "calificar por competencias y verificar su equidad"; O4 usa esos puntajes (PV OCDE
  como robustez); nuevas hipótesis H7 (validez) y H8 (multidimensionalidad).
- **Estado:** ✅ aceptada por el equipo (2026-10-04).

### D-17 · 2026-10-04 · Reorganización de la carpeta por etapas y anteproyecto vigente en PISA 2022
- **Qué se hizo:** `Etapa1_Saber11/` (archivo: `Primer Corte/` y `Proyecto/` movidos sin cambios) y `Proyecto_PISA/`
  (anteproyecto, datos, documentación, scripts, salidas, informe, api). El vault queda en la raíz.
- **Anteproyecto:** el documento vigente pasa a ser la versión PISA 2022 en `Proyecto_PISA/anteproyecto/`
  (reemplaza al de Saber 11). La versión entregada en el primer corte no se borró: queda como archivo en
  `Etapa1_Saber11/Primer Corte/`.
- **Estado:** ✅ aceptada por el equipo (2026-10-04).

### D-15 · 2026-10-01 · Sin RAG para gestionar la información; vault como fuente de verdad
- **Alternativas:** (a) RAG como base de la gestión de la información; (b) Obsidian como fuente de verdad, con
  protocolo de verificación, y Claude leyendo el vault directamente.
- **Razón:** con ~27 fuentes y decenas de notas, un RAG no aporta para organizar ni para evitar errores; lo que los
  evita es que cada afirmación tenga origen y estado ([[11 Protocolo de verificación]], `CLAUDE.md`). El RAG queda
  solo como posible producto del curso de Python (O5), si el profesor lo pide.
- **Pendiente:** confirmar con el profesor de Python si el RAG es requisito del curso.
- **Estado:** ✅ aceptada por el equipo (2026-10-01), salvo la confirmación con el profesor.

### D-14 · 2026-10-01 · Tratamiento de las respuestas omitidas en O3
- **Alternativas:** (a) omitida = incorrecta (criterio OCDE); (b) omisión rápida (NT10) = faltante; (c) ambas, como
  análisis de sensibilidad.
- **Propuesta:** (c) — es la base de H4.
- **Estado:** pendiente — se fija en F5, tras separar omitido / no alcanzado / no administrado (paso 1.2).

---

### D-01 · 2026-09-24 · Hacer TRI sobre los ítems del cuestionario socioeconómico
- **Alternativas:** (a) TRI sobre la prueba de matemáticas → imposible sin respuestas por ítem;
  (b) simular datos → descartado en el anteproyecto; (c) TRI sobre el cuestionario.
- **Razón:** son ítems reales, con formatos variados (2PL, GRM, nominal), y es exactamente lo
  que hace el ICFES para el INSE. Recupera el componente TRI y permite DIF por sexo/zona.
- **Estado:** ⏸ **pendiente de confirmar con el profesor de TRI** (paso 0.4). Bloquea fases 2–3.

### D-02 · 2026-09-24 · Gestión de la información: Obsidian ahora, RAG en la fase 7
- **Alternativas:** (a) solo Obsidian; (b) RAG desde el inicio; (c) Obsidian ahora + RAG después.
- **Razón:** con ~15 fuentes, un RAG no ayuda a *organizar*; Obsidian sí. El vault en Markdown
  será después el corpus del RAG, como módulo de la API del curso de Python.
- **Estado:** ✅ aceptada.

### D-03 · Motocicleta sale del modelo de medida
- **Razón:** carga 0,12; distribución ~50/50 sin relación con los demás bienes.
- **Estado:** ✅ aceptada (anteproyecto).

### D-04 · Manejo de faltantes con WLSMV
- **Alternativas:** `missing = "pairwise"` / imputación múltiple / MLR con FIML tratando ordinales como continuos.
- **Estado:** pendiente (fase 4).

### D-05 · Identificación del componente específico de matemáticas
- **Propuesta:** fijar varianza de error con la confiabilidad publicada por el ICFES.
- **Estado:** pendiente — buscar la cifra en el informe técnico.

### D-06 · Jornadas NOCHE y SABATINA (40.229 en la muestra analítica, educación de adultos)
- **Alternativas:** excluir / incluir con control / análisis de sensibilidad con y sin.
- **Estado:** pendiente. La bandera `jornada_adultos` ya está en la base.

### D-07 · 2026-09-24 · Git + GitHub privado para compartir
- **Razón:** historial de cambios, sin conflictos silenciosos; el crudo y los `.rds` quedan fuera (`.gitignore`).
- **Estado:** ✅ aceptada. Repositorio privado `Proyecto-Final-PISA` creado el 2026-10-04 (raíz: carpeta CONSULTORIA,
  incluye el vault y el proyecto; los datos quedan fuera). Flujo de trabajo en `README.md`.

### D-08 · 2026-09-24 · Ocupación de los padres → prestigio ordinal + máximo de los dos padres
- **Regla:** 1 agricultor/limpieza · 2 operario/vendedor/cuenta propia · 3 auxiliar/negocio pequeño ·
  4 profesional · 5 directivo/negocio grande. Hogar, pensionado, no sabe y no aplica quedan NA.
- **Problema detectado:** con esa regla, `ocup_madre` queda con 42,9 % NA (sobre todo "trabaja en el hogar").
- **Propuesta:** usar `ocup_max` y `educ_max` (el mayor de los dos padres, como HISEI/HISCED en PISA):
  17,1 % y 2,7 % NA. Alternativa TRI: respuesta nominal sobre la variable original.
- **Estado:** propuesta — discutir entre los dos (y con el profesor de TRI si aplica el modelo nominal).

### D-10 · 2026-09-24 · Preguntas del cuestionario no consideradas hasta ahora
- **Hallazgo:** al armar [[Archivo Saber 11/Saber11 - Variables originales ICFES]] aparecieron `estu_tiempocasaacole`,
  `estu_desplazacolegio`, `estu_horastrabnoremu`, `estu_comunidadcampesina`, `estu_numhijos`.
- **Propuesta:** incluir las tres primeras en el AFE de la fase 2 para ver si cargan en NSE o forman
  un factor de ruralidad/acceso; las otras dos como contexto.
- **Estado:** pendiente (fase 2). También revisar `estu_repite` (valores 0 a 278.859) en el diccionario oficial.

### D-09 · 2026-09-24 · Consecutivos repetidos
- **Hallazgo:** los 2 `estu_consecutivo` repetidos corresponden a personas distintas
  (estudiante de colegio vs individual). Los individuales no tienen cuestionario, así que en la
  muestra analítica no hay duplicados.
- **Estado:** ✅ aceptada — no se elimina nada; bandera `dup_consecutivo` por trazabilidad.
