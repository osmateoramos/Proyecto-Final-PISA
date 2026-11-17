"""Páginas de presentación del proyecto completo (ampliación de D-47, 2026-11-16).

* ``proyecto``: el informe en una página (pregunta, objetivos, conclusiones, hallazgos y limitaciones).
* ``materias``: qué se usó de cada curso integrado (TRI, ecuaciones estructurales y Python para APIs).

Como en el resto del tablero, toda cifra se lee de la API en el momento; el texto fijo resume el informe entregado
(``Proyecto_PISA/informe/informe.Rmd``) y las decisiones del registro.
"""

import pandas as pd
import streamlit as st

from pisa_tablero import datos
from pisa_tablero.componentes import numero, rango
from pisa_tablero.config import obtener_configuracion

REPOSITORIO = "https://github.com/osmateoramos/Proyecto-Final-PISA"
INFORME_PDF = f"{REPOSITORIO}/blob/main/Proyecto_PISA/informe/informe.pdf"
EQUIPO = "Vanessa Acosta, Mateo Ramos y Brayan David Barreto · Consultoría Estadística USTA 2026-II"
PREGUNTA = ("¿En qué medida el nivel socioeconómico (NSE), modelado como constructo latente cuya medición es igual "
            "entre grupos, explica el desempeño de los estudiantes colombianos en cada una de las cuatro competencias "
            "matemáticas de PISA 2022, y cuánto de la brecha depende de cómo se califica el desempeño?")

HALLAZGOS = [
    ("K1", "El NSE económico se asocia más con interpretar que con emplear", "Hallazgo exploratorio",
     "En Colombia, la ventaja de los estudiantes de hogares con más recursos es algo mayor cuando deben interpretar "
     "resultados matemáticos que cuando deben aplicar procedimientos."),
    ("K2", "La pendiente del NSE es mayor en los colegios privados", "Hallazgo",
     "En los colegios privados, la diferencia de desempeño en matemáticas entre estudiantes de hogares con más y con "
     "menos recursos es mayor que en los públicos."),
    ("K3", "El NSE económico se asocia con las 4 competencias", "Réplica, extendida a las 4 competencias",
     "Los estudiantes de hogares con más recursos rinden más en las cuatro formas de usar las matemáticas que mide "
     "PISA, no solo en el puntaje total."),
    ("K4", "Recalificar las omisiones rápidas no reduce la brecha", "Resultado nulo bien medido",
     "Las respuestas dejadas en blanco muy rápido no explican la brecha socioeconómica en matemáticas."),
    ("K5", "DIF por NSE escaso y no concentrado en interpretar y formular", "Hallazgo parcial",
     "Muy pocas preguntas de matemáticas de PISA funcionan distinto según los recursos del hogar, y las que lo hacen "
     "no favorecen de forma sistemática a los de más recursos."),
]
"""Candidatos de la F7 con la clasificación y la frase para el Ministerio del informe entregado (Hallazgos.md)."""

LIMITACIONES = [
    "**Diseño transversal**, un ciclo y un país: las relaciones son asociaciones, no efectos causales.",
    "**Ajuste del NSE** por debajo de los cortes usuales en las versiones *robust* (D-18, D-24).",
    "**Invarianza no demostrada**: el criterio preregistrado no detecta problemas, pero la prueba χ² la rechaza "
    "(D-35).",
    "**Exclusión no aleatoria**: los excluidos rinden menos; reponderar por colegio no cambia las conclusiones (D-38).",
    "**Competencias muy correlacionadas** y pocos ítems por estudiante: por eso el modelo estructural usa los valores "
    "plausibles de la OCDE (D-32).",
    "**Errores de diseño (BRR) solo en las cifras finales**: AFC, TRI y DIF son estimaciones puntuales (D-34).",
    "**Decisiones tomadas después de ver resultados**, declaradas como tales (D-32, D-33, D-43 y D-48).",
]
"""Resumen de la sección «Limitaciones» del informe."""

