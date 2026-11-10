# syntax=docker/dockerfile:1
# Imagen del tablero (Streamlit) del Proyecto PISA 2022 Colombia (F8, paso 8.4). No contiene datos: los pide a la API.
#   docker build -t pisa-tablero Proyecto_PISA/tablero
#   docker run -p 8501:8501 -e PISA_API_URL=http://<api>:8000 pisa-tablero

FROM python:3.11.9-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PISA_API_URL=http://127.0.0.1:8000

WORKDIR /srv/tablero
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY app.py .
COPY pisa_tablero ./pisa_tablero

RUN useradd --create-home pisa && chown -R pisa /srv
USER pisa

EXPOSE 8501
CMD ["sh", "-c", "streamlit run app.py --server.address 0.0.0.0 --server.port ${PORT:-8501} --server.headless true --browser.gatherUsageStats false"]
