"""Acceso a los datos del tablero: pide a la API, guarda en caché y entrega DataFrames listos para graficar."""

import functools
from collections.abc import Callable
from typing import ParamSpec, TypeVar

import pandas as pd
import streamlit as st

from pisa_tablero.cliente import ClienteAPI, ErrorAPI
from pisa_tablero.config import obtener_configuracion
from pisa_tablero.modelos import AnalisisInvarianza, Perfil, Prediccion

P = ParamSpec("P")
R = TypeVar("R")
NOMBRE_FACTOR = {"eco": "económico", "libros": "libros", "ECO": "económico", "CUL": "libros"}
CACHE_S = 300


@st.cache_resource
def cliente() -> ClienteAPI:
    """Un solo cliente HTTP por proceso del tablero."""
    c = obtener_configuracion()
    return ClienteAPI(c.api_url, timeout=c.api_timeout, intentos=c.api_intentos)


def con_api(pagina: Callable[P, R]) -> Callable[P, R | None]:
    """Decorador de página: si la API falla, muestra el motivo y detiene la página en lugar de un error de Python.

    Args:
        pagina: Función que dibuja una página.

    Returns:
        La página envuelta.
    """

    @functools.wraps(pagina)
    def envoltura(*args: P.args, **kwargs: P.kwargs) -> R | None:
        try:
            return pagina(*args, **kwargs)
        except ErrorAPI as e:
            st.error(f"No se pudieron traer los datos: {e}")
            st.caption(f"API configurada: `{obtener_configuracion().api_url}` (variable PISA_API_URL).")
            st.stop()
            return None

    return envoltura


@st.cache_data(ttl=CACHE_S, show_spinner="Consultando la API…")
def salud() -> dict[str, str]:
    """Estado de la API."""
    return cliente().salud().model_dump()


@st.cache_data(ttl=CACHE_S, show_spinner="Consultando la API…")
def hipotesis() -> pd.DataFrame:
    """Decisión de H1 a H8."""
    return pd.DataFrame([h.model_dump() for h in cliente().hipotesis()])


@st.cache_data(ttl=CACHE_S, show_spinner="Consultando la API…")
def robustez() -> pd.DataFrame:
    """Robustez de los candidatos de la F7."""
    return pd.DataFrame([r.model_dump() for r in cliente().robustez()])


@st.cache_data(ttl=CACHE_S, show_spinner="Consultando la API…")
def invarianza(analisis: AnalisisInvarianza) -> tuple[pd.DataFrame, pd.DataFrame, str]:
    """Pasos de invarianza, medias latentes (listas para ``graficos.intervalos``) y la nota del análisis."""
    inv = cliente().invarianza(analisis)
    pasos = pd.DataFrame([p.model_dump() for p in inv.pasos])
    medias = pd.DataFrame([m.model_dump() for m in inv.medias_latentes])
    if not medias.empty:
        medias = medias.assign(serie=medias["factor"].map(NOMBRE_FACTOR),
                               contraste=medias["grupo"] + " frente a " + medias["referencia"],
                               estimacion=medias["diferencia"])
    return pasos, medias, inv.nota


@st.cache_data(ttl=CACHE_S, show_spinner="Consultando la API…")
def dif() -> pd.DataFrame:
    """DIF por NSE de todos los ítems probados."""
    return pd.DataFrame([i.model_dump() for i in cliente().dif()])


@st.cache_data(ttl=CACHE_S, show_spinner="Consultando la API…")
def coeficientes_nse() -> pd.DataFrame:
    """Coeficientes del NSE económico y de libros por competencia (listos para ``graficos.intervalos``)."""
    df = pd.DataFrame([c.model_dump() for c in cliente().coeficientes()])
    df = df[df["coeficiente"].isin(["eco", "libros"])]
    return df.assign(serie=df["coeficiente"].map(NOMBRE_FACTOR))


@st.cache_data(ttl=CACHE_S, show_spinner="Consultando la API…")
def interacciones() -> pd.DataFrame:
    """Interacciones NSE x zona y NSE x sector."""
    return pd.DataFrame([i.model_dump() for i in cliente().interacciones()])


@st.cache_data(ttl=CACHE_S, show_spinner="Consultando la API…")
def tabla(ruta: str) -> pd.DataFrame:
    """Un recurso del catálogo de resultados (D-47) como DataFrame, por ejemplo ``tabla("/nse/cargas")``."""
    return pd.DataFrame(cliente().recurso(ruta))


@st.cache_data(ttl=CACHE_S, show_spinner="Consultando la API…")
def etiquetas_nse() -> dict[str, str]:
    """Etiqueta oficial (cuestionario de PISA, en inglés) de cada indicador del NSE."""
    return tabla("/nse/frecuencias").drop_duplicates("item").set_index("item")["etiqueta"].to_dict()


def predecir(perfil: Perfil) -> Prediccion:
    """Puntaje esperado para un perfil (sin caché: cada envío es una consulta nueva)."""
    return cliente().predecir(perfil)
