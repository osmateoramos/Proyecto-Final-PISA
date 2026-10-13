# Banco de Brayan: respuestas completas (2026-10-13)

Preguntas B01–B06 de `banco_Brayan.csv`, pegadas juntas en una sola conversación por tratamiento (textos en
`prompts_banco_Brayan.md`). Brayan corrió las tres y pegó las respuestas; Claude las pasó a `banco_Brayan.csv` y
comprobó cada cifra en los PDF del corpus. Quién juzga *sostenida* y *correcta*: Brayan, con la propuesta de Claude.

## A · Claude sin contexto

- **Condiciones:** claude.ai en chat incógnito, sin proyecto y sin búsqueda web. *Modelo: por confirmar (Brayan).*

```
Respondo sin buscar en internet. Varias de estas preguntas piden cifras de documentos concretos que no puedo verificar de memoria, así que indico cuándo no tengo el dato en lugar de inventarlo.

**B01.** No recuerdo con fiabilidad el estudio de Collazos et al. (2021) ni la cifra exacta de la diferencia en matemáticas asociada al acceso a internet. Prefiero no darte un número que podría ser incorrecto.

**B02.** Tampoco tengo un recuerdo fiable de Rodríguez-Gómez et al. (2024). Este tipo de estudios suele usar descomposiciones como la de Oaxaca-Blinder para separar la parte de la brecha rural–urbana atribuible a características familiares. Sin embargo, no puedo decirte qué proporción reportan.

**B03.** Sé que en PISA 2022 matemáticas fue el dominio principal y se aplicó por primera vez con un diseño adaptativo multietapa (MSAT). En ese diseño, el estudiante recibe en cada etapa bloques de unidades de mayor o menor dificultad según su desempeño en la etapa anterior. No recuerdo con seguridad el número exacto de ítems ni de unidades. Ese dato está en el informe técnico de PISA 2022, en el capítulo de diseño de la prueba.

**B04.** No recuerdo la cifra exacta que reporta el informe nacional del Icfes para Colombia. Como referencia, en PISA 2022 el estatus socioeconómico explicó en promedio alrededor del 15 % de la variación del desempeño en matemáticas en los países de la OCDE. No puedo confirmar el porcentaje específico de Colombia.

**B05.** No tengo información sobre Patsis et al. (2026). Es muy reciente y puede ser posterior a mis datos de entrenamiento, así que no puedo describir su modelo, sus datos ni cómo tratan los pesos muestrales y los valores plausibles.

**B06.** Hasta donde sé, Colombia no participó en TIMSS 2019. Participó en TIMSS 1995 y 2007, y en 2019 el único país latinoamericano fue Chile. Por eso no hay una cifra de estudiantes colombianos ni un efecto del nivel socioeconómico en esa edición. Puede que la pregunta se refiera a otra edición, por ejemplo TIMSS 2007, o a otra evaluación, como PISA o ERCE.

Si tienes los PDF de estos documentos, puedes subirlos y te extraigo las respuestas exactas con su ubicación en el texto.
```

## B · Zotero + Obsidian (Claude Code con el vault)

- **Condiciones:** sesión nueva de Claude Code abierta en `Vault_PISA2022`, protocolo v2. *Modelo: por confirmar
  (Brayan).* La respuesta declara que solo abrió archivos del vault y que no buscó en internet.

