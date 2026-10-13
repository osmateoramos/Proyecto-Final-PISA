# Banco de Mateo: respuestas completas (2026-10-13)

Preguntas M01–M06 de `banco_Mateo.csv`, pegadas juntas en una sola conversación por tratamiento (textos en
`prompts_banco_Mateo.md`). Mateo corrió las tres y pegó las respuestas; Claude las pasó a `banco_Mateo.csv` y las
comparó con la respuesta conocida y su página (ya verificadas por Mateo en su trazabilidad).

- **Quién juzga *sostenida* y *correcta*:** Mateo, a partir de la propuesta de Claude.
- **Convención** (la misma de Brayan):
  - sin cita no hay fragmento que sostenga la respuesta, así que *sostenida* es «no»;
  - si se abstiene, *sostenida* y *correcta* son «no aplica».

## A · Claude sin contexto

- **Condiciones:**
  - Opus 5.5, esfuerzo Alto;
  - el bloque empieza con «Sin buscar en internet»;
  - hacia las 13:15 (aproximada).
  - *Mateo: confirmar chat incógnito y conectores apagados.*

```
Respondo de memoria y te indico mi nivel de confianza en cada caso. Conviene verificar las cifras y las atribuciones contra las fuentes originales antes de citarlas.

M01. El ESCS se construye con tres componentes: el nivel ocupacional más alto de los padres (HISEI), el nivel educativo más alto de los padres expresado en años de escolaridad (PAREDINT) y el índice de posesiones del hogar (HOMEPOS), que incluye el número de libros en casa. Confianza alta.

M02. No tengo la cifra exacta de forma confiable. Recuerdo que la muestra de Colombia rondó los 7.800 estudiantes en unas 250 a 260 escuelas, pero podría equivocarme en los números precisos. La cifra está en las tablas de muestreo del reporte técnico de PISA 2022 (capítulo de resultados de muestreo). Confianza baja en el número exacto.

M03. HOMEPOS se construye con un modelo de teoría de respuesta al ítem (TRI), concretamente un modelo de crédito parcial generalizado, con parámetros internacionales e invarianza parcial (algunos ítems tienen parámetros específicos por país). No puedo confirmar qué dicen exactamente Avvisati y Wuyts (2024) sobre si el procedimiento cambió en 2022. No quiero atribuirles una conclusión que no recuerdo con certeza. Confianza media sobre el modelo, baja sobre el contenido específico del artículo.

M04. Eriksson, Lindvall, Helenius y Ryve (2021) analizaron el NSE como predictor multidimensional en decenas de países con PISA 2018. Hasta donde recuerdo, el número de libros en el hogar fue el componente con mayor poder predictivo, seguido de la educación de los padres. Las posesiones materiales o la riqueza del hogar predecían menos, y el índice compuesto ESCS no superaba a esos componentes por separado. Confianza media.

M05. No recuerdo este estudio con suficiente precisión para decir qué grupos y países comparó ni qué encontró. Prefiero no inventar los detalles. Sin respuesta confiable.

M06. No conozco un estudio que haya evaluado la invarianza de HOMEPOS entre estudiantes rurales y urbanos de Colombia con PISA 2022. Puede que exista y no lo tenga registrado, o que sea un trabajo reciente o no publicado (por ejemplo, uno que estés desarrollando tú). No puedo identificarlo sin riesgo de fabricar una referencia. Sin respuesta confiable.
```

## B · Zotero + Obsidian (Claude Code con el vault)

- **Condiciones:**
  - sesión nueva de Claude Code abierta en `Vault_PISA2022`;
  - protocolo v2 más el bloque de preguntas;
  - hacia las 13:25 (aproximada).
  - La respuesta declara que no abrió nada fuera del vault ni modificó archivos.
  - *Mateo: confirmar modelo (Opus 5.5, Alto) y que no hubo solicitudes de permiso.*

