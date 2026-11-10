# API PISA 2022 Colombia (F8)

Servicio web que expone los **resultados agregados** del proyecto (F3 a F7): medición e invarianza del NSE, ítems y
DIF de matemáticas, modelo estructural por competencia, decisión de las hipótesis y robustez. La API **solo lee**
resultados ya estimados en R (`Proyecto_PISA/salidas/`); nunca estima ni expone datos por estudiante (Ley 1581 de 2012).
Diseño registrado en D-46 (`Vault_PISA2022/03 Registro de decisiones.md`).

## Estructura

```
api/
├── app/
│   ├── main.py          # aplicación FastAPI, ciclo de vida, /health y manejo del 422
│   ├── config.py        # configuración por variables de entorno (prefijo PISA_) o .env
│   ├── db.py            # motor y sesiones de SQLAlchemy 2.0
│   ├── tablas.py        # tablas (ORM), una por archivo de salidas/
│   ├── esquemas.py      # contratos Pydantic v2: filas de los CSV y respuestas
│   ├── carga.py         # salidas/*.csv → validación → SQLite  (python -m app.carga)
│   ├── prediccion.py    # ModeloF6: Singleton con los coeficientes de la F6
│   ├── registro.py      # logging y decorador de auditoría
│   └── rutas/           # endpoints por área (nse, matematicas, modelo, hipotesis)
├── tests/               # pytest + TestClient sobre los salidas/ reales
├── requirements.txt     # dependencias de ejecución (pip freeze, Python 3.11.9)
├── requirements-dev.txt # + pytest y httpx
├── Dockerfile           # imagen python:3.11.9-slim (se construye desde Proyecto_PISA/)
└── .env.example         # plantilla de configuración (el .env real no se sube)
```

## Puesta en marcha (Windows, PowerShell)

Requiere **Python 3.11.9** (en Windows se elige con `py -3.11`, sin cambiar el Python por defecto).

```powershell
cd Proyecto_PISA/api
py -3.11 -m venv .venv
.venv\Scripts\activate
pip install -r requirements-dev.txt
python -m app.carga                 # crea pisa_resultados.db desde ../salidas (valida todas las filas)
uvicorn app.main:app --reload       # desarrollo: http://127.0.0.1:8000/docs
```

Si `salidas/` cambia (por ejemplo, después de correr `scripts/00_correr_todo.R`), hay que repetir `python -m app.carga`.

## Endpoints (v1)

| Método | Ruta | Qué devuelve | Fuente |
|---|---|---|---|
| GET | `/health` | estado del servicio y fecha de carga | — |
| GET | `/v1/nse/items` | 29 indicadores del NSE y su factor | `nse_estructura_afe.csv` (D-24) |
| GET | `/v1/invarianza/{analisis}` | secuencia de invarianza y medias latentes con BRR (`zona`, `H2_rural_urbana`, `sexo`, `sector`) | `invarianza_tabla.csv`, `nse_medias_latentes_brr.csv` (D-25, D-34) |
| GET | `/v1/matematicas/items` | ítems y parámetros internacionales; filtros `competencia`, `solo_calibrables` | `items_competencia.csv` (D-27) |
| GET | `/v1/dif` | DIF por NSE; filtros `competencia`, `solo_con_dif` | `mat_dif.csv` (D-40) |
| GET | `/v1/modelo/coeficientes` | coeficientes de la F6 con error BRR; filtro `competencia` | `sem_coeficientes.csv` (D-42) |
| GET | `/v1/modelo/interacciones` | pendiente del NSE por zona o sector (H6); filtro `grupo` | `sem_h6_interacciones.csv` (D-42) |
| POST | `/v1/modelo/prediccion` | puntaje esperado de las 4 competencias para un perfil | `sem_coeficientes.csv` (D-46) |
| GET | `/v1/hipotesis` | decisión de H1 a H8 | archivo de cada hipótesis |
| GET | `/v1/hipotesis/{codigo}` | decisión de una hipótesis (404 si no existe) | ídem |
| GET | `/v1/robustez` | robustez de los candidatos de la F7 | `f7_robustez.csv` (D-45) |

Ejemplo de predicción:

```json
POST /v1/modelo/prediccion
{"nse_economico": 1.0, "nse_libros": 0.0, "sexo": "Mujer", "grado": 0}
```

El puntaje esperado es una **media condicional** del modelo principal de la F6: no es el puntaje de una persona ni un
efecto causal, y no lleva intervalo (la covarianza de los coeficientes no se exporta). Una entrada fuera de rango
(NSE fuera de [−4, 4], sexo distinto de `Mujer`/`Hombre`, grado fuera de −3…1, campos de más o `NaN`) responde 422 con
todos los errores.

## Pruebas, imagen e integración continua

```powershell
python -m pytest                                  # 33 pruebas con los datos reales de salidas/
docker build -f api/Dockerfile -t pisa-api .      # desde Proyecto_PISA/
docker run -p 8000:8000 pisa-api
```

`.github/workflows/api.yml` corre las pruebas con Python 3.11.9 y construye la imagen en cada push que toque la API o
`salidas/`. La imagen solo recibe `api/app`, `api/requirements.txt` y `salidas/*.csv` (ver `Dockerfile.dockerignore`).

## Pendiente (F8)

- Tablero (Streamlit) que consuma esta API (paso 8.4).
- Despliegue en Render con la imagen de Docker y URL pública.
- RAG opcional (paso 8.5, D-04 y D-06).
- La imagen de Docker no se ha construido en este equipo (Docker no está instalado); su primera prueba es la
  integración continua.

## Uso de herramientas de IA

El código de esta carpeta lo escribió **Claude Code (Claude Opus 5.5)** por encargo de Vanessa Acosta, el 2026-11-09,
siguiendo las buenas prácticas del curso de Python para APIs. Vanessa decidió el stack, la persistencia en SQLite, el
endpoint de predicción y la rama (D-46). Claude escribió los módulos, las pruebas, el Dockerfile y la integración
continua, y los probó en este equipo con Python 3.11.9 (33 pruebas pasan; el servidor responde con uvicorn). Brayan,
responsable de la F8, revisa y continúa el código. El detalle está en `Vault_PISA2022/15 Bitácora de uso de IA.md`.
Cada integrante debe poder explicar cada línea en la sustentación.
