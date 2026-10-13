# INVENTARIO DE FALLOS — Brayan David Barreto

Entregable individual (½ página). Lo escribe y lo firma su autor: el diagnóstico no se delega.
Al menos tres fallos propios de IA (en el agente, en el anteproyecto o en otro trabajo). Si cree que no tuvo ninguno,
revise antes las referencias del anteproyecto.

> **BORRADOR.** Claude lo preparó el 2026-10-13 con los hechos de la sesión de trabajo. Brayan: reescríbelo con tus
> palabras, corrige lo que no haya sido así, completa lo que está entre [corchetes] y firma. Si prefieres otro fallo,
> al final hay dos alternativas.

### Fallo 1

- **Herramienta:** Claude Code (Opus 5.5), al descargar los PDF del corpus.
- **Qué generó:** el archivo `corpus/garcia2016analisis.pdf`.
- **Qué estaba mal:** no era García-Medina, Martínez Rizo y Cordero Arroyo (2016), sino otro artículo
  (Gómez-Benito et al., 2010). El nombre del archivo era correcto y el contenido no.
- **Cómo lo detecté:** no lo detecté yo. Lo detectó Mateo al comparar la primera página del PDF con el título de la
  nota.
- **Qué me costó:** reemplazarlo por el PDF correcto de SciELO (RMIE, 2016, págs. 1191-1220) y revisar la primera
  página de los 27 PDF. [tiempo aproximado]
- **Qué lo habría evitado:** comparar el título de la primera página con el registro de Zotero antes de guardar
  cualquier PDF descargado.

### Fallo 2

- **Herramienta:** Claude Code (Opus 5.5), con un script que escribió para comprobar en Crossref las 67 referencias
  de la hoja ciega.
- **Qué generó:** la columna `evidencia` de mi clasificación, con «el registro más parecido» en Crossref.
- **Qué estaba mal:** con las referencias de una sola palabra el script devolvió registros que no tenían nada que
  ver. Por ejemplo, para «Collazos» dio «Artista invitado Francisco Antonio-Collazos» (2018) y para «Cruz», un
  artículo de 1916 sobre Oswaldo Cruz. Yo marqué esas seis referencias como «no existe», y las seis existen en el
  vault.
- **Cómo lo detecté:** al revisar las referencias «Descartadas» del experimento, que eran todas de esa clase.
- **Qué me costó:** contando esas seis, mi proporción de utilizables en B bajaba de 0,50 a 0,38. Hubo que declarar el
  desvío 4, sacarlas del análisis y correr todo de nuevo.
- **Qué lo habría evitado:** que el script marcara «no comprobable» cuando la referencia no trae título, en lugar de
  mostrar la coincidencia más cercana. Y no clasificar con lo automático sin abrir el documento.

### Fallo 3

- **Herramienta:** Claude Code (Opus 5.5), como asistente para planear el experimento.
- **Qué generó:** el plan del experimento, que corrió el tratamiento B con el vault tal como estaba.
- **Qué estaba mal:** no me advirtió que en ese momento ninguna nota del vault estaba verificada (0 de 43). B responde
  con lo que dicen las notas, así que heredó cualquier error que tuvieran.
- **Cómo lo detecté:** al preguntar qué significaba «firmar» la trazabilidad, después del experimento.
- **Qué me costó:** el resultado de B mide notas sin verificar. No se repitió el experimento: se declaró, y la
  decisión quedó con la condición de usar solo notas `verificado`.
- **Qué lo habría evitado:** revisar el estado de las fuentes antes de correr cualquier tratamiento que dependa de
  ellas.

### Alternativas (si prefieres cambiar alguno)

- **Anteproyecto, T-Bra-01.** El texto dice que Collazos et al. (2021) usan mínimos cuadrados ordinarios, pero el
  artículo dice «modelo de combinación de corte transversal». La nota del vault repite el mismo error («Usa MCO»).
  [Confirmar si esa frase se redactó con IA.]
- **Script `leer_csv` de `nsf_comun.R`** (Claude Code). Leía mal los CSV con comillas dobles dentro del texto y las
  duplicaba. Lo detectó Vanessa y se reescribió con `read.table`.

Firma: Brayan David Barreto · Fecha:
