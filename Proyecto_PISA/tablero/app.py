"""Tablero del Proyecto PISA 2022 Colombia (F8, paso 8.4; D-47 y su ampliación del 2026-11-16).

El menú sigue la estructura de un informe académico y el orden cronológico del desarrollo del proyecto: resumen,
introducción, secciones 2 a 8 (una por fase), conclusiones y anexo.

Necesita la API corriendo (``Proyecto_PISA/api``)::

    streamlit run app.py

La URL de la API se toma de ``PISA_API_URL`` (por defecto, http://127.0.0.1:8000).
"""

import streamlit as st

from pisa_tablero import paginas, presentacion

st.set_page_config(page_title="PISA 2022 Colombia", layout="wide")

navegacion = st.navigation({
    "Informe": [
        st.Page(presentacion.resumen, title="Resumen", url_path="resumen", default=True),
        st.Page(paginas.inicio, title="1. Introducción", url_path="introduccion"),
    ],
    "Desarrollo del proyecto": [
        st.Page(paginas.datos_diseno, title="2. Datos y diseño muestral", url_path="datos"),
        st.Page(paginas.medicion_nse, title="3. Medición del NSE", url_path="nse"),
        st.Page(paginas.invarianza, title="4. Invarianza del NSE", url_path="invarianza"),
        st.Page(paginas.competencias, title="5. Calificación por competencias", url_path="competencias"),
        st.Page(paginas.modelo_estructural, title="6. Modelo estructural", url_path="modelo"),
        st.Page(paginas.robustez, title="7. Robustez y hallazgos", url_path="robustez"),
        st.Page(paginas.prediccion, title="8. Producto: puntaje esperado", url_path="prediccion"),
    ],
    "Cierre": [
        st.Page(presentacion.conclusiones, title="9. Conclusiones", url_path="conclusiones"),
        st.Page(presentacion.materias, title="Anexo. Materias integradas", url_path="materias"),
    ],
})
navegacion.run()
