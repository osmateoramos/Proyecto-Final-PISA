"""Endpoints del catálogo de resultados (D-47): una sola función crea un endpoint por recurso de ``app.catalogo``."""

from collections.abc import Callable
from typing import Annotated, Any

from fastapi import APIRouter, Depends
from pydantic import BaseModel
from sqlalchemy import select
from sqlalchemy.orm import Session

from app.catalogo import RECURSOS, Recurso
from app.db import obtener_sesion
from app.esquemas import FilaCSV
from app.tablas import ResultadoFila

enrutador = APIRouter()
SesionBD = Annotated[Session, Depends(obtener_sesion)]


class RecursoCatalogo(BaseModel):
    """Un recurso del catálogo: dónde se consulta y de dónde sale."""

    ruta: str
    archivo: str
    area: str
    titulo: str
    decision: str


def crear_endpoint(recurso: Recurso) -> Callable[[Session], list[Any]]:
    """Crea la función del endpoint de un recurso (una función aparte por recurso, para no compartir variables).

    Args:
        recurso: El recurso del catálogo.

    Returns:
        La función que FastAPI registra como endpoint.
    """
    esquema: type[FilaCSV] = recurso.esquema

    def endpoint(sesion: SesionBD) -> list[Any]:
        consulta = (select(ResultadoFila.datos).where(ResultadoFila.archivo == recurso.archivo)
                    .order_by(ResultadoFila.orden))
        return [esquema.model_validate(datos) for datos in sesion.scalars(consulta)]

    endpoint.__name__ = "leer_" + recurso.ruta.strip("/").replace("/", "_").replace("-", "_")
    endpoint.__doc__ = f"{recurso.titulo}. Fuente: `salidas/{recurso.archivo}` ({recurso.decision})."
    return endpoint


for _recurso in RECURSOS:
    enrutador.add_api_route(
        _recurso.ruta, crear_endpoint(_recurso), methods=["GET"], response_model=list[_recurso.esquema],
        response_model_by_alias=False, summary=_recurso.titulo, tags=[_recurso.area],
    )


@enrutador.get("/catalogo", response_model=list[RecursoCatalogo], tags=["Servicio"], summary="Catálogo de resultados")
def listar_catalogo() -> list[RecursoCatalogo]:
    """Qué resultados sirve la API, en qué ruta, de qué archivo de salidas/ y con qué decisión del registro."""
    return [RecursoCatalogo(ruta=f"/v1{r.ruta}", archivo=r.archivo, area=r.area, titulo=r.titulo, decision=r.decision)
            for r in RECURSOS]
