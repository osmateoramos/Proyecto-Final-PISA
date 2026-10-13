# Caso de fallo

Responsable: Vanessa (bloque 3). Es obligatorio: mostrar solo casos exitosos baja la nota. Candidatos:
- el caso de Liu (2017) del piloto con NotebookLM (`Vault_PISA2022/16 Experimento Nada sin fuente.md`, rama `Vanessa`);
- las filas de `Proyecto_PISA/salidas/nsf_banco_fallos.csv` (las genera `nsf_evaluacion.R`).

- **Sistema y versión del protocolo:** Tratamiento C — NotebookLM, cuaderno con 4 PDF (Liu y Bradley 2021, Kucam y
  Gülleroğlu 2023, Çelik y Kaşık 2025, Calderón et al. 2026). Corrido el 2026-10-12, antes de que existiera el
  protocolo v1 formal (congelado el mismo día en [[../protocolo/protocolo_consulta_v1|protocolo_consulta_v1]]); el
  cuaderno no tenía todavía esas reglas cargadas en "Configurar chat".
- **Pregunta:** «¿Qué estudios usan DIF por NSE dentro de las competencias/procesos matemáticos de PISA?» (consulta
  de Vanessa, O3).
- **Respuesta conocida y dónde está:** La referencia real de "Liu (2017)" es Liu, M. (2017). *Differential Item
  Functioning in Large-scale Mathematics Assessments: Comparing the Capabilities of the Rasch Trees Model to
  Traditional Approaches* (tesis doctoral, University of Toledo): compara métodos de detección de DIF (Rasch Tree,
  LR, Rasch), no un estudio aplicado sobre NSE/género/etnia en TIMSS. Dentro del PDF subido (Kucam y Gülleroğlu,
  2023), la única mención a Liu (2017) es metodológica, en la Discusión (p. 146): "Considering the number of items
  determined to contain DIF, it is seen that the LR method is more sensitive than the RT method, which is in line
  with the findings of Liu (2017)." La ficha completa de la tesis está en las referencias de ese mismo PDF (p. 148).
- **Qué respondió el sistema:** Describió a Liu (2017) como un estudio que "analizó el DIF según nivel
  socioeconómico, género, etnia y lengua materna en la prueba de matemáticas de TIMSS 2011 (8.º grado, EE. UU.)".
- **Qué estaba mal:** Le atribuyó a Liu (2017) hallazgos sobre NSE, género, etnia, lengua materna y TIMSS 2011 que
  el PDF subido no contiene — esa cita, de segundo nivel (una referencia citada dentro de otra), es solo
  metodológica y puntual.
- **Causa:** (marcar una y explicarla)
  - [ ] fragmentación que partió una tabla
  - [ ] PDF escaneado sin OCR
  - [ ] recuperación que trajo el fragmento equivocado
  - [x] el modelo ignoró el contexto y respondió de memoria
  - [ ] otra:

  El modelo no se limitó al fragmento del documento cerrado que sustenta la cita; completó la descripción de una
  referencia secundaria con conocimiento externo (de su entrenamiento), presentándolo como si viniera del PDF
  subido. Es una falla de anclaje parcial: la referencia primaria (Kucam) sí estaba bien anclada; la secundaria
  (Liu, citada dentro de Kucam) no.
- **Cómo se detectó:** Abriendo el PDF de Kucam y Gülleroğlu (`Ctrl+F` "Liu 2017") y comparando la oración exacta
  contra lo que afirmó NotebookLM (Vanessa, 2026-10-12). Reconfirmado el mismo día leyendo el PDF completo: la cita
  exacta está en la p. 146.
- **Qué cambiamos por esto:** No hizo falta un protocolo v2 (la regla ya se redactó directamente en la v1, congelada
  el mismo día): la regla 5 de [[../protocolo/protocolo_consulta_v1|protocolo_consulta_v1]] existe por este caso —
  "Si citas una referencia que a su vez aparece mencionada dentro de otra (una cita de segundo nivel), aclara que es
  una cita indirecta y que no verificaste el documento original."
