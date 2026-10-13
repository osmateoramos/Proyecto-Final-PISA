# Consulta de Brayan David Barreto — zona O4 (modelo estructural: NSE → competencias, valores plausibles y pesos)

**Consulta bibliográfica:** ¿Qué estudios estiman, con modelos de ecuaciones estructurales y usando los valores
plausibles y los pesos muestrales de PISA, el efecto del nivel socioeconómico sobre el desempeño en matemáticas, en
total o por subescala?

> Propuesta redactada con Claude el 2026-10-12; Brayan la confirma o la cambia **antes** de correr A.
> Otras candidatas: (a) «¿Qué estudios comparan el efecto del nivel socioeconómico entre las subescalas o procesos de
> matemáticas de PISA?» (es el centro de H5, pero puede tener muy pocos antecedentes) y (b) «¿Cómo se combinan los
> valores plausibles de PISA con las reglas de Rubin en modelos de ecuaciones estructurales?» (metodológica, más
> lejos del tema). Se propone la principal porque es O4 tal cual y el vault ya tiene fuentes para contrastar
> (Chen y Yung, Patsis, Rubin, Rosseel).

**Texto base** (idéntico en A, B y C):

> ¿Qué estudios estiman, con modelos de ecuaciones estructurales y usando los valores plausibles y los pesos
> muestrales de PISA, el efecto del nivel socioeconómico sobre el desempeño en matemáticas, en total o por subescala?
> Dame al menos cinco referencias (autores, año, título, revista y DOI) y, para cada una, qué encontró sobre el tema.

## Tratamiento A — Claude sin contexto

- **Herramienta y versión / modelo:** Claude (chat) — Claude Extra 5.5 (según Brayan)
- **Fecha y hora:** 2026-10-12, noche — *hora por confirmar*
- **Condiciones:** chat nuevo, sin proyecto, sin búsqueda web — *Brayan confirma si fue incógnito o sin memoria*
- **Prompt exacto:** el texto base de arriba, sin cambios.
- **Referencias tomadas para el experimento:** 9 (`referencias_Brayan.csv`, id_local 1–9): las 6 de la lista
  numerada y las 3 que la respuesta menciona después con algún contenido atribuido (Gustafsson et al., 2018; Caro
  et al., 2014; Hopfenbeck et al., 2018). Regla del equipo (2026-10-12): se cuenta toda referencia a la que la
  herramienta le atribuye algo, también las «cercanas»; la abstención se reporta aparte.

- **Respuesta completa** (pegada por Brayan, sin editar):

