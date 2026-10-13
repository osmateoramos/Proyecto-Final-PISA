# Banco de Mateo: textos para pegar en A, B y C

Igual que en el banco de Brayan: una conversación nueva por tratamiento, con las 6 preguntas juntas (se declara en la
memoria). Las respuestas conocidas están en `banco_Mateo.csv`: **no abrir ese archivo en la sesión de B**.

Al terminar cada tratamiento, copiar la respuesta completa y pasársela a Claude, indicando de qué tratamiento es, el
modelo y la hora.

M01 se cambió antes de correr el banco: la versión anterior (el 16 % del informe nacional) repetía la B04 de Brayan.

## Las 6 preguntas (las mismas en A, B y C)

```
Responde cada pregunta por separado, numerada:

M01. Según el reporte técnico de PISA 2022 de la OCDE, ¿cuáles son los tres componentes del índice de estatus económico, social y cultural (ESCS)?
M02. Según el reporte técnico de la OCDE, ¿cuántos estudiantes y cuántas escuelas tuvo la muestra principal de Colombia en PISA 2022?
M03. Según Avvisati y Wuyts (2024), ¿con qué tipo de modelo se construye el índice de posesiones del hogar (HOMEPOS) de PISA y cambió ese procedimiento en 2022?
M04. Según Eriksson et al. (2021), ¿qué componentes del nivel socioeconómico predicen mejor el logro en PISA 2018?
M05. ¿Entre qué grupos de estudiantes y en qué países evaluaron Mittal et al. (2022) la invarianza del índice HOMEPOS, y qué encontraron?
M06. ¿Qué estudio evaluó la invarianza del índice HOMEPOS entre estudiantes de zonas rurales y urbanas de Colombia con datos de PISA 2022?
```

## A · Claude sin contexto

- Chat **incógnito** nuevo, sin proyecto ni carpeta; Investigación y Memoria apagadas; conectores apagados.
- Mismo modelo que en la consulta del experimento: Opus 5.5, esfuerzo Alto.
- Se pega solo el bloque de las 6 preguntas.

## B · Zotero + Obsidian (Claude Code con el vault)

- Sesión **nueva** de Claude Code (app de escritorio, pestaña Code) abierta en la carpeta **`Vault_PISA2022`**, con
  un modo que pida permiso (no *Auto*). Mismo modelo: Opus 5.5, esfuerzo Alto.
- Se pega primero el protocolo v2 (`protocolo/protocolo_consulta_v2.md`, «Texto para pegar (B)») y, debajo, el bloque
  de las 6 preguntas.
- Si pide permiso para leer fuera del vault o para buscar en internet: **negar**. Si lo hizo igual, la corrida se
  descarta y se repite.

## C · Gemini Notebook (NotebookLM)

- Cuaderno compartido del equipo (el protocolo v1 ya está en *Personalizar cuaderno*).
- Anotar cuántas fuentes tiene el cuaderno ese día.
- Se pega solo el bloque de las 6 preguntas.
