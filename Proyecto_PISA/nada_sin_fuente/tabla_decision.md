# Tabla de decisión

Responsable: Brayan (bloque 3). Borrador del 2026-10-12, actualizado el 2026-10-13, redactado con Claude a partir de
lo observado en las corridas del equipo (`experimento/consulta_*.md`). Cada celda lleva evidencia, no opinión. Las
filas *Experimento* y *Banco* salen de `Proyecto_PISA/salidas/nsf_proporciones.csv` y
`nsf_banco_por_tratamiento.csv`. El experimento ya tiene los tres clasificadores; el banco, los tres (18 preguntas: 15
dentro del corpus y 3 fuera). Descartar bien se califica igual que
elegir bien.

| Criterio | A · Claude sin contexto | B · Zotero + Obsidian (Claude con el vault) | C · NotebookLM |
|---|---|---|---|
| **Contexto cerrado** | No. Responde de memoria; en la consulta de Brayan lo dice él mismo («Respondo de memoria, sin consultar internet») | Sí, si se controla: responde con las notas del vault. En la primera corrida de Mateo leyó fuera del vault (la respuesta de A y `procedencia.csv`) y se descartó; por eso la sesión se abre en `Vault_PISA2022` y existe el protocolo v2 (regla 6) | Sí: solo los documentos cargados en el cuaderno |
| **Cita con localización** | Da DOI, pero ninguna página | Nota del vault + página registrada en la nota y su estado (`por_verificar` / `verificado`); en la consulta de Brayan citó hasta línea de archivo (`Matriz estado del arte.md:57`) | Cita al documento del cuaderno; la página depende del PDF (pendiente de confirmar en las corridas con respuesta) |
| **Privacidad** | El texto de la pregunta va a Anthropic. Sin datos de contraparte | Las notas que lee van a Anthropic al procesarse; los PDF quedan en la máquina y en Zotero. Sin datos de contraparte | Los PDF se suben a Google. Sin datos de contraparte (todo el corpus es público) |
| **Costo** | Incluido en el plan de Claude que ya usa el equipo | Zotero, Obsidian y Git gratis; Claude Code requiere el plan de Claude | Gratis. Al intentar subir más PDF al cuaderno compartido apareció el aviso «Tu cuaderno ha alcanzado el límite de fuentes» |
| **Exportación a APA 7** | No: hay que rehacer cada referencia a mano y verificarla | Sí: Zotero + Better BibTeX + `apa.csl` generan las referencias del anteproyecto | No exporta referencias |
| **Reproducibilidad** | Baja: sin fuentes y respuesta variable | Media: el vault está versionado en Git y el protocolo también, pero el modelo no es determinista y la sesión puede cargar contexto de la máquina (memoria de Claude Code, `CLAUDE.md`) | Baja: el cuaderno no está versionado, tuvo duplicados y fuentes ajenas al corpus (Avvisati 2020, un PDF de la OCDE sin identificar), y su contenido cambió entre corridas: 13 entradas (4 duplicadas) en la primera C de Brayan, 36 (32 sin repetidos) en la de Mateo y 27 en la segunda de Brayan |
| **Base verificada** | No aplica: no lee fuentes | Depende del vault: responde con lo que dicen las notas, no con el PDF. De las notas que citó B en el experimento, solo una estaba verificada (Burns, en la consulta de Brayan); hoy hay 8 de 45 verificadas. Lo que esté mal en una nota, B lo repite | Lee el PDF cargado: no hereda errores de las notas, pero sí los del cuaderno (duplicados, documentos ajenos al corpus) |
| *Abstención observada* | No se abstuvo (consulta de Brayan): dio 6 referencias más 3 «cercanas» | Se abstuvo en la consulta de Brayan y listó 9 fuentes «cercanas» del vault. En la de Mateo dio 5 y descartó otras 6 explicando por qué (no cuentan en el experimento) | Se abstuvo en las consultas de Brayan y de Vanessa (oficial); en la de Brayan, en parte porque las fuentes no estaban cargadas |
| *Experimento* | Referencias utilizables: 11/13 = 0,85 (IC 95 %: 0,58–0,96), pero 9 de sus 22 quedaron sin mayoría: según cómo se cuenten, entre 0,50 y 0,91 | 15/18 = 0,83 (0,61–0,94); diferencia con A −0,01 (−0,26 a +0,28). Con las 2 sin mayoría, entre 0,75 y 0,85 | 12/17 = 0,71 (0,47–0,87); diferencia con A −0,14 (−0,40 a +0,17). Con las 2 sin mayoría, entre 0,63 y 0,74 |
| *Banco* | Dentro del corpus: 0/15 sostenidas (IC 95 %: 0–0,20). Se abstuvo en 11 (no conoce los artículos) y en las otras 4 respondió de memoria, sin cita. Fuera: se abstuvo en 2 de 3; en la otra respondió de memoria | Dentro: 12/15 sostenidas (0,80; 0,55–0,93). Se abstuvo en 3 que sí estaban en el corpus porque la nota no tenía el dato, y en otra repitió el «solo» de la nota de Eriksson, el mismo error del anteproyecto (T-Mat-12). Fuera: se abstuvo 3/3, la única sin fallos | Dentro: 15/15 sostenidas (1,00; 0,80–1,00), con más detalle que B (leyó hasta tablas en imagen). Fuera: se abstuvo en 2 de 3; en la de Brayan respondió con conocimiento externo (Colombia en TIMSS 2019), sin fuente |

**Herramienta elegida:** B · Zotero + Obsidian, con la sesión
abierta en `Vault_PISA2022`, el protocolo v2 y **una condición: solo se usa una nota del vault como fuente cuando su
estado es `verificado`**.

**Por qué:** es la única de las tres que exporta a APA 7, que tiene el sistema versionado (Git) y que deja rastro de la
página y del estado de verificación de cada afirmación; no depende de un cuaderno externo cuyo contenido cambió entre corridas. En el
experimento ninguna diferencia es concluyente y el acuerdo entre clasificadores fue bajo (kappa de Fleiss 0,06). El
0,85 de A sale solo de 13 de sus 22 referencias: las otras 9 son de pago y quedaron sin mayoría. Según cómo se
cuenten, A va de 0,50 a 0,91, mientras que B se mueve poco (0,75 a 0,85). Además,
A no da páginas, y en el banco no sostuvo con una fuente ninguna de sus 15 respuestas del corpus. En el banco C fue
la más completa (15/15 frente a 12/15 de B), pero en una pregunta fuera del corpus respondió con conocimiento externo
en vez de abstenerse, que es justo lo que el protocolo prohíbe. B fue la única que se abstuvo en las tres preguntas
fuera del corpus, y sus fallos dentro vinieron de notas incompletas o con errores, que es lo que corrige la condición.

**La condición sale del experimento:** de las notas que citó B, solo una estaba verificada (Burns, en la consulta
de Brayan); las demás estaban `por_verificar`, así que B heredó lo que dijeran. El banco lo confirma: la nota de Collazos dice «MCO», que el artículo no nombra, y no dice que el +1,14
sea en matemáticas, y B se abstuvo por eso; la de Eriksson dice «solo», y B lo repitió. Por eso la tabla de trazabilidad se firma abriendo el PDF y no la nota.

**Descartadas y en qué criterio perdieron:**

- **A** pierde en contexto cerrado y en cita con localización: responde de memoria y no da páginas (es el control).
- **C** pierde en reproducibilidad: el contenido del cuaderno cambió entre corridas, tuvo duplicados y documentos
  ajenos al corpus, no está versionado y no exporta a APA 7. Además, en el banco respondió fuera de sus fuentes.