```
Respondo de memoria, sin consultar internet. Estoy razonablemente seguro de que estas publicaciones existen y de su tema general. Aun así, los DOI, la paginación y los detalles de los resultados pueden tener errores. Tampoco puedo garantizar que cada estudio cumpla exactamente los tres requisitos: SEM, uso de todos los valores plausibles y pesos muestrales, incluidos los de replicación. Conviene verificarlos antes de citarlos.

1. Schmidt, W. H., Burroughs, N. A., Zoido, P., & Houang, R. T. (2015). The role of schooling in perpetuating educational inequality: An international perspective. Educational Researcher, 44(7), 371–386. https://doi.org/10.3102/0013189X15603982
Con PISA 2012 en los países de la OCDE, modelan la relación entre el nivel socioeconómico (NSE), la oportunidad de aprender (la exposición a matemáticas formales) y el desempeño en matemáticas. Los estudiantes de menor NSE tienen menos exposición a contenidos formales, y alrededor de un tercio de la asociación entre NSE y desempeño pasa por esa vía. La conclusión es que la escuela amplifica la desigualdad de origen. Su enfoque es de mediación multinivel, así que conviene revisar si encaja en lo que tú consideras SEM en sentido estricto.
2. Pokropek, A., Borgonovi, F., & Jakubowski, M. (2015). Socio-economic disparities in academic achievement: A comparative analysis of mechanisms and pathways. Learning and Individual Differences, 42, 10–18. https://doi.org/10.1016/j.lindif.2015.07.011
Con PISA 2012, descomponen la asociación entre NSE y matemáticas en un efecto directo y efectos indirectos. Las vías indirectas pasan por las disposiciones y autocreencias del estudiante y por factores escolares como la composición socioeconómica de la escuela. Encuentran que una parte importante del efecto total es indirecta y que el peso de cada vía varía entre países. Recuerdo el enfoque mejor que las cifras concretas.
3. Lee, J. (2014). Universal factors of student achievement in high-performing Eastern and Western countries. Journal of Educational Psychology, 106(2), 364–374. https://doi.org/10.1037/a0035609
Con datos de PISA (creo que de 2003; verifica el ciclo), compara con SEM sistemas de alto desempeño de Asia oriental y de Occidente. Un conjunto pequeño de predictores funciona de forma parecida en todos ellos. La autoeficacia matemática es el predictor más fuerte, y el NSE (ESCS) tiene un efecto positivo consistente pero de menor magnitud.
4. Kalaycıoğlu, D. B. (2015). The influence of socioeconomic status, self-efficacy, and anxiety on mathematics achievement in England, Greece, Hong Kong, the Netherlands, Turkey, and the USA. Educational Sciences: Theory & Practice, 15(5), 1391–1401. https://doi.org/10.12738/estp.2015.5.2731
Con PISA 2012, estima en seis sistemas un modelo estructural donde el NSE influye en el desempeño de forma directa e indirecta. Las vías indirectas son la autoeficacia (positiva) y la ansiedad matemática (negativa). La autoeficacia resulta el predictor más fuerte, y el efecto del NSE es en parte mediado, con magnitudes que varían entre países.
5. Kriegbaum, K., & Spinath, B. (2016). Explaining social disparities in mathematical achievement: The role of motivation. European Journal of Personality, 30(1), 45–63. https://doi.org/10.1002/per.2042
Usa, si recuerdo bien, la extensión longitudinal alemana PISA-I-Plus (2003–2004). Con SEM prueba si la motivación explica las disparidades sociales en matemáticas además de la inteligencia. La motivación media parcialmente la relación entre NSE y logro, con un aporte que va más allá de la inteligencia. Al ser datos nacionales, revisa si trabajaron con valores plausibles o con estimaciones WLE.
6. Güzel, Ç. I., & Berberoğlu, G. (2005). An analysis of the Programme for International Student Assessment 2000 (PISA 2000) mathematical literacy data for Brazilian, Japanese and Norwegian students. Studies in Educational Evaluation, 31(4), 283–314. https://doi.org/10.1016/j.stueduc.2005.11.006
Con SEM (LISREL) y datos de PISA 2000, relacionan variables socioeconómicas y del hogar con la competencia matemática en Brasil, Japón y Noruega. Los patrones difieren entre los tres países. Por ser un estudio temprano, es probable que no trate los valores plausibles como se recomienda hoy, así que conviene verificarlo.

Sobre las subescalas. No recuerdo con seguridad ningún estudio SEM que modele el efecto del NSE por subescala de matemáticas, ni de contenido (cantidad, espacio y forma, cambio y relaciones, incertidumbre y datos) ni de proceso. Esos valores plausibles existen en los ciclos donde matemáticas fue dominio principal: 2003, 2012 y 2022. Puede ser un vacío real en la literatura o algo que simplemente no recuerdo, así que vale la pena buscarlo de forma específica.
Trabajos cercanos que no cumplen todos los criterios. Gustafsson, Nilsen y Yang Hansen (2018, Studies in Educational Evaluation) usan SEM multinivel sobre la relación NSE–matemáticas, pero con TIMSS 2011. Caro, Sandoval-Hernández y Lüdtke (2014, School Effectiveness and School Improvement) modelan capital cultural, social y económico con ESEM en PISA 2009, pero el desempeño analizado es sobre todo lectura.
Nota metodológica para filtrar estudios. El tratamiento correcto en SEM es estimar el modelo con cada valor plausible y combinar los resultados con las reglas de Rubin. En Mplus se hace con `TYPE = IMPUTATION`, y en R con lavaan.survey o semTools junto con survey. Además hay que usar el peso final del estudiante y, para los errores estándar, los 80 pesos de replicación (BRR de Fay). Muchos artículos usan el peso final pero no los de replicación, lo que subestima los errores estándar. Ese es un buen criterio para revisar en la sección de método de cada uno.
Para verificar y ampliar, te sirven tres cosas: la revista Large-scale Assessments in Education, que publica bastante de esto; la revisión sistemática de Hopfenbeck et al. (2018) en Scandinavian Journal of Educational Research; y búsquedas que combinen "PISA", "structural equation", "plausible values", "ESCS" y "mathematics".
```

