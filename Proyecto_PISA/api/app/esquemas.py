"""Contratos de datos (Pydantic v2).

Dos familias:

* ``Fila*``: validan cada fila de los CSV de ``salidas/`` antes de guardarla en la base (``app.carga``). Los nombres de
  campo son los de la base; ``alias`` da el nombre de la columna en el CSV.
* ``*Respuesta`` y ``Perfil*``: lo que la API recibe y devuelve. Se documentan solos en ``/docs``.

Un vacío del CSV se guarda como ``None`` (dato ausente), nunca como 0: un 0 falso sesgaría cualquier promedio.
"""

from typing import Annotated, Any, ClassVar, Literal

from pydantic import BaseModel, ConfigDict, Field, model_validator

Competencia = Literal["emplear", "formular", "interpretar", "razonar"]
"""Las 4 competencias (procesos) de matemáticas de PISA 2022."""

AnalisisInvarianza = Literal["zona", "H2_rural_urbana", "sexo", "sector"]
"""Análisis de invarianza de la F4 (D-25)."""

VACIOS = frozenset({"", "NA", "NaN"})


# =====================================================================================================================
# Filas de los CSV (entrada de la carga)
# =====================================================================================================================
class FilaCSV(BaseModel):
    """Base de las filas: limpia los vacíos antes de validar los tipos."""

    model_config = ConfigDict(populate_by_name=True, extra="ignore", str_strip_whitespace=True, allow_inf_nan=False)

    NO_CALCULABLE_COMO_NULO: ClassVar[frozenset[str]] = frozenset()
    """Columnas del CSV donde ``Inf`` significa «R no pudo calcularlo» y se guarda como ``None``. En el resto, un
    infinito sigue siendo un error de carga."""

    @model_validator(mode="before")
    @classmethod
    def vacios_a_none(cls, datos: Any) -> Any:
        """Convierte las celdas vacías o ``NA`` (y los ``Inf`` de las columnas declaradas) en ``None``.

        Args:
            datos: La fila tal como la entrega ``csv.DictReader``.

        Returns:
            La misma fila con ``None`` en los vacíos.
        """
        if isinstance(datos, dict):
            def limpio(k: str, v: Any) -> Any:
                if not isinstance(v, str):
                    return v
                texto = v.strip()
                if texto in VACIOS or (k in cls.NO_CALCULABLE_COMO_NULO and texto in {"Inf", "-Inf"}):
                    return None
                return v
            return {k: limpio(k, v) for k, v in datos.items()}
        return datos


class FilaItemNSE(FilaCSV):
    """Fila de ``nse_estructura_afe.csv``."""

    item: str
    factor_d16: Annotated[Literal["económico", "cultural"], Field(alias="factor_D16")]
    factor_afe: Annotated[Literal["económico", "cultural"], Field(alias="factor_AFE")]
    carga_principal: Annotated[float, Field(ge=-1, le=1)]
    coincide: bool


class FilaItemMatematicas(FilaCSV):
    """Fila de ``items_competencia.csv``."""

    item: str
    competencia: Competencia | None
    unidad: str | None
    formato: str | None
    contenido: str | None
    contexto: str | None
    a_int: float | None
    b_int: float | None
    retirado: bool | None
    calibrable: bool


class FilaPasoInvarianza(FilaCSV):
    """Fila de ``invarianza_tabla.csv``."""

    analisis: AnalisisInvarianza
    paso: Literal["configural", "umbrales", "cargas", "interceptos"]
    n: Annotated[int, Field(gt=0)]
    convergio: bool
    cfi_scaled: Annotated[float | None, Field(alias="cfi.scaled")]
    rmsea_scaled: Annotated[float | None, Field(alias="rmsea.scaled")]
    srmr: float | None
    dcfi: Annotated[float | None, Field(alias="dCFI")]
    drmsea: Annotated[float | None, Field(alias="dRMSEA")]
    se_sostiene: bool | None


