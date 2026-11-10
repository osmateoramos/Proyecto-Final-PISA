"""Páginas del tablero: un recorrido por las fases del proyecto (D-47).

Las cifras se leen de la API en el momento (``pisa_tablero.datos``); el texto fijo son explicaciones de método y los
enunciados de las hipótesis, siempre con la decisión del registro que los sostiene. Cada gráfico lleva su tabla.
"""

import pandas as pd
import streamlit as st

from pisa_tablero import datos, graficos
from pisa_tablero.componentes import ETIQUETAS_DERIVADAS, explicar, fuente, numero, tarjeta_hipotesis
from pisa_tablero.diagrama import Ruta, svg_modelo
from pisa_tablero.modelos import Perfil

COMPETENCIAS = ["emplear", "formular", "interpretar", "razonar"]
ANALISIS = {"zona": "Zona (urbana, pueblo, rural)", "H2_rural_urbana": "Rural frente a urbana (H2)",
            "sexo": "Sexo", "sector": "Sector (público, privado)"}
GRADOS = {-3: "3 grados por debajo del modal", -2: "2 por debajo", -1: "1 por debajo", 0: "Grado modal",
          1: "1 por encima"}
NOTA_TRANSVERSAL = "Diseño transversal: las cifras son asociaciones, no efectos causales."
ENUNCIADOS = {
    "H1": "El NSE se representa mejor con dos dimensiones (económica y cultural) que con una.",
    "H2": "No hay invarianza escalar entre zona rural y urbana: al menos un bien del hogar funciona distinto.",
    "H3": "Hay ítems de matemáticas con DIF por NSE no despreciable, concentrados en interpretar y formular.",
    "H4": "Tratar las omisiones rápidas como faltantes (no como incorrectas) reduce la brecha entre el cuartil alto "
          "y el bajo de NSE.",
    "H5": "La asociación del NSE es mayor en interpretar que en emplear (exploratoria, D-32).",
    "H6": "La asociación del NSE difiere entre sectores o zonas.",
    "H7": "Los puntajes propios correlacionan al menos 0,80 con los valores plausibles de la OCDE de la misma "
          "competencia.",
    "H8": "Un modelo de 4 competencias ajusta mejor que uno unidimensional.",
}
"""Enunciados resumidos de Vault_PISA2022/09 Hipótesis preregistradas.md."""


def _etiquetas() -> dict[str, str]:
    return {**datos.etiquetas_nse(), **ETIQUETAS_DERIVADAS}


# =====================================================================================================================
# Inicio
# =====================================================================================================================
@datos.con_api
def inicio() -> None:
    """Pregunta, objetivos, recorrido por fases e hipótesis."""
    st.title("PISA 2022 Colombia: nivel socioeconómico y competencias matemáticas")
    s = datos.salud()
    st.caption(f"Consultoría estadística USTA 2026-II · Vanessa Acosta, Mateo Ramos y Brayan David Barreto · "
               f"datos de la API v{s['version']} (base cargada el {s['fecha_carga']}). {NOTA_TRANSVERSAL}")

    st.markdown("> **Pregunta.** ¿En qué medida el nivel socioeconómico (NSE) —modelado como constructo latente cuya "
                "medición es igual entre grupos— explica el desempeño de los estudiantes colombianos en cada una de las "
                "cuatro competencias matemáticas de PISA 2022, calificadas con un modelo de TRI propio, y cuánto de la "
                "brecha observada depende de cómo se califica el desempeño?")
    explicar(
        que="El proyecto se armó en cadena: **O1** construye una medida del NSE con TRI y análisis factorial; **O2** "
            "comprueba que esa medida funciona igual en zonas, sexos y sectores; **O3** califica a cada estudiante en "
            "cuatro competencias (formular, emplear, interpretar y razonar) con un modelo de TRI propio y revisa si "
            "algún ítem favorece a un grupo socioeconómico; **O4** relaciona el NSE con cada competencia en un modelo "
            "estructural; **O5** pone todo a disposición en esta API y este tablero. Antes de estimar cualquier modelo "
            "se congelaron 8 hipótesis con su regla de decisión.",
        como="El menú de la izquierda sigue las fases. Cada sección tiene estas tres pestañas: qué se hizo, cómo leer "
             "el gráfico y qué significa. Al pasar el cursor por un gráfico se ven sus valores, y debajo está la tabla "
             "con las mismas cifras. Las cifras salen de la API, que solo lee los resultados que produjo R.",
        significa="Las decisiones de cada hipótesis están abajo. Las que se rechazan también son resultados: un "
                  "resultado nulo bien medido dice algo sobre Colombia.",
        decisiones="D-01 (fuente), D-07 (competencias), D-22 (definiciones de las hipótesis), D-46 y D-47 (API y "
                   "tablero)")

    st.subheader("Recorrido del proyecto")
    st.dataframe(pd.DataFrame([
        ("F1-F2", "Datos y diseño", "Muestra analítica, pesos y valores plausibles; réplica de cifras de la OCDE",
         "Cerradas · Puerta G1"),
        ("F3", "O1 · Medir el NSE", "AFE, AFC y TRI del NSE; H1", "Cerrada · Puerta G2"),
        ("F4", "O2 · Invarianza", "Invarianza por zona, sexo y sector; DIF de los bienes; H2", "Cerrada"),
        ("F5", "O3 · Competencias", "TRI de 1 y 4 dimensiones, puntajes propios, DIF, omisiones; H3, H4, H7 y H8",
         "Cerrada · Puerta G3 (acta por firmar)"),
        ("F6", "O4 · Modelo estructural", "NSE → 4 competencias con VP de la OCDE y robustez; H5 y H6", "Cerrada"),
        ("F7", "Robustez y novedad", "5 sensibilidades, búsqueda de antecedentes y hallazgos", "En curso"),
        ("F8", "O5 · Producto", "API y tablero", "Primera versión"),
    ], columns=["Fase", "Objetivo", "Qué se hizo", "Estado (2026-11-09)"]), hide_index=True, use_container_width=True)

    st.subheader("Hipótesis preregistradas")
    hip = datos.hipotesis()
    izquierda, derecha = st.columns(2)
    for i, codigo in enumerate(ENUNCIADOS):
        with izquierda if i % 2 == 0 else derecha:
            tarjeta_hipotesis(codigo, ENUNCIADOS[codigo], hip)
    st.caption("✅ se acepta · ◐ se acepta en parte o es exploratoria · ✖ se rechaza. Decisión tomada de su archivo de "
               "salidas/ (endpoint /v1/hipotesis).")


