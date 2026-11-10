---
tipo: guia
estado: verificado
lectura: búsqueda hecha por Claude con la herramienta de búsqueda web (2026-11-09) y en Scopus con el acceso del CRAI USTA de Mateo, a su pedido (2026-11-10); Google Académico lo corrió Mateo (2026-11-10, página 1) y Claude leyó los resultados; de las fuentes nuevas solo se leyeron resúmenes o fragmentos, ninguna en texto completo
verificado_por: Mateo Ramos
fecha_verificacion: 2026-11-10
---

# Búsqueda formal de novedad (paso 7.2, D-45 punto 4)

Volver a [[Literatura/Matriz estado del arte]] · Decisión en [[03 Registro de decisiones]] (D-45) · Hallazgos en [[Hallazgos]]

> [!warning] Alcance real de esta búsqueda
> - **Herramienta:** buscador web general de Claude Code (2026-11-09), con filtros de dominio para SciELO
>   (`scielo.org`, `scielo.org.co`, `scielo.org.mx`) y Redalyc (`redalyc.org`). **Scopus** se consultó el 2026-11-10
>   (sección «Búsqueda en Scopus» abajo) y **Google Académico** el mismo día, solo la página 1 de cada cadena (sección
>   «Búsqueda en Google Académico»).
> - Cinco páginas no se pudieron abrir (errores de red o PDF sin texto legible). De los antecedentes nuevos solo se
>   conoce lo que mostró el resultado de búsqueda: **autores, años y hallazgos están por verificar** contra el original.
> - Un resultado de búsqueda que no encuentra antecedentes **no prueba** que no existan.

## Cadenas usadas (2026-11-09)

| # | Candidato | Cadena | Filtro |
|---|---|---|---|
| 1 | K1, K3 | PISA 2022 Colombia mathematics processes formulate employ interpret socioeconomic status | ninguno |
| 2 | K1, K3 | procesos matemáticos PISA 2022 Colombia nivel socioeconómico formular emplear interpretar | ninguno |
| 3 | K1 | PISA 2022 mathematics process subscales socioeconomic gap differs formulating interpreting reasoning secondary analysis | ninguno (búsqueda extendida) |
| 4 | K2 | socioeconomic gradient mathematics private public schools Colombia PISA interaction ESCS sector | ninguno |
| 5 | K2 | PISA Colombia nivel socioeconómico matemáticas colegios privados públicos | SciELO y Redalyc |
| 6 | K2 | socioeconomic status slope stronger in private schools mathematics Latin America PISA heterogeneity gradient school type | ninguno |
| 7 | K4 | rapid omissions disengagement response time socioeconomic achievement gap PISA mathematics | ninguno |
| 8 | K4 | omitted responses scored as incorrect versus missing effect on socioeconomic achievement gap PISA | ninguno |
| 9 | K5 | differential item functioning socioeconomic status PISA mathematics items Latin America | ninguno |
| 10 | K5 | funcionamiento diferencial de los ítems nivel socioeconómico matemáticas Colombia prueba | SciELO, Redalyc y revistas.unal.edu.co |

## Qué se encontró, por candidato

