"""O1-O2: medición e invarianza del NSE (F3-F4)."""

from typing import Annotated

from fastapi import APIRouter, Depends, HTTPException, Path, status
from sqlalchemy import select
from sqlalchemy.orm import Session

from app.db import obtener_sesion
from app.esquemas import AnalisisInvarianza, InvarianzaRespuesta, ItemNSERespuesta
from app.tablas import ItemNSE, MediaLatente, PasoInvarianza

enrutador = APIRouter(tags=["NSE (O1-O2)"])
SesionBD = Annotated[Session, Depends(obtener_sesion)]

NOTA_INVARIANZA = (
    "Ningún paso empeora ΔCFI/ΔRMSEA más allá de los cortes, pero la prueba χ² rechaza en 10 de 12 pasos: no es "
    "invarianza demostrada (D-35). Medias latentes en DE del factor, con error BRR (D-34)."
)


@enrutador.get("/nse/items", response_model=list[ItemNSERespuesta], summary="Indicadores del NSE y su factor")
def listar_items_nse(sesion: SesionBD) -> list[ItemNSE]:
    """Los 29 indicadores del NSE con el factor en que cargan en el modelo de 2 dimensiones del AFE (D-24)."""
    return list(sesion.scalars(select(ItemNSE).order_by(ItemNSE.factor_afe, ItemNSE.item)))


@enrutador.get("/invarianza/{analisis}", response_model=InvarianzaRespuesta, summary="Invarianza del NSE por grupo")
def obtener_invarianza(
    analisis: Annotated[AnalisisInvarianza, Path(description="Análisis de la F4 (D-25).")], sesion: SesionBD
) -> InvarianzaRespuesta:
    """Secuencia de invarianza (configural a interceptos) y diferencias de medias latentes del NSE."""
    pasos = list(sesion.scalars(select(PasoInvarianza).where(PasoInvarianza.analisis == analisis).order_by(PasoInvarianza.id)))
    if not pasos:
        raise HTTPException(status.HTTP_404_NOT_FOUND, f"No hay resultados de invarianza para «{analisis}»")
    medias = list(sesion.scalars(select(MediaLatente).where(MediaLatente.analisis == analisis).order_by(MediaLatente.id)))
    return InvarianzaRespuesta.model_validate(
        {"analisis": analisis, "pasos": pasos, "medias_latentes": medias, "nota": NOTA_INVARIANZA}, from_attributes=True
    )