# =====================================================================================================================
# F1-F2: datos y diseño
# =====================================================================================================================
@datos.con_api
def datos_diseno() -> None:
    """Muestra analítica, excluidos y validación contra la OCDE."""
    st.title("Datos y diseño muestral (F1-F2)")
    muestra = datos.tabla("/datos/muestra")
    total = int(muestra.loc[muestra["conjunto"] == "Total Colombia", "n"].iloc[0])
    analitica = muestra[muestra["conjunto"].str.startswith("Muestra analítica")].iloc[0]
    excl = datos.tabla("/datos/excluidos")
    fila_excl = excl[excl["grupo"].str.startswith("excluidos")].head(1)

    c1, c2, c3 = st.columns(3)
    c1.metric("Estudiantes de Colombia en PISA 2022", numero(total, 0))
    c2.metric("Muestra analítica", numero(int(analitica["n"]), 0),
              help=f"{numero(float(analitica['pct_poblacion']), 1)} % de la población ponderada")
    c3.metric("Excluidos", numero(total - int(analitica["n"]), 0))

    explicar(
        que="Se usan solo los datos de Colombia de PISA 2022. Entran a la muestra analítica los estudiantes con índice "
            "socioeconómico (ESCS) y con al menos 10 ítems de matemáticas vistos (respondidos u omitidos). Todas las "
            "cifras poblacionales usan el **peso final** y las **80 réplicas BRR** (Fay 0,5) para el error, y el "
            "desempeño se analiza con los **10 valores plausibles** combinados con las reglas de Rubin.",
        como="La primera tabla muestra cuántos estudiantes quedan en cada paso. La segunda compara el puntaje de "
             "matemáticas de incluidos y excluidos. La tercera es la **Puerta G1**: si el método reproduce las cifras "
             "que publica la OCDE (diferencia de 1 punto como máximo), el diseño muestral está bien manejado.",
        significa="La G1 se cumple, así que el manejo de pesos, réplicas y valores plausibles es correcto. Los excluidos "
                  "rinden menos que los incluidos" + (
                      f" ({numero(float(fila_excl['dif_vs_incluidos'].iloc[0]), 1)} puntos)" if not fila_excl.empty
                      and pd.notna(fila_excl["dif_vs_incluidos"].iloc[0]) else "") +
                  ": los resultados describen a la población analítica, no a todos los estudiantes. Por eso la F7 "
                  "repite los análisis con una reponderación por colegio (D-38).",
        decisiones="D-01, D-13, D-14, D-15, D-38")

    st.subheader("Cómo se llegó a la muestra analítica")
    st.dataframe(muestra, hide_index=True, use_container_width=True,
                 column_config={"conjunto": "Conjunto", "n": "Estudiantes", "pct_poblacion": "% población ponderada"})
    fuente("conteos_muestra.csv", "01c_muestra_analitica.R")
    st.subheader("Incluidos frente a excluidos (media de matemáticas)")
    st.dataframe(excl, hide_index=True, use_container_width=True,
                 column_config={"grupo": "Grupo", "n": "n", "media_mat": "Media", "ee": "EE",
                                "dif_vs_incluidos": "Diferencia con incluidos", "ee_dif": "EE de la diferencia"})
    fuente("comparacion_incluidos_excluidos.csv", "01c_muestra_analitica.R")
    st.subheader("Puerta G1: reproducir las cifras de la OCDE")
    st.dataframe(datos.tabla("/datos/validacion-ocde")[["cifra", "estimacion", "ee", "publicado", "diferencia",
                                                         "cumple_g1", "fuente"]],
                 hide_index=True, use_container_width=True,
                 column_config={"cifra": "Cifra", "estimacion": "Propia", "ee": "EE", "publicado": "OCDE",
                                "diferencia": "Diferencia", "cumple_g1": "Cumple (±1)", "fuente": "Dónde la publica"})
    fuente("validacion_ocde.csv", "02_validacion_ocde.R")


