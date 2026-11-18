"""Diagrama del modelo estructural como SVG (función pura): medición del NSE y de las competencias, y rutas entre ellos.

- Izquierda: los indicadores del NSE (código y carga estandarizada; el grosor de la flecha crece con la carga).
- Centro: los dos factores del modelo del AFE (D-24) y su correlación.
- Derecha: las 4 competencias como variables latentes (óvalos), con el coeficiente de cada ruta adentro. Debajo de
  cada una va el resumen de las cargas de sus ítems en el modelo de 4 competencias de la F5 (D-48), y a la derecha, los
  arcos con las correlaciones Φ entre competencias (D-51).

Al pasar el cursor sobre un elemento aparece su detalle (etiqueta ``<title>`` de SVG, nativa del navegador). El texto
usa ``currentColor``: toma el color del tema, así que se lee en modo claro y oscuro.
"""

from dataclasses import dataclass
from html import escape
from itertools import combinations
from math import sqrt

import pandas as pd

from pisa_tablero.graficos import AZUL, NARANJA

COLOR_FACTOR = {"ECO": AZUL, "CUL": NARANJA}
NOMBRE_FACTOR = {"ECO": "NSE económico", "CUL": "NSE libros"}
COMPETENCIAS = ["emplear", "formular", "interpretar", "razonar"]

ANCHO = 1050
FILA = 20                                   # alto de cada indicador
X_IND, ANCHO_IND = 8, 190
X_FAC, RX, RY = 470, 82, 34
X_COMP, RX_COMP, RY_COMP = 800, 78, 28      # centro y semiejes del óvalo de cada competencia
SEPARACION_CAJA, ANCHO_CAJA, ALTO_CAJA = 16, 196, 42
BAJO_OVALO = RY_COMP + SEPARACION_CAJA + ALTO_CAJA          # cuánto baja el grupo óvalo + caja desde el centro del óvalo
ALTO_MINIMO = 4 * (RY_COMP + BAJO_OVALO + 40) + 60

# Arcos de Φ: cuánto se abren hacia la derecha según cuántas competencias saltan (1, 2 o 3) y dónde salen del óvalo.
# Están calculados para que no pasen por encima de las cajas ni de las etiquetas de los otros arcos.
APERTURA_ARCO = {1: 50, 2: 132, 3: 180}
SALIDA_ARCO = {1: 5, 2: 11, 3: 17}


@dataclass(frozen=True)
class Ruta:
    """Una ruta factor → competencia con su valor y su texto de detalle."""

    factor: str
    competencia: str
    valor: float
    detalle: str


GRIS_CORRELACION = "#898781"
DESFASE_LLEGADA = {"ECO": -11, "CUL": 11}   # cada factor llega a la competencia por un punto distinto


def _num(valor: float, decimales: int = 2) -> str:
    """Número con coma decimal y signo menos tipográfico, como en el resto del proyecto."""
    texto = f"{abs(valor):.{decimales}f}".replace(".", ",")
    return f"−{texto}" if round(valor, decimales) < 0 else texto


def _flecha(id_: str, color: str) -> str:
    """Punta de flecha de tamaño fijo (``userSpaceOnUse``): no crece con el grosor de la línea."""
    return (f'<marker id="{id_}" viewBox="0 0 10 10" refX="9" refY="5" markerWidth="9" markerHeight="9" '
            f'markerUnits="userSpaceOnUse" orient="auto-start-reverse"><path d="M0,0 L10,5 L0,10 z" fill="{color}"/>'
            "</marker>")


def _borde_ovalo(dy: float, derecha: bool) -> float:
    """Coordenada x del borde del óvalo de una competencia a ``dy`` píxeles de su centro."""
    dx = RX_COMP * sqrt(max(0.0, 1 - (dy / RY_COMP) ** 2))
    return X_COMP + dx if derecha else X_COMP - dx


