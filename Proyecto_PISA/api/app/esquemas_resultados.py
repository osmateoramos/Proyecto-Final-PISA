"""Esquemas de las filas del catálogo de resultados (D-47).

Cada clase describe un archivo de ``salidas/``: valida sus filas al cargarlas y es el contrato de su endpoint. Los
nombres de campo son identificadores de Python; ``alias`` da el nombre de la columna en el CSV cuando difiere.
"""

from typing import Annotated

from pydantic import Field

from app.esquemas import AnalisisInvarianza, Competencia, FilaCSV

Proporcion = Annotated[float, Field(ge=0, le=1)]
ValorP = Annotated[float, Field(ge=0, le=1)]
Conteo = Annotated[int, Field(ge=0)]


# --- F1-F2: datos y diseño ---------------------------------------------------------------------------------------------
class FilaConteoMuestra(FilaCSV):
    """Conteo de estudiantes en cada paso de la muestra analítica (conteos_muestra.csv, D-14)."""

    conjunto: str
    n: Conteo
    pct_poblacion: Annotated[float, Field(ge=0, le=100, description="Porcentaje de la población ponderada.")]


class FilaComparacionExcluidos(FilaCSV):
    """Media de matemáticas de incluidos y excluidos (comparacion_incluidos_excluidos.csv, D-14, D-38)."""

    grupo: str
    n: Conteo
    media_mat: float
    ee: float
    dif_vs_incluidos: float | None
    ee_dif: float | None
    z: float | None


class FilaValidacionOCDE(FilaCSV):
    """Cifra propia frente a la publicada por la OCDE (validacion_ocde.csv, Puerta G1, D-15)."""

    paso: str
    cifra: str
    n: Conteo
    estimacion: float
    ee: float | None
    publicado: float
    ee_publicado: float | None
    diferencia: float
    cumple_g1: Annotated[bool, Field(alias="cumple_G1")]
    fuente: str


# --- F3: medición del NSE ----------------------------------------------------------------------------------------------
class FilaFrecuenciaNSE(FilaCSV):
    """Distribución de cada indicador del NSE con su etiqueta oficial (nse_items_frecuencias.csv, D-16)."""

    item: str
    etiqueta: str
    pct_na: float
    categoria: int
    n: Conteo
    pct: float
    pct_ponderado: float


class FilaCargaNSE(FilaCSV):
    """Carga estandarizada de un indicador en su factor (nse_cargas_afc.csv, D-18, D-24)."""

    modelo: Annotated[str, Field(description="M1 = 1 dimensión; M2 = 2 dimensiones de D-16; M2_AFE = 2 del AFE (D-24).")]
    factor: Annotated[str, Field(description="NSE (M1), ECO = económico, CUL = libros.")]
    item: str
    carga_std: Annotated[float, Field(ge=-1, le=1)]


class FilaAjusteAFC(FilaCSV):
    """Ajuste de cada AFC en la mitad de confirmación (nse_ajuste_afc.csv, D-18).

    Los índices *robust* que lavaan no pudo calcular salen como ``Inf`` o vacíos en el CSV (lo avisa la columna
    ``avisos`` de 03_nse_afc.R) y aquí quedan como ``None``.
    """

    NO_CALCULABLE_COMO_NULO = frozenset({"cfi.robust", "tli.robust", "rmsea.robust"})

    modelo: str
    version: str
    n: Conteo
    convergio: bool
    chisq_scaled: Annotated[float, Field(alias="chisq.scaled")]
    df_scaled: Annotated[float, Field(alias="df.scaled")]
    cfi_scaled: Annotated[float, Field(alias="cfi.scaled")]
    cfi_robust: Annotated[float | None, Field(alias="cfi.robust")]
    tli_scaled: Annotated[float, Field(alias="tli.scaled")]
    rmsea_scaled: Annotated[float, Field(alias="rmsea.scaled")]
    rmsea_robust: Annotated[float | None, Field(alias="rmsea.robust")]
    srmr: float
    correlacion_factores: float | None


class FilaOmega(FilaCSV):
    """Confiabilidad omega de cada factor (nse_omega_afc.csv)."""

    modelo: str
    factor: str
    omega: Proporcion


class FilaConfiabilidadTRI(FilaCSV):
    """Confiabilidad de la TRI del NSE (nse_confiabilidad_tri.csv, D-19)."""

    modelo: str
    dimension: str
    tipo: str
    confiabilidad: Proporcion


