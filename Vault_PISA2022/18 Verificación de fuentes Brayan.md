---
tipo: guia
estado: por_verificar
lectura: "redactado por Claude el 2026-10-18 buscando en el texto extraído de los PDF; las páginas son pistas, no evidencia"
pendientes: "Brayan abre cada PDF, comprueba la fila, escribe la cita y firma en la nota de la fuente (no aquí)"
verificado_por:
fecha_verificacion:
---

# Verificación de fuentes — tercio de Brayan

Volver a [[00 Inicio]] · Protocolo en [[11 Protocolo de verificación]] · Reparto en [[17 Plan de trabajo Brayan]] (sección 3.2)

**Cómo usar esta nota**
1. Abre el PDF en la página indicada y busca los términos con `Ctrl+F`.
2. Si la afirmación se sostiene, escribe en la **nota de la fuente** (no aquí) la página y una cita de menos de 15
   palabras, y cambia el estado de esa fila a `verificado (Brayan, fecha)`.
3. Si no se sostiene, corrige la fila de la nota (la versión vieja queda ~~tachada~~) y avisa si cambia el anteproyecto.

- Claude no marca nada como `verificado` y no leyó los documentos completos. Buscó términos en el texto que extrae
  `pdftotext`.
- Las notas de fuente que se citan son las de la rama `Vanessa` (`152691a`), que es la versión más reciente.
- Los PDF están en `Proyecto_PISA/nada_sin_fuente/corpus/`.
- **Página PDF** = número de página en el visor. Cuando la revista imprime otra numeración, se indica.

## Resumen

| Fuente | Filas por verificar | PDF en este equipo | Qué hay que hacer |
|---|---|---|---|
| [[Literatura/oecd2023fichacolombia]] | 0 de 3 | — | **Nada**: Vanessa verificó las 3 filas el 18/10 |
| [[Literatura/icfes2024pisa]] | 3 de 4 (la 3 ya la verificó Vanessa) | sí | Filas 1, 2 y 4 en las pp. 30–32 |
| [[Literatura/guerra2026digital]] | 3 | sí | Además, matizar la frase del anteproyecto (ver abajo) |
| [[Literatura/rodriguez2024rural]] | 3 | sí | **La inconsistencia del 40 % se confirma**, con tres redacciones distintas |
| [[Literatura/collazos2021determinantes]] | 3 | sí | La fila 1 dice «MCO» y el texto no lo dice |
| [[Literatura/lee2024decada]] | 2 | sí | La brecha es **por estrato** y el 11,3 está en un gráfico |
| [[Literatura/zabala2019impacto]] | 2 | sí | **El resumen y la discusión se contradicen** sobre el internet |
| [[Literatura/rosseel2012lavaan]] | 1 (solo referencia) | sí | Comprobar los datos bibliográficos en la p. 1 |
| [[Literatura/oecd2023pisadb]] | 2 | no es PDF | La fila 1 es un dato reproducido hoy; la fila 2 sigue `sin_origen` |
| [[Literatura/chen2024structural]] | 5 | **no** | El PDF está en el grupo de Zotero; necesitas tu cuenta |
| [[Literatura/wu2016identification]] | 1 (solo referencia) | **no** | ídem |
| [[Literatura/rubin1987multiple]] | 1 (solo referencia) | no (de pago) | Depende de D-10: con (b) se reemplaza por el Technical Report, p. 226 |
| [[Literatura/chen2007sensitivity]] | 1 (solo referencia) | no (de pago) | Depende de D-10: con (b) sale y la F4 usa Putnick y Bornstein (D-25) |

## Bloque A (descriptivo y econométrico)

### icfes2024pisa — `corpus/icfes2024pisa.pdf` (la página impresa es igual a la del PDF)

Se cita en el anteproyecto en las líneas 35 (16 %), 55 y 116 (las competencias solo se reportan como promedios del
país).

| Fila | Afirmación | Página propuesta | Buscar | Observación |
|---|---|---|---|---|
| 1 | Reporta las 4 subescalas de proceso frente a OCDE, Latinoamérica y Colombia 2012 (sección 3.1.3) | 30 (3.1.3); 31 (3.1.3.1 y figura 14) | «Subescalas de proceso», «Figura 14» | — |
| 2 | Frente a 2012: formular +4, emplear +13 e interpretar −4; razonamiento igual al promedio latinoamericano | 32 | «4 y 13 puntos», «igual en la subescala de razonamiento» | El texto aclara que razonar se evaluó por primera vez en 2022 |
| 4 | No cruza las subescalas de proceso con el ESCS | 30–33 y sección del ESCS (≈ 39–46) | «subescala» | Afirmación negativa: «subescala» solo aparece entre las pp. 4 y 33, no en la sección del ESCS. Hojear esa sección para confirmarlo |

