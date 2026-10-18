---
tipo: guia
estado: por_verificar
lectura: "redactado por Claude con Brayan; falta revisión del equipo"
pendientes: "Equipo: aceptar o ajustar las propuestas de las secciones 2, 3.2 y 4. Brayan: revisar y asumir la revisión del PR #12 (sección 6) y decidir las firmas (sección 7)"
verificado_por:
fecha_verificacion:
---

# Plan de trabajo — Brayan

Volver a [[00 Inicio]] · Plan general en [[07 Plan de desarrollo PISA 2022]] · Protocolo en [[11 Protocolo de verificación]]
Decisiones en [[03 Registro de decisiones]] · Actividad: `Proyecto_PISA/documentacion/Enunciado_Nada_sin_fuente.html`

Qué le toca a Brayan **sin repetir** lo que ya hicieron Mateo (rama `main`) y Vanessa (rama `Vanessa`).
Este trabajo vive en la rama `Brayan` y llega a `main` por Pull Request.

**Reparto propuesto** (ver [[00 Inicio]]): Brayan es responsable de O4–O5 (modelo estructural, API y tablero) y
revisa O1–O2.

## 1. "Nada sin fuente": lo individual (no se delega)

- [ ] **Inventario de fallos** (½ página, firmado):
  - al menos 3 fallos propios con la plantilla del enunciado;
  - los fallos los aporta Brayan, de su propia experiencia; la IA solo les da formato.
- [ ] **Consulta bibliográfica propia, zona O4.**
  - Propuesta: *"SEM con valores plausibles y pesos muestrales en PISA: efecto del NSE en el desempeño por
    competencia"*.
  - No coincide con la de Vanessa (zona O3) ni con la que corresponde a Mateo (O1–O2).
  - Se corre en los tres tratamientos: A (chat sin fuentes), B (buscador conectado a bases reales) y C (contexto
    cerrado con PDF).
  - Al menos 5 referencias por tratamiento.
  - De cada corrida se guardan el prompt, la respuesta completa, la fecha y la herramienta (con su versión).
- [ ] **Clasificación ciega** de las referencias de los tres integrantes:
  - categorías: utilizable / existe pero no dice eso / no existe;
  - cada quien escribe en su propio archivo (por ejemplo `clasificacion_Brayan.csv`);
  - Brayan **no lee la tabla de clasificación de `16 Experimento Nada sin fuente`** (rama `Vanessa`) antes de
    terminar la suya;
  - el cruce se hace al final, con los tres archivos completos.
- [ ] **Filas propias en la bitácora de IA** (`15 Bitácora de uso de IA`, rama `Vanessa`), cuando esa nota llegue a
  `main`. Mientras tanto se anotan en la sección 4 de esta nota.

## 2. "Nada sin fuente": piezas de equipo que nadie ha tomado (propuesta, por acordar)

- [ ] **Análisis del experimento:** un script reproducible (por ejemplo `Proyecto_PISA/scripts/nsf_experimento.R`)
  que:
  - lea los archivos de clasificación;
  - calcule la proporción de referencias utilizables por tratamiento con su intervalo de confianza (Wilson,
    adecuado para n ≈ 15);
  - cuente en cuántas referencias no coincidieron los clasificadores (opcional: kappa de Fleiss);
  - guarde las tablas en `Proyecto_PISA/salidas/`.

  Alimenta el criterio C1.
- [ ] **Implementación del sistema de fuentes (C3)**, ligada al paso 8.5 del plan (RAG):
  - proponer **D-10** en [[03 Registro de decisiones]], porque la actividad pide un sistema de contexto cerrado
    y D-06 lo había descartado; además, D-04 (modelo del RAG) sigue pendiente;
  - si el equipo elige la vía propia: Ollama + modelo de embeddings + Chroma, comparando `bge-m3` contra
    `multilingual-e5` sobre preguntas propias, como pide el enunciado;
  - límite conocido: el equipo de Brayan tiene 7,8 GB de RAM, así que solo caben modelos pequeños cuantizados.
- [ ] **Parte del banco de evaluación:**
  - preguntas con respuesta conocida y localizada (documento y página) sobre las fuentes de la sección 3.2;
  - al menos 3 preguntas cuya respuesta **no** esté en el corpus.
- [ ] **Parte de la tabla de trazabilidad:** sale de la verificación de la sección 3.2.

## 3. Proyecto PISA (plan 07)

### 3.1 F0 — pendientes de Brayan