class FilaValidezNSE(FilaCSV):
    """Correlación de cada puntuación del NSE con los índices oficiales (nse_validez.csv, D-19)."""

    puntuacion: str
    r_homepos: Annotated[float, Field(alias="r_HOMEPOS", ge=-1, le=1)]
    r_escs: Annotated[float, Field(alias="r_ESCS", ge=-1, le=1)]


class FilaH1(FilaCSV):
    """Comparación 1 frente a 2 dimensiones (nse_h1_afc.csv, H1, D-18)."""

    comparacion: str
    decide_h1: Annotated[str, Field(alias="decide_H1")]
    dcfi_scaled: Annotated[float, Field(alias="dCFI_scaled")]
    dcfi_robust: Annotated[float | None, Field(alias="dCFI_robust")]
    correlacion_factores: float | None
    cumple_regla: bool | None
    lrt_p: Annotated[str | None, Field(alias="LRT_p", description="Texto: puede ser «< 1e-16».")]
    h1: Annotated[str | None, Field(alias="H1")]


# --- F4: invarianza ----------------------------------------------------------------------------------------------------
class FilaDIFPosesion(FilaCSV):
    """DIF de los indicadores del NSE entre grupos (nse_dif_posesiones.csv, D-26)."""

    analisis: AnalisisInvarianza
    factor: str
    item: str
    p_bh: Annotated[ValorP | None, Field(alias="p_BH")]
    dr2_nagelkerke: Annotated[float | None, Field(alias="dR2_Nagelkerke")]
    dif: Annotated[bool, Field(alias="DIF")]
    n: Conteo


# --- F5: competencias --------------------------------------------------------------------------------------------------
class FilaMatrizResumen(FilaCSV):
    """Resumen de la matriz de respuestas por competencia (mat_matriz_resumen.csv, D-27)."""

    competencia: str
    items: Conteo
    dicotomicos: Conteo
    credito_parcial: Conteo
    pct_celdas_con_dato_a: float
    omisiones: Conteo
    omisiones_rapidas: Conteo
    estudiantes_con_dato: Conteo
    items_por_estudiante_mediana: float


class FilaDimensionalidad(FilaCSV):
    """Ajuste de la TRI de 1 frente a 4 dimensiones (mat_ajuste.csv, H8, D-27)."""

    modelo: str
    convergio: bool
    iteraciones: Conteo
    minutos: float
    loglik: Annotated[float, Field(alias="logLik")]
    parametros: Conteo
    aic: Annotated[float, Field(alias="AIC")]
    bic: Annotated[float, Field(alias="BIC")]
    correlacion_min: float | None
    correlacion_max: float | None


class FilaValidacionPuntajes(FilaCSV):
    """Validación V1-V3 de los puntajes propios (mat_rl_validacion.csv, D-33, D-39)."""

    competencia: Competencia
    v1_dif_max: Annotated[float, Field(alias="V1_dif_max")]
    v1_cumple: Annotated[bool, Field(alias="V1_cumple")]
    v2_dif_media: Annotated[float, Field(alias="V2_dif_media")]
    v2_cumple: Annotated[bool, Field(alias="V2_cumple")]
    v3_mediana_pct: Annotated[float, Field(alias="V3_mediana_pct")]
    v3_cumple: Annotated[bool, Field(alias="V3_cumple")]
    cobertura_ok: bool


class FilaConfiabilidadCompetencia(FilaCSV):
    """Confiabilidad empírica de los puntajes propios (mat_confiabilidad_competencias.csv, D-39)."""

    competencia: Competencia
    confiabilidad_empirica_con_covariables: Proporcion
    confiabilidad_empirica_sin_covariables: Proporcion
    ee_posterior_mediano: float


class FilaBrechaH4(FilaCSV):
    """Brecha Q4 - Q1 con cada calificación de las omisiones (mat_h4_brechas.csv, H4, D-41)."""

    competencia: Competencia
    brecha_a: float
    brecha_b: float
    brecha_c: float
    reduccion_b: float
    ee_reduccion_b: float
    ic95_inf_b: float
    ic95_sup_b: float
    p_b_holm: Annotated[ValorP, Field(alias="p_b_Holm")]
    cumple: bool


