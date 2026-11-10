"""Tablas de la base (ORM de SQLAlchemy 2.0).

Cada tabla guarda un archivo agregado de ``salidas/``; ninguna tiene filas por estudiante (Ley 1581 de 2012).
"""

from typing import Any

from sqlalchemy import JSON, String
from sqlalchemy.orm import Mapped, mapped_column

from app.db import Base


class Metadato(Base):
    """Datos de la carga (fecha y archivos de origen)."""

    __tablename__ = "metadatos"
    clave: Mapped[str] = mapped_column(String(50), primary_key=True)
    valor: Mapped[str] = mapped_column(String(500))


class ItemNSE(Base):
    """Indicador del NSE y el factor en que carga (salidas/nse_estructura_afe.csv, D-24)."""

    __tablename__ = "nse_items"
    item: Mapped[str] = mapped_column(String(20), primary_key=True)
    factor_d16: Mapped[str] = mapped_column(String(20))
    factor_afe: Mapped[str] = mapped_column(String(20))
    carga_principal: Mapped[float]
    coincide: Mapped[bool]


class ItemMatematicas(Base):
    """Ítem de matemáticas con su clasificación del anexo A (salidas/items_competencia.csv, D-27)."""

    __tablename__ = "matematicas_items"
    item: Mapped[str] = mapped_column(String(20), primary_key=True)
    competencia: Mapped[str | None] = mapped_column(String(20), index=True)   # vacía en el ítem sin clasificar
    unidad: Mapped[str | None] = mapped_column(String(100))
    formato: Mapped[str | None] = mapped_column(String(100))
    contenido: Mapped[str | None] = mapped_column(String(100))
    contexto: Mapped[str | None] = mapped_column(String(100))
    a_int: Mapped[float | None]
    b_int: Mapped[float | None]
    retirado: Mapped[bool | None]
    calibrable: Mapped[bool]


class PasoInvarianza(Base):
    """Paso de la secuencia de invarianza (salidas/invarianza_tabla.csv, D-25)."""

    __tablename__ = "invarianza_pasos"
    id: Mapped[int] = mapped_column(primary_key=True, autoincrement=True)
    analisis: Mapped[str] = mapped_column(String(30), index=True)
    paso: Mapped[str] = mapped_column(String(30))
    n: Mapped[int]
    convergio: Mapped[bool]
    cfi_scaled: Mapped[float | None]
    rmsea_scaled: Mapped[float | None]
    srmr: Mapped[float | None]
    dcfi: Mapped[float | None]
    drmsea: Mapped[float | None]
    se_sostiene: Mapped[bool | None]


class MediaLatente(Base):
    """Diferencia de medias latentes del NSE con error BRR (salidas/nse_medias_latentes_brr.csv, D-34)."""

    __tablename__ = "medias_latentes"
    id: Mapped[int] = mapped_column(primary_key=True, autoincrement=True)
    analisis: Mapped[str] = mapped_column(String(30), index=True)
    factor: Mapped[str] = mapped_column(String(10))
    grupo: Mapped[str] = mapped_column(String(30))
    referencia: Mapped[str] = mapped_column(String(30))
    diferencia: Mapped[float]
    ee_brr: Mapped[float]
    ic95_inf: Mapped[float]
    ic95_sup: Mapped[float]


class ItemDIF(Base):
    """Resultado del DIF por NSE de un ítem de matemáticas (salidas/mat_dif.csv, D-40)."""

    __tablename__ = "dif_items"
    item: Mapped[str] = mapped_column(String(20), primary_key=True)
    competencia: Mapped[str] = mapped_column(String(20), index=True)
    tipo: Mapped[str] = mapped_column(String(10))
    n_q1: Mapped[int]
    n_q4: Mapped[int]
    p: Mapped[float | None]
    p_bh: Mapped[float | None]
    delta_mh: Mapped[float | None]
    mh_calculable: Mapped[bool]
    categoria_ets: Mapped[str | None] = mapped_column(String(1))
    dr2_nagelkerke: Mapped[float | None]
    dif: Mapped[bool]
    favorece: Mapped[str | None] = mapped_column(String(30))


class CoeficienteSEM(Base):
    """Coeficiente del modelo principal de la F6 (salidas/sem_coeficientes.csv, D-42)."""

    __tablename__ = "sem_coeficientes"
    id: Mapped[int] = mapped_column(primary_key=True, autoincrement=True)
    competencia: Mapped[str] = mapped_column(String(20), index=True)
    coeficiente: Mapped[str] = mapped_column(String(20))
    estimacion: Mapped[float]
    ee_brr: Mapped[float]
    ic95_inf: Mapped[float]
    ic95_sup: Mapped[float]
    p: Mapped[float]
    por_de_eap: Mapped[float | None]
    r2_medio: Mapped[float]


class InteraccionSEM(Base):
    """Interacción NSE x zona o NSE x sector de H6 (salidas/sem_h6_interacciones.csv, D-42)."""

    __tablename__ = "sem_interacciones"
    id: Mapped[int] = mapped_column(primary_key=True, autoincrement=True)
    competencia: Mapped[str] = mapped_column(String(20), index=True)
    interaccion: Mapped[str] = mapped_column(String(30))
    estimacion: Mapped[float]
    ee_brr: Mapped[float]


class Hipotesis(Base):
    """Decisión de una hipótesis preregistrada, tomada de su archivo de salida (nota 09 del vault)."""

    __tablename__ = "hipotesis"
    codigo: Mapped[str] = mapped_column(String(3), primary_key=True)
    objetivo: Mapped[str] = mapped_column(String(3))
    decision: Mapped[str] = mapped_column(String(100))
    archivo: Mapped[str] = mapped_column(String(60))


class Robustez(Base):
    """Robustez de un candidato a hallazgo en la F7 (salidas/f7_robustez.csv, D-45)."""

    __tablename__ = "robustez"
    candidato: Mapped[str] = mapped_column(String(3), primary_key=True)
    conclusion: Mapped[str] = mapped_column(String(200))
    aplicables: Mapped[int]
    evaluadas: Mapped[int]
    se_mantiene_en: Mapped[int]
    requerido: Mapped[int]
    robusto: Mapped[str] = mapped_column(String(30))


class ResultadoFila(Base):
    """Fila validada de un archivo del catálogo de resultados (D-47); ``datos`` guarda la fila ya validada."""

    __tablename__ = "resultado_filas"
    id: Mapped[int] = mapped_column(primary_key=True, autoincrement=True)
    archivo: Mapped[str] = mapped_column(String(60), index=True)
    orden: Mapped[int]
    datos: Mapped[dict[str, Any]] = mapped_column(JSON)
