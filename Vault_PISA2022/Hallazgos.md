---
tipo: guia
estado: por_verificar
lectura: "borrador de Claude (2026-11-09; K5 actualizado el 2026-11-10) con las salidas de la F6-F7 (salidas/f7_robustez.csv y f7_sensibilidad_detalle.csv); las frases para el Ministerio las aprueba el equipo. Sección final (AFC por ítem de Brayan, posterior a la G4) agregada el 2026-11-10, borrador de Claude con salidas/mat_afc_items_condicional.*, mat_afc_diagnostico.txt y mat_afc_permutaciones.*"
verificado_por:
fecha_verificacion:
---

# Hallazgos (paso 7.3, D-45 punto 5)

Volver a [[00 Inicio]] · Criterio en [[08 Rúbrica de desarrollo]] · Hipótesis en [[09 Hipótesis preregistradas]] ·
Novedad en [[Literatura/Búsqueda de novedad F7]]

> [!warning] Cómo leer esta nota
> - Cada candidato se clasifica con los 5 criterios de la rúbrica: (1) hipótesis preregistrada o exploratoria declarada;
>   (2) efecto relevante según el umbral fijado antes; (3) robusto según D-45 (≥ 75 % de las sensibilidades que le
>   aplican, mínimo 3); (4) no está en la matriz para Colombia; (5) se explica en una frase.
> - **Criterio 4 cerrado** (decisión del equipo, 2026-11-10: lo comunicó Mateo, que estaba hablando con Vanessa y
>   Brayan y dijo que ellos lo aprueban). La búsqueda 7.2 cubrió las cuatro fuentes del plan (buscador web con SciELO y
>   Redalyc, **Scopus** y **Google Académico**, 2026-11-10) y ninguna encontró un antecedente para Colombia de K1, K2,
>   K4 ni K5. Hay estudios del mismo análisis en otros países o poblaciones. Los 4 posibles antecedentes que aparecieron
>   se revisaron y solo uno lo es, el de K2 (abajo) ([[Literatura/Búsqueda de novedad F7]]). Que no se haya encontrado un
>   antecedente no prueba que no exista; así se declara en el informe.
> - **K2:** el antecedente más cercano es Duarte, Bos y Moreno (2010, BID; [[Literatura/duarte2010ensenan]], leído por
>   Claude en texto completo y verificado por Mateo el 2026-11-10). Con el SERCE de 2006 (primaria) probaron la misma interacción: **para
>   Colombia no fue significativa** en ninguna de las 4 pruebas (pág. 21), y en América Latina solo en matemáticas de
>   3.º, en la misma dirección que K2. K2 sigue siendo nuevo para Colombia con PISA y en secundaria, pero el informe
>   debe citarlo.
> - El diseño es transversal: «asociación», no «efecto» (plan 9.1). Las frases son **borradores** de Claude.

## Resumen

| Candidato | (1) | (2) | (3) Robustez | (4) Novedad | Clasificación (borrador) |
|---|---|---|---|---|---|
| **K1** El NSE económico se asocia más con *interpretar* que con *emplear*, y su asociación no es igual entre competencias | H5 **exploratoria** (D-32) | Cumple la regla de H5 (positiva y significativa en la muestra completa y en la mitad de confirmación); H5 no fijó un umbral de magnitud | 3 de 3 (cerca del límite con ESCS y sin la ruta lineal) | No se encontró antecedente para Colombia | **Hallazgo exploratorio**, que necesita confirmarse en otra muestra o ciclo |
| **K2** La pendiente del NSE es mayor en los colegios privados | H6 preregistrada | Cumple la regla de H6 (Holm p = 0,007); la pendiente es entre 12,3 y 20,3 puntos mayor por unidad de EAP según la competencia (D-42) | 4 de 4; coincide con los puntajes propios (D-44) | No se encontró antecedente que pruebe la interacción en Colombia con PISA. En primaria (SERCE 2006), Duarte et al. (2010) no la encontraron significativa para Colombia | **Hallazgo** (se cita a Duarte et al., 2010, como antecedente en otra población) |
| **K3** El NSE económico se asocia con las 4 competencias | No es una hipótesis: es el punto de partida de O4 | 24,2 a 29,4 puntos por DE de la EAP (D-42) | 3 de 3 | Ya se sabe para matemáticas en total (OCDE; Icfes, 2024) | **Réplica** en Colombia, extendida a las 4 competencias |
| **K4** Tratar las omisiones rápidas como faltantes no reduce la brecha Q4 − Q1 | H4 preregistrada | **No**: reducción de 0,007 DE frente al umbral de 0,05 | 5 de 5 | No se encontró antecedente para Colombia | **Resultado nulo bien medido** (falla el criterio 2, es robusto) |
| **K5** DIF por NSE escaso (3 de 154 ítems) y no concentrado en interpretar y formular | H3 preregistrada | Primera parte sí (efectos B y C del ETS, el umbral de H3); segunda parte no | 4 de 4 (2 a 6 ítems con DIF según la variante: ESCS 6 de 155, sin ruta lineal 2 de 152, sin BH 8 de 154, D-38 3 de 154; nunca concentrado en interpretar y formular). `CMA135Q04S` tiene DIF en las cinco versiones | No se encontró DIF por NSE con ítems de PISA en Colombia | **Hallazgo parcial**: la primera parte de H3 se sostiene; el patrón por competencia que planteaba H3 no aparece (nulo en esa parte) |

