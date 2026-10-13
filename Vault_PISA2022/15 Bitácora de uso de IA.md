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
| 2026-10-12 | Vanessa | Redactar un borrador del inventario de fallos individual (actividad "Nada sin fuente") a partir de los errores ya registrados en [[11 Protocolo de verificación]] | Borrador en primera persona de 3 fallos, basado en la tabla "Errores ya detectados" | Ninguno: Vanessa lo validó y lo dejó tal cual lo redactó la IA (dato de Vanessa, 2026-10-13) | firmado sin cambios el 2026-10-12 |
| 2026-10-12 | Vanessa | Congelar la fecha de [[09 Hipótesis preregistradas]] (paso 0.5 del plan) | Fecha de congelamiento puesta en 2026-10-12, con nota explícita del atraso frente al plan original | Ninguno — se decidió no fechar antes de hoy para no fingir que se congeló antes de lo real | hecho |
| 2026-10-12 | Vanessa | Elegir la consulta bibliográfica individual para el experimento de la semana 1 | Recomendación entre 3 opciones de la zona O3 (competencias/DIF), con la razón de cada una | Vanessa eligió la opción 1: DIF por NSE en competencias matemáticas de PISA | decidido |
| 2026-10-13 | Vanessa | Evaluar la actividad contra el enunciado y contra la guía de trabajo, y listar lo que faltaba en su rama | Evaluación por criterio y lista de 13 pendientes en orden | Vanessa decidió trabajarlos uno por uno y qué se hacía en cada paso | hecho |
| 2026-10-13 | Vanessa | Traer a su rama el trabajo de Mateo y Brayan | Fusión de `origin/Mateo` y `origin/Brayan` con Git, sin conflictos | Ninguno | hecho |
| 2026-10-13 | Vanessa | Clasificación ciega de las 67 referencias (`experimento/clasificacion_Vanessa.csv`) | Claude listó las referencias agrupadas por documento, anotó en la hoja la categoría y la evidencia que Vanessa dictó, y consultó Crossref y OpenAlex para comprobar existencia. Vanessa indicó que validó cada fuente a mano, una por una | Claude no anotó como «no existe» 9 referencias que Vanessa no había encontrado, porque Crossref, OpenAlex o los registros del propio equipo sí las tienen. R002 se reclasificó cuando Vanessa abrió el artículo correcto de Rolfe (la primera revisión fue sobre otros artículos). Vanessa decidió descartar sin categoría las 21 de pago o sin acceso. Por instrucción suya, Claude dedujo 4 citas indirectas de la nota verificada de Çelik y Kaşık, usó su verificación del 12 de octubre en R013, R022 y R043, y aplicó a las 5 filas «descartada» el criterio que ella aprobó | hecho: 42 u, 4 e, 21 descartadas |
| 2026-10-13 | Vanessa | Cerrar la tabla de trazabilidad (`trazabilidad/trazabilidad_Vanessa.csv`) | Claude consultó los resúmenes en Crossref y el acceso abierto en OpenAlex y Europe PMC, encontró que Köhler et al. (2015) está abierto en PubMed Central, redactó las correcciones propuestas y la decisión D-10 | Vanessa abrió Köhler y García-Medina y aportó las citas y secciones. Se corrigió el destino de la corrección de T-Van-03 (va a la nota del vault, no al anteproyecto) y se propuso cambiar «el único análisis» en T-Van-06. Los resúmenes de Goh y Pohl los leyó solo Claude: esas dos filas siguen sin verificar | 8 de 10 filas sostenidas; 2 esperan D-10 |
| 2026-10-13 | Vanessa | Poner al día las notas de `Literatura/` | Claude completó páginas en las notas de Liu y Bradley, Köhler y García-Medina y creó la nota `gomezbenito2010sesgo` | Claude no marcó ninguna nota como `verificado`: lo hizo Vanessa en el editor, en Kucam, Liu y Bradley, Köhler y García-Medina. La fila 3 de García-Medina quedó verificada sin ubicación anotada | hecho, con ese pendiente |
| 2026-10-13 | Vanessa | Corregir la codificación del banco de evaluación y declarar los desvíos de la consulta | Claude rehízo las cuentas de `nsf_evaluacion.R` en Python, cambió la codificación de las 5 abstenciones de A, redactó la decisión D-11 y la sección de desvíos de `consulta_Vanessa.md` | Vanessa aportó el modelo usado en A y B (Claude Opus 5.5) y aprobó los cambios | hecho |
| 2026-10-13 | Vanessa | Actualizar la procedencia de sus fuentes y revisar el protocolo v2 | Claude reescribió las notas de 4 filas de `procedencia.csv`, actualizó a mano las mismas filas del README (este equipo no tiene R) y redactó la sección «Límites conocidos» del protocolo v2 | Vanessa confirmó su nombre como verificadora de 6 fuentes y la fecha de Burns, y aprobó la v2 sin cambiar el texto que se pega | hecho |

## Qué NO se usó IA para

- Decidir si el acta de datos de la contraparte aplica o no (lo decide el equipo).
- Elegir la herramienta final del sistema de fuentes (viene después del experimento, decisión de equipo).
- Marcar ninguna fuente o fila de trazabilidad como `verificado` (solo lo hace un integrante contra el original).
- Abrir y leer las fuentes de la clasificación y de la trazabilidad: lo hizo Vanessa. Las excepciones están en el registro
  (citas indirectas deducidas de una nota verificada y resúmenes de Goh y Pohl, leídos solo por Claude).
- Decidir qué referencias se descartan por falta de acceso (decisión de Vanessa, 2026-10-13).
- Tomar las decisiones D-10 y D-11: quedan como propuestas para los tres integrantes.
