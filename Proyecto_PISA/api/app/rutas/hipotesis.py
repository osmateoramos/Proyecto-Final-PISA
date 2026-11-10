"""Hipótesis preregistradas y robustez de los hallazgos (F7)."""

from typing import Annotated

from fastapi import APIRouter, Depends, HTTPException, Path, status
from sqlalchemy import select
from sqlalchemy.orm import Session

from app.db import obtener_sesion
from app.esquemas import HipotesisRespuesta, RobustezRespuesta
from app.tablas import Hipotesis, Robustez

enrutador = APIRouter(tags=["Hipótesis y robustez"])
SesionBD = Annotated[Session, Depends(obtener_sesion)]


@enrutador.get("/hipotesis", response_model=list[HipotesisRespuesta], summary="Decisión de H1 a H8")
def listar_hipotesis(sesion: SesionBD) -> list[Hipotesis]:
    """Decisión de cada hipótesis preregistrada, tomada de su archivo de salidas."""
    return list(sesion.scalars(select(Hipotesis).order_by(Hipotesis.codigo)))


@enrutador.get("/hipotesis/{codigo}", response_model=HipotesisRespuesta, summary="Decisión de una hipótesis")
def obtener_hipotesis(
    codigo: Annotated[str, Path(pattern=r"^H[1-9]$", description="Código de la hipótesis, por ejemplo H3.")],
    sesion: SesionBD,
) -> Hipotesis:
    """Decisión de una hipótesis; 404 si el código no existe."""
    hipotesis = sesion.get(Hipotesis, codigo)
    if hipotesis is None:
        raise HTTPException(status.HTTP_404_NOT_FOUND, f"No existe la hipótesis {codigo}")
    return hipotesis


@enrutador.get("/robustez", response_model=list[RobustezRespuesta], summary="Robustez de los candidatos (F7)")
def listar_robustez(sesion: SesionBD) -> list[Robustez]:
    """Cuántas sensibilidades mantiene cada candidato a hallazgo y si es robusto según la regla del 75 % (D-45)."""
    return list(sesion.scalars(select(Robustez).order_by(Robustez.candidato)))
