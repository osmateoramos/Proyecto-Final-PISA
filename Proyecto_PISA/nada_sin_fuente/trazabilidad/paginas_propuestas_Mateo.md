# Páginas propuestas para la trazabilidad de Mateo

> **Esto es una propuesta, no una verificación.** Claude la generó el 2026-10-12 buscando texto en los PDF de
> `corpus/` (lectura automática con pypdf). Mateo abre cada PDF en la página indicada y confirma. Solo entonces llena
> `ubicacion`, `se_sostiene`, `correccion_propuesta`, `verificado_por` y `fecha` en `trazabilidad_Mateo.csv`.
> Claude no tocó esas columnas.

**Cómo usarlo**
- *PDF p.* es el número que muestra el visor.
- *Impresa* es el número impreso en la hoja, y es el que va en la cita.
- Para llegar rápido: Ctrl+F con el texto entre «».
- Las citas se dejan cortas a propósito. La frase exacta la copia Mateo del original.

| Documento | Relación entre PDF e impresa |
|---|---|
| `oecd2024pisa2022tr` | impresa = PDF − 2 |
| `avvisati2024measurement` | impresa = PDF − 1 |
| `hernandez2011modelo` | impresa = PDF + 187 (la revista va de la p. 188 a la 203) |
| `cruz2016construccion` | impresa = PDF + 78 (la revista va de la p. 79 a la 92) |
| `icfes2024pisa`, `icfes2022marcomat`, `lee2024decada`, `mittal2022assessing` | iguales |
| `eriksson2021socioeconomic` | el artículo numera de 1 a 10; confirmar en el PDF |
| `icfes2019inse` | 7 páginas; el texto extraído se repite entre las pp. 3 y 6 por el diagramado: confirmar la página visible |

## Resumen

- **La fuente sostiene la afirmación tal como está (por confirmar):** T-Mat-02, 03, 09, 10, 13 y 16.
- **Se sostiene, pero hay un detalle que revisar:** T-Mat-01 (una palabra), T-Mat-05 (la nota del vault) y T-Mat-07
  (es una afirmación negativa).
- **La fuente no sostiene una parte de la afirmación:**
  - T-Mat-04: el documento sí compara grupos de la misma cohorte (por sexo).
  - T-Mat-06: la segunda mitad no sale del marco.
  - T-Mat-08: la cifra de Colombia es un dato nuestro, no del reporte técnico.
  - T-Mat-11: el modelo es jerárquico y los coeficientes son de Lenguaje.
  - T-Mat-12: «solo» es más fuerte que lo que dice el artículo.
- **Sin PDF:**
  - T-Mat-14: Rutkowski, de acceso cerrado.
  - T-Mat-15: Rolfe, solo se abre en el navegador.

Lo que no se sostiene es justo lo que el enunciado pide corregir en el anteproyecto y dejar dicho en la memoria.

## Fila por fila

### T-Mat-01 · `oecd2024pisa2022tr`
- **Página:** PDF 246 (impresa 244), *Annex Table 11.A.2*. Buscar «Colombia (COL)».
- **Lo que hay:** la fila de Colombia muestra 7,804 estudiantes en la muestra principal, prueba por computador (CBA)
  y 262 escuelas.
- **Revisar:** el título de la tabla habla de estudiantes y escuelas *muestreados*; la afirmación dice *evaluados*.
  Además, no ubiqué en esta pasada la página que dice que el dominio principal fue matemáticas.

### T-Mat-02 · `icfes2024pisa`
- **Página:** PDF 46 (impresa 46). Buscar «16 %».
- **Lo que hay:** 16 % de la variación, equivalente a 25 puntos; OCDE 15 % y Latinoamérica 13 %.
- **Revisar:** nada adicional; coincide con la cita del anteproyecto (p. 46).

### T-Mat-03 · `oecd2024pisa2022tr`
Tres partes, cada una en su página:
- **Componentes del ESCS:** PDF 403 (impresa 401). Buscar «Components of ESCS». Ocupación (HISEI), educación de los
  padres (PAREDINT) y posesiones del hogar (HOMEPOS).
