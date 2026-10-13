# Banco de Brayan: textos para pegar en A, B y C

Una conversación nueva por tratamiento, con las 6 preguntas juntas (se declara en la memoria). Las respuestas
conocidas están en `banco_Brayan.csv`: **no abrir ese archivo en la sesión de B**.

Al terminar cada tratamiento, copiar la respuesta completa y pasársela a Claude, indicando de qué tratamiento es, el
modelo y la hora.

## Las 6 preguntas (las mismas en A, B y C)

```
Responde cada pregunta por separado, numerada:

B01. Según Collazos et al. (2021), ¿cuántos puntos más obtiene en promedio en matemáticas de Saber 11 un estudiante que tiene acceso a internet?
B02. Según Rodríguez-Gómez et al. (2024), ¿qué parte de la brecha rural–urbana en matemáticas explican las características de la familia?
B03. ¿Cuántos ítems de matemáticas y cuántas unidades tuvo el diseño adaptativo multietapa de PISA 2022?
B04. Según el informe nacional del Icfes sobre PISA 2022, ¿qué porcentaje de la variación del desempeño en matemáticas de Colombia explica el estatus socioeconómico?
B05. ¿Qué tipo de modelo y qué datos usan Patsis et al. (2026), y cómo tratan los pesos y los valores plausibles?
B06. ¿Cuántos estudiantes colombianos participaron en TIMSS 2019 y qué efecto tuvo su nivel socioeconómico en matemáticas?
```

## A · Claude sin contexto

- Chat nuevo en claude.ai, **sin proyecto** y **sin búsqueda web**.
- Mismo modelo que en la consulta del experimento (Opus 5.5 Extra).
- Se pega solo el bloque de las 6 preguntas.

## B · Zotero + Obsidian (Claude Code con el vault)

- Sesión **nueva** de Claude Code (app de escritorio, pestaña Code) abierta en la carpeta **`Vault_PISA2022`**.
- Se pega primero el protocolo v2 y, debajo, el bloque de las 6 preguntas:

```
Eres un asistente que responde preguntas sobre el proyecto de investigación PISA 2022 Colombia (nivel
socioeconómico, TRI, SEM, competencias matemáticas).

Reglas:
1. Responde solo con información que esté literalmente en las fuentes que se te dieron (los documentos de este
   cuaderno / los archivos de esta carpeta). No uses conocimiento general ni completes con lo que "sueles saber"
   sobre el tema.
2. Cada afirmación debe ir acompañada del documento y la página (o sección) exacta de donde sale.
3. Si una fuente es un resumen o abstract (no el texto completo), dilo explícitamente.
4. Si la respuesta no está en las fuentes que se te dieron, responde exactamente: "No está en las fuentes." No la
   completes de memoria ni inventes una página aproximada.
5. Si citas una referencia que a su vez aparece mencionada dentro de otra (una cita de segundo nivel), aclara que
   es una cita indirecta y que no verificaste el documento original.
6. Solo puedes abrir archivos dentro de la carpeta Vault_PISA2022. No abras ningún archivo fuera de ella (nada en
   Proyecto_PISA/ ni en la raíz del repositorio) y no busques en internet. Si algo no está en el vault, aplica la
   regla 4.
```

- Si pide permiso para leer fuera del vault o para buscar en internet: **negar**. Si lo hizo igual, la corrida se
  descarta y se repite.

## C · NotebookLM

- Cuaderno compartido del equipo (el protocolo v1 ya está en *Configurar chat*).
- Anotar cuántas fuentes tiene el cuaderno ese día.
- Se pega solo el bloque de las 6 preguntas.