CURSOS = {
    "tri": "Teoría de Respuesta al Ítem",
    "sem": "Modelos de Ecuaciones Estructurales",
    "python": "Python para Desarrollo de APIs e Inteligencia Artificial",
}

TEORIA_TRI = [
    ("Modelos 2PL y de crédito parcial generalizado (GPCM)",
     "Calibrar los 29 indicadores del NSE y dar a cada estudiante una puntuación (EAP)", "F3 · Medición del NSE"),
    ("Información, confiabilidad y ajuste de ítems (S-X², Q3)",
     "Revisar la precisión del NSE y cada indicador; así se detectaron los saltos del cuestionario (D-20)", "F3"),
    ("TRI multidimensional y comparación de modelos (AIC, BIC)",
     "Los ítems de matemáticas en 1 y en 4 competencias (H8); bifactor exploratorio", "F5 · Dimensionalidad"),
    ("Estimación de habilidad y valores plausibles (regresión latente)",
     "Puntajes propios por competencia con EM y cuadratura adaptativa, validados contra una referencia (V1-V3)",
     "F5 · Puntajes propios"),
    ("Funcionamiento diferencial del ítem (DIF)",
     "Multigrupo con anclas, Benjamini-Hochberg, Mantel-Haenszel (ETS) y ΔR²: bienes del hogar por grupo e ítems de "
     "matemáticas por NSE (H3)", "F4 y F5 · DIF"),
    ("Calificación de las omisiones", "Recalificar las omisiones rápidas como faltantes y medir la brecha (H4)",
     "F5 · Omisiones"),
    ("Enlace con la escala internacional", "Comparar las dificultades propias con las de la OCDE (P3)",
     "F5 · Validez"),
]

TEORIA_SEM = [
    ("Análisis factorial exploratorio y confirmatorio con indicadores ordinales (WLSMV)",
     "Estructura del NSE: AFE en una mitad de la muestra y AFC en la otra (H1)", "F3 · Medición del NSE"),
    ("Índices de ajuste (CFI, TLI, RMSEA, SRMR) y confiabilidad omega",
     "Juzgar los modelos del NSE y documentar su desajuste (Puerta G2)", "F3"),
    ("Invarianza de medición multigrupo",
     "Configural → umbrales → cargas → interceptos por zona, sexo y sector, con prueba de diferencia escalada (H2)",
     "F4 · Invarianza"),
    ("Medias latentes entre grupos", "Diferencias de NSE entre grupos con error de diseño (80 réplicas BRR)",
     "F4"),
    ("Modelo estructural con variables latentes",
     "NSE (2 factores, 29 indicadores) → 4 competencias, con sexo y grado como controles", "F6 · diagrama"),
    ("Enfoque en dos pasos frente a SEM completo",
     "Principal: puntuación del NSE + regresión con los 10 valores plausibles, BRR y Rubin; robustez: SEM latente",
     "F6 · Robustez"),
    ("Pruebas de Wald y moderación (interacciones)",
     "Igualdad del NSE entre competencias, H5 e interacciones NSE × zona y × sector (H6)", "F6"),
    ("AFC de los ítems por competencia (sugerencia del curso)",
     "Cargas de cada ítem en su competencia y cobertura de pares de ítems (D-48, exploratorio)",
     "F5 · Dimensionalidad"),
]

ETAPAS_PYTHON = [
    ("Script", "Los análisis corren en R con un solo comando y dejan sus resultados agregados en `salidas/`."),
    ("Contrato", "Pydantic v2 fija tipos y límites de cada resultado y de cada petición; lo inválido responde 422."),
    ("Servicio", "FastAPI publica los resultados por HTTP en `/v1`, con `/health` y documentación en `/docs`."),
    ("Contenedor", "La API y el tablero tienen su imagen Docker sobre Python 3.11.9."),
    ("Producto", "Desplegados en Render, con pruebas automáticas e integración continua en GitHub Actions."),
]
"""Recorrido del curso (script → contrato → servicio → contenedor → producto) aplicado al proyecto."""