# =====================================================================================================================
# F3: medición del NSE
# =====================================================================================================================
@datos.con_api
def medicion_nse() -> None:
    """AFE, AFC, H1, cargas, confiabilidad y validez del NSE."""
    st.title("Medición del NSE (F3, objetivo O1)")
    h1 = datos.tabla("/nse/h1")
    decide = h1[h1["decide_h1"].str.startswith("sí")].iloc[0]
    tarjeta_hipotesis("H1", ENUNCIADOS["H1"], datos.hipotesis())

    explicar(
        que="El NSE no se observa directamente: se infiere de **29 indicadores** del cuestionario (bienes y "
            "dispositivos del hogar, libros, y la educación y ocupación de los padres). La muestra se partió en dos "
            "mitades: en la de **exploración** un análisis factorial exploratorio (AFE) encontró dos factores, uno "
            "**económico** (19 indicadores) y uno de **libros** o capital cultural (10); en la de **confirmación** se "
            "comparó con un análisis factorial confirmatorio (AFC) un modelo de 1 dimensión contra uno de 2. Además se "
            "calibró el NSE con TRI para obtener una puntuación (EAP) por estudiante.",
        como="Las **cargas** dicen cuánto refleja cada indicador su factor (de 0 a 1; más cerca de 1, mejor indicador). "
             "La tabla de **ajuste** compara los modelos: CFI y TLI más altos y RMSEA y SRMR más bajos indican mejor "
             "ajuste (cortes usuales: CFI ≥ 0,95, RMSEA ≤ 0,06, SRMR ≤ 0,08). La **confiabilidad** (omega y TRI) va de "
             "0 a 1. La **validez** es la correlación de cada puntuación con los índices oficiales de la OCDE.",
        significa=f"Con 2 dimensiones el CFI mejora {numero(float(decide['dcfi_scaled']), 3)} (scaled) y la correlación "
                  f"entre factores es {numero(float(decide['correlacion_factores']), 3)}: son dos aspectos del NSE "
                  "relacionados pero distintos, y **H1 se acepta**. *Ninguno* de los modelos alcanza los cortes de buen "
                  "ajuste: el desajuste quedó documentado en la Puerta G2 (viene sobre todo de la educación y ocupación "
                  "de los padres y de lo digital frente a la vivienda). El factor económico es casi el índice de bienes "
                  "de la OCDE (HOMEPOS); el de libros aporta algo distinto.",
        decisiones="D-16, D-18, D-19, D-20, D-21, D-24 y el acta de la Puerta G2")

    st.subheader("Cargas del modelo elegido (2 dimensiones del AFE)")
    cargas = datos.tabla("/nse/cargas")
    elegido = cargas[cargas["modelo"] == "M2_AFE"]
    st.altair_chart(graficos.cargas_nse(elegido, _etiquetas()), use_container_width=True)
    with st.expander("Ver las cargas de los tres modelos"):
        ancho = cargas.pivot_table(index="item", columns=["modelo", "factor"], values="carga_std")
        ancho.columns = [f"{m} · {f}" for m, f in ancho.columns]
        st.dataframe(ancho.assign(pregunta=ancho.index.map(_etiquetas())), use_container_width=True)
    fuente("nse_cargas_afc.csv", "03_nse_afc.R")

    st.subheader("Ajuste de los modelos (mitad de confirmación)")
    ajuste = datos.tabla("/nse/ajuste")
    st.dataframe(ajuste[["modelo", "version", "n", "cfi_scaled", "cfi_robust", "tli_scaled", "rmsea_scaled",
                         "rmsea_robust", "srmr", "correlacion_factores"]],
                 hide_index=True, use_container_width=True,
                 column_config={"modelo": "Modelo", "version": "Versión", "cfi_scaled": "CFI scaled",
                                "cfi_robust": "CFI robust", "tli_scaled": "TLI scaled", "rmsea_scaled": "RMSEA scaled",
                                "rmsea_robust": "RMSEA robust", "srmr": "SRMR", "correlacion_factores": "r entre factores"})
    st.caption("M1 = 1 dimensión; M2 = 2 dimensiones según la propuesta inicial (D-16); M2_AFE = 2 dimensiones del "
               "AFE, el modelo que pasa a la F4-F6 (D-24). Vacío = lavaan no pudo calcularlo.")
    fuente("nse_ajuste_afc.csv", "03_nse_afc.R")

    c1, c2 = st.columns(2)
    with c1:
        st.subheader("Confiabilidad")
        st.dataframe(datos.tabla("/nse/omega"), hide_index=True, use_container_width=True)
        st.dataframe(datos.tabla("/nse/confiabilidad"), hide_index=True, use_container_width=True)
        fuente("nse_omega_afc.csv y nse_confiabilidad_tri.csv")
    with c2:
        st.subheader("Validez frente a la OCDE")
        st.dataframe(datos.tabla("/nse/validez"), hide_index=True, use_container_width=True,
                     column_config={"puntuacion": "Puntuación (EAP)", "r_homepos": "r con HOMEPOS",
                                    "r_escs": "r con ESCS"})
        fuente("nse_validez.csv", "03_nse_tri.R")


