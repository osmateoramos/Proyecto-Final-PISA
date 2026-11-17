"""Páginas de apertura y cierre del tablero, con estructura de informe académico (ampliación de D-47).

* ``resumen``: resumen del informe y estructura de la presentación.
* ``conclusiones``: sección 9, con el cumplimiento de los objetivos, las conclusiones, los hallazgos y las limitaciones.
* ``materias``: anexo con el aporte de cada curso integrado (TRI, ecuaciones estructurales y Python para APIs).

Como en el resto del tablero, toda cifra se lee de la API en el momento; el texto fijo resume el informe entregado
(``Proyecto_PISA/informe/informe.Rmd``) y las decisiones del registro.
"""

import pandas as pd
import streamlit as st

from pisa_tablero import datos, textos
from pisa_tablero.componentes import contexto, numero, rango, siguiente
from pisa_tablero.config import obtener_configuracion

REPOSITORIO = "https://github.com/osmateoramos/Proyecto-Final-PISA"
INFORME_PDF = f"{REPOSITORIO}/blob/main/Proyecto_PISA/informe/informe.pdf"

CURSOS = {
    "tri": "Teoría de Respuesta al Ítem",
    "sem": "Modelos de Ecuaciones Estructurales",
    "python": "Python para Desarrollo de APIs e Inteligencia Artificial",
}

HALLAZGOS = [
    ("K1", "Asociación del NSE mayor en interpretar que en emplear", "Hallazgo exploratorio",
     "En Colombia, la ventaja de los estudiantes de hogares con más recursos es algo mayor cuando deben interpretar "
     "resultados matemáticos que cuando deben aplicar procedimientos."),
    ("K2", "Pendiente del NSE mayor en los colegios privados", "Hallazgo",
     "En los colegios privados, la diferencia de desempeño en matemáticas entre estudiantes de hogares con más y con "
     "menos recursos es mayor que en los públicos."),
    ("K3", "Asociación del NSE con las cuatro competencias", "Réplica, extendida a las cuatro competencias",
     "Los estudiantes de hogares con más recursos rinden más en las cuatro formas de usar las matemáticas que mide "
     "PISA, no solo en el puntaje total."),
    ("K4", "La recalificación de las omisiones rápidas no reduce la brecha", "Resultado nulo bien medido",
     "Las respuestas dejadas en blanco muy rápido no explican la brecha socioeconómica en matemáticas."),
    ("K5", "Funcionamiento diferencial escaso y no concentrado en interpretar y formular", "Hallazgo parcial",
     "Muy pocas preguntas de matemáticas de PISA funcionan distinto según los recursos del hogar, y las que lo hacen "
     "no favorecen de forma sistemática a los de más recursos."),
]
"""Resultados candidatos de la F7, con la clasificación y el mensaje del informe entregado (Hallazgos.md)."""

LIMITACIONES = [
    "**Diseño transversal**, de un solo ciclo y un solo país: las relaciones son asociaciones, no efectos causales.",
    "**Ajuste del modelo del NSE** por debajo de los cortes usuales en las versiones *robust* (D-18, D-24).",
    "**Invarianza no demostrada**: el criterio preregistrado no detecta diferencias relevantes, pero la prueba χ² "
    "la rechaza y el ajuste de partida es pobre (D-35).",
    "**Exclusión no aleatoria** de estudiantes: la reponderación por colegio no modifica las conclusiones (D-38).",
    "**Competencias muy correlacionadas** y pocos ítems por estudiante, por lo que el modelo estructural se estimó "
    "con los valores plausibles de la OCDE (D-32).",
    "**Errores de diseño (BRR) solo en las cifras finales**: el análisis factorial, la TRI y el DIF se reportan como "
    "estimaciones puntuales (D-34).",
    "**Decisiones adoptadas después de observar resultados**, declaradas como tales (D-32, D-33, D-43 y D-48).",
]
"""Síntesis de la sección «Limitaciones» del informe."""