## Tratamiento B — Zotero + Obsidian (Claude con el vault)

- **Herramienta y versión / modelo:** Claude Code (app de escritorio) — Claude Extra 5.5, el mismo de A (según Brayan)
- **Fecha y hora:** 2026-10-12, noche — *hora por confirmar*
- **Condiciones:** sesión nueva de Claude Code abierta en `Vault_PISA2022`; protocolo v1 pegado antes del texto base;
  sin web. Nota: el vault incluye las notas de la actividad (15, 16 y 17), que la sesión puede leer; no contienen las
  respuestas ni las referencias del tratamiento A de Brayan.
- **Prompt exacto:** texto de `protocolo/protocolo_consulta_v1.md` («Texto para pegar») seguido del texto base.
- **Resultado:** **abstención** («No está en las fuentes.»), con una lista de fuentes del vault que cumplen solo una
  parte de la pregunta.
- **Referencias tomadas para el experimento:** 9 (`referencias_Brayan.csv`, id_local 10–18): las 8 «más cercanas» y
  el manual de Chen y Yung, cada una con lo que la respuesta le atribuye (regla del equipo, ver tratamiento A).

- **Respuesta completa** (pegada por Brayan, sin editar):

```
No está en las fuentes.

Ninguna fuente del vault reúne a la vez las tres condiciones: modelo de ecuaciones estructurales, valores plausibles y pesos de PISA, y efecto del NSE sobre matemáticas. Por eso no puedo darte cinco referencias. La propia matriz dice lo mismo: pone "NSE → procesos, PV + pesos" como aporte de este proyecto y, en el vacío, "Combinación: Ninguno en esta revisión" (Matriz estado del arte.md:57 y :72).

Lo más cercano: cumple solo una parte, no responde la pregunta
Burns, Thorvaldson, Martin y Ginns (2026). "In-test effort in PISA achievement: it makes a difference for students and schools, but not countries". Large-scale Assessments in Education, 14(1), 17. https://doi.org/10.1186/s40536-026-00288-9 · nota
Qué cumple: usa PISA 2022 e incluye a Colombia, n = 7.804 (tabla 1, p. 8). Ajusta un modelo multinivel doblemente latente de 3 niveles, con un análisis por cada valor plausible combinado por imputación múltiple (p. 9).
Qué no cumple: estudia el esfuerzo en la prueba; el NSE solo entra como covariable de control (p. 1, resumen). La nota no registra el coeficiente del NSE ni el uso de pesos muestrales.
Estado: Vanessa la marcó como verificada el 12/10/2026, pero sus filas cotejadas son las de p. 1, 8 y 9 (tabla 2). El dato de los valores plausibles está en "Datos y método", no en esas filas. Claude leyó el resumen, la muestra y las tablas 1–2.
Patsis, Yang Hansen y Klapp (2026). "The role of instructional quality in explaining socioeconomic disparities in mathematics achievement: a multilevel SEM of Swedish TIMSS 2019 data". Large-scale Assessments in Education. https://doi.org/10.1186/s40536-026-00307-9 · nota
Qué cumple: es un SEM de dos niveles sobre matemáticas. El NSE "se mantuvo como predictor robusto en ambos niveles" y la mediación fue limitada (página pendiente).
Qué no cumple: los datos son de TIMSS 2019 Suecia, no de PISA. La nota no menciona valores plausibles ni pesos.
Estado: por_verificar; el equipo leyó el texto completo.
Hernández Padilla y González Montesinos (2011). "Modelo de ecuación estructural que evalúa las relaciones entre el estatus cultural y económico del estudiante y el logro educativo". REDIE, 13(2), 188–203. La nota no tiene DOI, solo el enlace de SciELO México. · nota
Qué cumple: es un SEM con estatus cultural y económico como factores latentes. El factor cultural pesa más sobre el logro (0,28–0,34) que el económico (0,22–0,31) (página pendiente).
Qué no cumple: son datos de México (cuestionarios a padres de 4.911 estudiantes), no PISA. El desenlace es "logro", y la nota no dice que sea matemáticas.
Estado: por_verificar; el equipo leyó el texto completo.
Ekmekci (2013). Disertación de la University of Texas at Austin. No tiene DOI; el enlace es http://hdl.handle.net/2152/21338 · nota
Qué cumple: aplica AFC y SEM a los ítems de matemáticas de PISA 2003–2009, y la evidencia favorece una sola dimensión.
Qué no cumple: no incluye el NSE. Solo se leyó el resumen (OpenAlex).
Con PISA y NSE → matemáticas, pero sin SEM:

Guerra et al. (2026), https://doi.org/10.3389/feduc.2026.1810210. Usa BRR, multinivel y LightGBM. Promedia los valores plausibles y lo reconoce como limitación. Es un resumen automático de la IA. nota
Icfes (2024). El ESCS explica el 16 % de la variación en matemáticas en Colombia (p. 46 del PDF). No hace SEM. nota
Eriksson et al. (2021), https://doi.org/10.3389/feduc.2021.731634. Usa PISA 2018 y 6 dimensiones del NSE, pero no es un modelo latente. nota
Mittal et al. (2022), https://doi.org/10.1186/s40536-022-00132-w. No se sabe qué modelo usa porque solo se leyó el resumen. nota
Para los métodos: el manual de Chen y Yung (2024) trae un SEM multinivel con NSE latente (pp. 370–375). Su nota aclara que no trata pesos, réplicas BRR ni valores plausibles (nota).

Ninguna de estas referencias es una cita de segundo nivel: todas tienen nota propia en el vault. Si esta es tu consulta para el experimento "Nada sin fuente" (O4–O5), puedo registrarla en la nota 16 con este resultado.
```

