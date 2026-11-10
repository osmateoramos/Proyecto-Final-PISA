"""Conexión a la base SQLite con SQLAlchemy 2.0."""

from collections.abc import Iterator
from functools import lru_cache

from sqlalchemy import Engine, create_engine
from sqlalchemy.orm import DeclarativeBase, Session, sessionmaker

from app.config import obtener_configuracion


class Base(DeclarativeBase):
    """Base declarativa de todas las tablas."""


@lru_cache
def obtener_motor() -> Engine:
    """Crea el motor de la base una sola vez por proceso.

    Returns:
        El motor de SQLAlchemy apuntando a ``PISA_URL_BASE_DATOS``.
    """
    url = obtener_configuracion().url_base_datos
    argumentos = {"check_same_thread": False} if url.startswith("sqlite") else {}
    return create_engine(url, connect_args=argumentos)


def obtener_sesion() -> Iterator[Session]:
    """Dependencia de FastAPI: abre una sesión por petición y la cierra al terminar.

    Yields:
        Una sesión de SQLAlchemy de solo lectura en la práctica (la API no escribe).
    """
    fabrica = sessionmaker(bind=obtener_motor(), autoflush=False, expire_on_commit=False)
    with fabrica() as sesion:
        yield sesion
