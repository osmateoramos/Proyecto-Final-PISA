"""Cliente HTTP de la API: única puerta del tablero hacia los datos."""

import time
from typing import Any, TypeVar

import httpx
from pydantic import BaseModel, TypeAdapter, ValidationError

from pisa_tablero.modelos import (
    AnalisisInvarianza,
    Coeficiente,
    Competencia,
    Hipotesis,
    Interaccion,
    Invarianza,
    ItemDIF,
    Perfil,
    Prediccion,
    Robustez,
    Salud,
)

M = TypeVar("M", bound=BaseModel)
PREFIJO = "/v1"


class ErrorAPI(Exception):
    """La API no respondió, respondió con error o devolvió algo que no cumple el contrato."""


class ClienteAPI:
    """Pide los resultados a la API y los valida con los modelos de ``pisa_tablero.modelos``."""

    def __init__(self, url_base: str, timeout: float = 10.0, intentos: int = 3,
                 http: httpx.Client | None = None, espera_base: float = 0.5) -> None:
        """Prepara el cliente.

        Args:
            url_base: URL de la API, sin ``/v1``.
            timeout: Tiempo máximo de espera por petición, en segundos.
            intentos: Intentos ante fallos de red o respuestas 5xx (los 4xx no se reintentan).
            http: Cliente de httpx ya creado (en las pruebas, uno con transporte simulado).
            espera_base: Espera antes del segundo intento; se duplica en cada intento (backoff exponencial).
        """
        self.http = http or httpx.Client(base_url=url_base, timeout=timeout)
        self.intentos = intentos
        self.espera_base = espera_base

    def _pedir(self, metodo: str, ruta: str, **kwargs: Any) -> Any:
        """Hace la petición con reintentos y devuelve el JSON.

        Raises:
            ErrorAPI: Si la API no responde tras los reintentos o responde con un error.
        """
        for intento in range(1, self.intentos + 1):
            try:
                respuesta = self.http.request(metodo, ruta, **kwargs)
            except httpx.TransportError as e:
                if intento == self.intentos:
                    raise ErrorAPI(f"No se pudo conectar con la API ({type(e).__name__}). ¿Está corriendo?") from e
            else:
                if respuesta.status_code < 500 or intento == self.intentos:
                    break
            time.sleep(self.espera_base * 2 ** (intento - 1))
        if respuesta.is_error:
            raise ErrorAPI(f"La API respondió {respuesta.status_code} en {ruta}: {self._detalle(respuesta)}")
        return respuesta.json()

    @staticmethod
    def _detalle(respuesta: httpx.Response) -> str:
        """Extrae un mensaje legible del cuerpo de un error (el ``detail`` de FastAPI)."""
        try:
            detalle = respuesta.json().get("detail", respuesta.text)
        except ValueError:
            return respuesta.text[:200]
        if isinstance(detalle, list):                                    # 422: lista de errores de validación
            return "; ".join(f"{'.'.join(map(str, d.get('loc', [])))}: {d.get('msg', '')}" for d in detalle)
        return str(detalle)

    @staticmethod
    def _validar(tipo: Any, datos: Any) -> Any:
        try:
            return TypeAdapter(tipo).validate_python(datos)
        except ValidationError as e:
            raise ErrorAPI(f"La respuesta de la API no cumple el contrato del tablero: {e.error_count()} errores") from e

    def salud(self) -> Salud:
        """Estado de la API."""
        return self._validar(Salud, self._pedir("GET", "/health"))

    def hipotesis(self) -> list[Hipotesis]:
        """Decisión de H1 a H8."""
        return self._validar(list[Hipotesis], self._pedir("GET", f"{PREFIJO}/hipotesis"))

    def robustez(self) -> list[Robustez]:
        """Robustez de los candidatos de la F7."""
        return self._validar(list[Robustez], self._pedir("GET", f"{PREFIJO}/robustez"))

    def invarianza(self, analisis: AnalisisInvarianza) -> Invarianza:
        """Invarianza y medias latentes de un análisis de la F4."""
        return self._validar(Invarianza, self._pedir("GET", f"{PREFIJO}/invarianza/{analisis}"))

    def dif(self, competencia: Competencia | None = None) -> list[ItemDIF]:
        """DIF por NSE de los ítems de matemáticas."""
        parametros = {"competencia": competencia} if competencia else None
        return self._validar(list[ItemDIF], self._pedir("GET", f"{PREFIJO}/dif", params=parametros))

    def coeficientes(self) -> list[Coeficiente]:
        """Coeficientes del modelo principal de la F6."""
        return self._validar(list[Coeficiente], self._pedir("GET", f"{PREFIJO}/modelo/coeficientes"))

    def interacciones(self) -> list[Interaccion]:
        """Interacciones NSE x zona y NSE x sector (H6)."""
        return self._validar(list[Interaccion], self._pedir("GET", f"{PREFIJO}/modelo/interacciones"))

    def predecir(self, perfil: Perfil) -> Prediccion:
        """Puntaje esperado de las 4 competencias para un perfil."""
        return self._validar(Prediccion, self._pedir("POST", f"{PREFIJO}/modelo/prediccion", json=perfil.model_dump()))
