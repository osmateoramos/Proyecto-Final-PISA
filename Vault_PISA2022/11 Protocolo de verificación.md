---
tipo: guia
estado: por_verificar
lectura: "redactado por Claude; falta aprobación del equipo"
verificado_por:
fecha_verificacion:
---

# Protocolo de verificación — cómo evitamos que la IA (o nosotros) inventemos

Volver a [[00 Inicio]] · Herramientas en [[10 Gestión de la información]] · Reglas para Claude en `CONSULTORIA/CLAUDE.md`

## Principio

**Si no está en el vault con su origen, no existe para el informe ni para la IA.**
Ninguna herramienta elimina por completo los errores de una IA; este protocolo hace que **toda afirmación sea
rastreable** y que **los errores se detecten antes de llegar al informe**.

## Tres tipos de información

| Tipo | Ejemplo | Origen obligatorio | Dónde vive |
|---|---|---|---|
| **Dato** | "175 de 234 ítems tienen ≥100 respuestas en Q1 y Q4" | Script + archivo de salida + fecha (y commit, cuando haya Git) | Nota de dato (`Plantillas/Nota de dato`) o tabla en `salidas/` |
| **Fuente** | "Eriksson et al. usan 6 dimensiones del NSE" | Clave bib + página + cita textual corta | Nota de la fuente en `Literatura/` |
| **Interpretación / decisión** | "La zona parece antecedente, no mediador" | Quién, cuándo, por qué | [[03 Registro de decisiones]] |

## Estados (propiedad `estado` al inicio de cada nota)

| Estado | Significa | ¿Se puede usar en el informe? |
|---|---|---|
| `verificado` | Un integrante lo comprobó contra el original (PDF con página, o volvió a correr el script) | Sí |
| `por_verificar` | Tiene origen, pero nadie del equipo lo ha comprobado (incluye todo lo que aporta Claude) | No, hasta verificarlo |
| `sin_origen` | Afirmación sin fuente ni script | No. Buscar el origen o descartar |
| `descartado` | Se comprobó que era falso o no aplica | No (se conserva tachado, con la razón) |

**Claude nunca marca nada como `verificado`.** Solo un integrante del equipo (Vanessa, Mateo o Brayan), poniendo su nombre y la fecha.

## Propiedades de cada nota

```yaml
---
tipo: fuente | dato | guia | decisiones | hipotesis
estado: por_verificar
lectura: "equipo: texto completo" | "IA: resumen automático del texto completo" | "IA: solo resumen/fragmento"
verificado_por:
fecha_verificacion:
---
```

Dentro de una nota con varias afirmaciones, cada fila de la tabla de afirmaciones lleva su propio estado y página.

## Cómo se verifica

- **Una fuente:** abrir el PDF en Zotero → buscar la afirmación → anotar página y cita textual (< 15 palabras) en la
  nota → cambiar `estado` de la fila a `verificado` → poner nombre y fecha arriba.
- **Un dato:** volver a correr el script indicado → comprobar que la salida coincide → anotar fecha, commit y nombre.
- **Si no coincide:** corregir la nota, dejar la versión anterior ~~tachada~~ con la razón y avisar en
  [[03 Registro de decisiones]] si cambia alguna decisión.

## Lista de pendientes (requiere el plugin Dataview)

```dataview
TABLE tipo, estado, lectura, verificado_por
WHERE estado = "por_verificar" OR estado = "sin_origen"
SORT tipo ASC, file.name ASC
```

## Reglas para cualquier IA que use el vault

1. Responder solo con lo que está en el vault, los datos o una fuente abierta en esa sesión, citando la nota o
   el archivo.
2. Si no encuentra la respuesta: decir "no está en el vault". Nunca completar con memoria propia.
3. Indicar el estado de lo que cita (`por_verificar` se dice explícitamente).
4. Al detectar un error propio, decirlo y corregir la nota.

## Errores ya detectados (para aprender del caso)

