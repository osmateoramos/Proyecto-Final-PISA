# Proyecto Final PISA

**Nivel socioeconómico latente y desempeño matemático por competencias en PISA 2022 (Colombia)**

Vanessa Acosta · Mateo Ramos · Brayan David Barreto — Consultoría Estadística, Universidad Santo Tomás, 2026-II
Proyecto integrador: Teoría de Respuesta al Ítem · Ecuaciones Estructurales · Python para APIs e IA

---

## Qué hay en este repositorio

```
├── README.md                ← esta guía
├── CLAUDE.md                ← reglas para el asistente de IA (veracidad, idioma, datos)
├── Vault_PISA2022/          ← notas del proyecto en Obsidian (fuente de verdad)
├── Proyecto_PISA/           ← proyecto actual
│   ├── anteproyecto/        ← anteproyecto vigente (.Rmd, .pdf, referencias.bib, apa.csl)
│   ├── datos/               ← SOLO scripts .R; los datos de PISA no se suben (ver abajo)
│   ├── documentacion/       ← anexo A del Technical Report 2022 (clasificación de ítems), rúbrica
│   ├── scripts/ · salidas/ · informe/ · api/
│   └── Proyecto_PISA.Rproj
```

Empezar por `Vault_PISA2022/00 Inicio.md` (en Obsidian) y por el anteproyecto en `Proyecto_PISA/anteproyecto/`.

## Primera vez (solo una)

1. **Descargar el repositorio.** Instalar GitHub Desktop (gratis, https://desktop.github.com), iniciar sesión con la
   cuenta de GitHub y luego *File → Clone repository* → elegir `Proyecto-Final-PISA` → escoger una carpeta local.
2. **Descargar los datos de PISA 2022** (no están en el repositorio: pesan varios GB y son datos de menores).
   Desde el servidor oficial de la OCDE:
   - https://webfs.oecd.org/pisa2022/STU_QQQ_SPSS.zip — cuestionario de estudiantes (≈ 682 MB)
   - https://webfs.oecd.org/pisa2022/STU_COG_SPSS.zip — ítems cognitivos (≈ 481 MB)
   - https://webfs.oecd.org/pisa2022/SCH_QQQ_SPSS.zip — cuestionario de colegios (≈ 6 MB)

   Descomprimir los tres en `Proyecto_PISA/datos/`. Deben quedar `CY08MSP_STU_QQQ.SAV`, `CY08MSP_STU_COG.SAV` y
   `CY08MSP_SCH_QQQ.SAV`.
3. **Instalar las versiones de los paquetes del proyecto** (R 4.4.1, con RStudio cerrado). Las versiones están en
   `Proyecto_PISA/scripts/versiones_paquetes.csv`, para que los tres corran todo con las mismas:
   ```
   & "C:\Program Files\R\R-4.4.1\bin\Rscript.exe" Proyecto_PISA\scripts\00_verificar_entorno.R --instalar
   ```
   Después, cada vez que se abre `Proyecto_PISA.Rproj` en RStudio, la consola avisa si alguna versión no coincide.
4. **Crear los cachés de Colombia** (unos minutos, solo la primera vez):
   ```
   & "C:\Program Files\R\R-4.4.1\bin\Rscript.exe" Proyecto_PISA\datos\revision_pisa2022_col.R
   ```
5. **Abrir el vault:** en Obsidian, *Abrir carpeta como vault* → `Vault_PISA2022`. Cuando pregunte por los
   complementos de la comunidad, activarlos (Dataview, ZotLit y Git ya vienen configurados).
6. **Referencias:** unirse al grupo de Zotero del proyecto (lo comparte Mateo) para ver la colección *Proyecto PISA*.

## Flujo de trabajo de todos los días

| Momento | Qué hacer en GitHub Desktop | Para qué |
|---|---|---|
| Al empezar | **Fetch origin → Pull origin** | Traer los cambios de los demás |
| Mientras trabajan | Nada: escribir notas, correr scripts, editar el anteproyecto | — |
| Al terminar | Escribir un resumen corto y **Commit to main**, luego **Push origin** | Guardar y subir los cambios |

- Si dos personas cambian **las mismas líneas** sin hacer *pull* antes, GitHub Desktop muestra un **conflicto** y
  pide elegir qué versión queda. Para evitarlo: *pull* al empezar y repartirse las notas o secciones.
- Si no estás seguro de algo, **no fuerces nada**: avisa al equipo antes de resolver un conflicto.
- Con tres personas: cada quien trabaja en sus notas y scripts, y nadie edita el mismo archivo que otro al mismo tiempo.

## Reglas del proyecto

1. **Nunca subir datos de estudiantes** ni resultados individuales (Ley 1581 de 2012). El `.gitignore` ya excluye los
   `.SAV`, los `.rds` y toda la carpeta `Proyecto_PISA/datos/` salvo los scripts.
2. **Toda cifra** que vaya al documento debe salir de un script del repositorio.
3. **Toda afirmación de una fuente** debe tener su nota en `Vault_PISA2022/Literatura/` con página y estado
   (ver `Vault_PISA2022/11 Protocolo de verificación.md`). Solo un integrante del equipo marca algo como `verificado`.
4. **Toda decisión metodológica** se registra en `Vault_PISA2022/03 Registro de decisiones.md` antes de programarla.

## Generar el PDF del anteproyecto

Abrir `Proyecto_PISA/anteproyecto/anteproyecto_VanessaAcosta_MateoRamos.Rmd` en RStudio y pulsar **Knit**
(requiere TinyTeX o MiKTeX con XeLaTeX).