# =====================================================================================================================
# F4: invarianza
# =====================================================================================================================
@datos.con_api
def invarianza() -> None:
    """O2: invarianza, medias latentes con BRR y DIF de los bienes."""
    st.title("Invarianza del NSE (F4, objetivo O2)")
    tarjeta_hipotesis("H2", ENUNCIADOS["H2"], datos.hipotesis())
    explicar(
        que="Para comparar el NSE entre grupos hay que comprobar que **se mide igual** en todos. Se ajustó el modelo "
            "del NSE por zona, rural frente a urbana, sexo y sector, imponiendo igualdades paso a paso: **configural** "
            "(misma estructura), **umbrales**, **cargas** e **interceptos** (invarianza escalar). Si un paso no empeora "
            "el ajuste más allá de los cortes, se sostiene. Con la invarianza escalar se comparan las **medias "
            "latentes** del NSE entre grupos, con error BRR. Además se buscó DIF en cada bien del hogar.",
        como="El gráfico muestra cuánto más bajo (negativo) o más alto está el NSE de cada grupo frente a su referencia, "
             "en desviaciones estándar del factor, con su intervalo del 95 %. Si el intervalo no toca el 0, la "
             "diferencia es clara. La tabla de pasos muestra el cambio en el ajuste (ΔCFI, ΔRMSEA) de cada paso.",
        significa="Ningún paso empeora el ajuste más allá de los cortes, así que el NSE puede compararse entre grupos con "
                  "cautela. Pero la prueba χ² rechaza en 10 de 12 pasos y el ajuste de partida es pobre: **no es "
                  "invarianza demostrada** (D-35), y H2 se rechaza por su regla. El NSE económico rural está casi una DE "
                  "por debajo del urbano, y el de los colegios privados, más de una DE por encima del de los públicos.",
        decisiones="D-25, D-26, D-28, D-34, D-35")
    analisis = st.selectbox("Comparación", list(ANALISIS), format_func=ANALISIS.get)
    pasos, medias, nota = datos.invarianza(analisis)
    if not medias.empty:
        st.altair_chart(graficos.intervalos(medias, eje_y="contraste",
                                            titulo_x="Diferencia en DE del factor (IC 95 % con BRR)"),
                        use_container_width=True)
        st.dataframe(medias[["contraste", "serie", "diferencia", "ee_brr", "ic95_inf", "ic95_sup"]],
                     hide_index=True, use_container_width=True,
                     column_config={"contraste": "Contraste", "serie": "Factor", "diferencia": "Diferencia",
                                    "ee_brr": "EE (BRR)", "ic95_inf": "IC 95 % inf.", "ic95_sup": "IC 95 % sup."})
    fuente("nse_medias_latentes_brr.csv", "04_medias_brr.R")
    st.subheader("Secuencia de invarianza")
    st.dataframe(pasos, hide_index=True, use_container_width=True,
                 column_config={"paso": "Paso", "cfi_scaled": "CFI scaled", "rmsea_scaled": "RMSEA scaled",
                                "dcfi": "ΔCFI", "drmsea": "ΔRMSEA", "se_sostiene": "Se sostiene"})
    st.info(nota)
    st.subheader("DIF de los bienes del hogar entre grupos")
    dif = datos.tabla("/nse/dif-posesiones")
    dif = dif[dif["analisis"] == analisis]
    st.metric("Bienes con DIF no despreciable en esta comparación", int(dif["dif"].sum()), help="D-26")
    with st.expander("Ver todos los bienes probados"):
        st.dataframe(dif.assign(pregunta=dif["item"].map(_etiquetas())), hide_index=True, use_container_width=True)
    fuente("invarianza_tabla.csv y nse_dif_posesiones.csv", "04_invarianza.R")


