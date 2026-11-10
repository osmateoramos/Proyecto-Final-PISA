"""Aplicación FastAPI del Proyecto PISA 2022 Colombia (F8, D-46).

Desarrollo::

    uvicorn app.main:app --reload

Producción (Dockerfile)::

    uvicorn app.main:app --host 0.0.0.0 --port 8000
"""

import math
from collections.abc import AsyncIterator
from contextlib import asynccontextmanager
from typing import Annotated, Any

from fastapi import Depends, FastAPI, HTTPException, Request, status
from fastapi.encoders import jsonable_encoder
from fastapi.exceptions import RequestValidationError
from fastapi.responses import JSONResponse
from sqlalchemy import inspect
from sqlalchemy.orm import Session

from app import __version__
from app.config import obtener_configuracion
from app.db import Base, obtener_motor, obtener_sesion
from app.esquemas import SaludRespuesta
from app.prediccion import ModeloF6
from app.registro import configurar_registro, registro
from app.rutas import hipotesis, matematicas, modelo, nse
from app.tablas import Metadato                                   # importar app.tablas registra todas las tablas

PREFIJO_VERSION = "/v1"


@asynccontextmanager
async def ciclo_de_vida(_: FastAPI) -> AsyncIterator[None]:
    """Al iniciar: comprueba que la base esté cargada y carga el modelo de la F6 una sola vez (Singleton).

    Raises:
        RuntimeError: Si la base no tiene las tablas (hay que correr ``python -m app.carga``).
    """
    configurar_registro(obtener_configuracion().nivel_log)
    motor = obtener_motor()
    faltan = set(Base.metadata.tables) - set(inspect(motor).get_table_names())
    if faltan:
        raise RuntimeError(f"La base no está cargada (faltan {sorted(faltan)}): correr antes `python -m app.carga`")
    with Session(motor) as sesion:
        ModeloF6.cargar(sesion)
    registro.info("API lista: base %s y modelo de la F6 cargados", obtener_configuracion().url_base_datos)
    yield


app = FastAPI(
    title="API PISA 2022 Colombia",
    description=(
        "Resultados **agregados** del proyecto de consultoría USTA 2026-II: medición e invarianza del NSE, "
        "calificación por competencias, DIF, modelo estructural y robustez. Solo lee resultados ya estimados en R; "
        "nunca expone datos por estudiante (Ley 1581 de 2012)."
    ),
    version=__version__,
    lifespan=ciclo_de_vida,
)
for modulo in (nse, matematicas, modelo, hipotesis):
    app.include_router(modulo.enrutador, prefix=PREFIJO_VERSION)


def _sin_no_finitos(valor: Any) -> Any:
    """Convierte NaN e infinitos en texto (JSON no los admite), recorriendo listas y diccionarios.

    Args:
        valor: Cualquier valor de un error de validación.

    Returns:
        El mismo valor con los flotantes no finitos como texto.
    """
    if isinstance(valor, float) and not math.isfinite(valor):
        return str(valor)
    if isinstance(valor, dict):
        return {k: _sin_no_finitos(v) for k, v in valor.items()}
    if isinstance(valor, list | tuple):
        return [_sin_no_finitos(v) for v in valor]
    return valor


@app.exception_handler(RequestValidationError)
async def error_de_validacion(_: Request, error: RequestValidationError) -> JSONResponse:
    """Responde 422 con todos los errores, también cuando la entrada traía NaN o infinito.

    Sin esto, el 422 de un NaN fallaría al escribirse como JSON y el cliente recibiría un 500.
    """
    detalle = jsonable_encoder(_sin_no_finitos(error.errors()))
    return JSONResponse(status_code=status.HTTP_422_UNPROCESSABLE_ENTITY, content={"detail": detalle})


@app.get("/health", response_model=SaludRespuesta, tags=["Servicio"], summary="Estado del servicio")
def salud(sesion: Annotated[Session, Depends(obtener_sesion)]) -> SaludRespuesta:
    """Responde 200 si la base está cargada; 503 si no."""
    fecha = sesion.get(Metadato, "fecha_carga")
    if fecha is None:
        raise HTTPException(status.HTTP_503_SERVICE_UNAVAILABLE, "La base no está cargada")
    return SaludRespuesta(estado="ok", version=__version__, fecha_carga=fecha.valor)
