# Consulta de Vanessa Acosta — zona O3 (competencias y DIF)

**Consulta bibliográfica:** ¿Qué estudios usan DIF por NSE dentro de las competencias/procesos matemáticos de PISA?

**Texto base** (idéntico en A, B y C):

> ¿Qué estudios usan DIF por NSE dentro de las competencias/procesos matemáticos de PISA? Dame al menos cinco
> referencias (autores, año, título, revista y DOI) y, para cada una, qué encontró sobre el tema.

> El tratamiento C ya se corrió el 2026-10-12 con 4 PDF (nota `16 Experimento Nada sin fuente`). Esa corrida queda
> como **piloto** y caso de fallo; aquí se pega la corrida nueva con el corpus completo.

## Tratamiento A — chat sin contexto

- **Herramienta y versión / modelo:** Claude (claude.ai, chat nuevo)
- **Fecha y hora:** 2026-10-12
- **Condiciones:** chat nuevo, sin proyecto ni archivos, instrucción explícita de no buscar en internet; sin
  indicador de búsqueda en la respuesta (no aparece "buscando" ni fuentes web, a diferencia del primer intento
  que sí mostró "Searched the web")
- **Prompt exacto:**

```
sin buscar en internet responde esta pregunta "¿Qué estudios usan DIF por NSE dentro de las
competencias/procesos matemáticos de PISA? Dame al menos cinco referencias (autores, año, título, revista y
DOI) y, para cada una, qué encontró sobre el tema."
```

- **Respuesta completa:**

```
Voy a responder sin buscar en internet, como pediste. Hay una limitación importante: no puedo verificar DOIs ni
detalles exactos de memoria, y los DOIs son justo lo que más se "alucina". Por eso separo lo que conozco con
razonable confianza de lo que debes verificar, y no te doy DOIs que no pueda respaldar.

Referencias que conozco con confianza razonable

1. Zwick, R., & Ercikan, K. (1989). Analysis of differential item functioning in the NAEP history assessment.
   Journal of Educational Measurement, 26(1), 55-66.
   No es PISA ni matemáticas; antecedente metodológico clásico sobre DIF por grupos sociodemográficos.

2. Le, L. T. (2009). Investigating gender differential item functioning across countries and test languages for
   PISA science items. International Journal of Testing, 9(2), 122-133.
   No es matemáticas ni NSE (es género y ciencias), pero es de los trabajos de DIF en PISA más citados.

3. Grisay, A., & Monseur, C. (2007). Measuring the equivalence of item difficulty in the various versions of an
   international test. Studies in Educational Evaluation, 33(1), 69-86.
   DIF entre países/versiones lingüísticas en PISA (lectura); equivalencia imperfecta entre versiones.

4. Kreiner, S., & Christensen, K. B. (2014). Analyses of model fit and robustness. A new look at the PISA
   scaling model underlying ranking of countries according to reading literacy. Psychometrika, 79(2), 210-231.
   Crítica al modelo de escalamiento de PISA; DIF por país en lectura.

5. Wu, M., & Adams, R. (2006). Modelling mathematics problem solving item responses using a multidimensional
   IRT model. Mathematics Education Research Journal, 18(2), 93-113.
   Ítems de matemáticas de PISA y procesos/dimensiones de resolución de problemas; no es DIF por NSE.

Lo que debo decirte con honestidad: con la información que tengo de memoria, no puedo darte cinco estudios que
sean exactamente "DIF por NSE (ESCS) dentro de los procesos matemáticos de PISA". No recuerdo con certeza un
artículo que haga justo ese cruce, y si te inventara títulos y DOIs para completar la lista, te haría daño en un
trabajo académico.
```

> **Resultado:** 5 referencias entregadas, **ninguna con DOI** (el modelo los omitió a propósito, explicando
> que de memoria se inventan) y ninguna cumple exactamente el cruce pedido (DIF + NSE + procesos matemáticos de
> PISA) — el propio modelo lo advierte. Quedan para clasificar abriendo cada una por título y autor (sin DOI
> directo). Mismo patrón de honestidad que en la corrida anterior: prefiere dar referencias reales pero
> incompletas/adyacentes antes que completar el pedido con datos inventados.