# =====================================================================================================================
# F5: competencias
# =====================================================================================================================
@datos.con_api
def competencias() -> None:
    """O3: dimensionalidad, puntajes propios, validez, omisiones y DIF."""
    st.title("Calificación por competencias (F5, objetivo O3)")
    hip = datos.hipotesis()
    pestanas = st.tabs(["Dimensionalidad (H8)", "Puntajes propios", "Validez frente a la OCDE (H7)",
                        "Omisiones (H4)", "DIF por NSE (H3)"])

    with pestanas[0]:
        tarjeta_hipotesis("H8", ENUNCIADOS["H8"], hip)
        dim = datos.tabla("/matematicas/dimensionalidad")
        explicar(
            que="Se calibraron los **232 ítems** de matemáticas que tienen respuestas en Colombia con dos modelos de "
                "TRI: uno de **1 dimensión** (un solo desempeño matemático) y uno de **4 dimensiones** (una por "
                "competencia, cada ítem en la suya). La prueba es adaptativa: cada estudiante ve pocos ítems de cada "
                "competencia.",
            como="Menor **BIC** = mejor equilibrio entre ajuste y complejidad. Las correlaciones entre competencias del "
                 "modelo de 4 dimensiones dicen si de verdad son distintas: por encima de 0,95 casi no se distinguen.",
            significa="H8 se rechaza: el BIC favorece al modelo de 1 dimensión y algunas competencias correlacionan por "
                      "encima de 0,95. Aun así se calificó con el de 4 dimensiones (D-29), porque la pregunta es por "
                      "competencia, sabiendo que sus puntajes van a parecerse mucho.",
            decisiones="D-27, D-29")
        st.dataframe(dim, hide_index=True, use_container_width=True,
                     column_config={"loglik": "log-verosimilitud", "aic": "AIC", "bic": "BIC",
                                    "correlacion_min": "r mínima", "correlacion_max": "r máxima"})
        st.dataframe(datos.tabla("/matematicas/matriz"), hide_index=True, use_container_width=True,
                     column_config={"pct_celdas_con_dato_a": "% de celdas con dato",
                                    "items_por_estudiante_mediana": "Ítems por estudiante (mediana)"})
        fuente("mat_ajuste.csv y mat_matriz_resumen.csv", "05_tri_competencias.R")

        st.subheader("¿Cada ítem representa su competencia? (exploratorio)")
        cargas = datos.tabla("/matematicas/cargas-competencia")
        pares = datos.tabla("/matematicas/cobertura-pares")
        total = cargas[cargas["competencia"] == "total"].iloc[0]
        todos = pares[pares["pares"] == "todos"].iloc[0]
        explicar(
            que="Por sugerencia del curso de Ecuaciones Estructurales se revisó si cada ítem carga en la competencia que "
                "le asigna PISA. Un **análisis factorial confirmatorio** clásico no se puede hacer: con la prueba "
                f"adaptativa, el {numero(float(todos['pct_nunca_juntos']), 1)} % de los pares de ítems nunca lo respondió "
                "el mismo estudiante. Por eso se leen las cargas del modelo de 4 competencias, que ya es un análisis "
                "confirmatorio con toda la información. Se decidió después de conocer H8 y así se declara.",
            como="La **carga** dice cuánto refleja el ítem su competencia (de 0 a 1). Por debajo de **0,30** el ítem "
                 "informa poco (criterio de D-29). La segunda tabla dice cuántos estudiantes respondieron juntos cada "
                 "par de ítems.",
            significa=f"Cada ítem carga en su competencia, pero {int(total['carga_menor_030'])} de "
                      f"{int(total['items'])} tienen carga menor que 0,30. Junto con las correlaciones de H8, confirma "
                      "que las competencias casi no se separan en Colombia. Es exploratorio: no cambia ninguna "
                      "hipótesis.",
            decisiones="D-27, D-29, D-48")
        st.dataframe(cargas, hide_index=True, use_container_width=True,
                     column_config={"items": "Ítems", "carga_mediana": "Carga mediana", "carga_p10": "Percentil 10",
                                    "carga_min": "Carga mínima", "carga_max": "Carga máxima",
                                    "carga_menor_030": "Ítems con carga < 0,30", "pct_menor_030": "% con carga < 0,30"})
        st.dataframe(pares, hide_index=True, use_container_width=True,
                     column_config={"n_pares": "Pares", "nunca_juntos": "Nunca juntos", "pct_nunca_juntos": "% nunca juntos",
                                    "menos_de_50": "Menos de 50 estudiantes", "pct_menos_de_50": "% menos de 50",
                                    "mediana_estudiantes": "Estudiantes por par (mediana)",
                                    "p90_estudiantes": "Estudiantes por par (percentil 90)"})
        fuente("mat_afc_resumen.csv y mat_pares_cobertura.csv", "05_afc_competencias.R")

    with pestanas[1]:
        conf = datos.tabla("/matematicas/confiabilidad")
        explicar(
            que="Cada estudiante recibió un **puntaje por competencia** con el modelo de 4 dimensiones, condicionado en "
                "su NSE, sexo, grado, zona y sector (regresión latente), como hace la OCDE con sus valores plausibles. "
                "La integración se hizo con cuadratura de Gauss-Hermite adaptativa (E1), y se validó contra un cálculo "
                "de referencia mucho más fino (V1-V3) antes de usar los puntajes.",
            como="**V1-V3** comparan los puntajes con la referencia: deben coincidir casi exactamente. La **confiabilidad "
                 "empírica** va de 0 a 1: cuánto del puntaje es señal y no ruido de medición.",
            significa=f"Los puntajes pasan V1-V3 en las cuatro competencias; su confiabilidad va de "
                      f"{numero(float(conf['confiabilidad_empirica_con_covariables'].min()))} a "
                      f"{numero(float(conf['confiabilidad_empirica_con_covariables'].max()))}. Son válidos como "
                      "medida, pero se usan como **robustez**: el análisis principal de la F6 usa los valores plausibles "
                      "de la OCDE (D-32).",
            decisiones="D-30, D-31, D-32, D-33, D-37, D-39")
        st.dataframe(datos.tabla("/matematicas/validacion-puntajes"), hide_index=True, use_container_width=True)
        st.dataframe(conf, hide_index=True, use_container_width=True)
        fuente("mat_rl_validacion.csv y mat_confiabilidad_competencias.csv", "05_puntajes_rl.R")

    with pestanas[2]:
        tarjeta_hipotesis("H7", ENUNCIADOS["H7"], hip)
        h7 = datos.tabla("/matematicas/validez-ocde").melt(id_vars="propio", var_name="ocde", value_name="r")
        explicar(
            que="Se correlacionaron los valores plausibles propios de cada competencia con los de la OCDE (promedio de "
                "las 10 correlaciones). Además se comparó la dificultad de cada ítem con la que publica la OCDE (P3).",
            como="En el mapa, cada fila es una competencia propia y cada columna una de la OCDE; la diagonal es la misma "
                 "competencia. H7 pide al menos 0,80 en la diagonal y que la diagonal sea la mayor de su fila.",
            significa="H7 se rechaza: las correlaciones quedan por debajo de 0,80, y en formular y razonar la mayor es con "
                      "emplear de la OCDE. Coincide con H8: las competencias casi no se distinguen. Un umbral de 0,80 "
                      "sin corregir por la falta de confiabilidad de ambos puntajes era exigente (interpretación, D-41). "
                      "Las dificultades de los ítems sí concuerdan con las internacionales (P3).",
            decisiones="D-22, D-41, D-43")
        st.altair_chart(graficos.mapa_correlaciones(h7, fila="propio", columna="ocde", valor="r",
                                                    titulo_fila="Puntaje propio", titulo_columna="VP de la OCDE"),
                        use_container_width=False)
        st.subheader("P3: dificultades frente a las internacionales")
        st.dataframe(datos.tabla("/matematicas/enlace-ocde"), hide_index=True, use_container_width=True,
                     column_config={"r_spearman_todos": "Spearman (todos)", "r_b_a_min": "Pearson (a ≥ 0,3)"})
        fuente("mat_h7_correlaciones.csv y mat_p3_robusto.csv", "05_h4_h7.R y 05_p3_robusto.R")

    with pestanas[3]:
        tarjeta_hipotesis("H4", ENUNCIADOS["H4"], hip)
        om = datos.tabla("/matematicas/omisiones")
        explicar(
            que="Una **omisión rápida** es una pregunta dejada en blanco en menos del 10 % del tiempo medio del ítem: "
                "señal de desgano más que de no saber. Se calificó de dos formas, (a) toda omisión como incorrecta "
                "(como la OCDE) y (b) las omisiones rápidas como faltantes, y se comparó la brecha entre el cuartil "
                "alto y el bajo de NSE.",
            como="El gráfico muestra cuánto **se reduce** la brecha al pasar de (a) a (b), en DE, con su IC 95 %. H4 "
                 "pide una reducción de al menos 0,05 DE (la línea del umbral) y significativa.",
            significa="H4 se rechaza: la reducción es mínima, muy por debajo de 0,05. La brecha por NSE no se explica "
                      "por el desgano en la prueba: es una brecha de desempeño. Es un **resultado nulo bien medido**, y "
                      "se mantiene con otros umbrales de omisión (F7).",
            decisiones="D-05, D-27, D-41, D-45")
        df = om.rename(columns={"reduccion_b": "estimacion", "ic95_inf_b": "ic95_inf", "ic95_sup_b": "ic95_sup"})
        st.altair_chart(graficos.intervalo_simple(df, eje_y="competencia", orden_y=COMPETENCIAS,
                                                  titulo_x="Reducción de la brecha Q4 − Q1 (DE)",
                                                  referencias={"0": 0.0, "umbral de H4 (0,05)": 0.05}),
                        use_container_width=True)
        st.dataframe(om, hide_index=True, use_container_width=True,
                     column_config={"brecha_a": "Brecha (a)", "brecha_b": "Brecha (b)", "brecha_c": "Brecha (c)",
                                    "reduccion_b": "Reducción", "p_b_holm": "p (Holm)"})
        fuente("mat_h4_brechas.csv", "05_h4_h7.R")

    with pestanas[4]:
        tarjeta_hipotesis("H3", ENUNCIADOS["H3"], hip)
        _dif_por_nse()


