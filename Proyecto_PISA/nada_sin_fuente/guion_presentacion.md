# Guion de la sustentación completa (10 minutos + 15 de preguntas)

Presentación: `presentacion.pdf`. Los números de diapositiva son los del pie de página (1/21 … 21/21). Las
diapositivas no dicen quién hizo cada cosa; este guion sí dice quién **habla** en cada una. Las portadas de sección
son el pase entre expositores: se dejan 1 o 2 segundos y se avanza. Detalle de bloques: `guion_Brayan.md` y
`guion_Mateo.md`. Cifras de `salidas/` al 2026-10-13.

| Minuto | Quién | Diapositivas | Qué se muestra |
|---|---|---|---|
| 0:00–0:50 | Vanessa | 1–3 | El proyecto PISA y por qué esta actividad |
| 0:50–2:00 | Vanessa | 4–5 | Los nueve fallos y el caso de fallo |
| 2:00–5:00 | Brayan | 6–11 | El experimento, el conteo en pantalla, el acuerdo, el banco y la decisión |
| 5:00–8:00 | Mateo | 12–15 y **demostración en vivo** | Cómo está montado, protocolo, trazabilidad, una consulta con su cita |
| 8:00–10:00 | Los tres | 16–18 | Qué corregimos, dónde falla, qué no delegamos y qué sigue |
| Preguntas | Cada uno, 5 min | 19–21 de respaldo | Demostración ya corrida, estadística y desvíos |

Diez minutos para 18 diapositivas es apretado: **cada diapositiva tiene un mensaje y se dice en una o dos frases.** Lo
demás queda para las preguntas.

## Antes de entrar (dejar abierto en el computador que proyecta)

1. `presentacion.pdf` en pantalla completa.
2. App de Claude, pestaña **Code**, lista para una sesión nueva en `Vault_PISA2022` (modo que pide permiso; Opus 5.5).
3. El protocolo v2 copiado (`protocolo/protocolo_consulta_v2.md`, «Texto para pegar (B)»).
4. `corpus/avvisati2024measurement.pdf` en la página 12 del visor (impresa 11) y la nota en Obsidian.
5. `trazabilidad/trazabilidad.md` y el PDF del anteproyecto, por si el profesor señala una frase.
6. El cuaderno de NotebookLM, por si pide ver C.
7. Plan B si algo falla en vivo: la diapositiva 19 o `evaluacion/respuestas_banco_Mateo.md`, sección B.

El profesor puede pedirle la demostración a **cualquiera** («a quien menos haya intervenido»): los tres deben haber
practicado el arranque de B en menos de 60 segundos.

---

## 0:00–0:50 · Vanessa · El proyecto

**Diapositiva 1 (portada) — 5 s.**
> Somos Vanessa, Mateo y Brayan.

**Diapositiva 2 (nuestro proyecto) — 25 s.**
> Nuestro proyecto pregunta en qué medida el nivel socioeconómico, medido como un constructo latente que mide lo
> mismo en todos los grupos, explica el desempeño en las cuatro competencias matemáticas de PISA 2022 en Colombia:
> 7 804 estudiantes y 262 colegios. El NSE explica el 16 % de la variación, pero esa brecha depende de cómo se mida el
> NSE y de cómo se califique. Los cinco objetivos van del NSE latente y su invarianza a la calificación por
> competencia, el modelo estructural y una API.

**Diapositiva 3 (por qué «Nada sin fuente») — 20 s.**
> Todo eso se apoya en un estado del arte de 37 fuentes, escrito con ayuda de IA. La actividad distingue tres tipos
> de invención: de búsqueda, de anclaje y de cálculo. Nuestro foco es el anclaje: que todo lo que entra al proyecto
> se pueda rastrear hasta la página del documento.

## 0:50–2:00 · Vanessa · Diagnóstico

**Diapositiva 4 (nueve fallos) — 45 s.**
> En nuestros inventarios hay nueve fallos de IA, en tres patrones. Uno: la IA escribe más de lo que dice la fuente,
> como un «solo» que Eriksson no dice o una cifra propia citada como de la OCDE. Dos: los procesos automáticos toman
> el objeto equivocado, como un PDF que era otro artículo. Tres: la herramienta no usa el contexto que creemos. Costó
> siete oraciones corregidas, una corrida descartada y una segunda versión del protocolo. Los nueve se detectaron
> igual: abriendo el documento.

