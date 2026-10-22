---
tipo: guia
estado: por_verificar
lectura: "redactado por Claude el 2026-10-05 con el índice de los dos libros y las secciones leídas (ver cada nota de fuente)"
verificado_por:
fecha_verificacion:
---

# Libros de TRI y SEM: qué leer en cada fase y qué mejora el plan

Volver a [[00 Inicio]] · Plan en [[07 Plan de desarrollo PISA 2022]] · Decisiones en [[03 Registro de decisiones]]

Los dos libros están en `Proyecto_PISA/documentacion/` (no van a Git):

- [[Literatura/deayala2009theory|de Ayala (2009)]], *The Theory and Practice of Item Response Theory*. Página impresa = página del PDF − 18.
- [[Literatura/chen2024structural|Chen y Yung (2024)]], *Structural Equation Modeling Using R/SAS*. Página impresa = página del PDF − 21.

## 1. Qué leer en cada fase

| Fase | de Ayala (2009) | Chen y Yung (2024) |
|---|---|---|
| **F3 — NSE (TRI + AFC)** | Cap. 4 (estimación marginal y EAP, p. 68) · Cap. 5 (2PL y tamaño de muestra, pp. 99–106) · Cap. 8 (GPCM y respuesta graduada, p. 209) · Independencia condicional (pp. 131–133) | Cap. 2 (AFC con `lavaan`, p. 31) · Cap. 5 (SEM con datos categóricos, p. 129) |
| **F4 — Invarianza** | Cap. 12 (DIF, p. 323) | Cap. 7 (multigrupo con datos categóricos, p. 213) · Cap. 6 (multigrupo continuo, p. 161) |
| **F5 — Competencias (MIRT) y DIF** | Cap. 10 (TRI multidimensional, p. 275) · Respuestas faltantes (pp. 148–151) · Cap. 11 (enlace de escalas, p. 306) · Cap. 12 (DIF) · Apéndice D (pruebas adaptativas, p. 373) | — |
| **F6 — SEM por competencia** | — | Cap. 8 (SEM completo, p. 247) · Cap. 11 (SEM multinivel, p. 367) · Cap. 12 (tamaño de muestra y potencia, p. 377) |

**Lo que ninguno de los dos cubre:** pesos muestrales, réplicas BRR y valores plausibles (búsqueda en el texto, sin
resultados). Para F2 y F6 siguen mandando el Technical Report 2022 y el manual de análisis de la OCDE.

## 2. ¿El plan ya está al día?

**En lo esencial, sí.** Los libros confirman las decisiones centrales:

- 2PL para sí/no y GPCM o respuesta graduada para cantidades (de Ayala, caps. 5 y 8).
- Estimación marginal con puntajes EAP (de Ayala, cap. 4).
- Los ítems que la ruta adaptativa no presentó se pueden ignorar al estimar a cada estudiante (de Ayala, p. 150): sustenta el paso 5.2.
- AFC ordinal con WLSMV (Chen y Yung, cap. 5).
- La secuencia de invarianza del plan (umbrales → cargas → interceptos, con Wu y Estabrook) es **más fina** que la de Chen y Yung, que pasan del modelo configural directamente al estricto (pp. 221–246). Se mantiene.

**Pero hay siete puntos que el plan no cubre o cubre a medias.** Los datos de Colombia que los respaldan salen de
`Proyecto_PISA/datos/revision_pisa2022_col.R` (corrida del 2026-10-05):

