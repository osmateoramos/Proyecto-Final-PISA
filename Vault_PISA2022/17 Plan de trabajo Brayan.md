---
tipo: guia
estado: por_verificar
lectura: "redactado por Claude con Brayan; falta revisión del equipo"
pendientes: "Equipo: aceptar o ajustar las propuestas de las secciones 2, 3.2 y 4. Brayan: revisar la sección 9 (H8) y decidir si propone al equipo las pruebas de la 9.5 (sin número: D-32 ya existe). Brayan: revisar el AFC (sección 10 y la sección final de Hallazgos) y decidir si se propone como D-49. Brayan: firmar D-16 y D-18 a D-48 y las actas de la G2, la G3 y la G4 (acta de la G4, pendientes)"
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

> [!info] Casillas de las secciones 1 y 2
> Las marcó Claude el 2026-10-18 según los archivos de `Proyecto_PISA/nada_sin_fuente/`, que se entregaron el 13/10
> (PR #2). Comprobó que existen y cuántas filas tienen, no su calidad. Brayan confirma cada una.

- [x] **Inventario de fallos** (½ página, firmado):
  - al menos 3 fallos propios con la plantilla del enunciado;
  - los fallos los aporta Brayan, de su propia experiencia; la IA solo les da formato.
  - *Evidencia:* `inventarios/inventario_Brayan.md`: 3 fallos, unas 520 palabras, firmado por Brayan el 13/10/2026.
- [x] **Consulta bibliográfica propia, zona O4.**
  - *Evidencia:* `experimento/consulta_Brayan.md` (tratamientos A, B y C, con herramienta y fecha; la hora quedó
    «por confirmar») y `experimento/referencias_Brayan.csv`, con 25 referencias: 9 de A, 9 de B y 7 de C.
  - Propuesta: *"SEM con valores plausibles y pesos muestrales en PISA: efecto del NSE en el desempeño por
    competencia"*.
  - No coincide con la de Vanessa (zona O3) ni con la que corresponde a Mateo (O1–O2).
  - Se corre en los tres tratamientos: A (chat sin fuentes), B (buscador conectado a bases reales) y C (contexto
    cerrado con PDF).
  - Al menos 5 referencias por tratamiento.
  - De cada corrida se guardan el prompt, la respuesta completa, la fecha y la herramienta (con su versión).
- [x] **Clasificación ciega** de las referencias de los tres integrantes:
  - categorías: utilizable / existe pero no dice eso / no existe;
  - cada quien escribe en su propio archivo (por ejemplo `clasificacion_Brayan.csv`);
  - Brayan **no lee la tabla de clasificación de `16 Experimento Nada sin fuente`** (rama `Vanessa`) antes de
    terminar la suya;
  - el cruce se hace al final, con los tres archivos completos.
  - *Evidencia:* `experimento/clasificacion_Brayan.csv`: 67 referencias (32 utilizables, 25 «existe pero no dice
    eso» y 10 «no existe»). Que fuera ciega no se puede comprobar en los archivos.
- [x] **Filas propias en la bitácora de IA** (`15 Bitácora de uso de IA`, rama `Vanessa`), cuando esa nota llegue a
  `main`. Mientras tanto se anotan en la sección 4 de esta nota.
  - *Evidencia:* 5 filas de Brayan del 2026-10-13 en [[15 Bitácora de uso de IA]] (en `main`). Las del 18/10 están en
    la sección 5 de esta nota, por trasladar.

## 2. "Nada sin fuente": piezas de equipo que nadie ha tomado (propuesta, por acordar)

- [x] **Análisis del experimento:** un script reproducible (por ejemplo `Proyecto_PISA/scripts/nsf_experimento.R`)
  que:
  - lea los archivos de clasificación;
  - calcule la proporción de referencias utilizables por tratamiento con su intervalo de confianza (Wilson,
    adecuado para n ≈ 15);
  - cuente en cuántas referencias no coincidieron los clasificadores (opcional: kappa de Fleiss);
  - guarde las tablas en `Proyecto_PISA/salidas/`.

  Alimenta el criterio C1.
  - *Evidencia:* `scripts/nsf_experimento.R`, con `salidas/nsf_proporciones.csv`, `nsf_acuerdo.csv` y
    `nsf_desacuerdos.csv`, entre otros (en `main`).
- [ ] **Implementación del sistema de fuentes (C3)**, ligada al paso 8.5 del plan (RAG):
  - *Resuelto por el equipo de otra forma:* se eligió la «vía empaquetada» (`nada_sin_fuente/README.md`, línea 12,
    con C3 topado en Competente), con los protocolos de `nada_sin_fuente/protocolo/`. El sistema lo expone Mateo.
    La vía propia de abajo (Ollama + Chroma) no se hizo. Queda sin marcar porque no se hizo lo que dice esta
    casilla.
  - proponer **D-10** en [[03 Registro de decisiones]], porque la actividad pide un sistema de contexto cerrado
    y D-06 lo había descartado; además, D-04 (modelo del RAG) sigue pendiente;
  - si el equipo elige la vía propia: Ollama + modelo de embeddings + Chroma, comparando `bge-m3` contra
    `multilingual-e5` sobre preguntas propias, como pide el enunciado;
  - límite conocido: el equipo de Brayan tiene 7,8 GB de RAM, así que solo caben modelos pequeños cuantizados.
- [x] **Parte del banco de evaluación:**
  - preguntas con respuesta conocida y localizada (documento y página) sobre las fuentes de la sección 3.2;
  - al menos 3 preguntas cuya respuesta **no** esté en el corpus.
  - *Evidencia:* `evaluacion/banco_Brayan.csv`, con 6 preguntas (B01–B06) en los tres tratamientos. Solo B06 está
    fuera del corpus; las 3 fuera del corpus se cumplen entre los tres bancos (B06, M06 y V06,
    `evaluacion/banco_completo.csv`).
- [x] **Parte de la tabla de trazabilidad:** sale de la verificación de la sección 3.2.
  - *Evidencia:* `trazabilidad/trazabilidad_Brayan.csv`: 18 filas, 17 firmadas por Brayan (16 se sostienen y 1 es
    parcial).
    - Parcial: T-Bra-01, Collazos. No se revisó por qué; ver también lo de «MCO» en
      [[18 Verificación de fuentes Brayan]].
    - Sin firmar: T-Bra-16, Rubin (1987), de pago; depende de D-10.

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

**Preparado el 2026-10-18:** [[18 Verificación de fuentes Brayan]], con la página propuesta y qué buscar en cada fila
(son pistas, no evidencia).
- `oecd2023fichacolombia` ya no hace falta: la verificó Vanessa entera.
- Hay que revisar tres puntos: el 40 % de Rodríguez (tres redacciones distintas), el internet de Zabala (el resumen
  y la discusión se contradicen) y el «MCO» de Collazos (no aparece en el texto).

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

   *Resuelto el 2026-10-18:* el umbral de «efecto no despreciable» y las otras definiciones quedaron en D-22 y en el
   anexo de la nota 09. P1–P6 se aprobaron en D-21. El congelamiento y el paso 0.5 se anotaron el 2026-10-16.
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
| 2026-10-18 | Brayan | Avanzar lo que no requiere a Brayan: reproducir el PR #12 en `152691a`, preparar la verificación de sus fuentes y marcar con evidencia las tareas de «Nada sin fuente» | Claude reprodujo 4 scripts (21 de 24 salidas idénticas; sección 6.3). Escribió [[18 Verificación de fuentes Brayan]] buscando en el texto de 7 PDF del corpus. Marcó las casillas de las secciones 1 y 2 según los archivos | No saltó la verificación antibots de la página de la OCDE (términos de uso): queda para Brayan | borrador, sin confirmar |
| 2026-10-18 | Brayan | Crear el PR #13 y publicar la revisión en el PR #12 | Con la sesión de GitHub de Brayan en el navegador integrado, Claude llenó y creó el PR #13 (`Brayan` → `main`, listo para revisión) y publicó en el #12 un comentario con las secciones 6.4 y 6.5 y el veredicto. No aprobó el PR, a pedido de Brayan | El comentario dice que el siguiente número libre es D-26, pero Vanessa ya había usado D-26 y D-27 minutos antes: es un error de Claude, corregido en esta nota | borrador, sin confirmar |
| 2026-10-18 | Brayan | Revisar la F4 de Vanessa (O2) y reproducirla con datos | Claude leyó `04_invarianza.R`, D-25, D-26 y la F4 del plan 07. Comprobó en el código de `mirt` la causa que da D-26 y reprodujo los pasos 4.1 a 4.5 en una copia aparte, con el script cortado en la línea 189: 4 de 5 salidas idénticas y 1 que difiere en el redondeo de una celda. Redactó la sección 8 | El 4.4 (DIF) no se revisó ni se corrió, porque sus salidas no están publicadas | borrador, sin confirmar |
| 2026-10-18 | Brayan | Publicar la revisión de la F4 en el PR #12 | Con la sesión de GitHub de Brayan en el navegador integrado, Claude publicó la sección 8 como comentario (`issuecomment-6256805371`), sin aprobar el PR, a pedido de Brayan | Ninguna | borrador, sin confirmar |
| 2026-10-23 | Brayan | Revisar H8: cada supuesto y cómo se construyen sus bases | Claude leyó el anexo A y las etiquetas del `.SAV` con lectores propios, reprodujo los pasos 5.1 a 5.3 en una copia aparte (5 salidas; solo cambian los minutos), revisó con datos la co-observación, las unidades y las omisiones, recalculó la verosimilitud con más puntos y corrió el Q3 dentro de las unidades. Redactó la sección 9 | El primer Q3 marcaba el 17,7 % de los pares entre unidades; antes de interpretarlo, Claude lo repitió con el número de estudiantes por par y vio que se concentra en pares con menos de 50 | borrador, sin confirmar |
| 2026-10-23 | Brayan | Prueba R2: H8 con la omisión como faltante | A pedido de Brayan, Claude repitió en la copia aparte el 5.3 con la matriz (c), con la lectura fijada antes de correrla (sección 9.5), y anotó el resultado en la sección 9.7: la regla de H8 tampoco se cumple y las correlaciones cambian 0,007 como máximo | Claude había sugerido (sección 9.2) que la omisión como 0 podía subir las correlaciones: R2 no lo confirma, y queda anotado como error de interpretación | borrador, sin confirmar |
| 2026-11-08 | Brayan | AFC de los ítems de matemáticas por competencia, antes del plan B de la F6 (sección 10) | Claude fijó la lectura antes de correr, reconstruyó los modelos de 1 y 4 dimensiones en una copia aparte, corrió las pruebas por ítem (A, B, C y E) y empezó el control D. Explicó la demora y comprobó que solo entran datos de Colombia (prefijo 170 en los 6.886 estudiantes) | Claude estimó de 2 a 5 minutos por ajuste del control y fueron unos 30; lo dijo y repartió el control en 3 procesos. Un cálculo directo más rápido no reprodujo el control de `mirt` (−99.814,11 frente a −99.810,19) y no se usó | borrador, sin confirmar |
| 2026-11-10 | Brayan | Cerrar el AFC, revisar GitHub y agregar el AFC como hallazgo | Claude reanudó los procesos pausados, unió el control D y revisó GitHub: 66 commits nuevos en `main`, 0 PR abiertos y la etiqueta `resultados-v1`. Avanzó la rama local `Brayan` hasta `origin/main` (sin `push`). Copió 6 scripts y 5 salidas al proyecto, cambiando solo rutas y nombres, y probó 2 scripts con salidas idénticas. Redactó la sección final de [[Hallazgos]] y la sección 10 | Vio que D-32 ya existe (Vanessa, 2026-11-08) y quitó el número al borrador de la sección 9.5. Vio que D-48 de Mateo responde parte de la misma pregunta y presentó el AFC como complemento | borrador, sin confirmar |

## 6. Revisión del PR #12 (rama `Vanessa` → `main`): borrador para Brayan

> [!info] Alcance de esta revisión
> - **Secciones 6.1 a 6.3:** el PR hasta el commit `4159ca4` (3.2, 3.3 y 3.5; D-19 y D-20), incluida la
>   reproducción con datos.
> - **Secciones 6.4 y 6.5:** los 14 commits que Vanessa subió el 2026-10-18, de las 13:44 a las 16:15 (hasta
>   `152691a`): el 3.3b con Q3 (D-21), el 3.4 y H1 (D-18), la Puerta G2 (D-24), la F4 (D-25), `00_correr_todo.R`, la
>   corrección de las cargas 2D, D-22, D-23 y la posición de Vanessa en D-10.
>   - **Reproducida con datos el 2026-10-18 (17:38–17:49):** `03_nse_medicion.R`, `03_nse_tri.R`, `03_nse_afc.R` y
>     `04_explorar_grupos.R` de `152691a` (sección 6.3). No se reprodujo `03_explorar_saltos.R`.
> - **Números de decisión:** D-21 a D-27 ya están usados; el siguiente libre es **D-28**.
>   - *Corrección (2026-10-18):* antes decía D-26. Entre las 17:51 y las 18:04 Vanessa registró D-26 (F4, prueba del
>     DIF) y D-27 (F5), en los commits `34d68d0` a `0a43118`.
>   - El comentario publicado en el PR #12 decía D-26; se corrigió el mismo día.
> - **Commits que esta revisión no cubre:** después de `152691a` el PR suma 4 commits (32 en total, de `34d68d0` a
>   `51ad44d`, entre las 17:51 y las 18:16):
>   - la F4 (`04_invarianza.R`, D-26; pasos 4.1–4.3 y 4.5);
>   - la F5: el paso 5.1 y un piloto (`05_explorar_items.R`, D-27).
>
>   La F4 es O2: como revisor de O1–O2, también te toca revisarla.
>   - **Revisada el 2026-10-18 en la sección 8**, con reproducción hasta el 4.5. El 4.4 y el paso 5.1 de la F5 no se
>     revisaron.
>   - El comentario del PR #12 se editó para decir esto y para corregir el número (D-28).
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
- **Segunda reproducción, con el PR en `152691a`** (2026-10-18, de 17:38 a 17:49; copia aparte, sin caché de modelos y
  sin errores):
  - scripts: `03_nse_medicion.R` (0,4 min), `03_nse_tri.R` (8,1 min), `03_nse_afc.R` (1,7 min) y
    `04_explorar_grupos.R`;
  - de **24 salidas regeneradas, 21 son idénticas byte a byte**, entre ellas:
    - todas las del 3.4: `nse_ajuste_afc.csv`, `nse_h1_afc.csv` (H1 se acepta con los mismos ΔCFI),
      `nse_cargas_afc.csv`, `nse_omega_afc.csv` y `nse_residuos_afc.csv`;
    - el Q3 (`nse_q3_tri.csv`) y las cargas 2D corregidas (`nse_tri_cargas_2d.csv`);
    - las dos tablas de la F4 (`inv_grupos_n.csv` e `inv_categorias_grupo.csv`);
  - las otras 3 son las mismas de la primera vez y con las mismas diferencias: `nse_parametros_tri.csv` (3 de 522
    celdas, 0,001), `nse_itemfit_tri.csv` (173 de 783, como mucho 0,0001) y la figura (2 bytes).

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
| D-26 | La prueba TRI del DIF va sin pesos (corrige D-25 punto 7) | Comprobado en `mirt` 1.46.1: `DIF()` reestima sin `survey.weights` (sección 8.1) | Revisar y firmar |

## 8. Revisión de la F4 (O2), commits `34d68d0` a `51ad44d`: borrador para Brayan

Borrador de Claude del 2026-10-18, como revisor de O2. Cubre `04_invarianza.R` en `51ad44d`, D-25, D-26, la F4 del
plan 07 y las salidas publicadas. **El 4.4 (DIF) no está en el PR:** sus salidas (`nse_dif_posesiones.csv` e
`inv_h2.csv`) no se publicaron porque la corrida corregida seguía en curso (plan 07). Por eso aquí no se revisa su
resultado.

### 8.1 Lo que se comprobó y cuadra

- **Muestras** (`salidas/invarianza_tabla.csv`), como dice D-25:
  - zona, 6.674 (6.886 menos los 212 sin zona);
  - rural–urbana, 5.831 (4.927 + 904);
  - sexo, 6.886;
  - sector, 6.796 (menos los 90 sin sector).
- **Categorías escasas:** cambian solo los 3 ítems previstos en D-25 (`ST254Q02JA`, `ST251Q01JA` y `HISCED_c`). El
  script se detiene si cambia otro (líneas 89–90), y el detalle está en `salidas/inv_recodificacion.csv`.
- **Secuencia:** `measEq.syntax` con Wu y Estabrook, parametrización theta y `std.lv`, en el orden configural →
  umbrales → cargas → interceptos. El criterio es ΔCFI ≥ −0,01 y ΔRMSEA ≤ 0,015 en versión *scaled* (líneas 114 y
  141), como en D-25 punto 5.
- **Resultado:** la invarianza escalar total se sostiene en los 4 análisis. No hizo falta liberar ningún parámetro
  (`nse_items_no_invariantes.csv` vacío). El peor cambio es el del sector: ΔCFI −0,0066 y ΔRMSEA +0,0019.
- **D-26:** la causa que da se comprobó en el código de `mirt` 1.46.1 de este equipo: ninguna línea de `DIF()`
  menciona `survey.weights`, y reestima con `multipleGroup()` sin pesos. La prueba TRI sin pesos y la magnitud con
  pesos son coherentes con D-19 punto 4.
- **H2 ya se decide sin el DIF:** la regla de D-25 punto 8 pide dos condiciones a la vez. El paso escalar
  rural–urbana no empeora (ΔCFI −0,0027 y ΔRMSEA +0,0007), así que **H2 se rechaza tenga o no DIF**. El plan 07 ya lo
  dice. El 4.4 sigue sirviendo para describir O2.

### 8.2 Observaciones (propuestas; las decide el equipo)

1. **Al restringir las cargas, el ajuste *scaled* mejora.**
   - En los 4 análisis, el CFI *scaled* sube entre 0,004 y 0,006 y el RMSEA baja. El χ² *scaled* también baja, de
     9.646 a 8.917 en zona, aunque el modelo tiene más restricciones (`invarianza_tabla.csv`).
   - *Interpretación de Claude, sin fuente en el vault:* con WLSMV, el χ² y los índices *scaled* de modelos anidados
     no tienen por qué empeorar al restringir, porque la corrección de escala cambia entre modelos. Eso le quita
     fuerza a la regla ΔCFI/ΔRMSEA, que D-25 ya matiza: Putnick y Bornstein la describen para ítems continuos.
   - Propuesta: agregar en cada paso la prueba de diferencia escalada (`lavTestLRT`, como en el 3.4) como
     complemento. No cambia la regla de H2; con n ≈ 6.000 seguramente rechazará, pero queda documentado.
2. **Los índices *robust* faltan también sin restricciones.**
   - En el 4.1 (un AFC por grupo, sin igualdades), 4 de los 7 grupos no tienen CFI ni RMSEA *robust*: urbana,
     rural, mujer y privado.
   - Donde sí salen, el CFI *robust* va de 0,68 a 0,71 y el RMSEA *robust* de 0,12 a 0,14
     (`invarianza_por_grupo.csv`), igual de lejos de los cortes que en la G2.
   - D-25 atribuye la falta de *robust* a las restricciones de igualdad, pero aquí pasa sin ellas.
   - Propuesta: anotarlo como limitación. Que el modelo «converge con CFI *scaled* de 0,929 a 0,954» (plan 07) no
     dice que ajuste bien en cada grupo.
3. **Errores estándar de las medias latentes.** `nse_medias_latentes.csv` exporta `ee` e IC 95 % de `lavaan`, que no
   reflejan el diseño por colegios (D-16 punto 5; D-25 punto 9 dice «sin EE de diseño»).
   - El riesgo es que se lean como intervalos válidos: por ejemplo, hombre frente a mujer en el factor económico,
     con un IC de −0,003 a 0,107.
   - Propuesta: agregar una columna de aviso, o no exportar el IC hasta tener errores con BRR.
4. **El caché del AFC** (`datos/COL_inv_cfa.rds`) tampoco detecta si cambiaron `COL_nse.rds` o `COL_nse_tri.rds`. Es
   el mismo patrón de la observación 2 (sección 6). El commit `51ad44d` blindó solo el caché del DIF, y solo contra la
   corrida con pesos.
5. **De redacción:** en D-25 (o al cerrar la F4), decir explícitamente que H2 ya se rechaza por la primera
   condición. Así no parece que H2 espere al DIF.

### 8.3 Reproducción con datos (2026-10-18, de 18:24 a 18:59)

- **Cómo se hizo:**
  - copia aparte de la rama `Vanessa` en `51ad44d`, fuera del proyecto y de OneDrive, sin caché del AFC (34,5 min,
    sin errores);
  - entradas: `COL_nse.rds` y `COL_nse_tri.rds` de la reproducción de `152691a` (sección 6.3). Los scripts `03` no
    cambian entre `152691a` y `51ad44d`;
  - se corrió `04_invarianza.R` **hasta la línea 189** (fin del 4.5), copiada sin cambios, para no correr el 4.4
    (DIF), cuyas salidas no están publicadas.
- **Resultado:** de las 5 salidas publicadas, **4 son idénticas byte a byte**:
  - `inv_recodificacion.csv`, `invarianza_por_grupo.csv`, `nse_items_no_invariantes.csv` y
    `nse_medias_latentes.csv`;
  - en `invarianza_tabla.csv` difiere 1 celda de 256, en el redondeo (χ² *scaled* de umbrales rural–urbana: 8.421,42
    frente a 8.421,4199). Los ΔCFI, ΔRMSEA y la columna `se_sostiene` son iguales.
- **Qué confirma:** la invarianza escalar total en los 4 análisis y las medias latentes del 4.5 se reproducen en este
  equipo.

**Propuesta de veredicto para la F4 (la decide Brayan):**
- aprobable; las observaciones 1 a 4 son mejoras, y la 5 es de redacción;
- el 4.4 se revisa cuando se publiquen sus salidas;
- D-26 se puede firmar: su causa está comprobada.

## 9. Revisión de H8 (F5, pasos 5.1 a 5.3): borrador para Brayan

Borrador de Claude del 2026-10-23, a pedido de Brayan, para revisar cada supuesto de H8 y cómo se construyen sus
bases. Cubre `05_explorar_items.R` y `05_tri_competencias.R` hasta la línea 148 (fin del 5.3) en `main` (`3dc44d3`),
D-13, D-14, D-27, D-29, la F5 del plan 07 y la H8 de [[09 Hipótesis preregistradas]]. Los scripts de la revisión están
en el scratchpad de Claude, no en el proyecto, y solo imprimen agregados (Ley 1581).

> [!info] Qué es dato, qué es fuente y qué es interpretación
> Las cifras salen de los datos o de las salidas que se indican. Las lecturas marcadas «interpretación de Claude» no
> tienen fuente en el vault: son hipótesis para discutir, no resultados.

### 9.1 Construcción de las bases: lo que se comprobó y cuadra

| Pieza | Qué supone H8 | Cómo se comprobó | Resultado |
|---|---|---|---|
| Bloque de Colombia y estados de cada celda (D-13) | El omitido, el no alcanzado y el no administrado están bien separados | Cadena de `main` reproducida el 2026-10-18 (sección 5, fila de ese día); aquí se usa el mismo `COL_cognitivo.rds` | Sin cambios frente al repositorio |
| Muestra de 6.886 (D-14 b, con ESCS) | Se calibra con la población del proyecto | Misma reproducción; hoy `mat_matriz_resumen.csv` vuelve a dar 6.886 | Cuadra |
| Clasificación ítem → competencia | Cada ítem va a la competencia que le da la OCDE | Lectura propia del anexo A (hoja `Mathematics-CBA`, columna K «Process»), con un lector escrito aparte, sin el código del proyecto | 233 de 234 ítems coinciden en competencia, unidad, formato y parámetros internacionales; la excepción es el hallazgo 1 |
| Regla de puntaje (D-27 punto 1) | El primer dígito es el crédito | La regla del script aplicada a las etiquetas oficiales del `.SAV` (solo la cabecera, sin respuestas) | 563 de 564 códigos coinciden con «No / Partial / Full credit»; la excepción es el hallazgo 2 |
| Matrices (a), (b) y (c) del 5.2 y el NT10 | Omitida = 0 en (a), omisión rápida faltante en (b), toda omisión faltante en (c) | `05_explorar_items.R` y el 5.2 regenerados en una copia aparte | Las 4 salidas son **idénticas byte a byte**: `items_competencia.csv`, `items_respuestas.csv`, `items_resumen_competencia.csv` y `mat_matriz_resumen.csv` (12.490 omisiones, 4.852 rápidas, dato en el 11,66 % de las celdas) |
| Pesos y BIC | `W_FSTUWT` normalizados a suma 6.886; BIC con N = 6.886 | Línea 103 y cuenta a mano: −2 · logLik + parámetros · ln 6.886 | 1D: 199.620,4 + 526 · 8,8373 = 204.268,8; 4D: 199.594,6 + 532 · 8,8373 = 204.296,0. Coinciden con `mat_ajuste.csv` |
| Regla de H8 en el código (línea 146) | La misma de la nota 09 | Lectura | «Menor BIC y máximo ≤ 0,95» equivale a «ninguna correlación > 0,95» |

- En el anexo, por proceso: emplear 75, interpretar 57, razonar 54 (con el retirado) y formular 48. Calibrables en
  Colombia: 75, 57, 53 y 47, porque `CMA112Q02S` (razonar) está retirado y `CMA143Q01S` (formular) no tiene
  respuestas (D-27).

### 9.2 Supuestos revisados con los datos

Script `revisar_supuestos_h8.R` sobre `COL_mat_respuestas.rds` de la copia (versión a, salvo que se diga otra cosa).

1. **Las correlaciones se pueden estimar con el diseño adaptativo.** Cumplido.
   - 6.832 de los 6.886 estudiantes tienen al menos un ítem de las 4 competencias, y 54 tienen de 3.
   - Por par de competencias, entre 6.289 (formular–interpretar) y 6.621 (emplear–interpretar) estudiantes tienen al
     menos 3 ítems en las dos.
   - Ítems por estudiante (mediana): emplear 9, formular 5, interpretar 7 y razonar 6.
   - Las correlaciones salen de estudiantes que respondieron las dos competencias, no de una extrapolación. Que haya
     pocos ítems por competencia pesa en los puntajes individuales (5.4), no en la correlación latente.
2. **Independencia local dentro de las unidades (estímulo común).** El proyecto no la comprobó (hallazgo 3). En la
   copia, la dependencia sale baja (sección 9.4).
   - De 99 unidades, 76 tienen 2 o más ítems y **57 de esas 76 mezclan competencias**: 166 de los 232 ítems están en
     una unidad mixta.
   - Dentro de una misma unidad hay 133 pares de ítems de competencias distintas y 68 de la misma. La mediana de
     estudiantes que respondieron los dos ítems es 760 y 722,5 (`revisar_unidades_y_logLik.R`).
   - *Interpretación de Claude:* si dos ítems de una unidad comparten algo además de su competencia (el estímulo), en
     el modelo de 4 dimensiones esa covarianza extra solo la puede absorber la correlación entre factores cuando los
     ítems son de competencias distintas, lo que la subiría. En los pares de la misma competencia pasaría lo
     contrario. Como dos tercios de los pares son mixtos, el sesgo esperado es hacia arriba, pero hay que medirlo.
3. **La omisión calificada como 0 (versión a).** Es el criterio de la OCDE (D-13, TR p. 211) y es correcto para el
   análisis principal, pero puede no ser neutral para H8.
   - Proporción media de omisiones: emplear 0,054, formular 0,077, interpretar 0,065 y razonar 0,085.
   - La proporción de omisiones de un estudiante en una competencia se correlaciona con la de otra entre 0,37 y 0,44.
     373 estudiantes omiten algo en las 4 competencias y 2.669 no omiten nada.
   - *Interpretación de Claude:* la tendencia a omitir es en parte común a las 4 competencias. Calificada como 0,
     entra en los 4 factores a la vez y podría subir sus correlaciones. H8 se decidió solo con la versión (a) (plan
     07, 5.3).
   - **R2 no confirma esa interpretación** (sección 9.7): con la omisión como faltante, las correlaciones cambian
     0,007 como máximo. La hipótesis era de Claude, y queda descartada.
4. **Con pesos, el BIC es descriptivo** (D-19 punto 4).
   - La ganancia del modelo de 4 dimensiones es de 12,9 en la log-verosimilitud, con 6 parámetros más. Con
     pseudo-verosimilitud, eso no es una prueba χ² válida.
   - La regla preregistrada es la que manda, y se aplicó bien.
5. **Precisión de las correlaciones.** El 5.3 se estima con `SE = FALSE` (línea 109), así que no hay intervalo para
   ninguna correlación.
   - Emplear–interpretar (0,951) está a 0,001 del corte: por sí sola no sería evidencia fuerte.
   - La condición la sostiene emplear–razonar (0,976).

### 9.3 Hallazgos (propuestas; las decide el equipo)

1. **El retirado `CMA112Q02S` no queda marcado.**
   - En `items_competencia.csv` tiene la competencia vacía y `retirado = FALSE`. La celda del anexo dice
     «CMA112Q02⏎(Dropped)», con un salto de línea, y la expresión de la línea 64 de `05_explorar_items.R`
     (`" *\\(Dropped\\)"`) solo admite espacios.
   - No afecta a H8, porque el ítem no tiene respuestas y no es calibrable. Pero D-27 dice que está retirado y el
     archivo no lo refleja.
   - Propuesta: `"\\s*\\(Dropped\\)"`, y que el script se detenga si algún ítem queda sin competencia.
2. **`DMA161Q04C` tiene dos códigos de crédito completo** (0 = *No credit*, 1 y 2 = *Full credit*, etiquetas del
   `.SAV`).
   - La regla daría 2 al código 2, pero en Colombia solo aparecen el 0 y el 1 (412 respuestas). Es latente: no cambia
     nada aquí.
   - Propuesta: anotarlo en D-27 junto a `DM462Q01C`.
3. **La P1 (Q3 dentro de las unidades) no está programada.** D-27 punto 9 la incluye y el plan 07 la pone en el 5.3,
   que está marcado como hecho. Ningún script de la F5 calcula el Q3; solo lo hace `03_nse_tri.R`, en la F3.
   - Claude la corrió en la copia como revisión (sección 9.4): la dependencia es baja. Falta que quede en el script y
     en `salidas/` del proyecto.
4. **La matriz de correlaciones no queda en un archivo.**
   - `mat_ajuste.csv` guarda solo la mínima y la máxima. El 0,951 de emplear–interpretar que citan el plan 07, la
     nota 09 y D-29 sale de la consola, no de una salida.
   - Propuesta: guardar `salidas/mat_correlaciones_4D.csv`.
5. **Menor:** `correlaciones()` (línea 132) pone los nombres de las competencias sin comprobar el orden de los
   factores que devuelve `mirt`. En esta corrida el orden es el correcto (sección 9.4); la propuesta es agregar un
   `stopifnot()` para que siga así si cambia la sintaxis.

### 9.4 Reproducción del 5.3 y pruebas numéricas (2026-10-23, de 19:35 a 19:59)

- **Cómo se hizo:** copia aparte de `main` (`3dc44d3`), fuera del proyecto y de OneDrive, sin cachés de modelos.
  - Entradas: `COL_cognitivo.rds` de `datos/`, y `COL_nse.rds` y `COL_nse_tri.rds` de la reproducción de la sección 6.3.
    `03_nse_medicion.R` no cambia entre `152691a` y `3dc44d3`.
  - Se corrieron `05_explorar_items.R` y `05_tri_competencias.R` **hasta la línea 148** (fin del 5.3), copiado sin
    cambios, para no correr el 5.3b ni el 5.4.
- **Resultado:** `mat_ajuste.csv` es igual al de `main` salvo en la columna de minutos (1D 3,1 frente a 7; 4D 20,8
  frente a 45,3). Coinciden la convergencia, las iteraciones (123 y 258), la log-verosimilitud, los parámetros, el AIC,
  el BIC y las correlaciones mínima y máxima. `mirt` repite el aviso de que la log-verosimilitud bajaba cerca de la
  solución.
- **Matriz completa de correlaciones del modelo 4D** (salida de consola del 5.3 en la copia; en el proyecto no queda
  en ningún archivo, hallazgo 4):

  | | Emplear | Formular | Interpretar | Razonar |
  |---|---|---|---|---|
  | Emplear | 1 | 0,940 | 0,951 | 0,976 |
  | Formular | 0,940 | 1 | 0,897 | 0,945 |
  | Interpretar | 0,951 | 0,897 | 1 | 0,906 |
  | Razonar | 0,976 | 0,945 | 0,906 | 1 |

  - El orden de los factores que devuelve `mirt` es `EMP FOR INT RAZ`, el mismo que asume `correlaciones()`: el
    hallazgo 5 no produce un error aquí.
- **Error de la integración con 1.000 puntos** (`revisar_unidades_y_logLik.R`): la log-verosimilitud de cada modelo,
  con sus parámetros fijos en los estimados, se recalculó con más puntos QMC.

  | Puntos QMC | 1D | 4D | Ganancia del 4D | Diferencia de BIC (4D − 1D) |
  |---|---|---|---|---|
  | 1.000 (los del 5.3) | −99.810,19 | −99.797,32 | 12,9 | +27,3 |
  | 5.000 | −99.809,82 | −99.794,96 | 14,9 | +23,3 |
  | 10.000 | −99.809,60 | −99.794,83 | 14,8 | +23,5 |
  | 20.000 | −99.809,54 | −99.794,87 | 14,7 | +23,7 |

  - Con 1.000 puntos, el modelo de 4 dimensiones subestima su log-verosimilitud en unos 2,5 puntos, y el de 1, en
    unos 0,7. Entre 5.000 y 20.000 puntos, el de 4 dimensiones varía menos de 0,15 y el de 1, menos de 0,3.
  - Con eso, el BIC sigue favoreciendo al de 1 dimensión, por 23,7 en vez de 27,3. Para invertirlo, la ganancia
    tendría que llegar a 26,5 (= 6 · ln 6.886 / 2), y está en 14,7. El AIC favorece al de 4, por 17,3 en vez de 13,8.
  - **Se confirma la interpretación de Vanessa** (plan 07, 5.3): el aviso de `mirt` es del tamaño del ruido de la
    integración y no cambia la condición del BIC.
  - *Límite:* los parámetros se dejaron fijos en los estimados con 1.000 puntos. Reestimar con más puntos podría
    subir un poco la log-verosimilitud y mover las correlaciones; eso no se probó.
- **Q3 dentro de las unidades (P1 de D-27 punto 9; `revisar_q3_unidades.R`):** como el 3.3b de la F3, sin pesos y con
  el corte |Q3| > 0,2. En el modelo de 4 dimensiones, las EAP salen de integración QMC.

  | Tipo de par | Pares | Mediana de estudiantes con los dos ítems | Q3 medio (1D / 4D) | Marcados 1D | Marcados 4D |
  |---|---|---|---|---|---|
  | Misma unidad, competencias distintas | 133 | 760 | 0,030 / 0,032 | 4 (3,0 %) | 4 (3,0 %) |
  | Misma unidad, misma competencia | 68 | 722,5 | 0,027 / 0,012 | 2 (2,9 %) | 1 (1,5 %) |
  | Unidades distintas, ≥ 200 estudiantes | 3.342 | 242 | — | 45 (1,3 %) | 52 (1,6 %) |
  | Unidades distintas, de 50 a 199 | 10.950 | 104 | — | 923 (8,4 %) | 917 (8,4 %) |
  | Unidades distintas, < 50 | 6.540 | 26 | — | 2.697 (41,2 %) | 2.711 (41,5 %) |

  - Entre unidades distintas, el Q3 medio es −0,028 (1D) y −0,027 (4D), cerca del −1/28 = −0,036 que se espera bajo
    independencia con 29 ítems por estudiante. Otros 5.763 pares no tienen ningún estudiante en común.
  - Los pares marcados entre unidades distintas se concentran donde hay pocos estudiantes en común (41,5 % con menos de
    50); con 200 estudiantes o más, la proporción baja al 1,6 %. *Interpretación de Claude:* es lo que se espera del
    ruido de muestreo con pocos estudiantes por par, no una señal de dependencia.
  - **Dentro de las unidades la dependencia es baja.** En el modelo de 4 dimensiones hay 5 pares marcados en **4 de
    las 76 unidades**: *Triangular Pattern* (emplear–formular 0,354 y formular–razonar 0,213), *Chance of Rain*
    (emplear–razonar 0,292), *Walk to School* (emplear–emplear 0,220) y *Cash Withdrawal* (emplear–formular 0,213).
  - El modelo de 4 dimensiones baja el Q3 de los pares de la misma competencia (de 0,027 a 0,012) y no el de los
    mixtos (de 0,030 a 0,032). Va en la dirección del supuesto 2, pero el tamaño es pequeño: unos 0,06 por encima de
    la referencia entre unidades.
  - *Interpretación de Claude:* una dependencia de este tamaño no parece capaz de explicar correlaciones de 0,90 a
    0,98, aunque no se puede descartar que las suba un poco. Medirlo exigiría un modelo con factores por unidad, que
    con estos datos tiene el mismo riesgo de no ser viable que el bifactor (D-29).

### 9.5 Pruebas de robustez: borrador de decisión (propuesta de Claude; la decide el equipo)

> [!note] Número (2026-11-10)
> Este borrador se llamó «D-32» el 2026-10-23. Vanessa registró D-32 el 2026-11-08 para otra decisión (con qué puntajes
> se responde O4 después de rechazar H8), así que esta propuesta queda **sin número**. Las menciones a «D-32» de las
> secciones 9.5 a 9.7 se refieren a este borrador, no a la D-32 del registro.

- **Marco:** H8 ya está decidida con la regla preregistrada, y eso no cambia. Lo que sigue es **exploratorio y
  posterior a ver el resultado**. Si el equipo lo acepta, va a [[03 Registro de decisiones]] con el número libre que
  toque, antes de programarlo, con la lectura de cada prueba fijada antes de correrla.
- **Qué busca:** saber si la conclusión depende de los dos supuestos de la sección 9.2 que podrían subir las
  correlaciones: la independencia local dentro de las unidades y la omisión calificada como 0.

| Prueba | Qué se hace | Costo aproximado | Lectura fijada antes de correr (propuesta) |
|---|---|---|---|
| R1. P1 de D-27 | Q3 dentro de las unidades, en 1D y 4D, sin pesos y con el corte \|Q3\| > 0,2 (D-21). Ya está decidida; solo falta programarla en el proyecto | Minutos | Se informa cuántos pares se marcan, separando los de la misma competencia y los mixtos |
| R2. Versión (c) | Calibrar 1D y 4D con toda omisión faltante y comparar el BIC y las correlaciones con la versión (a) | ~1 h | Si la máxima baja de 0,95, la conclusión depende del tratamiento de la omisión y se informa así; si no baja, es robusta a ese supuesto |
| R3. Un ítem por unidad | Solo si R1 marca muchos pares mixtos: reestimar el 4D con un ítem por unidad (regla fija, por ejemplo, el primero), sin pares dentro de una misma unidad | Menos que el 4D completo (99 ítems) | La misma de R2 |
| R4. Referencia externa | Comparar con las correlaciones entre subescalas de proceso que publique la OCDE, si las publica | Lectura | No está en el vault ni lo he verificado: hay que buscar la fuente y abrir su nota en `Literatura/` |

- **No se propone:**
  - cambiar la configuración del bifactor (D-29 lo prohíbe después de conocer el fallo);
  - quitar los pesos: no hay indicio de que sean la causa.
- **Orden recomendado:** R1 primero (ya está decidida y es barata), luego R2. R3 y R4 dependen de lo que salga.
- *Actualización del 2026-10-23:* R1 ya se corrió en la copia como revisión (sección 9.4) y marca pocos pares mixtos
  (4 de 133), así que **R3 no hace falta** por su propia condición. Falta pasar R1 al script del proyecto. La prueba
  abierta que más importa es **R2**.
- *Actualización del 2026-10-23, más tarde:* R2 se corrió en la copia, a pedido de Brayan, sin registrar D-32
  (sección 9.7). La conclusión de H8 es robusta al tratamiento de la omisión.
- **Error estándar de las correlaciones:** con las 80 réplicas BRR serían unas 60 horas (80 × 45 min), lo que es
  inviable. Si el equipo quiere un intervalo, primero hay que ver qué admite `mirt` 1.46.1 con pesos. Por la regla
  preregistrada, no es necesario.

### 9.6 Propuesta de veredicto sobre H8 (la decide Brayan)

- **El rechazo de H8 está bien hecho y se reproduce.** Las bases se construyen como dicen D-13, D-14 y D-27; la
  clasificación y el puntaje coinciden con las fuentes oficiales; la regla del código es la preregistrada; y el 5.3 da
  las mismas cifras en este equipo.
- **Las dos condiciones de la regla se sostienen con lo revisado:**
  - el BIC sigue favoreciendo al modelo de 1 dimensión al corregir el error de la integración (por 23,7);
  - la dependencia dentro de las unidades es baja, así que difícilmente explica la correlación emplear–razonar de 0,976
    (interpretación de Claude; no se puede descartar que la suba un poco).
- **La omisión tampoco cambia el resultado** (R2, sección 9.7): con la omisión como faltante, la regla de H8 tampoco
  se cumple y las correlaciones quedan entre 0,890 y 0,977. La conclusión se sostiene en los dos extremos: la omisión
  como fallo seguro, que es el criterio de la OCDE, y como faltante ignorable.
- **Lo que queda sin probar:** el modelo de propensión latente a omitir (Köhler et al., 2015), un supuesto intermedio
  entre esos dos extremos.
- **Cambios propuestos al proyecto**, ninguno de los cuales cambia H8: los hallazgos 1, 3, 4 y 5 (en el código) y el 2
  (en D-27).

### 9.7 Resultado de R2: la omisión como faltante (2026-10-23, de 21:09 a 21:50)

- **Qué es:** prueba exploratoria posterior al resultado de H8, corrida en la copia aparte a pedido de Brayan y sin
  registrar D-32 (Brayan lo pidió así). La lectura quedó fijada en la sección 9.5 antes de correrla.
- **Cómo se hizo:** script `r2_version_c.R` (scratchpad de Claude) → `r2_ajuste_c.csv` y `r2_correlaciones_c.csv`, solo
  agregados. Es el 5.3 con la matriz (c) y todo lo demás igual: 232 ítems, 2PL y GPCM, pesos normalizados, `QMCEM`
  con 1.000 puntos y log-verosimilitud recalculada con 10.000.
- **Controles previos:** ningún ítem cambia de categorías y ningún estudiante queda sin datos. Hay 173.724 celdas con
  dato (12.490 menos que en (a): las omisiones). La mediana de ítems por estudiante es de 8 en emplear, 4 en
  formular, 6 en interpretar y 6 en razonar.

| | (a) omitida = 0 | (c) omitida = faltante |
|---|---|---|
| Convergencia (iteraciones 1D / 4D) | sí (123 / 258) | sí (1.389 / 294) |
| Ganancia del 4D en log-verosimilitud (10.000 puntos) | 14,8 | 6,3 |
| BIC, 4D − 1D (10.000 puntos) | +23,5 | +40,4 |
| AIC, 4D − 1D (10.000 puntos) | −17,5 | −0,7 |
| Correlación mínima / máxima | 0,897 / 0,976 | 0,890 / 0,977 |
| Regla de H8 | no se cumple | no se cumple |

- Correlaciones de (c), con las de (a) entre paréntesis:
  - emplear–formular 0,935 (0,940);
  - emplear–interpretar 0,952 (0,951);
  - emplear–razonar 0,977 (0,976);
  - formular–interpretar 0,890 (0,897);
  - formular–razonar 0,941 (0,945);
  - interpretar–razonar 0,908 (0,906).
- Las cifras de (a) con 10.000 puntos salen de la sección 9.4; el AIC de (a) con 10.000 puntos se calculó a mano a
  partir de ellas.
- **Lectura fijada (sección 9.5):** la correlación máxima no baja de 0,95, así que **la conclusión de H8 es robusta al
  tratamiento de la omisión**.
- **Error de interpretación de Claude:** la sección 9.2 suponía que contar la omisión como 0 podía subir las
  correlaciones. No es así: cambian 0,007 como máximo.
- *Interpretación de Claude, por discutir:*
  - sin las omisiones, la pequeña ventaja del modelo de 4 dimensiones baja a menos de la mitad (de 14,8 a 6,3) y el
    AIC queda en empate;
  - parte de esa ventaja en (a) parece venir de cómo se reparten las omisiones entre competencias (las preguntas
    abiertas, con más omisión, se concentran en razonar), no de habilidades distintas.
- **Observación:** el modelo de 1 dimensión con (c) necesitó 1.389 iteraciones, frente a 123 con (a). Convergió según
  el criterio de `mirt`, pero no se investigó por qué tardó tanto.
- **Límites:**
  - (c) supone que la omisión es ignorable (MAR);
  - (a) y (c) son los dos extremos, y el modelo de propensión latente no se probó;
  - los parámetros y las correlaciones se estimaron con 1.000 puntos, igual que en el 5.3.

## 10. AFC de los ítems de matemáticas (exploratorio, 2026-11-08 a 2026-11-10)

- **Pedido:** Brayan, el 2026-11-08, antes de redactar el plan B de la F6: verificar que cada ítem de matemáticas mide
  la competencia que dice medir, y solo esa. Se hizo en una copia aparte (scratchpad de Claude) y **sin registrar en el
  03**. El 2026-11-10 se vio que Mateo ya había registrado D-48 con la misma pregunta (sugerencia del profesor de SEM),
  leyendo las cargas del 5.3 sin reestimar.
- **Dónde queda:**
  - resultado completo en [[Hallazgos]], sección final (borrador);
  - scripts `Proyecto_PISA/scripts/05_explorar_afc_0_lectura_viabilidad.R` a `05_explorar_afc_3_diagnostico.R`;
  - salidas `salidas/mat_afc_items_condicional.csv` y `.txt`, `mat_afc_diagnostico.txt` y
    `mat_afc_permutaciones.csv` y `.txt`.
  Nada de esto está en `00_correr_todo.R` ni en `resultados-v1`.
- **Resultado en una línea:** con la regla fijada antes de correr, el AFC **contradice** (A: 173 de 232, 74,6 %). La
  asignación de la OCDE supera a las 19 asignaciones al azar (D), pero las competencias casi no se separan.
- **Errores de Claude, declarados:**
  - estimó de 2 a 5 minutos por ajuste del control D, y tardó unos 30 (32 el primero);
  - la prueba A no distingue la competencia propia de la habilidad general, y el criterio de magnitud de B no filtra
    nada (197 de 232 ítems con alguna carga libre mayor que 1). Los dos criterios se fijaron antes de correr y se
    mantienen, pero no responden del todo la pregunta;
  - un cálculo directo para acelerar el control no reprodujo el control de `mirt` y no se usó.
- **Cómo se corrió:** pruebas por ítem en 106,8 min. El control D se repartió en 3 procesos desde el 2026-11-08 a las
  19:34, con dos pausas pedidas por Brayan (del 08/11 a las 19:38 al 10/11 a las 14:48, y del 10/11 de 16:58 a 19:16).
  Terminó el 2026-11-10 a las 19:54.
- **Borrador de D-49 (propuesta; no registrada):** «Análisis confirmatorio condicional por ítem y control con
  asignaciones al azar (exploratorio, posterior a la G4; complementa D-48 con su opción (d))». Si el equipo lo acepta,
  se registra declarando que se corrió antes de registrarse.
