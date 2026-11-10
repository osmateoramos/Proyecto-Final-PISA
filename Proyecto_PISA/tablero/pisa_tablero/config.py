"""Configuración del tablero, leída de variables de entorno con el prefijo ``PISA_`` o de ``tablero/.env``."""

from functools import lru_cache
from pathlib import Path
from typing import Annotated

from pydantic import Field
from pydantic_settings import BaseSettings, SettingsConfigDict

RAIZ_TABLERO = Path(__file__).resolve().parents[1]


class ConfiguracionTablero(BaseSettings):
    """Parámetros de ejecución del tablero."""

    model_config = SettingsConfigDict(env_prefix="PISA_", env_file=RAIZ_TABLERO / ".env", extra="ignore")

    api_url: Annotated[str, Field(description="URL base de la API (sin /v1).")] = "http://127.0.0.1:8000"
    api_timeout: Annotated[float, Field(gt=0, le=120, description="Tiempo máximo de espera por petición, en s.")] = 10.0
    api_intentos: Annotated[int, Field(ge=1, le=6, description="Intentos ante fallos de red o 5xx.")] = 3


@lru_cache
def obtener_configuracion() -> ConfiguracionTablero:
    """Devuelve la configuración, leída una sola vez por proceso.

    Returns:
        La configuración vigente.
    """
    return ConfiguracionTablero()
