---
tipo: guia
estado: por_verificar
lectura: "redactado por Claude junto con Vanessa, en vivo; falta revisión del resto del equipo"
pendientes: "Correr Tratamiento A y B; completar clasificación de Ercikan, Roth y Asil (2009); sumar las consultas de Mateo y Brayan"
verificado_por:
fecha_verificacion:
---

# Experimento — actividad "Nada sin fuente"

Volver a [[00 Inicio]] · Bitácora de IA en [[15 Bitácora de uso de IA]] · Actividad: `Rubrica_Segundo_Corte.txt`

## Consulta de Vanessa (O3: competencias y DIF)

> ¿Qué estudios usan DIF por NSE dentro de las competencias/procesos matemáticos de PISA?

Elegida sobre las otras dos candidatas (TRI multidimensional; tratamiento de omisiones) porque el equipo ya tenía
evidencia propia para contrastar: la revisión de literatura del 2026-10-05 ([[11 Protocolo de verificación]]) ya
había encontrado que el DIF por NSE en matemáticas de PISA sí se ha estudiado (Liu y Bradley 2021; Goh et al. 2024;
Kucam y Gülleroğlu 2023).

## Tratamientos

| Tratamiento | Herramienta | Estado |
|---|---|---|
| A — sin fuentes | Pendiente | no corrido todavía |
| B — buscador conectado | Pendiente | no corrido todavía |
| C — contexto cerrado | **NotebookLM**, con 4 PDF (Liu y Bradley 2021, Kucam y Gülleroğlu 2023, Çelik y Kaşık 2025, Calderón et al. 2026) | corrido el 2026-10-12 |

## Clasificación de referencias (Tratamiento C, NotebookLM)

| # | Referencia | Clasificación | Evidencia |
|---|---|---|---|
| 1 | Liu y Bradley (2021) | **Utilizable** | Coincide con [[Literatura/liu2021differential]]: HGLM, ESCS como covariable, 4 de 10 ítems con DIF |
| 2 | Kucam y Gülleroğlu (2023) | **Utilizable** | Verificado en el PDF: el ítem `CM305Q01S` y sus estadísticos sí aparecen |
| 3 | Liu, M. (2017), tesis doctoral (Univ. de Toledo) | **Existe pero no dice eso** | Kucam solo la cita para un punto metodológico (LR más sensible que RT); NotebookLM le atribuyó hallazgos sobre NSE/género/etnia/TIMSS 2011 que el PDF no sostiene — ver caso de fallo abajo |
| 4 | Ercikan, Roth y Asil (2009) | pendiente | Existe como publicación (*International Journal of Testing*, 9(2), 101–121), falta confirmar si el PDF cerrado la describe como DIF en lectura de PISA 2006 o con otro alcance |
| 5 | Odabaşı (2019) | **Utilizable** (corroborado, no verificado en el PDF subido) | Tesis de maestría confirmada (Akdeniz Üniversitesi, DIF en PISA 2015 ciencias); coincide con la pista ya anotada en [[Literatura/celik2025differential]] |

## Caso de fallo

**Consulta:** la de arriba.

**Qué respondió el sistema:** describió a *Liu (2017)* como un estudio que "analizó el DIF según nivel
socioeconómico, género, etnia y lengua materna en la prueba de matemáticas de TIMSS 2011 (8.º grado, EE. UU.)".

**Qué estaba mal:** la referencia existe y está citada en el PDF cerrado (Kucam y Gülleroğlu, 2023), pero el
documento solo la cita para un punto metodológico puntual: *"the LR method is more sensitive than the RT method,
which is in line with the findings of Liu (2017)"* — nada sobre NSE, género, etnia, lengua materna ni TIMSS 2011.
La ficha real de Liu (2017) es una tesis doctoral sobre comparar métodos de detección de DIF (*"Differential Item
Functioning in Large-scale Mathematics Assessments: Comparing the Capabilities of the Rasch Trees Model to
Traditional Approaches"*, Univ. de Toledo), no un estudio aplicado sobre esas variables.

**Causa técnica:** el modelo no se limitó al fragmento del documento cerrado que sustenta la cita; completó la
descripción de una referencia secundaria con conocimiento externo (de su entrenamiento), presentándolo como si
viniera del PDF subido. Es una falla de anclaje parcial: la referencia primaria (Kucam) sí estaba bien anclada; la
secundaria (Liu, citada dentro de Kucam) no.

**Cómo se detectó:** abriendo el PDF de Kucam y Gülleroğlu (`Ctrl+F` "Liu 2017") y comparando la oración exacta
contra lo que afirmó NotebookLM.

**Lo que esto confirma:** el contexto cerrado reduce las referencias totalmente inventadas (problema de búsqueda),
pero no elimina las afirmaciones falsas sobre lo que dice un documento real (problema de anclaje) cuando la cita
es de segundo nivel.

## Pendiente

- Correr Tratamiento A (chat sin fuentes) y B (buscador conectado a bases reales) con la misma consulta.
- Confirmar la clasificación de Ercikan, Roth y Asil (2009) contra el PDF real.
- Correr el mismo Tratamiento C en un segundo candidato (Proyecto de Claude/ChatGPT con los mismos PDF), para la
  tabla de decisión de los 6 criterios.
- Sumar las consultas de Mateo (O1–O2) y Brayan (O4–O5), cada uno clasificando sin consultarse.