```
Busco en el vault los datos que faltan: diseño adaptativo de PISA 2022 (B03) y TIMSS (B06).
Solo abrí archivos dentro de `Vault_PISA2022/` y no busqué en internet. Ninguna de las cifras de abajo la ha cotejado todavía alguien del equipo contra el original.
B01. No está en las fuentes.
La nota de Collazos et al. (2021) sí trae un valor para internet: "+1,14" (fila 3 de "Afirmaciones que usamos", collazos2021determinantes.md:36). Pero esa fila no dice que sea en matemáticas: la única fila que nombra matemáticas es la del estrato, +0,81 (fila 2). La página está "pendiente". La nota la leyó el equipo en texto completo y está `por_verificar`.
B02. Las características de la familia explican "más del 20 % de la brecha en matemáticas y ciencias, y 32 % en lectura". La cita textual de la nota es "explaining more than 20% of the gap in mathematics and science" (fila 3, rodriguez2024rural.md:37).

* Sin página: Claude leyó el texto completo en la versión HTML de SciELO, que no tiene números de página.
* Estado: `por_verificar`.
* Advertencia de la misma nota (fila 1): hay una inconsistencia interna. El "más del 40 %" se atribuye unas veces solo a los colegios y otras a colegios y familias juntos. Falta cotejarlo en el PDF.

B03.

* Ítems: 234 ítems en un diseño adaptativo multietapa; cada estudiante responde 28–30.
   * Origen: fila 1 de la nota del Technical Report (oecd2024pisa2022tr.md:34). La página está "pendiente".
   * Proviene de un resumen automático del texto completo hecho por la IA. Estado: `por_verificar`.
   * Según el anexo A del Technical Report (fila 9), uno de los 234, `CMA112Q02`, aparece como (Dropped).
* Unidades del diseño: No está en las fuentes.
   * Lo único que hay es un dato contado en la base de Colombia, no una cifra de un documento: "99 unidades (estímulos); 76 con 2 o más ítems, que suman 211 ítems".
   * Lo registra la nota 14 Libros de TRI y SEM.md:62, sección 3. Sale de `revision_pisa2022_col.R` (corrida del 2026-10-05).
   * No lo comprobé en esta sesión: el script está fuera del vault.

B04. 16 %, equivalente a 25 puntos (OCDE 15 %, Latinoamérica 13 %). La cita textual es "la variación en el desempeño explicada por el estatus socioeconómico fue del 16 %" (fila 3, icfes2024pisa.md:37).

* Página: 46 del PDF, ubicada por Claude en el texto extraído. Puede no coincidir con la página impresa.
* Lectura: solo se leyeron las secciones de subescalas y de ESCS, no el informe completo.
* Estado: `por_verificar`.

B05.

* Modelo y datos: es un SEM de dos niveles (el título dice "a multilevel SEM") con datos de TIMSS 2019 de Suecia (patsis2026instructional.md, "Datos y método").
   * Usa el NSE como predictor y la calidad instruccional como variable latente ("Qué hace").
   * El equipo la leyó en texto completo; las páginas de las afirmaciones están "pendientes" y el estado es `por_verificar`.
* Pesos y valores plausibles: No está en las fuentes.

B06. No está en las fuentes.
```

## C · NotebookLM

- **Condiciones:** cuaderno compartido del equipo con **27 fuentes**, protocolo v1 en *Configurar chat*. Las citas
  numeradas de NotebookLM no quedaron en el texto copiado.

