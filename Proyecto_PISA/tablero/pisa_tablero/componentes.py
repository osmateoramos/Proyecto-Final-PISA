"""Piezas de presentación que se repiten en las páginas: explicaciones, fuentes y tarjetas de hipótesis."""

import pandas as pd
import streamlit as st

ETIQUETAS_DERIVADAS = {
    "HISEI_q": "Ocupación más alta de los padres (índice HISEI de PISA, en cuartiles; variable derivada)",
    "HISCED_c": "Educación más alta de los padres (ISCED de PISA, en categorías; variable derivada)",
}
"""Descripción de los indicadores derivados por PISA, que no tienen pregunta propia en el cuestionario (D-16)."""


def explicar(que: str, como: str, significa: str, decisiones: str) -> None:
    """Recuadro con tres pestañas: qué se hizo, cómo se lee y qué significa, más las decisiones que lo sostienen.

    Args:
        que: Qué se hizo y por qué.
        como: Cómo leer el gráfico o la tabla.
        significa: Qué significa el resultado (las interpretaciones del equipo se marcan como tales).
        decisiones: Decisiones del registro (``Vault_PISA2022/03 Registro de decisiones.md``).
    """
    with st.container(border=True):
        p1, p2, p3 = st.tabs(["¿Qué se hizo?", "¿Cómo se lee?", "¿Qué significa?"])
        p1.markdown(que)
        p2.markdown(como)
        p3.markdown(significa)
        st.caption(f"Decisiones del registro: {decisiones}")


def fuente(archivos: str, script: str | None = None) -> None:
    """Pie con el archivo de ``salidas/`` (y el script de R) del que salen las cifras."""
    st.caption(f"Fuente: `salidas/{archivos}`" + (f" ({script})." if script else "."))


def tarjeta_hipotesis(codigo: str, enunciado: str, hipotesis: pd.DataFrame) -> None:
    """Tarjeta con el enunciado de una hipótesis y su decisión (leída de la API).

    Args:
        codigo: Código de la hipótesis (H1 a H8).
        enunciado: Enunciado resumido (Vault_PISA2022/09 Hipótesis preregistradas.md).
        hipotesis: Tabla de ``datos.hipotesis()``.
    """
    decision = hipotesis.set_index("codigo").loc[codigo, "decision"]
    icono = "✅" if decision.startswith(("se acepta", "se cumple")) and "solo" not in decision else (
        "◐" if "solo" in decision or "exploratoria" in decision else "✖")
    with st.container(border=True):
        st.markdown(f"**{codigo}** · {enunciado}")
        st.markdown(f"{icono} **Decisión:** {decision}")


def numero(valor: float, decimales: int = 2) -> str:
    """Número con coma decimal y punto de miles, como en el resto del proyecto."""
    texto = f"{valor:,.{decimales}f}"
    return texto.replace(",", "§").replace(".", ",").replace("§", ".")
