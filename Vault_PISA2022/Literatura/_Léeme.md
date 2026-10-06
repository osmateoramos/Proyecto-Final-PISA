# Literatura

Volver a [[00 Inicio]] · Matriz en [[Literatura/Matriz estado del arte]] · Protocolo en [[11 Protocolo de verificación]]

Una nota por fuente. Nombre de archivo = clave bib (ej. `oecd2024pisa2022tr.md`). Las notas nuevas se crean con ZotLit
o con la plantilla [[Plantillas/Nota de lectura]].

**Cómo verificar una fuente:** abrir el PDF en Zotero → por cada fila de "Afirmaciones que usamos" anotar página y
cita textual → cambiar la fila a `verificado` → al terminar todas, cambiar `estado` arriba, con nombre y fecha.
Si `clave_provisional: sí`, confirmar la clave al importar a Zotero y renombrar la nota si cambia.

## Fuentes y su estado (requiere el plugin Dataview)

```dataview
TABLE año, bloque, estado, lectura, verificado_por
FROM "Literatura"
WHERE tipo = "fuente"
SORT bloque ASC, año ASC
```