| Fecha | Error | Cómo se detectó | Corrección |
|---|---|---|---|
| 2026-09-29 | Claude reportó 15,7 % de estudiantes con respuestas rápidas y 25,8 % de acierto, mezclando respuestas rápidas con omisiones | Al reescribir el cálculo en el script de revisión | Separado: 3,3 % responde rápido; 10,6 % omite > 25 % de lo que ve |
| 2026-10-01 | Claude citó números de capítulo del Technical Report sin verificarlos | Revisión antes de guardar la nota 07 | Se quitaron los números de capítulo |
| 2026-10-01 | Claude escribió iniciales de autores (Ingram, Rios, Soland, Avvisati) que no salían de ninguna fuente de la sesión | Revisión de las notas de fuente recién creadas | Reemplazadas por "nombres completos por completar" |
| 2026-10-01 | Claude escribió "Zotero 7" en la nota 10; la versión vigente es Zotero 10 | Al buscar los enlaces oficiales de descarga | Corregido en [[10 Gestión de la información]], con aviso de compatibilidad de Better BibTeX |
| 2026-10-04 | Claude tomó solo 18 ítems de posesiones del hogar (ST250, ST251, ST254, ST255); HOMEPOS 2022 usa también ST253 y ST256 (27 ítems disponibles para Colombia) | Al leer la sección de HOMEPOS del Technical Report 2022 | Corregido en las notas 06 y 07 y en `revision_pisa2022_col.R` (falta reconstruir el caché) |
| 2026-10-05 | La matriz (y la tabla de vacío del anteproyecto) decían que el DIF de matemáticas por NSE "no se ha estudiado en PISA", aunque Liu y Bradley (2021), ya en la matriz, usan el ESCS para explicar DIF en PISA 2012; además existen Goh et al. (2024, PISA 2022) y Kucam y Gülleroğlu (2023, PISA 2018) | Revisión de literatura del 2026-10-05 | Corregido en la matriz; el cambio al anteproyecto queda propuesto en [[13 Revisión de literatura]] |
| 2026-10-05 | La matriz marcaba ✓ (texto completo) al Technical Report y al informe nacional, que Claude solo consultó por búsqueda de secciones | Misma revisión | Cambiados a ◐ con la nueva leyenda |
| 2026-10-05 | Claude dijo que el ítem `CMA112Q02S` "falta" en el anexo A; sí está, con el código `CMA112Q02 (Dropped)`, que el cruce automático no reconoció | Búsqueda del ítem en todas las hojas del anexo | Corregido en las notas 03, 06, 07, la del Technical Report y el anteproyecto (propuesta D-09) |
| 2026-10-05 | El paso 3.2 del plan seguía diciendo 18 ítems de posesiones (son 27) y el 3.3 omitía ST253 y ST256; el script decía "los 18 internacionales" y citaba capítulos del Technical Report sin verificar | Revisión completa del vault y del script | Corregidos el plan, el script y su mensaje; caché del cuestionario reconstruido (27 ítems) |
| 2026-10-06 | Claude escribió en la nota 10 que el Zotero Connector estaba instalado; nunca se confirmó (solo Zotero 10.0.5, Better BibTeX y ZotLit Companion) | Al preparar el documento de gestión de la información | Corregido en la nota 10: queda como pendiente por confirmar |
| 2026-10-01 | La brecha de 79 puntos (meta de la puerta G1) venía de un fragmento de buscador, sin nota de origen | Revisión del plan 07 contra las notas de fuente | Marcada `sin_origen` en [[Literatura/oecd2023fichacolombia]] hasta abrir el PDF |
| 2026-10-12 | En `procedencia.csv` Claude anotó como PDF de García-Medina et al. (2016) un enlace de Redalyc que es otro artículo (Gómez-Benito et al., 2010): su revisión automática tomó el primer PDF de la página, que estaba en la lista de referencias | Al descargarlo, la primera página no coincidía con el título | Nota corregida con el PDF de SciELO México. Se comprobó que los otros 23 PDF del corpus coinciden con el título de su nota |
| 2026-10-12 | En `Literatura/mittal2022assessing` las tres afirmaciones decían «origen: IA, texto completo», aunque las tres citan el resumen (p. 1) y la propiedad `lectura` dice que el cuerpo no se ha leído (nota creada con Claude el 2026-10-05) | Lo señaló la corrida descartada del tratamiento B de Mateo | Cambiado a «origen: IA, resumen dentro del PDF» |
| 2026-10-13 | `Literatura/rutkowski2013measuring` y `Literatura/rolfe2021tailoring` decían `lectura: "equipo: texto completo"`, pero ninguno de los dos PDF se consiguió y nadie confirma haberlos leído; B repitió esa frase en su respuesta | Al firmar la trazabilidad (T-Mat-14 y T-Mat-15), Mateo solo pudo ver el resumen | `lectura` y el origen de la afirmación cambiados a «solo resumen / sin confirmar» |
| 2026-10-18 | `salidas/nse_tri_cargas_2d.csv` (de `03_nse_tri.R`, escrito con Claude el 2026-10-17) salió con todas las cargas del factor cultural en 0 y `h2` = 0 en los ítems culturales. `summary()` de `mirt` 1.46.1 devuelve 0 en esa columna en los modelos de 2 dimensiones, y el script no lo comprobó | Revisión de tutor del 2026-10-18: en el caché de los modelos, las pendientes culturales no son 0 (`ST255Q01JA`, 2,942) | Corregido el mismo día. La causa era un error de la función interna `Lambdas()` de `mirt` 1.46.1 (`sign()` de la pendiente del factor 1); el script usa la misma fórmula con el signo de la pendiente que no es 0 y lo comprueba contra `summary()`. Ver D-19 |
| 2026-10-18 | D-19 ordenaba los ítems del NSE por su *a*, mezclando 2PL y GPCM de 3 a 10 categorías, que no se pueden comparar entre sí; dejaba fuera al cuarto propio, que aporta menos información que HISCED | Misma revisión | Se agregó la información de cada ítem a `salidas/nse_parametros_tri.csv`; D-19 corregido, con la versión anterior tachada |
| 2026-10-18 | `04_invarianza.R` (escrito con Claude) usó `DIF()` de `mirt` sobre un modelo con `survey.weights`; `DIF()` re-estima sin los pesos y los X² salieron negativos. La prueba con datos simulados no lo detectó porque corría sin error | Los X² negativos y los p vacíos de la primera corrida; luego, el código de `DIF()` | D-26: prueba TRI sin pesos y magnitud con pesos. La corrida mala no se usa |
| 2026-10-18 | `datos/revision_pisa2022_col.R` (escrito con Claude) definía la respuesta rápida (NT10) con el 10 % de la **mediana** del tiempo del ítem, y lo atribuía a Rios y Soland; la fuente dice el 10 % de la **media** (Wise y Ma, 2012, citados por Rios y Soland, 2022, p. 18 del visor del preprint) | Al preparar D-05 para la F5, leyendo el PDF de Rios y Soland | Se corrige al fijar D-05: el NT10 del proyecto usará la media. Las cifras de desenganche de la revisión del 29/09 quedan como exploratorias |
| 2026-10-18 | Dos cifras del registro no coincidían con su archivo de salida vigente: el par policórico más alto (D-16 decía 0,85; la salida da 0,836) y los casos completos de la mitad de exploración (D-19 citaba 1.966, de antes de D-20; el archivo da ahora 2.362) | Misma revisión, comparando cada cifra con su archivo | Corregidas en D-16 y D-19, con la versión anterior a la vista |
