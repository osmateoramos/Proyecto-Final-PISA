"""Gráficos: colores fijos por serie, un solo eje y tooltip en las marcas."""

import json

import pandas as pd

from pisa_tablero import graficos


def especificacion(grafico: object) -> str:
    return json.dumps(grafico.to_dict())   # type: ignore[attr-defined]


def test_intervalos_color_fijo_por_factor() -> None:
    df = pd.DataFrame({"competencia": ["emplear", "emplear"], "serie": ["económico", "libros"],
                       "estimacion": [25.5, 7.3], "ic95_inf": [21.8, 3.7], "ic95_sup": [29.2, 11.0]})
    spec = especificacion(graficos.intervalos(df, eje_y="competencia", titulo_x="x"))
    assert graficos.AZUL in spec and graficos.NARANJA in spec
    assert '"tooltip"' in spec
    assert '"y2"' not in spec                                         # un solo eje vertical


def test_intervalos_con_una_sola_serie_conserva_su_color() -> None:
    df = pd.DataFrame({"contraste": ["Rural frente a Urbana"], "serie": ["libros"],
                       "estimacion": [-0.17], "ic95_inf": [-0.35], "ic95_sup": [0.0]})
    spec = especificacion(graficos.intervalos(df, eje_y="contraste", titulo_x="x"))
    assert graficos.NARANJA in spec and graficos.AZUL not in spec    # libros sigue siendo naranja sin el económico


def test_dif_resalta_solo_los_items_con_dif() -> None:
    df = pd.DataFrame({"item": ["A", "B", "C"], "competencia": ["emplear", "emplear", "razonar"],
                       "delta_mh": [1.2, -0.3, 0.5], "categoria_ets": ["B", "A", "A"], "p_bh": [0.01, 0.8, 0.5],
                       "dif": [True, False, False]})
    spec = especificacion(graficos.dif_por_item(df))
    assert graficos.AZUL in spec and graficos.GRIS in spec


def test_puntajes_esperados_no_parte_de_cero() -> None:
    df = pd.DataFrame({"competencia": ["emplear", "razonar"], "puntaje_esperado": [410.1, 405.5]})
    assert '"zero": false' in especificacion(graficos.puntajes_esperados(df))
