"""Registro (logging) de la API y decorador de auditoría."""

import functools
import logging
import time
from collections.abc import Callable
from typing import ParamSpec, TypeVar

P = ParamSpec("P")
R = TypeVar("R")

registro = logging.getLogger("pisa_api")


def configurar_registro(nivel: str) -> None:
    """Configura el formato y el nivel del registro de la API.

    Args:
        nivel: Nivel de ``logging`` (DEBUG, INFO, WARNING o ERROR).
    """
    logging.basicConfig(level=nivel, format="%(asctime)s | %(levelname)s | %(name)s | %(message)s")


def auditar(func: Callable[P, R]) -> Callable[P, R]:
    """Decorador: registra cada llamada con su duración, para auditoría.

    Solo registra el nombre de la función y el tiempo; los argumentos no se escriben en el registro.

    Args:
        func: Función que se envuelve.

    Returns:
        La función envuelta, con el mismo nombre y docstring (``functools.wraps``).
    """

    @functools.wraps(func)
    def envoltura(*args: P.args, **kwargs: P.kwargs) -> R:
        inicio = time.perf_counter()
        try:
            return func(*args, **kwargs)
        finally:
            registro.info("%s terminó en %.1f ms", func.__name__, 1000 * (time.perf_counter() - inicio))

    return envoltura
