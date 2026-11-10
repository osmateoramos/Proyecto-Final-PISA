"""Gráficos del tablero (Altair), como funciones puras: reciben un DataFrame y devuelven el gráfico.

Colores: slots 1 y 2 de la paleta categórica de referencia (azul y naranja), en orden fijo y siempre ligados a la
misma serie (el NSE económico es azul en todo el tablero; libros, naranja). El gris solo marca lo que no se resalta.
Cada gráfico lleva tooltip por marca, y la página muestra su tabla al lado: el color nunca es el único canal.
"""

import altair as alt
import pandas as pd

AZUL = "#2a78d6"        # slot 1
NARANJA = "#eb6834"     # slot 2
GRIS = "#898781"        # tinta atenuada: lo no resaltado
REGLA = "#c3c2b7"       # línea de referencia (eje/base)

SERIES_NSE = {"económico": AZUL, "libros": NARANJA}
"""Color fijo de cada factor del NSE (D-24)."""

TAMANO_PUNTO = 90       # ≈ 10 px de diámetro
ANCHO_LINEA = 2


def intervalos(df: pd.DataFrame, *, eje_y: str, titulo_x: str, orden_y: list[str] | None = None,
               referencia_cero: bool = True) -> alt.LayerChart:
    """Estimación con su IC 95 % para una o dos series (punto + segmento), una fila por categoría.

    Args:
        df: Columnas ``eje_y``, ``serie``, ``estimacion``, ``ic95_inf`` e ``ic95_sup``.
        eje_y: Columna de las categorías del eje vertical.
        titulo_x: Título del eje horizontal (con unidades).
        orden_y: Orden de las categorías (por defecto, el de aparición).
        referencia_cero: Si se dibuja la línea vertical en 0.

    Returns:
        El gráfico de capas (segmentos, puntos y, si aplica, la línea en 0).
    """
    series = [s for s in SERIES_NSE if s in set(df["serie"])]
    color = alt.Color("serie:N", title="Factor del NSE",
                      scale=alt.Scale(domain=series, range=[SERIES_NSE[s] for s in series]))
    y = alt.Y(f"{eje_y}:N", title=None, sort=orden_y or list(dict.fromkeys(df[eje_y])))
    desplazamiento = alt.YOffset("serie:N", sort=series)
    tooltip = [alt.Tooltip(f"{eje_y}:N", title="Categoría"), alt.Tooltip("serie:N", title="Factor"),
               alt.Tooltip("estimacion:Q", title="Estimación", format=".2f"),
               alt.Tooltip("ic95_inf:Q", title="IC 95 % inf.", format=".2f"),
               alt.Tooltip("ic95_sup:Q", title="IC 95 % sup.", format=".2f")]
    base = alt.Chart(df).encode(y=y, yOffset=desplazamiento, color=color)
    segmentos = base.mark_rule(strokeWidth=ANCHO_LINEA).encode(
        x=alt.X("ic95_inf:Q", title=titulo_x), x2="ic95_sup:Q", tooltip=tooltip)
    puntos = base.mark_point(filled=True, size=TAMANO_PUNTO, opacity=1).encode(x="estimacion:Q", tooltip=tooltip)
    capas = [segmentos, puntos]
    if referencia_cero:
        capas.insert(0, alt.Chart(pd.DataFrame({"x": [0]})).mark_rule(color=REGLA, strokeWidth=1).encode(x="x:Q"))
    return alt.layer(*capas).properties(height=alt.Step(28))