### guerra2026digital — `corpus/guerra2026digital.pdf` (Frontiers, sin numeración impresa propia)

Se cita en la línea 86: «13 países de ALC con PISA 2022, mediante descomposición multinivel y aprendizaje
automático, sin análisis por ítem, TRI ni modelos estructurales».

| Fila | Afirmación | Página propuesta | Buscar | Observación |
|---|---|---|---|---|
| 1 | No hace análisis por ítem, DIF, TRI, SEM ni tiempos de respuesta | todo el texto | «item», «differential item», «item response», «structural equation», «response time» | Afirmación negativa: ninguno de esos términos aparece en el texto extraído |
| 2 | Señala que los índices TIC requieren pruebas de invarianza | 4; también 24 | «invariance» | Lo dice **citando estudios de PISA 2018**, no como resultado propio. Conviene escribirlo así |
| 3 | Usa la media de los PV y lo reconoce como limitación | 23 (limitaciones); 7 (sección 2.4) | «MATH_MEAN», «plausible values» | En la p. 7 aclaran que usar la media no cambia la estimación puntual; la limitación es la incertidumbre |
| — | (anteproyecto) «mediante descomposición multinivel y aprendizaje automático» | 1 (resumen) | «complementary robustness» | **Matiz:** según el resumen, la estimación principal es ponderada con BRR, y lo multinivel y LightGBM/SHAP son capas complementarias. El «13 países» no se ubicó con la búsqueda: confirmarlo en el resumen o el método |

### rodriguez2024rural — `corpus/rodriguez2024rural.pdf` (*Desarrollo y Sociedad*, 97, pp. 59–75)

El PDF tiene 27 páginas y la numeración impresa no sigue al visor. Va en el encabezado: p. 3 del PDF = 61, p. 18 = 66
y p. 20 = 68. Se cita en las líneas 84–85.

| Fila | Afirmación | Página propuesta | Buscar | Observación |
|---|---|---|---|---|
| 1 | Las características del colegio explican más del 40 % de la brecha | PDF 3 (impresa 61), 17 y 20 (impresa 68) | «40%» | **Se confirma la inconsistencia, y son tres redacciones distintas:** en el resumen (p. 3), el colegio explica más del 40 % «de las variaciones en el desempeño»; en la p. 17, el colegio explica más del 40 % «de la brecha»; en las conclusiones (p. 20), son colegio **y** familia juntos. La frase actual del anteproyecto («sobre todo por características observables de los colegios y de las familias») no depende del 40 % y se sostiene. Propuesta: dejar la fila 1 como `descartado` o reescribirla con la redacción de las conclusiones |
| 2 | Brecha de 30,7 puntos en matemáticas, 36,9 en lectura y 29,6 en ciencias | PDF 16; también 18 y 20 (impresa 68) | «30.7» | — |
| 3 | La familia explica más del 20 % en matemáticas y ciencias, y 32 % en lectura | PDF 3 (impresa 61) y 18 (impresa 66) | «20%», «32%» | — |

### collazos2021determinantes — `corpus/collazos2021determinantes.pdf` (Redalyc, generado de XML: sin páginas impresas)

Se cita en las líneas 81–82: «combinación de cortes transversales sobre 3.247.429 evaluados… efectos netos de
estrato, educación materna y acceso a computador e internet».

| Fila | Afirmación | Página propuesta | Buscar | Observación |
|---|---|---|---|---|
| 1 | Usa MCO sobre 3.247.429 estudiantes de 2014 a 2019 | 11 (n); 2 (método, en el resumen) | «3.247.429», «combinación de corte transversal» | **«MCO» y «mínimos cuadrados» no aparecen** en el texto extraído. El resumen dice «modelo de combinación de corte transversal», como el anteproyecto. Ver en la sección de método qué estimador usan antes de dejar «MCO» en la nota |
| 2 | Estrato medio frente a bajo: +0,81 puntos en matemáticas | 14 | «0,81» | — |
| 3 | Educación materna hasta +7,44 (posgrado); computador +1,42; internet +1,14 | 14 (7,44 y 1,14) y 15 (1,42) | «7,44», «1,42», «1,14» | — |

### lee2024decada — `corpus/lee2024decada.pdf` (la página impresa es igual a la del PDF)

Se cita en la línea 51: «El seguimiento público de las brechas se hace sobre puntajes agregados».

