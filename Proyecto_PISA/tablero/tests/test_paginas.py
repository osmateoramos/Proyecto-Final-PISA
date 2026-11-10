"""Páginas contra la API real (AppTest de Streamlit).

En local se saltan si la API no está corriendo en PISA_API_URL. En la integración continua (PISA_EXIGIR_API=1) la
falta de la API es un error, para que el trabajo no pase en falso.
"""

import os

import httpx
import pytest
from streamlit.testing.v1 import AppTest

from pisa_tablero.config import obtener_configuracion


def api_disponible() -> bool:
    try:
        return httpx.get(f"{obtener_configuracion().api_url}/health", timeout=3).status_code == 200
    except httpx.HTTPError:
        return False


DISPONIBLE = api_disponible()
if not DISPONIBLE and os.environ.get("PISA_EXIGIR_API") == "1":
    raise RuntimeError("PISA_EXIGIR_API=1 y la API no responde en " + obtener_configuracion().api_url)
pytestmark = pytest.mark.skipif(not DISPONIBLE, reason="La API no está corriendo (ver Proyecto_PISA/api/README.md)")


def correr(pagina: str) -> AppTest:
    return AppTest.from_string(f"from pisa_tablero import paginas\npaginas.{pagina}()", default_timeout=60).run()


PAGINAS = ["inicio", "datos_diseno", "medicion_nse", "invarianza", "competencias", "modelo_estructural", "robustez"]


@pytest.mark.parametrize("pagina", PAGINAS)
def test_pagina_se_dibuja_sin_errores(pagina: str) -> None:
    app = correr(pagina)
    assert not app.exception
    assert not app.error


def test_inicio_muestra_las_ocho_hipotesis() -> None:
    texto = " ".join(m.value for m in correr("inicio").markdown)
    assert all(f"**H{i}**" in texto for i in range(1, 9))


def test_modelo_cambia_de_enfoque_y_resalta() -> None:
    app = correr("modelo_estructural")
    app.radio[0].set_value("NSE latente (robustez)").run()
    app.selectbox[0].set_value("interpretar").run()
    assert not app.exception and not app.error


def test_prediccion_al_enviar_el_formulario() -> None:
    app = correr("prediccion")
    app.button[0].click().run()
    assert not app.exception and not app.error
    assert len(app.dataframe[0].value) == 4
    assert "no es el puntaje de una persona" in app.warning[0].value
