"""Textos institucionales que comparten varias secciones del tablero (resumen, introducción y conclusiones).

Resumen del informe entregado (``Proyecto_PISA/informe/informe.Rmd``) y de ``Vault_PISA2022/06 Objetivos PISA 2022.md``.
No contienen cifras: las cifras se leen siempre de la API.
"""

TITULO = "Nivel socioeconómico latente y desempeño matemático por competencias en PISA 2022 (Colombia)"
EQUIPO = "Vanessa Acosta, Mateo Ramos y Brayan David Barreto"
INSTITUCION = "Consultoría Estadística · Universidad Santo Tomás · 2026-II"
NOTA_TRANSVERSAL = "Diseño transversal: las cifras expresan asociaciones, no efectos causales."

PREGUNTA = ("¿En qué medida el nivel socioeconómico (NSE), modelado como constructo latente cuya medición es igual "
            "entre grupos, explica el desempeño de los estudiantes colombianos en cada una de las cuatro competencias "
            "matemáticas de PISA 2022, y cuánto de la brecha observada depende de cómo se califica el desempeño?")

PROBLEMA = (
    "En Colombia, la brecha socioeconómica en matemáticas suele reportarse con un índice de nivel socioeconómico de "
    "una sola dimensión y con un puntaje global de desempeño. Dos decisiones de medición, que rara vez se discuten, "
    "condicionan la magnitud de esa brecha:\n\n"
    "1. **La medición del NSE.** El índice oficial de PISA (ESCS) se valida entre países, pero no se ha verificado que "
    "mida lo mismo dentro de Colombia, entre zonas, sectores o sexos.\n"
    "2. **La calificación del desempeño.** PISA define cuatro procesos matemáticos —formular, emplear, interpretar y "
    "razonar—, que en el país se reportan solo como promedios nacionales, sin cruzarlos con el NSE. Además, las "
    "respuestas omitidas se califican como incorrectas, aunque el desenganche en la prueba puede variar con el NSE.\n\n"
    "En este trabajo se denomina **competencias** a esos cuatro procesos.")

OBJETIVO_GENERAL = (
    "Determinar en qué medida el NSE, medido como constructo latente con invarianza verificada entre grupos, explica "
    "el desempeño de los estudiantes colombianos en las cuatro competencias matemáticas de PISA 2022, y en qué medida "
    "la brecha socioeconómica depende del funcionamiento de los ítems y del tratamiento de las omisiones.")

OBJETIVOS = [
    ("O1", "Medir el NSE como constructo latente, con TRI y análisis factorial, y contrastar una y dos dimensiones."),
    ("O2", "Verificar la invarianza de la medición del NSE por zona, sexo y sector del colegio."),
    ("O3", "Calificar el desempeño por competencias con un modelo de TRI multidimensional propio y verificar la "
           "equidad de la calificación (funcionamiento diferencial de los ítems y tratamiento de las omisiones)."),
    ("O4", "Estimar la asociación del NSE con cada competencia mediante un modelo estructural."),
    ("O5", "Poner los resultados a disposición en una API y un tablero, siempre en forma agregada."),
]

PREGUNTA_BREVE = ("¿Cuánto se asocia el NSE latente con cada competencia matemática de PISA 2022 en Colombia, y cuánto "
                  "de la brecha depende de cómo se califica el desempeño?")

PROBLEMA_TARJETAS = [
    ("Medición del NSE", "Índice oficial de una dimensión, no verificado dentro de Colombia."),
    ("Calificación por competencias", "Cuatro procesos matemáticos reportados solo como promedios nacionales."),
    ("Respuestas omitidas", "Se califican como incorrectas; el desenganche puede variar con el NSE."),
]
"""Las tres decisiones de medición que plantea el problema, en una línea cada una."""

OBJETIVOS_BREVES = [
    ("O1 · Medir", "NSE latente con TRI y análisis factorial"),
    ("O2 · Verificar", "Invarianza por zona, sexo y sector"),
    ("O3 · Calificar", "Cuatro competencias con TRI; DIF y omisiones"),
    ("O4 · Relacionar", "Modelo estructural NSE → competencias"),
    ("O5 · Publicar", "API y tablero con resultados agregados"),
]

SECCIONES = [
    ("Resumen", "Síntesis del problema, el método, los resultados y la conclusión"),
    ("1. Introducción", "Planteamiento del problema, pregunta, objetivos e hipótesis preregistradas"),
    ("2. Datos y diseño muestral", "Fuente, muestra analítica y validación del diseño frente a la OCDE (F1-F2)"),
    ("3. Medición del NSE", "Estructura del NSE con análisis factorial y TRI (F3, O1, H1)"),
    ("4. Invarianza del NSE", "Equivalencia de la medición entre zonas, sexos y sectores (F4, O2, H2)"),
    ("5. Calificación por competencias", "TRI multidimensional, puntajes propios, DIF y omisiones (F5, O3)"),
    ("6. Modelo estructural", "Asociación del NSE con cada competencia (F6, O4, H5 y H6)"),
    ("7. Robustez y hallazgos", "Sensibilidades de los cinco resultados principales (F7)"),
    ("8. Producto: puntaje esperado", "Uso de la API: puntaje esperado por competencia (F8, O5)"),
    ("9. Conclusiones", "Cumplimiento de los objetivos, conclusiones, hallazgos y limitaciones"),
    ("Anexo. Materias integradas", "Aporte de cada curso del proyecto integrador"),
]
"""Estructura del tablero, en el orden cronológico del desarrollo del proyecto."""