| Candidato | ¿Antecedente para Colombia con el mismo resultado? | Lo más cercano (según el resultado de búsqueda; por verificar) |
|---|---|---|
| **K1** NSE más asociado con interpretar que con emplear | **No se encontró.** Las fuentes dan la brecha por NSE solo para matemáticas total (79 puntos Q4 − Q1 y 16 % de varianza, nota de país de la OCDE) y dicen que Colombia está bajo el promedio OCDE en los 4 procesos | Informe de ACER para Australia: los estudiantes de NSE alto superan a los de NSE bajo en **todas** las subescalas de contenido y proceso (no dice si la brecha cambia entre procesos). Un documento de Oxford (ORA) que analiza los subdominios de proceso: título, autores y hallazgos sobre NSE **no verificados** (el PDF no se pudo leer) |
| **K2** pendiente del NSE mayor en colegios privados | **No se encontró** un estudio que pruebe la interacción NSE × sector en Colombia con PISA | Preprint en Research Square «Within- and between-school socioeconomic inequality in concurrent low performance. Evidence from PISA 2025 Colombia» (autores y año no verificados). Un estudio longitudinal PISA 2009–2022 (revista JOSPOE, UAM) sobre la brecha público–privado en Colombia (título no verificado). Para Argentina, PISA 2015: la brecha público–privado desaparece al controlar el NSE (atribuido a Quiroz, Dari y Cervini, 2018; no verificado). Ninguno compara pendientes |
| **K3** NSE asociado con las 4 competencias | Es conocido para matemáticas total (nota de país de la OCDE; Icfes, 2024, ya en la matriz) | — |
| **K4** tratar las omisiones rápidas como faltantes no cambia la brecha por NSE | **No se encontró** un análisis que descomponga la brecha por NSE según el tratamiento de las omisiones | OCDE, *Education Working Paper* n.º 279, «Developing measures of engagement in PISA»: los estudiantes de NSE bajo muestran más desenganche (autores no verificados). Un estudio sobre PISA 2018 matemáticas que compara omitida = incorrecta frente a modelos de faltantes y encuentra medias de país que cambian (atribuido a Robitzsch, *European Journal of Investigation in Health, Psychology and Education*, 2021, 11(4), 117; no verificado). Jerrim y coautores sobre la robustez de PISA al modelo de escalamiento (UCL Discovery; título completo y año no verificados) |
| **K5** DIF por NSE escaso y no concentrado en interpretar y formular | **No se encontró** un DIF por NSE con ítems de PISA en Colombia ni en América Latina | García-Medina et al. (2016), Excale de México: 18 de 100 ítems con DIF severo por NSE (ya en la matriz). Un estudio en *Psicothema* con TERCE (15 países, ciencias): DIF en el 32 % de los ítems, ligado al desarrollo humano del país (título y año no verificados) |

## Búsqueda en Scopus (2026-11-10)

- **Cómo:** Mateo entró a Scopus con su usuario por el CRAI de la USTA y pidió a Claude correr las cadenas en su
  navegador. Se usó la búsqueda avanzada con `TITLE-ABS-KEY` (título, resumen y palabras clave). Se leyeron los títulos
  de todos los resultados y los resúmenes de los relevantes; ningún texto completo.
- **Prueba de la sintaxis:** `TITLE-ABS-KEY ( pisa AND "mathematical process*" )` da 14 documentos y la misma frase sin
  comodín, 13: los comodines dentro de comillas funcionan, así que los ceros de abajo son ceros reales.
- **Búsquedas de control:** `TITLE-ABS-KEY ( pisa AND colombia )` da **43 documentos** (se revisaron los 43 títulos)
  y `TITLE-ABS-KEY ( pisa AND colombia AND mathematic* AND socioeconomic )` da 1 (Ortega et al., 2026, sobre brechas
  de género en matemáticas en América Latina). Por sus títulos, y por el resumen en los dos que comparan colegios
  públicos y privados, ninguno de los 43 prueba alguno de los 5 resultados para Colombia. *Por leer:* Flores-Mendoza et
  al. (2021), *Frontiers in Education*, 6, 632289, que usa ítems de PISA con inteligencia y NSE en América Latina; por
  el título no parece DIF, pero no se leyó su resumen.

