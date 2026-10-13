# Guion de Mateo: el sistema funcionando (minutos 5 a 8)

Unas 430 palabras, unos 3 minutos. El bloque es en vivo: una consulta con su cita y la ruta de abstención. Las cifras son
de `salidas/` y del vault al 2026-10-13; si se vuelve a correr algo, revisar que coincidan.

## Antes de exponer (dejar abierto)

1. App de escritorio de Claude, pestaña **Code**, lista para abrir una sesión nueva en **`Vault_PISA2022`**:
   - modo que pida permiso, no *Auto*;
   - Opus 5.5, esfuerzo Alto.
2. El protocolo v2 copiado en el portapapeles (`protocolo/protocolo_consulta_v2.md`, «Texto para pegar (B)»).
3. `corpus/avvisati2024measurement.pdf` abierto en la página 12 del visor, que es la página impresa 11.
4. Obsidian con la nota `Literatura/avvisati2024measurement`.
5. **Plan B por si algo falla en vivo:** `evaluacion/respuestas_banco_Mateo.md`, sección B, donde está la misma
   consulta ya corrida.

## Lo que se dice

**1. Cómo está montado (40 s).** El sistema tiene cuatro piezas:
- **Zotero:** las 37 fuentes del estado del arte, cada una con una clave fija y su DOI o URL.
- **Carpeta `corpus/`:** los PDF obtenidos (28) con un README de procedencia que genera un script.
- **Vault de Obsidian:** una nota por fuente con la página, una cita corta y un estado: `por_verificar`, `verificado`
  o `sin_origen`. La IA nunca marca nada como verificado.
- **Tabla de trazabilidad:** una fila por cada oración citada del anteproyecto. Hay 41 de 44 firmadas por alguno de
  nosotros con el PDF abierto.

La consulta la hace Claude abierto solo en el vault, con un protocolo que le prohíbe salir de esa carpeta y de
internet.

**2. Una consulta con su cita (60 s).**
- Abro una sesión nueva en el vault, pego el protocolo y pregunto: «Según Avvisati y Wuyts (2024), ¿con qué modelo se
  construye HOMEPOS y cambió en 2022?».
- Responde con la nota, la página 11 y el estado.
- Abro el PDF en esa página y muestro la frase: el procedimiento con TRI unidimensional «no cambió en 2018 ni en
  2022».

**3. Cuando no está en las fuentes (30 s).** Pregunto qué estudio evaluó la invarianza de HOMEPOS entre zonas rurales y
urbanas de Colombia. Responde «No está en las fuentes». En el banco, B se abstuvo en las 3 preguntas de fuera del
corpus, y fue la única herramienta que no respondió nada sin fuente.

**4. Cómo se arranca y se actualiza (25 s).**
- B no tiene índice: lee las notas tal como están. «Reindexar» es traer los cambios con Git y abrir una sesión nueva.
- Agregar una fuente:
  1. guardar el PDF como `corpus/{clave}.pdf`;
  2. crear su nota en `Literatura/`;
  3. correr `nsf_procedencia.R`.

**5. Dónde falla (25 s).** B dice exactamente lo que dicen las notas, con sus errores:
- en el banco repitió el «solo» de la nota de Eriksson, que el artículo no dice;
- por eso una nota solo cuenta como fuente cuando está verificada, y hoy son 8 de 44.

Lo que no le delegamos: marcar algo como verificado y firmar la trazabilidad.

## Preguntas probables

- **«Muéstreme de dónde sale esta frase del anteproyecto».** Busco la oración en `trazabilidad/trazabilidad_Mateo.csv`,
  leo la columna `ubicacion` y abro el PDF en esa página. Si es Rutkowski o Rolfe, abro el DOI: esas dos se verificaron
  solo con el resumen y así está escrito.
- **«¿Cómo se reconstruye el índice desde cero? Muéstreme el comando».** En B no hay índice que reconstruir: se abre una
  sesión nueva en `Vault_PISA2022`, después de traer los cambios con Git. Para la procedencia, desde
  `Proyecto_PISA/scripts/` se corre el script `nsf_procedencia.R`. En C se crea un cuaderno nuevo y se suben los PDF de
  `corpus/`.
- **«Si bajo a un solo fragmento recuperado, ¿qué se rompe?».** En la vía empaquetada no elegimos fragmentos: B abre
  notas completas y C fragmenta por su cuenta. Lo que sí vimos es un fallo de fragmentación en C: dijo que la tabla
  11.A.2 del reporte técnico no traía los datos de Colombia, y sí los trae, en la página 244.
- **«¿Qué no entiende todavía del sistema?».** Cómo decide Claude qué notas abrir, porque no lista los archivos que
  leyó, y cómo parte NotebookLM los PDF con tablas.
- **«¿Qué le corrigió a la IA?».** Tres casos:
  - el enlace al PDF de García llevaba a otro artículo;
  - una corrida de B leyó la respuesta de A y la descartamos;
  - seis oraciones de mi parte del anteproyecto decían más que la fuente.
- **Si me preguntan por la parte de Brayan:**
  - ninguna diferencia del experimento es concluyente: B − A = −0,01 con p = 1, y el kappa de Fleiss es 0,06;
  - elegimos B por el banco y porque no se sale de sus fuentes.
- **Si me preguntan por la parte de Vanessa:** el fallo que más costó fue que NotebookLM atribuyó a Liu (2017) hallazgos
  que el PDF no tiene (`evaluacion/caso_fallo.md`).
