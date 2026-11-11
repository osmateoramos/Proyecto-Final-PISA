# Tablero PISA 2022 Colombia (F8, paso 8.4)

Tablero en Streamlit que **consume la API** (`Proyecto_PISA/api`). No lee archivos ni estima nada: cada cifra viene de
un endpoint, y cada página dice de qué archivo de `salidas/` y de qué decisión del registro sale.

Publicado en Render (plan gratuito): https://pisa-tablero.onrender.com, con la API en
https://pisa-api-k2tn.onrender.com. La primera visita después de un rato sin uso puede tardar 50 segundos o más.

## Páginas (recorrido por fases, D-47)

Cada sección explica en tres pestañas **qué se hizo, cómo se lee y qué significa**, con las decisiones del registro que
la sostienen.

| Página | Qué muestra |
|---|---|
| Inicio y recorrido | pregunta, objetivos O1-O5, estado de cada fase y las 8 hipótesis con su decisión |
| F1-F2 · Datos y diseño | muestra analítica, incluidos frente a excluidos y la Puerta G1 (réplica de cifras de la OCDE) |
| F3 · Medición del NSE | H1, cargas de los 29 indicadores (con su pregunta), ajuste de los AFC, confiabilidad y validez |
| F4 · Invarianza | H2, medias latentes con IC 95 % (BRR), secuencia de invarianza y DIF de los bienes por comparación |
| F5 · Competencias | H8 (1 frente a 4 dimensiones), puntajes propios (V1-V3, confiabilidad), H7 (mapa de correlaciones), P3, H4 y DIF (H3) |
| F6 · Modelo estructural | **diagrama interactivo** (indicadores con su carga → 2 factores con su correlación → 4 competencias), coeficientes, H5, H6 y robustez (SEM latente, puntajes propios, ajuste) |
| F7 · Robustez y hallazgos | matriz candidato × sensibilidad y robustez de K1-K5 |
| Puntaje esperado | formulario de perfil → puntaje esperado de las 4 competencias, con su advertencia |

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
│   └── paginas.py         # una función por página
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
