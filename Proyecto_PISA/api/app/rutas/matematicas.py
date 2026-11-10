"""O3: ítems de matemáticas y DIF por NSE (F5)."""

from typing import Annotated

from fastapi import APIRouter, Depends, Query
from sqlalchemy import select
from sqlalchemy.orm import Session

from app.db import obtener_sesion
from app.esquemas import Competencia, ItemDIFRespuesta, ItemMatematicasRespuesta
from app.tablas import ItemDIF, ItemMatematicas

enrutador = APIRouter(tags=["Matemáticas (O3)"])
SesionBD = Annotated[Session, Depends(obtener_sesion)]


@enrutador.get("/matematicas/items", response_model=list[ItemMatematicasRespuesta], summary="Ítems de matemáticas")
def listar_items_matematicas(
    sesion: SesionBD,
    competencia: Annotated[Competencia | None, Query(description="Filtra por competencia.")] = None,
    solo_calibrables: Annotated[bool, Query(description="Solo los 232 ítems calibrables en Colombia.")] = False,
) -> list[ItemMatematicas]:
    """Ítems con su clasificación y parámetros internacionales (anexo A del Technical Report 2022, D-27)."""
    consulta = select(ItemMatematicas).order_by(ItemMatematicas.item)
    if competencia is not None:
        consulta = consulta.where(ItemMatematicas.competencia == competencia)
    if solo_calibrables:
        consulta = consulta.where(ItemMatematicas.calibrable.is_(True))
    return list(sesion.scalars(consulta))


@enrutador.get("/dif", response_model=list[ItemDIFRespuesta], summary="DIF por NSE de los ítems de matemáticas")
def listar_dif(
    sesion: SesionBD,
    competencia: Annotated[Competencia | None, Query(description="Filtra por competencia.")] = None,
    solo_con_dif: Annotated[bool, Query(description="Solo los ítems con DIF (BH 5 % y efecto no despreciable).")] = False,
) -> list[ItemDIF]:
    """DIF entre el cuartil bajo (focal) y el alto (referencia) del NSE económico, con su magnitud (D-40, H3)."""
    consulta = select(ItemDIF).order_by(ItemDIF.competencia, ItemDIF.item)
    if competencia is not None:
        consulta = consulta.where(ItemDIF.competencia == competencia)
    if solo_con_dif:
        consulta = consulta.where(ItemDIF.dif.is_(True))
    return list(sesion.scalars(consulta))