TEORIA_PYTHON = [
    ("Entorno reproducible", "Python 3.11.9 en venv, dependencias con versión fija y Git con ramas y pull requests"),
    ("HTTP y JSON", "GET para consultar resultados y POST para la predicción; respuestas 200, 422 y 503"),
    ("POO y decoradores", "Clases con una sola responsabilidad (cliente HTTP, modelo, configuración); decoradores de "
     "FastAPI, de caché y uno propio que muestra los errores de la API en el tablero"),
    ("Pydantic v2", "`Annotated` + `Field` con límites; validadores que limpian vacíos e infinitos de los CSV; 422 con "
     "detalle incluso si llega un NaN"),
    ("FastAPI", "Routers por tema, versión `/v1`, ciclo de vida (lifespan), `/health`, inyección de dependencias y "
     "documentación OpenAPI"),
    ("SQLAlchemy con SQLite",
     "ORM 2.0: la carga valida cada archivo de resultados y lo guarda; la API consulta la base"),
    ("Modelo y predicción (Singleton)", "Los coeficientes de la F6 se cargan una sola vez al iniciar; "
     "`POST /v1/modelo/prediccion` da el puntaje esperado por competencia"),
    ("Pruebas", "pytest + TestClient en la API, contra los resultados reales; en el tablero, cliente con transporte "
     "simulado y páginas con AppTest"),
    ("Docker, despliegue e integración continua", "Imágenes python:3.11.9-slim; `render.yaml` despliega al fusionar en "
     "`main`; GitHub Actions corre las pruebas en cada cambio"),
    ("Repositorio y configuración", "Variables con prefijo `PISA_` y `.env.example` sin secretos; README con "
     "instalación, uso y la sección de uso de herramientas de IA"),
    ("Tablero", "Streamlit que solo habla con la API, con caché y reintentos con espera creciente"),
    ("Datos personales", "Solo resultados agregados: ningún dato por estudiante (Ley 1581 de 2012)"),
]


def _valor_p(p: float) -> str:
    """Valor p como texto: «p < 0,001» o «p = 0,010»."""
    return "p < 0,001" if p < 0.001 else f"p = {numero(p, 3)}"


def _cifras() -> dict[str, str]:
    """Cifras de la presentación, leídas de la API y ya formateadas (ninguna se escribe a mano).

    Returns:
        Diccionario con el texto de cada cifra.
    """
    muestra = datos.tabla("/datos/muestra")
    analitica = muestra[muestra["conjunto"].str.startswith("Muestra analítica")].iloc[0]
    eco = datos.coeficientes_nse().query("coeficiente == 'eco'")
    cuatro = datos.tabla("/matematicas/dimensionalidad").query("modelo == '4D'").iloc[0]
    dif = datos.tabla("/matematicas/dif-resumen")
    omisiones = datos.tabla("/matematicas/omisiones")
    h5 = datos.tabla("/modelo/h5")
    h5_completa = h5[h5["muestra"].str.startswith("completa")].iloc[0]
    h6 = datos.tabla("/modelo/h6")
    h1 = datos.tabla("/nse/h1")
    decide_h1 = h1[h1["decide_h1"].str.startswith("sí")].iloc[0]
    robustez = datos.robustez()
    return {
        "n": numero(int(analitica["n"]), 0),
        "pct": numero(float(analitica["pct_poblacion"]), 1),
        "coef": rango(eco["por_de_eap"]),
        "coef_entre": rango(eco["por_de_eap"], union=" y "),
        "comp_max": eco.loc[eco["por_de_eap"].idxmax(), "competencia"],
        "r_comp": rango(pd.Series([cuatro["correlacion_min"], cuatro["correlacion_max"]]), 3, " y "),
        "dif": f"{int(dif['con_dif'].sum())} de {int(dif['elegibles'].sum())}",
        "omision": rango(omisiones["reduccion_b"], 3),
        "h5": numero(float(h5_completa["diferencia_interpretar_menos_emplear"])),
        "igualdad": _valor_p(float(datos.tabla("/modelo/igualdad").iloc[0]["p"])),
        "h6": _valor_p(float(h6[h6["variable"].str.startswith("sector")].iloc[0]["p_holm"])),
        "r_nse": numero(float(decide_h1["correlacion_factores"]), 2),
        "robustos": f"{int((robustez['robusto'] == 'sí').sum())} de {len(robustez)}",
    }


