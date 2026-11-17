"""Formato de las cifras que se muestran en los textos (sin red)."""

import pandas as pd

from pisa_tablero.componentes import numero, rango


def test_numero_usa_coma_decimal_y_punto_de_miles() -> None:
    assert numero(6886, 0) == "6.886"
    assert numero(1220.5, 1) == "1.220,5"


def test_numero_redondea_mitad_hacia_arriba_como_el_informe() -> None:
    assert numero(24.15, 1) == "24,2"                                     # el formato de Python daría 24,1
    assert numero(0.0075, 3) == "0,008"


def test_numero_no_finito() -> None:
    assert numero(float("nan")) == "—"


def test_rango_con_a_y_con_y() -> None:
    serie = pd.Series([29.43, 24.15, None, 25.0])
    assert rango(serie) == "24,2 a 29,4"
    assert rango(serie, union=" y ") == "24,2 y 29,4"


def test_rango_con_extremos_iguales_da_un_solo_numero() -> None:
    assert rango(pd.Series([0.0073, 0.0074]), 2) == "0,01"
