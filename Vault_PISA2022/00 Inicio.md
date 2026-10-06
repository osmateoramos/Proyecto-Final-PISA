# Proyecto PISA 2022 Colombia — NSE latente y competencias matemáticas

Vanessa Acosta · Mateo Ramos · Consultoría Estadística USTA 2026-II
Proyecto integrador: Teoría de Respuesta al Ítem · Ecuaciones Estructurales · Python para APIs e IA

## Por dónde empezar

1. [[11 Protocolo de verificación]] — cómo se marca qué está verificado y qué no (leer primero).
2. [[06 Objetivos PISA 2022]] — pregunta, objetivo general y O1–O5.
3. [[07 Plan de desarrollo PISA 2022]] — paso a paso por semanas. **Estamos en la semana 1:** F0 casi cerrada
   (falta congelar las hipótesis, paso 0.5) y sigue F1 (datos y ETL).

## Notas del proyecto

- **Anteproyecto vigente:** `Proyecto_PISA/anteproyecto/anteproyecto_VanessaAcosta_MateoRamos.pdf`
  (fuente `.Rmd` y `referencias.bib` en la misma carpeta; 15 marcas [VERIFICAR] por revisar antes de entregar; ver [[13 Revisión de literatura]])
- [[03 Registro de decisiones]] — toda decisión, con fecha y razón (D-01 a D-09)
- [[08 Rúbrica de desarrollo]] — cómo autoevaluarse, puertas de fase y criterio de hallazgo innovador
- [[09 Hipótesis preregistradas]] — H1–H8, se congelan antes de modelar
- [[10 Gestión de la información]] — Zotero + Obsidian, instalación y reglas
- [[12 Guía de Zotero]] — qué hace Zotero, el ciclo de una fuente y cómo compartir con un grupo
- [[13 Revisión de literatura]] — revisión del 2026-10-05: qué se quitó, qué se comprobó y qué se agregó
- [[14 Libros de TRI y SEM]] — qué leer de de Ayala y de Chen y Yung en cada fase, y mejoras propuestas al plan
- [[Literatura/Matriz estado del arte]] — antecedentes vs este proyecto (cada fila enlaza a su nota de fuente)
- [[Literatura/_Léeme]] — todas las fuentes con su estado de verificación
- [[Datos/PISA2022 - Diccionario de variables]] — variables de PISA 2022 que usa el proyecto (etiquetas oficiales)
- Proyecto: `CONSULTORIA/Proyecto_PISA/` — anteproyecto, datos (`revision_pisa2022_col.R` y cachés de Colombia),
  scripts, salidas, informe, API y documentación.

## Carpetas

- `Literatura/` — una nota por fuente (ZotLit o `Plantillas/Nota de lectura`)
- `Reuniones/` — una nota por reunión con tutores o entre ustedes
- `Datos/` — diccionario de variables de PISA 2022
- `Plantillas/` — nota de lectura y nota de dato

## Reglas del vault

Las reglas completas están en [[11 Protocolo de verificación]]; las que sigue Claude, en `CONSULTORIA/CLAUDE.md`.

1. Una idea = una nota. Se enlazan con `[[doble corchete]]`.
2. Toda cifra que vaya al informe se anota con el script que la produce.
3. Toda decisión va a [[03 Registro de decisiones]] antes de programarla.
4. Los datos y los scripts NO viven aquí: viven en `Proyecto_PISA/`. Aquí se enlazan.
5. Nada de datos individuales de estudiantes en el vault (Ley 1581 de 2012).
