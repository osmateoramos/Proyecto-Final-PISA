# Instrucciones para Claude — Proyecto PISA 2022 Colombia

Equipo: Vanessa Acosta, Mateo Ramos y Brayan David Barreto · Consultoría Estadística USTA 2026-II
Cursos integrados: Teoría de Respuesta al Ítem · Ecuaciones Estructurales · Python para APIs e IA

## Idioma
- Responder **siempre en español**, incluidos los mensajes intermedios mientras se trabaja.

## Fuente de verdad
- El vault `Vault_PISA2022/` es la única fuente de verdad del proyecto. Empezar por `00 Inicio.md`.
- Objetivos: `06 Objetivos PISA 2022.md` · Plan: `07 Plan de desarrollo PISA 2022.md` ·
  Protocolo de verificación: `11 Protocolo de verificación.md` · Decisiones: `03 Registro de decisiones.md`.
- Fuentes bibliográficas: una nota por fuente en `Vault_PISA2022/Literatura/` (con su estado).
- Proyecto actual: `Proyecto_PISA/` → `anteproyecto/` (documento vigente), `datos/` (PISA 2022 .SAV + cachés de
  Colombia + `revision_pisa2022_col.R`), `scripts/`, `salidas/`, `informe/`, `api/`, `documentacion/`.
- La única fuente de datos es PISA 2022 (decisión D-01). No hay material de otras etapas en esta carpeta.

## Reglas de veracidad (obligatorias)
1. **Toda cifra** se acompaña de su origen: script + archivo de salida, o fuente + página. Si la cifra no se
   comprobó en esta sesión, decirlo.
2. **Nunca inventar** cifras, citas, páginas, autores, años, DOI ni nombres de variables. Si algo no está en el
   vault, en los datos o en una fuente abierta en la sesión, responder "no está en el vault / no lo he verificado".
3. **Antes de afirmar algo de una fuente**, leer su nota en `Literatura/` y respetar su estado
   (`por_verificar`, `verificado`, `sin_origen`). Distinguir siempre si se leyó el texto completo o solo el resumen.
4. **Distinguir** dato (sale de los datos), fuente (sale de un documento) e interpretación (decisión del equipo).
5. **Si se detecta un error propio**, decirlo explícitamente y corregirlo en el vault.
6. **Claude nunca marca nada como `verificado`**: eso lo hace un integrante del equipo contra el original.
7. Las propiedades de estado y el procedimiento están en `Vault_PISA2022/11 Protocolo de verificación.md`.

## Datos y privacidad
- Ley 1581 de 2012: nunca exportar ni mostrar datos individuales de estudiantes; solo resultados agregados.
- No borrar archivos: si algo sobra, proponerlo y que el usuario lo elimine (la papelera de C: admite máx. 14.216 MB).
- No crear carpetas nuevas dentro de `Proyecto_PISA/datos/`; los cachés van como archivos `.rds` allí mismo.
- R 4.4.1: `C:\Program Files\R\R-4.4.1\bin\Rscript.exe`. Ejecutar con `Start-Process` desde PowerShell
  redirigiendo la salida a archivos; vía Bash no devuelve salida.
- Leer PISA solo con el bloque de Colombia: `haven::read_sav(col_select, skip, n_max)` (filas contiguas).

## Forma de trabajo
- El equipo está aprendiendo TRI y SEM: avanzar fase por fase según `07 Plan de desarrollo PISA 2022.md`,
  explicar el porqué de cada paso y no adelantar fases sin que lo pidan.
- Toda decisión metodológica va a `03 Registro de decisiones.md` antes de programarla.
- Las hipótesis de `09 Hipótesis preregistradas.md` no se cambian después de ver resultados sin dejarlo registrado.
