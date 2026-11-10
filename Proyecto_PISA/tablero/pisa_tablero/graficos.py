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


RAMPA_AZUL = ["#cde2fb", "#9ec5f4", "#6da7ec", "#3987e5", "#256abf", "#184f95", "#0d366b"]
"""Rampa secuencial de un solo tono (azul) de la paleta de referencia, para magnitudes."""


def cargas_nse(df: pd.DataFrame, etiquetas: dict[str, str]) -> alt.Chart:
    """Carga estandarizada de cada indicador en su factor (un punto por indicador; color = factor).

    Args:
        df: Columnas ``item``, ``factor`` (``ECO`` o ``CUL``) y ``carga_std``.
        etiquetas: Etiqueta oficial de cada indicador (va en el tooltip).

    Returns:
        El gráfico.
    """
    df = df.assign(serie=df["factor"].map({"ECO": "económico", "CUL": "libros"}),
                   etiqueta=df["item"].map(etiquetas).fillna(""))
    orden = df.sort_values(["serie", "carga_std"], ascending=[True, False])["item"].tolist()
    series = [s for s in SERIES_NSE if s in set(df["serie"])]
    return alt.Chart(df).mark_point(filled=True, size=TAMANO_PUNTO, opacity=1).encode(
        x=alt.X("carga_std:Q", title="Carga estandarizada", scale=alt.Scale(domain=[0, 1])),
        y=alt.Y("item:N", title=None, sort=orden),
        color=alt.Color("serie:N", title="Factor del NSE",
                        scale=alt.Scale(domain=series, range=[SERIES_NSE[s] for s in series])),
        tooltip=[alt.Tooltip("item:N", title="Indicador"), alt.Tooltip("etiqueta:N", title="Pregunta"),
                 alt.Tooltip("serie:N", title="Factor"), alt.Tooltip("carga_std:Q", title="Carga", format=".2f")],
    ).properties(height=alt.Step(16))


def intervalo_simple(df: pd.DataFrame, *, eje_y: str, titulo_x: str, referencias: dict[str, float] | None = None,
                     orden_y: list[str] | None = None) -> alt.LayerChart:
    """Estimación con su IC 95 % para una sola serie, con líneas de referencia rotuladas (por ejemplo 0 y un umbral).

    Args:
        df: Columnas ``eje_y``, ``estimacion``, ``ic95_inf`` e ``ic95_sup``.
        eje_y: Columna de las categorías.
        titulo_x: Título del eje horizontal, con unidades.
        referencias: Nombre y posición de cada línea de referencia.
        orden_y: Orden de las categorías.

    Returns:
        El gráfico de capas.
    """
    y = alt.Y(f"{eje_y}:N", title=None, sort=orden_y or list(dict.fromkeys(df[eje_y])))
    tooltip = [alt.Tooltip(f"{eje_y}:N", title="Categoría"),
               alt.Tooltip("estimacion:Q", title="Estimación", format=".3f"),
               alt.Tooltip("ic95_inf:Q", title="IC 95 % inf.", format=".3f"),
               alt.Tooltip("ic95_sup:Q", title="IC 95 % sup.", format=".3f")]
    base = alt.Chart(df).encode(y=y)
    # El dominio incluye las referencias con margen a la derecha, para que su línea y su rótulo no queden en el borde
    valores = [*df["ic95_inf"], *df["ic95_sup"], *(referencias or {}).values()]
    bajo, alto = min(valores), max(valores)
    rango = (alto - bajo) or 1.0
    escala = alt.Scale(domain=[bajo - 0.05 * rango, alto + 0.3 * rango], nice=False)
    capas: list[alt.Chart] = []
    if referencias:
        ref = pd.DataFrame({"nombre": list(referencias), "x": list(referencias.values())})
        capas += [alt.Chart(ref).mark_rule(color=REGLA, strokeWidth=1).encode(x=alt.X("x:Q", scale=escala)),
                  alt.Chart(ref).mark_text(align="left", dx=4, dy=-6, fontSize=10, opacity=0.8).encode(
                      x=alt.X("x:Q", scale=escala), y=alt.value(0), text="nombre:N")]
    capas += [base.mark_rule(strokeWidth=ANCHO_LINEA, color=AZUL).encode(
                  x=alt.X("ic95_inf:Q", title=titulo_x, scale=escala), x2="ic95_sup:Q", tooltip=tooltip),
              base.mark_point(filled=True, size=TAMANO_PUNTO, color=AZUL, opacity=1).encode(
                  x="estimacion:Q", tooltip=tooltip)]
    return alt.layer(*capas).properties(height=alt.Step(34))


