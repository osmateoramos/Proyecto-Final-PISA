"""Servicio: salud y documentación."""

from fastapi.testclient import TestClient


def test_health_responde_ok(cliente: TestClient) -> None:
    r = cliente.get("/health")
    assert r.status_code == 200
    assert r.json()["estado"] == "ok"


def test_documentacion_disponible(cliente: TestClient) -> None:
    assert cliente.get("/docs").status_code == 200
    rutas = cliente.get("/openapi.json").json()["paths"]
    assert "/v1/modelo/prediccion" in rutas


def test_raiz_lleva_a_la_documentacion(cliente: TestClient) -> None:
    r = cliente.get("/", follow_redirects=False)
    assert r.status_code == 307
    assert r.headers["location"] == "/docs"


def test_ruta_inexistente_da_404(cliente: TestClient) -> None:
    assert cliente.get("/v1/no-existe").status_code == 404
