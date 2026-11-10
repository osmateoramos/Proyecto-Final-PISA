"""O4: modelo estructural por competencia (F6) y puntaje esperado."""

from typing import Annotated, Literal

from fastapi import APIRouter, Depends, Query
from sqlalchemy import select
from sqlalchemy.orm import Session

from app.db import obtener_sesion
from app.esquemas import (
    CoeficienteRespuesta,
    Competencia,
    InteraccionRespuesta,
    PerfilPrediccion,
    PrediccionRespuesta,
)
from app.prediccion import ADVERTENCIA, ModeloF6
from app.tablas import CoeficienteSEM, InteraccionSEM

enrutador = APIRouter(prefix="/modelo", tags=["Modelo estructural (O4)"])
SesionBD = Annotated[Session, Depends(obtener_sesion)]


@enrutador.get("/coeficientes", response_model=list[CoeficienteRespuesta], summary="Coeficientes del modelo F6")
def listar_coeficientes(
    sesion: SesionBD,
    competencia: Annotated[Competencia | None, Query(description="Filtra por competencia.")] = None,
) -> list[CoeficienteSEM]:
    """Coeficientes en puntos PISA con error BRR y Rubin (VP de la OCDE, D-42)."""
    consulta = select(CoeficienteSEM).order_by(CoeficienteSEM.competencia, CoeficienteSEM.id)
    if competencia is not None:
        consulta = consulta.where(CoeficienteSEM.competencia == competencia)
    return list(sesion.scalars(consulta))


@enrutador.get("/interacciones", response_model=list[InteraccionRespuesta], summary="Pendiente del NSE por grupo (H6)")
def listar_interacciones(
    sesion: SesionBD,
    grupo: Annotated[Literal["zona", "sector"] | None, Query(description="zona (pueblo, rural) o sector (privado).")] = None,
) -> list[InteraccionSEM]:
    """Cuánto cambia la pendiente del NSE económico frente a la referencia (urbana, pública), en puntos PISA."""
    consulta = select(InteraccionSEM).order_by(InteraccionSEM.competencia, InteraccionSEM.id)
    if grupo is not None:
        consulta = consulta.where(InteraccionSEM.interaccion.like(f"eco:{grupo}%"))
    return list(sesion.scalars(consulta))


@enrutador.post("/prediccion", response_model=PrediccionRespuesta, summary="Puntaje esperado por competencia")
def predecir(perfil: PerfilPrediccion) -> PrediccionRespuesta:
    """Puntaje esperado de las 4 competencias para un perfil de NSE, sexo y grado (D-46 punto 3).

    Fuera de rango (por ejemplo, un NSE de 5 o un sexo distinto de Mujer u Hombre) responde 422.
    """
    return PrediccionRespuesta(
        perfil=perfil,
        puntajes=ModeloF6.obtener().predecir(perfil),
        fuente="salidas/sem_coeficientes.csv (06_sem_competencias.R, D-42)",
        advertencia=ADVERTENCIA,
    )
