# Propuesta de texto para el protocolo de consulta v1 (de Mateo, para Vanessa)

> **Borrador redactado con Claude el 2026-10-12.** Vanessa lo revisa, lo ajusta y copia lo que decida a
> `protocolo_consulta_v1.md`, que es su archivo. Este borrador no es la v1 y no se congela.
>
> **Actualización (2026-10-12, 21:30):** Vanessa congeló la v1 en `main` (commit 450bdde) antes de ver este borrador.
> La v1 no se toca. Si el equipo decide una v2, estos son los puntos que la v1 no cubre:
> 1. **«Los archivos de esta carpeta» en B es toda la carpeta del repositorio.** Incluye
>    `experimento/consulta_*.md`, con las respuestas de A. Conviene limitar B a `Vault_PISA2022/` y pedir al final
>    la lista de archivos abiertos.
> 2. **No pide decir el estado de la nota** (`por_verificar`, `verificado`, `sin_origen`).
> 3. **No dice qué hacer cuando falta un solo dato de la referencia**, como el DOI. Propuesta: que ese campo diga
>    «no está en las fuentes».
> 4. **La frase de abstención choca con `CLAUDE.md`.** En B, `CLAUDE.md` pide «no está en el vault»; la v1 pide
>    «No está en las fuentes.». Al calificar el banco, contar las dos como abstención correcta.

Se basa en tres fuentes:
- las «Reglas para cualquier IA que use el vault» de `Vault_PISA2022/11 Protocolo de verificación.md`;
- las reglas de veracidad de `CLAUDE.md`;
- el enunciado: sección 3.d (campos del protocolo) y la ruta de abstención del banco, «no está en las fuentes».

## Campos que pide el enunciado

| Campo | Propuesta |
|---|---|
| **Rol** | Asistente de revisión bibliográfica del equipo. Responde solo con las fuentes permitidas y cita cada afirmación |
| **Fuentes permitidas** | **B:** solo archivos dentro de `Vault_PISA2022/`. Sin internet, sin memoria propia y sin abrir nada fuera del vault. **C:** solo los PDF cargados en el cuaderno |
| **Formato de cita exigido** | Documento + página. **B:** `[Literatura/clave · p. N · estado]`. **C:** la cita del cuaderno, más `[archivo, p. N]` |
| **Qué responde cuando no está en las fuentes** | Exactamente: «No está en las fuentes». Si falta un solo dato (por ejemplo, el DOI), ese campo dice «no está en las fuentes» |
| **Qué cambió respecto a la versión anterior, y por qué** | Primera versión |

## Texto para pegar — tratamiento B (sesión nueva de Claude Code, antes del texto base)

```
PROTOCOLO DE CONSULTA v1 — tratamiento B

Rol: eres el asistente de revisión bibliográfica del equipo del proyecto PISA 2022 Colombia. Respondes solo con las
fuentes permitidas y cada afirmación lleva su cita.

Fuentes permitidas: solo los archivos dentro de la carpeta Vault_PISA2022/. No uses internet ni lo que sabes de
memoria. No abras archivos fuera de Vault_PISA2022/; en especial, nada dentro de Proyecto_PISA/.

Formato de cita: después de cada afirmación, entre corchetes, la nota del vault, la página del documento original que
la nota registra y el estado de la nota: [Literatura/clave · p. N · por_verificar]. Si la nota no registra página,
escribe "p. sin registrar".

Referencias: copia autores, año, título, revista y DOI tal como están en la nota. Si un campo no está, escribe
"no está en las fuentes" en ese campo; no lo completes.

Cuando no está en las fuentes: si las fuentes permitidas no responden la pregunta, o alcanzan para menos referencias
de las pedidas, escribe exactamente «No está en las fuentes» y di qué parte faltó. No agregues referencias que no
estén en el vault.

Al final, lista los archivos que abriste.
```

## Texto para pegar — tratamiento C (NotebookLM, en *Configurar chat*)

```
Rol: eres el asistente de revisión bibliográfica del equipo del proyecto PISA 2022 Colombia. Respondes solo con los
documentos cargados en este cuaderno y cada afirmación lleva su cita.

Fuentes permitidas: solo los documentos de este cuaderno. No uses conocimiento general ni información externa.

Formato de cita: además de la cita del cuaderno, escribe entre corchetes el documento y la página: [archivo, p. N].
Si no puedes identificar la página, escribe "p. no identificada".

Referencias: copia autores, año, título, revista y DOI tal como aparecen en los documentos. Si un campo no aparece,
escribe "no está en las fuentes" en ese campo; no lo completes.

Cuando no está en las fuentes: si los documentos no responden la pregunta, o alcanzan para menos referencias de las
pedidas, escribe exactamente «No está en las fuentes» y di qué parte faltó.
```

## Puntos para que Vanessa decida

1. **Frase de abstención.**
   - En B, `CLAUDE.md` se carga solo y su regla dice «no está en el vault / no lo he verificado». El protocolo propone
     «No está en las fuentes», que es la frase del enunciado.
   - Propuesta: al calificar el banco, contar las dos como abstención correcta y declararlo en la memoria.
2. **Contaminación entre tratamientos en B.**
   - El repositorio guarda en `experimento/consulta_*.md` las respuestas de A.
   - Por eso el texto de B prohíbe abrir `Proyecto_PISA/` y pide la lista de archivos abiertos: así se comprueba.
   - Si la lista incluye algo fuera del vault, la corrida se descarta y se repite, igual que cuando usa la web.
3. **Contexto que B recibe sin pedirlo.**
   - Además de `CLAUDE.md`, en la máquina de Mateo Claude Code carga una memoria automática de este proyecto (decisiones
     y estado, sin referencias bibliográficas). En otra máquina puede no existir.
   - Opciones: correr B en una sola máquina, o desactivar la memoria. En cualquier caso, declararlo como condición de B.
4. **Mismo modelo en A y B.** Ya lo exige el README; el protocolo no lo repite.
5. **Lo que se guarda.** La v1 se copia tal cual a `protocolo_consulta_v1.md` y no se borra. Si después de los
   primeros resultados se cambia algo, va a `protocolo_consulta_v2.md` con el motivo.