| # | Candidato | Cadena en Scopus | Resultados | Qué apareció |
|---|---|---|---|---|
| 1 | K1, K3 | `TITLE-ABS-KEY ( pisa AND colombia AND mathematic* AND ( socioeconomic OR "socio-economic" OR escs ) AND ( formulat* OR interpret* OR "mathematical process*" OR subscale* ) )` | 0 | — |
| 2 | K1, K3 | `TITLE-ABS-KEY ( pisa AND colombia AND matematic* AND ( socioeconomic* OR "nivel socioeconomico" ) AND ( formular OR interpretar OR emplear OR "procesos matematicos" ) )` | 0 | — |
| 3 | K1 | `TITLE-ABS-KEY ( pisa AND mathematic* AND ( "process subscale*" OR "mathematical process*" OR ( formulat* AND interpret* ) ) AND ( socioeconomic OR "socio-economic" OR escs ) AND ( gap OR gradient OR inequalit* ) )` | 0 | — (sin país: tampoco hay un estudio internacional de la brecha por NSE entre procesos) |
| 4 | K2 | `TITLE-ABS-KEY ( pisa AND colombia AND ( socioeconomic OR escs ) AND ( "private school*" OR "public school*" OR "school type" OR "school sector" ) )` | 0 | — |
| 5 | K2 | `TITLE-ABS-KEY ( pisa AND colombia AND ( "colegios privados" OR "colegios publicos" OR "sector privado" OR "tipo de colegio" ) AND ( socioeconomic* OR "nivel socioeconomico" ) )` | 0 | — |
| 6 | K2 | `TITLE-ABS-KEY ( pisa AND ( "latin america*" OR colombia OR chile OR mexico OR argentina OR peru OR brazil ) AND ( "socioeconomic gradient" OR "socioeconomic slope" OR ( socioeconomic W/5 interaction ) ) AND ( "private school*" OR "school type" OR "school sector" ) )` | 0 | — |
| 7 | K4 | `TITLE-ABS-KEY ( pisa AND ( "rapid guessing" OR "rapid omission*" OR disengagement OR "response time*" ) AND ( socioeconomic OR escs ) AND ( gap OR achievement ) )` | 1 | Costa y Chen (2023), *Large-scale Assessments in Education*, 11(1), 5: datos de proceso y variables de contexto en estudiantes escandinavos, PISA 2012 (solo título; no es Colombia ni trata las omisiones) |
| 8 | K4 | `TITLE-ABS-KEY ( pisa AND ( "omitted response*" OR "missing response*" OR omission* ) AND ( "scored as incorrect" OR "treated as missing" OR "missing data" OR scoring ) AND ( socioeconomic OR escs OR gap ) )` | 1 | Marôco y von Davier (2026), *International Journal of Testing*, 26(1), 38–53: imputación del NSE en PIRLS (no es el tema) |
| 9 | K5 | `TITLE-ABS-KEY ( "differential item functioning" AND ( socioeconomic OR "socio-economic" OR escs ) AND ( pisa OR "large-scale assessment*" ) AND mathematic* )` | 0 | — |
| 10 | K5 | `TITLE-ABS-KEY ( "funcionamiento diferencial" AND ( socioeconomic* OR "nivel socioeconomico" ) AND matematic* )` | 1 | García-Medina, Martínez Rizo y Cordero Arroyo (2016), *Revista Mexicana de Investigación Educativa*, 21(71), 1191–1220: el Excale de México, ya en la matriz |

Una versión más amplia de la 9 (DIF por NSE en matemáticas con América Latina, TERCE o PISA, sin exigir «large-scale»)
también da 1 documento: el mismo de García-Medina et al. (2016).

**Lo más cercano a K2 que tiene Scopus** (resúmenes leídos en Scopus; ninguno prueba si la pendiente del NSE cambia
entre sectores):

- Castro Aristizabal, Giménez y Pérez Ximénez-de-Embún (2017), *Revista de Educación*, 376, 33–59: descomponen con
  Oaxaca-Blinder la brecha público–privado en 8 países de América Latina con PISA 2012; según el resumen, Colombia y
  México tienen la brecha más baja y la explican sobre todo las características individuales y familiares.
- De Jorge-Moreno, Castro, Vega y Gutiérrez (2018), *Desarrollo y Sociedad*, 80, 89–118: eficiencia de colegios
  públicos y privados en Colombia con PISA 2012 (fronteras order-m y metafrontera).
- Quiroz, Dari y Cervini (2018), *REICE*, 16(4), 79–97: en Argentina, con PISA 2015, la brecha público–privado
  desaparece al controlar el origen social del estudiante y la composición del colegio.
- Delprato y Antequera (2021), *International Journal of Educational Development*, 84, 102404: eficiencia de colegios
  públicos y privados con PISA para el Desarrollo (Ecuador, Guatemala, Honduras y Paraguay).

**Antecedentes nuevos de la tabla de arriba que Scopus confirma** (autores, año y revista según el registro de Scopus;
el contenido sigue por verificar en el texto completo):

- Quiroz, Dari y Cervini (2018): confirmado (ver arriba).
- Robitzsch (2021), «On the treatment of missing item responses in educational large-scale assessment data: An
  illustrative simulation study and a case study using PISA 2018 mathematics data», *European Journal of Investigation
  in Health, Psychology and Education*, 11(4), 1653–1687. *Corrección:* «117» era el número del artículo en la URL de
  MDPI, no la página.
