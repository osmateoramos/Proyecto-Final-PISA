# PROTOCOLO DE CONSULTA — v2

Responsable del protocolo: Vanessa. Esta v2 la propuso Mateo el 2026-10-12; Vanessa la revisó y la aprobó el
2026-10-13, sin cambiar el texto que se pega. La v1 (`protocolo_consulta_v1.md`) no se borra.

- **Rol:** igual que en la v1.
- **Fuentes permitidas:** igual que en la v1. Para B se agrega una regla explícita: no abrir archivos fuera de
  `Vault_PISA2022/`.
- **Formato de cita exigido:** igual que en la v1 (documento + página o sección).
- **Qué responde cuando no está en las fuentes:** igual que en la v1, exactamente «No está en las fuentes.».
- **Qué cambió respecto a la versión anterior, y por qué:**
  - **Qué cambió:** se agrega la regla 6.
  - **Por qué:** la primera corrida de B de Mateo (2026-10-12) leyó, antes de responder,
    `Proyecto_PISA/nada_sin_fuente/experimento/consulta_Mateo.md`, que tenía la respuesta de A, y `corpus/procedencia.csv`.
    La v1 decía «los archivos de esta carpeta», y eso no bastó para impedirlo. La corrida se descartó; queda guardada
    en `consulta_Mateo.md`.
- **A qué tratamientos aplica:**
  - **B:** la v2.
  - **C:** sigue con la v1, porque NotebookLM no puede abrir archivos fuera del cuaderno.
  - **Corridas de B hechas con la v1** (por ejemplo, la de Vanessa): se dejan como están y se declara en la memoria
    qué versión usó cada una.

## Texto para pegar (B)

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

## Límites conocidos de esta versión

Revisión de Vanessa del 2026-10-13. Estos puntos no se resuelven en la v2: las corridas del experimento y del banco ya
se hicieron con la v1 y la v2, y una regla nueva sería una v3 sin probar. Quedan como candidatos para esa v3.

1. **La regla 6 no se puede comprobar desde la respuesta.** El protocolo no pide listar los archivos abiertos. Hoy se
   controla abriendo la sesión en `Vault_PISA2022` y revisando a mano si la herramienta leyó algo de fuera.
2. **No pide decir el estado de la nota citada.** En B la fuente es una nota del vault, que puede estar
   `por_verificar`; la respuesta no siempre lo aclara.
3. **No dice qué hacer cuando falta un solo dato de la referencia**, por ejemplo el DOI.
4. **La frase de abstención no es única en B.** `CLAUDE.md` se carga solo y pide «no está en el vault»; el protocolo
   pide «No está en las fuentes.». Al calificar el banco, las dos cuentan como abstención correcta (decisión D-11).
5. **Abstención de más.** Al exigir que la respuesta esté «literalmente» en las fuentes, el sistema puede abstenerse
   aunque la respuesta exista con otro término: en la consulta de Vanessa, C respondió «No está en las fuentes»
   porque la pregunta decía «NSE» y el documento «educación de los padres» (`experimento/consulta_Vanessa.md`).

Estos puntos salen de `protocolo/propuesta_v1_Mateo.md` (1 a 4) y de la consulta de Vanessa (5).