## Tratamiento C — NotebookLM

### Corrida 1 — cuaderno incompleto (no se usa para el experimento; se conserva como evidencia)

- **Herramienta y versión / modelo:** NotebookLM (cuaderno compartido del equipo)
- **Fecha y hora:** 2026-10-12, noche — *hora por confirmar*
- **Condiciones:** protocolo v1 en *Configurar chat* (cargado por Vanessa). Fuentes en el cuaderno según la captura
  de Brayan: **13 entradas, 9 documentos distintos** (4 duplicados):
  - `10.21031-epod.1122857-2453716.pdf` ×2 → kucam2023examination
  - `10.48146-odusobiad.1731407-50089….pdf` ×2 → celik2025differential
  - `fpsyg-12-657335.pdf` ×2 → liu2021differential
  - `s40536-026-00294-x.pdf` ×2 → calderon2026differential
  - «DETERMINANTES DEL RENDIMIENT…» → collazos2021determinantes
  - `pcerda,+8,+CALIBRACIÓN+CONCU….pdf` → brandt2017calibracion
  - `v48i02.pdf` → rosseel2012lavaan
  - `s40536-020-00086-x.pdf` → avvisati2020measure (no está entre las 36 fuentes del corpus)
  - `7abea67b-en.pdf` → documento de la OCDE sin identificar

  El cuaderno **no** tiene la mayoría del corpus: faltan, entre otras, las fuentes de esta zona (Patsis 2026,
  Burns 2026, Hernández 2011, Guerra 2026, Eriksson 2021, el Technical Report y el informe del Icfes 2024).
- **Prompt exacto:** el texto base; Brayan lo pegó sin el signo «¿» inicial.
- **Resultado:** **abstención**, sin referencias. Con la regla del equipo, C aporta 0 referencias para esta consulta.
  Parte de la abstención se explica porque las fuentes relevantes no estaban cargadas en el cuaderno.

