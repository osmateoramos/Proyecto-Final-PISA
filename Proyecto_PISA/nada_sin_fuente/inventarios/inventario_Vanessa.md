# INVENTARIO DE FALLOS — Vanessa Acosta

Entregable individual (½ página). Lo escribe y lo firma su autor: el diagnóstico no se delega.
Al menos tres fallos propios de IA (en el agente, en el anteproyecto o en otro trabajo). Si cree que no tuvo ninguno,
revise antes las referencias del anteproyecto.

### Fallo 1

- **Herramienta:** Claude (dentro de este proyecto)
- **Qué generó:** En la clasificación de los ítems de matemáticas por competencia, el ítem `CMA112Q02S` no aparecía marcado como retirado de la escala internacional.
- **Qué estaba mal:** El ítem sí figura en el anexo A del Technical Report, con el código `CMA112Q02 (Dropped)` — de la competencia razonar, sin parámetros. El cruce automático no lo reconoció por la diferencia de código.
- **Cómo lo detecté:** Al revisar la clasificación de ítems de mi objetivo (O3), buscando ese ítem específico en todas las hojas del anexo.
- **Qué me costó:** Tuve que revisar de nuevo el conteo de ítems calibrables de las cuatro competencias antes de seguir.
- **Qué lo habría evitado:** Cruzar los códigos de ítem de forma manual, no solo automática, cuando el formato del código cambia entre fuentes.

### Fallo 2

- **Herramienta:** Claude
- **Qué generó:** Una afirmación en la matriz de estado del arte de que el DIF de matemáticas por NSE "no se ha estudiado en PISA".
- **Qué estaba mal:** Ya teníamos en la matriz a Liu y Bradley (2021), que sí usan el ESCS para explicar DIF en PISA 2012; además existen Goh et al. (2024, PISA 2022) y Kucam y Gülleroğlu (2023, PISA 2018).
- **Cómo lo detecté:** Revisando la literatura de mi propia parte del proyecto (O3, DIF), justo antes de usar esa afirmación como vacío de literatura.
- **Qué me costó:** Corregir la matriz y replantear cómo presentamos la novedad de esa parte del proyecto.
- **Qué lo habría evitado:** No dar por cerrada una búsqueda de literatura sin revisar las fuentes que ya teníamos agregadas antes.

### Fallo 3

- **Herramienta:** NotebookLM (tratamiento C del experimento de esta misma actividad)
- **Qué generó:** Al preguntarle por estudios de DIF por NSE en competencias de PISA, describió a "Liu (2017)" como un estudio que analizó el DIF según nivel socioeconómico, género, etnia y lengua materna en TIMSS 2011.
- **Qué estaba mal:** Liu (2017) sí existe y sí está citado en uno de mis PDF (Kucam y Gülleroğlu, 2023), pero ese documento solo lo cita para un punto metodológico puntual (qué método detecta más DIF), no para nada sobre NSE, género, etnia o TIMSS. La ficha real de Liu (2017) es una tesis doctoral sobre comparar métodos de detección de DIF.
- **Cómo lo detecté:** Abriendo el PDF de Kucam y Gülleroğlu y buscando "Liu 2017" para comparar la oración exacta contra lo que afirmó NotebookLM.
- **Qué me costó:** Nada grave porque lo detecté antes de usar la cita en algo, pero sí el tiempo de abrir el PDF y verificar línea por línea.
- **Qué lo habría evitado:** No confiar en la descripción de una cita de segundo nivel (una referencia citada dentro de otra) sin abrir el documento que la cita de verdad.

Firma: Vanessa Acosta · Fecha: 2026-10-12