### Comparación secundaria (no oficial) — ChatGPT, mismo prompt
Misma instrucción ("sin buscar en internet"), en ChatGPT: se abstuvo por completo, 0 referencias entregadas —
más conservador que Claude en esta corrida. Entre las dos, Claude dio más para clasificar (5 referencias reales,
sin DOI) mientras ChatGPT no dio nada que clasificar. Útil para discutir en la memoria que el comportamiento de
abstención varía por herramienta incluso bajo la misma instrucción.

## Tratamiento B — Zotero + Obsidian (Claude con el vault)

- **Herramienta y versión / modelo:** Claude (Claude Code, sesión de Vanessa en este repo)
- **Fecha y hora:** 2026-10-12
- **Condiciones:** misma sesión de Claude Code en el repo (ya tenía el vault leído de trabajo previo); protocolo
  v1 aplicado; sin búsqueda web; fuentes permitidas = solo `Vault_PISA2022/Literatura/`
- **Prompt exacto:**

```
¿Qué estudios usan DIF por NSE dentro de las competencias/procesos matemáticos de PISA? Dame al menos cinco
referencias (autores, año, título, revista y DOI) y, para cada una, qué encontró sobre el tema.
```

- **Respuesta completa:**

```
Encuentro 6 fuentes relevantes en el vault. Para cada una, el estado de lectura que tiene registrado (todas son
por_verificar, ninguna confirmada contra el PDF completo por el equipo):

1. Goh, Woo, Lee, Choi y Choi (2024). Detection of differential item functioning in PISA 2022 mathematics test
   using the Rasch tree method. Journal of Educational Evaluation, 37(4), 803-834. DOI: 10.31158/jeev.2024.37.4.803.
   [Solo resumen OpenAlex, el artículo está en coreano]. Detecta DIF en matemáticas de PISA 2022 con árboles de
   Rasch en dos subpruebas (Corea); el NSE está entre las variables de contexto que influyen significativamente
   en el DIF. La nota del vault lo marca como "el antecedente más cercano" a DIF por NSE en matemáticas de PISA
   2022.

2. Kucam y Gülleroğlu (2023). Examination of Differential Item Functioning in PISA 2018 Mathematics Literacy
   Test with Different Methods. DOI: 10.21031/epod.1122857. [Solo resumen]. DIF en matemáticas de PISA 2018
   (Turquía) por sexo y por educación de los padres; un ítem funciona distinto según la educación de la madre.

3. Liu y Bradley (2021). Differential Item Functioning Among English Language Learners on a Large-Scale
   Mathematics Assessment. Frontiers in Psychology, 12, 657335. DOI: 10.3389/fpsyg.2021.657335. DIF en
   matemáticas de PISA 2012 (EE. UU.) entre aprendices de inglés y no aprendices; el NSE se usa como covariable,
   no como grupo de comparación. El vault aclara explícitamente: "No analiza DIF por NSE como tal."

4. García-Medina, Martínez Rizo y Cordero Arroyo (2016). Análisis del funcionamiento diferencial de los ítems
   del Excale de Matemáticas para tercero de secundaria. No es PISA, es el EXCALE de México. DIF severo por NSE
   en 18 de 100 ítems.

5. Çelik y Kaşık (2025). Differential item functioning in PIRLS 2021. DOI: 10.48146/odusobiad.1731407. No es
   PISA ni matemáticas, es PIRLS lectura. DIF por NSE variable según país y método.

6. Calderón, Rodríguez y Cervantes (2026). DIF en Saber 11 (Colombia); no es PISA ni analiza NSE.

No está en las fuentes ningún estudio que cruce explícitamente "DIF por NSE" con los cuatro procesos
matemáticos de PISA (formular, emplear, interpretar, razonar) por separado — la nota 06 Objetivos PISA 2022
señala esto como el vacío de literatura que ocupa el objetivo O3 del propio proyecto.
```