- **HOMEPOS como escala TRI:** PDF 393 (impresa 391). Buscar «Home possessions (HOMEPOS)». La p. 402 remite a esa
  sección de escalas TRI.
- **Funcionamiento entre grupos:**
  - PDF 382 (impresa 380), buscar «country-by-language groups»: define los grupos país-idioma del escalamiento.
  - PDF 385 (impresa 383), buscar «invariance of latent constructs»: calibración multigrupo con invarianza parcial.
- **Revisar:** confirmar que ese procedimiento aplica a HOMEPOS y no solo a las otras escalas del cuestionario.

### T-Mat-04 · `icfes2019inse`
- **Páginas:** PDF 3 y 4. Buscar «unidimensionalidad», «entre periodos» y «consola de videojuegos».
- **Lo que hay:**
  - verifica la unidimensionalidad antes de estimar;
  - usa la TRI para mantener la escala comparable entre periodos.
- **No se sostiene «solo evalúa funcionamiento diferencial entre periodos».** En la PDF p. 4 el documento compara la
  curva del ítem *consola de videojuegos* por sexo: la curva de las mujeres aparece desplazada a la derecha. Es una
  comparación entre grupos de la misma cohorte, aunque sea con un solo ítem y a modo de ejemplo.
- **Corrección posible (Mateo decide):** «…asume una sola dimensión; compara el funcionamiento de los ítems entre
  periodos y lo ilustra por sexo con un solo ítem».
  - Antes de escribir «sin un análisis sistemático entre grupos», leer las 7 páginas. Yo solo hice búsquedas.
- **Nota del vault:** la afirmación 4 de `Literatura/icfes2019inse` («no entre grupos de una misma cohorte») tiene el
  mismo problema. La corrige quien verifica.

### T-Mat-05 · `lee2024decada`
- **Páginas:** PDF 13 (impresa 13) y gráfico de la p. 14. Buscar «brecha a favor».
- **Lo que hay:** la brecha se reporta sobre el puntaje global y por área: 11,3 puntos en 2023 en la prueba global.
  Sostiene «puntajes agregados».
- **Revisar la nota del vault:**
  - **No es «brecha por NSE»: la comparación es por estrato (alto frente a bajo).** En el texto extraído no aparece
    «nivel socioeconómico» ni «INSE».
  - Para «más de 60 puntos en los años iniciales»: el texto extraído del gráfico sugiere 58,5, 64,1 y 59,9 en
    2014–2016, es decir, más de 60 solo en un año. La lectura del gráfico es automática; confirmar mirándolo.

### T-Mat-06 · `icfes2022marcomat`
- **Página:** PDF 6 (impresa 6); también la p. 16. Buscar «Interpretación y representación».
- **Lo que hay:** las tres competencias.
- **La segunda mitad no sale de esta fuente.** «No publica resultados por competencia para cada estudiante» no está
  en el marco. Hay que buscarle otra fuente o reescribir la oración sin esa parte.

### T-Mat-07 · `icfes2024pisa`
- **Páginas:** PDF 14 (impresa 14) para los cuatro procesos; sección 3.1.3.1 para las subescalas de proceso de
  Colombia (el índice la ubica en la p. 31).
- **Revisar:** «sin cruzarlos con el NSE» es una afirmación negativa, y no se prueba con una sola página.
  - En la p. 46 la relación con el ESCS se reporta para matemáticas en conjunto.
  - Falta recorrer el resto de la sección 4 para confirmar que no hay un cruce por proceso.

### T-Mat-08 · `oecd2024pisa2022tr`
- **Página:** PDF 307 (impresa 305), *Annex Table 14.A.18*. Buscar «14.A.18».
- **Lo que hay:** seis correlaciones entre las subescalas de proceso, de 0,79 a 0,87. Sostiene el rango internacional.
- **No se sostiene con esta fuente:**
  - «0,70 a 0,83 en Colombia» es un **dato** nuestro, no del reporte técnico. Su origen debe ser el script de revisión
    y su archivo de salida; si no se encuentra, queda sin origen.
  - En la PDF p. 237 (impresa 235) el reporte advierte que las correlaciones se calculan con valores plausibles del
    mismo sorteo (PV1 con PV1, y así). Hay que confirmar que nuestro cálculo lo hizo así.
  - La p. 293 describe cómo se promedian estas tablas; confirmar que la 14.A.18 es un promedio entre países.

