# Nada sin fuente — carpeta de trabajo del equipo

Actividad de Consultoría (30 % del corte). Enunciado: `Proyecto_PISA/documentacion/Enunciado_Nada_sin_fuente.html`.
Se entrega **todo** de una vez, con sustentación. Equipo de tres: Vanessa, Mateo y Brayan.

## Decisiones fijadas

- **Tratamientos del experimento:**
  - **A** = Claude sin contexto (chat normal, control);
  - **B** = Zotero + Obsidian (Claude respondiendo solo con el vault);
  - **C** = NotebookLM con los PDF del corpus.
- **Vía empaquetada:** la nota máxima de C3 es Competente, así que la global queda topada en 4,8 (regla 4).
- **Sin auditoría cruzada:** se declara en la memoria.
- **Sin datos de contraparte:** el corpus es 100 % público; el acta no aplica y se declara.
- **Desvío frente al enunciado:** no hay tratamiento de buscador bibliográfico. La memoria lo declara: el experimento
  mide **anclaje** (A frente a dos vías de contexto cerrado), no búsqueda.

## Reglas para trabajar en paralelo

1. **Cada quien edita solo sus archivos** (`*_Brayan`, `*_Mateo`, `*_Vanessa`). Los consolidados los generan los
   scripts; no se editan a mano.
2. Cada quien trabaja en su rama. En cada punto de sincronización (S1–S5) se hace un Pull Request a `main`, aprobado
   por otro integrante. Antes de seguir: *Fetch* → *Pull* de `main`.
3. **Clasificación ciega:**
   - no abrir `experimento/clave_referencias.csv` ni la tabla de clasificación de la nota 16 antes de terminar la
     clasificación propia;
   - no comentar las clasificaciones entre ustedes hasta que los tres hayan terminado.
4. **CSV:** se abren con Excel y se guardan con *Guardar como → CSV UTF-8*. Los scripts aceptan `;` o `,` y avisan si
   el archivo quedó en ANSI.
5. Los **PDF del corpus** van en `corpus/{clave_bib}.pdf` y en el grupo de Zotero, **nunca en Git**.
6. Cada sesión de IA va a la bitácora (`Vault_PISA2022/15 Bitácora de uso de IA.md`), con qué se corrigió.
7. Solo un integrante marca algo como `verificado`, y solo después de abrir el documento original. La nota del vault
   también está `por_verificar`: no sirve como evidencia.

## Cómo se corre cada tratamiento (igual para los tres integrantes)

Texto base, el mismo en A, B y C:

> {consulta}. Dame al menos cinco referencias (autores, año, título, revista y DOI) y, para cada una, qué encontró
> sobre el tema.

| | Dónde | Qué se pega | Cuidado |
|---|---|---|---|
| **A** | Chat nuevo de Claude, **sin proyecto** y **sin búsqueda web** | Solo el texto base | Anotar el modelo y la versión. Debe ser el mismo modelo que en B |
| **B** | Sesión **nueva** de Claude Code (app de escritorio, pestaña Code) abierta en la carpeta **`Vault_PISA2022`**, no en la raíz del repositorio. El `CLAUDE.md` de la raíz se carga igual | Texto de `protocolo/protocolo_consulta_v1.md` + texto base | La v1 dice «los archivos de esta carpeta»: abrir la sesión en el vault hace que esa carpeta sea solo el vault y no `Proyecto_PISA/`, donde están las respuestas de A. Si pide permiso para buscar en internet o para leer fuera del vault, **negar**; si lo hizo, descartar y repetir |
| **C** | Cuaderno compartido de NotebookLM con los PDF del corpus. Protocolo v1 en *Configurar chat* | Texto base | Anotar cuántas fuentes tenía el cuaderno ese día |

De cada respuesta:
- pegar el prompt y la respuesta completa en `experimento/consulta_{persona}.md`;
- pasar al menos 5 referencias por tratamiento a `experimento/referencias_{persona}.csv`, con la afirmación que la
  herramienta les atribuye.

## Reparto (cada bloque en paralelo; no se pasa al siguiente sin su sincronización)

