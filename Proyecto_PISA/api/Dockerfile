# syntax=docker/dockerfile:1
# Imagen de la API PISA 2022 Colombia (F8, D-46).
# Se construye desde Proyecto_PISA/ porque necesita los CSV de salidas/:
#   docker build -f api/Dockerfile -t pisa-api .
#   docker run -p 8000:8000 pisa-api
# Solo entran api/app, api/requirements.txt y salidas/*.csv (ver api/Dockerfile.dockerignore): ningún dato de datos/.

FROM python:3.11.9-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PISA_CARPETA_SALIDAS=/srv/salidas \
    PISA_URL_BASE_DATOS=sqlite:////srv/pisa_resultados.db

WORKDIR /srv/api
COPY api/requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY api/app ./app
COPY salidas/*.csv /srv/salidas/

# La base se construye y se valida al construir la imagen: si una salida no cumple su esquema, la imagen no se crea
RUN python -m app.carga

RUN useradd --create-home pisa && chown -R pisa /srv
USER pisa

EXPOSE 8000
# Render (y otras plataformas) pasan el puerto en $PORT
CMD ["sh", "-c", "uvicorn app.main:app --host 0.0.0.0 --port ${PORT:-8000}"]
