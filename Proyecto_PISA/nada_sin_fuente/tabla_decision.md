# Tabla de decisión

Responsable: Brayan (bloque 3). Borrador del 2026-10-12, actualizado el 2026-10-13, redactado con Claude a partir de
lo observado en las corridas del equipo (`experimento/consulta_*.md`). Cada celda lleva evidencia, no opinión. Las
filas *Experimento* y *Banco* salen de `Proyecto_PISA/salidas/nsf_proporciones.csv` y
`nsf_banco_por_tratamiento.csv`. **Son provisionales:** el experimento tiene dos clasificadores (falta Vanessa) y el
banco solo tiene las 6 preguntas de Vanessa (faltan las de Mateo y Brayan). Descartar bien se califica igual que
elegir bien.

| Criterio | A · Claude sin contexto | B · Zotero + Obsidian (Claude con el vault) | C · NotebookLM |
|---|---|---|---|
| **Contexto cerrado** | No. Responde de memoria; en la consulta de Brayan lo dice él mismo («Respondo de memoria, sin consultar internet») | Sí, si se controla: responde con las notas del vault. En la primera corrida de Mateo leyó fuera del vault (la respuesta de A y `procedencia.csv`) y se descartó; por eso la sesión se abre en `Vault_PISA2022` y existe el protocolo v2 (regla 6) | Sí: solo los documentos cargados en el cuaderno |
| **Cita con localización** | Da DOI, pero ninguna página | Nota del vault + página registrada en la nota y su estado (`por_verificar` / `verificado`); en la consulta de Brayan citó hasta línea de archivo (`Matriz estado del arte.md:57`) | Cita al documento del cuaderno; la página depende del PDF (pendiente de confirmar en las corridas con respuesta) |
| **Privacidad** | El texto de la pregunta va a Anthropic. Sin datos de contraparte | Las notas que lee van a Anthropic al procesarse; los PDF quedan en la máquina y en Zotero. Sin datos de contraparte | Los PDF se suben a Google. Sin datos de contraparte (todo el corpus es público) |
| **Costo** | Incluido en el plan de Claude que ya usa el equipo | Zotero, Obsidian y Git gratis; Claude Code requiere el plan de Claude | Gratis, pero con **límite de fuentes por cuaderno**: el cuaderno compartido se llenó con 13 entradas visibles (4 duplicadas) y no dejó subir el resto del corpus |
| **Exportación a APA 7** | No: hay que rehacer cada referencia a mano y verificarla | Sí: Zotero + Better BibTeX + `apa.csl` generan las referencias del anteproyecto | No exporta referencias |
| **Reproducibilidad** | Baja: sin fuentes y respuesta variable | Media: el vault está versionado en Git y el protocolo también, pero el modelo no es determinista y la sesión puede cargar contexto de la máquina (memoria de Claude Code, `CLAUDE.md`) | Baja: el cuaderno no está versionado, tuvo duplicados y fuentes ajenas al corpus (Avvisati 2020, un PDF de la OCDE sin identificar), y su contenido cambió entre corridas |
| **Base verificada** | No aplica: no lee fuentes | Depende del vault: responde con lo que dicen las notas, no con el PDF. Durante el experimento 0 de 43 notas estaban verificadas; hoy 4 de 44. Lo que esté mal en una nota, B lo repite | Lee el PDF cargado: no hereda errores de las notas, pero sí los del cuaderno (duplicados, documentos ajenos al corpus) |
| *Abstención observada* | No se abstuvo (consulta de Brayan): dio 6 referencias más 3 «cercanas» | Se abstuvo en la consulta de Brayan y listó 9 fuentes «cercanas» del vault. En la de Mateo dio 5 y descartó otras 6 explicando por qué (no cuentan en el experimento) | Se abstuvo en las consultas de Brayan y de Vanessa (oficial); en la de Brayan, en parte porque las fuentes no estaban cargadas |
| *Experimento* | Referencias utilizables: 9/10 = 0,90 (IC 95 %: 0,60–0,98) | 8/11 = 0,73 (0,43–0,90); diferencia con A −0,17 (−0,48 a +0,18) | 8/13 = 0,62 (0,36–0,82); diferencia con A −0,28 (−0,56 a +0,08) |
| *Banco* | Dentro del corpus: 0/5 sostenidas, se abstuvo en las 5 (no conoce los artículos). Fuera: se abstuvo 1/1 | Dentro: 5/5 sostenidas y correctas. Fuera: se abstuvo 1/1 | Dentro: 5/5 sostenidas y correctas. Fuera: se abstuvo 1/1 |

**Herramienta elegida:** *(propuesta, a confirmar con los conteos finales)* B · Zotero + Obsidian, con la sesión
abierta en `Vault_PISA2022`, el protocolo v2 y **una condición: solo se usa una nota del vault como fuente cuando su
estado es `verificado`**.

**Por qué:** es la única de las tres que exporta a APA 7, que tiene el sistema versionado (Git) y que deja rastro de la
página y del estado de verificación de cada afirmación; no depende del límite de fuentes de NotebookLM. En el
experimento A tuvo la proporción más alta de referencias utilizables, pero los intervalos se traslapan (ninguna
diferencia es concluyente con unas 10 a 13 referencias por tratamiento) y A no da páginas; en el banco, A no pudo
responder ninguna pregunta concreta del corpus.

**La condición sale del experimento:** B respondió con notas `por_verificar` (0 de 43 verificadas en ese momento), así
que heredó lo que dijeran las notas. Por eso la tabla de trazabilidad se firma abriendo el PDF y no la nota.

**Descartadas y en qué criterio perdieron:**

- **A** pierde en contexto cerrado y en cita con localización: responde de memoria y no da páginas (es el control).
- **C** pierde en reproducibilidad y en costo práctico: el cuaderno compartido llegó a su límite de fuentes, tuvo
  duplicados y documentos ajenos al corpus, y no exporta a APA 7.
