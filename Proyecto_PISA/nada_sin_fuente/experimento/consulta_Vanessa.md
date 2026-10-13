# Consulta de Vanessa Acosta — zona O3 (competencias y DIF)

**Consulta bibliográfica:** ¿Qué estudios usan DIF por NSE dentro de las competencias/procesos matemáticos de PISA?

**Texto base** (idéntico en A, B y C):

> ¿Qué estudios usan DIF por NSE dentro de las competencias/procesos matemáticos de PISA? Dame al menos cinco
> referencias (autores, año, título, revista y DOI) y, para cada una, qué encontró sobre el tema.

> El tratamiento C ya se corrió el 2026-10-12 con 4 PDF (nota `16 Experimento Nada sin fuente`). Esa corrida queda
> como **piloto** y caso de fallo; aquí se pega la corrida nueva con el corpus completo.

## Tratamiento A — Claude sin contexto

- **Herramienta y versión / modelo:** Claude (Claude Code, sesión de Vanessa en este repo)
- **Fecha y hora:** 2026-10-12
- **Condiciones:** ⚠️ **NO es un control limpio** — esta sesión ya había leído a fondo Kucam, Liu y Bradley,
  Goh et al. y otras fuentes reales antes de esta corrida, así que su "memoria" está contaminada por ese
  contexto previo. Se deja documentada por transparencia, pero **no debe usarse como el dato oficial de
  Tratamiento A** en la tabla de conteos — hace falta una corrida en una sesión que de verdad no haya visto
  estos PDF (otra persona del equipo, o un chat nuevo sin este historial).
- **Prompt exacto:**

```
¿Qué estudios usan DIF por NSE dentro de las competencias/procesos matemáticos de PISA? Dame al menos cinco
referencias (autores, año, título, revista y DOI) y, para cada una, qué encontró sobre el tema.
```

- **Respuesta completa:**

```
No tengo cinco referencias que pueda darte con autores, año, título, revista y DOI exactos y con confianza
real de que sean correctos — si te los diera ahora mismo estaría inventando el nivel de detalle que pides. Lo
que sí puedo decirte, con menos precisión: existe investigación sobre funcionamiento diferencial del ítem (DIF)
en PISA matemáticas, usualmente analizada por sexo, idioma o estatus de inmigrante más que por NSE como
variable principal; recuerdo líneas de trabajo sobre invarianza de medición del índice socioeconómico de PISA
(ESCS/HOMEPOS) que tocan preguntas parecidas; y es plausible que haya estudios recientes (2022-2024) usando
árboles de Rasch para detectar DIF en PISA matemáticas por covariables de contexto, aunque no podría asegurarte
autor ni revista exacta sin consultarlo. No doy DOIs: cualquiera que diera ahora sería inventado.
```

> **Nota:** esta respuesta es atípicamente cautelosa para un "chat sin fuentes" real — la mayoría sí inventaría
> los 5 DOIs con confianza. No sirve como ejemplo representativo del control; sirve solo para no mentir en este
> documento. Pendiente: correr A de verdad en una sesión limpia.

## Tratamiento B — Zotero + Obsidian (Claude con el vault)

- **Herramienta y versión / modelo:**
- **Fecha y hora:**
- **Condiciones:** sesión nueva de Claude Code en el repo; protocolo v1 pegado antes del texto base; sin web
- **Prompt exacto:**

```
(pegar)
```

- **Respuesta completa:**

```
(pegar sin editar)
```

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
