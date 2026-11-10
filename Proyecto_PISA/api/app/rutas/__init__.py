"""Rutas de la API, una por área del proyecto.

Los endpoints usan ``def`` (no ``async def``): SQLAlchemy con SQLite es síncrono y, dentro de una corrutina,
bloquearía el bucle de eventos. FastAPI ejecuta las funciones ``def`` en un hilo aparte.
"""