### T-Mat-09 · `cruz2016construccion`
- **Páginas:** PDF 1 (impresa 79), resumen; PDF 6 (impresa 84). Buscar «componentes principales» y «primera
  componente».
- **Lo que hay:** índice por análisis de componentes principales; se queda con la primera componente, confirmada con
  el análisis paralelo de Horn.
- **Revisar:** «unidimensional por construcción» es interpretación del equipo (el índice es un solo componente), no
  una frase del artículo.

### T-Mat-10 · `icfes2019inse`
- **Páginas:** PDF 3 y 4. Buscar «unidimensionalidad».
- **Lo que hay:** valida la unidimensionalidad antes de estimar el modelo TRI. Sostiene «asume una sola dimensión».

### T-Mat-11 · `hernandez2011modelo`
- **Página:** PDF 10 (impresa 197) y su Figura 2. Buscar «0.34».
- **Lo que hay:**
  - dos componentes, capital cultural-escolar (CCE) y nivel económico (NSE), bajo una variable latente de segundo
    orden (ESCE), con cargas de 1,00 y 0,83;
  - efectos sobre Lenguaje y comunicación: CCE de 0,28 a 0,34 y NSE de 0,22 a 0,31.
- **Revisar:**
  1. El modelo es jerárquico, no de «dos factores correlacionados». Conviene ajustar la redacción.
  2. Los rangos son de Lenguaje y comunicación; la afirmación dice «logro» en general.
  3. No busqué en el PDF la palabra «México» ni el tamaño de muestra; están en la nota, sin página.

### T-Mat-12 · `eriksson2021socioeconomic`
- **Páginas:** PDF 1, resumen (buscar «clearly outperform»); PDF 3, las seis medidas (buscar «six component»).
- **Lo que hay:**
  - el compuesto de NSE de PISA se descompone en seis variables;
  - en la sociedad típica, libros en casa y ocupación más alta de los padres superan claramente al resto.
- **«Solo… predicen sustantivamente» es más fuerte que la fuente.** Redacción posible: «dos de las seis componentes
  superan claramente al resto como predictores».

### T-Mat-13 · `avvisati2024measurement`
- **Páginas:** PDF 12 (impresa 11), buscar «unidimensional scale»; PDF 49 (impresa 48), buscar «theoretical
  framework».
- **Lo que hay:** coincide con la cita del anteproyecto (pp. 11 y 48).

### T-Mat-14 · `rutkowski2013measuring`
- **Sin PDF:** es de acceso cerrado. No hay página propuesta.
- **Opciones:**
  - conseguirlo por la biblioteca;
  - o reescribir la oración sin esta fuente y dejarlo dicho en la memoria.

### T-Mat-15 · `rolfe2021tailoring`
- **Sin PDF local:** se abre en el navegador pero no se descarga directo. Una vez abierto, buscar «invariance» y anotar
  la página.

### T-Mat-16 · `mittal2022assessing`
- **Páginas:** PDF 1 (*Page 1 of 28*), resumen; PDF 7.
  - Buscar «measurement invariance» y «exhibited DIF». En el PDF, «HOME-POS» aparece partido con guion.
- **Lo que hay:** prueban la invarianza de HOMEPOS de PISA 2018 y el DIF de sus ítems entre tres grupos: primera
  generación, segunda generación y sin origen inmigrante. Varios ítems muestran DIF en Noruega y en Suecia.

## Cómo se hizo (para la bitácora)
- **Búsqueda:** texto de los PDF extraído con pypdf y búsqueda por expresiones regulares en los 10 PDF de Mateo
  presentes en `corpus/`.
- **Páginas impresas:** se dedujeron de la cabecera o el pie de cada página.
- **Qué no se hizo:** no se leyó ningún documento completo. Las observaciones salen del contexto alrededor de cada
  coincidencia.
