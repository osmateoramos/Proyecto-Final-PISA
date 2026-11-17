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


def correr(pagina: str, modulo: str = "paginas") -> AppTest:
    return AppTest.from_string(f"from pisa_tablero import {modulo}\n{modulo}.{pagina}()", default_timeout=60).run()


PAGINAS = ["inicio", "datos_diseno", "medicion_nse", "invarianza", "competencias", "modelo_estructural", "robustez"]


@pytest.mark.parametrize("pagina", PAGINAS)
def test_pagina_se_dibuja_sin_errores(pagina: str) -> None:
    app = correr(pagina)
    assert not app.exception
    assert not app.error


@pytest.mark.parametrize("pagina", ["resumen", "conclusiones", "materias"])
def test_presentacion_se_dibuja_sin_errores(pagina: str) -> None:
    app = correr(pagina, modulo="presentacion")
    assert not app.exception
    assert not app.error


def test_resumen_tiene_las_partes_de_un_resumen_academico() -> None:
    texto = " ".join(m.value for m in correr("resumen", modulo="presentacion").markdown)
    assert all(parte in texto for parte in ("**Problema.**", "**Método.**", "**Resultados.**", "**Conclusión.**"))


def test_conclusiones_muestran_objetivos_y_hallazgos() -> None:
    app = correr("conclusiones", modulo="presentacion")
    texto = " ".join(m.value for m in app.markdown)
    assert all(f"**K{i} ·" in texto for i in range(1, 6))
    assert len(app.table[0].value) == 5                                   # O1 a O5


@pytest.mark.parametrize("pagina", PAGINAS + ["prediccion"])
def test_cada_seccion_cierra_anunciando_la_siguiente(pagina: str) -> None:
    texto = " ".join(m.value for m in correr(pagina).markdown)
    assert "**Siguiente sección.**" in texto


def test_modelo_explica_por_que_las_competencias_no_son_latentes() -> None:
    app = correr("modelo_estructural")
    assert any("variables latentes" in e.label for e in app.expander)


def test_materias_tiene_una_pestana_por_curso_y_las_rutas_de_la_api() -> None:
    app = correr("materias", modulo="presentacion")
    assert len(app.tabs) == 3
    rutas = next(m for m in app.metric if m.label == "Rutas publicadas en /v1")
    assert int(rutas.value) > 0


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
