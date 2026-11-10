# Tablero PISA 2022 Colombia (F8, paso 8.4)

Tablero en Streamlit que **consume la API** (`Proyecto_PISA/api`). No lee archivos ni estima nada: cada cifra viene de
un endpoint, y cada página dice de qué archivo de `salidas/` y de qué decisión del registro sale.

## Páginas

| Página | Qué muestra | Endpoint |
|---|---|---|
| Resumen | decisión de H1 a H8 y robustez de los candidatos de la F7 | `/v1/hipotesis`, `/v1/robustez` |
| NSE e invarianza | diferencias de medias latentes del NSE con IC 95 % (BRR) y la secuencia de invarianza, por comparación | `/v1/invarianza/{analisis}` |
| DIF por competencia | ΔMH de los ítems dicotómicos con los cortes del ETS; ítems con DIF resaltados | `/v1/dif` |
| Modelo estructural | coeficiente del NSE (económico y libros) por competencia con IC 95 %, e interacciones de H6 | `/v1/modelo/coeficientes`, `/v1/modelo/interacciones` |
| Puntaje esperado | formulario de perfil → puntaje esperado de las 4 competencias, con su advertencia | `POST /v1/modelo/prediccion` |

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

- Despliegue en Render (un servicio para la API y otro para el tablero, con `PISA_API_URL` apuntando a la API).
- Revisión de Brayan (responsable de la F8).

## Uso de herramientas de IA

Código escrito por **Claude Code (Claude Opus 5.5)** por encargo de Vanessa Acosta el 2026-11-09, con las buenas
prácticas del curso de Python para APIs y la guía de visualización de datos de Claude (paleta, marcas, tooltip y tabla
por gráfico). Vanessa decidió hacer el tablero en Streamlit sobre la API (plan 8.4, D-46). Brayan lo revisa y lo
continúa; cada integrante debe poder explicar cada línea en la sustentación.
