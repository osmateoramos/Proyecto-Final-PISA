"""Diagrama del modelo estructural como SVG (función pura): medición del NSE con sus cargas y rutas a las competencias.

- Izquierda: los indicadores del NSE (código y carga estandarizada; el grosor de la flecha crece con la carga).
- Centro: los dos factores del modelo del AFE (D-24) y su correlación.
- Derecha: las 4 competencias; cada ruta lleva el coeficiente del factor sobre la competencia.

Al pasar el cursor sobre un elemento aparece su detalle (etiqueta ``<title>`` de SVG, nativa del navegador). El texto
usa ``currentColor``: toma el color del tema, así que se lee en modo claro y oscuro.
"""

from dataclasses import dataclass
from html import escape

import pandas as pd

from pisa_tablero.graficos import AZUL, NARANJA

COLOR_FACTOR = {"ECO": AZUL, "CUL": NARANJA}
NOMBRE_FACTOR = {"ECO": "NSE económico", "CUL": "NSE libros"}
COMPETENCIAS = ["emplear", "formular", "interpretar", "razonar"]

ANCHO = 960
FILA = 20                 # alto de cada indicador
X_IND, ANCHO_IND = 8, 190
X_FAC, RX, RY = 470, 82, 34
X_COMP, ANCHO_COMP, ALTO_COMP = 790, 160, 48


@dataclass(frozen=True)
class Ruta:
    """Una ruta factor → competencia con su valor y su texto de detalle."""

    factor: str
    competencia: str
    valor: float
    detalle: str


GRIS_CORRELACION = "#898781"
DESFASE_LLEGADA = {"ECO": -11, "CUL": 11}   # cada factor llega a la competencia por un punto distinto


def _flecha(id_: str, color: str) -> str:
    """Punta de flecha de tamaño fijo (``userSpaceOnUse``): no crece con el grosor de la línea."""
    return (f'<marker id="{id_}" viewBox="0 0 10 10" refX="9" refY="5" markerWidth="9" markerHeight="9" '
            f'markerUnits="userSpaceOnUse" orient="auto-start-reverse"><path d="M0,0 L10,5 L0,10 z" fill="{color}"/>'
            "</marker>")


