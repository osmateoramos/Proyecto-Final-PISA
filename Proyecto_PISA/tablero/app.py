"""Tablero del Proyecto PISA 2022 Colombia (F8, paso 8.4).

Necesita la API corriendo (``Proyecto_PISA/api``)::

    streamlit run app.py

La URL de la API se toma de ``PISA_API_URL`` (por defecto, http://127.0.0.1:8000).
"""

import streamlit as st

from pisa_tablero import paginas

st.set_page_config(page_title="PISA 2022 Colombia", layout="wide")

navegacion = st.navigation([
    st.Page(paginas.resumen, title="Resumen", url_path="resumen", default=True),
    st.Page(paginas.nse, title="NSE e invarianza", url_path="nse"),
    st.Page(paginas.competencias, title="DIF por competencia", url_path="competencias"),
    st.Page(paginas.modelo, title="Modelo estructural", url_path="modelo"),
    st.Page(paginas.prediccion, title="Puntaje esperado", url_path="prediccion"),
])
navegacion.run()
