library (mirt)

> [!note] Archivado: diccionario de **Saber 11 (ICFES)**, etapa 1. El de PISA 2022 está en [[Datos/PISA2022 - Diccionario de variables]].

# Diccionario de las 92 variables originales

Volver a [[00 Inicio]] · Variables nuevas en [[Archivo Saber 11/Saber11 - Diccionario de variables recodificadas]] · Ítems en [[02 Clasificación de ítems (TRI)]]

Base: `Examen_Saber_11_20252.txt` tal como la entrega el ICFES. Generado con `Etapa1_Saber11/Proyecto/scripts/00_perfil_variables.R`
(estadísticas) y clasificado a mano (bloque, medida, rol). Si cambian una clasificación, editen aquí y anótenlo en
[[03 Registro de decisiones]].

- **% NA total:** sobre los 576.213 registros. **% NA analítica:** sobre los 495.807 con cuestionario.
- **Medida:** cómo se mide la variable. Decide qué modelo o recodificación aplica.
- **Rol:** para qué la usa el proyecto.
- **Nueva:** la variable que crea `01_etl.R` a partir de esta (vacío = se usa tal cual o no se usa).

## Resumen por rol

| Rol | Nº variables |
|---|---|
| No se usa | 31 |
| Indicador NSE | 18 |
| Contexto | 12 |
| Mediador | 4 |
| Excluida | 4 |
| Indicador habilidad | 4 |
| Candidato | 4 |
| Control | 3 |
| Filtro | 3 |
| Grupo | 3 |
| Agrupamiento | 2 |
| Validación | 2 |
| Por revisar | 1 |
| DESENLACE | 1 |

> [!warning] Hallazgos al armar el diccionario
> - Las columnas 85–92 traen **preguntas del cuestionario que no estaban en la clasificación de ítems**:
>   tiempo de la casa al colegio, medio de transporte, horas de trabajo no remunerado, comunidad campesina, número de hijos.
>   Algunas podrían ser indicadores de NSE o de ruralidad → evaluar en la fase 2 (quedan como *Candidato a evaluar*).
> - `estu_repite` trae números de 0 a 278.859 en vez de Sí/No: revisar en el diccionario oficial antes de usarla.
> - `estu_grado` incluye 25 y 26 (ciclos de educación de adultos), coherente con las jornadas noche/sabatina (D-06).
> - `estu_tieneetnia` solo trae 'S' (96 % vacío): usar `estu_grupoetnia`.

## 1. Identificación y control

| # | Variable | Descripción | Medida | Rol | Nueva | Cat. | Ejemplos | % NA total | % NA analítica |
|---|---|---|---|---|---|---|---|---|---|
| 1 | `periodo` | Periodo de aplicación (20252 = 2025-2) | Identificador | Control |  | 1 | 20252 | 0 | 0 |
| 2 | `estu_consecutivo` | Código anónimo del evaluado | Identificador | Control | `dup_consecutivo` | 576211 | SB11202530244351 · SB11202530244353 · SB11202530000001 · SB11202530… | 0 | 0 |
| 3 | `estu_estudiante` | Tipo de evaluado: estudiante de colegio o individual | Nominal | Filtro |  | 2 | ESTUDIANTE · INDIVIDUAL | 0 | 0 |
| 4 | `estu_tipodocumento` | Tipo de documento (TI, CC, PPT…) | Nominal | No se usa |  | 11 | TI · CC · PPT · CR | 0 | 0 |
| 27 | `estu_agregado` | Si el resultado se agrega a los del colegio | Binaria | No se usa |  | 2 | S · N | 0 | 0 |

## 2. Colegio

