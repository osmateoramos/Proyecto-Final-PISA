"""Catálogo de resultados (D-47): cada recurso responde con todas las filas de su archivo."""

import pytest
from fastapi.testclient import TestClient

from app.catalogo import RECURSOS, Recurso
from tests.conftest import leer_salida


@pytest.mark.parametrize("recurso", RECURSOS, ids=lambda r: r.ruta)
def test_recurso_devuelve_todas_sus_filas(cliente: TestClient, recurso: Recurso) -> None:
    r = cliente.get(f"/v1{recurso.ruta}")
    assert r.status_code == 200
    assert len(r.json()) == len(leer_salida(recurso.archivo))


def test_catalogo_lista_todos_los_recursos(cliente: TestClient) -> None:
    catalogo = cliente.get("/v1/catalogo").json()
    assert {c["ruta"] for c in catalogo} == {f"/v1{r.ruta}" for r in RECURSOS}


def test_campos_con_nombre_de_python_y_no_de_csv(cliente: TestClient) -> None:
    fila = cliente.get("/v1/nse/ajuste").json()[0]
    assert "cfi_scaled" in fila and "cfi.scaled" not in fila


def test_cargas_del_modelo_elegido(cliente: TestClient) -> None:
    cargas = [c for c in cliente.get("/v1/nse/cargas").json() if c["modelo"] == "M2_AFE"]
    assert {c["factor"] for c in cargas} == {"ECO", "CUL"}
    assert len(cargas) == 29