## Frases para el Ministerio de Educación (borradores de Claude, criterio 5)

- **K1 (exploratorio):** «En Colombia, la ventaja de los estudiantes de hogares con más recursos es algo mayor cuando
  deben interpretar resultados matemáticos que cuando deben aplicar procedimientos.»
- **K2:** «En los colegios privados, la diferencia de desempeño en matemáticas entre estudiantes de hogares con más y
  con menos recursos es mayor que en los públicos.»
- **K3 (réplica):** «Los estudiantes de hogares con más recursos rinden más en las cuatro formas de usar las
  matemáticas que mide PISA, no solo en el puntaje total.»
- **K4 (nulo):** «Las respuestas dejadas en blanco muy rápido no explican la brecha socioeconómica en matemáticas: la
  brecha es real y no un efecto de desgano en la prueba.»
- **K5 (parcial):** «Muy pocas preguntas de matemáticas de PISA funcionan distinto para estudiantes de hogares con más
  o con menos recursos, y las que lo hacen no favorecen de forma sistemática a los de más recursos.» (En la versión
  base, 2 de los 3 ítems con DIF favorecen al cuartil bajo y 1 al alto: `salidas/mat_dif.csv`, columna `favorece`.)

## Lectura para política y riesgos de mal uso (criterio C7)

- **K2** no dice que los colegios privados «causen» desigualdad: puede reflejar cómo se reparten los estudiantes entre
  colegios (composición y selección), algo que este diseño no separa. Los antecedentes encontrados en la búsqueda
  apuntan a la composición de los colegios (por verificar).
- **K1 y K3** no deben leerse como que los estudiantes de NSE bajo «no pueden» interpretar: describen promedios
  condicionados, no capacidades individuales. Riesgo de estigmatización si se reportan sin esa salvedad.
- **K4** no autoriza a ignorar el desenganche: dice que no explica la brecha por NSE en esta muestra.
- **K5** no dice que la prueba sea «justa» en todo: un ítem con DIF no es necesariamente injusto, y la revisión de
  contenido de los ítems marcados (P4, D-21) sigue pendiente; `CMA135Q04S` aparece en todas las variantes (D-45).
  Tampoco descarta un sesgo común a todos los ítems: el DIF compara cada ítem con el resto de la prueba. Y el número de
  ítems con DIF depende de cómo se mida el NSE (3 con la EAP y 6 con ESCS): lo robusto es que son pocos, no cuáles son.

## Resultados que no fueron candidatos (se reportan igual)
- H1 aceptada (2 dimensiones del NSE, D-18); H2 rechazada, sin demostrar la invarianza (D-35); H7 y H8 rechazadas
  (D-27, D-41). No pasaron por las sensibilidades de la F7 (D-45) y así se declara.
- H6 por zona: sin resolver entre fuentes (D-44); con ESCS sale significativa (D-45). No es hallazgo.

## Exploratorio posterior a la G4: ¿cada ítem mide su competencia, y solo esa? (borrador)