class FilaMediaLatente(FilaCSV):
    """Fila de ``nse_medias_latentes_brr.csv``."""

    analisis: AnalisisInvarianza
    factor: Literal["ECO", "CUL"]
    grupo: str
    referencia: str
    diferencia: float
    ee_brr: Annotated[float, Field(alias="ee_BRR", gt=0)]
    ic95_inf: Annotated[float, Field(alias="ic95_inf_BRR")]
    ic95_sup: Annotated[float, Field(alias="ic95_sup_BRR")]

    @model_validator(mode="after")
    def intervalo_ordenado(self) -> "FilaMediaLatente":
        """Comprueba que el intervalo contenga la estimación."""
        if not self.ic95_inf <= self.diferencia <= self.ic95_sup:
            raise ValueError("el IC 95 % no contiene la diferencia estimada")
        return self


class FilaItemDIF(FilaCSV):
    """Fila de ``mat_dif.csv``."""

    item: str
    competencia: Competencia
    tipo: Literal["2PL", "gpcm"]
    n_q1: Annotated[int, Field(alias="n_Q1", ge=0)]
    n_q4: Annotated[int, Field(alias="n_Q4", ge=0)]
    p: Annotated[float | None, Field(ge=0, le=1)]
    p_bh: Annotated[float | None, Field(alias="p_BH", ge=0, le=1)]
    delta_mh: Annotated[float | None, Field(alias="delta_MH")]
    mh_calculable: bool = True
    categoria_ets: Annotated[Literal["A", "B", "C"] | None, Field(alias="categoria_ETS")]
    dr2_nagelkerke: Annotated[float | None, Field(alias="dR2_Nagelkerke")]
    dif: Annotated[bool, Field(alias="DIF")]
    favorece: str | None

    @model_validator(mode="before")
    @classmethod
    def mh_infinito(cls, datos: Any) -> Any:
        """Un ΔMH infinito (``Inf`` en R: α_MH de 0 o infinito) se guarda como ``None`` con ``mh_calculable = False``.

        En ``mat_dif.csv`` pasa en 2 ítems; R los dejó en la categoría A porque su prueba MH no se pudo calcular.

        Args:
            datos: La fila del CSV.

        Returns:
            La fila con el ΔMH infinito reemplazado y la marca agregada.
        """
        if isinstance(datos, dict):
            valor = datos.get("delta_MH")
            if isinstance(valor, str) and valor.strip() in {"Inf", "-Inf"}:
                return {**datos, "delta_MH": None, "mh_calculable": False}
        return datos


class FilaCoeficienteSEM(FilaCSV):
    """Fila de ``sem_coeficientes.csv``."""

    competencia: Competencia
    coeficiente: str
    estimacion: float
    ee_brr: Annotated[float, Field(alias="ee_BRR", gt=0)]
    ic95_inf: float
    ic95_sup: float
    p: Annotated[float, Field(ge=0, le=1)]
    por_de_eap: Annotated[float | None, Field(alias="por_DE_de_la_EAP")]
    r2_medio: Annotated[float, Field(alias="R2_medio", ge=0, le=1)]


class FilaInteraccionSEM(FilaCSV):
    """Fila de ``sem_h6_interacciones.csv``."""

    competencia: Competencia
    interaccion: Literal["eco:zonapueblo", "eco:zonarural", "eco:sectorprivado"]
    estimacion: float
    ee_brr: Annotated[float, Field(alias="ee_BRR", gt=0)]


class FilaRobustez(FilaCSV):
    """Fila de ``f7_robustez.csv``."""

    candidato: Annotated[str, Field(pattern=r"^K[1-9]$")]
    conclusion: str
    aplicables: Annotated[int, Field(ge=0)]
    evaluadas: Annotated[int, Field(ge=0)]
    se_mantiene_en: Annotated[int, Field(ge=0)]
    requerido: Annotated[int, Field(ge=0)]
    robusto: str


# =====================================================================================================================
# Respuestas de la API
# =====================================================================================================================
class Respuesta(BaseModel):
    """Base de las respuestas: se construyen desde los objetos de la base."""

    model_config = ConfigDict(from_attributes=True)


class SaludRespuesta(Respuesta):
    """Estado del servicio."""

    estado: Literal["ok"]
    version: str
    fecha_carga: Annotated[str, Field(description="Cuándo se cargó la base desde salidas/.")]


class ItemNSERespuesta(Respuesta):
    """Indicador del NSE."""

    item: str
    factor_d16: str
    factor_afe: Annotated[str, Field(description="Factor del modelo del AFE que pasó a la F4-F6 (D-24).")]
    carga_principal: float
    coincide: bool