TEORIA_TRI = [
    ("Modelos logístico de dos parámetros (2PL) y de crédito parcial generalizado (GPCM)",
     "Calibración de los 29 indicadores del NSE y estimación de una puntuación (EAP) por estudiante", "3"),
    ("Información, confiabilidad y ajuste de ítems (S-X², Q3)",
     "Evaluación de la precisión del NSE y de cada indicador; detección de los saltos del cuestionario (D-20)", "3"),
    ("TRI multidimensional y comparación de modelos (AIC, BIC)",
     "Comparación de los modelos de una y cuatro competencias (H8) y modelo bifactor exploratorio", "5"),
    ("Estimación de la habilidad y valores plausibles (regresión latente)",
     "Puntajes propios por competencia mediante EM y cuadratura adaptativa, validados contra una referencia (V1-V3)",
     "5"),
    ("Funcionamiento diferencial del ítem (DIF)",
     "Modelos multigrupo con anclas, Benjamini-Hochberg, Mantel-Haenszel (ETS) y ΔR²: bienes del hogar por grupo e "
     "ítems de matemáticas por NSE (H3)", "4 y 5"),
    ("Tratamiento de las respuestas omitidas",
     "Recalificación de las omisiones rápidas como faltantes y efecto sobre la brecha (H4)", "5"),
    ("Enlace con la escala internacional", "Concordancia de las dificultades propias con las de la OCDE (P3)", "5"),
]

TEORIA_SEM = [
    ("Análisis factorial exploratorio y confirmatorio con indicadores ordinales (WLSMV)",
     "Estructura del NSE: exploración en una mitad de la muestra y confirmación en la otra (H1)", "3"),
    ("Índices de ajuste (CFI, TLI, RMSEA, SRMR) y confiabilidad omega",
     "Evaluación de los modelos del NSE y documentación de su desajuste (Puerta G2)", "3"),
    ("Invarianza de medición multigrupo",
     "Secuencia configural, umbrales, cargas e interceptos por zona, sexo y sector, con prueba de diferencia escalada "
     "(H2)", "4"),
    ("Comparación de medias latentes", "Diferencias de NSE entre grupos con error de diseño (80 réplicas BRR)", "4"),
    ("Modelo estructural con variables latentes",
     "NSE (dos factores, 29 indicadores) → cuatro competencias, con sexo y grado como controles", "6"),
    ("Estimación en dos pasos frente al modelo completo",
     "Principal: puntuación del NSE y regresión con los 10 valores plausibles, BRR y Rubin; robustez: SEM latente",
     "6"),
    ("Pruebas de Wald y moderación (interacciones)",
     "Igualdad de la asociación entre competencias, H5 e interacciones del NSE con zona y sector (H6)", "6"),
    ("Análisis confirmatorio de los ítems por competencia",
     "Cargas de cada ítem en su competencia y cobertura de pares de ítems (D-48, exploratorio)", "5"),
]

ETAPAS_PYTHON = [
    ("Script", "Los análisis se ejecutan en R con un solo comando y dejan sus resultados agregados en `salidas/`."),
    ("Contrato", "Pydantic v2 define tipos y límites de cada resultado y de cada petición; lo inválido responde 422."),
    ("Servicio", "FastAPI publica los resultados por HTTP en `/v1`, con `/health` y documentación en `/docs`."),
    ("Contenedor", "La API y el tablero cuentan con su imagen Docker sobre Python 3.11.9."),
    ("Producto", "Ambos están desplegados en Render, con pruebas automáticas e integración continua."),
]
"""Etapas del curso (script → contrato → servicio → contenedor → producto) aplicadas al proyecto."""