| # | Variable | Descripción | Medida | Rol | Nueva | Cat. | Ejemplos | % NA total | % NA analítica |
|---|---|---|---|---|---|---|---|---|---|
| 5 | `cole_area_ubicacion` | Zona del colegio (urbana / rural) | Nominal | Grupo (invarianza / DIF) | `zona` | 3 | URBANA · RURAL · URBANO | 5 | 0 |
| 6 | `cole_bilingue` | Colegio bilingüe (S/N) | Binaria | Contexto |  | 2 | N · S | 24,1 | 19,9 |
| 7 | `cole_calendario` | Calendario académico (A, B, otro) | Nominal | Contexto |  | 3 | A · OTRO · B | 5 | 0 |
| 8 | `cole_caracter` | Carácter: académico, técnico, técnico/académico | Nominal | Contexto |  | 4 | ACADÉMICO · TÉCNICO/ACADÉMICO · TÉCNICO · NO APLICA | 9,5 | 4,6 |
| 9 | `cole_cod_dane_establecimiento` | Código DANE del establecimiento | Identificador | Agrupamiento (colegio) |  | 10679 | rango 105001000001 a 568432001300 | 5 | 0 |
| 10 | `cole_cod_dane_sede` | Código DANE de la sede | Identificador | Agrupamiento (colegio) |  | 11917 | rango 105001000001 a 818001100027 | 5 | 0 |
| 11 | `cole_cod_depto_ubicacion` | Código del departamento del colegio | Código geográfico | Contexto |  | 33 | rango 5 a 99 | 5 | 0 |
| 12 | `cole_cod_mcpio_ubicacion` | Código del municipio del colegio | Código geográfico | No se usa |  | 1117 | rango 5001 a 99773 | 5 | 0 |
| 13 | `cole_codigo_icfes` | Código ICFES del colegio | Identificador | No se usa |  | 14066 | rango 83 a 822940 | 5 | 0 |
| 14 | `cole_depto_ubicacion` | Departamento del colegio | Nominal | Contexto |  | 34 | BOGOTÁ · ANTIOQUIA · CUNDINAMARCA · VALLE | 5 | 0 |
| 15 | `cole_genero` | Colegio mixto, femenino o masculino | Nominal | Contexto |  | 3 | MIXTO · FEMENINO · MASCULINO | 5 | 0 |
| 16 | `cole_jornada` | Jornada (mañana, tarde, única, completa, noche, sabatina) | Nominal | Mediador candidato / filtro | `jornada_adultos` | 6 | MAÑANA · UNICA · COMPLETA · TARDE | 5 | 0 |
| 17 | `cole_mcpio_ubicacion` | Municipio del colegio | Nominal | No se usa |  | 1048 | BOGOTÁ D.C. · MEDELLÍN · BARRANQUILLA · CALI | 5 | 0 |
| 18 | `cole_naturaleza` | Sector: oficial / no oficial | Binaria | Grupo (invarianza / DIF) | `sector` | 2 | OFICIAL · NO OFICIAL | 5 | 0 |
| 19 | `cole_nombre_establecimiento` | Nombre del establecimiento | Texto | No se usa |  | 9689 | INSTITUCION EDUCATIVA SIMON BOLIVAR · INSTITUCION EDUCATIVA SAN JOS… | 5 | 0 |
| 20 | `cole_nombre_sede` | Nombre de la sede | Texto | No se usa |  | 11182 | SEDE PRINCIPAL · INSTITUTO TECNICO INDUSTRIAL · SIMON BOLIVAR · COL… | 5 | 0 |
| 21 | `cole_sede_principal` | Si es la sede principal | Nominal | No se usa |  | 3 | S · N · P | 5 | 0 |

## 3. Ubicación del estudiante