**Diapositiva 5 (caso de fallo) — 25 s.**
> El caso más delicado: NotebookLM le atribuyó a Liu (2017) hallazgos sobre NSE y TIMSS que el PDF no tiene; el
> artículo que lo cita solo lo menciona por un punto de método, en la página 146. Completó de memoria una cita de
> segundo nivel. Por eso la regla 5 del protocolo obliga a declarar las citas indirectas.

**Pase:**
> Para elegir con qué herramienta trabajar, lo medimos. Brayan.

## 2:00–5:00 · Brayan · Experimento y decisión

**Diapositiva 6 (experimento) — 20 s.**
> Hicimos tres consultas reales del proyecto, cada una en tres tratamientos: A, Claude sin contexto, como control; B,
> Claude leyendo solo nuestro vault; y C, NotebookLM con los PDF. De 67 referencias cuentan 61, y las clasificamos los
> tres a ciegas.

**Diapositiva 7 (conteo) — 30 s.**
> A queda en 0,85, B en 0,83 y C en 0,71, pero ninguna diferencia es concluyente: B menos A es −0,01 con p = 1, y los
> intervalos incluyen el cero. Además, las referencias de una misma consulta no son independientes.

**Diapositiva 8 (gráfica) — 30 s.**
> El 0,85 de A sale de 13 de sus 22 referencias: las otras 9 son de pago y no hubo mayoría. Si se cuentan, A va de 0,50
> a 0,91; B, en azul, solo de 0,75 a 0,85. Con el experimento solo no se puede elegir.

**Diapositiva 9 (acuerdo) — 25 s.**
> Y el acuerdo entre nosotros fue bajo: kappa de Fleiss de 0,06. Casi todo el desacuerdo es si la fuente dice lo que
> se le atribuye o algo parecido. Las proporciones dependen de quién clasifica: hacía falta otra medida.

**Diapositiva 10 (banco) — 40 s.**
> Por eso hicimos un banco de 18 preguntas con respuesta y página conocidas, 15 dentro del corpus y 3 fuera. A no
> sostuvo ninguna con una fuente. C sostuvo las 15, pero en una pregunta trampa respondió con conocimiento externo. B
> sostuvo 12 y fue la única que se abstuvo en las tres de fuera; sus fallos vinieron de las notas.

**Diapositiva 11 (decisión) — 35 s.**
> Elegimos B, con una condición: una nota solo sirve de fuente si está verificada contra el PDF. B es la única que
> exporta a APA 7, está versionada y no se sale de sus fuentes. C se salió de sus fuentes y su cuaderno cambió entre
> corridas; A responde de memoria y sin páginas.

**Pase:**
> Así quedó montado. Mateo.

## 5:00–8:00 · Mateo · El sistema, funcionando

**Diapositiva 12 (cómo quedó montado) — 30 s.**
> Zotero guarda las 37 fuentes con una clave fija; `corpus/` tiene los 28 PDF con su procedencia; el vault tiene una
> nota por fuente con página, cita y estado; y Claude se abre solo en el vault. Vía empaquetada: sin índice propio.

**Diapositiva 13 (protocolo) — 25 s.**
> Antes de cada pregunta se pega este protocolo: solo lo que está en las fuentes, documento y página, «No está en las
> fuentes» cuando no está, citas indirectas declaradas y nada fuera del vault. La regla 6 nació cuando una corrida de B
> leyó la respuesta de A.

**Diapositiva 14 (trazabilidad) — 25 s.**
> Cada oración citada del anteproyecto tiene una fila: fuente, página, cita y quién la verificó con el PDF abierto. Hay
> 41 de 44 firmadas. En esta fila, la pista automática decía que «28 a 30» no estaba, y sí está: la pista no es
> evidencia.

**Diapositiva 15 → pasar a la app de Claude (1 min 40 s).**
1. Sesión nueva en `Vault_PISA2022`, pegar el protocolo v2 y preguntar por Avvisati y Wuyts (2024).
2. Mostrar la respuesta: la nota, la página 11 y el estado. Abrir el PDF en esa página y leer la frase.
3. Preguntar por la invarianza de HOMEPOS entre zonas rurales y urbanas → «No está en las fuentes.»
4. Si algo falla: decirlo y mostrar la diapositiva 19.

**Pase:**
> Y ahora, lo que encontramos y lo que no funciona.

## 8:00–10:00 · Los tres · Límites

**Diapositiva 16 (qué corregimos) — Mateo, 30 s.**
> Al firmar la trazabilidad hicimos diez correcciones al anteproyecto. Por ejemplo, Collazos no nombra mínimos
> cuadrados ordinarios, Eriksson no dice «solo», y una correlación que citábamos de la OCDE era cálculo propio.

