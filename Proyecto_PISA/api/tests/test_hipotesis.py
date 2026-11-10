"""Hipótesis preregistradas y robustez."""

from fastapi.testclient import TestClient

from tests.conftest import leer_salida


def test_ocho_hipotesis(cliente: TestClient) -> None:
    r = cliente.get("/v1/hipotesis")
    assert r.status_code == 200
    assert [h["codigo"] for h in r.json()] == [f"H{i}" for i in range(1, 9)]


def test_decision_sale_del_archivo(cliente: TestClient) -> None:
    r = cliente.get("/v1/hipotesis/H3")
    assert r.status_code == 200
    assert r.json()["decision"] == leer_salida("mat_h3.csv")[0]["H3"]
    assert r.json()["archivo"] == "mat_h3.csv"


def test_h8_se_calcula_de_mat_ajuste(cliente: TestClient) -> None:
    ajuste = {f["modelo"]: f for f in leer_salida("mat_ajuste.csv")}
    cuatro = next(f for m, f in ajuste.items() if m != "1D")
    cumple = float(cuatro["BIC"]) < float(ajuste["1D"]["BIC"]) and float(cuatro["correlacion_max"]) <= 0.95
    assert cliente.get("/v1/hipotesis/H8").json()["decision"] == ("se acepta" if cumple else "se rechaza")


def test_hipotesis_inexistente_da_404(cliente: TestClient) -> None:
    assert cliente.get("/v1/hipotesis/H9").status_code == 404


def test_codigo_mal_formado_da_422(cliente: TestClient) -> None:
    assert cliente.get("/v1/hipotesis/X1").status_code == 422


def test_robustez(cliente: TestClient) -> None:
    r = cliente.get("/v1/robustez")
    assert r.status_code == 200
    assert [c["candidato"] for c in r.json()] == [f["candidato"] for f in leer_salida("f7_robustez.csv")]
