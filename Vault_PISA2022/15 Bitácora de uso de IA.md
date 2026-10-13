---
tipo: guia
estado: por_verificar
lectura: "redactado por Claude junto con Vanessa, en vivo; falta revisión del resto del equipo"
pendientes: "Mateo y Brayan: agregar sus propias sesiones de uso de IA aquí"
verificado_por:
fecha_verificacion:
---

# Bitácora de uso de IA

Volver a [[00 Inicio]] · Protocolo en [[11 Protocolo de verificación]] · Actividad: `Rubrica_Segundo_Corte.txt` ("Nada sin fuente")

Registro continuo de en qué se usó IA, qué hizo exactamente, y qué se corrigió — insumo directo para la
**Declaración de uso de IA** que pide la actividad de Consultoría (30 % del corte). Una fila por sesión de trabajo,
no por cada mensaje.

## Regla de esta bitácora

No se usa para ocultar que hubo IA de por medio: se usa para declararlo con precisión. Lo que la IA redactó
en borrador se marca como tal hasta que la persona lo revisa, lo ajusta y lo asume como propio.

## Registro

| Fecha | Integrante | Para qué se usó la IA | Qué generó exactamente | Qué se corrigió / ajustó | Estado |
|---|---|---|---|---|---|
| 2026-10-12 | Vanessa | Redactar un borrador del inventario de fallos individual (actividad "Nada sin fuente") a partir de los errores ya registrados en [[11 Protocolo de verificación]] | Borrador en primera persona de 3 fallos, basado en la tabla "Errores ya detectados" | _(pendiente: Vanessa revisa, ajusta a su propia experiencia y confirma)_ | borrador, sin confirmar |
| 2026-10-12 | Vanessa | Congelar la fecha de [[09 Hipótesis preregistradas]] (paso 0.5 del plan) | Fecha de congelamiento puesta en 2026-10-12, con nota explícita del atraso frente al plan original | Ninguno — se decidió no fechar antes de hoy para no fingir que se congeló antes de lo real | hecho |
| 2026-10-12 | Vanessa | Elegir la consulta bibliográfica individual para el experimento de la semana 1 | Recomendación entre 3 opciones de la zona O3 (competencias/DIF), con la razón de cada una | Vanessa eligió la opción 1: DIF por NSE en competencias matemáticas de PISA | decidido |
| 2026-10-12 | Mateo | Conseguir los PDF del corpus y llenar la procedencia | Claude (Claude Code) revisó la disponibilidad de cada fuente en OpenAlex y Crossref, descargó los PDF abiertos, llenó licencia y notas de `procedencia.csv` y corrió `nsf_procedencia.R` | El enlace anotado para García-Medina (2016) era otro artículo (Gómez-Benito, 2010): el script tomó el primer PDF de la página. Se cambió por el de SciELO y se comparó el título de todos los PDF con su nota (error en [[11 Protocolo de verificación]]) | borrador de Claude; Mateo revisa |
| 2026-10-12 / 13 | Mateo | Trazabilidad de Mateo (16 filas) | Claude buscó en los PDF la página probable de cada oración citada (`paginas_propuestas_Mateo.md`) y la dejó como pista | Mateo abrió cada PDF y firmó las 16 filas: 10 se sostienen y 6 parcialmente. Rutkowski y Rolfe, solo con el resumen. Sus notas decían «equipo: texto completo» y se corrigieron | borrador de Claude; Mateo revisa |
| 2026-10-12 / 13 | Mateo | Consulta del experimento (A, B y C) y protocolo | Claude propuso la consulta y los textos para pegar, registró las respuestas y transcribió las referencias tal como las dio cada herramienta. Redactó la propuesta de protocolo que pasó a ser la v2 | La primera corrida de B leyó la respuesta de A fuera del vault: se descartó y se agregó la regla 6 (protocolo v2). Mateo corrió A, B y C él mismo | borrador de Claude; Mateo revisa |
| 2026-10-13 | Mateo | Clasificación ciega de las 67 referencias | Un script de Claude consultó en Crossref y DataCite el DOI o el título de cada referencia y llenó la columna `evidencia` | Mateo asignó todas las categorías. Claude no opinó sobre ninguna referencia para no romper la clasificación ciega. Se declaró en la memoria | borrador de Claude; Mateo revisa |
| 2026-10-13 | Mateo | Banco de evaluación de Mateo (6 preguntas) | Claude redactó las preguntas con respuesta y página, los textos para pegar, registró las respuestas y propuso las calificaciones comparando con el PDF | M01 se cambió antes de correr porque repetía la B04 de Brayan. Mateo corrió A, B y C y confirmó las calificaciones. Hallazgos: C leyó mal una tabla del reporte técnico; B repitió el «solo» de la nota de Eriksson | borrador de Claude; Mateo revisa |
| 2026-10-13 | Mateo | Inventario de fallos y memoria (§3 y §5) | Claude redactó el borrador del inventario a partir de lo ocurrido y los borradores de las secciones 3 y 5 de la memoria | Mateo revisó el inventario y lo ajustó («el resto del equipo» en vez de nombres). La §5 pasó de «por confirmar» a confirmada después de firmar la trazabilidad | borrador de Claude; Mateo revisa |

## Qué NO se usó IA para

- Decidir si el acta de datos de la contraparte aplica o no (lo decide el equipo).
- Elegir la herramienta final del sistema de fuentes (viene después del experimento, decisión de equipo).
- Marcar ninguna fuente o fila de trazabilidad como `verificado` (solo lo hace un integrante contra el original).
