"""Tablero del Proyecto PISA 2022 Colombia (F8, pasos 8.4; recorrido por fases de D-47).

Necesita la API corriendo (``Proyecto_PISA/api``)::

    streamlit run app.py

La URL de la API se toma de ``PISA_API_URL`` (por defecto, http://127.0.0.1:8000).
"""

import streamlit as st

from pisa_tablero import paginas

st.set_page_config(page_title="PISA 2022 Colombia", layout="wide")

navegacion = st.navigation({
    "Proyecto": [st.Page(paginas.inicio, title="Inicio y recorrido", url_path="inicio", default=True)],
    "Fases": [
        st.Page(paginas.datos_diseno, title="F1-F2 · Datos y diseño", url_path="datos"),
        st.Page(paginas.medicion_nse, title="F3 · Medición del NSE", url_path="nse"),
        st.Page(paginas.invarianza, title="F4 · Invarianza", url_path="invarianza"),
        st.Page(paginas.competencias, title="F5 · Competencias", url_path="competencias"),
        st.Page(paginas.modelo_estructural, title="F6 · Modelo estructural", url_path="modelo"),
        st.Page(paginas.robustez, title="F7 · Robustez y hallazgos", url_path="robustez"),
    ],
    "Explorar": [st.Page(paginas.prediccion, title="Puntaje esperado", url_path="prediccion")],
})
navegacion.run()
