"""Diagrama del modelo estructural (SVG)."""

import xml.etree.ElementTree as ET

import pandas as pd

from pisa_tablero.diagrama import COMPETENCIAS, Ruta, svg_medicion, svg_modelo

CARGAS = pd.DataFrame({"item": ["A1", "A2", "B1"], "factor": ["ECO", "ECO", "CUL"], "carga_std": [0.8, 0.5, 0.9]})
RUTAS = [Ruta("ECO", c, 25.0, f"eco → {c}") for c in COMPETENCIAS] + \
        [Ruta("CUL", c, 8.0, f"libros → {c}") for c in COMPETENCIAS]
CARGAS_COMPETENCIA = pd.DataFrame({"competencia": COMPETENCIAS, "items": [75, 47, 57, 53],
                                   "carga_mediana": [0.477, 0.501, 0.53, 0.63], "carga_min": [-0.207, -0.065, 0.016, -0.011],
                                   "carga_max": [0.912, 0.928, 0.919, 0.974], "carga_menor_030": [22, 17, 6, 11]})
PHI = pd.DataFrame({"competencia": COMPETENCIAS, "emplear": [1, 0.94, 0.951, 0.976], "formular": [0.94, 1, 0.897, 0.945],
                    "interpretar": [0.951, 0.897, 1, 0.906], "razonar": [0.976, 0.945, 0.906, 1]})
SVG_NS = "{http://www.w3.org/2000/svg}"


def test_es_svg_valido_con_todos_los_indicadores() -> None:
    svg = svg_modelo(CARGAS, {"A1": "Cuarto propio & <algo>"}, 0.52, RUTAS, "puntos")
    raiz = ET.fromstring(svg)                                    # falla si el SVG no es XML válido
    textos = "".join(raiz.itertext())
    assert all(item in textos for item in CARGAS["item"])
    assert "Cuarto propio & <algo>" in textos                    # la etiqueta se escapa bien
    assert "r = 0,52" in textos                                  # coma decimal, como en el resto del proyecto


def test_resaltar_atenua_las_otras_competencias() -> None:
    svg = svg_modelo(CARGAS, {}, None, RUTAS, "puntos", resaltar="interpretar")
    assert svg.count('opacity="0.15"') == 6                      # 8 rutas, 2 de interpretar quedan activas


def test_competencias_son_ovalos() -> None:
    raiz = ET.fromstring(svg_modelo(CARGAS, {}, None, RUTAS, "puntos"))
    assert len(raiz.findall(f".//{SVG_NS}ellipse")) == 2 + len(COMPETENCIAS)   # 2 factores del NSE + 4 competencias


def test_cajas_de_cargas_y_arcos_phi() -> None:
    svg = svg_modelo(CARGAS, {}, None, RUTAS, "puntos", cargas_competencia=CARGAS_COMPETENCIA, phi=PHI)
    raiz = ET.fromstring(svg)
    textos = "".join(raiz.itertext())
    assert "75 ítems · carga mediana 0,48" in textos
    assert "−0,21 a 0,91 · 22 con carga < 0,30" in textos       # signo menos tipográfico y < escapado
    arcos = raiz.findall(f".//{SVG_NS}path[@marker-start]")
    assert len(arcos) == 6                                       # un arco por cada par de competencias
    assert all(v in textos for v in ["0,940", "0,951", "0,976", "0,897", "0,945", "0,906"])


def test_exportar_lee_salidas_y_escribe_el_svg(tmp_path) -> None:
    import exportar_diagrama
    CARGAS.assign(modelo="M2_AFE").to_csv(tmp_path / "nse_cargas_afc.csv", index=False)
    pd.DataFrame({"modelo": ["M2_AFE"], "correlacion_factores": [0.559]}).to_csv(tmp_path / "nse_ajuste_afc.csv",
                                                                               index=False)
    pd.DataFrame([{"competencia": r.competencia, "coeficiente": "eco" if r.factor == "ECO" else "libros",
                   "por_DE_de_la_EAP": r.valor} for r in RUTAS]).to_csv(tmp_path / "sem_coeficientes.csv", index=False)
    pd.concat([CARGAS_COMPETENCIA, pd.DataFrame({"competencia": ["total"], "items": [232], "carga_mediana": [0.5],
                                                 "carga_min": [-0.2], "carga_max": [0.97], "carga_menor_030": [56]})]
              ).to_csv(tmp_path / "mat_afc_resumen.csv", index=False)
    PHI.to_csv(tmp_path / "mat_afc_phi.csv", index=False)
    raiz = ET.fromstring(exportar_diagrama.exportar(tmp_path).read_text(encoding="utf-8"))
    assert "75 ítems · carga mediana 0,48" in "".join(raiz.itertext())


def test_medicion_de_una_competencia() -> None:
    items = pd.DataFrame({"item": ["CM1", "CM2", "CM3"], "tipo": ["2PL", "gpcm", "2PL"], "respuestas": [500, 700, 300],
                          "a": [1.2, 0.9, 0.1], "carga": [0.7, 0.5, -0.05]})
    raiz = ET.fromstring(svg_medicion(items, "formular"))
    textos = "".join(raiz.itertext())
    assert all(i in textos for i in items["item"])
    assert "3 ítems · 1 con carga < 0,30" in textos
    assert "−0,05" in textos
    assert len(raiz.findall(f".//{SVG_NS}line[@stroke-dasharray]")) == 1   # solo la carga baja va punteada


def test_resaltar_atenua_los_arcos_de_las_otras_competencias() -> None:
    svg = svg_modelo(CARGAS, {}, None, RUTAS, "puntos", resaltar="interpretar", phi=PHI)
    assert svg.count('<g opacity="0.25">') == 3                  # 6 arcos, 3 tocan interpretar