class FilaValidezOCDE(FilaCSV):
    """Correlación de los VP propios con los de la OCDE (mat_h7_correlaciones.csv, H7, D-41)."""

    propio: Competencia
    emplear: Annotated[float, Field(alias="emplear (MPEM)")]
    formular: Annotated[float, Field(alias="formular (MPFS)")]
    interpretar: Annotated[float, Field(alias="interpretar (MPIN)")]
    razonar: Annotated[float, Field(alias="razonar (MPRE)")]


class FilaEnlaceP3(FilaCSV):
    """Concordancia de las dificultades con las internacionales (mat_p3_robusto.csv, D-43)."""

    competencia: Competencia
    items: Conteo
    r_spearman_todos: float
    items_a_min: Conteo
    excluidos: Conteo
    r_b_a_min: float
    pendiente_a: Annotated[float, Field(alias="pendiente_A")]
    intercepto_b: Annotated[float, Field(alias="intercepto_B")]


class FilaResumenDIF(FilaCSV):
    """Resumen del DIF por competencia (mat_dif_resumen.csv, D-40)."""

    competencia: Competencia
    elegibles: Conteo
    significativos_bh: Annotated[int, Field(alias="significativos_BH", ge=0)]
    no_despreciables: Conteo
    con_dif: Annotated[int, Field(alias="con_DIF", ge=0)]
    pct_dif: Annotated[float, Field(alias="pct_DIF")]


# --- F6: modelo estructural --------------------------------------------------------------------------------------------
class FilaIgualdad(FilaCSV):
    """Prueba de igualdad del NSE entre competencias (sem_igualdad.csv, D-42)."""

    prueba: str
    chi2: float
    gl: Conteo
    p: ValorP


class FilaH5(FilaCSV):
    """Interpretar - emplear en el coeficiente del NSE económico (sem_h5.csv, H5, D-42)."""

    muestra: str
    diferencia_interpretar_menos_emplear: float
    ee_brr: Annotated[float, Field(alias="ee_BRR")]
    ic95_inf: float
    ic95_sup: float
    p: ValorP
    cumple_regla: bool
    h5: Annotated[str, Field(alias="H5")]


class FilaH6(FilaCSV):
    """Prueba de Wald de las interacciones del NSE (sem_h6.csv, H6, D-42)."""

    variable: str
    chi2: float
    gl: Conteo
    p: ValorP
    n: Conteo
    p_holm: Annotated[ValorP, Field(alias="p_Holm")]
    h6: Annotated[str, Field(alias="H6")]


class FilaRobustezLatente(FilaCSV):
    """Coeficiente con NSE latente frente al de dos pasos (sem_robustez_latente.csv, D-42 punto 4)."""

    competencia: Competencia
    coeficiente: str
    coef_latente_por_de: Annotated[float, Field(alias="coef_latente_por_DE")]
    convergieron: Conteo
    dos_pasos_por_de: Annotated[float, Field(alias="dos_pasos_por_DE_de_la_EAP")]
    razon: Annotated[float, Field(alias="razon_dos_pasos_sobre_latente")]


class FilaComparacionFuentes(FilaCSV):
    """Conclusión con los VP de la OCDE frente a los propios (sem_comparacion_fuentes.csv, D-44)."""

    prueba: str
    unidad: str
    ocde_estimacion: float
    ocde_p: ValorP | None
    propios_estimacion: float
    propios_p: ValorP | None
    coincide: bool | None


class FilaAjusteSEM(FilaCSV):
    """Ajuste del SEM con NSE latente, VP1 (sem_ajuste_latente.csv, D-44)."""

    modelo: str
    n: Conteo
    convergio: bool
    chisq_scaled: Annotated[float, Field(alias="chisq.scaled")]
    df_scaled: Annotated[float, Field(alias="df.scaled")]
    cfi_scaled: Annotated[float, Field(alias="cfi.scaled")]
    tli_scaled: Annotated[float, Field(alias="tli.scaled")]
    rmsea_scaled: Annotated[float, Field(alias="rmsea.scaled")]
    cfi_robust: Annotated[float | None, Field(alias="cfi.robust")]
    srmr: float


# --- F7: robustez ------------------------------------------------------------------------------------------------------
class FilaSensibilidad(FilaCSV):
    """Resultado de cada sensibilidad para cada candidato (f7_sensibilidad_detalle.csv, D-45)."""

    candidato: Annotated[str, Field(pattern=r"^K[1-9]$")]
    sensibilidad: str
    se_mantiene: Annotated[bool | None, Field(description="None = variante todavía sin correr.")]
    detalle: str