def _caja_cargas(competencia: str, fila: pd.Series, y: float) -> str:
    """Caja con el resumen de las cargas de los ítems de una competencia, debajo de su óvalo."""
    arriba = y + RY_COMP + SEPARACION_CAJA
    detalle = (f"{competencia.capitalize()}: {int(fila['items'])} ítems en el modelo de 4 competencias (F5).\n"
               f"Carga estandarizada mediana {_num(fila['carga_mediana'])}, mínima {_num(fila['carga_min'])} y máxima "
               f"{_num(fila['carga_max'])}.\n{int(fila['carga_menor_030'])} ítems con carga < 0,30 (criterio de D-29).\n"
               "Carga de cada ítem: mat_afc_cargas.csv (D-48).")
    return (f'<g><title>{escape(detalle)}</title>'
            f'<line x1="{X_COMP}" y1="{y + RY_COMP:.1f}" x2="{X_COMP}" y2="{arriba - 1:.1f}" stroke="{GRIS_CORRELACION}" '
            f'stroke-width="1.5" marker-end="url(#flecha-r)"/>'
            f'<rect x="{X_COMP - ANCHO_CAJA / 2}" y="{arriba:.1f}" width="{ANCHO_CAJA}" height="{ALTO_CAJA}" rx="3" '
            f'fill="none" stroke="currentColor" stroke-opacity="0.35"/>'
            f'<text x="{X_COMP}" y="{arriba + 17:.1f}" text-anchor="middle" font-size="10.5">'
            f'{int(fila["items"])} ítems · carga mediana {_num(fila["carga_mediana"])}</text>'
            f'<text x="{X_COMP}" y="{arriba + 33:.1f}" text-anchor="middle" font-size="10.5" opacity="0.8">'
            f'{_num(fila["carga_min"])} a {_num(fila["carga_max"])} · {int(fila["carga_menor_030"])} con carga '
            f'&lt; 0,30</text></g>')


def _arcos_phi(phi: pd.DataFrame, y_comp: dict[str, float], resaltar: str | None) -> list[str]:
    """Arcos de doble punta con las correlaciones Φ entre las competencias, a la derecha de los óvalos."""
    matriz = phi.set_index("competencia")
    partes = []
    for a, b in combinations(COMPETENCIAS, 2):
        if a not in matriz.index or b not in matriz.columns:
            continue
        salto = COMPETENCIAS.index(b) - COMPETENCIAS.index(a)
        valor = float(matriz.loc[a, b])
        sale = SALIDA_ARCO[salto]
        y1, y2 = y_comp[a] + sale, y_comp[b] - sale
        x1, x2 = _borde_ovalo(sale, derecha=True), _borde_ovalo(-sale, derecha=True)
        abre = APERTURA_ARCO[salto]
        cima_x, cima_y = x1 + 0.75 * abre, (y1 + y2) / 2       # punto más a la derecha de la curva
        # Las etiquetas de los arcos de salto 2 van por dentro de la curva; las demás, por fuera
        if salto == 2:
            etiqueta = f'<text x="{cima_x - 4:.1f}" y="{cima_y + 4:.1f}" text-anchor="end">{_num(valor, 3)}</text>'
        else:
            etiqueta = f'<text x="{cima_x + 4:.1f}" y="{cima_y + 4:.1f}">{_num(valor, 3)}</text>'
        activo = resaltar is None or resaltar in (a, b)
        detalle = (f"Φ {a}–{b} = {_num(valor, 3)}: correlación entre las dos competencias latentes en el modelo de 4 "
                   "competencias (F5), sin controlar por el NSE. No es una correlación entre residuos.")
        partes.append(
            f'<g opacity="{1 if activo else 0.25}"><title>{escape(detalle)}</title>'
            f'<path d="M{x1:.1f},{y1:.1f} C{x1 + abre:.1f},{y1:.1f} {x2 + abre:.1f},{y2:.1f} {x2:.1f},{y2:.1f}" '
            f'fill="none" stroke="{GRIS_CORRELACION}" stroke-width="1.2" marker-start="url(#flecha-r)" '
            f'marker-end="url(#flecha-r)"/>{etiqueta}</g>')
    return partes


FILA_ITEM, ANCHO_MEDICION, UMBRAL_CARGA = 16, 760, 0.30