- **Respuesta completa** (pegada por Brayan, sin editar):

```
No está en las fuentes.
```

### Corrida 2 — cuaderno con el corpus (la que cuenta para el experimento)

- **Herramienta y versión / modelo:** NotebookLM (cuaderno compartido del equipo)
- **Fecha y hora:** 2026-10-13, madrugada — *hora por confirmar*
- **Condiciones:** el mismo cuaderno, después de subir los PDF del corpus que faltaban desde `corpus/` (orden del
  plan: tema O4, tema de Mateo, tema de Vanessa, resto). N.º de fuentes cargadas: 27 (según Brayan).
  Protocolo v1 en *Configurar chat*.
- **Prompt exacto:** el texto base.
- **Resultado:** abstención parcial: dice que ninguna fuente cumple a la vez todos los criterios, pero presenta 5
  investigaciones «que más se aproximan» y 2 «complementarias», cada una con contenido atribuido. Con la regla del
  equipo se cuentan las 7 (`referencias_Brayan.csv`, id_local 19–25).
- **Nota de formato:** los números pegados al final de algunas frases y referencias (por ejemplo «14:1712»,
  «731634910») son los marcadores de cita de NotebookLM que se copiaron junto con el texto; los enlaces
  `google.com/url?...` son como NotebookLM muestra los DOI.

- **Respuesta completa** (pegada por Brayan, sin editar):