| Bloque | Vanessa | Mateo | Brayan |
|---|---|---|---|
| **0 Arranque** | PR de su rama a `main`; compartir NotebookLM; **protocolo v1** | Importar 12 referencias a Zotero y mandar 2 a la papelera; invitar a Brayan y Vanessa; escribir su consulta (O1–O2) | Esta carpeta, plantillas y scripts; escribir su consulta (O4) |
| **S1** | | | carpeta en `main` · protocolo v1 congelado · 3 consultas escritas · accesos listos |
| **1 Consultas y corpus** | Inventario · su consulta en A y B, y C de nuevo con el corpus completo · PDF de DIF y desenganche | Inventario · su consulta en A, B y C · PDF del NSE y del planteamiento | Inventario · su consulta en A, B y C · PDF de econométrico, competencias y metodología |
| **S2** | | | 3 archivos `referencias_*.csv` en `main` → Brayan corre `nsf_unir_referencias.R` |
| **2 Clasificación y trazabilidad** | Clasificar a ciegas · `trazabilidad_Vanessa.csv` | Clasificar a ciegas · `trazabilidad_Mateo.csv` · completar `corpus/procedencia.csv` | Clasificar a ciegas · `trazabilidad_Brayan.csv` · correr `nsf_experimento.R` |
| **S3** | | | clasificaciones y trazabilidad en `main` · tablas `salidas/nsf_*.csv` |
| **3 Banco y decisión** | 6 preguntas en A, B y C · **caso de fallo** · protocolo v2 si hace falta | 6 preguntas en A, B y C · aplicar correcciones al anteproyecto | 6 preguntas en A, B y C · **tabla de decisión** · `nsf_evaluacion.R` |
| **S4** | | | banco (18 preguntas: 15 dentro del corpus + 3 fuera), resultados y decisión en `main` |
| **4 Documentos y ensayo** | Memoria §1 (diagnóstico) | Memoria §3 (sistema) y §5 (correcciones) · *Knit* de la memoria | Experimento y decisión (2 págs.) · memoria §2 y §4 |
| **S5** | | | PDF en `main` · ensayo · cada uno opera el sistema solo |

Exposición de 10 minutos:
- 0–2′ diagnóstico (Vanessa);
- 2–5′ experimento y decisión (Brayan);
- 5–8′ sistema funcionando (Mateo);
- 8–10′ límites (los tres).

Cada uno debe poder responder sobre la parte de los otros.

## Archivos

| Pieza (lista final del enunciado) | Archivo |
|---|---|
| Inventario de fallos (uno por integrante) | `inventarios/inventario_{persona}.md` |
| Consultas y respuestas completas | `experimento/consulta_{persona}.md` |
| Referencias de cada consulta | `experimento/referencias_{persona}.csv` |
| Hoja ciega y clave | `experimento/hoja_ciega.csv`, `experimento/clave_referencias.csv` (generados) |
| Clasificación de cada integrante | `experimento/clasificacion_{persona}.csv` |
| Conteos, proporciones con IC y desacuerdo | `../salidas/nsf_conteos.csv`, `nsf_proporciones.csv`, `nsf_diferencias.csv`, `nsf_acuerdo.csv` |
| Tabla de decisión | `tabla_decision.md` |
| README de procedencia | `corpus/README_procedencia.md` (generado desde `corpus/procedencia.csv`) |
| Tabla de trazabilidad | `trazabilidad/trazabilidad_{persona}.csv` → `trazabilidad/trazabilidad.md` (generado) |
| Protocolo versionado | `protocolo/protocolo_consulta_v1.md` (v2 si cambia; la v1 no se borra) |
| Banco de evaluación | `evaluacion/banco_{persona}.csv` → `../salidas/nsf_banco_por_tratamiento.csv` |
| Caso de fallo | `evaluacion/caso_fallo.md` |
| Experimento y decisión (2 págs.) | `experimento_decision.Rmd` → PDF |
| Memoria (2–4 págs.) | `memoria.Rmd` → PDF |

## Scripts (desde `Proyecto_PISA/scripts/`)

```
& "C:\Program Files\R\R-4.4.1\bin\Rscript.exe" nsf_unir_referencias.R      # S2: hoja ciega y hojas de clasificación
& "C:\Program Files\R\R-4.4.1\bin\Rscript.exe" nsf_experimento.R           # S3: conteos, IC de Wilson, acuerdo
& "C:\Program Files\R\R-4.4.1\bin\Rscript.exe" nsf_trazabilidad.R unir     # S3: trazabilidad.md y resumen
& "C:\Program Files\R\R-4.4.1\bin\Rscript.exe" nsf_procedencia.R           # cuando cambie el corpus
& "C:\Program Files\R\R-4.4.1\bin\Rscript.exe" nsf_evaluacion.R            # S4: fidelidad por tratamiento
```

- `nsf_trazabilidad.R preparar` ya se corrió: creó las tres hojas de trazabilidad con una fila por oración citada del
  anteproyecto.
- La columna `ubicacion_sugerida` es solo una **pista** que viene de la nota del vault: hay que abrir el PDF y anotar
  la ubicación real.

## Arrancar el sistema en menos de 60 segundos (sustentación)

- **B:** abrir Claude (pestaña Code) en la carpeta del repositorio, sesión nueva, pegar el protocolo v1 y la pregunta.
- **C:** abrir el cuaderno compartido de NotebookLM; el protocolo ya está en *Configurar chat*.
- **"Reindexar":**
  - B no tiene índice: lee los archivos del vault tal como están (`git pull` y sesión nueva);
  - en C, se quita y se vuelve a subir una fuente, o se crea el cuaderno desde `corpus/`.