def mapa_correlaciones(df: pd.DataFrame, *, fila: str, columna: str, valor: str, titulo_fila: str,
                       titulo_columna: str) -> alt.LayerChart:
    """Mapa de calor de una matriz de correlaciones con el valor escrito en cada celda (rampa de un solo tono).

    Args:
        df: Formato largo: una fila por celda.
        fila, columna, valor: Columnas de la fila, la columna y el valor.
        titulo_fila, titulo_columna: Títulos de los ejes.

    Returns:
        El gráfico de capas (celdas y valores).
    """
    orden = ["emplear", "formular", "interpretar", "razonar"]
    minimo, maximo = float(df[valor].min()), float(df[valor].max())
    corte = minimo + 0.55 * (maximo - minimo)
    base = alt.Chart(df).encode(x=alt.X(f"{columna}:N", title=titulo_columna, sort=orden, axis=alt.Axis(labelAngle=0)),
                                y=alt.Y(f"{fila}:N", title=titulo_fila, sort=orden))
    celdas = base.mark_rect(stroke="white", strokeWidth=2).encode(
        color=alt.Color(f"{valor}:Q", title="r", scale=alt.Scale(range=RAMPA_AZUL[1:], domain=[minimo, maximo])),
        tooltip=[alt.Tooltip(f"{fila}:N", title=titulo_fila), alt.Tooltip(f"{columna}:N", title=titulo_columna),
                 alt.Tooltip(f"{valor}:Q", title="r", format=".3f")])
    textos = base.mark_text(fontSize=12).encode(
        text=alt.Text(f"{valor}:Q", format=".2f"),
        color=alt.condition(alt.datum[valor] >= corte, alt.value("white"), alt.value("#0b0b0b")))
    return alt.layer(celdas, textos).properties(height=alt.Step(44), width=alt.Step(110))


def comparacion_enfoques(df: pd.DataFrame) -> alt.LayerChart:
    """Coeficiente con NSE latente frente al de dos pasos, unidos por una línea (uno por competencia y factor).

    Args:
        df: Columnas ``competencia``, ``serie`` (``económico`` o ``libros``), ``latente`` y ``dos_pasos``.

    Returns:
        El gráfico de capas.
    """
    largo = df.melt(id_vars=["competencia", "serie"], value_vars=["latente", "dos_pasos"], var_name="enfoque",
                    value_name="valor").replace({"enfoque": {"latente": "NSE latente (SEM)", "dos_pasos": "Dos pasos"}})
    series = [s for s in SERIES_NSE if s in set(df["serie"])]
    color = alt.Color("serie:N", title="Factor del NSE",
                      scale=alt.Scale(domain=series, range=[SERIES_NSE[s] for s in series]))
    y = alt.Y("competencia:N", title=None, sort=["emplear", "formular", "interpretar", "razonar"])
    tooltip = [alt.Tooltip("competencia:N", title="Competencia"), alt.Tooltip("serie:N", title="Factor"),
               alt.Tooltip("enfoque:N", title="Enfoque"), alt.Tooltip("valor:Q", title="Puntos por DE", format=".2f")]
    lineas = alt.Chart(df).mark_rule(strokeWidth=ANCHO_LINEA, opacity=0.6).encode(
        x=alt.X("latente:Q", title="Puntos PISA por DE del NSE"), x2="dos_pasos:Q", y=y,
        yOffset=alt.YOffset("serie:N", sort=series), color=color)
    # Dos pasos: círculo relleno. NSE latente: rombo hueco (la forma, no solo el color, distingue el enfoque).
    dos_pasos = alt.Chart(largo[largo["enfoque"] == "Dos pasos"]).mark_point(
        filled=True, shape="circle", size=TAMANO_PUNTO, opacity=1).encode(
        x="valor:Q", y=y, yOffset=alt.YOffset("serie:N", sort=series), color=color, tooltip=tooltip)
    latente = alt.Chart(largo[largo["enfoque"] != "Dos pasos"]).mark_point(
        filled=False, shape="diamond", size=TAMANO_PUNTO * 1.3, strokeWidth=2, opacity=1).encode(
        x="valor:Q", y=y, yOffset=alt.YOffset("serie:N", sort=series), color=color, tooltip=tooltip)
    return alt.layer(lineas, dos_pasos, latente).properties(height=alt.Step(30))