- [x] Instalar Zotero: 10.0.6 con `winget`, hash verificado (2026-10-12). Mateo tiene la 10.0.5.
- [ ] Crear la cuenta de Zotero, iniciar sesión y aceptar la invitación al grupo (ver [[12 Guía de Zotero]]).
- [ ] Instalar en Zotero **Better BibTeX** y **ZotLit Companion**, y en el navegador el **Zotero Connector**.
- [x] Instalar Obsidian: 1.14.4 con `winget`, hash verificado (2026-10-12).
- [ ] Abrir `Vault_PISA2022` como vault y activar los complementos de la comunidad.
- [x] Clonar el repositorio (2026-10-12, rama `Brayan`).
- [ ] Hacer los pasos de *Primera vez* del `README.md`: descargar PISA 2022 y correr
  `revision_pisa2022_col.R`.
  - Los `.SAV` y los `.rds` quedan fuera de Git.
  - Si el repositorio está dentro de OneDrive, OneDrive sí los sube a la nube: conviene excluir
    `Proyecto_PISA/datos/` de la sincronización.
  - 2026-10-18: los tres `.SAV` ya están en `Proyecto_PISA/datos/`. Se bajaron los zips SPSS de
    `webfs.oecd.org/pisa2022/` y se comprobaron:
    - el tamaño de cada zip es igual al que anuncia el servidor;
    - los tres pasan `unzip -t` (CRC);
    - cada `.SAV` extraído pesa lo mismo que indica su zip: `STU_COG` 3.733.772.526 bytes, `STU_QQQ`
      2.096.666.903 y `SCH_QQQ` 19.704.342.

    Git los ignora (`.gitignore`, `*.sav`), pero OneDrive sí los sincroniza.
  - 2026-10-18, **la cadena de `main` se reproduce en este equipo.** Corrieron sin errores y en este orden
    `revision_pisa2022_col.R`, `01a_etl_cognitivo.R`, `01a_explorar_faltantes_cog.R`, `01b`, `01c`, `02`,
    `03_explorar_items_nse.R` y `03_nse_medicion.R` (unos 13 minutos).
    - Volvieron a escribir 12 archivos de `salidas/`, y `git status` no muestra ningún cambio: son iguales a los de
      `main`.
    - `01b` también reescribe [[Datos/PISA2022 - Variables recodificadas]]. Solo cambió la fecha (2026-10-16 →
      2026-10-18) y se devolvió a la versión del repositorio. En la primera comparación Claude miró solo
      `Proyecto_PISA/` y no la vio.
    - La Puerta G1 pasa: 382,70 (EE 3,03), 78,56 (EE 5,74) y 16,16 % (EE 2,09).
    - No se regeneraron los `nsf_*.csv` ni `diccionario_pisa2022.csv`, porque no son parte de esta cadena.
- [x] Instalar el entorno de D-17 (2026-10-18).
  - `--instalar` no pudo bajar `pbivnorm`, una dependencia de `lavaan`, por un fallo de DNS; se instaló aparte
    desde la misma copia de Posit del 2026-10-17.
  - `00_verificar_entorno.R` decía «Al día» aunque `lavaan` no cargaba: compara versiones, no dependencias (límite
    ya anotado en D-17).
  - Ahora R 4.4.1 y los 13 paquetes coinciden y los 13 cargan. Quedan avisos de que `mirt` y `lattice` se
    compilaron con R 4.4.3.

### 3.2 Verificación de fuentes (propuesta de tercio, acorde a O4)

Empezar por las que tienen **[VERIFICAR]** en el anteproyecto. Solo Brayan marca `verificado`, con nombre y fecha,
siguiendo [[11 Protocolo de verificación]].

- **Bloque A** (descriptivo y enfoque econométrico):
  - [[Literatura/guerra2026digital]]
  - [[Literatura/icfes2024pisa]]
  - [[Literatura/oecd2023fichacolombia]]
  - [[Literatura/rodriguez2024rural]] — tiene [VERIFICAR] y la inconsistencia del "40 %" anotada en
    [[13 Revisión de literatura]]
  - [[Literatura/collazos2021determinantes]]
  - [[Literatura/lee2024decada]]
  - [[Literatura/zabala2019impacto]]
- **Bloque M** (métodos de SEM):
  - [[Literatura/chen2024structural]]
  - [[Literatura/rosseel2012lavaan]]
  - [[Literatura/rubin1987multiple]]
  - [[Literatura/chen2007sensitivity]]
  - [[Literatura/wu2016identification]]
- **Datos:** [[Literatura/oecd2023pisadb]]

### 3.3 Revisión cruzada de O1–O2

