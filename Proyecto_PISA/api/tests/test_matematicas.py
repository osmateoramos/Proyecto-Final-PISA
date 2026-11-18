"""O3: ítems de matemáticas y DIF."""

from fastapi.testclient import TestClient

from tests.conftest import leer_salida


def test_items_por_competencia(cliente: TestClient) -> None:
    r = cliente.get("/v1/matematicas/items", params={"competencia": "emplear"})
    assert r.status_code == 200
    esperado = sum(f["competencia"] == "emplear" for f in leer_salida("items_competencia.csv"))
    assert len(r.json()) == esperado
    assert {i["competencia"] for i in r.json()} == {"emplear"}


def test_items_solo_calibrables(cliente: TestClient) -> None:
    r = cliente.get("/v1/matematicas/items", params={"solo_calibrables": True})
    esperado = sum(f["calibrable"] == "TRUE" for f in leer_salida("items_competencia.csv"))
    assert len(r.json()) == esperado


def test_competencia_invalida_da_422(cliente: TestClient) -> None:
    assert cliente.get("/v1/matematicas/items", params={"competencia": "sumar"}).status_code == 422


def test_dif_solo_items_con_dif(cliente: TestClient) -> None:
    r = cliente.get("/v1/dif", params={"solo_con_dif": True})
    assert r.status_code == 200
    esperado = {f["item"] for f in leer_salida("mat_dif.csv") if f["DIF"] == "TRUE"}
    assert {i["item"] for i in r.json()} == esperado
    assert all(i["dif"] for i in r.json())


def test_dif_todos_los_probados(cliente: TestClient) -> None:
    assert len(cliente.get("/v1/dif").json()) == len(leer_salida("mat_dif.csv"))


def test_cargas_items_coinciden_con_el_resumen(cliente: TestClient) -> None:
    items = cliente.get("/v1/matematicas/cargas-items").json()
    assert len(items) == len(leer_salida("mat_afc_cargas.csv"))
    resumen = {f["competencia"]: f for f in leer_salida("mat_afc_resumen.csv")}
    for comp in ["emplear", "formular", "interpretar", "razonar"]:
        propios = [i for i in items if i["competencia"] == comp]
        assert len(propios) == int(resumen[comp]["items"])
        assert sum(i["carga_baja"] for i in propios) == int(resumen[comp]["carga_menor_030"])


def test_correlaciones_competencia_simetricas(cliente: TestClient) -> None:
    r = cliente.get("/v1/matematicas/correlaciones-competencia")
    assert r.status_code == 200
    phi = {f["competencia"]: f for f in r.json()}
    competencias = ["emplear", "formular", "interpretar", "razonar"]
    assert set(phi) == set(competencias)
    for a in competencias:
        assert phi[a][a] == 1
        for b in competencias:
            assert phi[a][b] == phi[b][a]


def test_dif_mh_infinito_queda_marcado(cliente: TestClient) -> None:
    infinitos = {f["item"] for f in leer_salida("mat_dif.csv") if f["delta_MH"] in {"Inf", "-Inf"}}
    marcados = {i["item"] for i in cliente.get("/v1/dif").json() if not i["mh_calculable"]}
    assert marcados == infinitos
    assert all(i["delta_mh"] is None for i in cliente.get("/v1/dif").json() if i["item"] in infinitos)
