"""Cliente HTTP: reintentos, errores y contrato, con un transporte simulado (sin red)."""

import httpx
import pytest

from pisa_tablero.cliente import ClienteAPI, ErrorAPI
from pisa_tablero.modelos import Perfil

HIPOTESIS = [{"codigo": "H1", "objetivo": "O1", "decision": "se acepta", "archivo": "nse_h1_afc.csv"}]


def cliente_con(manejador: httpx.MockTransport, intentos: int = 3) -> ClienteAPI:
    http = httpx.Client(base_url="http://api.prueba", transport=manejador)
    return ClienteAPI("http://api.prueba", intentos=intentos, http=http, espera_base=0)


def test_respuesta_valida_se_convierte_en_modelos() -> None:
    c = cliente_con(httpx.MockTransport(lambda r: httpx.Response(200, json=HIPOTESIS)))
    h = c.hipotesis()
    assert h[0].codigo == "H1" and h[0].decision == "se acepta"


def test_error_4xx_no_se_reintenta_y_muestra_el_detalle() -> None:
    llamadas = []

    def manejador(r: httpx.Request) -> httpx.Response:
        llamadas.append(r)
        return httpx.Response(422, json={"detail": [{"loc": ["body", "sexo"], "msg": "valor no permitido"}]})

    with pytest.raises(ErrorAPI, match="body.sexo: valor no permitido"):
        cliente_con(httpx.MockTransport(manejador)).predecir(Perfil(nse_economico=0, sexo="Mujer"))
    assert len(llamadas) == 1


def test_error_5xx_se_reintenta_hasta_responder() -> None:
    respuestas = iter([httpx.Response(503), httpx.Response(503), httpx.Response(200, json=HIPOTESIS)])
    c = cliente_con(httpx.MockTransport(lambda r: next(respuestas)))
    assert c.hipotesis()[0].codigo == "H1"


def test_red_caida_tras_los_intentos_da_error_claro() -> None:
    def manejador(r: httpx.Request) -> httpx.Response:
        raise httpx.ConnectError("sin conexión", request=r)

    with pytest.raises(ErrorAPI, match="No se pudo conectar"):
        cliente_con(httpx.MockTransport(manejador), intentos=2).hipotesis()


def test_respuesta_que_rompe_el_contrato() -> None:
    c = cliente_con(httpx.MockTransport(lambda r: httpx.Response(200, json=[{"codigo": "H1"}])))
    with pytest.raises(ErrorAPI, match="no cumple el contrato"):
        c.hipotesis()


def test_perfil_fuera_de_rango_no_sale_del_tablero() -> None:
    with pytest.raises(ValueError):
        Perfil(nse_economico=7, sexo="Mujer")