- [ ] Revisar `03_nse_medicion.R` y `04_invarianza.R` de Mateo cuando existan.
  - El 3.1–3.3 y el 3.5 los hizo Vanessa (PR #12). Borrador de revisión en la sección 6; `04_invarianza.R` aún no
    existe.

### 3.4 Responsable de F6 (SEM) y F8 (API, tablero y RAG)

No se adelantan fases (regla de `CLAUDE.md`). Al llegar a F6:
- leer Chen y Yung, caps. 8 y 11 ([[14 Libros de TRI y SEM]]);
- resolver si `lavaan` acepta pesos con WLSMV (paso 6.2 del plan).

Lo que ya dejó registrado la F3 para la F6 (2026-10-18; solo se anota, no se adelanta la fase):
- **Pesos con WLSMV:** `lavaan` 0.7-3 acepta `ordered`, `sampling.weights` y `missing = "pairwise"` (D-18, prueba
  con datos simulados) y da `cfi.robust` (observación 15).
  - Con restricciones de igualdad no da las versiones *robust* (D-25). Afecta la prueba de igualdad de efectos del
    paso 6.4.
- **NSE de la F6:** el modelo de 2 dimensiones del AFE (D-24). H5 y H6 se deciden con el factor económico (D-22).
- **Por decidir antes de la F6** (D-23, propuesta):
  - punto 1: generar los PV propios con regresión latente sobre el NSE. Si no, su efecto saldría atenuado; esa
    interpretación no tiene fuente todavía;
  - punto 5: errores estándar. Un BRR completo son unos 810 ajustes (10 PV × 81 pesos).
- **Paquetes:** `lavaan.mi` (paso 6.2) no está en `versiones_paquetes.csv` (D-17).

## 4. Observaciones para Mateo y Vanessa (solo propuestas)

Revisión del repositorio del 2026-10-12. Nada de esto se corrigió desde esta rama: cada punto lo decide el equipo.

1. **Riesgo para el criterio C2 de "Nada sin fuente":**
   - las 43 notas de `Literatura/` siguen `por_verificar`;
   - el anteproyecto tiene 15 marcas [VERIFICAR];
   - la regla 1 de la actividad deja C2 en Insuficiente si una fila de trazabilidad no se sostiene.

   Propuesta: repartir ya la verificación (sección 3.2 para Brayan).
2. **Hipótesis congeladas** (`09 Hipótesis preregistradas`, rama `Vanessa`):
   - [[14 Libros de TRI y SEM]] (P4) recomendaba fijar el umbral de "efecto no despreciable" del DIF antes de
     congelar; H2 y H3 usan esa expresión sin definirla;
   - P1–P7 siguen sin aprobarse;
   - la nota se contradice: dice congelada el 2026-10-12, pero el `pendientes` del frontmatter y la nota sobre
     H7–H8 dicen que el congelamiento sigue pendiente, y el campo del commit quedó vacío;
   - el paso 0.5 no está marcado en [[07 Plan de desarrollo PISA 2022]].

   Como aún no se ha estimado ningún modelo, un ajuste registrado ahora sigue siendo legítimo.
3. **Cifras sin archivo de salida:** `Proyecto_PISA/datos/revision_pisa2022_col.R` solo imprime en consola. Cifras
   citadas en [[06 Objetivos PISA 2022]] (3,9 puntos con z = 2,61; 175 ítems; 7.459 estudiantes con ESCS) no tienen
   archivo en `salidas/`. Eso choca con la regla 2 del `README.md`.
4. **Calendario:** según [[07 Plan de desarrollo PISA 2022]], la semana 2 (12–18 oct) es de F2 y puerta G1, pero F1
   no ha empezado (`scripts/` está vacío). [[00 Inicio]] todavía dice "semana 1".
5. **D-06 frente a la actividad:**
   - D-06 y la declaración de uso de IA del anteproyecto dicen que se descartó un RAG, pero "Nada sin fuente" exige
     un sistema de contexto cerrado;
   - [[10 Gestión de la información]] dice que NotebookLM es "no para citar".

   Hace falta una decisión nueva (D-10, sección 2).
6. **Flujo de Git:** el `README.md` dice "Commit to main", pero ya se trabaja en ramas. Propuesta:
   - cada rama llega a `main` por Pull Request revisado por otro integrante;
   - acordar cómo numerar las notas nuevas para que no choquen (esta nota es la 17 porque la 16 ya existe en la
     rama `Vanessa`).
7. **Independencia del experimento:** la clasificación de Vanessa está visible en la nota 16, en el repositorio
   compartido. Propuesta: cada integrante clasifica en su propio archivo, sin mirar los de los demás, y el cruce se
   hace al final.
8. **Menores:**
   - el reparto sigue "por confirmar" en [[00 Inicio]] y en el anteproyecto;
   - el nombre del archivo del anteproyecto no incluye a Brayan;
   - en Zotero faltan las 12 referencias de `importar_zotero_2026-10-05.bib` y adjuntar los PDF (pendientes de
     [[13 Revisión de literatura]] y del plan 07);
   - las notas 15 y 16 citan `Rubrica_Segundo_Corte.txt`, que no está en el repositorio. El enunciado ya quedó en
     `Proyecto_PISA/documentacion/`.

## 5. Sesiones de IA por pasar a la bitácora

**Trasladadas el 2026-10-13** a [[15 Bitácora de uso de IA]], junto con las demás sesiones de Brayan. Se dejan aquí
como registro.

| Fecha | Integrante | Para qué se usó la IA | Qué generó exactamente | Qué se corrigió / ajustó | Estado |
|---|---|---|---|---|---|
| 2026-10-12 | Brayan | Revisar el estado del repositorio (ramas `main` y `Vanessa`) y armar el plan de trabajo de Brayan sin repetir lo hecho | Esta nota (borrador) y la copia del enunciado en `documentacion/` | Claude iba a numerar esta nota como 16; al volver a consultar el repositorio vio que Vanessa ya había creado la 16 y la cambió a 17 | borrador, sin confirmar |
| 2026-10-12 | Brayan | Plan de equipo para entregar "Nada sin fuente" en una noche y estructura de trabajo en paralelo | `Proyecto_PISA/nada_sin_fuente/` (README, plantillas, esqueletos de memoria y experimento) y los scripts `nsf_*.R`, probados con datos simulados fuera del repositorio | En las pruebas aparecieron y se corrigieron: CSV de Excel en ANSI que quedaban con codificación mezclada; tablas que no cabían en el PDF; símbolo ≈ sin glifo. Las hojas de trazabilidad salen del anteproyecto con una pista del vault que **no** es evidencia | borrador, sin confirmar |

**Por trasladar** a [[15 Bitácora de uso de IA]] cuando se fusione el PR #12. La rama `Vanessa` agrega filas al final
de esa tabla y las dos ediciones chocarían.

| Fecha | Integrante | Para qué se usó la IA | Qué generó exactamente | Qué se corrigió / ajustó | Estado |
|---|---|---|---|---|---|
| 2026-10-18 | Brayan | Revisar el estado del proyecto, traer `main` a la rama `Brayan` y revisar el PR #12 (F3: 3.2, 3.3 y 3.5; D-19 y D-20) | Claude (Claude Code, Claude Opus 5.5) leyó el vault, las ramas y el PR por la API pública de GitHub. Guardó con `stash` los cambios de formato que hizo Obsidian y fusionó `origin/main` en `Brayan` sin conflictos (sin `push`). Corrió `00_verificar_entorno.R` sin `--instalar`. Leyó los tres scripts del PR y comprobó sus cifras contra las salidas. Redactó las secciones 6 y 7 de esta nota | No se volvió a correr ningún script del PR: no hay datos de PISA en este equipo | borrador, sin confirmar |
| 2026-10-18 | Brayan | Conseguir los datos de PISA 2022 e instalar el entorno de D-17 | Claude vio que el zip que tenía Brayan (`STU_COG_SAS.zip`) era solo el cognitivo, en SAS. Con permiso de Brayan bajó los tres zips SPSS de la OCDE, los comprobó (tamaño, CRC y tamaño extraído) y los extrajo en `datos/`. Corrió `00_verificar_entorno.R --instalar` e instaló aparte `pbivnorm` | La verificación de D-17 decía «Al día» con `lavaan` sin cargar; se detectó al cargar cada paquete. Dos comandos de prueba de Claude fallaron (un `-e` partido por los espacios y un `.R` guardado con BOM) y se rehicieron | borrador, sin confirmar |
| 2026-10-18 | Brayan | Reproducir la cadena de `main` con los datos nuevos y revisar el plan 07 | Claude corrió los 8 scripts de la cadena y comparó las salidas con `git status` (sin cambios). Cruzó el plan 07 con los scripts, el registro y las salidas, y agregó las observaciones 7 a 9 a la sección 6 | Al principio Claude había revisado el plan 07 en la versión vieja de la rama, de antes de traer `main`; lo dijo y lo volvió a revisar en la versión vigente | borrador, sin confirmar |
| 2026-10-18 | Brayan | Reproducir el PR #12 con datos | Claude exportó la rama `Vanessa` a una copia aparte (fuera del proyecto y de OneDrive), corrió `03_nse_medicion.R` y `03_nse_tri.R` y comparó las 16 salidas con un script propio: 13 son idénticas y 3 difieren en 0,001 o menos (sección 6.3) | Ninguna | borrador, sin confirmar |
| 2026-10-18 | Brayan | Revisar los 14 commits nuevos del PR #12 (hasta `152691a`) | Claude leyó los scripts nuevos o cambiados, D-18 y D-21 a D-25, D-10, el acta de la G2 y las salidas del AFC. Comprobó cada observación de la 1 a la 10, simuló la fusión con `git merge-tree` y redactó las secciones 6.4 y 6.5 y las filas nuevas de la sección 7 | Claude declara un error propio (observación 11): reportó como reproducidas sin problema unas cargas 2D que valían 0 por un fallo de `mirt`; lo había encontrado Vanessa | borrador, sin confirmar |

## 6. Revisión del PR #12 (rama `Vanessa` → `main`): borrador para Brayan

> [!info] Alcance de esta revisión
> - **Secciones 6.1 a 6.3:** el PR hasta el commit `4159ca4` (3.2, 3.3 y 3.5; D-19 y D-20), incluida la
>   reproducción con datos.
> - **Secciones 6.4 y 6.5:** los 14 commits que Vanessa subió el 2026-10-18, de las 13:44 a las 16:15 (hasta
>   `152691a`): el 3.3b con Q3 (D-21), el 3.4 y H1 (D-18), la Puerta G2 (D-24), la F4 (D-25), `00_correr_todo.R`, la
>   corrección de las cargas 2D, D-22, D-23 y la posición de Vanessa en D-10.
>   - Revisión estática: los scripts nuevos o cambiados de esos commits (`03_nse_tri.R` y `03_nse_afc.R`) no se
>     volvieron a correr en este equipo.
> - **Números de decisión:** D-21 a D-25 ya están usados; el siguiente libre es D-26.
> - **Fusión:** `git merge-tree` entre `origin/Brayan` (`3afe333`) y `origin/Vanessa` (`152691a`) no da conflictos,
>   tampoco en esta nota (2026-10-18).

Borrador de Claude del 2026-10-18. Brayan lo revisa, lo ajusta y decide si lo publica como revisión del PR. La revisión empezó
estática, porque no había datos de PISA en este equipo. Ese mismo día llegaron los `.SAV` (sección 3.1) y los dos
scripts del PR se reprodujeron con datos (sección 6.3). Se leyeron
`03_nse_medicion.R` (3.1 y 3.2), `03_nse_tri.R`, `03_explorar_saltos.R`, D-16, D-19, D-20 y las salidas nuevas.

### 6.1 Lo que se comprobó y cuadra

- **Ajuste de ítems** (`salidas/nse_itemfit_tri.csv`), coincide con D-19:
  - S-X² en 4.672 casos completos, calculado para los 29 ítems de los tres modelos;
  - ítems con p ajustado < 0,05: 26 (1D), 27 (D-16) y 24 (AFE);
  - RMSEA máximo del S-X²: 0,016, 0,027 y 0,021;
  - ningún ítem problemático.
- **Policórica** (`salidas/nse_policorica_diagnostico.csv`), coincide con D-16: autovalor mínimo sin suavizar de
  −0,0255 (ponderada), −0,0262 (sin pesos) y −0,0357 (casos completos, n = 2.362).
- **Comparación de la TRI** (`salidas/nse_ajuste_tri.csv`):
  - BIC de 345.289 (1D), 330.600 (D-16) y 328.765 (AFE);
  - correlación entre factores de 0,497 (D-16) y 0,483 (AFE).
- **Información** (`salidas/nse_informacion_tri.csv`), coincide con D-19:
  - máximo de 20,6 en θ = 1,6 (1D);
  - económico: 10,0 (D-16) y 10,6 (AFE), cerca de θ = −0,3;
  - cultural: 32,3 (D-16) y 33,1 (AFE), en θ = 1,4.
- **D-20 bien implementada:** el script solo llena celdas que estaban vacías (`stopifnot` de
  `03_nse_medicion.R`, líneas 64–66).
- **Mitades:** se sortean después de ordenar por colegio y estudiante. D-20 cambia valores, no filas, así que no
  cambió las mitades.
- **Información por eje:** `testinfo(..., degrees = …)` recorre el eje correcto en cada dimensión.
- **Ley 1581:**
  - los cachés con datos individuales (`COL_nse.rds`, `COL_nse_tri.rds`, `COL_nse_tri_modelos.rds`) quedan fuera
    de Git (`.gitignore`: `*.rds` y `Proyecto_PISA/datos/*`);
  - las salidas del PR son agregadas.

### 6.2 Observaciones (propuestas; las decide el equipo)

1. **De fondo, antes del 3.4: dependencia local por el filtro de libros.**
   - **Qué pasa:** con D-20, los 1.002 estudiantes de la muestra analítica que no tienen libros quedan con
     `ST255Q01JA` = 0 y los 8 `ST256` = 0 por construcción. Una sola pregunta fija sus 9 respuestas.
     - Lo mismo, en menor escala, con `ST253` → `ST254` (204 estudiantes en Colombia; D-20).
     - La TRI (2PL y GPCM) y el AFC suponen independencia local dado el factor.
   - **Interpretación de Claude, sin fuente en el vault:** un bloque así puede inflar las discriminaciones, la
     información y la confiabilidad de sus ítems. Hay que buscar la fuente (por ejemplo, en de Ayala) antes de citarlo.
   - **Lo que se ve en las salidas y es compatible con eso:**
     - en el modelo de 1D, los 9 ítems de libros tienen las cargas más altas (0,83 a 0,93;
       `salidas/nse_parametros_tri.csv`);
     - la información del factor cultural llega a 32–33, frente a 10 en el económico;
     - con D-20, las cargas de los libros en el AFE pasaron de 0,52–0,74 a 0,69–0,85 (resultado del 3.2 en D-16).
   - **La otra lectura, la del registro, también encaja:** antes de D-20, por pares, los ítems de libros solo se
     correlacionaban entre quienes tienen libros (rango restringido). Las salidas actuales no permiten distinguir las
     dos lecturas.
   - **Por qué importa para H1:** 9 de los 12 indicadores del factor cultural de D-16 son de ese bloque. El AFC del
     3.4 podría preferir 2 factores por cómo está hecho el cuestionario y no por el NSE.
   - **Propuesta** (no cambia H1 ni su regla, que están congeladas):
     - (a) medir la dependencia local en el modelo de 1D con `residuals(m, type = "LD")` o `type = "Q3"` de `mirt`,
       en los casos completos, como el S-X²;
     - (b) análisis de sensibilidad del 3.4: el mismo AFC con los 8 `ST256` resumidos en un solo indicador (por
       ejemplo, cuántos tipos de libro hay en casa) o con un factor propio para ellos;
     - registrarlo (en la D-18 de Mateo o en una nueva) **antes** de correr el 3.4, para que cuente como
       preregistrado.
2. **Código: el caché de modelos no detecta si cambiaron los datos.**
   - **Qué pasa:** `03_nse_tri.R` (líneas 61–64) reutiliza `datos/COL_nse_tri_modelos.rds` si existe y
     `REHACER_TRI` no es `"1"`. Si `COL_nse.rds` cambia, el script:
     - no vuelve a estimar e imprime «Modelos leídos del caché»;
     - saca de los datos viejos todas las salidas (parámetros, EAP, validez y S-X²);
     - pega las EAP a `nse$CNTSTUID` por posición (líneas 133–138), sin control.

     Eso puede pasar con otra corrección como D-20, o si Mateo vuelve a correr el 3.1.
   - **Las salidas actuales no tienen ese problema:** el S-X² se calculó en los 29 ítems, y con los datos anteriores
     a la ampliación de D-20 no se podía calcular (D-20).
   - **Propuesta, sin probar** (`mirt` no está instalado en este equipo), después de leer el caché:

     ```r
     guardados <- unname(as.matrix(extract.mirt(modelos[["1D"]], "data")))
     if (!isTRUE(all.equal(guardados, unname(as.matrix(X)), check.attributes = FALSE)))
       stop("COL_nse.rds cambió desde que se guardó el caché: correr con REHACER_TRI = 1")
     ```
3. **Comentario desactualizado:** `03_nse_tri.R`, líneas 155–156, dice que el S-X² no se puede calcular para
   `ST253Q01JA` y `ST255Q01JA` («pendiente de decisión»). Después de D-20 sí se calcula en los 29 ítems.
4. **Registro:** en D-19 («Lo que muestran el software y los datos») dice «1.966 de 3.445 (57 %)» y cita
   `salidas/nse_policorica_diagnostico.csv`. Hoy ese archivo dice 2.362: el dato es de antes de D-20. Basta con
   agregar «antes de D-20».
5. **Interpretación del 3.5, para la Puerta G2:** la correlación de 0,96 del factor económico con `HOMEPOS`
   (`salidas/nse_validez.csv`) no es evidencia de validez independiente.
   - `HOMEPOS` se construye con los mismos bloques de posesiones, ST250 a ST256 (plan 07, paso 1.3).
   - Propuesta: presentarla como concordancia con el índice oficial, no como validez externa.
   - La composición exacta de `ESCS` no está en el vault; D-16 solo dice que `PAREDINT` se deriva de `HISCED`
     (p. 387). Todavía no se puede decir cuánto comparten nuestras escalas con `ESCS`.
6. **Menor:** el PR no tiene descripción. Propuesta: listar los pasos que cierra (3.2, 3.3 y 3.5), las decisiones
   (D-19 y D-20) y que el 3.4 de Mateo se corre sobre estos datos.
7. **Plan 07, paso 3.1:** sigue diciendo que «la regla del 2 % cambió solo los 5 ítems previstos en D-16». Con D-20
   son 7: se suman `ST256Q01JA` y `ST254Q01JA` (D-20 y la lista `esperados` de `03_nse_medicion.R`). El PR no
   actualiza esa frase.
8. **Plan 07, paso 3.3:** dice «las dos dimensiones ajustan mucho mejor que una». D-19 dice que la comparación es
   descriptiva (pseudo-verosimilitud ponderada) y que H1 se decide en el 3.4. Propuesta: «tienen menor AIC y BIC
   (comparación descriptiva, D-19)».
9. **Plan 07, paso 3.2:** dice «aparecen 2 factores» sin mencionar que el análisis paralelo sugiere 7 factores y 4
   componentes. El 2 es una lectura de los dos autovalores dominantes (10,12 y 3,16; resultado del 3.2 en D-16).
   Propuesta: agregarlo en una línea.

10. **Menor, para que las reproducciones se comparen limpias:** `nse_itemfit_tri.csv` se guarda sin redondear,
    a diferencia de las demás salidas. Sus diferencias de 0,0001 entre máquinas aparecen como cambios en Git (sección
    6.3). Propuesta: redondearlo a 4 decimales, como `nse_parametros_tri.csv` a 3.

### 6.3 Reproducción con datos (2026-10-18)

- **Cómo se hizo:**
  - copia aparte de la rama `Vanessa` (commit `4159ca4`) en la carpeta temporal de la sesión, fuera del proyecto
    y de OneDrive;
  - de entrada, el `COL_analitica.rds` de la cadena de `main`, que el PR no cambia (los `01a`–`01c` y
    `utilidades_pisa.R` son iguales en las dos ramas);
  - se corrieron `03_nse_medicion.R` (0,6 min) y `03_nse_tri.R` (10,8 min), sin caché de modelos, con el entorno
    de D-17 y sin errores.
- **Resultado:** de las 16 salidas de los dos scripts, **13 son idénticas byte a byte**, entre ellas todas las del
  3.1 y el 3.2, `nse_ajuste_tri.csv`, `nse_validez.csv`, `nse_confiabilidad_tri.csv` y `nse_informacion_tri.csv`.
  - `nse_parametros_tri.csv`: 3 de 464 celdas difieren en el tercer decimal (0,001). Son umbrales extremos de
    ítems que casi no discriminan: `ST254Q05JA` b1 (6,968 frente a 6,969) y `HISCED_c` b6 y b9.
  - `nse_itemfit_tri.csv`: 173 de 783 celdas difieren, con una diferencia máxima de 0,0001 en el S-X² (632,6124
    frente a 632,6123). La columna `problematico` es igual en todas las filas, así que la conclusión no cambia.
  - `nse_informacion_tri.png`: difiere en 2 bytes, pero se ve igual y sus datos (`nse_informacion_tri.csv`) son
    idénticos.
  - Interpretación de Claude, no verificada: las diferencias de 0,0001 vienen del cálculo en coma flotante de cada
    máquina.
- **Ojo:** `nse_tri_cargas_2d.csv` salió idéntico, pero con el fallo de `mirt` que dejaba en 0 las cargas
  culturales. Esta reproducción no lo detectó (observación 11).
- **Qué confirma:** que las salidas del PR corresponden al código del PR. La observación 2 (caché) no afectó las
  salidas publicadas.
- **No se reprodujo** `03_explorar_saltos.R`, que lee el `.SAV` del cuestionario. Sus dos tablas
  (`nse_saltos_*.csv`) son conteos que D-20 usa como dato.

### 6.4 Estado de las observaciones en `152691a` (2026-10-18)

| # | Observación | Estado | Evidencia |
|---|---|---|---|
| 1 | Dependencia local en el bloque de libros | **Atendida** por D-21 (Q3 de Yen) | En 2D quedan 10 de 406 pares con \|Q3\| > 0,2 (D-16) y 13 (AFE), y no hay dependencia positiva dentro de los libros (`salidas/nse_q3_tri.csv`). Queda abierto, como menor: los pares **negativos** `ST255Q01JA`–`ST256` (−0,21 a −0,27), que D-21 deja sin explicación |
| 2 | El caché de modelos no detecta si cambiaron los datos | **Vigente** | Las líneas 61–64 de `03_nse_tri.R` no cambiaron. Ver también la 14 |
| 3 | Comentario desactualizado sobre el S-X² | **Resuelta** | El comentario ya dice que el S-X² se calcula con D-20 |
| 4 | D-19 citaba 1.966 casos completos | **Resuelta** | D-19 aclara que es la cifra de antes de D-20 (hoy 2.362) |
| 5 | Validez frente a HOMEPOS | **Atendida en lo esencial** | D-22 y D-24 presentan el factor económico como «el más cercano al índice de la OCDE». El paso del plan se sigue llamando «Validez» |
| 6 | El PR no tiene descripción | **Vigente** | La API de GitHub la da vacía (28 commits) |
| 7 | Plan 3.1: «5 ítems» unidos | **Vigente** | Con D-20 son 7 |
| 8 | Plan 3.3: «ajustan mucho mejor» | **Vigente** | Sigue la frase. La comparación de la TRI es descriptiva (D-19); la de verdad es el AFC del 3.4 |
| 9 | Plan 3.2: falta que el paralelo sugería 7 factores | **Vigente** | No se agregó |
| 10 | `nse_itemfit_tri.csv` sin redondear | **Vigente**, ahora más importante | `00_correr_todo.R` usa `git status` como criterio de reproducción, y en otra máquina este archivo aparece cambiado aunque los resultados coincidan (6.3) |

### 6.5 Observaciones nuevas sobre los 14 commits

11. **Error de Claude en esta revisión:** en la 6.3 se reportó `nse_tri_cargas_2d.csv` como reproducido idéntico. Era
    cierto, pero reproducía un fallo: todas las cargas del factor cultural valían 0. Lo encontró Vanessa (commits
    `c814241` y `8f90ac2`): `summary()` de `mirt` 1.46.1 anula la carga de los ítems GPCM que solo cargan en el
    segundo factor. Esta revisión no lo vio.
    - **La corrección** (`cargas_mirt()` en `03_nse_tri.R`):
      - en 1D coincide con `summary()`; es un control del propio script;
      - las cargas de los libros quedan entre 0,92 y 0,98;
      - `a`, `b` y `carga_1D` de `nse_parametros_tri.csv` no cambian; se comprobó contra `4159ca4`.
    - Usa funciones internas de `mirt` (`mirt:::ExtractLambdas`, `nominal_rescale_d`). Con la versión fijada en D-17
      está bien; si se actualiza `mirt`, conviene revisarla. Los `stopifnot` del script avisarían.
12. **D-24 y el acta usan el AIC/BIC de la TRI como evidencia a favor del AFE.** D-19 ya advierte que esa comparación
    favorece al AFE, porque su estructura salió de la mitad de exploración, que está entre los 6.886.
    - La comparación justa es la del AFC en la mitad de confirmación (`salidas/nse_ajuste_afc.csv`). Ahí el AFE
      también gana: CFI *scaled* 0,943 frente a 0,921 y SRMR 0,071 frente a 0,087.
    - Propuesta: marcar la fila del AIC/BIC como no independiente. La decisión no cambia.
13. **La G2 pasa con «desajuste documentado».**
    - El plan pide que el desajuste esté «documentado y explicado». El modelo elegido tiene CFI *robust* de 0,753 y
      RMSEA *robust* de 0,114 (`salidas/nse_ajuste_afc.csv`), lejos de los cortes.
    - D-18 identifica de dónde viene el desajuste, pero su interpretación sigue «por discutir».
    - Propuesta para el acta: decir que la explicación es parcial. Es un juicio del equipo; no lo resuelve esta
      revisión.
14. **`00_correr_todo.R`:**
    - solo compara `salidas/`. No ve [[Datos/PISA2022 - Variables recodificadas]], que `01b` reescribe; le pasó a
      Claude en la corrida de este equipo (sección 3.1);
    - con el caché de la TRI, que `salidas/` no cambie no prueba que la TRI se reproduzca: hace falta
      `REHACER_TRI = 1`. Junto con la observación 2, podría esconder datos viejos;
    - `00_verificar_entorno.R` revisa versiones, no si los paquetes cargan (el caso de `pbivnorm`, sección 3.1).
15. **La comprobación pendiente de `lavaan` 0.7-3 queda resuelta con los datos.**
    - `cfi.robust` se calcula con WLSMV, pesos y faltantes por pares en 6 de los 7 modelos. Con M1 más los 10
      residuos sale NaN, y se reporta (`salidas/nse_ajuste_afc.csv`).
    - D-25 añade que, con restricciones de igualdad, `lavaan` no da las versiones *robust*.
    - Le sirve a la F6 (sección 3.4 de esta nota).
16. **Comprobado:** los 10 pares de la sensibilidad (b) se fijaron antes de ver el Q3, como dice D-21. El orden de
    los commits lo respalda: D-18 con los pares en `e5cb408` (15:37), Q3 en `8f90ac2` (15:46) y AFC en `9ba120e`
    (16:03).

**Propuesta de veredicto (la decide Brayan; actualizada con los 14 commits):**
- aprobar con los cambios menores 2, 6 a 10 y 12, y 14 como mejora de `00_correr_todo.R`;
- la 13 va al acta de la G2 antes de firmarla;
- la 1 queda atendida; los pares negativos `ST255`–`ST256` se anotan como pendiente menor;
- D-10 no es parte de este PR: se decide con Mateo antes de la F4 (sección 7).

## 7. Firmas pendientes en el registro: resumen para decidir

Claude no firma: cada firma la pone Brayan en [[03 Registro de decisiones]], con nombre y fecha.

| Decisión | Qué fija | Qué revisó Claude (2026-10-18) | Qué falta |
|---|---|---|---|
| D-15 | Método de la Puerta G1 | `utilidades_pisa.R` y `02_validacion_ocde.R` hacen lo que dice D-15 (factor 0,05 = 1/(80 · 0,5²), varianza total con (1 + 1/10), cortes ponderados fijos, R² lineal). Las tres cifras quedan dentro de ±1 (`salidas/validacion_ocde.csv`). Reproducida en este equipo el 2026-10-18: la salida es idéntica a la de `main` (sección 3.1) | Leerla y firmar. Es la «revisión de Brayan» que pide la Puerta G1 en la F2 del plan 07 |
| D-16 | Muestra, indicadores, categorías escasas, pesos, faltantes, estructura y regla de H1 | El 3.1 aplica los puntos 1 a 4: 6.886 estudiantes, 29 indicadores, regla del 2 % y cortes de `HISEI` | Firmar. La observación 1 ya la atendió D-21, antes del 3.4 |
| D-17 | Versiones de R y de los paquetes | Instalado el 2026-10-18: los 13 coinciden y cargan (sección 3.1). Hubo que instalar aparte `pbivnorm`, y la verificación no lo detectó | Firmar. Opcional, para Mateo: que `00_verificar_entorno.R` también intente cargar cada paquete |
| D-19 | Detalles de la TRI del NSE | `03_nse_tri.R` hace lo que dice D-19. Las cargas 2D se corrigieron el 18/10 (observación 11) | Siguen vigentes las observaciones 2 y 10; la 3 y la 4 están resueltas |
| D-20 | Saltos del cuestionario = 0 | Bien implementada (sección 6.1) | Firmar. La observación 1 quedó atendida con D-21 |
| D-18 | Reglas del AFC del 3.4 (lo hizo Vanessa y Mateo lo revisa) | `03_nse_afc.R` aplica la regla de H1 de D-16 punto 8 con WLSMV, pesos, faltantes por pares y `std.lv`. H1 se acepta: ΔCFI de 0,107 (*scaled*) y 0,218 (*robust*), r = 0,559 (`salidas/nse_h1_afc.csv`) | Revisar; como revisor de O1–O2 te toca |
| D-21 | P1–P6 de la nota 14 y Q3 | Ver observación 1 (sección 6.4) | Revisar |
| D-22 | Definiciones de H2 a H7 | Anterior al AFC (commit `e5cb408`). **Para tu F6:** H5 y H6 se deciden con el factor económico | Revisar, sobre todo el punto de H5 y H6 |
| D-23 | Pendientes de la F5 y la F6 | Los puntos 1 (PV condicionados) y 5 (errores estándar con BRR) son de tu F6 (sección 3.4) | Propuesta: decidir el 5 antes de la F6 |
| D-24 | Puerta G2: pasa el modelo del AFE | Observaciones 12 y 13 | Revisar y firmar el acta [[Reuniones/2026-10-18 Puerta G2]] |
| D-25 | Reglas de la F4 (invarianza) | Coherente con la regla de H2 del preregistro. Los criterios ΔCFI/ΔRMSEA salen de [[Literatura/putnick2016measurement]] (por verificar) | Revisar (revisor de O2) |
| D-10 | Citas de fuentes de pago | Vanessa eligió (b) el 2026-10-18 y la extendió a todas las fuentes de pago del anteproyecto. **Dos son de tu bloque M:** [[Literatura/chen2007sensitivity]] (la F4 usaría Putnick en su lugar) y [[Literatura/rubin1987multiple]] (lo reemplazaría el Technical Report, p. 226, por verificar) | Decidir con Mateo antes de la F4 (lo pide el acta de la G2). Si queda (b), salen de tu lista de verificación |
| D-11 | Cómo se codifica una abstención | `banco_Brayan.csv` ya la sigue: las 6 abstenciones en preguntas del corpus están como `sostenida = no` y `correcta = no` | Confirmarla. En `banco_Mateo.csv`, M01 B, M02 B y M05 A son abstenciones en preguntas del corpus y siguen como «no aplica». Así `nsf_evaluacion.R` las saca del conteo, que es justo lo que D-11 corrige. Lo decide Mateo |