class ItemMatematicasRespuesta(Respuesta):
    """Ítem de matemáticas con sus parámetros internacionales (anexo A del Technical Report)."""

    item: str
    competencia: Competencia | None
    unidad: str | None
    formato: str | None
    contenido: str | None
    contexto: str | None
    a_int: float | None
    b_int: float | None
    retirado: bool | None
    calibrable: bool


class PasoInvarianzaRespuesta(Respuesta):
    """Paso de la secuencia de invarianza."""

    paso: str
    n: int
    convergio: bool
    cfi_scaled: float | None
    rmsea_scaled: float | None
    srmr: float | None
    dcfi: float | None
    drmsea: float | None
    se_sostiene: bool | None


class MediaLatenteRespuesta(Respuesta):
    """Diferencia de medias latentes del NSE frente al grupo de referencia, en DE latentes."""

    factor: str
    grupo: str
    referencia: str
    diferencia: float
    ee_brr: float
    ic95_inf: float
    ic95_sup: float


class InvarianzaRespuesta(BaseModel):
    """Resultado de invarianza de un análisis de la F4."""

    analisis: AnalisisInvarianza
    pasos: list[PasoInvarianzaRespuesta]
    medias_latentes: list[MediaLatenteRespuesta]
    nota: str


class ItemDIFRespuesta(Respuesta):
    """DIF por NSE (cuartil bajo frente a alto) de un ítem."""

    item: str
    competencia: Competencia
    tipo: str
    n_q1: int
    n_q4: int
    p: float | None
    p_bh: float | None
    delta_mh: float | None
    mh_calculable: Annotated[bool, Field(description="False si ΔMH salió infinito en R (la prueba MH no se calculó).")]
    categoria_ets: str | None
    dr2_nagelkerke: float | None
    dif: bool
    favorece: str | None


class CoeficienteRespuesta(Respuesta):
    """Coeficiente del modelo principal de la F6, en puntos PISA."""

    competencia: Competencia
    coeficiente: str
    estimacion: float
    ee_brr: float
    ic95_inf: float
    ic95_sup: float
    p: float
    por_de_eap: float | None
    r2_medio: float


class InteraccionRespuesta(Respuesta):
    """Diferencia en la pendiente del NSE económico frente al grupo de referencia (H6)."""

    competencia: Competencia
    interaccion: str
    estimacion: float
    ee_brr: float


class HipotesisRespuesta(Respuesta):
    """Decisión de una hipótesis preregistrada."""

    codigo: str
    objetivo: str
    decision: str
    archivo: Annotated[str, Field(description="Archivo de salidas/ del que sale la decisión.")]


class RobustezRespuesta(Respuesta):
    """Robustez de un candidato a hallazgo en la F7."""

    candidato: str
    conclusion: str
    aplicables: int
    evaluadas: int
    se_mantiene_en: int
    requerido: int
    robusto: str


class PerfilPrediccion(BaseModel):
    """Perfil para el que se pide el puntaje esperado (D-46 punto 3)."""

    model_config = ConfigDict(allow_inf_nan=False, extra="forbid")

    nse_economico: Annotated[
        float, Field(ge=-4, le=4, description="EAP del NSE económico (media 0, DE ≈ 0,95; D-42).", examples=[0.0])
    ]
    nse_libros: Annotated[float, Field(ge=-4, le=4, description="EAP del factor de libros (D-24).", examples=[0.0])] = 0.0
    sexo: Annotated[Literal["Mujer", "Hombre"], Field(description="Mujer es la referencia del modelo.")]
    grado: Annotated[
        int, Field(ge=-3, le=1, description="Grado relativo al modal (0 = modal; -3 a -1 atrasado; 1 adelantado).")
    ] = 0


class PuntajeEsperado(BaseModel):
    """Puntaje esperado de una competencia."""

    competencia: Competencia
    puntaje_esperado: Annotated[float, Field(description="Puntos PISA (media condicional estimada).")]


class PrediccionRespuesta(BaseModel):
    """Puntajes esperados de las 4 competencias para un perfil."""

    perfil: PerfilPrediccion
    puntajes: list[PuntajeEsperado]
    fuente: str
    advertencia: str