| # | Mejora propuesta | Por qué | Dónde |
|---|---|---|---|
| **P1** | **Revisar dependencia local** con el índice Q3 dentro de cada unidad (estímulo común) y, si es alta, comparar con un modelo de *testlet* o sumar los ítems de la unidad como un ítem politómico. En F3, revisar los pares ST253–ST254 (dispositivos) y ST255–ST256 (libros), que preguntan casi lo mismo | Si se viola la independencia condicional, la información se sobreestima (de Ayala, p. 131). En Colombia, **211 de los 234 ítems** están en 76 unidades de 2 o más ítems | F3.3, F5.3 |
| **P2** | **Ítems con pocas respuestas:** calibrar los 232 que tienen datos, reportar el error estándar de sus parámetros y repetir la calibración sin los 20 que tienen menos de 500 respuestas, como robustez | Pauta orientativa de al menos 500 personas para el 2PL (de Ayala, p. 105). En Colombia, 22 ítems tienen menos de 500 respuestas y 2 no tienen ninguna | F5.2, F7 |
| **P3** | **Enlazar escalas antes de comparar dificultades con la OCDE:** llevar la métrica propia a la de la OCDE (media-sigma, curva característica, o calibrar con parámetros fijos) | La métrica de la TRI es arbitraria (de Ayala, pp. 106 y 291–292); enlazar (cap. 11; parámetros fijos en p. 310). La correlación con los PV (H7) no necesita enlace | F5.5 |
| **P4** | **DIF más completo:** distinguir DIF uniforme y no uniforme; depurar los ítems ancla en forma iterativa; clasificar la magnitud; repetir con un segundo método como robustez; y que el equipo revise el contenido antes de hablar de sesgo | de Ayala, pp. 324–327 (DIF no es sesgo; depuración). Çelik y Kaşık (2025) muestran que los resultados cambian con el método | F4.4, F5.6 y **H3** |
| **P5** | **Tercer tratamiento de las omisiones:** además de omitida = incorrecta y omisión rápida = faltante, una variante con crédito fraccional (1/m) o con la omisión como categoría (modelo nominal) | Las omisiones no son ignorables; en ítems dicotómicos no conviene tratarlas como incorrectas ni ignorarlas (de Ayala, p. 150, citando a De Ayala, Plake e Impara, 2001) | D-05, F5.7 (H4 no cambia) |
| **P6** | **Invarianza paso a paso según Chen y Yung:** ajustar primero el modelo en cada grupo; usar la parametrización *theta*; y al final **comparar las medias latentes del NSE** entre zonas y sectores | Chen y Yung, pp. 221–222 y 246. Comparar el NSE rural y urbano es justamente lo que la invarianza permite y hoy no está en el plan | F4.1, F4.5 (nuevo) |
| **P7** | *(Opcional)* **SEM multinivel:** separar el efecto del NSE del estudiante y el del NSE promedio del colegio | Chen y Yung, pp. 370–375, con un NSE latente casi igual al nuestro. Es una extensión: el plan ya corrige los errores estándar por colegio. Solo si sobra tiempo en F7 | F7 |

**Recomendación:** P1 a P6 sí; P7 solo si sobra tiempo. Para H3 (P4) conviene fijar el umbral de "efecto no
despreciable" **antes** de congelar las hipótesis (paso 0.5): las hipótesis aún no están congeladas.

## 3. Datos nuevos de Colombia (revisión del 2026-10-05)

- 234 ítems calificados, 2 sin ninguna respuesta: `CMA112Q02S` (retirado por la OCDE) y `CMA143Q01S` (con parámetros
  internacionales pero sin respuestas en Colombia; causa no verificada). **Quedan 232 calibrables:** emplear 75,
  interpretar 57, razonar 53 y formular 47.
- Respuestas por ítem: mediana 707; 22 ítems con menos de 500; 54 con 1.000 o más.
- 99 unidades (estímulos); 76 con 2 o más ítems, que suman 211 ítems.

## 4. Pendiente

- [x] El equipo aprueba, cambia o rechaza P1–P7. *Hecho el 2026-10-18 (D-21): Vanessa aprobó P1–P6; P7 queda opcional
  para la F7. Los pasos ya están en el plan 07.*
- [x] Si se aprueba P4: fijar el umbral de magnitud del DIF en [[09 Hipótesis preregistradas]]. *Hecho el 2026-10-18
  (D-22), en un anexo de la nota 09. Las hipótesis ya estaban congeladas (2026-10-12), así que se declara como
  definición posterior al congelamiento, aunque anterior a ver los datos de la F4 y la F5.*
