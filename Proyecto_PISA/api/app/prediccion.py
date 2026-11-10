"""Puntaje esperado por competencia con los coeficientes de la F6 (D-42, D-46 punto 3).

``ModeloF6`` es un Singleton: los coeficientes se leen de la base **una vez**, al iniciar la API, y todas las peticiones
usan la misma instancia. Nunca se cargan dentro del endpoint.
"""

import threading
from typing import ClassVar

from sqlalchemy import select
from sqlalchemy.orm import Session

from app.esquemas import Competencia, PerfilPrediccion, PuntajeEsperado
from app.registro import auditar
from app.tablas import CoeficienteSEM

COMPETENCIAS: tuple[Competencia, ...] = ("emplear", "formular", "interpretar", "razonar")
COEFICIENTES_REQUERIDOS = frozenset({"(Intercept)", "eco", "libros", "sexoHombre", "grado-3", "grado-2", "grado-1", "grado1"})
ADVERTENCIA = (
    "Media condicional estimada con el modelo principal de la F6 (VP de la OCDE, BRR y Rubin): no es el puntaje de una "
    "persona ni un efecto causal (diseño transversal). Sin intervalo: la covarianza de los coeficientes no se exporta."
)


class ModeloNoCargadoError(RuntimeError):
    """Se pidió una predicción antes de cargar el modelo."""


class ModeloF6:
    """Coeficientes del modelo principal de la F6, cargados una sola vez (Singleton)."""

    _instancia: ClassVar["ModeloF6 | None"] = None
    _candado: ClassVar[threading.Lock] = threading.Lock()

    def __init__(self, coeficientes: dict[Competencia, dict[str, float]]) -> None:
        """Guarda los coeficientes; usar ``ModeloF6.cargar`` en lugar de construirlo a mano.

        Args:
            coeficientes: Por competencia, el valor de cada coeficiente en puntos PISA.

        Raises:
            ValueError: Si falta alguna competencia o algún coeficiente del modelo.
        """
        for competencia in COMPETENCIAS:
            faltan = COEFICIENTES_REQUERIDOS - coeficientes.get(competencia, {}).keys()
            if faltan:
                raise ValueError(f"Faltan coeficientes de {competencia}: {sorted(faltan)}")
        self.coeficientes = coeficientes

    @classmethod
    def cargar(cls, sesion: Session) -> "ModeloF6":
        """Lee los coeficientes de la base y crea la instancia única (si ya existe, la reemplaza).

        Args:
            sesion: Sesión de la base con la tabla ``sem_coeficientes``.

        Returns:
            La instancia única.
        """
        coeficientes: dict[Competencia, dict[str, float]] = {}
        for fila in sesion.scalars(select(CoeficienteSEM)):
            coeficientes.setdefault(fila.competencia, {})[fila.coeficiente] = fila.estimacion
        with cls._candado:
            cls._instancia = cls(coeficientes)
        return cls._instancia

    @classmethod
    def obtener(cls) -> "ModeloF6":
        """Devuelve la instancia única.

        Returns:
            El modelo cargado al iniciar la API.

        Raises:
            ModeloNoCargadoError: Si todavía no se ha cargado.
        """
        if cls._instancia is None:
            raise ModeloNoCargadoError("El modelo de la F6 no se ha cargado (ver el ciclo de vida de app.main)")
        return cls._instancia

    @staticmethod
    def termino_grado(grado: int) -> str | None:
        """Nombre del coeficiente del grado (el grado modal es la referencia y no tiene coeficiente).

        Args:
            grado: Grado relativo al modal, de -3 a 1.

        Returns:
            El nombre del coeficiente, o ``None`` para el grado modal.
        """
        match grado:
            case 0:
                return None
            case -3 | -2 | -1 | 1:
                return f"grado{grado}"
            case _:
                raise ValueError(f"Grado fuera del modelo: {grado}")

    @auditar
    def predecir(self, perfil: PerfilPrediccion) -> list[PuntajeEsperado]:
        """Calcula el puntaje esperado de las 4 competencias para un perfil.

        Args:
            perfil: Perfil ya validado por Pydantic.

        Returns:
            Un puntaje esperado por competencia, en puntos PISA, redondeado a 1 decimal.
        """
        grado = self.termino_grado(perfil.grado)
        puntajes = []
        for competencia in COMPETENCIAS:
            b = self.coeficientes[competencia]
            valor = (b["(Intercept)"] + b["eco"] * perfil.nse_economico + b["libros"] * perfil.nse_libros
                     + (b["sexoHombre"] if perfil.sexo == "Hombre" else 0.0) + (b[grado] if grado else 0.0))
            puntajes.append(PuntajeEsperado(competencia=competencia, puntaje_esperado=round(valor, 1)))
        return puntajes
