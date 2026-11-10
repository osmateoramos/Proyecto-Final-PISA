"""Catálogo de resultados (D-47): qué archivos de ``salidas/`` sirve la API, en qué ruta y con qué contrato.

Agregar un resultado nuevo es agregar una línea aquí (y su esquema en ``app.esquemas_resultados``): la carga y el
endpoint salen solos.
"""

from dataclasses import dataclass

from app import esquemas_resultados as er
from app.esquemas import FilaCSV


@dataclass(frozen=True)
class Recurso:
    """Un archivo agregado de ``salidas/`` expuesto como endpoint ``GET /v1{ruta}``."""

    ruta: str
    archivo: str
    esquema: type[FilaCSV]
    area: str
    titulo: str
    decision: str


RECURSOS: tuple[Recurso, ...] = (
    Recurso("/datos/muestra", "conteos_muestra.csv", er.FilaConteoMuestra, "Datos (F1-F2)", "Muestra analítica", "D-14"),
    Recurso("/datos/excluidos", "comparacion_incluidos_excluidos.csv", er.FilaComparacionExcluidos, "Datos (F1-F2)",
            "Incluidos frente a excluidos", "D-14, D-38"),
    Recurso("/datos/validacion-ocde", "validacion_ocde.csv", er.FilaValidacionOCDE, "Datos (F1-F2)",
            "Validación contra la OCDE (Puerta G1)", "D-15"),
    Recurso("/nse/frecuencias", "nse_items_frecuencias.csv", er.FilaFrecuenciaNSE, "NSE (O1-O2)",
            "Distribución de los indicadores del NSE", "D-16"),
    Recurso("/nse/cargas", "nse_cargas_afc.csv", er.FilaCargaNSE, "NSE (O1-O2)", "Cargas del AFC por modelo",
            "D-18, D-24"),
    Recurso("/nse/ajuste", "nse_ajuste_afc.csv", er.FilaAjusteAFC, "NSE (O1-O2)", "Ajuste del AFC", "D-18"),
    Recurso("/nse/omega", "nse_omega_afc.csv", er.FilaOmega, "NSE (O1-O2)", "Confiabilidad omega", "D-18"),
    Recurso("/nse/confiabilidad", "nse_confiabilidad_tri.csv", er.FilaConfiabilidadTRI, "NSE (O1-O2)",
            "Confiabilidad de la TRI del NSE", "D-19"),
    Recurso("/nse/validez", "nse_validez.csv", er.FilaValidezNSE, "NSE (O1-O2)", "Validez frente a ESCS y HOMEPOS",
            "D-19"),
    Recurso("/nse/h1", "nse_h1_afc.csv", er.FilaH1, "NSE (O1-O2)", "H1: 1 frente a 2 dimensiones", "D-18"),
    Recurso("/nse/dif-posesiones", "nse_dif_posesiones.csv", er.FilaDIFPosesion, "NSE (O1-O2)",
            "DIF de los indicadores del NSE entre grupos", "D-26"),
    Recurso("/matematicas/matriz", "mat_matriz_resumen.csv", er.FilaMatrizResumen, "Matemáticas (O3)",
            "Matriz de respuestas y omisiones", "D-27"),
    Recurso("/matematicas/dimensionalidad", "mat_ajuste.csv", er.FilaDimensionalidad, "Matemáticas (O3)",
            "H8: 1 frente a 4 competencias", "D-27"),
    Recurso("/matematicas/cargas-competencia", "mat_afc_resumen.csv", er.FilaCargasCompetencia, "Matemáticas (O3)",
            "Cargas de los ítems en su competencia (exploratorio)", "D-48"),
    Recurso("/matematicas/cobertura-pares", "mat_pares_cobertura.csv", er.FilaCoberturaPares, "Matemáticas (O3)",
            "Pares de ítems respondidos juntos (prueba adaptativa)", "D-48"),
    Recurso("/matematicas/validacion-puntajes", "mat_rl_validacion.csv", er.FilaValidacionPuntajes, "Matemáticas (O3)",
            "Validación de los puntajes propios (V1-V3)", "D-33, D-39"),
    Recurso("/matematicas/confiabilidad", "mat_confiabilidad_competencias.csv", er.FilaConfiabilidadCompetencia,
            "Matemáticas (O3)", "Confiabilidad de los puntajes propios", "D-39"),
    Recurso("/matematicas/omisiones", "mat_h4_brechas.csv", er.FilaBrechaH4, "Matemáticas (O3)",
            "H4: brecha según el trato de las omisiones", "D-41"),
    Recurso("/matematicas/validez-ocde", "mat_h7_correlaciones.csv", er.FilaValidezOCDE, "Matemáticas (O3)",
            "H7: puntajes propios frente a los de la OCDE", "D-41"),
    Recurso("/matematicas/enlace-ocde", "mat_p3_robusto.csv", er.FilaEnlaceP3, "Matemáticas (O3)",
            "P3: dificultades frente a las internacionales", "D-43"),
    Recurso("/matematicas/dif-resumen", "mat_dif_resumen.csv", er.FilaResumenDIF, "Matemáticas (O3)",
            "Resumen del DIF por competencia", "D-40"),
    Recurso("/modelo/igualdad", "sem_igualdad.csv", er.FilaIgualdad, "Modelo estructural (O4)",
            "Igualdad del NSE entre competencias", "D-42"),
    Recurso("/modelo/h5", "sem_h5.csv", er.FilaH5, "Modelo estructural (O4)", "H5: interpretar frente a emplear", "D-42"),
    Recurso("/modelo/h6", "sem_h6.csv", er.FilaH6, "Modelo estructural (O4)", "H6: pruebas por zona y sector", "D-42"),
    Recurso("/modelo/robustez-latente", "sem_robustez_latente.csv", er.FilaRobustezLatente, "Modelo estructural (O4)",
            "NSE latente frente a dos pasos", "D-42"),
    Recurso("/modelo/puntajes-propios", "sem_comparacion_fuentes.csv", er.FilaComparacionFuentes,
            "Modelo estructural (O4)", "VP de la OCDE frente a puntajes propios", "D-44"),
    Recurso("/modelo/ajuste", "sem_ajuste_latente.csv", er.FilaAjusteSEM, "Modelo estructural (O4)",
            "Ajuste del SEM con NSE latente", "D-44"),
    Recurso("/robustez/detalle", "f7_sensibilidad_detalle.csv", er.FilaSensibilidad, "Hipótesis y robustez",
            "Detalle de cada sensibilidad", "D-45"),
)
"""Recursos del catálogo, en el orden en que aparecen en ``/docs``."""