def svg_medicion(items: pd.DataFrame, competencia: str) -> str:
    """Modelo de medición de una competencia: el óvalo de la competencia y todos sus ítems con su carga (D-51).

    Args:
        items: Ítems de la competencia, con columnas ``item``, ``tipo``, ``respuestas``, ``a`` y ``carga``
            (``mat_afc_cargas.csv``).
        competencia: Nombre de la competencia.

    Returns:
        El SVG como texto. Las cargas < 0,30 (criterio de D-29) van en línea punteada gris.
    """
    items = items.sort_values("carga", ascending=False)
    n = len(items)
    alto = max(n * FILA_ITEM + 70, 160)
    x_caja, ancho_caja = 470, 210
    cx, cy = 150, 30 + n * FILA_ITEM / 2
    partes = [f'<svg viewBox="0 0 {ANCHO_MEDICION} {alto}" width="100%" role="img" '
              'xmlns="http://www.w3.org/2000/svg" font-family="system-ui, -apple-system, Segoe UI, sans-serif" '
              f'font-size="10.5" fill="currentColor"><title>Modelo de medición: {escape(competencia)}</title><defs>'
              f'{_flecha("flecha-m", "currentColor")}{_flecha("flecha-baja", GRIS_CORRELACION)}</defs>']
    for k, fila in enumerate(items.itertuples()):
        y = 36 + k * FILA_ITEM
        baja = fila.carga < UMBRAL_CARGA
        detalle = (f"{fila.item} ({fila.tipo}): carga estandarizada {_num(fila.carga)}; discriminación a = "
                   f"{_num(fila.a)}; {int(fila.respuestas)} respuestas en Colombia"
                   + (". Carga < 0,30: el ítem informa poco sobre la competencia (D-29)." if baja else "."))
        trazo = (f'stroke="{GRIS_CORRELACION}" stroke-dasharray="4 3" marker-end="url(#flecha-baja)"' if baja
                 else 'stroke="currentColor" stroke-opacity="0.55" marker-end="url(#flecha-m)"')
        atenuar = ' opacity="0.6"' if baja else ""
        partes.append(
            f'<g><title>{escape(detalle)}</title>'
            f'<line x1="{cx + 92}" y1="{cy:.1f}" x2="{x_caja - 2}" y2="{y}" {trazo} '
            f'stroke-width="{0.5 + 2.5 * max(fila.carga, 0):.2f}"/>'
            f'<rect x="{x_caja}" y="{y - FILA_ITEM / 2 + 1.5}" width="{ancho_caja}" height="{FILA_ITEM - 3}" rx="3" '
            f'fill="none" stroke="currentColor" stroke-opacity="0.25"/>'
            f'<text x="{x_caja + 6}" y="{y + 3.5}"{atenuar}>{escape(fila.item)}'
            f'<tspan opacity="0.6"> · {escape(str(fila.tipo))}</tspan></text>'
            f'<text x="{x_caja + ancho_caja - 6}" y="{y + 3.5}" text-anchor="end" font-variant-numeric="tabular-nums"'
            f'{atenuar}>{_num(fila.carga)}</text></g>')
    bajas = int((items["carga"] < UMBRAL_CARGA).sum())
    partes.append(
        f'<g><title>{escape(competencia.capitalize())} (competencia latente del modelo de 4 competencias, F5)</title>'
        f'<ellipse cx="{cx}" cy="{cy:.1f}" rx="90" ry="34" fill="currentColor" fill-opacity="0.05" '
        f'stroke="currentColor" stroke-width="1.5"/>'
        f'<text x="{cx}" y="{cy - 2:.1f}" text-anchor="middle" font-size="14" font-weight="600">'
        f'{escape(competencia.capitalize())}</text>'
        f'<text x="{cx}" y="{cy + 14:.1f}" text-anchor="middle" font-size="11" opacity="0.8">{n} ítems · '
        f'{bajas} con carga &lt; 0,30</text></g>'
        f'<text x="{x_caja}" y="18" font-weight="600">Ítems (carga estandarizada, de mayor a menor)</text>'
        f'<text x="8" y="{alto - 8}" opacity="0.7">Línea punteada gris: carga &lt; 0,30 (criterio de D-29). '
        'Fuente: mat_afc_cargas.csv (D-48).</text></svg>')
    return "".join(partes)