- Jerrim, Parker, Choi y coautores (2018), «How robust are cross-country comparisons of PISA scores to the scaling
  model used?», *Educational Measurement: Issues and Practice*, 37(4), 28–39.
- El estudio de *Psicothema* con TERCE es Woitschach, Zumbo y Fernández-Alonso (2019), *Psicothema*, 31(2), 194–203.
  Su resumen dice que el 32 % de los ítems de ciencias tienen DIF y que la fuente principal es el nivel de desarrollo
  humano del país (entre países, no por NSE del estudiante).
- No están en Scopus (o no aparecieron): el informe de ACER, el documento de Oxford, el preprint de Research Square, el
  artículo de JOSPOE y el *Working Paper* 279 de la OCDE.

## Búsqueda en Google Académico (2026-11-10)

- **Cómo:** Mateo corrió las 10 cadenas en Google Académico desde otro computador (en el suyo Google bloqueó las
  consultas por «tráfico automatizado»), con «Cualquier momento», orden por relevancia y cualquier idioma, y copió la
  **página 1** de cada búsqueda (10 resultados) en un Word. Claude leyó los títulos y fragmentos. Para los posibles
  antecedentes buscó el resumen público en la web el mismo día; ninguno se leyó en texto completo.
- Google Académico busca en el texto completo, así que el número de resultados es aproximado y sirve poco; lo que cuenta
  es si entre los primeros aparece un estudio con el mismo resultado para Colombia.

| # | Candidato | Cadena en Google Académico | Resultados (aprox.) | Lo relevante en la página 1 |
|---|---|---|---|---|
| 1 | K1, K3 | `PISA Colombia socioeconomic mathematics "formulating" "employing" "interpreting"` | 134 | Wu (2025), *International Electronic Journal of Mathematics Education* (ERIC): PISA 2022, las 4 subescalas de proceso; el fragmento nombra a Colombia y a «students from wealthier» hogares. Revisado el 2026-11-10: **no es antecedente** (ver abajo). De Bortoli y Underwood (2025), ACER, Australia |
| 2 | K1, K3 | `PISA Colombia "nivel socioeconómico" matemáticas "formular" "emplear" "interpretar"` | 938 | Tesis y documentos que citan la definición de PISA («formular, emplear e interpretar»); ninguno compara la brecha por NSE entre procesos |
| 3 | K1 | `PISA "process subscales" mathematics socioeconomic gap` | 45 | Informes nacionales de PISA 2022 de Inglaterra e Irlanda del Norte (Ingram et al., 2023): según el fragmento, revisan «whether gender and socioeconomic gaps are bigger» en algunas subescalas de proceso, **pero en esos países**. Informes de Inglaterra de PISA 2012 y 2018 y Cantillas et al. (2026), Filipinas, sobre NSE y subescalas |
| 4 | K2 | `PISA Colombia "socioeconomic gradient" "private schools"` | 34 | Carneiro y Toppeta (2022, CAF): brechas por educación de la madre en 3.º y 6.º grado, ligadas a la segregación entre colegios (no la pendiente por sector). Duarte, Bos y Moreno (2010, BID), análisis multinivel del SERCE. Willms (2006) |
| 5 | K2 | `PISA Colombia "nivel socioeconómico" "colegios privados" "colegios públicos" matemáticas` | 459 | Estudios de la brecha público–privado en Colombia (Castro Aristizábal et al., 2017 y 2020; Uribe, 2012; Correa-Fonnegra y Orejuela-Ríos, 2017): explican la brecha, no prueban si la pendiente del NSE cambia entre sectores |
| 6 | K2 | `PISA "Latin America" "socioeconomic gradient" "private schools" interaction` | 38 | Salinas-Contador (2014), tesis sobre sector escolar y estratificación en América Latina con PISA 2009; el fragmento menciona «a significant interaction effect». Revisado el 2026-11-10: **no es antecedente** (ver abajo) |
| 7 | K4 | `PISA "rapid guessing" OR "rapid omissions" socioeconomic gap mathematics` | 99 | Rios y Soland (2022), ya en la matriz. Buchholz, Cignetti y Piacentini (2022), *OECD Education Working Paper*, «Developing measures of engagement in PISA»: el fragmento, sin contexto, dice «effort magnify the socio-economic gap in performance». Ninguno trata Colombia |
| 8 | K4 | `PISA "omitted responses" "treated as missing" OR "scored as incorrect" socioeconomic` | 16 | Sachse, Mahler y Pohl (2019), *Educational and Psychological Measurement*: cómo el tratamiento de la no respuesta afecta las comparaciones entre grupos (incluido el NSE) en evaluaciones internacionales. Köhler, Pohl y Carstensen (2017). Antecedentes del método, no de Colombia |
| 9 | K5 | `PISA "differential item functioning" mathematics "socioeconomic status"` | 944 | Chen y Zumbo (2017), DIF multinivel con datos de PISA; Rutkowski y Rutkowski (2013) y Pokropek et al. (2017), sobre la medición del NSE en PISA (más cerca de la F4 que de K5). Ninguno trata Colombia |
| 10 | K5 | `"funcionamiento diferencial" ítems "nivel socioeconómico" matemáticas Colombia` | 93 | Woitschach y Ortiz (2019), «Funcionamiento diferencial del ítem en la evaluación educativa a nivel América Latina y el Caribe» (icso.org.py): el fragmento menciona PISA 2012, matemáticas y el índice socioeconómico. Revisado el 2026-11-10: **no es antecedente** (ver abajo). Pardo Adames et al. (2023), *Interdisciplinaria*, 40(1): TERCE y procesamiento cognitivo, no DIF por NSE |