def dif_por_item(df: pd.DataFrame) -> alt.LayerChart:
    """ΔMH de los ítems dicotómicos por competencia; los ítems con DIF se resaltan en azul y se rotulan.

    Las líneas verticales marcan los cortes del ETS (|ΔMH| = 1 y 1,5; D-22): de ahí hacia afuera el efecto es B o C.

    Args:
        df: Columnas ``item``, ``competencia``, ``delta_mh`` (sin nulos), ``categoria_ets``, ``p_bh`` y ``dif``.

    Returns:
        El gráfico de capas.
    """
    df = df.sort_values(["competencia", "item"]).assign(estado=df["dif"].map({True: "con DIF", False: "sin DIF"}))
    # Fila 0 de cada competencia: solo los ítems con DIF (su rótulo no tapa otros puntos); filas 1-4: el resto,
    # repartido de forma fija para que no se muevan entre recargas.
    df["dispersion"] = 0
    sin_dif = ~df["dif"]
    df.loc[sin_dif, "dispersion"] = 1 + df[sin_dif].groupby("competencia").cumcount() % 4
    tooltip = [alt.Tooltip("item:N", title="Ítem"), alt.Tooltip("competencia:N", title="Competencia"),
               alt.Tooltip("delta_mh:Q", title="ΔMH", format=".2f"), alt.Tooltip("categoria_ets:N", title="ETS"),
               alt.Tooltip("p_bh:Q", title="p (BH)", format=".3f"), alt.Tooltip("estado:N", title="Resultado")]
    color = alt.Color("estado:N", title=None, scale=alt.Scale(domain=["con DIF", "sin DIF"], range=[AZUL, GRIS]))
    y = alt.Y("competencia:N", title=None, sort=["emplear", "formular", "interpretar", "razonar"])
    cortes = pd.DataFrame({"x": [-1.5, -1.0, 1.0, 1.5]})
    reglas = alt.Chart(cortes).mark_rule(color=REGLA, strokeWidth=1).encode(x="x:Q")
    # Sin cuadrícula vertical: así las únicas líneas verticales son los cortes del ETS
    x = alt.X("delta_mh:Q", title="ΔMH (negativo favorece al cuartil alto del NSE)", axis=alt.Axis(grid=False))
    desplazamiento = alt.YOffset("dispersion:O", scale=alt.Scale(domain=[0, 1, 2, 3, 4]))
    puntos = alt.Chart(df).mark_point(filled=True, size=TAMANO_PUNTO, opacity=0.85).encode(
        x=x, y=y, yOffset=desplazamiento, color=color, tooltip=tooltip, order=alt.Order("dif:N"))
    rotulos = alt.Chart(df[df["dif"]]).mark_text(align="center", baseline="bottom", dy=-8, fontSize=11).encode(
        x=x, y=y, yOffset=desplazamiento, text="item:N")
    return alt.layer(reglas, puntos, rotulos).properties(height=360)


def puntajes_esperados(df: pd.DataFrame) -> alt.LayerChart:
    """Puntaje esperado por competencia (un punto por competencia, con su valor rotulado).

    Es un gráfico de puntos y no de barras: el eje no empieza en 0 y las barras exagerarían las diferencias.

    Args:
        df: Columnas ``competencia`` y ``puntaje_esperado``.

    Returns:
        El gráfico de capas (puntos y rótulos).
    """
    y = alt.Y("competencia:N", title=None, sort=["emplear", "formular", "interpretar", "razonar"])
    x = alt.X("puntaje_esperado:Q", title="Puntaje esperado (puntos PISA)", scale=alt.Scale(zero=False, padding=30))
    tooltip = [alt.Tooltip("competencia:N", title="Competencia"),
               alt.Tooltip("puntaje_esperado:Q", title="Puntaje esperado", format=".1f")]
    puntos = alt.Chart(df).mark_point(filled=True, size=TAMANO_PUNTO * 1.5, color=AZUL, opacity=1).encode(
        x=x, y=y, tooltip=tooltip)
    rotulos = alt.Chart(df).mark_text(align="left", dx=12, fontSize=12).encode(
        x=x, y=y, text=alt.Text("puntaje_esperado:Q", format=".1f"))   # color del texto: el del tema
    return alt.layer(puntos, rotulos).properties(height=alt.Step(40))
