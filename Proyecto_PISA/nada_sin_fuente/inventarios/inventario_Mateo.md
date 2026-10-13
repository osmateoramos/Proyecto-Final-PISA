# INVENTARIO DE FALLOS — Mateo Ramos

Entregable individual (½ página). Lo escribe y lo firma su autor: el diagnóstico no se delega.
Al menos tres fallos propios de IA (en el agente, en el anteproyecto o en otro trabajo). Si cree que no tuvo ninguno,
revise antes las referencias del anteproyecto.

### Fallo 1

- **Herramienta:** Claude (Opus), al redactar el estado del arte del anteproyecto.
- **Qué generó:** las oraciones del estado del arte, cada una con su cita bibliográfica.
- **Qué estaba mal:** de mis 16 oraciones citadas, 6 no se sostenían completas:
  - afirmaciones más fuertes que la fuente: en Eriksson et al. (2021) escribí que «solo» dos componentes predicen el
    logro, y el artículo dice que «superan claramente al resto»;
  - una cifra calculada por nosotros (correlaciones de 0,70 a 0,83 en Colombia) citada como si fuera de la OCDE;
  - coeficientes de Lenguaje y comunicación presentados como del logro en general (Hernández y González, 2011);
  - media oración sin fuente (marco del Icfes).
- **Cómo lo detecté:** el 13 de octubre, al firmar la tabla de trazabilidad, abrí cada PDF en la página citada y
  comparé oración por oración. No lo detecté antes de entregar el anteproyecto.
- **Qué me costó:** seis correcciones a un documento ya entregado, que además deben quedar declaradas en la memoria.
- **Qué lo habría evitado:** abrir el PDF en la página antes de citar, y anotar la página en la nota de la fuente desde
  el principio, no después.

### Fallo 2

- **Herramienta:** Claude Code, con un script que revisaba qué PDF estaban disponibles.
- **Qué generó:** el enlace al PDF de García-Medina et al. (2016) en la procedencia del corpus.
- **Qué estaba mal:** el enlace llevaba a otro artículo (Gómez-Benito et al., 2010). El script tomó el primer PDF que
  encontró en la página del artículo, y ese PDF estaba en la lista de referencias.
- **Cómo lo detecté:** el 12 de octubre, al descargarlo, la primera página no coincidía con el título de la nota.
- **Qué me costó:** corregir la procedencia, buscar el PDF correcto en SciELO México, avisar al resto del equipo, que
  ya había usado ese enlace, y comparar el título de todos los PDF del corpus.
- **Qué lo habría evitado:** comprobar que el título de cada PDF coincida con su ficha antes de registrarlo como
  obtenido.

### Fallo 3

- **Herramienta:** Claude Code (Opus 5.5), en el tratamiento B del experimento.
- **Qué generó:** la respuesta de B a mi consulta bibliográfica.
- **Qué estaba mal:** antes de responder leyó archivos fuera del vault, entre ellos mi archivo de consulta, que ya
  tenía la respuesta de A. Esa respuesta pudo quedar influida por A.
- **Cómo lo detecté:** la misma herramienta lo declaró en un aviso al final de su respuesta.
- **Qué me costó:** descartar la corrida, repetirla y crear la versión 2 del protocolo, con una regla que prohíbe abrir
  archivos fuera del vault.
- **Qué lo habría evitado:** abrir la sesión directamente en la carpeta del vault, usar un modo que pida permiso antes
  de actuar y no el automático, y escribir esa restricción en el protocolo desde la v1.

*Redactado con apoyo de Claude a partir de lo ocurrido en el proyecto; revisado por Mateo.*

Firma: Mateo Ramos · Fecha: 2026-10-13