def svg_modelo(cargas: pd.DataFrame, etiquetas: dict[str, str], correlacion: float | None, rutas: list[Ruta],
               unidad_rutas: str, resaltar: str | None = None) -> str:
    """Construye el SVG del modelo.

    Args:
        cargas: Columnas ``item``, ``factor`` (``ECO`` o ``CUL``) y ``carga_std``.
        etiquetas: Etiqueta oficial de cada indicador (para el detalle al pasar el cursor).
        correlacion: Correlación entre los dos factores (o ``None`` si no se conoce).
        rutas: Rutas factor → competencia.
        unidad_rutas: Unidad de los coeficientes de las rutas (para el detalle).
        resaltar: Competencia que se resalta; las rutas de las demás se atenúan. ``None`` = todas por igual.

    Returns:
        El SVG como texto.
    """
    cargas = cargas.assign(orden=cargas["factor"].map({"ECO": 0, "CUL": 1})).sort_values(
        ["orden", "carga_std"], ascending=[True, False])
    n = len(cargas)
    alto = max(n * FILA + 60, 4 * (ALTO_COMP + 30) + 60)
    y_ind = {item: 40 + i * FILA for i, item in enumerate(cargas["item"])}
    y_fac = {f: sum(y_ind[i] for i in grupo["item"]) / len(grupo) for f, grupo in cargas.groupby("factor")}
    paso_comp = (alto - 60) / 4
    y_comp = {c: 30 + paso_comp * (k + 0.5) for k, c in enumerate(COMPETENCIAS)}

    partes = [f'<svg viewBox="0 0 {ANCHO} {alto}" width="100%" role="img" xmlns="http://www.w3.org/2000/svg" '
              f'font-family="system-ui, -apple-system, Segoe UI, sans-serif" font-size="11" fill="currentColor">',
              "<title>Modelo estructural: NSE de 2 dimensiones → 4 competencias</title><defs>",
              *(_flecha(f"flecha-{f}", c) for f, c in COLOR_FACTOR.items()),
              _flecha("flecha-r", GRIS_CORRELACION), "</defs>"]

    # --- Medición: factor → indicador (grosor según la carga)
    for fila in cargas.itertuples():
        y, color = y_ind[fila.item], COLOR_FACTOR[fila.factor]
        etiqueta = escape(etiquetas.get(fila.item, ""))
        detalle = escape(f"{fila.item}: ") + etiqueta + escape(f"\nCarga estandarizada en {NOMBRE_FACTOR[fila.factor]}: "
                                                              f"{fila.carga_std:.2f}")
        partes.append(
            f'<g><title>{detalle}</title>'
            f'<line x1="{X_FAC - RX}" y1="{y_fac[fila.factor]:.1f}" x2="{X_IND + ANCHO_IND + 2}" y2="{y}" stroke="{color}" '
            f'stroke-width="{0.6 + 3.2 * abs(fila.carga_std):.2f}" stroke-opacity="0.55" marker-end="url(#flecha-{fila.factor})"/>'
            f'<rect x="{X_IND}" y="{y - FILA / 2 + 2}" width="{ANCHO_IND}" height="{FILA - 4}" rx="3" fill="none" '
            f'stroke="currentColor" stroke-opacity="0.25"/>'
            f'<text x="{X_IND + 6}" y="{y + 4}">{escape(fila.item)}</text>'
            f'<text x="{X_IND + ANCHO_IND - 6}" y="{y + 4}" text-anchor="end" font-variant-numeric="tabular-nums">'
            f'{fila.carga_std:.2f}</text></g>')

    # --- Correlación entre factores
    if correlacion is not None and {"ECO", "CUL"} <= set(y_fac):
        # Línea vertical de doble punta entre los dos factores: no cruza ninguna ruta (las rutas salen por la derecha)
        medio = (y_fac["ECO"] + y_fac["CUL"]) / 2
        partes.append(
            f'<g><title>Correlación entre los factores: {correlacion:.3f}</title>'
            f'<line x1="{X_FAC}" y1="{y_fac["ECO"] + RY + 3:.1f}" x2="{X_FAC}" y2="{y_fac["CUL"] - RY - 3:.1f}" '
            f'stroke="{GRIS_CORRELACION}" stroke-width="1.5" marker-start="url(#flecha-r)" marker-end="url(#flecha-r)"/>'
            f'<text x="{X_FAC + 8}" y="{medio + 4:.1f}">r = {correlacion:.2f}</text></g>')

    # --- Estructura: factor → competencia
    for ruta in rutas:
        if ruta.factor not in y_fac:
            continue
        activa = resaltar is None or ruta.competencia == resaltar
        x1, y1 = X_FAC + RX, y_fac[ruta.factor]
        x2, y2 = X_COMP - 4, y_comp[ruta.competencia] + DESFASE_LLEGADA[ruta.factor]
        partes.append(
            f'<g opacity="{1 if activa else 0.15}"><title>{escape(ruta.detalle)}</title>'
            f'<line x1="{x1}" y1="{y1:.1f}" x2="{x2}" y2="{y2:.1f}" stroke="{COLOR_FACTOR[ruta.factor]}" '
            f'stroke-width="{1 + abs(ruta.valor) / 6:.2f}" marker-end="url(#flecha-{ruta.factor})"/></g>')
    # Los valores van dentro del recuadro de cada competencia (no sobre las líneas, que se cruzan)
    valores = {(r.competencia, r.factor): r.valor for r in rutas}

    # --- Nodos: factores y competencias
    for f, y in y_fac.items():
        partes.append(
            f'<g><title>{NOMBRE_FACTOR[f]} (factor latente)</title>'
            f'<ellipse cx="{X_FAC}" cy="{y:.1f}" rx="{RX}" ry="{RY}" fill="{COLOR_FACTOR[f]}" fill-opacity="0.12" '
            f'stroke="{COLOR_FACTOR[f]}" stroke-width="2"/>'
            f'<text x="{X_FAC}" y="{y + 4:.1f}" text-anchor="middle" font-size="13" font-weight="600">'
            f'{NOMBRE_FACTOR[f]}</text></g>')
    for c, y in y_comp.items():
        opacidad = 1 if resaltar is None or c == resaltar else 0.45
        partes.append(
            f'<g opacity="{opacidad}"><title>Competencia: {c} (10 valores plausibles de la OCDE)</title>'
            f'<rect x="{X_COMP}" y="{y - ALTO_COMP / 2:.1f}" width="{ANCHO_COMP}" height="{ALTO_COMP}" rx="6" '
            f'fill="none" stroke="currentColor" stroke-width="1.5"/>'
            f'<text x="{X_COMP + ANCHO_COMP / 2}" y="{y - 4:.1f}" text-anchor="middle" font-size="13" '
            f'font-weight="600">{c.capitalize()}</text>'
            f'<text x="{X_COMP + ANCHO_COMP / 2}" y="{y + 14:.1f}" text-anchor="middle" font-size="12" '
            f'font-weight="600">'
            + " · ".join(f'<tspan fill="{COLOR_FACTOR[f]}">{valores[(c, f)]:.1f}</tspan>'
                         for f in ("ECO", "CUL") if (c, f) in valores)
            + "</text></g>")

    partes.append(f'<text x="{X_IND}" y="18" font-weight="600">Indicadores del NSE (carga estandarizada)</text>'
                  f'<text x="{X_COMP}" y="18" font-weight="600">Competencias</text>'
                  f'<text x="{ANCHO - 8}" y="{alto - 8}" text-anchor="end" opacity="0.7">Rutas: {escape(unidad_rutas)}</text>'
                  "</svg>")
    return "".join(partes)