```
Respuestas con base solo en las notas de `Vault_PISA2022/`
M01. No está en las fuentes.
Aclaración: la nota del reporte técnico (Literatura/oecd2024pisa2022tr.md) no registra los componentes del ESCS. Otra fuente del vault, Avvisati y Wuyts (2024), sí los nombra: educación de los padres, ocupación de los padres y posesiones del hogar (Literatura/avvisati2024measurement.md, sección “Qué hace”, sin página). Pero esa no es la fuente por la que preguntas.
M02. No está en las fuentes.
Aclaración: la nota del reporte técnico no trae el tamaño de la muestra de Colombia. Lo que hay en el vault sale de otros documentos:

* 7.804 estudiantes según Burns et al. (2026), tabla 1, p. 8 (Literatura/burns2026intest.md, fila 3).
* 262 colegios según el diccionario de variables, un conteo hecho sobre los datos y no tomado de una fuente (`Datos/PISA2022 - Diccionario de variables.md`, encabezado).

M03. Según Avvisati y Wuyts (2024), HOMEPOS se construye con un modelo de TRI unidimensional, y el procedimiento no cambió en 2018 ni en 2022 (p. 11). En 2022 hubo dos ajustes:

* antes de escalar se agruparon varias categorías de respuesta para alinearlas con los ciclos anteriores (p. 11);
* la escala usa parámetros parcialmente invariantes, unos internacionales y otros por país-idioma (p. 21).

Fuente: Literatura/avvisati2024measurement.md, filas 1–3. Esa nota no viene de una lectura completa: Claude buscó en el texto extraído del PDF. Estado: `por_verificar`.
M04. Según Eriksson et al. (2021), solo dos dimensiones del nivel socioeconómico predicen el logro de forma sustantiva: los libros en casa, que tienen el mayor efecto, y la ocupación de los padres. Fuente: Literatura/eriksson2021socioeconomic.md, fila 1. El equipo leyó el texto completo, pero la página no está registrada en el vault (dice “pendiente”). Estado: `por_verificar`.
M05. Mittal et al. (2022) usaron PISA 2018 de Noruega y Suecia y compararon tres grupos: estudiantes inmigrantes de primera generación, de segunda generación y sin origen inmigrante. Encontraron dos cosas:

* Varios ítems de HOMEPOS presentan DIF dentro de esos países.
* En los estudiantes inmigrantes, la fuerza de la relación entre HOMEPOS y el logro depende de cómo se traten los ítems con DIF. El estudio compara cuatro estrategias para tratarlos.

Fuente: Literatura/mittal2022assessing.md, filas 1–3, p. 1. Es solo el resumen: el cuerpo del artículo no se ha leído. Estado: `por_verificar`.
M06. No está en las fuentes.
Aclaración: el vault registra esa comparación como un vacío que este mismo proyecto propone cubrir: “Por zona, sexo o sector; en Colombia” (`Literatura/Matriz estado del arte.md`, tabla “Qué queda sin hacer”). Está planteada como hipótesis H2 en `09 Hipótesis preregistradas.md`.
No abrí nada fuera del vault ni modifiqué archivos. Si esta corrida es parte del experimento, puedo registrarla en `16 Experimento Nada sin fuente.md` o en `15 Bitácora de uso de IA.md`.
```

## C · Gemini Notebook (NotebookLM)

- **Condiciones:**
  - cuaderno compartido «Proyecto Final»;
  - protocolo v1 en *Personalizar cuaderno*;
  - bloque de preguntas;
  - hacia las 13:20 (aproximada).
  - *Mateo: anotar cuántas fuentes tenía el cuaderno.*
- **Copia de la respuesta:** los números pegados al final de las frases (por ejemplo «12», «34», «more_horiz») son las
  marcas de cita del cuaderno, que se pegaron como texto.