**Antecedente que aparece al revisar la cadena 4, leído en texto completo el 2026-11-10:** Duarte, Bos y Moreno
(2010), «¿Enseñan mejor las escuelas privadas en América Latina? Estudio comparativo usando los resultados del SERCE»,
BID, Notas Técnicas n.º 5 ([[Literatura/duarte2010ensenan]]). Con el SERCE de 2006 (3.º y 6.º grado) prueban la
interacción gestión × NSE del estudiante. En el agregado de América Latina solo es significativa en matemáticas de 3.º
(más fuerte en las privadas); **para Colombia ninguna de las 4 es significativa** (pág. 21, tabla 7), y concluyen que la
gestión es «en general neutro» frente a esa asociación (pág. 20). Es el antecedente más cercano a K2: la misma
pregunta, pero en primaria y en 2006.

**Documentos de la búsqueda del 2026-11-09 que Google Académico identifica** (según los resultados, por verificar):

- El documento de Oxford (ORA) que no se pudo leer es el informe nacional de Inglaterra: Ingram, Stiff, Cadwallader,
  Lee y Kayton (2023), «PISA 2022: National report for England».
- El informe de ACER es De Bortoli y Underwood (2025), «PISA 2022. A closer look at mathematics in Australia».
- El *Working Paper* 279 de la OCDE es Buchholz, Cignetti y Piacentini (2022), «Developing measures of engagement in
  PISA».

**Conclusión (interpretación de Claude, por discutir):** ninguna fuente de la página 1 prueba para Colombia K1, K2, K4
o K5. Hay antecedentes **del mismo análisis en otros países o poblaciones**: K1 en Inglaterra, K2 en primaria de
América Latina (Duarte et al., 2010, leído: sin interacción significativa para Colombia en el SERCE de 2006) y K4 en el
método. Esto no quita la novedad para Colombia, pero el informe debe citarlos.

**Los 3 posibles antecedentes que quedaban, revisados el 2026-11-10 (Claude, a pedido de Mateo): ninguno lo es.**

