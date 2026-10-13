# Tabla de decisión

Responsable: Brayan (bloque 3). Borrador del 2026-10-12, redactado con Claude a partir de lo observado en las corridas
del equipo (`experimento/consulta_*.md`). Cada celda lleva evidencia, no opinión. Las filas *Experimento* y *Banco* se
llenan con `Proyecto_PISA/salidas/nsf_proporciones.csv` y `nsf_banco_por_tratamiento.csv` cuando estén los conteos.
Descartar bien se califica igual que elegir bien.

| Criterio | A · Claude sin contexto | B · Zotero + Obsidian (Claude con el vault) | C · NotebookLM |
|---|---|---|---|
| **Contexto cerrado** | No. Responde de memoria; en la consulta de Brayan lo dice él mismo («Respondo de memoria, sin consultar internet») | Sí, si se controla: responde con las notas del vault. En la primera corrida de Mateo leyó fuera del vault (la respuesta de A y `procedencia.csv`) y se descartó; por eso la sesión se abre en `Vault_PISA2022` y existe el protocolo v2 (regla 6) | Sí: solo los documentos cargados en el cuaderno |
| **Cita con localización** | Da DOI, pero ninguna página | Nota del vault + página registrada en la nota y su estado (`por_verificar` / `verificado`); en la consulta de Brayan citó hasta línea de archivo (`Matriz estado del arte.md:57`) | Cita al documento del cuaderno; la página depende del PDF (pendiente de confirmar en las corridas con respuesta) |
| **Privacidad** | El texto de la pregunta va a Anthropic. Sin datos de contraparte | Las notas que lee van a Anthropic al procesarse; los PDF quedan en la máquina y en Zotero. Sin datos de contraparte | Los PDF se suben a Google. Sin datos de contraparte (todo el corpus es público) |
| **Costo** | Incluido en el plan de Claude que ya usa el equipo | Zotero, Obsidian y Git gratis; Claude Code requiere el plan de Claude | Gratis, pero con **límite de fuentes por cuaderno**: el cuaderno compartido se llenó con 13 entradas visibles (4 duplicadas) y no dejó subir el resto del corpus |
| **Exportación a APA 7** | No: hay que rehacer cada referencia a mano y verificarla | Sí: Zotero + Better BibTeX + `apa.csl` generan las referencias del anteproyecto | No exporta referencias |
| **Reproducibilidad** | Baja: sin fuentes y respuesta variable | Media: el vault está versionado en Git y el protocolo también, pero el modelo no es determinista y la sesión puede cargar contexto de la máquina (memoria de Claude Code, `CLAUDE.md`) | Baja: el cuaderno no está versionado, tuvo duplicados y fuentes ajenas al corpus (Avvisati 2020, un PDF de la OCDE sin identificar), y su contenido cambió entre corridas |
| *Abstención observada* | No se abstuvo (consulta de Brayan): dio 6 referencias más 3 «cercanas» | Se abstuvo en la consulta de Brayan y listó 9 fuentes «cercanas» del vault | Se abstuvo en las consultas de Brayan y de Vanessa (oficial); en la de Brayan, en parte porque las fuentes no estaban cargadas |
| *Experimento* | Referencias utilizables (IC 95 %): *pendiente* | *pendiente* | *pendiente* |
| *Banco* | Sostenidas / abstención fuera del corpus: *pendiente* | *pendiente* | *pendiente* |

**Herramienta elegida:** *(propuesta, a confirmar con los conteos)* B · Zotero + Obsidian, con la sesión abierta en
`Vault_PISA2022` y el protocolo v2.

**Por qué:** es la única de las tres que exporta a APA 7, que tiene el sistema versionado (Git) y que deja rastro de la
página y del estado de verificación de cada afirmación; no depende del límite de fuentes de NotebookLM.

**Descartadas y en qué criterio perdieron:**
- **A** pierde en contexto cerrado y en cita con localización: responde de memoria y no da páginas (es el control).
- **C** pierde en reproducibilidad y en costo práctico: el cuaderno compartido llegó a su límite de fuentes, tuvo
  duplicados y documentos ajenos al corpus, y no exporta a APA 7.
