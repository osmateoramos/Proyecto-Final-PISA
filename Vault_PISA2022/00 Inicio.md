# Proyecto PISA 2022 Colombia — NSE latente y procesos matemáticos

Vanessa Acosta · Mateo Ramos · Consultoría Estadística USTA 2026-II
Proyecto integrador: Teoría de Respuesta al Ítem · Ecuaciones Estructurales · Python para APIs e IA

## Etapa 2 — PISA 2022 (actual)

- [[06 Objetivos PISA 2022]] — pregunta, objetivo general y O1–O5
- **Anteproyecto vigente (PISA 2022):** `Proyecto_PISA/anteproyecto/anteproyecto_VanessaAcosta_MateoRamos.pdf`
  (fuente `.Rmd` y `referencias.bib` en la misma carpeta; 8 marcas [VERIFICAR] por revisar antes de entregar)
- [[07 Plan de desarrollo PISA 2022]] — paso a paso por semanas, desde la limpieza hasta la API
- [[08 Rúbrica de desarrollo]] — cómo autoevaluarse, puertas de fase y criterio de hallazgo innovador
- [[09 Hipótesis preregistradas]] — H1–H6, se congelan antes de modelar
- [[10 Gestión de la información]] — Zotero + Obsidian, instalación y reglas
- [[11 Protocolo de verificación]] — **empezar aquí**: cómo se marca qué está verificado y qué no
- [[12 Guía de Zotero]] — qué hace Zotero, el ciclo de una fuente y cómo compartir con un grupo
- [[13 Revisión de literatura]] — revisión del 2026-10-05: qué quitar, qué se comprobó, qué agregar y cambios propuestos al anteproyecto
- [[Literatura/Matriz estado del arte]] — antecedentes vs este proyecto (cada fila enlaza a su nota de fuente)
- [[Literatura/_Léeme]] — las 38 fuentes con su estado de verificación
- [[Datos/PISA2022 - Diccionario de variables]] — variables de PISA 2022 que usa el proyecto (etiquetas oficiales)
- [[03 Registro de decisiones]] — toda decisión, con fecha y razón (desde D-11 corresponde a PISA)
- Proyecto: `CONSULTORIA/Proyecto_PISA/` — anteproyecto vigente, datos (`revision_pisa2022_col.R` y cachés de Colombia),
  scripts, salidas, informe, API y documentación. La etapa con Saber 11 está archivada en `CONSULTORIA/Etapa1_Saber11/`.

## Etapa 1 — Saber 11 (archivo)

Primer corte y trabajo hasta el 29/09, cuando se decidió cambiar de fuente (D-11). Se conserva como antecedente.

- [[01 Plan paso a paso]] — plan original sobre Saber 11 (los pasos de Git en 0.2 siguen vigentes)
- [[02 Clasificación de ítems (TRI)]] — clasificación del cuestionario de Saber 11
- [[04 Pendientes del primer corte]] — correcciones al anteproyecto
- [[05 Mapa teoría → proyecto]] — conceptos de TRI y SEM (sigue siendo útil para PISA)
- [[Datos/Saber11 - Variables originales ICFES]] y [[Datos/Saber11 - Diccionario de variables recodificadas]] — variables de Saber 11 (archivo)

## Carpetas

- `Literatura/` — una nota por fuente (ZotLit o `Plantillas/Nota de lectura`)
- `Reuniones/` — una nota por reunión con tutores o entre ustedes
- `Datos/` — diccionarios de variables

## Reglas del vault

Las reglas completas están en [[11 Protocolo de verificación]]; las que sigue Claude, en `CONSULTORIA/CLAUDE.md`.

1. Una idea = una nota. Se enlazan con `[[doble corchete]]`.
2. Toda cifra que vaya al informe se anota con el script que la produce.
3. Toda decisión va a [[03 Registro de decisiones]] antes de programarla.
4. Los datos y los scripts NO viven aquí: viven en `datos/` y `Proyecto_PISA/`. Aquí se enlazan.
5. Nada de datos individuales de estudiantes en el vault (Ley 1581 de 2012).