> [!warning] Estado de esta sección
> - Análisis de Brayan con Claude (2026-11-08 a 2026-11-10), **posterior a la Puerta G4** y fuera de `resultados-v1`.
>   No se registró en [[03 Registro de decisiones]] antes de programarlo, no pasó por las sensibilidades de la F7
>   (D-45) y **no cambia ninguna hipótesis ni ningún resultado congelado**. Propuesta: registrarlo como D-49 si el
>   equipo lo acepta (confirmar que el número siga libre al registrarlo).
> - **Complementa D-48.** D-48 leyó las cargas del 5.3 sin reestimar y dejó como trabajo futuro su opción (d), probar
>   cada ítem en las otras competencias. Esto hace una versión **condicional** de (d): cada ítem se reestima solo, con
>   el resto del modelo fijo.
> - Los cortes de la lectura son de Claude y no tienen fuente en el vault (como los de D-29). Se fijaron antes de correr,
>   en la cabecera de `scripts/05_explorar_afc_0_lectura_viabilidad.R`.

**Pregunta** (la misma de D-48): ¿cada ítem de matemáticas mide la competencia que le asigna la OCDE, y solo esa?

**Cómo se hizo** (versión (a) de la matriz, 6.886 estudiantes × 232 ítems, pesos normalizados):
- *A, B y C* (`05_explorar_afc_1_items.R` → `salidas/mat_afc_items_condicional.csv` y `.txt`): para cada ítem, la
  posterior de cada estudiante sale de sus **otros** ítems en el modelo de 4 competencias del 5.3 (5.000 puntos QMC y
  la Φ del 5.3). Con esa posterior el ítem se reestima 5 veces: cargando solo en cada una de las 4 competencias y con
  las 4 cargas libres. Control: la carga propia coincide con la del 5.3 (correlación 0,9989).
- *D* (`05_explorar_afc_2_permutaciones.R`, `05_explorar_afc_2b_rango.R` y `05_explorar_afc_2c_unir.R` →
  `salidas/mat_afc_permutaciones.csv` y `.txt`): 20 modelos de 4 factores con los parámetros de los ítems fijos en
  los del modelo de 1 dimensión y solo las 6 correlaciones estimadas (QMCEM con 1.000 puntos; log-verosimilitud con
  10.000): la asignación de la OCDE y 19 al azar, permutadas dentro de cada formato (semilla 2026).
- *E* (mismo script que A): Q3 de los modelos de 1 y 4 dimensiones, en pares de unidades distintas con al menos 200
  estudiantes en común.

| Prueba | Lectura fijada antes de correr | Resultado | ¿Cumple? |
|---|---|---|---|
| A. Mide su competencia | ≥ 90 % de los ítems con carga propia ≥ 0,30 y límite inferior del IC 95 % > 0 | 173 de 232 (74,6 %): emplear 70,7 %, formular 63,8 %, interpretar 89,5 %, razonar 73,6 % | No |
| B. Solo esa | ≤ 10 % de ítems con cargas cruzadas significativas (BH 5 %) y alguna ≥ 0,30 | 15 de 232 (6,5 %) | Sí, pero ver el diagnóstico |
| C. Su competencia es la que mejor encaja | Informativa | 73 de 232 (31,5 %); permutando dentro de cada formato se esperan 58,2 (95 %: 46 a 71), p = 0,013 | Por encima del azar |
| D. Control contra el azar | La OCDE supera a las 19 asignaciones al azar | Ganancia frente a 1 dimensión: OCDE 10,24; azar de −14,95 a 2,89 (mediana −6,29); ninguna iguala a la OCDE | Sí (p = 0,05, el mínimo posible con 19) |
| E. Residuos | Informativa | Q3 medio en 1 dimensión: −0,0254 misma competencia (830 pares) y −0,0242 distintas (2.512 pares) | Sin diferencia |

- **Veredicto con la regla fijada: contradice**, porque A quedó por debajo de 90 %. La regla era: confirma si A ≥ 90 %,
  B ≤ 10 % y D se cumple; contradice si A < 90 % o B > 10 %.

**Diagnóstico posterior a ver A** (`05_explorar_afc_3_diagnostico.R` → `salidas/mat_afc_diagnostico.txt`; no es parte
de la regla):
- De los 59 ítems que no cumplen A, 56 tienen carga < 0,30 y 3 tienen carga ≥ 0,30 con el límite inferior ≤ 0. Los 56
  son **los mismos 56 de D-48** (Claude cruzó `mat_afc_cargas.csv` con `mat_afc_items_condicional.csv` el 2026-11-10,
  sin script guardado).
