---
tipo: guia
estado: por_verificar
lectura: "redactado por Claude; falta revisión del equipo"
pendientes: "Datos de herramientas (versiones, fechas) y precios de la API: confirmar en las fuentes enlazadas al final de la nota"
verificado_por:
fecha_verificacion:
---

# Gestión de la información

Volver a [[00 Inicio]] · Decisiones D-03, D-04 y D-06 en [[03 Registro de decisiones]]

## La recomendación en una frase

**Zotero guarda las fuentes y Obsidian guarda lo que sabemos, pensamos y decidimos, con su origen y su estado.**
La IA (Claude) trabaja leyendo directamente el vault, siguiendo `CLAUDE.md` y [[11 Protocolo de verificación]].
Un RAG **no** hace falta para gestionar la información de este proyecto (decisión D-06).

| Capa | Herramienta | Para qué | Costo |
|---|---|---|---|
| Fuentes | **Zotero 10** + **Better BibTeX** + Zotero Connector (navegador) | PDF, metadatos, anotaciones; mantiene `referencias.bib` al día con las claves del anteproyecto | Gratis |
| Conocimiento | **Obsidian** + **ZotLit** + **Git** (autor Vinzent03; antes llamado "Obsidian Git") + Templates + **Dataview** | Notas de fuente con página y estado, datos con su script, decisiones, hipótesis; sincronización entre los dos | Gratis |
| Consulta con IA | **Claude Code leyendo el vault** + `CLAUDE.md` | Preguntar y trabajar sobre el material ya organizado, citando nota y origen | Incluido en el plan actual |
| Producto del curso de Python (opcional) | RAG propio: LlamaIndex + Chroma | Solo si el curso lo pide como entregable (confirmar con el profesor) | Ver tabla de costos |
| Apoyo puntual | NotebookLM | Exploración rápida de un PDF | Gratis, **no** para citar |

**Por qué no un RAG para gestionar la información:** un RAG resuelve el problema de buscar en colecciones que no
caben en el contexto de un modelo (miles de documentos, muchos usuarios). Este proyecto tiene unas 40 fuentes y unas
decenas de notas: un modelo actual las puede leer completas. Lo que evita errores no es el RAG sino que **cada
afirmación tenga origen y estado** (ver el protocolo). Un RAG mal alimentado repite errores con apariencia de cita.
**Por qué no NotebookLM como base:** no es reproducible, no se integra con Zotero y se reportan errores de lectura;
cualquier dato que salga de ahí se verifica en el PDF antes de usarlo.

## Instalación (fase F0, ~1 hora)

### Zotero
- [x] **Zotero 10.0.5**, Zotero Connector, **Better BibTeX** y ZotLit Companion instalados (Mateo, 2026-10-04).
  Descarga: https://www.zotero.org/download/ (Vanessa).
- [x] Grupo privado **Proyecto Final PISA**, colección *Proyecto PISA*, con las referencias de
  `Proyecto_PISA/anteproyecto/referencias.bib` importadas con sus claves de cita (2026-10-05). Paso a paso,
  reglas y pendientes en [[12 Guía de Zotero]].
- [ ] **`referencias.bib`** vive en `Proyecto_PISA/anteproyecto/` y por ahora se mantiene a mano, con metadatos de
  Crossref. Si más adelante activan la exportación automática de Better BibTeX (*Exportar colección* → *Mantener
  actualizado*), debe apuntar a ese mismo archivo y exportar la colección del grupo, para no tener dos `.bib` distintos.
- **No cambiar las claves de cita** que ya usa el anteproyecto (`oecd2024pisa2022tr`, `goh2024detection`, …).

### Obsidian
- [x] Abrir el vault (*Open folder as vault* → `CONSULTORIA/Vault_PISA2022`).
- [x] Complementos de la comunidad: **ZotLit**, **Git** (Vinzent03) y **Dataview** (para las tablas de pendientes del
  [[11 Protocolo de verificación]]).
