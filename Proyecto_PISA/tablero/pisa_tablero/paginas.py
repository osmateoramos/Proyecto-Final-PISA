"""Páginas del tablero. Cada una pide sus datos a la API (``pisa_tablero.datos``); ninguna cifra se escribe a mano.

Cada gráfico lleva al lado su tabla: los valores se pueden leer sin depender del color ni del tooltip.
"""

import pandas as pd
import streamlit as st

from pisa_tablero import datos, graficos
from pisa_tablero.modelos import Perfil

COMPETENCIAS = ["emplear", "formular", "interpretar", "razonar"]
ANALISIS = {
    "zona": "Zona (urbana, pueblo, rural)",
    "H2_rural_urbana": "Rural frente a urbana (H2)",
    "sexo": "Sexo",
    "sector": "Sector (público, privado)",
}
GRADOS = {-3: "3 grados por debajo del modal", -2: "2 por debajo", -1: "1 por debajo", 0: "Grado modal",
          1: "1 por encima"}
NOTA_TRANSVERSAL = "Diseño transversal: las cifras son asociaciones, no efectos causales."


@datos.con_api
def resumen() -> None:
    """Hipótesis H1-H8 y robustez de los candidatos a hallazgo."""
    st.title("PISA 2022 Colombia: nivel socioeconómico y competencias matemáticas")
    s = datos.salud()
    st.caption(f"Resultados agregados del proyecto (USTA, 2026-II), servidos por la API v{s['version']}; "
               f"base cargada el {s['fecha_carga']}. {NOTA_TRANSVERSAL}")

    st.subheader("Hipótesis preregistradas")
    st.dataframe(
        datos.hipotesis(), hide_index=True, use_container_width=True,
        column_config={"codigo": "Hipótesis", "objetivo": "Objetivo", "decision": "Decisión",
                       "archivo": st.column_config.TextColumn("Archivo de salidas/", help="De dónde sale la decisión")},
    )

    st.subheader("Robustez de los candidatos a hallazgo (F7)")
    st.dataframe(
        datos.robustez(), hide_index=True, use_container_width=True,
        column_config={"candidato": "Candidato", "conclusion": "Conclusión que se pone a prueba",
                       "aplicables": "Sensibilidades que aplican", "evaluadas": "Evaluadas",
                       "se_mantiene_en": "Se mantiene en", "requerido": "Requerido", "robusto": "¿Robusto?"},
    )
    st.caption("Regla de D-45: robusto si la conclusión se mantiene en al menos el 75 % de las sensibilidades que le "
               "aplican, con un mínimo de 3.")


@datos.con_api
def nse() -> None:
    """O1-O2: medias latentes del NSE por grupo e invarianza."""
    st.title("NSE: diferencias entre grupos e invarianza")
    analisis = st.selectbox("Comparación", list(ANALISIS), format_func=ANALISIS.get)
    pasos, medias, nota = datos.invarianza(analisis)

    st.subheader("Diferencia de medias latentes del NSE frente al grupo de referencia")
    if medias.empty:
        st.info("Este análisis no tiene medias latentes con error BRR.")
    else:
        st.altair_chart(graficos.intervalos(medias, eje_y="contraste",
                                            titulo_x="Diferencia en DE del factor (IC 95 % con BRR)"),
                        use_container_width=True)
        with st.expander("Ver la tabla"):
            st.dataframe(medias[["contraste", "serie", "diferencia", "ee_brr", "ic95_inf", "ic95_sup"]],
                         hide_index=True, use_container_width=True,
                         column_config={"contraste": "Contraste", "serie": "Factor", "diferencia": "Diferencia",
                                        "ee_brr": "EE (BRR)", "ic95_inf": "IC 95 % inf.", "ic95_sup": "IC 95 % sup."})
    st.caption("Fuente: salidas/nse_medias_latentes_brr.csv (D-34).")

    st.subheader("Secuencia de invarianza")
    st.dataframe(pasos, hide_index=True, use_container_width=True,
                 column_config={"paso": "Paso", "n": "n", "convergio": "Convergió", "cfi_scaled": "CFI scaled",
                                "rmsea_scaled": "RMSEA scaled", "srmr": "SRMR", "dcfi": "ΔCFI", "drmsea": "ΔRMSEA",
                                "se_sostiene": "Se sostiene"})
    st.info(nota)