def _objetivos(c: dict[str, str], decisiones: pd.Series) -> pd.DataFrame:
    """Tabla de los 5 objetivos con lo que se hizo y lo que salió.

    Args:
        c: Cifras de ``_cifras()``.
        decisiones: Decisión de cada hipótesis, indexada por código (H1 a H8).
    """
    filas = [
        ("O1 · Medir el NSE", "AFE y AFC con WLSMV en dos mitades; TRI de 29 indicadores",
         f"Dos dimensiones, económica y libros (r = {c['r_nse']}). H1 {decisiones['H1']}"),
        ("O2 · Verificar la invarianza", "Invarianza multigrupo por zona, sexo y sector; DIF de los bienes",
         f"No se detectaron diferencias relevantes en la medición, pero la invarianza no queda demostrada. "
         f"H2 {decisiones['H2']}"),
        ("O3 · Calificar por competencias", "TRI de 1 y 4 dimensiones, puntajes propios, DIF por NSE y omisiones",
         f"Competencias con r entre {c['r_comp']} (H8 {decisiones['H8']}); {c['dif']} ítems con DIF; "
         f"recalificar omisiones cambia la brecha {c['omision']} DE"),
        ("O4 · Modelo estructural", "NSE → 4 competencias con valores plausibles, BRR y Rubin; SEM latente",
         f"{c['coef']} puntos PISA por DE del NSE económico; más en {c['comp_max']}; pendiente mayor en privados"),
        ("O5 · API y tablero", "FastAPI, SQLite, Docker y Streamlit, desplegados en Render",
         "API pública con documentación y este tablero"),
    ]
    return pd.DataFrame(filas, columns=["Objetivo", "Qué se hizo", "Qué salió"]).set_index("Objetivo")


