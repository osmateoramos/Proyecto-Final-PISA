---
tipo: guia
estado: por_verificar
lectura: "redactado por Claude con Brayan; falta revisión del equipo"
pendientes: "Equipo: aceptar o ajustar las propuestas de las secciones 2, 3.2 y 4"
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

### 3.4 Responsable de F6 (SEM) y F8 (API, tablero y RAG)

No se adelantan fases (regla de `CLAUDE.md`). Al llegar a F6:
- leer Chen y Yung, caps. 8 y 11 ([[14 Libros de TRI y SEM]]);
- resolver si `lavaan` acepta pesos con WLSMV (paso 6.2 del plan).

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