```
En las fuentes del cuaderno no existen cinco estudios que cumplan simultáneamente y de forma estricta todos los criterios solicitados (es decir: modelamiento por ecuaciones estructurales [SEM], uso explícito de valores plausibles y pesos muestrales de PISA, y estimación específica del efecto del nivel socioeconómico [SES] sobre el rendimiento en matemáticas en total o por subescalas).
Las fuentes disponibles incluyen investigaciones que abordan estos elementos de manera desagregada o aproximada (por ejemplo, estudios que aplican SEM con pesos y valores plausibles pero sobre un factor latente general de logro o en evaluaciones distintas a PISA, o estudios en PISA que modelan el rendimiento matemático a partir del SES pero utilizando regresiones múltiples o modelos multinivel en lugar de SEM).
A continuación se presentan las investigaciones del cuaderno que más se aproximan a estos criterios metodológicos y temáticos, detallando su alcance, especificación técnica y hallazgos:
1. Burns et al. (2026)

* Referencia bibliográfica: Burns et al. (2026). In-test effort and achievement in PISA 2022. Large-scale Assessments in Education, 14:1712.
* Metodología y datos: Utiliza microdatos de PISA 2022 de 36 países de la OCDE (289.044 estudiantes en 10.910 escuelas)3. Estima un modelo de ecuaciones estructurales multinivel de tres niveles doblemente latente (doubly latent three-level SEM) ejecutado en Mplus v8.8 (`type = threelevel`)45. Incorpora los pesos muestrales a nivel de estudiante (`weight`) y de escuela (`b2weight`), y gestiona los 10 valores plausibles mediante imputación múltiple (`type = imputation`)46.
* Particularidad del modelo: El desenlace no son las matemáticas de forma aislada, sino una variable latente general de rendimiento académico, donde los valores plausibles de matemáticas, lectura y ciencias actúan simultáneamente como indicadores continuos debido a su alta correlación ($r > 0.81$)7.
* Hallazgos sobre el nivel socioeconómico: En el nivel 1 (estudiante), el estatus socioeconómico (SES) mostró un efecto estandarizado positivo y estadísticamente significativo sobre el rendimiento académico general ($\beta = 0.21, p < .001$), situándose como uno de los predictores individuales más determinantes junto al esfuerzo en la prueba ($\beta = 0.18, p < .001$)8.

2. Eriksson, Lindvall, Helenius y Ryve (2021)

* Referencia bibliográfica: Eriksson, K., Lindvall, J., Helenius, O., & Ryve, A. (2021). Socioeconomic Status as a Multidimensional Predictor of Student Achievement in 77 Societies. Frontiers in Education, 6:731634. DOI: [10.3389/feduc.2021.731634](https://www.google.com/url?sa=E&q=https%3A%2F%2Fdoi.org%2F10.3389%2Ffeduc.2021.731634)910.
* Metodología y datos: Analiza casi 600.000 estudiantes de 77 países y economías en PISA 2018911. Implementa el software IDB Analyzer para respetar el diseño complejo de muestreo mediante pesos de los estudiantes y los 10 valores plausibles de matemáticas, lectura y ciencias1213.
* Diferencia metodológica: No utiliza modelos de ecuaciones estructurales (SEM), sino regresiones lineales múltiples y descomposiciones de varianza tratando al SES como un predictor multidimensional compuesto por seis variables913.
* Hallazgos sobre el nivel socioeconómico en matemáticas:
   * Los dos predictores del SES con mayor peso independiente sobre el rendimiento matemático son los libros en el hogar (coeficiente medio estandarizado de $0.20$) y la ocupación más alta de los padres ($0.17$)1415.
   * El índice compuesto tradicional de PISA (ESCS) explica en promedio el 13% de la varianza en matemáticas ($R^2 = 0.13$), mientras que el modelo con múltiples predictores socioeconómicos desagregados explica el 17% ($R^2 = 0.17$)16.
   * Las posesiones materiales de riqueza exhiben un efecto independiente cercano a cero o levemente negativo en países con alto índice de desarrollo humano, pero fuertemente positivo en las sociedades menos desarrolladas917.

3. Guerra, Roblez, Vargas, Meneses y Basantes-Andrade (2026)

* Referencia bibliográfica: Guerra, J., Roblez, G., Vargas, V., Meneses, M., & Basantes-Andrade, A. (2026). Digital equity and socioeconomic gradients in PISA 2022 mathematics: an integrated equity-diagnostic framework for Latin America and the Caribbean. Frontiers in Education, 11:1810210. DOI: [10.3389/feduc.2026.1810210](https://www.google.com/url?sa=E&q=https%3A%2F%2Fdoi.org%2F10.3389%2Ffeduc.2026.1810210)1819.
* Metodología y datos: Evalúa 613.744 estudiantes en 80 países en PISA 2022, enfocándose en matemáticas19. Considera el diseño muestral complejo mediante el peso final del estudiante (`W_FSTUWT`) y los 80 pesos de replicación con el método BRR y ajuste de Fay20. El desenlace se mide a través del promedio de los 10 valores plausibles (`MATH_MEAN`)2122.
* Diferencia metodológica: No emplea SEM; utiliza regresiones lineales ponderadas con BRR-Fay, modelos multinivel jerárquicos anidados y algoritmos de machine learning explicable (LightGBM/SHAP)2324.
* Hallazgos sobre el nivel socioeconómico en matemáticas:
   * En América Latina y el Caribe, el gradiente socioeconómico en matemáticas ($\beta_{ESCS}$) presenta una marcada dispersión: va desde pendientes pronunciadas en Chile ($\beta = 25.5$ puntos por unidad de ESCS), Uruguay ($\beta = 24.0$) y Argentina ($\beta = 20.0$), hasta asociaciones considerablemente más débiles en Guatemala ($\beta = 5.5$) y Paraguay ($\beta = 4.9$)25.
   * La descomposición de varianza indica que la mayor proporción de la desigualdad en matemáticas radica a nivel intraescolar e interescolar más que a nivel puramente de país2627.

4. Patsis, Yang Hansen y Klapp (2026)

* Referencia bibliográfica: Patsis, P., Yang Hansen, K., & Klapp, A. (2026). The role of instructional quality in explaining socioeconomic disparities in mathematics achievement: a multilevel structural equation modeling of Swedish TIMSS 2019 data. Large-scale Assessments in Education, 14:34. DOI: [10.1186/s40536-026-00307-9](https://www.google.com/url?sa=E&q=https%3A%2F%2Fdoi.org%2F10.1186%2Fs40536-026-00307-9)28.
* Metodología y datos: Utiliza una muestra representativa de 3.996 estudiantes de 8.º grado en 227 aulas29. Aplica modelos de ecuaciones estructurales multinivel (MSEM) en Mplus 8.6 con estimador MLR, utilizando los pesos muestrales de los estudiantes (`HOUWGT`) y los 5 valores plausibles de matemáticas mediante imputación múltiple (`TYPE = IMPUTATION`)30more_horiz.
* Diferencia respecto a la consulta: Utiliza datos de TIMSS 2019, no de PISA2930.
* Hallazgos sobre el nivel socioeconómico en matemáticas:
   * El estatus socioeconómico (medido a través de los recursos educativos en el hogar, HER) tuvo un efecto positivo y estadísticamente significativo sobre el rendimiento en matemáticas tanto a nivel intra-aula ($\gamma = 18.62, p < .001$) como a nivel inter-aula ($\beta = 35.362, p < .001$)3435.
   * En el modelo de pendientes aleatorias, la varianza de la pendiente del SES no fue estadísticamente significativa entre aulas ($\tau_s = 20.28, p = .13$), lo que demuestra que la relación entre el nivel socioeconómico y el desempeño en matemáticas permanece estable entre los distintos salones de clase3436.

5. Hernández Padilla y González Montesinos (2011)

* Referencia bibliográfica: Hernández, E., & González Montesinos, M. J. (2011). Modelo de ecuación estructural que evalúa las relaciones entre el estatus cultural y económico del estudiante y el logro educativo. Revista Electrónica de Investigación Educativa, 13(2), 188-203. URL: http://redie.uabc.mx/vol13no2/contenido-hernandezglezmontesinos.html37.
* Metodología y datos: Aplica un modelo de ecuaciones estructurales (SEM) estimado en el software EQS 6.1 que incorpora cinco valores plausibles como indicadores observables del logro escolar3839.
* Diferencia respecto a la consulta: No utiliza datos de PISA ni evalúa matemáticas; se basa en la evaluación Excale-00 (tercer grado de preescolar en México) en el área de Lenguaje y comunicación4041.
* Hallazgos sobre el nivel socioeconómico: Descompone el estatus social, cultural y económico (ESCE) en dos variables latentes: Capital Cultural Escolar (CCE) y Nivel Económico (NSE)4243. Aunque ambos factores tienen un efecto positivo y significativo sobre el aprendizaje, el capital cultural ejerce una influencia sustancialmente mayor que el nivel económico de posesiones materiales4043.

Otras investigaciones complementarias en el repositorio

* Rodríguez et al. (2024): Utiliza los 10 valores plausibles y ponderaciones muestrales de PISA 2018 (Colombia) para evaluar determinantes del logro en matemáticas y la brecha rural-urbana mediante regresiones cuantílicas y descomposición Oaxaca-Blinder (no SEM)44more_horiz. Encuentra que las posesiones del hogar tienen una asociación positiva y significativa con matemáticas ($\beta = 30.30$ en rural y $58.43$ en urbano), mientras que los años de educación parental pierden significancia al controlar por otros recursos47.
* Mittal, Scherer y Nilsen (2022): Utiliza Mplus 8.5, pesos muestrales y los 10 valores plausibles de PISA 2018 en Noruega y Suecia (`Large-scale Assessments in Education`, 10:13, DOI: [10.1186/s40536-022-00132-w])4849. No obstante, su objetivo es evaluar la invarianza de medición y el funcionamiento diferencial de ítems (DIF) de la escala HOMEPOS entre estudiantes nativos e inmigrantes usando modelos MIMIC/TRI, y no estimar un modelo estructural del efecto global del SES sobre matemáticas5051.

Tus fuentes actuales no contienen otros artículos empíricos que modelen simultáneamente el efecto del SES sobre matemáticas en PISA bajo modelos de ecuaciones estructurales con valores plausibles y pesos muestrales. ¿Deseas que realice una búsqueda en la web para identificar estudios adicionales publicados en la literatura internacional que cumplan exactamente con esos criterios metodológicos?
```
