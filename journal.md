# Journal — Moodstream

Resumen diario de jornadas. Más ligero que los logs, más frecuente que los ADRs.
Los agentes leen esto para entender qué se aprendió sin procesar todo el historial.
Entradas más recientes van arriba.

---

## Formato de entrada
```
## YYYY-MM-DD — [tema o sprint]

**Decisiones tomadas:**
- ...

**Atajos / cosas que funcionaron bien:**
- ...

**Riesgos abiertos:**
- ...

**Para la próxima sesión:**
- ...
```

---

## 2026-03-23 — Setup inicial del vault

**Decisiones tomadas:**
- Vault Obsidian como fuente de verdad del proyecto
- Script get-context.ps1 para automatizar el bundle de contexto con 5 modos
- log-template.md con campos: Error, Causa raíz, Pruebas, Fix, Lecciones
- journal.md como resumen ejecutivo diario (separado de logs/ que es técnico)

**Atajos / cosas que funcionaron bien:**
- get-context.ps1 + Set-Clipboard elimina el copy/paste manual de archivos
- Separar logs/ (detalle) de journal.md (resumen) reduce ruido al cargar contexto

**Riesgos abiertos:**
- Repo sin crear, sin scaffolding de código aún
- Deezer API no tiene refresh token — estrategia de re-auth pendiente
- Dominio y SSL sin configurar
- Zustand vs Redux sin decidir formalmente

**Para la próxima sesión:**
- Sprint 0: crear repo + scaffolding frontend/backend
- Registrar app en Deezer Developers y obtener APP_ID