- Esos 56 también tienen carga < 0,30 en el **modelo de 1 dimensión**: la carga en su competencia y la de 1 dimensión
  correlacionan 0,9992. No es falta de datos (mediana de 702 respuestas en los que fallan y 757 en los que cumplen).
  Cumplen menos los de calificación automática (141 de 197, 71,6 %) que los de codificación humana (32 de 35, 91,4 %).
- **A no distingue «su competencia» de «matemáticas en general», y B no distingue cargas cruzadas.** Con correlaciones
  entre competencias de 0,897 a 0,976, el modelo con 4 cargas libres casi no se identifica: 197 de 232 ítems dan alguna
  carga libre mayor que 1 en valor absoluto y 227 superan 0,30. B quedó dependiendo solo de la significancia (45 ítems
  con p < 0,05 sin corregir; 15 con BH). Son defectos del diseño de Claude, y así se declaran.

**Qué significa** (*interpretación de Claude, por discutir*):
- La asignación de la OCDE **no es arbitraria**: separa mejor que las 19 asignaciones al azar (D), y la competencia
  asignada encaja mejor de lo que daría el azar (C).
- Pero la parte propia de cada competencia es **pequeña**: correlaciones de 0,924 a 0,979 en el control D, residuos sin
  grupos por competencia (E) y, con los parámetros fijos, el BIC sigue prefiriendo 1 dimensión (+32,5) mientras el AIC
  prefiere 4 por poco (−8,5). BIC y AIC se calcularon a mano con la ganancia de 10,24, 6 parámetros y 6.886
  estudiantes; con pesos son descriptivos.
- Lo que hace fallar A son ítems que **discriminan poco en Colombia**, no ítems de otra competencia. Es coherente con
  D-43 y D-48.
- **«Solo esa competencia» no se puede comprobar** con estos datos.
- Para **K1** (H5, exploratoria): K1 compara competencias con los VP de proceso de la OCDE (D-32), que este análisis no
  evalúa. Que lo propio de cada competencia sea pequeño en los datos de Colombia refuerza la cautela con que D-32 ya
  pide leer K1.

**Clasificación con la rúbrica** (borrador; la decide el equipo): (1) exploratorio, declarado después de correr y
posterior a la G4; (2) sin umbral del equipo, porque los cortes son de Claude; (3) sin las sensibilidades de la F7; (4)
no se buscaron antecedentes; (5) frase abajo. **No es candidato a hallazgo según D-45: es un resultado de medición
exploratorio que se reporta.**

- **Frase (borrador):** «Las preguntas de matemáticas de PISA se agrupan en las cuatro competencias de la OCDE mejor que
  al azar, pero en Colombia esas competencias casi no se distinguen: miden sobre todo una misma habilidad matemática.»

**Límites:**
- La prueba es condicional: no reestima el resto del modelo. Con pesos, las razones de verosimilitud son aproximadas y
  no corrigen por el diseño muestral.
- En D los parámetros de los ítems quedaron fijos en los del modelo de 1 dimensión; por eso la OCDE gana 10,24 y no los
  14,8 del modelo completo (nota 17, sección 9.4). Varias asignaciones al azar ganan menos que 0, lo que no debería
  pasar, porque con correlaciones de 1 son el modelo de 1 dimensión. Claude cree que el algoritmo se detiene antes de
  llegar a esa frontera (*sin verificar*). Aunque esas ganancias se contaran como 0, quedan por debajo de la OCDE.
- Solo se usó la versión (a) de la matriz (omisión = 0).
- La columna `minutos` de `mat_afc_permutaciones.csv` incluye dos pausas pedidas por Brayan (en azar_1 y azar_14, y en
  azar_6, azar_12 y azar_18). Sin pausas, cada ajuste tomó de 18 a 34 minutos.

**Reproducción:** `05_tri_competencias.R` (genera los cachés) → `05_explorar_afc_1_items.R` (106,8 min en el equipo de
Brayan) → `05_explorar_afc_2_permutaciones.R` (20 ajustes de unos 30 min, o `05_explorar_afc_2b_rango.R` en paralelo y
`05_explorar_afc_2c_unir.R`) → `05_explorar_afc_3_diagnostico.R` (menos de 1 min). Las copias del proyecto solo cambian
rutas y nombres de salida respecto de lo que corrió. `05_explorar_afc_2c_unir.R` y `05_explorar_afc_3_diagnostico.R`
se corrieron desde una réplica de la estructura del proyecto y dieron salidas idénticas (2026-11-10). Los `.txt` son
los registros de la corrida original y conservan los nombres de archivo de la copia aparte.