# =====================================================================================================================
# El proyecto en una página
# =====================================================================================================================
@datos.con_api
def proyecto() -> None:
    """Resumen del informe: pregunta, cifras clave, objetivos, conclusiones, hallazgos y limitaciones."""
    st.title("PISA 2022 Colombia: nivel socioeconómico y competencias matemáticas")
    st.caption(f"{EQUIPO} · Proyecto integrador de {CURSOS['tri']}, {CURSOS['sem']} y {CURSOS['python']}.")
    c = _cifras()
    st.markdown(f"> **Pregunta.** {PREGUNTA}")

    col = st.columns(4)
    col[0].metric("Estudiantes analizados", c["n"], help=f"{c['pct']} % de la población ponderada (F1-F2)")
    col[1].metric("Puntos PISA por DE del NSE", c["coef"], help="NSE económico, según la competencia (F6)")
    col[2].metric("Ítems con DIF por NSE", c["dif"], help="Ítems probados (H3, F5)")
    col[3].metric("Resultados robustos", c["robustos"], help="Candidatos que resisten las sensibilidades (F7)")

    st.subheader("Objetivos: qué se hizo y qué salió")
    decisiones = datos.hipotesis().set_index("codigo")["decision"]
    st.table(_objetivos(c, decisiones))

    st.subheader("Conclusiones")
    st.markdown(
        f"1. **El NSE tiene dos dimensiones**, económica y de libros en el hogar. Su medición no cambia de forma "
        f"relevante entre zonas, sexos y sectores, aunque la invarianza no queda demostrada.\n"
        f"2. **El NSE económico se asocia con las cuatro competencias** con una magnitud parecida, entre "
        f"{c['coef_entre']} puntos PISA por DE. Es algo mayor en interpretar ({c['h5']} puntos más que en emplear; "
        f"exploratorio) y más fuerte en los colegios privados ({c['h6']} con Holm).\n"
        f"3. **La brecha no es un artefacto de la calificación**: casi no cambia al recalificar las omisiones y no la "
        f"explican ítems con DIF.\n"
        f"4. **Las cuatro competencias casi no se distinguen** con los pocos ítems que ve cada estudiante en la prueba "
        f"adaptativa: para separarlas conviene usar los valores plausibles de la OCDE.\n"
        f"5. **Los resultados principales son robustos** ({c['robustos']}) y no se encontró un antecedente para "
        f"Colombia de K1, K2, K4 ni K5.")
    st.caption("Diseño transversal: todas las cifras son asociaciones, no efectos causales.")

    _hallazgos()
    with st.expander("Limitaciones que se declaran"):
        st.markdown("\n".join(f"- {texto}" for texto in LIMITACIONES))
    docs = f"{obtener_configuracion().api_url}/docs"
    st.markdown(f"**Documentos:** [informe en PDF]({INFORME_PDF}) · [repositorio en GitHub]({REPOSITORIO}) · "
                f"[documentación de la API]({docs}). El detalle de cada fase está en el menú de la izquierda.")


def _hallazgos() -> None:
    """Tarjetas de K1 a K5 con su clasificación, su robustez (de la API) y la frase para el Ministerio."""
    st.subheader("Hallazgos y mensaje para el Ministerio de Educación")
    robustez = datos.robustez().set_index("candidato")
    izquierda, derecha = st.columns(2)
    for i, (codigo, resultado, clasificacion, frase) in enumerate(HALLAZGOS):
        fila = robustez.loc[codigo]
        with (izquierda if i % 2 == 0 else derecha).container(border=True):
            st.markdown(f"**{codigo} · {resultado}**")
            st.caption(f"{clasificacion} · robusto en {int(fila['se_mantiene_en'])} de {int(fila['aplicables'])} "
                       "sensibilidades")
            st.markdown(f"*«{frase}»*")
    st.caption("Clasificación del informe entregado. D-50 propone leer K1 como resultado frágil (su regla se fijó "
               "después de ver el efecto); no se aplicó en el informe. K1 y K3 describen promedios, no capacidades "
               "individuales.")


# =====================================================================================================================
# Materias integradas
# =====================================================================================================================
@datos.con_api
def materias() -> None:
    """Qué se usó de cada curso del proyecto integrador y dónde se ve."""
    st.title("Materias integradas")
    st.caption("Cada curso aportó una pieza: la TRI mide, las ecuaciones estructurales relacionan y Python lo pone a "
               "disposición de cualquiera.")
    pestanas = st.tabs([CURSOS["tri"], CURSOS["sem"], CURSOS["python"]])
    with pestanas[0]:
        _materia_tri()
    with pestanas[1]:
        _materia_sem()
    with pestanas[2]:
        _materia_python()


def _tabla_teoria(filas: list[tuple[str, str, str]]) -> None:
    """Tabla «teoría del curso → cómo se usó → dónde verlo»."""
    st.table(pd.DataFrame(filas, columns=["Teoría del curso", "Cómo se usó en el proyecto", "Dónde verlo"])
             .set_index("Teoría del curso"))