def svg_modelo(cargas: pd.DataFrame, etiquetas: dict[str, str], correlacion: float | None, rutas: list[Ruta],
               unidad_rutas: str, resaltar: str | None = None, cargas_competencia: pd.DataFrame | None = None,
               phi: pd.DataFrame | None = None) -> str:
    """Construye el SVG del modelo.

    Args:
        cargas: Columnas ``item``, ``factor`` (``ECO`` o ``CUL``) y ``carga_std``.
        etiquetas: Etiqueta oficial de cada indicador (para el detalle al pasar el cursor).
        correlacion: Correlación entre los dos factores (o ``None`` si no se conoce).
        rutas: Rutas factor → competencia.
        unidad_rutas: Unidad de los coeficientes de las rutas (para el detalle).
        resaltar: Competencia que se resalta; las demás se atenúan. ``None`` = todas por igual.
        cargas_competencia: Resumen de las cargas de los ítems por competencia (``mat_afc_resumen.csv``): columnas
            ``competencia``, ``items``, ``carga_mediana``, ``carga_min``, ``carga_max`` y ``carga_menor_030``.
            ``None`` = sin cajas de cargas.
        phi: Matriz Φ de correlaciones entre competencias (``mat_afc_phi.csv``): columna ``competencia`` y una
            columna por competencia. ``None`` = sin arcos.

    Returns:
        El SVG como texto.
    """
    cargas = cargas.assign(orden=cargas["factor"].map({"ECO": 0, "CUL": 1})).sort_values(
        ["orden", "carga_std"], ascending=[True, False])
    n = len(cargas)
    alto = max(n * FILA + 60, ALTO_MINIMO)
    y_ind = {item: 40 + i * FILA for i, item in enumerate(cargas["item"])}
    y_fac = {f: sum(y_ind[i] for i in grupo["item"]) / len(grupo) for f, grupo in cargas.groupby("factor")}
    paso_comp = (alto - 60) / 4
    # El grupo óvalo + caja queda centrado en su franja: el óvalo sube la mitad de lo que baja la caja
    y_comp = {c: 30 + paso_comp * (k + 0.5) - (BAJO_OVALO - RY_COMP) / 2 for k, c in enumerate(COMPETENCIAS)}

    partes = [f'<svg viewBox="0 0 {ANCHO} {alto}" width="100%" role="img" xmlns="http://www.w3.org/2000/svg" '
              f'font-family="system-ui, -apple-system, Segoe UI, sans-serif" font-size="11" fill="currentColor">',
              "<title>Modelo estructural: NSE de 2 dimensiones → 4 competencias latentes</title><defs>",
              *(_flecha(f"flecha-{f}", c) for f, c in COLOR_FACTOR.items()),
              _flecha("flecha-r", GRIS_CORRELACION), "</defs>"]

    # --- Medición del NSE: factor → indicador (grosor según la carga)
    for fila in cargas.itertuples():
        y, color = y_ind[fila.item], COLOR_FACTOR[fila.factor]
        etiqueta = escape(etiquetas.get(fila.item, ""))
        detalle = escape(f"{fila.item}: ") + etiqueta + escape(f"\nCarga estandarizada en {NOMBRE_FACTOR[fila.factor]}: "
                                                              f"{_num(fila.carga_std)}")
        partes.append(
            f'<g><title>{detalle}</title>'
            f'<line x1="{X_FAC - RX}" y1="{y_fac[fila.factor]:.1f}" x2="{X_IND + ANCHO_IND + 2}" y2="{y}" stroke="{color}" '
            f'stroke-width="{0.6 + 3.2 * abs(fila.carga_std):.2f}" stroke-opacity="0.55" marker-end="url(#flecha-{fila.factor})"/>'
            f'<rect x="{X_IND}" y="{y - FILA / 2 + 2}" width="{ANCHO_IND}" height="{FILA - 4}" rx="3" fill="none" '
            f'stroke="currentColor" stroke-opacity="0.25"/>'
            f'<text x="{X_IND + 6}" y="{y + 4}">{escape(fila.item)}</text>'
            f'<text x="{X_IND + ANCHO_IND - 6}" y="{y + 4}" text-anchor="end" font-variant-numeric="tabular-nums">'
            f'{_num(fila.carga_std)}</text></g>')

    # --- Correlación entre factores
    if correlacion is not None and {"ECO", "CUL"} <= set(y_fac):
        # Línea vertical de doble punta entre los dos factores: no cruza ninguna ruta (las rutas salen por la derecha)
        medio = (y_fac["ECO"] + y_fac["CUL"]) / 2
        partes.append(
            f'<g><title>Correlación entre los factores: {_num(correlacion, 3)}</title>'
            f'<line x1="{X_FAC}" y1="{y_fac["ECO"] + RY + 3:.1f}" x2="{X_FAC}" y2="{y_fac["CUL"] - RY - 3:.1f}" '
            f'stroke="{GRIS_CORRELACION}" stroke-width="1.5" marker-start="url(#flecha-r)" marker-end="url(#flecha-r)"/>'
            f'<text x="{X_FAC + 8}" y="{medio + 4:.1f}">r = {_num(correlacion)}</text></g>')

    # --- Estructura: factor → competencia
    for ruta in rutas:
        if ruta.factor not in y_fac:
            continue
        activa = resaltar is None or ruta.competencia == resaltar
        dy = DESFASE_LLEGADA[ruta.factor]
        x1, y1 = X_FAC + RX, y_fac[ruta.factor]
        x2, y2 = _borde_ovalo(dy, derecha=False) - 3, y_comp[ruta.competencia] + dy
        partes.append(
            f'<g opacity="{1 if activa else 0.15}"><title>{escape(ruta.detalle)}</title>'
            f'<line x1="{x1}" y1="{y1:.1f}" x2="{x2:.1f}" y2="{y2:.1f}" stroke="{COLOR_FACTOR[ruta.factor]}" '
            f'stroke-width="{1 + abs(ruta.valor) / 6:.2f}" marker-end="url(#flecha-{ruta.factor})"/></g>')
    # Los valores van dentro del óvalo de cada competencia (no sobre las líneas, que se cruzan)
    valores = {(r.competencia, r.factor): r.valor for r in rutas}

    # --- Correlaciones Φ entre competencias
    if phi is not None and not phi.empty:
        partes.extend(_arcos_phi(phi, y_comp, resaltar))

    # --- Nodos: factores, competencias y cajas de cargas
    for f, y in y_fac.items():
        partes.append(
            f'<g><title>{NOMBRE_FACTOR[f]} (factor latente)</title>'
            f'<ellipse cx="{X_FAC}" cy="{y:.1f}" rx="{RX}" ry="{RY}" fill="{COLOR_FACTOR[f]}" fill-opacity="0.12" '
            f'stroke="{COLOR_FACTOR[f]}" stroke-width="2"/>'
            f'<text x="{X_FAC}" y="{y + 4:.1f}" text-anchor="middle" font-size="13" font-weight="600">'
            f'{NOMBRE_FACTOR[f]}</text></g>')
    resumen = (cargas_competencia.set_index("competencia")
               if cargas_competencia is not None and not cargas_competencia.empty else None)
    for c, y in y_comp.items():
        opacidad = 1 if resaltar is None or c == resaltar else 0.45
        detalle = (f"{c.capitalize()} (competencia latente). Sus ítems y Φ: modelo de 4 competencias de la F5. "
                   f"Rutas: {unidad_rutas}.")
        partes.append(
            f'<g opacity="{opacidad}"><title>{escape(detalle)}</title>'
            f'<ellipse cx="{X_COMP}" cy="{y:.1f}" rx="{RX_COMP}" ry="{RY_COMP}" fill="currentColor" fill-opacity="0.05" '
            f'stroke="currentColor" stroke-width="1.5"/>'
            f'<text x="{X_COMP}" y="{y - 3:.1f}" text-anchor="middle" font-size="13" font-weight="600">'
            f'{c.capitalize()}</text>'
            f'<text x="{X_COMP}" y="{y + 14:.1f}" text-anchor="middle" font-size="12" font-weight="600">'
            + " · ".join(f'<tspan fill="{COLOR_FACTOR[f]}">{_num(valores[(c, f)], 1)}</tspan>'
                         for f in ("ECO", "CUL") if (c, f) in valores)
            + "</text>"
            + (_caja_cargas(c, resumen.loc[c], y) if resumen is not None and c in resumen.index else "")
            + "</g>")

    partes.append(f'<text x="{X_IND}" y="18" font-weight="600">Indicadores del NSE (carga estandarizada)</text>'
                  # Latentes, y en las rutas entran como valores plausibles (VP): las dos cosas se dicen en el título
                  f'<text x="{X_COMP - RX_COMP}" y="18" font-weight="600">Competencias (latentes, VP)</text>'
                  + (f'<text x="{X_COMP + RX_COMP + 40}" y="18" font-weight="600">Φ entre competencias</text>'
                     if phi is not None and not phi.empty else "")
                  + f'<text x="{ANCHO - 8}" y="{alto - 8}" text-anchor="end" opacity="0.7">'
                  f'Rutas: {escape(unidad_rutas)}</text></svg>')
    return "".join(partes)