TEORIA_PYTHON = [
    ("Entorno reproducible", "Python 3.11.9 en entorno virtual, dependencias con versión fija y control de versiones "
     "con Git (ramas y pull requests)"),
    ("Protocolo HTTP y JSON", "GET para consultar resultados y POST para la predicción; respuestas 200, 422 y 503"),
    ("Programación orientada a objetos y decoradores", "Clases con una sola responsabilidad (cliente HTTP, modelo, "
     "configuración); decoradores de FastAPI, de caché y uno propio que presenta los errores de la API"),
    ("Validación con Pydantic v2", "`Annotated` y `Field` con límites; validadores que depuran vacíos e infinitos; "
     "respuesta 422 con detalle incluso ante valores no finitos"),
    ("Servicio con FastAPI", "Enrutadores por tema, versión `/v1`, ciclo de vida (lifespan), `/health`, inyección de "
     "dependencias y documentación OpenAPI"),
    ("Persistencia con SQLAlchemy y SQLite",
     "ORM 2.0: la carga valida cada archivo de resultados antes de guardarlo; la API consulta la base"),
    ("Modelo de predicción (Singleton)", "Los coeficientes de la sección 6 se cargan una sola vez al iniciar; "
     "`POST /v1/modelo/prediccion` devuelve el puntaje esperado por competencia"),
    ("Pruebas automáticas", "pytest y TestClient en la API, contra los resultados reales; en el tablero, cliente con "
     "transporte simulado y páginas con AppTest"),
    ("Contenedores, despliegue e integración continua", "Imágenes python:3.11.9-slim; `render.yaml` despliega al "
     "fusionar en `main`; GitHub Actions ejecuta las pruebas en cada cambio"),
    ("Repositorio y configuración", "Variables con prefijo `PISA_` y `.env.example` sin secretos; README con "
     "instalación, uso y declaración del uso de herramientas de IA"),
    ("Tablero", "Streamlit que consulta exclusivamente la API, con caché y reintentos con espera creciente"),
    ("Protección de datos personales", "Solo resultados agregados; ningún dato individual (Ley 1581 de 2012)"),
]


def _valor_p(p: float) -> str:
    """Valor p como texto: «p < 0,001» o «p = 0,010»."""
    return "p < 0,001" if p < 0.001 else f"p = {numero(p, 3)}"


