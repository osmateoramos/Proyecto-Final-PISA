"""Diagrama del modelo estructural (SVG)."""

import xml.etree.ElementTree as ET

import pandas as pd

from pisa_tablero.diagrama import Ruta, svg_modelo

CARGAS = pd.DataFrame({"item": ["A1", "A2", "B1"], "factor": ["ECO", "ECO", "CUL"], "carga_std": [0.8, 0.5, 0.9]})
RUTAS = [Ruta("ECO", c, 25.0, f"eco → {c}") for c in ["emplear", "formular", "interpretar", "razonar"]] + \
        [Ruta("CUL", c, 8.0, f"libros → {c}") for c in ["emplear", "formular", "interpretar", "razonar"]]


def test_es_svg_valido_con_todos_los_indicadores() -> None:
    svg = svg_modelo(CARGAS, {"A1": "Cuarto propio & <algo>"}, 0.52, RUTAS, "puntos")
    raiz = ET.fromstring(svg)                                    # falla si el SVG no es XML válido
    textos = "".join(raiz.itertext())
    assert all(item in textos for item in CARGAS["item"])
    assert "Cuarto propio & <algo>" in textos                    # la etiqueta se escapa bien
    assert "r = 0.52" in textos


def test_resaltar_atenua_las_otras_competencias() -> None:
    svg = svg_modelo(CARGAS, {}, None, RUTAS, "puntos", resaltar="interpretar")
    assert svg.count('opacity="0.15"') == 6                      # 8 rutas, 2 de interpretar quedan activas