| # | Variable | Descripción | Medida | Rol | Nueva | Cat. | Ejemplos | % NA total | % NA analítica |
|---|---|---|---|---|---|---|---|---|---|
| 28 | `estu_cod_depto_presentacion` | Código del departamento donde presentó | Código geográfico | No se usa |  | 33 | rango 5 a 99 | 0 | 0 |
| 29 | `estu_cod_mcpio_presentacion` | Código del municipio donde presentó | Código geográfico | No se usa |  | 560 | rango 5001 a 99773 | 0 | 0 |
| 30 | `estu_cod_reside_depto` | Código del departamento de residencia | Código geográfico | No se usa |  | 34 | rango 5 a 99999 | 0 | 0 |
| 31 | `estu_cod_reside_mcpio` | Código del municipio de residencia | Código geográfico | No se usa |  | 1119 | rango 5001 a 99999 | 0 | 0 |
| 34 | `estu_depto_presentacion` | Departamento donde presentó | Nominal | No se usa |  | 33 | BOGOTÁ · ANTIOQUIA · CUNDINAMARCA · VALLE | 0 | 0 |
| 35 | `estu_depto_reside` | Departamento de residencia | Nominal | No se usa |  | 34 | BOGOTÁ · ANTIOQUIA · CUNDINAMARCA · VALLE | 0 | 0 |
| 43 | `estu_mcpio_presentacion` | Municipio donde presentó | Nominal | No se usa |  | 542 | BOGOTÁ D.C. · MEDELLÍN · BARRANQUILLA · CALI | 0 | 0 |
| 44 | `estu_mcpio_reside` | Municipio de residencia | Nominal | No se usa |  | 1036 | BOGOTÁ D.C. · MEDELLÍN · BARRANQUILLA · CALI | 0 | 0 |
| 45 | `estu_nacionalidad` | Nacionalidad | Nominal | Contexto |  | 50 | COLOMBIA · VENEZUELA · ECUADOR · VANUATU | 0 | 0 |
| 48 | `estu_pais_reside` | País de residencia | Nominal | No se usa |  | 21 | COLOMBIA · VENEZUELA · ECUADOR · ESPAÑA | 0 | 0 |

## 4. Características del estudiante

| # | Variable | Descripción | Medida | Rol | Nueva | Cat. | Ejemplos | % NA total | % NA analítica |
|---|---|---|---|---|---|---|---|---|---|
| 36 | `estu_discapacidad` | Reporta discapacidad (S/N) | Binaria | Contexto |  | 2 | N · S | 0 | 0 |
| 37 | `estu_etnia` | Pueblo étnico específico (130 valores) | Nominal | No se usa |  | 130 | Wayúu · Zenu (Senu) · Pasto · Nasa | 96,1 | 96,4 |
| 38 | `estu_fechanacimiento` | Fecha de nacimiento (dd/mm/aaaa) | Fecha | Control (edad) |  | 11649 | 17/09/2008 · 12/12/2008 · 24/09/2008 · 26/09/2008 | 0 | 0 |
| 39 | `estu_genero` | Sexo del evaluado (F/M) | Binaria | Grupo (invarianza / DIF) | `sexo` | 2 | F · M | 0 | 0 |
| 40 | `estu_grado` | Grado (11; 25 y 26 = ciclos de adultos) | Nominal | Filtro |  | 3 | 11 · 26 · 25 | 4,9 | 0 |
| 49 | `estu_privado_libertad` | Persona privada de la libertad | Binaria | Filtro |  | 2 | N · S | 0 | 0 |
| 50 | `estu_repite` | ¿Ha repetido? — trae números de 0 a 278.859: REVISAR con el diccionario oficial | Por revisar | Por revisar |  | 10933 | rango 0 a 278859 | 0 | 0 |
| 51 | `estu_tieneetnia` | Pertenece a un grupo étnico (solo trae 'S') | Binaria | No se usa |  | 1 | S | 96,1 | 96,4 |
| 85 | `estu_grupoetnia` | Grupo étnico (ninguno, afro, indígena, raizal…) | Nominal | Contexto |  | 6 | NINGUNO · NEGRO AFRODESCENDIENTE · INDIGENA · RAIZAL | 0 | 0 |
| 87 | `estu_comunidadcampesina` | Pertenece a comunidad campesina | Binaria | Candidato a evaluar |  | 2 | NO · SI | 5,6 | 0,6 |
| 88 | `estu_numhijos` | Número de hijos del evaluado | Ordinal | Contexto |  | 5 | 0 · 1 · 2 · 3 | 5,6 | 0,6 |

## 5. Hábitos y trabajo del estudiante (cuestionario)