```
B01. Según Collazos, Quintero y Trujillo (2021), en el modelo general de combinación de corte transversal (2014-2019), un estudiante que tiene acceso a internet obtiene en promedio 1,14 puntos más en matemáticas en la prueba Saber 11 que un estudiante que no cuenta con dicho servicio. Adicionalmente, en su análisis temporal desagregado tomando como año base el 2014, el efecto inicial fue de 0,523 puntos y se mantuvo con coeficientes positivos y estadísticamente significativos a lo largo de los años evaluados.
B02. De acuerdo con Rodríguez-Gómez, Rodríguez-Gómez y Gomez-Gonzalez (2024), en la descomposición de Oaxaca-Blinder de la brecha rural–urbana en matemáticas (que asciende a una diferencia total de 30,74 puntos a favor de las zonas urbanas), las características de la familia explican 7,761 puntos (p < 0,001). Esto equivale aproximadamente al 25,25 % de la brecha total y al 30,39 % del componente explicado por factores observables. Al estratificar por género, las características familiares explican 6,513 puntos de la brecha en hombres y 8,845 puntos en mujeres.
B03. El diseño adaptativo multietapa (MSAT por computador) de PISA 2022 estuvo compuesto por un banco total de 234 ítems de matemáticas (160 ítems nuevos y 74 de tendencia) agrupados en 99 unidades (56 unidades nuevas y 43 unidades de tendencia). La prueba se estructuró en tres etapas a través de 192 trayectorias adaptativas, en las cuales cada estudiante resolvía una mediana de 13 unidades y 30 ítems de matemáticas.
B04. Según el informe nacional del Icfes sobre PISA 2022, el estatus socioeconómico (medido mediante el índice ESCS) explica el 16 % de la variación del desempeño en matemáticas en Colombia. Esta asociación equivale a una diferencia de hasta 25 puntos en el puntaje de la prueba.
B05. Patsis, Yang Hansen y Klapp (2026) utilizan la siguiente configuración metodológica:

* Tipo de modelo: Modelo de ecuaciones estructurales multinivel de dos niveles (two-level MSEM), estimado en el programa Mplus 8.6 mediante el estimador de máxima verosimilitud robusto (MLR).
* Datos: Datos de corte transversal de Suecia en el ciclo TIMSS 2019 de la IEA, con una muestra representativa de 3.996 estudiantes de 8.º grado en 227 aulas.
* Tratamiento de los pesos: Emplean el peso normalizado de muestreo de estudiantes de TIMSS (`HOUWGT` / house weight) para preservar el tamaño muestral efectivo en el análisis multinivel.
* Tratamiento de los valores plausibles: Incorporan los cinco valores plausibles de rendimiento matemático mediante imputación múltiple a través del comando `TYPE = IMPUTATION` en Mplus.

B06. Colombia no participó en TIMSS 2019, por lo que cero estudiantes colombianos fueron evaluados en dicha aplicación y no existen estimaciones de efecto del nivel socioeconómico sobre matemáticas para el país en ese ciclo. Las fuentes que analizan datos de TIMSS 2019 en este repositorio corresponden exclusivamente a otros países participantes (como Suecia en Patsis et al., 2026), mientras que las evaluaciones internacionales con muestra colombiana reportadas en las fuentes para ese periodo corresponden a PISA (7.522 estudiantes en 2018 y 7.804 en 2022).
🔍 Si te interesa profundizar en alguno de estos puntos, ¿te gustaría que elaboremos un cuadro comparativo detallado sobre cómo se descompone la brecha rural-urbana frente a la brecha público-privada en Saber 11 y PISA?
```

## Qué se comprobó en los PDF (Claude, 2026-10-13)

| Pregunta | A | B | C |
|---|---|---|---|
| B01 | Se abstuvo | Se abstuvo: la nota del vault no dice «matemáticas» (y dice «MCO»); el PDF sí lo dice (pág. PDF 14) | 1,14 (pág. PDF 14) y 0,523 (Tabla 7, pág. PDF 18): correctos |
| B02 | Se abstuvo | «Más del 20 %»: correcto (pág. PDF 3) | 7,761 de 30,74 y 6,513 / 8,845 en la tabla de la pág. PDF 8; los porcentajes los calcula y cuadran |
| B03 | Se abstuvo | 234 ítems y 28-30 por estudiante: correctos (pág. PDF 35); las 99 unidades no las da | Todo correcto (págs. PDF 35, 71 y 72) |
| B04 | Se abstuvo | Correcto (pág. PDF 46) | Correcto (pág. PDF 46) |
| B05 | Se abstuvo | Modelo y datos correctos; pesos y valores plausibles: «No está en las fuentes», aunque el PDF los trae | Todo correcto (págs. PDF 11 a 13) |
| B06 (fuera) | Responde de memoria que Colombia no participó | «No está en las fuentes.» (correcto) | Responde con conocimiento externo que Colombia no participó: ningún documento del corpus lo dice |