| Fila | Afirmación | Página propuesta | Buscar | Observación |
|---|---|---|---|---|
| 1 | La brecha por NSE se reporta sobre el puntaje global | 13 (sección 6.2) | «Estrato socioeconómico de la vivienda», «prueba global» | **Matiz:** la brecha es **por estrato** (alto, estratos 4–6, frente a bajo). El informe también presenta resultados por área (por ejemplo, el gráfico 3 de la p. 6, por género). Falta ver si la brecha por estrato también va por área: si es así, «sobre el puntaje global» no es exacto. Lo que sí se sostiene es lo de la sección «Qué NO dice»: no desagrega por competencia |
| 2 | La brecha pasó de más de 60 puntos a 11,3 en 2023 | 13 (texto) y 14 (gráfico) | «por encima de los 60 puntos» | El texto dice que fue de más de 60 puntos en 2014–2016 y que de 2017 a 2023 oscila entre 10 y 30 puntos. **El 11,3 solo aparece entre los datos del gráfico de la p. 14:** confirmarlo mirando el gráfico |

### zabala2019impacto — `corpus/zabala2019impacto.pdf` (la página impresa es igual a la del PDF)

Se cita en la línea 83: «encuentran asociaciones similares en Norte de Santander, con un efecto contraintuitivo
del internet».

| Fila | Afirmación | Página propuesta | Buscar | Observación |
|---|---|---|---|---|
| 1 | El NSE del colegio y la posesión de computador se asocian con el desempeño | 9 (variables del modelo) y resultados (pp. 10–14) | «nivel socioeconómico del colegio», «tiene computador» | La p. 9 confirma que las dos variables están en el modelo. Falta ver en la tabla de resultados si son significativas |
| 2 | Reporta un efecto contraintuitivo del acceso a internet | 1 (resumen) y 16 (discusión) | «internet», «DEDICACIONINTERNET» | **El resumen y la discusión no dicen lo mismo:** el resumen dice que el internet **y la escolaridad de los padres** tienen impacto negativo y significativo; la discusión dice que la variable de internet no fue significativa y tuvo un signo inesperado. Además, si la escolaridad de los padres sale negativa, «asociaciones similares» (a las de Collazos) podría no sostenerse en el anteproyecto. Revisar la tabla de resultados |

## Bloque M (métodos) y datos

| Fuente | Fila | Qué comprobar | Estado de la pista |
|---|---|---|---|
| [[Literatura/rosseel2012lavaan]] | 1 (solo referencia; línea 263) | Datos bibliográficos | `corpus/rosseel2012lavaan.pdf`, p. 1: *Journal of Statistical Software*, mayo de 2012, vol. 48, n.º 2. Coincide con la nota |
| [[Literatura/wu2016identification]] | 1 (solo referencia; línea 257) | Datos bibliográficos y que propone la identificación que usa `ID.cat = "Wu.Estabrook.2016"` | PDF en el grupo de Zotero, no en este equipo |
| [[Literatura/chen2024structural]] | 1–5 (pp. 221–222, 221, 246, 221–246 y 370–375) | Cada fila, con la regla de la nota: página impresa = página del PDF − 21 | PDF del libro en el grupo de Zotero (adjuntado el 18/10), no en este equipo. Lo usan D-25 y la F6 |
| [[Literatura/rubin1987multiple]] | 1 (línea 262) | — | De pago. **Depende de D-10:** con (b), la cita se reemplaza por el Technical Report, p. 226 (`oecd2024pisa2022tr`, fila 16, por verificar) |
| [[Literatura/chen2007sensitivity]] | 1 (línea 258) | — | De pago. **Depende de D-10:** con (b) sale, y la F4 toma los cortes de [[Literatura/putnick2016measurement]] (D-25) |
| [[Literatura/oecd2023pisadb]] | 1: Colombia tiene 7.804 estudiantes en filas contiguas | Es un **dato**: se verifica volviendo a correr el script | Reproducido en este equipo el 2026-10-18: `01a` da «COL: filas 117013 a 124816 (7804 estudiantes)» en `CY08MSP_STU_COG.SAV`, y `01b` lee 7.804 filas de `CY08MSP_STU_QQQ.SAV`. Los dos se detienen si el bloque no es contiguo (línea 79 de `01a` y línea 45 de `01b`). Brayan puede firmarlo con esta corrida |
| [[Literatura/oecd2023pisadb]] | 2: condiciones de uso | Leer los términos en la página de la base (`doi_url` de la nota) | Sigue `sin_origen`. El 2026-10-18 la página pidió una verificación antibots (Cloudflare) y Claude no la saltó: la abre Brayan |

## Qué falta para cerrar el tercio

- Crear la cuenta de Zotero y entrar al grupo, para tener los PDF de Chen y Yung y de Wu y Estabrook.
- Decidir D-10 con Mateo. Eso define si Rubin (1987) y Chen (2007) siguen en el proyecto.
- Leer los términos de uso de la base de la OCDE (fila 2 de `oecd2023pisadb`).