def _materia_tri() -> None:
    """Pestaña de Teoría de Respuesta al Ítem."""
    st.markdown("**Para qué sirvió:** medir lo que no se observa directamente (el NSE y el desempeño por "
                "competencia) y comprobar que las preguntas miden igual a todos los grupos.")
    cargas = datos.tabla("/nse/cargas")
    matriz = datos.tabla("/matematicas/matriz").query("competencia == 'total'").iloc[0]
    confiabilidad = datos.tabla("/matematicas/confiabilidad")["confiabilidad_empirica_con_covariables"]
    c = _cifras()
    col = st.columns(4)
    col[0].metric("Indicadores del NSE calibrados", cargas.query("modelo == 'M2_AFE'")["item"].nunique())
    col[1].metric("Ítems de matemáticas calibrados", int(matriz["items"]),
                  help=f"Cada estudiante ve una mediana de {numero(float(matriz['items_por_estudiante_mediana']), 0)}")
    col[2].metric("Confiabilidad de los puntajes propios", rango(confiabilidad, 2), help="Por competencia (F5)")
    col[3].metric("Ítems con DIF por NSE", c["dif"], help="H3")
    _tabla_teoria(TEORIA_TRI)


def _materia_sem() -> None:
    """Pestaña de Modelos de Ecuaciones Estructurales."""
    st.markdown("**Para qué sirvió:** confirmar la estructura del NSE, comprobar que se mide igual entre grupos y "
                "relacionarlo con las cuatro competencias en un solo modelo.")
    c = _cifras()
    h1 = datos.tabla("/nse/h1")
    decide = h1[h1["decide_h1"].str.startswith("sí")].iloc[0]
    latente = datos.tabla("/modelo/robustez-latente").query("coeficiente == 'eco'")
    col = st.columns(4)
    col[0].metric("Mejora del CFI con 2 dimensiones", numero(float(decide["dcfi_scaled"]), 3), help="H1 (F3)")
    col[1].metric("Puntos PISA por DE del NSE", c["coef"], help="NSE económico, modelo en dos pasos (F6)")
    col[2].metric("Igualdad entre competencias", c["igualdad"], help="Prueba de Wald (F6)")
    col[3].metric("Dos pasos frente a SEM latente", f"+{rango((latente['razon'] - 1) * 100)} %",
                  help="Cuánto más alto da el enfoque en dos pasos el coeficiente del NSE económico (robustez, F6)")
    _tabla_teoria(TEORIA_SEM)


def _materia_python() -> None:
    """Pestaña de Python para APIs: el recorrido del curso aplicado al proyecto y las rutas vivas de la API."""
    st.markdown("**Para qué sirvió:** convertir los resultados de R en un producto que cualquiera puede consultar, "
                "probado, documentado y desplegado.")
    columnas = st.columns(len(ETAPAS_PYTHON))
    for i, (columna, (etapa, texto)) in enumerate(zip(columnas, ETAPAS_PYTHON, strict=True), start=1):
        with columna.container(border=True):
            st.markdown(f"**{i}. {etapa}**")
            st.caption(texto)
    st.table(pd.DataFrame(TEORIA_PYTHON, columns=["Teoría del curso", "Cómo se aplicó"]).set_index("Teoría del curso"))

    rutas = datos.rutas_api()
    v1 = rutas[rutas["ruta"].str.startswith("/v1")]
    col = st.columns(3)
    col[0].metric("Rutas publicadas en /v1", len(v1), help="Leídas en vivo del contrato OpenAPI de la API")
    col[1].metric("Grupos de rutas", v1["grupo"].nunique(), help="Datos, NSE, matemáticas, modelo, hipótesis…")
    col[2].metric("Versión de la API", datos.salud()["version"])
    with st.expander("Ver todas las rutas de la API"):
        st.dataframe(rutas, hide_index=True, use_container_width=True,
                     column_config={"metodo": "Método", "ruta": "Ruta", "grupo": "Grupo", "resumen": "Qué devuelve"})
    st.markdown(f"Documentación interactiva: [{obtener_configuracion().api_url}/docs]"
                f"({obtener_configuracion().api_url}/docs) · código en [GitHub]({REPOSITORIO}).")
