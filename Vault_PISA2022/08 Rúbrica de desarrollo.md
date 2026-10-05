---
tipo: guia
estado: por_verificar
lectura: "redactado por Claude; falta revisión del equipo"
pendientes: "Diseño del equipo: aprobar o ajustar umbrales"
verificado_por:
fecha_verificacion:
---

# Rúbrica de desarrollo — cómo proceder para lograr un hallazgo innovador

Volver a [[00 Inicio]] · Pasos en [[07 Plan de desarrollo PISA 2022]] · Hipótesis en [[09 Hipótesis preregistradas]]

Esta rúbrica es **interna**: no reemplaza la del curso. Sirve para autoevaluarse al cerrar cada fase y para
saber qué falta para que un resultado cuente como hallazgo defendible. Misma regla que la rúbrica oficial:
**si dudan entre dos niveles, están en el de abajo.**

## Criterios

| Criterio | Ejemplar | Competente | En desarrollo | Insuficiente |
|---|---|---|---|---|
| **C1 Reproducibilidad** | Todo corre desde cero con un solo comando; semilla fija; cachés documentados; Git con historial limpio y etiqueta de resultados congelados | Scripts corren en orden con pasos manuales mínimos documentados | Algunas cifras salen de la consola o de pasos no guardados | No se puede reproducir una cifra del informe |
| **C2 Diseño muestral** | Pesos finales, 80 réplicas BRR (Fay 0,5), 10 PV con Rubin y conglomerado por colegio en **todos** los análisis inferenciales | Pesos y PV correctos; conglomerado solo en el modelo principal | Usa pesos pero solo un PV o EE sin réplicas | Sin pesos o promediando PV por estudiante |
| **C3 Validación externa** | Reproduce media, brecha por ESCS y % de varianza de la OCDE dentro de ±1 punto (G1) y lo reporta | Reproduce la media; la brecha difiere por razón explicada | Reproduce solo una cifra sin explicar diferencias | No se compara con cifras publicadas |
| **C4 Calidad de medición** | Ajuste, confiabilidad e invarianza reportados **también cuando fallan**, con invarianza parcial justificada | Ajuste y confiabilidad reportados; invarianza solo hasta métrica | Ajuste reportado sin confiabilidad ni invarianza | Se usan las escalas sin evaluarlas |
| **C5 Rigor inferencial** | Hipótesis preregistradas; tamaños de efecto con IC; corrección por comparaciones múltiples; separa resultados confirmatorios de exploratorios | Efectos con IC y corrección múltiple, sin preregistro | Solo valores p | Conclusiones sin incertidumbre |
| **C6 Novedad verificada** | Búsqueda formal documentada (bases, términos, fecha); matriz completa sin †; el aporte se dice en una frase y se distingue de lo existente | Búsqueda razonable; aporte claro, alguna fuente sin leer completa | Novedad afirmada por intuición | Se presenta como nuevo algo ya publicado |
| **C7 Relevancia para Colombia** | Cada hallazgo tiene lectura para política (zona rural, sector público) y declara riesgos de mal uso (estigmatización) | Lectura para política genérica | Hallazgos solo técnicos | Sin conexión con Colombia |
| **C8 Gestión de la información** | Cada fuente en Zotero con nota en el vault; cada decisión en el registro antes de programarla; cada cifra enlazada a su script | Fuentes y decisiones registradas con huecos menores | Notas sueltas, decisiones reconstruidas después | Sin trazabilidad |
| **C9 Producto (API)** | API documentada en `/docs`, pruebas automáticas que pasan, tablero sobre resultados reales, datos solo agregados | API funcional con documentación, sin pruebas | Endpoints parciales o con datos de ejemplo | No hay API |

## Puertas de fase (no se avanza sin cumplirlas)

| Puerta | Al cerrar | Condición | Si no se cumple |
|---|---|---|---|
| **G1** | F2 | Media, brecha y % de varianza coinciden con la OCDE (±1) | Revisar pesos, PV y filtros antes de cualquier modelo |
| **G2** | F3 | Modelo de NSE con ajuste aceptable o desajuste documentado; H1 resuelta | Revisar ítems problemáticos; no pasar a invarianza con un modelo sin decidir |
| **G3** | F5 | Ítems con n insuficiente excluidos y listados; H3 y H4 resueltas | Agrupar ítems o países hispanohablantes (plan de respaldo de O3) |
| **G4** | F7 | Resultados congelados con etiqueta Git | No construir la API sobre resultados que todavía cambian |

## Criterio de hallazgo innovador

Un resultado se presenta como **hallazgo** solo si cumple las cinco condiciones:

1. **Responde a una hipótesis preregistrada** en [[09 Hipótesis preregistradas]] (o se declara explícitamente
   como exploratorio).
2. **Tiene un efecto relevante**, según el umbral definido en la hipótesis *antes* de verlo.
3. **Es robusto**: se mantiene en al menos 3 de los 4 análisis de sensibilidad de F7.
4. **No está en la matriz**: ningún antecedente de [[Literatura/Matriz estado del arte]] lo reporta para Colombia.
5. **Se explica en una frase** que entienda alguien del Ministerio de Educación.

Si cumple 1–3 pero falla 4: es una **réplica** en Colombia — también vale, pero se presenta como tal.
Si falla 2 o 3: se reporta como **resultado nulo o frágil**, con la misma honestidad (un nulo bien medido es un
resultado).