def _dif_por_nse() -> None:
    """DIF por NSE (H3), dentro de la página de competencias."""
    todos = datos.dif()
    explicar(
        que="Un ítem tiene **DIF** si estudiantes con el mismo nivel de matemáticas pero distinto NSE tienen distinta "
            "probabilidad de acertarlo: el ítem favorecería a un grupo por algo ajeno a lo que mide. Se compararon el "
            "cuartil bajo y el alto del NSE con TRI (prueba significativa con corrección de Benjamini-Hochberg) y se "
            "midió el tamaño del efecto (categorías A, B y C del ETS).",
        como="Cada punto es un ítem dicotómico; su posición es el ΔMH (negativo = favorece al cuartil alto). Las líneas "
             "verticales marcan los cortes del ETS en 1 y 1,5. Un ítem tiene DIF solo si su prueba es significativa "
             "**y** su efecto no es despreciable; por eso hay puntos grises lejos del centro.",
        significa="Hay muy pocos ítems con DIF, todos en emplear y en ambos sentidos (dos favorecen al cuartil bajo): "
                  "la primera parte de H3 se acepta y la segunda no. No apunta a un sesgo sistemático contra los "
                  "estudiantes de menor NSE (interpretación, D-40).",
        decisiones="D-22, D-36, D-40")
    eleccion = st.selectbox("Competencia", ["todas", *COMPETENCIAS])
    df = todos if eleccion == "todas" else todos[todos["competencia"] == eleccion]
    c1, c2, c3 = st.columns(3)
    c1.metric("Ítems probados", len(df))
    c2.metric("Ítems con DIF", int(df["dif"].sum()))
    c3.metric("Sin ΔMH calculable", int((~df["mh_calculable"]).sum()),
              help="ΔMH salió infinito en R y la prueba MH no se calculó (salvedad de D-40).")
    dicotomicos = df[df["delta_mh"].notna()]
    if not dicotomicos.empty:
        st.altair_chart(graficos.dif_por_item(dicotomicos), use_container_width=True)
    st.dataframe(df[df["dif"]][["item", "competencia", "tipo", "p_bh", "delta_mh", "categoria_ets", "favorece"]],
                 hide_index=True, use_container_width=True)
    st.dataframe(datos.tabla("/matematicas/dif-resumen"), hide_index=True, use_container_width=True)
    fuente("mat_dif.csv y mat_dif_resumen.csv", "05_dif_matematicas.R")


