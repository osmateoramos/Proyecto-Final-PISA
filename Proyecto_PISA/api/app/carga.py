"""Carga de los resultados agregados de ``salidas/`` a la base SQLite (D-46 punto 2).

Se corre una vez antes de levantar la API (y en la imagen de Docker)::

    python -m app.carga

Cada fila se valida con su esquema de ``app.esquemas``. Si alguna fila no cumple, la carga se detiene y lista **todos**
los errores: los resultados tienen que coincidir con ``salidas/`` y no se descarta nada en silencio.
"""

import csv
from datetime import datetime, timezone
from pathlib import Path
from typing import TypeVar

from pydantic import ValidationError
from sqlalchemy import Engine
from sqlalchemy.orm import Session

from app.catalogo import RECURSOS
from app.config import obtener_configuracion
from app.db import Base, obtener_motor
from app.esquemas import (
    FilaCoeficienteSEM,
    FilaCSV,
    FilaInteraccionSEM,
    FilaItemDIF,
    FilaItemMatematicas,
    FilaItemNSE,
    FilaMediaLatente,
    FilaPasoInvarianza,
    FilaRobustez,
)
from app.registro import auditar, configurar_registro, registro
from app.tablas import (
    CoeficienteSEM,
    Hipotesis,
    InteraccionSEM,
    ItemDIF,
    ItemMatematicas,
    ItemNSE,
    MediaLatente,
    Metadato,
    PasoInvarianza,
    ResultadoFila,
    Robustez,
)

F = TypeVar("F", bound=FilaCSV)

TABLAS: list[tuple[type[Base], str, type[FilaCSV]]] = [
    (ItemNSE, "nse_estructura_afe.csv", FilaItemNSE),
    (ItemMatematicas, "items_competencia.csv", FilaItemMatematicas),
    (PasoInvarianza, "invarianza_tabla.csv", FilaPasoInvarianza),
    (MediaLatente, "nse_medias_latentes_brr.csv", FilaMediaLatente),
    (ItemDIF, "mat_dif.csv", FilaItemDIF),
    (CoeficienteSEM, "sem_coeficientes.csv", FilaCoeficienteSEM),
    (InteraccionSEM, "sem_h6_interacciones.csv", FilaInteraccionSEM),
    (Robustez, "f7_robustez.csv", FilaRobustez),
]
"""Tabla de la base, archivo de origen y esquema con que se valida cada fila."""

OBJETIVO = {"H1": "O1", "H2": "O2", "H3": "O3", "H4": "O3", "H5": "O4", "H6": "O4", "H7": "O3", "H8": "O3"}
"""Objetivo de cada hipótesis (Vault_PISA2022/09 Hipótesis preregistradas.md)."""


class ErrorCarga(Exception):
    """Algún archivo de ``salidas/`` falta o tiene filas que no cumplen su esquema."""