@datos.con_api
def competencias() -> None:
    """O3: DIF por NSE de los ítems de matemáticas (H3)."""
    st.title("Competencias: DIF por nivel socioeconómico")
    todos = datos.dif()
    eleccion = st.selectbox("Competencia", ["todas", *COMPETENCIAS])
    df = todos if eleccion == "todas" else todos[todos["competencia"] == eleccion]

    c1, c2, c3 = st.columns(3)
    c1.metric("Ítems probados", len(df))
    c2.metric("Ítems con DIF", int(df["dif"].sum()))
    c3.metric("Sin ΔMH calculable", int((~df["mh_calculable"]).sum()),
              help="ΔMH salió infinito en R y la prueba MH no se calculó (salvedad de D-40).")

    dicotomicos = df[df["delta_mh"].notna()]
    st.subheader("Magnitud del DIF en los ítems dicotómicos (ΔMH)")
    if dicotomicos.empty:
        st.info("No hay ítems dicotómicos con ΔMH en esta selección.")
    else:
        st.altair_chart(graficos.dif_por_item(dicotomicos), use_container_width=True)
    st.caption("Cuartil bajo del NSE (focal) frente al alto (referencia). Líneas verticales: cortes del ETS en "
               "|ΔMH| = 1 y 1,5. Un ítem tiene DIF si su prueba TRI es significativa con BH y su efecto no es "
               "despreciable (D-40). Los ítems de crédito parcial usan ΔR² y están en la tabla.")

    st.subheader("Ítems con DIF")
    con_dif = df[df["dif"]]
    if con_dif.empty:
        st.write("Ningún ítem con DIF en esta selección.")
    else:
        st.dataframe(con_dif[["item", "competencia", "tipo", "p_bh", "delta_mh", "categoria_ets", "favorece"]],
                     hide_index=True, use_container_width=True)
    with st.expander("Ver todos los ítems probados"):
        st.dataframe(df, hide_index=True, use_container_width=True)
    st.caption("Fuente: salidas/mat_dif.csv (05_dif_matematicas.R, D-40).")


@datos.con_api
def modelo() -> None:
    """O4: asociación del NSE con cada competencia (F6) y H6."""
    st.title("Modelo estructural: NSE y competencias")
    coef = datos.coeficientes_nse()
    st.subheader("Coeficiente del NSE por competencia")
    st.altair_chart(graficos.intervalos(coef, eje_y="competencia", orden_y=COMPETENCIAS,
                                        titulo_x="Puntos PISA por unidad de la EAP del NSE (IC 95 %, BRR y Rubin)"),
                    use_container_width=True)
    with st.expander("Ver la tabla"):
        st.dataframe(coef[["competencia", "serie", "estimacion", "ee_brr", "ic95_inf", "ic95_sup", "por_de_eap",
                           "r2_medio"]],
                     hide_index=True, use_container_width=True,
                     column_config={"serie": "Factor", "estimacion": "Coeficiente", "ee_brr": "EE",
                                    "ic95_inf": "IC 95 % inf.", "ic95_sup": "IC 95 % sup.",
                                    "por_de_eap": "Puntos por DE de la EAP", "r2_medio": "R² medio"})
    st.caption(f"Análisis principal en dos pasos con los 10 VP de la OCDE (D-42). {NOTA_TRANSVERSAL} "
               "Fuente: salidas/sem_coeficientes.csv.")

    st.subheader("¿Cambia la pendiente del NSE por zona o sector? (H6)")
    inter = datos.interacciones()
    tabla = inter.pivot(index="interaccion", columns="competencia", values="estimacion")[COMPETENCIAS]
    tabla.index = tabla.index.map({"eco:zonapueblo": "Pueblo frente a urbana", "eco:zonarural": "Rural frente a urbana",
                                   "eco:sectorprivado": "Privado frente a público"})
    st.dataframe(tabla, use_container_width=True)
    h6 = datos.hipotesis().set_index("codigo").loc["H6", "decision"]
    st.caption(f"Diferencia en la pendiente del NSE económico, en puntos PISA por unidad de la EAP. H6: {h6} "
               "(Wald conjunta por variable y Holm; D-42). Fuente: salidas/sem_h6_interacciones.csv.")


@datos.con_api
def prediccion() -> None:
    """Puntaje esperado por competencia para un perfil (D-46)."""
    st.title("Puntaje esperado por competencia")
    st.write("Elija un perfil. El NSE está en la métrica de la EAP: 0 es el promedio y 1 es aproximadamente una "
             "desviación estándar por encima.")
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
