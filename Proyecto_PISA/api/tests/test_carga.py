"""Carga: la validación reúne todos los errores y no descarta filas en silencio."""

from pathlib import Path

import pytest
from sqlalchemy import create_engine

from app.carga import CargadorSalidas, ErrorCarga
from app.esquemas import FilaItemDIF, FilaItemNSE


def test_reporta_todas_las_filas_malas(tmp_path: Path) -> None:
    (tmp_path / "nse_estructura_afe.csv").write_text(
        "item,factor_D16,factor_AFE,carga_principal,coincide\n"
        "ST1,económico,económico,0.5,TRUE\n"
        "ST2,económico,otro,0.5,TRUE\n"          # factor no previsto
        "ST3,cultural,cultural,1.7,FALSE\n",     # carga imposible
        encoding="utf-8",
    )
    cargador = CargadorSalidas(tmp_path, create_engine("sqlite://"))
    with pytest.raises(ErrorCarga) as e:
        cargador.validar("nse_estructura_afe.csv", FilaItemNSE)
    assert "fila 3" in str(e.value) and "fila 4" in str(e.value)


def test_vacio_es_none_no_cero() -> None:
    fila = FilaItemNSE.model_validate(
        {"item": "ST1", "factor_D16": "económico", "factor_AFE": "económico", "carga_principal": "0.4", "coincide": "TRUE"}
    )
    assert fila.coincide is True
    dif =FilaItemDIF.model_validate({"item": "X", "competencia": "emplear", "tipo": "gpcm", "n_Q1": "120", "n_Q4": "130",
                                      "p": "0.5", "p_BH": "0.7", "delta_MH": "", "categoria_ETS": "", "dR2_Nagelkerke": "0.01",
                                      "DIF": "FALSE", "favorece": ""})
    assert dif.delta_mh is None and dif.categoria_ets is None


def test_falta_archivo(tmp_path: Path) -> None:
    with pytest.raises(ErrorCarga, match="Falta"):
        CargadorSalidas(tmp_path, create_engine("sqlite://")).leer_csv("no_existe.csv")
