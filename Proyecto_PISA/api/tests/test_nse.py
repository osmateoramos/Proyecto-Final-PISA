"""O1-O2: indicadores del NSE e invarianza."""

from fastapi.testclient import TestClient

from tests.conftest import leer_salida


def test_items_nse_coinciden_con_salidas(cliente: TestClient) -> None:
    r = cliente.get("/v1/nse/items")
    assert r.status_code == 200
    esperado = {f["item"]: f["factor_AFE"] for f in leer_salida("nse_estructura_afe.csv")}
    assert {i["item"]: i["factor_afe"] for i in r.json()} == esperado


def test_invarianza_zona(cliente: TestClient) -> None:
    r = cliente.get("/v1/invarianza/zona")
    assert r.status_code == 200
    cuerpo = r.json()
    assert [p["paso"] for p in cuerpo["pasos"]] == ["configural", "umbrales", "cargas", "interceptos"]
    esperado = [f for f in leer_salida("nse_medias_latentes_brr.csv") if f["analisis"] == "zona"]
    assert len(cuerpo["medias_latentes"]) == len(esperado)
    assert all(m["ic95_inf"] <= m["diferencia"] <= m["ic95_sup"] for m in cuerpo["medias_latentes"])


def test_invarianza_analisis_invalido_da_422(cliente: TestClient) -> None:
    r = cliente.get("/v1/invarianza/estrato")
    assert r.status_code == 422
    assert r.json()["detail"][0]["loc"] == ["path", "analisis"]