- [x] **ZotLit:** carpeta de notas = `Literatura/`; cada nota de fuente tiene la propiedad `zotero-key` que la une con
  su referencia del grupo.
- [ ] **Git:** el flujo oficial es **GitHub Desktop** (ver `README.md`). El complemento Git de Obsidian es opcional; si
  lo usan, sin commits automáticos, para no mezclar cambios a medio hacer.
- [ ] **Templates** (núcleo): carpeta de plantillas = `Plantillas`.

## Reglas de trabajo

1. **Leer en Zotero, pensar en Obsidian, citar desde el `.bib`.** Una fuente = una nota en `Literatura/`.
2. **Ninguna fuente entra al informe sin nota de lectura completa** (ni las marcadas † en la matriz).
3. **Toda decisión** va a [[03 Registro de decisiones]] **antes** de programarla.
4. **Toda cifra** del informe se anota con el script y el archivo de `salidas/` que la producen.
5. **Reuniones** con tutores → `Reuniones/AAAA-MM-DD Tema.md`.
6. **Hallazgos** → nota `Hallazgos.md` con el criterio de [[08 Rúbrica de desarrollo]].
7. **Nada de datos de estudiantes** en el vault ni en el RAG (Ley 1581 de 2012): solo resultados agregados.

## RAG del proyecto (fase F8, solo si el curso de Python lo pide) — decisiones D-04 y D-06

- **Corpus:** notas del vault + PDF de la colección de Zotero + Technical Report de PISA 2022.
- **Cómo:** fragmentar por encabezados → embeddings locales (gratis) → Chroma → recuperar los fragmentos más
  cercanos → el modelo responde **citando** la nota o el PDF de origen.
- **Evaluación:** 15 preguntas cuya respuesta ya conocen (ej. "¿qué estimador usa el modelo de O4?"); se
  revisa si la respuesta es correcta y si cita bien.
- **Se expone** como endpoint `/preguntar` de la API (O5).

### Costo del modelo de lenguaje (precios oficiales de la API, consultados el 2026-10-01)

Supuesto: ~4.000 tokens de entrada (pregunta + fragmentos) y ~600 de salida por consulta.

| Modelo | Entrada / salida por millón de tokens | Por consulta | 300 consultas |
|---|---|---|---|
| Local con Ollama (llama3.2 3B) | — | $0 | $0 (calidad limitada; el equipo tiene 7,6 GB de RAM: no correrlo junto con R) |
| Claude Haiku 4.5 | US$1 / US$5 | ≈ US$0,007 | ≈ US$2 |
| Claude Sonnet 5.5 | US$2 / US$10 | ≈ US$0,014 | ≈ US$4 |
| Claude Opus 5.5 | US$4 / US$20 | ≈ US$0,028 | ≈ US$8 |

- **El plan Pro de Claude no incluye la API**: se paga aparte con créditos prepagos en la Console de Anthropic.
- En Sonnet y Opus el razonamiento se cobra como salida; con esfuerzo bajo, el costo extra es pequeño.
- Los embeddings locales no tienen costo.

## Fuentes de esta recomendación
- Copilot for Obsidian con modelos locales: https://github.com/logancyang/obsidian-copilot/blob/master/local_copilot.md
- Smart Connections: https://github.com/brianpetro/obsidian-smart-connections
- Obsidian + Zotero (2026): https://vaultpicks.net/obsidian-zotero-academic-research/
- Límites de NotebookLM: https://www.atlasworkspace.ai/blog/notebooklm-limitations
- RAG con FastAPI + LlamaIndex: https://developers.llamaindex.ai/python/examples/usecases/fastapi_rag_ollama/
- Pago de la API de Claude: https://support.claude.com/en/articles/8977456-how-do-i-pay-for-my-claude-api-usage
- Plan Pro y API son productos separados: https://support.claude.com/en/articles/9876003
