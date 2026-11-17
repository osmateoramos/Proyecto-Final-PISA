"""Piezas de presentación que se repiten en las páginas: explicaciones, fuentes y tarjetas de hipótesis."""

import math
from decimal import ROUND_HALF_UP, Decimal

import pandas as pd
import streamlit as st

ETIQUETAS_DERIVADAS = {
    "HISEI_q": "Ocupación más alta de los padres (índice HISEI de PISA, en cuartiles; variable derivada)",
    "HISCED_c": "Educación más alta de los padres (ISCED de PISA, en categorías; variable derivada)",
}
"""Descripción de los indicadores derivados por PISA, que no tienen pregunta propia en el cuestionario (D-16)."""


def explicar(que: str, como: str, significa: str, decisiones: str) -> None:
    """Recuadro con tres pestañas: procedimiento, lectura e interpretación, más las decisiones que lo sostienen.

    Args:
        que: Procedimiento: qué se hizo y por qué.
        como: Lectura del gráfico o de la tabla.
        significa: Interpretación del resultado (las del equipo se marcan como tales).
        decisiones: Decisiones del registro (``Vault_PISA2022/03 Registro de decisiones.md``).
    """
    with st.expander("Notas metodológicas (procedimiento, lectura e interpretación)"):
        p1, p2, p3 = st.tabs(["Procedimiento", "Lectura de los resultados", "Interpretación"])
        p1.markdown(que)
        p2.markdown(como)
        p3.markdown(significa)
        st.caption(f"Decisiones del registro: {decisiones}")


def contexto(texto: str) -> None:
    """Línea inicial que sitúa la sección en el recorrido del proyecto (hilo de la presentación).

    Args:
        texto: Una frase: qué pregunta responde la sección.
    """
    st.markdown(f"##### {texto}")


def clave(texto: str) -> None:
    """Mensaje clave de la sección, en una frase, junto a las tablas y gráficos que lo sostienen.

    Args:
        texto: La conclusión de la sección, breve.
    """
    st.info(f"**Mensaje clave.** {texto}")


def tarjetas(items: list[tuple[str, str]], columnas: int | None = None) -> None:
    """Fila de tarjetas breves (título y una línea), al estilo de una diapositiva.

    Args:
        items: Pares (título, texto).
        columnas: Número de columnas; por defecto, una por tarjeta.
    """
    filas = st.columns(columnas or len(items))
    for i, (titulo, texto) in enumerate(items):
        with filas[i % len(filas)].container(border=True):
            st.markdown(f"**{titulo}**")
            st.caption(texto)


def siguiente(texto: str) -> None:
    """Cierre de la sección: anuncia la siguiente, para mantener la secuencia de la presentación.

    Args:
        texto: Qué aborda la siguiente sección, en una frase.
    """
    st.divider()
    st.markdown(f"**Siguiente sección.** {texto}")


def icono_decision(decision: str) -> str:
    """Icono de la decisión de una hipótesis: ✅ se acepta, ◐ en parte o exploratoria, ✖ se rechaza."""
    if "solo" in decision or "exploratoria" in decision:
        return "◐"
    return "✅" if decision.startswith(("se acepta", "se cumple")) else "✖"


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
    with st.container(border=True):
        st.markdown(f"**{codigo}** · {enunciado}")
        st.markdown(f"{icono_decision(decision)} **Decisión:** {decision}")


def numero(valor: float, decimales: int = 2) -> str:
    """Número con coma decimal y punto de miles, redondeado «mitad hacia arriba» como en el informe.

    El formato de Python redondea la representación binaria (24,15 se vuelve 24,1); con ``Decimal`` sobre el texto del
    número da 24,2, la misma cifra que imprime el informe en R.

    Args:
        valor: Número a mostrar.
        decimales: Decimales que se muestran.

    Returns:
        El número formateado, o «—» si no es finito.
    """
    if not math.isfinite(float(valor)):
        return "—"
    redondeado = Decimal(str(valor)).quantize(Decimal(1).scaleb(-decimales), rounding=ROUND_HALF_UP)
    texto = f"{redondeado:,.{decimales}f}"
    return texto.replace(",", "§").replace(".", ",").replace("§", ".")


def rango(valores: pd.Series, decimales: int = 1, union: str = " a ") -> str:
    """Mínimo y máximo de una serie como texto («24,2 a 29,4»); con ``union=" y "`` sirve para «entre X y Y».

    Args:
        valores: Serie numérica (los vacíos se ignoran).
        decimales: Decimales de los dos extremos.
        union: Texto entre el mínimo y el máximo.

    Returns:
        El rango con coma decimal, o un solo número si los dos extremos coinciden al redondear.
    """
    limpio = pd.to_numeric(valores, errors="coerce").dropna()
    minimo, maximo = numero(float(limpio.min()), decimales), numero(float(limpio.max()), decimales)
    return minimo if minimo == maximo else f"{minimo}{union}{maximo}"
