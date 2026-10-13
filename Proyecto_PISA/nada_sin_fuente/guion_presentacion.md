# Guion de la sustentación completa (10 minutos + 15 de preguntas)

Presentación: `presentacion.pdf`. Los números de diapositiva son los del pie de página (1/13 … 13/13). Las portadas de
sección («Diagnóstico · Vanessa», etc.) son el pase entre expositores: se dejan 1 o 2 segundos y se avanza.
Detalle de cada bloque: `guion_Brayan.md` (2–5′) y `guion_Mateo.md` (5–8′). Cifras de `salidas/` al 2026-10-13.

| Minuto | Quién | Diapositivas | Qué se muestra |
|---|---|---|---|
| 0:00–2:00 | Vanessa | 1–2 | Portada y los tres patrones de fallos |
| 2:00–5:00 | Brayan | 3–7 | El conteo en pantalla, el rango de A, el banco y la decisión |
| 5:00–8:00 | Mateo | 8–9 y **demostración en vivo** | Una consulta con su cita y una abstención |
| 8:00–10:00 | Los tres | 10–11 | Dónde falla y qué no le delegamos |
| Preguntas | Cada uno, 5 min | 12–13 de respaldo | Correcciones del anteproyecto y desvíos |

## Antes de entrar (dejar abierto en el computador que proyecta)

1. `presentacion.pdf` en pantalla completa.
2. App de Claude, pestaña **Code**, lista para una sesión nueva en `Vault_PISA2022` (modo que pide permiso; Opus 5.5).
3. El protocolo v2 copiado (`protocolo/protocolo_consulta_v2.md`, «Texto para pegar (B)»).
4. `corpus/avvisati2024measurement.pdf` en la página 12 del visor (impresa 11) y la nota en Obsidian.
5. `trazabilidad/trazabilidad.md` y el PDF del anteproyecto, por si el profesor señala una frase.
6. El cuaderno de NotebookLM, por si pide ver C.
7. Plan B si algo falla en vivo: `evaluacion/respuestas_banco_Mateo.md`, sección B.

El profesor puede pedirle la demostración a **cualquiera** («a quien menos haya intervenido»): los tres deben haber
practicado el arranque de B en menos de 60 segundos.

---

## 0:00–2:00 · Vanessa · Diagnóstico

**Diapositiva 1 (portada) — 10 s.**
> Somos Vanessa, Mateo y Brayan. Nuestro proyecto mide el NSE con PISA 2022 en Colombia, y esta actividad fue
> hacer que la IA responda solo con lo que se puede comprobar.

**Diapositiva 2 — 1 min 45 s.**
> Juntamos los inventarios de los tres: son nueve fallos de IA, y caen en tres patrones.
>
> El primero: la IA escribe más de lo que dice la fuente. De las 16 oraciones citadas que Mateo redactó con Claude,
> seis no se sostenían completas. Por ejemplo, un «solo» que el artículo de Eriksson no dice, y una cifra que
> calculamos nosotros citada como si fuera de la OCDE. En mi caso, Claude escribió en la matriz que el DIF por NSE
> «no se ha estudiado en PISA», cuando ya teníamos tres fuentes que lo hacían.
>
> El segundo: los procesos automáticos toman el objeto equivocado. Un script guardó como García-Medina un PDF que era
> otro artículo, y un cruce de códigos no reconoció un ítem retirado porque el código cambiaba de formato.
>
> El tercero, el más delicado: la herramienta no usa el contexto que creemos. NotebookLM le atribuyó a Liu (2017)
> hallazgos sobre NSE, género y TIMSS que el PDF no contiene: completó de memoria una cita que el artículo solo
> menciona de pasada. Y una corrida de B leyó la respuesta de A antes de responder.
>
> ¿Qué nos costó? Siete oraciones del anteproyecto corregidas, una corrida descartada y una segunda versión del
> protocolo. Los nueve se detectaron igual: abriendo el documento original.

**Pase:**
> Para elegir con qué herramienta trabajar no nos bastó la impresión: lo medimos. Brayan.

