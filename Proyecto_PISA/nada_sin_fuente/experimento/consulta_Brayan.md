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

- **Herramienta y versión / modelo:** Claude (chat) — *modelo por confirmar por Brayan*
- **Fecha y hora:** 2026-10-12, noche — *hora por confirmar*
- **Condiciones:** chat nuevo, sin proyecto, sin búsqueda web — *Brayan confirma si fue incógnito o sin memoria*
- **Prompt exacto:** el texto base de arriba, sin cambios.
- **Referencias tomadas para el experimento:** las 6 de la lista numerada (`referencias_Brayan.csv`, id_local 1–6).
  Los trabajos que la respuesta menciona después, como «cercanos que no cumplen los criterios» (Gustafsson et al.,
  2018; Caro et al., 2014) o como lectura (Hopfenbeck et al., 2018), no se cuentan, porque la herramienta no los
  propuso como respuesta.

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

- **Herramienta y versión / modelo:**
- **Fecha y hora:**
- **Condiciones:** sesión nueva de Claude Code abierta en `Vault_PISA2022`; protocolo v1 pegado antes del texto base; sin web
- **Prompt exacto:**

```
(pegar)
```

- **Respuesta completa:**

```
(pegar sin editar)
```

## Tratamiento C — NotebookLM

- **Herramienta y versión / modelo:**
- **Fecha y hora:**
- **Condiciones:** cuaderno compartido; n.º de fuentes cargadas: ; protocolo v1 en Configurar chat
- **Prompt exacto:**

```
(pegar)
```

- **Respuesta completa:**

```
(pegar sin editar)
```
