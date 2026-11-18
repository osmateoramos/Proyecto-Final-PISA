"""Exporta el diagrama del modelo final (D-51) como SVG, a partir de los CSV de ``salidas/``, para el informe.

Usa la misma función que dibuja el diagrama en el tablero (``svg_modelo``), así que la figura del informe es la misma
del tablero. No necesita la API: lee los archivos directamente. Las rutas son las del análisis principal (dos pasos con
los VP de la OCDE, D-42). Escribe ``salidas/sem_diagrama_competencias.svg``; el informe lo convierte a PDF con ``rsvg``.

Uso (desde ``Proyecto_PISA/tablero/``, con el entorno del tablero)::

    python exportar_diagrama.py ../salidas
"""

import sys
from pathlib import Path

import pandas as pd

from pisa_tablero.diagrama import Ruta, svg_modelo

ARCHIVO = "sem_diagrama_competencias.svg"


def exportar(salidas: Path) -> Path:
    """Escribe el SVG del modelo final en ``salidas`` y devuelve su ruta.

    Args:
        salidas: Carpeta ``salidas/`` del proyecto.

    Returns:
        La ruta del SVG escrito.
    """
    cargas = pd.read_csv(salidas / "nse_cargas_afc.csv")
    cargas = cargas[cargas["modelo"] == "M2_AFE"]
    ajuste = pd.read_csv(salidas / "nse_ajuste_afc.csv")
    r_fact = ajuste.loc[ajuste["modelo"] == "M2_AFE", "correlacion_factores"].dropna()
    coef = pd.read_csv(salidas / "sem_coeficientes.csv")
    coef = coef[coef["coeficiente"].isin(["eco", "libros"])]
    factor = {"eco": "ECO", "libros": "CUL"}
    rutas = [Ruta(factor[f.coeficiente], f.competencia, float(f.por_DE_de_la_EAP), "") for f in coef.itertuples()]
    resumen = pd.read_csv(salidas / "mat_afc_resumen.csv")
    phi = pd.read_csv(salidas / "mat_afc_phi.csv")
    svg = svg_modelo(cargas, {}, float(r_fact.iloc[0]) if not r_fact.empty else None, rutas,
                     "puntos PISA por DE del NSE (dos pasos, VP de la OCDE)",
                     cargas_competencia=resumen[resumen["competencia"] != "total"], phi=phi)
    destino = salidas / ARCHIVO
    destino.write_text(svg, encoding="utf-8")
    return destino


if __name__ == "__main__":
    carpeta = Path(sys.argv[1]) if len(sys.argv) > 1 else Path(__file__).resolve().parent.parent / "salidas"
    print("SVG escrito en", exportar(carpeta))