# =====================================================================================================================
# F6: modelo estructural
# =====================================================================================================================
@datos.con_api
def modelo_estructural() -> None:
    """O4: diagrama del modelo, coeficientes, H5, H6 y robustez."""
    st.title("Modelo estructural: NSE y competencias (F6, objetivo O4)")
    hip = datos.hipotesis()
    coef = datos.coeficientes_nse()
    latente = datos.tabla("/modelo/robustez-latente")
    cargas = datos.tabla("/nse/cargas")
    ajuste_nse = datos.tabla("/nse/ajuste")
    r_fact = ajuste_nse.loc[ajuste_nse["modelo"] == "M2_AFE", "correlacion_factores"].dropna()

    explicar(
        que="El modelo une las dos medidas: el **NSE** (2 factores, medidos por sus 29 indicadores) se relaciona con "
            "cada una de las **4 competencias**, controlando por sexo y grado. El análisis principal es **en dos "
            "pasos**: primero la puntuación del NSE de cada estudiante (EAP) y luego una regresión con los **10 valores "
            "plausibles de la OCDE**, los 81 pesos (BRR) y Rubin. Como robustez se estimó el **SEM completo** con el NSE "
            "latente, y se repitió todo con los puntajes propios de la F5.",
        como="En el diagrama, a la izquierda están los indicadores con su **carga** (grosor de la flecha); en el centro, "
             "los dos factores y su **correlación**; a la derecha, las **rutas** a cada competencia con su coeficiente "
             "(puntos PISA por cada DE de más en el NSE). Elija una competencia para resaltar sus rutas, o cambie al "
             "enfoque del SEM latente. Al pasar el cursor se ve el detalle de cada elemento.",
        significa="El NSE económico se asocia con las cuatro competencias, más con **interpretar**. La asociación **no "
                  "es igual** entre competencias, la diferencia interpretar − emplear cumple la regla de H5 (que es "
                  "exploratoria) y la pendiente del NSE es mayor en los colegios **privados** (H6). El SEM latente da "
                  f"casi lo mismo que los dos pasos. {NOTA_TRANSVERSAL}",
        decisiones="D-23, D-32, D-34, D-42, D-44")

    c1, c2 = st.columns([1, 1])
    resaltar = c1.selectbox("Resaltar la competencia", ["todas", *COMPETENCIAS])
    enfoque = c2.radio("Coeficientes de las rutas", ["Dos pasos (principal)", "NSE latente (robustez)"], horizontal=True)
    factor = {"eco": "ECO", "libros": "CUL"}
    if enfoque.startswith("Dos"):
        rutas = [Ruta(factor[f.coeficiente], f.competencia, float(f.por_de_eap),
                      f"{'NSE económico' if f.coeficiente == 'eco' else 'NSE libros'} → {f.competencia}: "
                      f"{f.por_de_eap:.1f} puntos por DE de la EAP (coeficiente {f.estimacion:.1f}, IC 95 % "
                      f"{f.ic95_inf:.1f} a {f.ic95_sup:.1f}; R² = {f.r2_medio:.3f})")
                 for f in coef.itertuples()]
    else:
        rutas = [Ruta(factor[f.coeficiente], f.competencia, float(f.coef_latente_por_de),
                      f"{'NSE económico' if f.coeficiente == 'eco' else 'NSE libros'} → {f.competencia}: "
                      f"{f.coef_latente_por_de:.1f} puntos por DE del factor latente (SEM con WLSMV, peso final; "
                      f"{f.convergieron} de 10 VP convergieron)")
                 for f in latente.itertuples()]
    svg = svg_modelo(cargas[cargas["modelo"] == "M2_AFE"], _etiquetas(),
                     float(r_fact.iloc[0]) if not r_fact.empty else None, rutas,
                     "puntos PISA por DE del NSE", None if resaltar == "todas" else resaltar)
    st.markdown(svg, unsafe_allow_html=True)
    st.caption("Sexo y grado están en el modelo como controles y no se dibujan. Correlación entre factores: AFC del "
               "modelo del AFE en la mitad de confirmación. Fuentes: nse_cargas_afc.csv, nse_ajuste_afc.csv, "
               "sem_coeficientes.csv y sem_robustez_latente.csv.")

    st.subheader("Coeficiente del NSE por competencia")
    st.altair_chart(graficos.intervalos(coef, eje_y="competencia", orden_y=COMPETENCIAS,
                                        titulo_x="Puntos PISA por unidad de la EAP del NSE (IC 95 %, BRR y Rubin)"),
                    use_container_width=True)
    st.dataframe(coef[["competencia", "serie", "estimacion", "ee_brr", "ic95_inf", "ic95_sup", "por_de_eap",
                       "r2_medio"]], hide_index=True, use_container_width=True,
                 column_config={"serie": "Factor", "estimacion": "Coeficiente", "ee_brr": "EE",
                                "por_de_eap": "Puntos por DE de la EAP", "r2_medio": "R² medio"})
    fuente("sem_coeficientes.csv", "06_sem_competencias.R")

    st.subheader("¿Es igual la asociación en todas las competencias? (H5)")
    tarjeta_hipotesis("H5", ENUNCIADOS["H5"], hip)
    igualdad = datos.tabla("/modelo/igualdad").iloc[0]
    st.markdown(f"Prueba de Wald de igualdad del NSE económico en las 4 competencias: χ² = "
                f"{numero(float(igualdad['chi2']))} con {int(igualdad['gl'])} gl, p = {float(igualdad['p']):.3g}.")
    h5 = datos.tabla("/modelo/h5").rename(columns={"diferencia_interpretar_menos_emplear": "estimacion"})
    st.altair_chart(graficos.intervalo_simple(h5, eje_y="muestra", titulo_x="Interpretar − emplear (puntos PISA)",
                                              referencias={"0": 0.0}), use_container_width=True)
    st.dataframe(h5, hide_index=True, use_container_width=True)
    fuente("sem_igualdad.csv y sem_h5.csv")

    st.subheader("¿Cambia la pendiente del NSE por zona o sector? (H6)")
    tarjeta_hipotesis("H6", ENUNCIADOS["H6"], hip)
    inter = datos.interacciones()
    tabla_inter = inter.pivot(index="interaccion", columns="competencia", values="estimacion")[COMPETENCIAS]
    tabla_inter.index = tabla_inter.index.map({"eco:zonapueblo": "Pueblo frente a urbana",
                                               "eco:zonarural": "Rural frente a urbana",
                                               "eco:sectorprivado": "Privado frente a público"})
    st.dataframe(tabla_inter, use_container_width=True)
    st.dataframe(datos.tabla("/modelo/h6"), hide_index=True, use_container_width=True)
    st.caption("Diferencia en la pendiente del NSE económico frente a la referencia (puntos PISA por unidad de la EAP). "
               "Wald conjunta por variable con Holm (D-42).")
    fuente("sem_h6.csv y sem_h6_interacciones.csv")

    st.subheader("Robustez del modelo")
    explicar(
        que="Tres comprobaciones del análisis principal: (1) el **SEM completo** con el NSE latente, que evita usar la "
            "puntuación EAP como si fuera el NSE verdadero; (2) repetir todo con los **puntajes propios** de la F5 en "
            "lugar de los valores plausibles de la OCDE; (3) el **ajuste** del SEM latente.",
        como="En el gráfico, el círculo relleno es el coeficiente en dos pasos y el rombo hueco el del SEM latente; si "
             "están cerca, los dos enfoques coinciden. La tabla de fuentes dice, prueba por prueba, si la conclusión "
             "coincide con los dos tipos de puntaje.",
        significa="El coeficiente del NSE económico casi no cambia con el SEM latente. Con los puntajes propios se "
                  "repiten las conclusiones, salvo la interacción por zona, que queda sin resolver entre las dos fuentes "
                  "(D-44). El ajuste del SEM latente se reporta como descriptivo: sus índices robust no se pudieron "
                  "calcular.",
        decisiones="D-42 punto 4, D-44")
    df_lat = latente.assign(serie=latente["coeficiente"].map({"eco": "económico", "libros": "libros"}),
                            latente=latente["coef_latente_por_de"], dos_pasos=latente["dos_pasos_por_de"])
    st.altair_chart(graficos.comparacion_enfoques(df_lat), use_container_width=True)
    st.dataframe(latente, hide_index=True, use_container_width=True)
    st.dataframe(datos.tabla("/modelo/puntajes-propios"), hide_index=True, use_container_width=True)
    st.dataframe(datos.tabla("/modelo/ajuste"), hide_index=True, use_container_width=True)
    fuente("sem_robustez_latente.csv, sem_comparacion_fuentes.csv y sem_ajuste_latente.csv")


