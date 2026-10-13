# Guion de Brayan: experimento y decisión (minutos 2 a 5)

Unas 430 palabras, unos 3 minutos a ritmo tranquilo. En pantalla: `experimento_decision.pdf` (cuadro 1 y luego
cuadro 2). Las cifras son las de `salidas/` del 2026-10-13; si se vuelve a correr algo, revisar que coincidan.

## Lo que se dice

**1. Qué medimos (20 s).** Cada uno hizo una consulta bibliográfica real de su parte del proyecto y la corrimos en tres
tratamientos: A, Claude sin contexto, que es el control; B, Claude leyendo solo nuestro vault de Obsidian; y C,
NotebookLM con los PDF. Salieron 67 referencias y las clasificamos los tres a ciegas: utilizable, existe pero no dice
eso, o no existe.

**2. El experimento (45 s).** *(Cuadro 1.)* A queda en 0,85, B en 0,83 y C en 0,71, pero ninguna diferencia es
concluyente: los intervalos se traslapan y los p son 1,00 y 0,43. Además, el 0,85 de A sale solo de 13 de sus 22
referencias: las otras 9 son de pago y no hubo mayoría. Si se cuentan, A puede quedar entre 0,50 y 0,91; B se mueve
solo entre 0,75 y 0,85. Y el acuerdo entre nosotros fue bajo, kappa 0,06: casi todo el desacuerdo fue si el documento
dice lo que se le atribuye. Conclusión: con el experimento solo no se puede elegir.

**3. El banco (45 s).** Por eso hicimos un banco de 18 preguntas con respuesta y página conocidas, 15 dentro del corpus
y 3 fuera. A no sostuvo ninguna con una fuente: se abstiene o responde de memoria. C sostuvo las 15, pero en una
pregunta trampa, sobre Colombia en TIMSS 2019, respondió con conocimiento externo, que es justo lo que el protocolo
prohíbe. B sostuvo 12 de 15 y fue la única que se abstuvo en las tres preguntas de fuera. Sus fallos vinieron de las
notas: una no decía «matemáticas» y otra traía un «solo» que la fuente no dice.

**4. La decisión (45 s).** *(Cuadro 2.)* Elegimos B, con una condición: una nota solo sirve de fuente si está
verificada contra el PDF. B es la única que exporta a APA 7, está versionada en Git, deja rastro de la página y del
estado de cada afirmación, y no se sale de sus fuentes. Descartamos C porque se salió de sus fuentes, su cuaderno
cambió entre corridas y no exporta referencias, y A porque responde de memoria y sin páginas.

**5. Lo que declaramos (25 s).** Cosas que salieron mal y quedaron escritas: una corrida de B leyó la respuesta de A y
la descartamos; las seis fuentes que B descartó las sacamos después de clasificar, y por eso mostramos el resultado
con ellas (B baja a 0,65); y Vanessa dejó sin categoría las referencias de pago. Todo está en los desvíos del
documento.

## Preguntas probables

- **¿Por qué no A, si sacó el número más alto?** Porque ese 0,85 excluye sus 9 referencias más dudosas; contándolas
  puede bajar a 0,50. Y A no da páginas: en el banco no sostuvo ninguna respuesta.
- **¿Por qué no C, si en el banco fue perfecta dentro del corpus?** Porque fuera del corpus respondió de memoria, y eso
  no se puede controlar desde afuera; los fallos de B vienen de notas, y eso sí se corrige verificándolas. Además, el
  cuaderno de C cambió entre corridas (13, 36 y 27 entradas) y no está versionado.
- **¿Sacar las descartadas después de ver los datos no es acomodar el resultado?** Por eso lo declaramos y mostramos
  las dos versiones: contándolas, B pasa de 0,83 a 0,65 y la decisión no cambia, porque se apoya también en el banco.
- **¿Las referencias son independientes?** No: las de una misma consulta comparten respuesta y tema. El número
  efectivo está más cerca de tres consultas por tratamiento; los intervalos son orientativos.
- **¿Por qué el acuerdo fue tan bajo?** La frontera entre «utilizable» y «existe pero no dice eso» depende de cuánta
  paráfrasis acepta cada uno, y Vanessa dejó sin categoría lo que no pudo abrir.
- **¿Hubo alguna referencia inventada?** Por mayoría, solo Ekmekci (2013), y sí existe: su repositorio no abría y la
  encontramos después. Lo declaramos como error de clasificación.
- **¿Cómo saben que una nota está verificada?** Tiene estado `verificado` y lo pone una persona con el PDF abierto; la
  IA nunca lo marca. Hoy son 8 de 45, y la trazabilidad está firmada en 41 de 44 filas.