def _cifras() -> dict[str, str]:
    """Cifras de las páginas de apertura y cierre, leídas de la API y ya formateadas (ninguna se escribe a mano).

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


def _indicadores(c: dict[str, str]) -> None:
    """Fila de cuatro indicadores principales del estudio."""
    col = st.columns(4)
    col[0].metric("Estudiantes analizados", c["n"], help=f"{c['pct']} % de la población ponderada (sección 2)")
    col[1].metric("Puntos PISA por DE del NSE", c["coef"], help="NSE económico, según la competencia (sección 6)")
    col[2].metric("Ítems con DIF por NSE", c["dif"], help="Ítems evaluados (H3, sección 5)")
    col[3].metric("Resultados robustos", c["robustos"], help="Resultados que resisten las sensibilidades (sección 7)")


# =====================================================================================================================
# Resumen
# =====================================================================================================================
@datos.con_api
def resumen() -> None:
    """Resumen del informe, indicadores principales y estructura de la presentación."""
    st.title("Resumen")
    st.markdown(f"#### {textos.TITULO}")
    st.caption(f"{textos.EQUIPO} · {textos.INSTITUCION} · Proyecto integrador de {CURSOS['tri']}, {CURSOS['sem']} y "
               f"{CURSOS['python']}.")
    c = _cifras()
    with st.container(border=True):
        st.markdown(
            "**Problema.** En Colombia, la brecha socioeconómica en matemáticas se reporta con un índice de nivel "
            "socioeconómico (NSE) unidimensional y con un puntaje global. Este estudio examina la asociación del NSE "
            "con cada una de las cuatro competencias matemáticas de PISA 2022 y si la brecha depende de cómo se mide "
            "el NSE y de cómo se califica la prueba.\n\n"
            f"**Método.** Se analizaron {c['n']} estudiantes colombianos ({c['pct']} % de la población ponderada). El "
            "NSE se midió como constructo latente mediante análisis factorial y Teoría de Respuesta al Ítem (TRI), y "
            "su invarianza se evaluó por zona, sexo y sector. El desempeño se calibró con un modelo de TRI de cuatro "
            "competencias; el funcionamiento diferencial de los ítems (DIF) y el tratamiento de las omisiones se "
            "contrastaron con hipótesis preregistradas. La asociación se estimó con un modelo estructural, valores "
            "plausibles, pesos muestrales y 80 réplicas BRR.\n\n"
            f"**Resultados.** El NSE presenta dos dimensiones, económica y de libros en el hogar (r = {c['r_nse']}). "
            f"Las competencias correlacionan entre {c['r_comp']}, y el BIC favorece un modelo unidimensional. Una "
            f"desviación estándar del NSE económico se asocia con {c['coef']} puntos PISA más, según la competencia, "
            f"con el valor más alto en {c['comp_max']} ({c['h5']} puntos sobre emplear; resultado exploratorio). La "
            f"pendiente del NSE es mayor en los colegios privados ({c['h6']}, con corrección de Holm). Solo "
            f"{c['dif']} ítems presentan DIF por NSE, y la recalificación de las omisiones rápidas modifica la brecha "
            f"en {c['omision']} desviaciones estándar. De los resultados principales, {c['robustos']} resisten las "
            "pruebas de robustez.\n\n"
            "**Conclusión.** La brecha socioeconómica en matemáticas no es un artefacto de la calificación; sin "
            "embargo, las cuatro competencias apenas se distinguen con los ítems que responde cada estudiante.\n\n"
            "**Palabras clave:** nivel socioeconómico, teoría de respuesta al ítem, ecuaciones estructurales, "
            "invarianza de medición, PISA 2022.")
    st.caption(textos.NOTA_TRANSVERSAL)

    st.subheader("Indicadores principales")
    _indicadores(c)

    st.subheader("Estructura de la presentación")
    st.table(pd.DataFrame(textos.SECCIONES, columns=["Sección", "Contenido"]).set_index("Sección"))
    st.caption("Las secciones siguen el orden cronológico del desarrollo del proyecto: cada una parte de lo que dejó "
               "resuelto la anterior.")
    siguiente("La sección 1 presenta el problema, la pregunta de investigación, los objetivos y las hipótesis.")


# =====================================================================================================================
# 9. Conclusiones
# =====================================================================================================================
def _cumplimiento(c: dict[str, str], decisiones: pd.Series) -> pd.DataFrame:
    """Tabla de cumplimiento de los cinco objetivos: metodología y resultado principal.

    Args:
        c: Cifras de ``_cifras()``.
        decisiones: Decisión de cada hipótesis, indexada por código (H1 a H8).
    """
    filas = [
        ("O1 · Medición del NSE", "Análisis factorial exploratorio y confirmatorio (WLSMV) y TRI de 29 indicadores",
         f"Dos dimensiones, económica y de libros (r = {c['r_nse']}); H1 {decisiones['H1']}"),
        ("O2 · Invarianza", "Invarianza multigrupo por zona, sexo y sector; DIF de los bienes del hogar",
         f"Sin diferencias relevantes en la medición, aunque la invarianza no queda demostrada; H2 "
         f"{decisiones['H2']}"),
        ("O3 · Calificación por competencias", "TRI de una y cuatro dimensiones, puntajes propios, DIF y omisiones",
         f"Competencias con correlaciones entre {c['r_comp']} (H8 {decisiones['H8']}); {c['dif']} ítems con DIF; "
         f"cambio en la brecha de {c['omision']} DE al recalificar omisiones"),
        ("O4 · Modelo estructural", "NSE → cuatro competencias con valores plausibles, BRR y Rubin; SEM latente",
         f"{c['coef']} puntos PISA por DE del NSE económico; mayor en {c['comp_max']}; pendiente mayor en el "
         "sector privado"),
        ("O5 · Producto", "API (FastAPI, SQLite) y tablero (Streamlit) en contenedores, desplegados en Render",
         "API pública documentada y tablero de consulta"),
    ]
    return pd.DataFrame(filas, columns=["Objetivo", "Metodología", "Resultado principal"]).set_index("Objetivo")


@datos.con_api
def conclusiones() -> None:
    """Sección 9: cumplimiento de los objetivos, conclusiones, hallazgos y limitaciones."""
    st.title("9. Conclusiones")
    st.caption("Fase F9 · Informe final")
    contexto("Esta sección cierra el recorrido: contrasta los resultados con los objetivos planteados en la "
             "introducción, resume las conclusiones y declara los alcances y las limitaciones del estudio.")
    c = _cifras()
    _indicadores(c)

    st.subheader("Cumplimiento de los objetivos")
    st.table(_cumplimiento(c, datos.hipotesis().set_index("codigo")["decision"]))

    st.subheader("Conclusiones")
    st.markdown(
        "1. **El NSE se representa mejor con dos dimensiones**, económica y de libros en el hogar. Su medición no "
        "presenta diferencias relevantes entre zonas, sexos y sectores, aunque la invarianza no queda demostrada.\n"
        f"2. **El NSE económico se asocia con las cuatro competencias** con una magnitud similar, entre "
        f"{c['coef_entre']} puntos PISA por desviación estándar. La asociación es algo mayor en interpretar "
        f"({c['h5']} puntos más que en emplear; resultado exploratorio) y más pronunciada en los colegios privados "
        f"({c['h6']}, con corrección de Holm).\n"
        "3. **La brecha no es un artefacto de la calificación**: apenas cambia al recalificar las omisiones y no la "
        "explican ítems con funcionamiento diferencial.\n"
        "4. **Las cuatro competencias apenas se distinguen** con los ítems que responde cada estudiante en la prueba "
        "adaptativa; para analizarlas por separado conviene emplear los valores plausibles de la OCDE.\n"
        f"5. **Los resultados principales son robustos** ({c['robustos']}), y la búsqueda en Scopus, Google "
        "Académico, SciELO y Redalyc no identificó antecedentes para Colombia de K1, K2, K4 ni K5.")
    st.caption(textos.NOTA_TRANSVERSAL)

    _hallazgos()

    st.subheader("Limitaciones")
    st.markdown("\n".join(f"- {texto}" for texto in LIMITACIONES))

    st.subheader("Documentos de referencia")
    docs = f"{obtener_configuracion().api_url}/docs"
    st.markdown(f"- [Informe final (PDF)]({INFORME_PDF})\n- [Repositorio del proyecto]({REPOSITORIO})\n"
                f"- [Documentación de la API]({docs})")
    siguiente("El anexo describe el aporte de cada curso integrado al proyecto.")


def _hallazgos() -> None:
    """Tarjetas de K1 a K5 con su clasificación, su robustez (leída de la API) y el mensaje para el Ministerio."""
    st.subheader("Hallazgos y mensajes para la política educativa")
    robustez = datos.robustez().set_index("candidato")
    izquierda, derecha = st.columns(2)
    for i, (codigo, resultado, clasificacion, frase) in enumerate(HALLAZGOS):
        fila = robustez.loc[codigo]
        with (izquierda if i % 2 == 0 else derecha).container(border=True):
            st.markdown(f"**{codigo} · {resultado}**")
            st.caption(f"{clasificacion} · se mantiene en {int(fila['se_mantiene_en'])} de "
                       f"{int(fila['aplicables'])} sensibilidades")
            st.markdown(f"*«{frase}»*")
    st.caption("Clasificación del informe entregado. D-50 propone tratar K1 como resultado frágil, porque su regla se "
               "fijó después de observar el efecto; no se aplicó en el informe. K1 y K3 describen promedios "
               "condicionados, no capacidades individuales.")


# =====================================================================================================================
# Anexo. Materias integradas
# =====================================================================================================================
@datos.con_api
def materias() -> None:
    """Anexo: aporte de cada curso del proyecto integrador y sección del tablero donde se aplica."""
    st.title("Anexo. Materias integradas")
    contexto("El proyecto integra tres cursos: la Teoría de Respuesta al Ítem aporta la medición, los Modelos de "
             "Ecuaciones Estructurales la relación entre constructos y Python para APIs la publicación de los "
             "resultados. Este anexo detalla el contenido de cada curso aplicado y la sección donde puede "
             "consultarse.")
    pestanas = st.tabs([CURSOS["tri"], CURSOS["sem"], CURSOS["python"]])
    with pestanas[0]:
        _materia_tri()
    with pestanas[1]:
        _materia_sem()
    with pestanas[2]:
        _materia_python()


def _tabla_teoria(filas: list[tuple[str, str, str]]) -> None:
    """Tabla «contenido del curso → aplicación en el proyecto → sección del tablero»."""
    st.table(pd.DataFrame(filas, columns=["Contenido del curso", "Aplicación en el proyecto", "Sección"])
             .set_index("Contenido del curso"))


def _materia_tri() -> None:
    """Pestaña de Teoría de Respuesta al Ítem."""
    st.markdown("**Aporte al proyecto.** Medir lo que no se observa directamente —el NSE y el desempeño por "
                "competencia— y verificar que los ítems funcionan igual para todos los grupos.")
    cargas = datos.tabla("/nse/cargas")
    matriz = datos.tabla("/matematicas/matriz").query("competencia == 'total'").iloc[0]
    confiabilidad = datos.tabla("/matematicas/confiabilidad")["confiabilidad_empirica_con_covariables"]
    col = st.columns(4)
    col[0].metric("Indicadores del NSE calibrados", cargas.query("modelo == 'M2_AFE'")["item"].nunique())
    col[1].metric("Ítems de matemáticas calibrados", int(matriz["items"]),
                  help=f"Cada estudiante responde una mediana de "
                       f"{numero(float(matriz['items_por_estudiante_mediana']), 0)}")
    col[2].metric("Confiabilidad de los puntajes propios", rango(confiabilidad, 2), help="Por competencia")
    col[3].metric("Ítems con DIF por NSE", _cifras()["dif"], help="H3")
    _tabla_teoria(TEORIA_TRI)


def _materia_sem() -> None:
    """Pestaña de Modelos de Ecuaciones Estructurales."""
    st.markdown("**Aporte al proyecto.** Confirmar la estructura del NSE, verificar que se mide igual entre grupos y "
                "relacionarlo con las cuatro competencias en un solo modelo.")
    c = _cifras()
    h1 = datos.tabla("/nse/h1")
    decide = h1[h1["decide_h1"].str.startswith("sí")].iloc[0]
    latente = datos.tabla("/modelo/robustez-latente").query("coeficiente == 'eco'")
    col = st.columns(4)
    col[0].metric("Mejora del CFI con dos dimensiones", numero(float(decide["dcfi_scaled"]), 3), help="H1")
    col[1].metric("Puntos PISA por DE del NSE", c["coef"], help="NSE económico, estimación en dos pasos")
    col[2].metric("Igualdad entre competencias", c["igualdad"], help="Prueba de Wald")
    col[3].metric("Dos pasos frente a SEM latente", f"+{rango((latente['razon'] - 1) * 100)} %",
                  help="Diferencia relativa del coeficiente del NSE económico entre los dos enfoques (robustez)")
    _tabla_teoria(TEORIA_SEM)


def _materia_python() -> None:
    """Pestaña de Python para APIs: etapas del curso aplicadas al proyecto y rutas publicadas por la API."""
    st.markdown("**Aporte al proyecto.** Convertir los resultados de R en un producto consultable, probado, "
                "documentado y desplegado.")
    columnas = st.columns(len(ETAPAS_PYTHON))
    for i, (columna, (etapa, texto)) in enumerate(zip(columnas, ETAPAS_PYTHON, strict=True), start=1):
        with columna.container(border=True):
            st.markdown(f"**{i}. {etapa}**")
            st.caption(texto)
    st.table(pd.DataFrame(TEORIA_PYTHON, columns=["Contenido del curso", "Aplicación en el proyecto"])
             .set_index("Contenido del curso"))

    rutas = datos.rutas_api()
    v1 = rutas[rutas["ruta"].str.startswith("/v1")]
    col = st.columns(3)
    col[0].metric("Rutas publicadas en /v1", len(v1), help="Leídas del contrato OpenAPI de la API")
    col[1].metric("Grupos de rutas", v1["grupo"].nunique(), help="Datos, NSE, matemáticas, modelo, hipótesis…")
    col[2].metric("Versión de la API", datos.salud()["version"])
    with st.expander("Rutas de la API"):
        st.dataframe(rutas, hide_index=True, use_container_width=True,
                     column_config={"metodo": "Método", "ruta": "Ruta", "grupo": "Grupo", "resumen": "Descripción"})
    docs = f"{obtener_configuracion().api_url}/docs"
    st.markdown(f"Documentación interactiva: [{docs}]({docs}) · código fuente en [GitHub]({REPOSITORIO}).")