# =====================================================================================================================
# F7: robustez y hallazgos
# =====================================================================================================================
@datos.con_api
def robustez() -> None:
    """Sensibilidades de la F7 y robustez de los candidatos."""
    st.title("Robustez y hallazgos (F7)")
    explicar(
        que="Cinco resultados candidatos (K1 a K5) se repitieron cambiando una cosa a la vez: **S-A** el índice oficial "
            "ESCS en lugar del NSE propio; **S-B** sin los estudiantes de la ruta lineal de la prueba; **S-C** otros "
            "umbrales de omisión rápida; **S-D** sin corrección por comparaciones múltiples; **S-E** pesos ajustados "
            "por la exclusión de estudiantes dentro de cada colegio. No todas aplican a todos los candidatos.",
        como="En la matriz, ✓ = la conclusión se mantiene, ✗ = cambia, … = variante todavía en cálculo y — = no aplica. "
             "Un candidato es **robusto** si se mantiene en al menos el 75 % de las sensibilidades que le aplican "
             "(mínimo 3).",
        significa="Los candidatos del modelo estructural (K1 a K3) y el nulo de las omisiones (K4) son robustos. La "
                  "clasificación como hallazgo, réplica o resultado nulo (borrador del equipo en Hallazgos.md) además "
                  "exige que no esté ya publicado para Colombia: la búsqueda de antecedentes es provisional (falta "
                  "Scopus).",
        decisiones="D-38, D-45")
    det = datos.tabla("/robustez/detalle")
    simbolo = det["se_mantiene"].map({True: "✓", False: "✗"}).fillna("…")
    matriz = det.assign(estado=simbolo).pivot(index="candidato", columns="sensibilidad", values="estado").fillna("—")
    st.dataframe(matriz, use_container_width=True)
    st.dataframe(datos.robustez(), hide_index=True, use_container_width=True,
                 column_config={"conclusion": "Conclusión", "aplicables": "Aplican", "se_mantiene_en": "Se mantiene en",
                                "requerido": "Requerido", "robusto": "¿Robusto?"})
    with st.expander("Ver el detalle numérico de cada sensibilidad"):
        st.dataframe(det, hide_index=True, use_container_width=True)
    fuente("f7_sensibilidad_detalle.csv y f7_robustez.csv", "07_sensibilidad.R")


# =====================================================================================================================
# Puntaje esperado
# =====================================================================================================================
@datos.con_api
def prediccion() -> None:
    """Puntaje esperado por competencia para un perfil (D-46)."""
    st.title("Puntaje esperado por competencia")
    explicar(
        que="Con los coeficientes del modelo principal de la F6 se calcula el **puntaje esperado** de cada competencia "
            "para un perfil de NSE, sexo y grado.",
        como="Mueva los controles y pulse *Calcular*. El NSE está en la métrica de la EAP: 0 es el promedio y 1 es "
             "aproximadamente una desviación estándar por encima.",
        significa="Es una **media condicional**: el puntaje promedio que el modelo espera para estudiantes con ese "
                  "perfil, no el puntaje de una persona ni el efecto de cambiar su NSE. Sirve para ver de un vistazo el "
                  "tamaño de las asociaciones.",
        decisiones="D-42, D-46")
    with st.form("perfil"):
        izquierda, derecha = st.columns(2)
        nse_eco = izquierda.slider("NSE económico", -4.0, 4.0, 0.0, 0.1)
        nse_libros = izquierda.slider("NSE de libros", -4.0, 4.0, 0.0, 0.1)
        sexo = derecha.radio("Sexo", ["Mujer", "Hombre"], horizontal=True)
        grado = derecha.selectbox("Grado", list(GRADOS), index=3, format_func=GRADOS.get)
        enviado = st.form_submit_button("Calcular")
    if not enviado:
        return
    respuesta = datos.predecir(Perfil(nse_economico=nse_eco, nse_libros=nse_libros, sexo=sexo, grado=grado))
    df = pd.DataFrame([p.model_dump() for p in respuesta.puntajes])
    st.altair_chart(graficos.puntajes_esperados(df), use_container_width=True)
    st.dataframe(df, hide_index=True, use_container_width=True,
                 column_config={"competencia": "Competencia", "puntaje_esperado": "Puntaje esperado"})
    st.warning(respuesta.advertencia)
    st.caption(f"Fuente: {respuesta.fuente}.")