| # | Variable | Descripción | Medida | Rol | Nueva | Cat. | Ejemplos | % NA total | % NA analítica |
|---|---|---|---|---|---|---|---|---|---|
| 32 | `estu_dedicacioninternet` | Tiempo diario navegando en internet | Ordinal | Mediador candidato |  | 5 | Entre 1 y 3 horas · Entre 30 y 60 minutos · Más de 3 horas · 30 min… | 16,2 | 2,8 |
| 33 | `estu_dedicacionlecturadiaria` | Tiempo diario de lectura por entretenimiento | Ordinal | Mediador candidato |  | 5 | 30 minutos o menos · No leo por entretenimiento · Entre 30 y 60 min… | 16 | 2,6 |
| 41 | `estu_horassemanatrabaja` | Horas semanales de trabajo remunerado | Ordinal | Mediador candidato |  | 5 | 0 · Menos de 10 horas · Entre 11 y 20 horas · Entre 21 y 30 horas | 13,9 | 5,4 |
| 52 | `estu_tiporemuneracion` | Tipo de pago por el trabajo | Nominal | Contexto |  | 4 | No · Si, en efectivo · Si, en especie · Si, en efectivo y especie | 14 | 5,6 |
| 89 | `estu_horastrabnoremu` | Horas semanales de trabajo no remunerado | Ordinal | Candidato a evaluar |  | 5 | 0 · Menos de 10 horas · Entre 11 y 20 horas · Más de 30 horas | 7 | 2,1 |
| 91 | `estu_tiempocasaacole` | Tiempo de la casa al colegio | Ordinal | Candidato a evaluar |  | 4 | Menos de 15 minutos · Entre 15 y 30 minutos · Entre 30 minutos y un… | 5,6 | 0,6 |
| 92 | `estu_desplazacolegio` | Medio de transporte al colegio | Nominal | Candidato a evaluar |  | 4 | Caminando o en bicicleta · En transporte escolar o particular · En … | 5,6 | 0,6 |

## 6. Hogar y familia (cuestionario socioeconómico)