class CargadorSalidas:
    """Lee los CSV de ``salidas/``, los valida y los guarda en la base."""

    def __init__(self, carpeta_salidas: Path, motor: Engine) -> None:
        """Prepara la carga.

        Args:
            carpeta_salidas: Carpeta con los CSV agregados.
            motor: Motor de SQLAlchemy de la base destino.
        """
        self.carpeta = carpeta_salidas
        self.motor = motor

    def leer_csv(self, archivo: str) -> list[dict[str, str]]:
        """Lee un CSV de ``salidas/`` como una lista de diccionarios de texto.

        Args:
            archivo: Nombre del archivo dentro de la carpeta de salidas.

        Returns:
            Las filas del archivo.

        Raises:
            ErrorCarga: Si el archivo no existe.
        """
        ruta = self.carpeta / archivo
        if not ruta.is_file():
            raise ErrorCarga(f"Falta {ruta}: hay que correr antes la cadena de R (scripts/00_correr_todo.R)")
        with ruta.open(encoding="utf-8-sig", newline="") as f:
            return list(csv.DictReader(f))

    def validar(self, archivo: str, esquema: type[F]) -> list[F]:
        """Valida todas las filas de un archivo y reúne todos los errores.

        Args:
            archivo: Nombre del archivo dentro de la carpeta de salidas.
            esquema: Modelo de Pydantic de la fila.

        Returns:
            Las filas validadas.

        Raises:
            ErrorCarga: Si alguna fila no cumple el esquema (con todos los errores, no solo el primero).
        """
        validas: list[F] = []
        errores: list[str] = []
        for numero, fila in enumerate(self.leer_csv(archivo), start=2):     # la fila 1 es el encabezado
            try:
                validas.append(esquema.model_validate(fila))
            except ValidationError as e:
                errores.extend(f"{archivo}, fila {numero}, {'.'.join(map(str, err['loc']))}: {err['msg']}"
                               for err in e.errors())
        if errores:
            raise ErrorCarga("Filas que no cumplen su esquema:\n" + "\n".join(errores))
        return validas

    def decisiones_hipotesis(self) -> list[Hipotesis]:
        """Toma la decisión de cada hipótesis de su archivo de salidas (no se escribe a mano).

        Returns:
            Una fila por hipótesis, de H1 a H8.
        """
        def primera(archivo: str, columna: str) -> str:
            return self.leer_csv(archivo)[0][columna]

        h1 = next(f["H1"] for f in self.leer_csv("nse_h1_afc.csv") if f["decide_H1"].startswith("sí"))
        ajuste = {f["modelo"]: f for f in self.leer_csv("mat_ajuste.csv")}
        uno, cuatro = ajuste["1D"], next(f for m, f in ajuste.items() if m != "1D")
        h8_cumple = float(cuatro["BIC"]) < float(uno["BIC"]) and float(cuatro["correlacion_max"]) <= 0.95
        decisiones = {
            "H1": (h1, "nse_h1_afc.csv"),
            "H2": (primera("inv_h2.csv", "H2"), "inv_h2.csv"),
            "H3": (primera("mat_h3.csv", "H3"), "mat_h3.csv"),
            "H4": (primera("mat_h4.csv", "H4"), "mat_h4.csv"),
            "H5": (primera("sem_h5.csv", "H5"), "sem_h5.csv"),
            "H6": (primera("sem_h6.csv", "H6"), "sem_h6.csv"),
            "H7": (primera("mat_h7.csv", "H7"), "mat_h7.csv"),
            "H8": ("se acepta" if h8_cumple else "se rechaza", "mat_ajuste.csv"),
        }
        return [Hipotesis(codigo=c, objetivo=OBJETIVO[c], decision=d, archivo=a) for c, (d, a) in decisiones.items()]

    @auditar
    def cargar(self) -> dict[str, int]:
        """Rehace la base completa desde ``salidas/``.

        Primero valida todo y solo después escribe: si un archivo falla, la base anterior queda intacta.

        Returns:
            Número de filas guardadas por tabla.
        """
        filas = {tabla: self.validar(archivo, esquema) for tabla, archivo, esquema in TABLAS}
        catalogo = {r.archivo: self.validar(r.archivo, r.esquema) for r in RECURSOS}          # D-47
        hipotesis = self.decisiones_hipotesis()
        Base.metadata.drop_all(self.motor)
        Base.metadata.create_all(self.motor)
        with Session(self.motor) as sesion, sesion.begin():
            for tabla, validas in filas.items():
                sesion.add_all(tabla(**fila.model_dump()) for fila in validas)
            sesion.add_all(hipotesis)
            for archivo, validas in catalogo.items():
                sesion.add_all(ResultadoFila(archivo=archivo, orden=i, datos=fila.model_dump(mode="json"))
                               for i, fila in enumerate(validas))
            sesion.add_all([
                Metadato(clave="fecha_carga", valor=datetime.now(timezone.utc).isoformat(timespec="seconds")),
                Metadato(clave="archivos", valor=", ".join([a for _, a, _ in TABLAS] + list(catalogo))),
            ])
        conteo = {tabla.__tablename__: len(validas) for tabla, validas in filas.items()}
        conteo["hipotesis"] = len(hipotesis)
        conteo["catalogo (archivos)"] = len(catalogo)
        conteo["catalogo (filas)"] = sum(len(v) for v in catalogo.values())
        return conteo


def main() -> None:
    """Punto de entrada de ``python -m app.carga``."""
    configuracion = obtener_configuracion()
    configurar_registro(configuracion.nivel_log)
    conteo = CargadorSalidas(configuracion.carpeta_salidas, obtener_motor()).cargar()
    for tabla, n in conteo.items():
        registro.info("%-20s %4d filas", tabla, n)


if __name__ == "__main__":
    main()
