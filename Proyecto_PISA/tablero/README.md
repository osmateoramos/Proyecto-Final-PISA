# Tablero PISA 2022 Colombia (F8, paso 8.4)

Tablero en Streamlit que **consume la API** (`Proyecto_PISA/api`). No lee archivos ni estima nada: cada cifra viene de
un endpoint, y cada página dice de qué archivo de `salidas/` y de qué decisión del registro sale.

Publicado en Render (plan gratuito): https://pisa-tablero.onrender.com, con la API en
https://pisa-api-k2tn.onrender.com. La primera visita después de un rato sin uso puede tardar 50 segundos o más.

## Páginas (estructura de informe académico, D-47)

El menú sigue el orden de un informe y el orden cronológico del proyecto. Cada sección de las fases abre con un recuadro
de **contexto**, explica en tres pestañas el **procedimiento, la lectura de los resultados y su interpretación** (con las
decisiones del registro que la sostienen) y cierra anunciando la **siguiente sección**.

| Grupo | Página | Qué muestra |
|---|---|---|
| Informe | Resumen | resumen académico (problema, método, resultados, conclusión y palabras clave), indicadores principales y estructura de la presentación |
| Informe | 1. Introducción | planteamiento del problema, pregunta, objetivos O1-O5, las 8 hipótesis con su decisión y el recorrido metodológico |
| Desarrollo | 2. Datos y diseño muestral | muestra analítica, incluidos frente a excluidos y la Puerta G1 (réplica de cifras de la OCDE) |
| Desarrollo | 3. Medición del NSE | H1, cargas de los 29 indicadores (con su pregunta), ajuste de los AFC, confiabilidad y validez |
| Desarrollo | 4. Invarianza del NSE | H2, medias latentes con IC 95 % (BRR), secuencia de invarianza y DIF de los bienes por comparación |
| Desarrollo | 5. Calificación por competencias | H8 (1 frente a 4 dimensiones), puntajes propios (V1-V3, confiabilidad), H7 (mapa de correlaciones), P3, H4 y DIF (H3) |
| Desarrollo | 6. Modelo estructural | **diagrama interactivo** (indicadores con su carga → 2 factores latentes → 4 competencias como valores plausibles), por qué las competencias no son latentes, coeficientes, H5, H6 y robustez |
| Desarrollo | 7. Robustez y hallazgos | matriz candidato × sensibilidad y robustez de K1-K5 |
| Desarrollo | 8. Producto: puntaje esperado | formulario de perfil → puntaje esperado de las 4 competencias, con su advertencia |
| Cierre | 9. Conclusiones | cumplimiento de los objetivos, conclusiones, hallazgos K1-K5 con su mensaje para el Ministerio, limitaciones y documentos |
| Cierre | Anexo. Materias integradas | una pestaña por curso: contenido aplicado y sección donde se ve; en Python, las etapas script → contrato → servicio → contenedor → producto y las rutas vivas de la API (de su `/openapi.json`) |

El diagrama del modelo permite resaltar una competencia y cambiar entre el enfoque en dos pasos (principal) y el SEM
con NSE latente (robustez); al pasar el cursor se ve el detalle de cada indicador, factor y ruta.

Cada gráfico tiene su tabla al lado (los valores no dependen del color ni del tooltip). Colores: azul para el NSE
económico y naranja para libros en todo el tablero (slots 1 y 2 de la paleta categórica de referencia), gris para lo
que no se resalta.

## Puesta en marcha (Windows, PowerShell)

Requiere Python 3.11.9 y la API corriendo (ver `../api/README.md`).

```powershell
cd Proyecto_PISA/tablero
py -3.11 -m venv .venv
.venv\Scripts\activate
pip install -r requirements-dev.txt
streamlit run app.py                 # http://localhost:8501 ; la API se toma de PISA_API_URL
```

## Estructura

```
tablero/
├── app.py                 # navegación entre páginas
├── pisa_tablero/
│   ├── config.py          # PISA_API_URL, tiempo de espera e intentos (variables de entorno o .env)
│   ├── modelos.py         # contrato Pydantic de lo que se espera de la API
│   ├── cliente.py         # cliente HTTP con reintentos (backoff exponencial) y errores claros
│   ├── datos.py           # caché de 5 min y decorador que muestra los errores de la API en pantalla
│   ├── graficos.py        # gráficos de Altair como funciones puras
│   ├── diagrama.py        # diagrama SVG del modelo estructural (función pura)
│   ├── componentes.py     # explicaciones en pestañas, fuentes y tarjetas de hipótesis
│   ├── paginas.py         # una función por sección de las fases (1 a 8)
│   ├── presentacion.py    # resumen, conclusiones (sección 9) y anexo de materias integradas
│   └── textos.py          # textos institucionales compartidos (título, pregunta, problema, objetivos, secciones)
├── tests/                 # pytest: cliente (transporte simulado), gráficos y páginas (AppTest contra la API)
├── Dockerfile             # python:3.11.9-slim
└── .env.example
```

## Pruebas

```powershell
python -m pytest -rs
```

Las pruebas de páginas necesitan la API en `PISA_API_URL`; si no está, se saltan (en la integración continua,
`.github/workflows/tablero.yml`, se levanta la API y su ausencia cuenta como error).

## Pendiente

- Revisión de Brayan (responsable de la F8).

## Uso de herramientas de IA

Código escrito por **Claude Code (Claude Opus 5.5)** por encargo de Vanessa Acosta el 2026-11-09, con las buenas
prácticas del curso de Python para APIs y la guía de visualización de datos de Claude (paleta, marcas, tooltip y tabla
por gráfico). Vanessa decidió hacer el tablero en Streamlit sobre la API (plan 8.4, D-46). Brayan lo revisa y lo
continúa; cada integrante debe poder explicar cada línea en la sustentación.
