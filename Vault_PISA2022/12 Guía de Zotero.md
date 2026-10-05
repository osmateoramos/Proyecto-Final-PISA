---
tipo: guia
estado: por_verificar
lectura: "redactado por Claude con la documentación oficial de Zotero, Better BibTeX y ZotLit; falta revisión del equipo"
verificado_por:
fecha_verificacion:
---

# Guía de Zotero para el proyecto

Volver a [[00 Inicio]] · Gestión de la información en [[10 Gestión de la información]] · Protocolo en [[11 Protocolo de verificación]]

## Qué es Zotero, en una frase

Zotero es **la biblioteca del proyecto**: guarda cada fuente (artículo, informe, libro) con sus datos correctos y su
PDF, permite leer y subrayar el PDF, y produce las citas y la bibliografía del documento.

## El ciclo de una fuente

```
1. Capturar        2. Leer y subrayar        3. Llevar a Obsidian        4. Citar
─────────────      ──────────────────        ────────────────────        ──────────
Zotero Connector   Lector de PDF de          ZotLit crea o actualiza     Better BibTeX mantiene
(botón del         Zotero: resaltar y        la nota de la fuente con    referencias.bib; el .Rmd
navegador)         anotar con la página      datos y subrayados          cita con [@clave]
```

1. **Capturar.** Con el artículo abierto en el navegador, clic en el botón de **Zotero Connector**: guarda la
   referencia con sus datos reales (autores, año, revista, DOI) y, si está disponible, el PDF. También se puede usar la
   varita de Zotero (*Añadir elemento por identificador*) pegando el DOI.
2. **Leer y subrayar.** Doble clic en el PDF dentro de Zotero. Lo que se resalta queda guardado **con su página**:
   es la evidencia que pide el protocolo de verificación (página + cita textual).
3. **Llevar a Obsidian.** ZotLit crea la nota de la fuente en `Literatura/` y trae los subrayados.
4. **Citar.** Cada referencia tiene una **clave de cita** fija (ej. `icfes2019inse`). Better BibTeX la mantiene y
   genera `referencias.bib`, que usa el anteproyecto: en el `.Rmd` se escribe `[@icfes2019inse]`.

## Qué hace cada pieza que instalamos

| Pieza | Qué hace |
|---|---|
| **Zotero 10** | La biblioteca: referencias, PDF, subrayados, colecciones |
| **Zotero Connector** (navegador) | Guarda en Zotero el artículo que tienes abierto |
| **Better BibTeX** (dentro de Zotero) | Fija las claves de cita y mantiene actualizado el `.bib` del anteproyecto |
| **ZotLit Companion** (dentro de Zotero) | Avisa a Obsidian de los cambios en Zotero |
| **ZotLit** (en Obsidian) | Crea las notas de fuente y trae los subrayados a `Literatura/` |

## Cómo organizar la biblioteca

- **Colección `Proyecto PISA`**: todas las fuentes del proyecto (hoy tiene las 14 del anteproyecto anterior).
- Una fuente puede estar en varias colecciones sin duplicarse.
- **Etiquetas** útiles: `por_verificar`, `verificado`, y el objetivo que sustenta (`O1`…`O5`).

## Compartir con la compañera: grupo de Zotero

- Un **grupo** es una biblioteca compartida: lo que uno agrega o subraya allí lo ve la otra persona.
- Las dos personas necesitan **cuenta de Zotero** (zotero.org) e iniciar sesión en Zotero (*Editar → Configuración → Sincronización*).
- Los PDF del grupo **cuentan contra el almacenamiento del dueño del grupo** (según la ayuda oficial de Zotero).
- Lo que se arrastra de *Mi biblioteca* al grupo queda como **copia separada**: por eso primero se arma el grupo y
  después se vinculan las notas de Obsidian con las referencias del grupo.

### Pasos (orden recomendado)
1. [x] Mateo crea su cuenta en zotero.org e inicia sesión en Zotero (2026-10-05).
   - [ ] Vanessa crea su cuenta, inicia sesión y acepta la invitación al grupo.
2. [x] Mateo crea el grupo **Proyecto Final PISA** (privado; edición y archivos para todos los miembros).
3. [x] Se importa `Proyecto_PISA/anteproyecto/referencias.bib` **directamente en el grupo** (colección *Proyecto PISA*,
   26 referencias). Importar el `.bib` conserva las claves de cita; **arrastrar** desde *Mi biblioteca* no las conserva
   (Better BibTeX les asignó claves largas nuevas; esas 14 copias quedaron en la papelera del grupo).
4. [x] Las 26 notas de `Literatura/` quedaron vinculadas con su referencia del grupo (propiedad `zotero-key`).
5. [ ] Agregar al grupo las fuentes que aún no están (`avvisati2024disengagement`, `oecd2023fichacolombia`,
   `oecd2026pisa2025tr`) con la misma clave de cita que su nota, y adjuntar los PDF.

## Reglas para no equivocarse
- **Fuentes nuevas: importarlas o capturarlas directamente en el grupo**, no en *Mi biblioteca* (al copiar entre
  bibliotecas se pierde la clave de cita).
- Las fuentes que ya tienen nota están vinculadas (`zotero-key`): ZotLit debería reconocerlas en lugar de duplicarlas.
  Comprobarlo con una sola fuente antes de usarlo con todas.
- **No cambiar las claves de cita** de las referencias que ya están en el anteproyecto.
- Toda afirmación que se use en el documento debe tener su subrayado (página) en Zotero y su fila en la nota de la fuente.

## Fuentes de esta guía
- Grupos de Zotero: https://www.zotero.org/support/groups
- Instalación de Better BibTeX: https://retorque.re/zotero-better-bibtex/installation/
- ZotLit (propiedad `zotero-key`): https://zotlit.aidenlx.site/docs/reference/templates/frontmatter