---

## 2:00–5:00 · Brayan · Experimento y decisión

**Diapositiva 3 — 20 s.**
> Cada uno hizo una consulta bibliográfica real de su parte del proyecto, y la corrimos en tres tratamientos: A,
> Claude sin contexto, que es el control; B, Claude leyendo solo nuestro vault; y C, NotebookLM con los PDF. Salieron
> 67 referencias; cuentan 61, porque B nombró 6 solo para descartarlas. Las clasificamos los tres a ciegas.

**Diapositiva 4 (el conteo) — 40 s.**
> A queda en 0,85, B en 0,83 y C en 0,71. Pero ninguna diferencia es concluyente: los intervalos se traslapan y los
> valores p son 1,00 y 0,43. Y el acuerdo entre nosotros fue bajo: kappa de Fleiss de 0,06.

**Diapositiva 5 (la gráfica) — 35 s.**
> Además, el 0,85 de A sale solo de 13 de sus 22 referencias. Las otras 9 son de pago y no hubo mayoría. La línea
> punteada muestra qué pasa si se cuentan: A puede quedar entre 0,50 y 0,91, mientras que B, en azul, se mueve solo
> entre 0,75 y 0,85. Con el experimento solo no se puede elegir.

**Diapositiva 6 (el banco) — 40 s.**
> Por eso hicimos un banco de 18 preguntas con respuesta y página conocidas: 15 dentro del corpus y 3 fuera. A no
> sostuvo ninguna con una fuente: se abstiene o responde de memoria. C sostuvo las 15, pero en una pregunta trampa,
> Colombia en TIMSS 2019, respondió con conocimiento externo, justo lo que el protocolo prohíbe. B sostuvo 12 y fue la
> única que se abstuvo en las tres de fuera. Sus fallos vinieron de las notas: una no decía «matemáticas» y otra
> traía el «solo» de Eriksson.

**Diapositiva 7 (la decisión) — 40 s.**
> Elegimos B, con una condición: una nota solo sirve de fuente si está verificada contra el PDF. B exporta a APA 7,
> está versionada en Git, deja rastro de la página y del estado de cada afirmación, y no se sale de sus fuentes.
> Descartamos C porque se salió de sus fuentes y su cuaderno cambió entre corridas, y A porque responde de memoria y
> sin páginas.

**Pase:**
> Así quedó montado y así funciona. Mateo.

---

## 5:00–8:00 · Mateo · El sistema, funcionando

Detalle completo en `guion_Mateo.md`.

**Diapositiva 8 — 40 s.** Las piezas: Zotero con las 37 fuentes; `corpus/` con 28 PDF y su procedencia; el vault con
una nota por fuente, con página, cita y estado; y la tabla de trazabilidad, con 41 de 44 filas firmadas. Claude se
abre solo en el vault, con un protocolo que le prohíbe salir de esa carpeta y de internet.

**Diapositiva 9 → pasar a la app de Claude (2 min).**
1. Sesión nueva en `Vault_PISA2022`, pegar el protocolo v2 y preguntar por Avvisati y Wuyts (2024).
2. Mostrar la respuesta: la nota, la página 11 y el estado. Abrir el PDF en esa página y leer la frase: el
   procedimiento «no cambió en 2018 ni en 2022».
3. Preguntar por la invarianza de HOMEPOS entre zonas rurales y urbanas de Colombia → «No está en las fuentes.»
4. Si algo falla: decirlo y mostrar la misma corrida en `respuestas_banco_Mateo.md`.

**Cierre de Mateo (20 s):**
> B no tiene índice: lee las notas tal como están. Para agregar una fuente se guarda el PDF, se crea su nota y se
> corre el script de procedencia.

**Pase:**
> Y ahora, lo que no funciona.

---

## 8:00–10:00 · Los tres · Límites

**Diapositiva 10 — Dónde falla.**

- **Mateo (30 s):**
  > B repite lo que digan sus notas, con sus errores: hoy hay 8 de 45 verificadas. Por eso la condición.