> **Resultado:** 6 referencias entregadas, todas reales y ya existentes en el vault del propio proyecto (no es
> sorpresa: B solo puede citar lo que el equipo ya recopiló). A diferencia de A, aquí sí hay DOI en 4 de las 6
> (las que la nota de la fuente ya tenía registrado). El sistema correctamente distinguió el antecedente más
> cercano (Goh et al.) de los que no aplican directamente (Liu y Bradley, marcado explícitamente como "no analiza
> DIF por NSE como tal" — tomado tal cual de la nota del vault, no inventado). **Límite real de B:** la respuesta
> es tan buena como lo que el equipo ya haya cargado al vault — si una fuente relevante no está en `Literatura/`,
> B tampoco la va a encontrar (a diferencia de un buscador real, que sí podría hallar algo nuevo).

## Tratamiento C — NotebookLM

- **Herramienta y versión / modelo:** NotebookLM
- **Fecha y hora:** 2026-10-12
- **Condiciones:** cuaderno compartido con el equipo (13 fuentes cargadas en total, de los tres); protocolo v1 pegado en *Configurar chat*
- **Prompt exacto (oficial, idéntico al texto base):**

```
¿Qué estudios usan DIF por NSE dentro de las competencias/procesos matemáticos de PISA? Dame al menos cinco
referencias (autores, año, título, revista y DOI) y, para cada una, qué encontró sobre el tema.
```

- **Respuesta completa (oficial):**

```
No está en las fuentes.
```

> **Nota metodológica — abstención por no generalizar el término "NSE":** con el prompt oficial tal cual, el
> sistema se abstuvo aunque la respuesta sí estaba disponible (ver la prueba de diagnóstico abajo). El protocolo
> v1 instruye "no uses conocimiento general" y el sistema no generalizó que "educación de los padres" es un
> componente del NSE (así lo define el propio proyecto en `06 Objetivos PISA 2022`: ST005, ST007, HISCED). Es el
> reverso del caso de fallo de Liu (2017) en el piloto: ahí el sistema inventó de más; aquí se abstiene de más.
> Las dos cosas vienen del mismo protocolo estricto — es un costo real de reducir la invención, no un error
> aislado.

### Prueba de diagnóstico (no oficial, mismo cuaderno) — con el término NSE definido explícitamente

- **Prompt:**

```
¿Qué estudios analizan el funcionamiento diferencial del ítem (DIF) por nivel socioeconómico (NSE) —entendido
como educación de los padres, ocupación o posesiones del hogar— dentro de las competencias o procesos
matemáticos de PISA?
```

- **Respuesta completa:**

```
A partir de la revisión exhaustiva de las fuentes presentes en este cuaderno, se identifican dos estudios directos
(disponibles en texto completo) que analizan el Funcionamiento Diferencial del Ítem (DIF) por nivel socioeconómico
(NSE) o sus componentes dentro de las competencias matemáticas de PISA, así como citas indirectas a otros trabajos
relacionados.

1. Estudios directos presentes en las fuentes (texto completo)

1. Kucam y Gülleroğlu (2023) — 10.21031-epod.1122857-2453716.pdf
Título: Examination of Differential Item Functioning in PISA 2018 Mathematics Literacy Test with Different Methods
Revista: Journal of Measurement and Evaluation in Education and Psychology, 14(2), 128-153
- Abstract (pág. 129): objetivo de determinar si los ítems de matemáticas de PISA 2018 muestran DIF según género y
  nivel educativo de los padres.
- Method/Data (págs. 133-134): muestra de Turquía, PISA 2018 matemáticas (Cuadernillos 1 y 7, 23 y 22 ítems).
- Findings... (págs. 145-146, Figura 10): DIF por nivel educativo del padre y de la madre con Árbol de Rasch (RT).
- Hallazgos: en el Cuadernillo 1, el ítem 11 (CM305Q01S) presentó DIF significativo por educación materna
  (p = 0.041); más fácil para madres con secundaria alta o universidad, más difícil para madres con secundaria
  básica, primaria o primaria incompleta. El ítem mide habilidad visoespacial. En el Cuadernillo 7, RT no detectó
  ningún ítem con DIF por educación de los padres.

2. Liu y Bradley (2021) — fpsyg-12-657335.pdf
Título: Explaining the Achievement Gap Between English Language Learners and Non-English Language Learners in
Mathematics: A Differential Item Functioning Approach
Revista: Frontiers in Psychology, 12, artículo 657335
- Purpose/Measures (págs. 192-198): 76 ítems de matemáticas de PISA 2012 (EE. UU.), DIF entre ELL y no ELL; usa el
  ESCS (HOMEPOS, HISEI, PARED) como medida del NSE a nivel de estudiante.
- Results/Model 2 (págs. 204-207, Tabla 5): HGLM multinivel.
- Hallazgos: el NSE/ESCS fue predictor significativo (p ≤ 0.05) en 4 de 10 ítems con DIF (ítem 61: OR = 1.18).
  Al controlar por NSE y otras covariables, los ítems con DIF bajaron de 10 a 7 y el tamaño del efecto se redujo
  en todos.

2. Referencias indirectas mencionadas dentro de las fuentes (citas de segundo nivel; no se verificaron los
   documentos originales)

- Kamata y Binici (2003) — citada en 10.48146-odusobiad.1731407-5008925.pdf, p. 640/657: DIF por grupos de NSE en
  matemáticas de TIMSS 2003 (EE. UU., no PISA), 8 ítems con diferencias significativas en NSE bajo.
- Liu (2017) — citada en 10.21031-epod.1122857-2453716.pdf, p. 132: compara Árbol de Rasch, Regresión Logística y
  Rasch para DIF por NSE, género, etnia y lengua materna en matemáticas de TIMSS 2011 (no PISA).
- Odabaşı (2019) — citada en 10.48146-odusobiad.1731407-5008925.pdf, p. 640/657: PISA 2015 Turquía, ciencias (no
  matemáticas), Mantel-Haenszel y Regresión Logística, 5 ítems con DIF por NSE, 2 a favor de NSE bajo.
- Ercikan, Roth y Asil (2009) — citada en 10.48146-odusobiad.1731407-5008925.pdf, p. 640/657: PISA 2006 (Canadá,
  Corea, Hong Kong), lectura (no matemáticas), menor NSE con peor desempeño en ítems contextualizados por DIF.
- Martiniello (2008) — citada en 10.48146-odusobiad.1731407-5008925.pdf, p. 640/658: problemas verbales de
  matemáticas en aprendices de inglés en EE. UU.; no se especifica que sea una prueba PISA.
```

> **Lectura de este resultado:** con el término definido explícitamente, el sistema respondió con precisión, citó
> documento y página en cada afirmación directa, y aplicó bien la regla 5 del protocolo en las 5 citas indirectas
> (algo que el piloto de 4 PDF no hizo con Liu 2017). Confirma que la causa de la abstención oficial fue
> puramente la falta de la palabra "NSE" en el prompt, no un problema del corpus ni del cuaderno.
>
> **Actualización (2026-10-12, verificación posterior):** se abrió el texto completo de Çelik y Kaşık (2025) y de
> Rios y Soland (2022) para la trazabilidad. Las 4 citas de segundo nivel que NotebookLM marcó como "no
> verificadas" (Kamata y Binici 2003, Liu 2017, Odabaşı 2019, Ercikan/Roth/Asil 2009) **sí están descritas tal
> cual** en el texto completo de Çelik, p. 639-640 — ver el detalle completo en
> [[Literatura/celik2025differential]]. Siguen sin verificarse contra el documento *original* de cada cita
> secundaria (eso lo decide quien haga la clasificación ciega), pero ya no hay duda de que Çelik las describe
> exactamente así.