- **Wu (2025)**, *International Electronic Journal of Mathematics Education*, 20(2), em0817
  (https://doi.org/10.29333/iejme/15900; texto completo en ERIC, EJ1469671). Usa PISA 2022 de 6 economías, entre ellas
  Colombia (7.804 estudiantes, pág. 6). Las subescalas de proceso solo aparecen como medias descriptivas (tabla 3,
  pág. 8). Las regresiones usan el puntaje **total** de matemáticas con ESCS como predictor (pág. 10). No compara la
  asociación del NSE entre procesos, así que **no es antecedente de K1**: para K3 confirma lo ya conocido para el total.
- **Woitschach y Ortiz (2019)**, «Funcionamiento diferencial del ítem en la evaluación educativa a nivel América Latina
  y el Caribe», ICSO (Paraguay), Documento de Trabajo n.º 3, informe preliminar del proyecto CONACYT PINV15-1150 (texto
  completo, 30 págs.). Usa el **TERCE** (6.º grado, ciencias y lectura) y busca DIF **por sexo** (el ítem 26 de lectura
  favorece a los varones, pág. 21 del PDF). El NSE entra como variable explicativa del logro, no como grupo del DIF
  (pág. 22). PISA 2012 solo se menciona como antecedente de la evaluación por computador (pág. 4). **No es antecedente
  de K5.**
- **Salinas (2014)**, «Educational Expansion, School Sector and Social Stratification: Changing Mechanisms of
  Educational Inequality in Latin America», tesis doctoral, Pennsylvania State University (autor: Daniel R. Salinas;
  resumen leído en el catálogo ETDA, https://etda.libraries.psu.edu/catalog/22383). Estudia la estratificación entre
  colegios públicos y privados en **Chile y México** con encuestas de movilidad social de hombres adultos (CSMS 2001 y
  EMOVI-2011). **No trata Colombia ni prueba la interacción de K2 con PISA.** *Corrección:* en la tabla de arriba
  figuraba como «Salinas-Contador»; el catálogo da «Salinas, Daniel R».

Con esto, la búsqueda 7.2 cubrió las cuatro fuentes del plan y se revisaron todos los posibles antecedentes que
aparecieron. **Decisión del equipo (2026-11-10):** el criterio 4 deja de ser «provisional» para K1, K2, K4 y K5 (D-45).

## Fuentes de los resultados de búsqueda (URL tal como aparecieron)

- OCDE, nota de país de Colombia PISA 2022: https://www.oecd.org/en/publications/pisa-2022-results-volume-i-and-ii-country-notes_ed6fbcc5-en/colombia_dd5f34d9-en.html
- ACER, informe PISA 2022 de Australia: https://research.acer.edu.au/context/ozpisa/article/1066/viewcontent/PISA22_ACLAM_Report_FINAL.pdf
- Oxford ORA (no legible): https://ora.ox.ac.uk/objects/uuid:13c97a71-afa1-4343-ab46-6b614247ea21/files/r6682x545p
- Research Square, preprint PISA 2025 Colombia: https://www.researchsquare.com/article/rs-11021638
- JOSPOE (UAM), brecha público–privado: https://revistas-new.uam.es/jospoe/article/download/21866/19106/77557
- Quiroz, Dari y Cervini (DOAJ): https://doaj.org/article/4fdd5177aed34285acb8f1000d3c1b84
- OCDE, *Working Paper* 279: https://oecd-ilibrary.org/education/developing-measures-of-engagement-in-pisa_2d9a73ca-en
- Estudio de omisiones en PISA 2018 (MDPI): https://mdpi.com/2254-9625/11/4/117
- Jerrim y coautores (UCL Discovery): https://discovery.ucl.ac.uk/10049242/1/Jerrim_How%20robust%20are%20cross-country%20comparisons%20of%20PISA%20scores%20to%20the%20scaling%20model%20used_AAM.pdf
- García-Medina et al. (2016), SciELO México: https://www.scielo.org.mx/scielo.php?script=sci_arttext&pid=S1405-66662016000401191
- *Psicothema*, DIF con TERCE: https://www.psicothema.com/pi?pii=4533

## Qué falta (equipo)
1. ✅ Scopus y Google Académico (2026-11-10, arriba). Si se quiere más cobertura, revisar también la página 2 de
   Google Académico.
1b. ✅ (2026-11-10) Revisados los posibles antecedentes: Duarte, Bos y Moreno (2010) en texto completo
   ([[Literatura/duarte2010ensenan]], verificado por Mateo y agregado a Zotero); Wu (2025) y Woitschach y Ortiz (2019)
   en texto completo; Salinas (2014) por su resumen. Solo Duarte et al. es antecedente (de K2, en otra población).
2. Abrir los 9 antecedentes nuevos (ACER, Oxford, Research Square, JOSPOE, Quiroz et al., OCDE WP 279, Robitzsch,
   Jerrim et al. y *Psicothema*), crear su nota en `Literatura/` (ZotLit) y corregir esta tabla.
3. Con eso, confirmar o corregir el criterio 4 de cada candidato en [[Hallazgos]].
