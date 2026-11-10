"""Fixtures: una base temporal cargada desde los ``salidas/`` reales y un cliente de pruebas."""

import csv
from collections.abc import Iterator
from pathlib import Path

import pytest
from fastapi.testclient import TestClient

from app.carga import CargadorSalidas
from app.config import RAIZ_API, obtener_configuracion
from app.db import obtener_motor
from app.main import app

SALIDAS = RAIZ_API.parent / "salidas"


@pytest.fixture(scope="session")
def cliente(tmp_path_factory: pytest.TempPathFactory) -> Iterator[TestClient]:
    """Carga los ``salidas/`` reales en una base temporal y levanta la API sobre ella (con su ciclo de vida)."""
    base = tmp_path_factory.mktemp("bd") / "pisa_pruebas.db"
    parche = pytest.MonkeyPatch()
    parche.setenv("PISA_URL_BASE_DATOS", f"sqlite:///{base.as_posix()}")
    parche.setenv("PISA_CARPETA_SALIDAS", str(SALIDAS))
    obtener_configuracion.cache_clear()
    obtener_motor.cache_clear()
    CargadorSalidas(SALIDAS, obtener_motor()).cargar()
    with TestClient(app) as c:
        yield c
    parche.undo()
    obtener_configuracion.cache_clear()
    obtener_motor.cache_clear()


def leer_salida(archivo: str) -> list[dict[str, str]]:
    """Lee un CSV de ``salidas/`` para comparar la API con su fuente.

    Args:
        archivo: Nombre del archivo.

    Returns:
        Las filas como diccionarios de texto.
    """
    with (SALIDAS / archivo).open(encoding="utf-8-sig", newline="") as f:
        return list(csv.DictReader(f))


@pytest.fixture(scope="session")
def ruta_salidas() -> Path:
    """Carpeta de ``salidas/`` del repositorio."""
    return SALIDAS
