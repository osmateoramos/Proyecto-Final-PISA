"""O4: coeficientes, interacciones y puntaje esperado."""

import pytest
from fastapi.testclient import TestClient

from app.prediccion import ModeloF6
from tests.conftest import leer_salida


def esperado_a_mano(nse_economico: float, nse_libros: float, sexo: str, grado: int) -> dict[str, float]:
    """Puntaje esperado calculado directamente del CSV, sin pasar por el código de la API."""
    b: dict[str, dict[str, float]] = {}
    for f in leer_salida("sem_coeficientes.csv"):
        b.setdefault(f["competencia"], {})[f["coeficiente"]] = float(f["estimacion"])
    return {
        c: round(v["(Intercept)"] + v["eco"] * nse_economico + v["libros"] * nse_libros
                 + (v["sexoHombre"] if sexo == "Hombre" else 0) + (v[f"grado{grado}"] if grado else 0), 1)
        for c, v in b.items()
    }


def test_coeficientes_por_competencia(cliente: TestClient) -> None:
    r = cliente.get("/v1/modelo/coeficientes", params={"competencia": "interpretar"})
    assert r.status_code == 200
    eco = next(c for c in r.json() if c["coeficiente"] == "eco")
    fila = next(f for f in leer_salida("sem_coeficientes.csv") if f["competencia"] == "interpretar" and f["coeficiente"] == "eco")
    assert eco["estimacion"] == pytest.approx(float(fila["estimacion"]))


def test_interacciones_por_sector(cliente: TestClient) -> None:
    r = cliente.get("/v1/modelo/interacciones", params={"grupo": "sector"})
    assert r.status_code == 200
    assert {i["interaccion"] for i in r.json()} == {"eco:sectorprivado"}
    assert len(r.json()) == 4


@pytest.mark.parametrize(
    ("nse_economico", "nse_libros", "sexo", "grado"),
    [(0.0, 0.0, "Mujer", 0), (1.0, -0.5, "Hombre", -3), (-2.0, 1.0, "Mujer", 1)],
)
def test_prediccion_coincide_con_el_calculo_a_mano(
    cliente: TestClient, nse_economico: float, nse_libros: float, sexo: str, grado: int
) -> None:
    perfil = {"nse_economico": nse_economico, "nse_libros": nse_libros, "sexo": sexo, "grado": grado}
    r = cliente.post("/v1/modelo/prediccion", json=perfil)
    assert r.status_code == 200
    obtenido = {p["competencia"]: p["puntaje_esperado"] for p in r.json()["puntajes"]}
    assert obtenido == pytest.approx(esperado_a_mano(nse_economico, nse_libros, sexo, grado))
    assert "no es el puntaje de una persona" in r.json()["advertencia"]


@pytest.mark.parametrize(
    "perfil",
    [
        {"nse_economico": 5, "sexo": "Mujer"},                       # NSE fuera de rango
        {"nse_economico": 0, "sexo": "Otro"},                        # sexo no previsto
        {"nse_economico": 0, "sexo": "Mujer", "grado": 2},           # grado fuera del modelo
        {"sexo": "Mujer"},                                           # falta el NSE
        {"nse_economico": 0, "sexo": "Mujer", "estrato": 3},         # campo no previsto
    ],
)
def test_prediccion_invalida_da_422(cliente: TestClient, perfil: dict[str, object]) -> None:
    assert cliente.post("/v1/modelo/prediccion", json=perfil).status_code == 422


def test_prediccion_rechaza_nan(cliente: TestClient) -> None:
    r = cliente.post("/v1/modelo/prediccion", content='{"nse_economico": NaN, "sexo": "Mujer"}',
                     headers={"Content-Type": "application/json"})
    assert r.status_code == 422
    assert r.json()["detail"][0]["loc"] == ["body", "nse_economico"]


def test_modelo_es_singleton(cliente: TestClient) -> None:
    assert ModeloF6.obtener() is ModeloF6.obtener()