```
M01. Según el reporte técnico de PISA 2022 de la OCDE (`oecd2024pisa2022tr.pdf`, Capítulo 19 "Background Questionnaire Derived Variables", sección "Components of ESCS", pp. 401-402), los tres componentes del índice de estatus económico, social y cultural (ESCS) son12:

1. Estatus ocupacional más alto de los padres (highest parental occupation status, HISEI)2.
2. Nivel educativo más alto de los padres expresado en años de escolaridad (highest education of parents in years, PAREDINT)2.
3. Posesiones del hogar (home possessions, HOMEPOS), el cual se utiliza como un indicador indirecto (proxy) del ingreso o la riqueza familiar2.
4. Documento de origen: `oecd2024pisa2022tr.pdf` (Capítulo 19, pp. 401-402)2.

M02. Si se consulta estrictamente el texto del Reporte Técnico de PISA 2022 de la OCDE (`oecd2024pisa2022tr.pdf`), la tabla que detalla el número de estudiantes y escuelas muestreadas por país (Annex Table 11.A.2, Capítulo 11, p. 244) no incluye el desglose de datos dentro del PDF, sino que remite a la tabla web a través de un enlace de StatLink34. Por lo tanto, respecto a ese documento en particular: No está en las fuentes.
Aclaración sobre otras fuentes del cuaderno: En el informe nacional de resultados para Colombia elaborado con datos proporcionados por la OCDE (`icfes2024pisa.pdf`, Sección 1.2 "Características de PISA 2022", p. 14 y Sección 2 "Caracterización de la población evaluada", p. 20), se reporta que la muestra de Colombia en PISA 2022 contó con 7.804 estudiantes de 262 colegios (o establecimientos educativos)56.

* Documento de origen: `oecd2024pisa2022tr.pdf` (Capítulo 11, Annex Table 11.A.2, p. 244)34 e `icfes2024pisa.pdf` (Sección 1.2, p. 14; Sección 2, p. 20)56.

M03. Según Avvisati y Wuyts (2024) (`avvisati2024measurement.pdf`, OECD Education Working Paper No. 321, Sección "Introduction", p. 7 y Sección 2 "What’s new in the measurement of socio-economic status in PISA? - Changes to scaling procedures: Household possessions", p. 11)78:

* Modelo de construcción: El índice HOMEPOS se construye utilizando modelos de Teoría de Respuesta al Ítem (IRT, por sus siglas en inglés) (item-response-theory models)78.
* ¿Cambió el procedimiento en 2022?: Los procedimientos estadísticos para derivar la escala unidimensional basada en modelos IRT a partir de las respuestas de los estudiantes no cambiaron en 2018 ni en 202289. Sin embargo, la fuente aclara que en 2022 se consideraron las respuestas del propio ciclo 2022 para calibrar el modelo (obteniendo parámetros diferentes) y se aplicó un procedimiento de enlazamiento de parámetros fijos (fixed parameter linking) para recalcular los valores de tendencia comparables con los ciclos de 2012, 2015 y 2018910.
* Documento de origen: `avvisati2024measurement.pdf` (Sección 1, p. 7; Sección 2, pp. 11-12)7more_horiz.

M04. Según Eriksson et al. (2021) (`eriksson2021socioeconomic.pdf`, artículo completo de la revista Frontiers in Education, vol. 6, art. 731634; Abstract, p. 1 y Sección "RESULTS - Table 2", p. 5)1112: Al descomponer el índice socioeconómico de PISA en sus seis variables componentes (estatus ocupacional de los padres, nivel educativo de los padres, posesiones de riqueza, posesiones culturales, recursos educativos en el hogar y libros en el hogar), los dos componentes que predicen mejor el logro académico y superan claramente al resto en la mayoría de las sociedades analizadas son1112:

1. La cantidad de libros en el hogar (books at home) (coeficiente estandarizado medio $M = 0,20$)1112.
2. El estatus ocupacional más alto de los padres (parents' highest occupational status / HISEI) (coeficiente estandarizado medio $M = 0,17$)1112.
3. Documento de origen: `eriksson2021socioeconomic.pdf` (Abstract, p. 1; Sección "RESULTS", p. 5)1112.

M05. Según Mittal, Scherer y Nilsen (2022) (`mittal2022assessing.pdf`, artículo completo de la revista Large-scale Assessments in Education, vol. 10, art. 13; Abstract, p. 2; Sección "Methods - Sample", pp. 7-8; Sección "Results", pp. 14-18; Sección "Discussion", pp. 19-23)13more_horiz:

* Países evaluados: Noruega y Suecia (con datos de PISA 2018)1314.
* Grupos de estudiantes: Tres grupos definidos según su origen migratorio: estudiantes nativos (native), estudiantes inmigrantes de primera generación (first-generation) y estudiantes inmigrantes de segunda generación (second-generation)13more_horiz.
* Hallazgos:
   1. Falta de invarianza global: No se encontró evidencia de invarianza métrica ni escalar completa para la escala HOMEPOS entre los grupos de origen migratorio en Noruega ni en Suecia13more_horiz.
   2. Presencia de DIF: Múltiples ítems mostraron funcionamiento diferencial (DIF). En Noruega, 14 ítems mostraron DIF uniforme (y 1 ítem DIF no uniforme); en Suecia, 19 ítems presentaron DIF uniforme y 8 ítems DIF no uniforme19more_horiz. Los ítems de riqueza material (autos, televisores, baños) y el número de libros tendieron a estar sesgados en contra de los estudiantes inmigrantes, mientras que los ítems de recursos educativos y digitales mostraron mayor probabilidad de respuesta en los grupos inmigrantes a igual nivel de nivel socioeconómico latente19more_horiz.
   3. Efecto en la relación con el rendimiento: La fuerza de la asociación entre HOMEPOS y el rendimiento en lectura fue sensible al enfoque metodológico utilizado para tratar los ítems con DIF en los estudiantes inmigrantes (al eliminar o ajustar los ítems con DIF la relación se fortaleció), mientras que se mantuvo moderada y estable para los estudiantes nativos13more_horiz.
* Documento de origen: `mittal2022assessing.pdf` (Abstract, p. 2; Sección "Methods", pp. 7-8; Sección "Results", pp. 14-18; Sección "Discussion", pp. 19-23)13more_horiz.

M06. Tras revisar detalladamente la totalidad de las fuentes disponibles en este cuaderno sobre PISA 2022 y Colombia, no existe ningún estudio que evalúe la invarianza de medición o el funcionamiento diferencial de los ítems (DIF) del índice HOMEPOS entre estudiantes de zonas rurales y urbanas de Colombia con datos de PISA 2022. Por lo tanto: No está en las fuentes.
```
