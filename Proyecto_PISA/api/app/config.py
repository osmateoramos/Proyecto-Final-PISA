"""Configuración de la API.

Los valores salen de variables de entorno con el prefijo ``PISA_`` o de un archivo ``.env`` en ``Proyecto_PISA/api``
(que no se sube a Git; la plantilla es ``.env.example``). Nada de configuración queda escrito en el código.
"""

from functools import lru_cache
from pathlib import Path
from typing import Annotated, Literal

from pydantic import Field
from pydantic_settings import BaseSettings, SettingsConfigDict

RAIZ_API = Path(__file__).resolve().parents[1]
"""Carpeta ``Proyecto_PISA/api``."""


class Configuracion(BaseSettings):
    """Parámetros de ejecución de la API."""

    model_config = SettingsConfigDict(env_prefix="PISA_", env_file=RAIZ_API / ".env", extra="ignore")

    url_base_datos: Annotated[
        str, Field(description="URL de SQLAlchemy de la base SQLite con los resultados cargados.")
    ] = f"sqlite:///{(RAIZ_API / 'pisa_resultados.db').as_posix()}"
    carpeta_salidas: Annotated[
        Path, Field(description="Carpeta con los CSV agregados que produce la cadena de R (salidas/).")
    ] = RAIZ_API.parent / "salidas"
    nivel_log: Annotated[
        Literal["DEBUG", "INFO", "WARNING", "ERROR"], Field(description="Nivel del registro de la API.")
    ] = "INFO"


@lru_cache
def obtener_configuracion() -> Configuracion:
    """Devuelve la configuración, leída una sola vez por proceso.

    Returns:
        La configuración vigente.
    """
    return Configuracion()