**Diapositiva 17 (dónde falla).**
- **Mateo (15 s):** «B repite lo que digan sus notas, y hoy hay 8 de 45 verificadas».
- **Brayan (25 s):** «La clasificación depende de quién clasifica, kappa de 0,06, y no medimos búsqueda: no hubo un
  tratamiento de buscador».
- **Vanessa (20 s):** «Tres fuentes de pago quedaron sin firmar, no hubo auditoría cruzada y cada pregunta se corrió
  una vez».

**Diapositiva 18 (qué no delegamos y qué sigue) — Vanessa, 30 s.**
> No le delegamos a la IA firmar, verificar, clasificar ni decidir. Para el proyecto PISA, lo que sigue es verificar
> las notas que usarán los cinco objetivos antes de citarlas y consultar las fuentes nuevas con este sistema. La IA
> propone dónde buscar; una persona abre el documento y firma. Gracias.

---

## Preguntas: 5 minutos por persona

El profesor le pregunta a cada uno por su parte y, en la misma ronda, por algo que expuso otro. Lo mínimo que cada uno
debe saber de las otras partes:

| Parte | Tres datos que todos deben saber |
|---|---|
| **Proyecto y diagnóstico** | La pregunta del proyecto (NSE latente → cuatro competencias, PISA 2022 Colombia) y sus cinco objetivos. Nueve fallos en tres patrones; caso de fallo: Liu (2017), cita de segundo nivel → regla 5. Diez oraciones del anteproyecto corregidas (siete parciales). |
| **Experimento y decisión** | Ninguna diferencia concluyente (B − A = −0,01, p = 1,00); kappa de Fleiss 0,06; A va de 0,50 a 0,91 por sus 9 referencias sin mayoría. Banco: B 12/15 y 3/3 fuera; C 15/15 pero se salió de sus fuentes. Se eligió B con la condición de notas verificadas. |
| **Sistema** | Zotero (37 fuentes) → `corpus/` (28 PDF) → vault con estado por nota → Claude solo en el vault + protocolo v2 (6 reglas). Arranque: sesión nueva en `Vault_PISA2022`; no hay índice que reconstruir. 8 de 45 notas verificadas y 41 de 44 filas de trazabilidad firmadas. |

**Preguntas probables y quién las toma:**

- *«El enunciado pedía que B fuera un buscador. ¿Por qué no?»* · **Brayan.** Comparamos las dos herramientas
  candidatas para nuestro sistema contra el control; no corrimos un buscador. Está declarado: medimos anclaje, no
  búsqueda.
- *«¿Por qué no A, si sacó el número más alto?»* · **Brayan.** Ese 0,85 excluye sus 9 referencias más dudosas;
  contándolas puede bajar a 0,50. Y A no da páginas.
- *«¿Por qué no C, si en el banco fue perfecta dentro del corpus?»* · **Brayan.** Fuera del corpus respondió de
  memoria, y eso no se controla desde afuera; los fallos de B vienen de notas, y se corrigen verificándolas.
- *«Muéstreme de dónde sale esta frase del anteproyecto.»* · **Quien la verificó** (columna `verificado_por`). Se
  busca la fila en `trazabilidad.md`, se abre el PDF en la página y se lee la cita.
- *«¿Qué le corrigió a la IA?»* · **Cada uno, sus tres fallos del inventario.**
- *«¿Sacar las descartadas después de ver los datos no es acomodar el resultado?»* · **Brayan.** Está declarado y se
  muestran las dos versiones: contándolas, B baja a 0,65, y la decisión no cambia porque se apoya en el banco.
- *«¿Por qué hay 21 referencias sin clasificar por una persona?»* · **Vanessa.** Eran de pago y no pudo abrirlas; en
  esas, la etiqueta cuenta solo si los otros dos coinciden. Es el desvío 5.
- *«¿Hubo alguna referencia inventada?»* · **Brayan.** Por mayoría, solo Ekmekci (2013), y sí existe: su repositorio
  no abría. Lo declaramos.
- *«¿Qué tiene que ver esto con el proyecto PISA?»* · **Vanessa.** Las 37 fuentes son el estado del arte que
  justifica los cinco objetivos; con el sistema, cada cifra y cada antecedente que usemos en el informe tiene página y
  verificador.
- *«Si el sistema no arranca, ¿qué hacen?»* · **Mateo.** Decirlo, mostrar la corrida guardada (diapositiva 19) y
  explicar por qué falló: eso también se califica.