| # | Variable | Descripción | Medida | Rol | Nueva | Cat. | Ejemplos | % NA total | % NA analítica |
|---|---|---|---|---|---|---|---|---|---|
| 53 | `fami_comecarnepescadohuevo` | Frecuencia de consumo de carne, pescado o huevo | Ordinal | Indicador NSE (E. alimentación) | `come_proteina` | 4 | Todos o casi todos los días · 3 a 5 veces por semana · 1 o 2 veces … | 16,1 | 2,7 |
| 54 | `fami_comecerealfrutoslegumbre` | Frecuencia de consumo de cereales, frutas, legumbres | Ordinal | Indicador NSE (E. alimentación) | `come_cereal` | 4 | 1 o 2 veces por semana · 3 a 5 veces por semana · Nunca o rara vez … | 16,3 | 2,9 |
| 55 | `fami_comelechederivados` | Frecuencia de consumo de leche y derivados | Ordinal | Indicador NSE (E. alimentación) | `come_lacteos` | 4 | 1 o 2 veces por semana · Todos o casi todos los días · 3 a 5 veces … | 16,7 | 3,4 |
| 56 | `fami_cuartoshogar` | Cuartos del hogar | Ordinal | Indicador NSE (D. vivienda) | `cuartos`, `hacinamiento` | 6 | Dos · Tres · Cuatro · Uno | 12 | 3,3 |
| 57 | `fami_educacionmadre` | Máximo nivel educativo de la madre | Ordinal | Indicador NSE (B. cultural) | `educ_madre`, `educ_max` | 12 | Secundaria (Bachillerato) completa · Educación profesional completa… | 14 | 0,3 |
| 58 | `fami_educacionpadre` | Máximo nivel educativo del padre | Ordinal | Indicador NSE (B. cultural) | `educ_padre`, `educ_max` | 12 | Secundaria (Bachillerato) completa · Secundaria (Bachillerato) inco… | 13,9 | 0,3 |
| 59 | `fami_estratovivienda` | Estrato de la vivienda | Ordinal | Indicador NSE (D. vivienda) | `estrato` | 7 | Estrato 2 · Estrato 1 · Estrato 3 · Estrato 4 | 15,1 | 1,6 |
| 60 | `fami_numlibros` | Libros en el hogar | Ordinal | Indicador NSE (B. cultural) | `libros` | 4 | 0 A 10 LIBROS · 11 A 25 LIBROS · 26 A 100 LIBROS · MÁS DE 100 LIBROS | 16,3 | 3 |
| 61 | `fami_personashogar` | Personas en el hogar | Ordinal | Indicador NSE (D. vivienda) | `personas`, `hacinamiento` | 5 | 3 a 4 · 5 a 6 · 1 a 2 · 7 a 8 | 11,8 | 3,1 |
| 62 | `fami_situacioneconomica` | Situación económica frente al año anterior (mejor/igual/peor) | Ordinal | Excluida (percepción, no nivel) |  | 3 | Igual · Mejor · Peor | 14,4 | 6 |
| 63 | `fami_tieneautomovil` | Hogar tiene automóvil | Binaria | Indicador NSE (A. bienes) | `b_automovil` | 2 | No · Si | 14 | 5,5 |
| 64 | `fami_tienecomputador` | Hogar tiene computador | Binaria | Indicador NSE (A. bienes) | `b_computador` | 2 | Si · No | 11,9 | 3,2 |
| 65 | `fami_tieneconsolavideojuegos` | Hogar tiene consola de videojuegos | Binaria | Indicador NSE (A. bienes) | `b_consolavideojuegos` | 2 | No · Si | 14,1 | 5,6 |
| 66 | `fami_tienehornomicroogas` | Hogar tiene horno microondas o a gas | Binaria | Indicador NSE (A. bienes) | `b_hornomicroogas` | 2 | No · Si | 13,5 | 4,9 |
| 67 | `fami_tieneinternet` | Hogar tiene internet | Binaria | Indicador NSE (A. bienes) | `b_internet` | 2 | Si · No | 15 | 1,4 |
| 68 | `fami_tienelavadora` | Hogar tiene lavadora | Binaria | Indicador NSE (A. bienes) | `b_lavadora` | 2 | Si · No | 12,8 | 4,2 |
| 69 | `fami_tienemotocicleta` | Hogar tiene motocicleta | Binaria | Excluida (carga 0,12; D-03) | `b_motocicleta` | 2 | No · Si | 13,9 | 5,4 |
| 70 | `fami_tieneserviciotv` | Hogar tiene servicio de TV | Binaria | Indicador NSE (A. bienes) | `b_serviciotv` | 2 | Si · No | 15,4 | 1,9 |
| 71 | `fami_trabajolabormadre` | Ocupación de la madre | Nominal | Indicador NSE (C. ocupación) | `ocup_madre`, `ocup_max` | 13 | Trabaja en el hogar, no trabaja o estudia · Trabaja como personal d… | 12 | 3,3 |
| 72 | `fami_trabajolaborpadre` | Ocupación del padre | Nominal | Indicador NSE (C. ocupación) | `ocup_padre`, `ocup_max` | 13 | Es agricultor, pesquero o jornalero · Trabaja por cuenta propia (po… | 12 | 3,3 |
| 86 | `fami_numhermanos` | Número de hermanos | Ordinal | Excluida (no es NSE) |  | 5 | 1 · 2 · 0 · 3 | 5,6 | 0,6 |
| 90 | `fami_posicionhermanos` | Posición entre los hermanos | Nominal | Excluida (22 % NA) |  | 3 | El/La mayor · El/La menor · En medio | 26,2 | 22,4 |

## 7. Índices socioeconómicos del ICFES

| # | Variable | Descripción | Medida | Rol | Nueva | Cat. | Ejemplos | % NA total | % NA analítica |
|---|---|---|---|---|---|---|---|---|---|
| 42 | `estu_inse_individual` | Índice de nivel socioeconómico del ICFES (0–100, estimado con TRI) | Numérica | Validación + filtro de muestra |  | 462697 | rango 13.88276 a 88.36628 | 14 | 0 |
| 46 | `estu_nse_establecimiento` | Nivel socioeconómico promedio del colegio, 1–4 | Ordinal | Contexto (nivel colegio) |  | 4 | 2 · 3 · 4 · 1 | 5 | 0 |
| 47 | `estu_nse_individual` | Nivel socioeconómico del estudiante, NSE 1–4 (corte del INSE) | Ordinal | Validación |  | 4 | 3 · 2 · 1 · 4 | 14 | 0 |

## 8. Resultados de la prueba

| # | Variable | Descripción | Medida | Rol | Nueva | Cat. | Ejemplos | % NA total | % NA analítica |
|---|---|---|---|---|---|---|---|---|---|
| 22 | `desemp_c_naturales` | Nivel de desempeño en ciencias naturales (1–4) | Ordinal | No se usa (corte del puntaje) |  | 4 | 2 · 3 · 1 · 4 | 0 | 0 |
| 23 | `desemp_ingles` | Nivel de inglés (A-, A1, A2, B1, B+) | Ordinal | No se usa (corte del puntaje) |  | 5 | A- · A1 · A2 · B1 | 1,4 | 1,5 |
| 24 | `desemp_lectura_critica` | Nivel de desempeño en lectura crítica (1–4) | Ordinal | No se usa (corte del puntaje) |  | 4 | 3 · 2 · 4 · 1 | 0 | 0 |
| 25 | `desemp_matematicas` | Nivel de desempeño en matemáticas (1–4) | Ordinal | No se usa (corte del puntaje) |  | 4 | 3 · 2 · 1 · 4 | 0 | 0 |
| 26 | `desemp_sociales_ciudadanas` | Nivel de desempeño en sociales (1–4) | Ordinal | No se usa (corte del puntaje) |  | 4 | 2 · 1 · 3 · 4 | 0 | 0 |
| 73 | `percentil_c_naturales` | Percentil en ciencias naturales | Numérica | No se usa (transformación del puntaje) |  | 100 | rango 1 a 100 | 0 | 0 |
| 74 | `percentil_global` | Percentil global | Numérica | No se usa (transformación del puntaje) |  | 100 | rango 1 a 100 | 1,4 | 1,5 |
| 75 | `percentil_ingles` | Percentil en inglés | Numérica | No se usa (transformación del puntaje) |  | 100 | rango 1 a 100 | 1,4 | 1,5 |
| 76 | `percentil_lectura_critica` | Percentil en lectura crítica | Numérica | No se usa (transformación del puntaje) |  | 100 | rango 1 a 100 | 0 | 0 |
| 77 | `percentil_matematicas` | Percentil en matemáticas | Numérica | No se usa (transformación del puntaje) |  | 100 | rango 1 a 100 | 0 | 0 |
| 78 | `percentil_sociales_ciudadanas` | Percentil en sociales | Numérica | No se usa (transformación del puntaje) |  | 100 | rango 1 a 100 | 0 | 0 |
| 79 | `punt_c_naturales` | Puntaje de ciencias naturales (0–100) | Numérica | Indicador habilidad general (g) |  | 65 | rango 0 a 100 | 0 | 0 |
| 80 | `punt_global` | Puntaje global (0–500, ponderado de las 5 pruebas) | Numérica | No se usa (redundante) |  | 414 | rango 0 a 500 | 0 | 0 |
| 81 | `punt_ingles` | Puntaje de inglés (0–100) | Numérica | Indicador habilidad general (g) |  | 67 | rango 0 a 100 | 1,4 | 1,5 |
| 82 | `punt_lectura_critica` | Puntaje de lectura crítica (0–100) | Numérica | Indicador habilidad general (g) |  | 66 | rango 0 a 100 | 0 | 0 |
| 83 | `punt_matematicas` | Puntaje de matemáticas (0–100) | Numérica | DESENLACE |  | 78 | rango 0 a 100 | 0 | 0 |
| 84 | `punt_sociales_ciudadanas` | Puntaje de sociales y ciudadanas (0–100) | Numérica | Indicador habilidad general (g) |  | 72 | rango 0 a 100 | 0 | 0 |