- **Brayan (30 s):**
  > La clasificación depende de quién clasifica: kappa de 0,06. Cada pregunta del banco se corrió una sola vez, y no
  > hubo auditoría cruzada con otro equipo.
- **Vanessa (25 s):**
  > Hay fuentes que no pudimos leer completas: Rubin, Goh y Pohl quedaron sin firmar, y cinco filas se verificaron
  > solo con el resumen. Está declarado.

**Diapositiva 11 — Qué no le delegamos (Vanessa, 25 s).**
> No le delegamos firmar una fila de trazabilidad, marcar una nota como verificada, clasificar las referencias,
> confirmar las calificaciones del banco ni decidir. La IA propone dónde buscar; una persona abre el documento y firma.
> Gracias.

---

## Preguntas: 5 minutos por persona

El profesor le pregunta a cada uno por su parte y, en la misma ronda, por algo que expuso otro. Lo mínimo que cada uno
debe saber de las otras partes:

| Parte | Tres datos que todos deben saber |
|---|---|
| **Diagnóstico** (Vanessa) | Nueve fallos en tres patrones. El caso de fallo: NotebookLM atribuyó a Liu (2017) hallazgos que no están en el PDF (p. 146 de Kucam y Gülleroğlu); por eso la regla 5 obliga a declarar las citas indirectas. En el anteproyecto, siete oraciones parciales corregidas y tres ajustes de redacción (diapositiva 12). |
| **Experimento** (Brayan) | Ninguna diferencia es concluyente (B − A = −0,01, p = 1,00) y el kappa de Fleiss es 0,06. El 0,85 de A excluye 9 referencias de pago: A va de 0,50 a 0,91. Se decidió con el banco: B 12/15 y 3/3 abstenciones fuera; C 15/15, pero respondió fuera de sus fuentes. |
| **Sistema** (Mateo) | Vía empaquetada: Zotero, `corpus/` con procedencia, vault con estado por nota, trazabilidad y protocolo v2. Arranque: sesión nueva en `Vault_PISA2022` y pegar el protocolo; no hay índice que reconstruir. Hoy hay 8 de 45 notas verificadas y 41 de 44 filas de trazabilidad firmadas. |

**Preguntas probables y quién las toma:**

- *«¿Por qué no A, si sacó el número más alto?»* · **Brayan.** Porque ese 0,85 excluye sus 9 referencias más
  dudosas; contándolas puede bajar a 0,50. Y A no da páginas.
- *«¿Por qué no C, si en el banco fue perfecta dentro del corpus?»* · **Brayan.** Porque fuera del corpus respondió
  de memoria, y eso no se controla desde afuera; los fallos de B vienen de notas, y eso se corrige verificándolas.
- *«Muéstreme de dónde sale esta frase del anteproyecto.»* · **Quien la verificó** (columna `verificado_por`). Se
  busca la fila en `trazabilidad.md`, se abre el PDF en la página y se lee la cita.
- *«¿Qué le corrigió a la IA?»* · **Cada uno, sus tres fallos del inventario.** Brayan: el PDF equivocado de García,
  las coincidencias falsas de Crossref y no haber verificado las notas antes de correr B.
- *«¿Sacar las descartadas después de ver los datos no es acomodar el resultado?»* · **Brayan.** Está declarado y se
  muestran las dos versiones: contándolas, B baja a 0,65, y la decisión no cambia porque se apoya en el banco.
- *«¿Por qué Vanessa dejó 21 sin clasificar?»* · **Vanessa.** Eran de pago y no pudo abrirlas; en esas la etiqueta
  cuenta solo si Brayan y Mateo coinciden. Es el desvío 5.
- *«¿Hubo alguna referencia inventada?»* · **Brayan.** Por mayoría, solo Ekmekci (2013), y sí existe: su repositorio
  no abría. Lo declaramos como error de clasificación.
- *«Si el sistema no arranca, ¿qué hacen?»* · **Mateo.** Decirlo, mostrar la corrida guardada y explicar por qué
  falló: eso también se califica.
