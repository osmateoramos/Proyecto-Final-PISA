# Clasificación de ítems para TRI

> [!note] Archivado: corresponde a la etapa con Saber 11. El proyecto actual está en [[07 Plan de desarrollo PISA 2022]] (decisión D-11).

Volver a [[00 Inicio]] · Siguiente paso en [[01 Plan paso a paso]]

## Qué creemos que pidió el profesor

No tenemos las respuestas a las preguntas de la **prueba** (reserva legal), pero sí
tenemos las respuestas a las preguntas del **cuestionario socioeconómico**, y esas
también son ítems. El ICFES construye el INSE justamente aplicando TRI sobre ellas
(2PL para dicotómicos, respuesta graduada o nominal para politómicos).

"Identificar los grupos de ítems y clasificarlos" se lee en dos ejes:

1. **Por formato de respuesta** → decide *qué modelo TRI* se ajusta a cada ítem.
2. **Por contenido / dimensión** → decide *qué ítems forman una misma escala*
   (TRI unidimensional supone que todos los ítems de una escala miden un solo rasgo).

> [!question] Confirmar con el profesor
> "Profe, ¿lo que nos pide es clasificar los ítems del cuestionario socioeconómico por
> tipo de respuesta y por dimensión, para luego ajustar un modelo TRI por grupo
> (2PL / GRM / nominal)? ¿O se refiere a otra cosa?"
> Llevar impresa la tabla de abajo.

## Eje 1 — Formato de respuesta → modelo TRI

| Formato | Ítems | Modelo TRI | `itemtype` en `mirt` |
|---|---|---|---|
| Dicotómico (Sí/No) | `fami_tiene*` (8 ítems) | 2PL | `"2PL"` |
| Ordinal politómico | educación madre/padre, estrato, libros, cuartos, personas, alimentación (3), dedicación internet, lectura diaria, horas trabajo | Respuesta graduada (Samejima) | `"graded"` |
| Nominal (sin orden) | ocupación madre, ocupación padre (13 categorías) | Respuesta nominal (Bock) — o recodificar a escala ordinal de prestigio y usar GRM | `"nominal"` |

## Eje 2 — Contenido → grupos candidatos (dimensiones)

Categorías y faltantes calculados sobre los 495.807 evaluados con cuestionario.
Los % NA de estas tablas son **antes** de convertir "No sabe"/"Sin Estrato"/"hogar" en NA;
los faltantes definitivos están en [[Archivo Saber 11/Saber11 - Diccionario de variables recodificadas]].

### A. Bienes del hogar (capital económico)
| Ítem | Categorías | % NA | Nota |
|---|---|---|---|
| `fami_tienecomputador` | Sí/No | 3,2 | carga 0,80 en la auditoría |
| `fami_tieneinternet` | Sí/No | 1,4 | 0,76 |
| `fami_tieneconsolavideojuegos` | Sí/No | 5,6 | 0,68 · **candidato a DIF por sexo** (lo muestra el propio ICFES) |
| `fami_tienehornomicroogas` | Sí/No | 4,9 | 0,67 |
| `fami_tieneautomovil` | Sí/No | 5,5 | 0,64 |
| `fami_tienelavadora` | Sí/No | 4,2 | 0,62 |
| `fami_tieneserviciotv` | Sí/No | 1,9 | 0,57 |
| `fami_tienemotocicleta` | Sí/No | 5,4 | 0,12 → **sale** (casi 50/50 y no discrimina; es bien rural/de trabajo) |

### B. Capital cultural
| Ítem | Categorías | % NA | Recodificación |
|---|---|---|---|
| `fami_educacionmadre` | 12 | 0,3 | 6 niveles; "No sabe"/"No Aplica" → NA |
| `fami_educacionpadre` | 12 | 0,3 | ídem (ojo: "No sabe" padre = 44.927, 9 %) |
| `fami_numlibros` | 4 | 3,0 | ordinal 1–4 |

### C. Ocupación de los padres
| Ítem | Categorías | % NA | Recodificación |
|---|---|---|---|
| `fami_trabajolabormadre` | 13 | 3,3 | nominal, o prestigio ordinal (ver abajo) |
| `fami_trabajolaborpadre` | 13 | 3,3 | ídem |

Propuesta de prestigio ordinal (decidir en [[03 Registro de decisiones]]):
1 = agricultor/jornalero, limpieza/construcción · 2 = operario/conductor, vendedor, cuenta propia ·
3 = auxiliar administrativo, negocio pequeño · 4 = profesional · 5 = directivo/negocio grande.
"Hogar/no trabaja", "Pensionado", "No sabe", "No aplica" → tratar aparte (NA o categoría nominal).
Eriksson et al. (2021) encontraron que la ocupación es de las dos dimensiones que más predicen logro: **no conviene dejarla fuera**.

### D. Vivienda
| Ítem | Categorías | % NA | Nota |
|---|---|---|---|
| `fami_estratovivienda` | 6 + "Sin Estrato" | 1,6 | "Sin Estrato" → NA; ICFES lo usa solo como validación externa |
| `fami_cuartoshogar` | 6 | 3,3 | carga 0,31 |
| `fami_personashogar` | 5 | 3,1 | relación **inversa**; mejor combinar: hacinamiento = personas / cuartos |

### E. Alimentación (privación)
| Ítem | Categorías | % NA |
|---|---|---|
| `fami_comecarnepescadohuevo` | 4 (frecuencia semanal) | 2,7 |
| `fami_comecerealfrutoslegumbre` | 4 | 2,9 |
| `fami_comelechederivados` | 4 | 3,4 |

No entraron en la auditoría: hay que probar si cargan en NSE o forman un factor propio.

### F. Conductas del estudiante — NO son NSE
`estu_dedicacioninternet`, `estu_dedicacionlecturadiaria`, `estu_horassemanatrabaja`,
`estu_tiporemuneracion`. Son hábitos del estudiante, no del hogar: pueden usarse como
mediadores en el modelo estructural, no como indicadores del NSE.

### G. Candidatos nuevos (aparecieron al armar [[Archivo Saber 11/Saber11 - Variables originales ICFES]], D-10)
| Ítem | Categorías | Formato | Hipótesis |
|---|---|---|---|
| `estu_tiempocasaacole` | 4 | ordinal | acceso / ruralidad |
| `estu_desplazacolegio` | 4 | nominal | acceso / ruralidad |
| `estu_horastrabnoremu` | 5 | ordinal | carga de trabajo en el hogar (mediador, como F) |
| `estu_comunidadcampesina` | 2 | binaria | contexto |

### Excluidos del modelo de medida
`fami_situacioneconomica` (percepción de cambio, no nivel), `fami_numhermanos`,
`fami_posicionhermanos` (22 % NA). Justificar en [[03 Registro de decisiones]].

## Qué se hace con esta clasificación

1. **Verificar** que cada grupo sea unidimensional (análisis paralelo + AFE policórico).
2. **Ajustar** el modelo TRI que corresponde a cada grupo.
3. **Leer** parámetros: discriminación *a* (cuánto separa el ítem) y umbrales *b* (en qué
   nivel de NSE se vuelve probable responder "Sí"/subir de categoría).
4. **Comparar** con un modelo multidimensional (grupos A–E a la vez) y con el INSE oficial.
5. **DIF** de estos ítems por sexo y zona → esta es la parte TRI de la invarianza (objetivo 4).

Detalle operativo en [[01 Plan paso a paso]], fases 2 y 3.
