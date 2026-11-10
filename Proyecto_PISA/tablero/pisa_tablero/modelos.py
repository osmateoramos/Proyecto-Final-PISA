"""Contrato del lado del tablero: lo que se espera recibir de la API (Pydantic v2).

Si la API cambia un campo, el tablero falla al validar con un mensaje claro en lugar de dibujar algo equivocado.
"""

from typing import Annotated, Literal

from pydantic import BaseModel, ConfigDict, Field

Competencia = Literal["emplear", "formular", "interpretar", "razonar"]
AnalisisInvarianza = Literal["zona", "H2_rural_urbana", "sexo", "sector"]


class Modelo(BaseModel):
    """Base: ignora campos nuevos de la API para no romper el tablero por agregados compatibles."""

    model_config = ConfigDict(extra="ignore")


class Salud(Modelo):
    estado: str
    version: str
    fecha_carga: str


class Hipotesis(Modelo):
    codigo: str
    objetivo: str
    decision: str
    archivo: str


class Robustez(Modelo):
    candidato: str
    conclusion: str
    aplicables: int
    evaluadas: int
    se_mantiene_en: int
    requerido: int
    robusto: str


class PasoInvarianza(Modelo):
    paso: str
    n: int
    convergio: bool
    cfi_scaled: float | None
    rmsea_scaled: float | None
    srmr: float | None
    dcfi: float | None
    drmsea: float | None
    se_sostiene: bool | None


class MediaLatente(Modelo):
    factor: str
    grupo: str
    referencia: str
    diferencia: float
    ee_brr: float
    ic95_inf: float
    ic95_sup: float


class Invarianza(Modelo):
    analisis: AnalisisInvarianza
    pasos: list[PasoInvarianza]
    medias_latentes: list[MediaLatente]
    nota: str


class ItemDIF(Modelo):
    item: str
    competencia: Competencia
    tipo: str
    n_q1: int
    n_q4: int
    p: float | None
    p_bh: float | None
    delta_mh: float | None
    mh_calculable: bool
    categoria_ets: str | None
    dr2_nagelkerke: float | None
    dif: bool
    favorece: str | None


class Coeficiente(Modelo):
    competencia: Competencia
    coeficiente: str
    estimacion: float
    ee_brr: float
    ic95_inf: float
    ic95_sup: float
    p: float
    por_de_eap: float | None
    r2_medio: float


class Interaccion(Modelo):
    competencia: Competencia
    interaccion: str
    estimacion: float
    ee_brr: float


class Perfil(BaseModel):
    """Perfil que se envía a la predicción (los límites repiten los de la API, D-46)."""

    model_config = ConfigDict(allow_inf_nan=False, extra="forbid")

    nse_economico: Annotated[float, Field(ge=-4, le=4)]
    nse_libros: Annotated[float, Field(ge=-4, le=4)] = 0.0
    sexo: Literal["Mujer", "Hombre"]
    grado: Annotated[int, Field(ge=-3, le=1)] = 0


class PuntajeEsperado(Modelo):
    competencia: Competencia
    puntaje_esperado: float


class Prediccion(Modelo):
    perfil: Perfil
    puntajes: list[PuntajeEsperado]
    fuente: str
    advertencia: str
