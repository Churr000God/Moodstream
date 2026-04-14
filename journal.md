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

## 2026-04-13 — Implementación de la página de inicio (Home)

**Decisiones tomadas:**
- Se creó el componente `Home` con el botón de login de Deezer.
- Se mantuvieron estilos sencillos (CSS clásico) y se limpiaron los de Vite para mantener claridad.
- No se introdujo `react-router-dom` en este paso; la redirección a Deezer OAuth se hace vía `window.location.href`.

**Atajos / cosas que funcionaron bien:**
- Usar `VITE_API_URL` directo desde `import.meta.env` para redireccionar al backend evita exponer la lógica de auth en el front.

**Riesgos abiertos:**
- Necesitaremos manejar el callback de Deezer en el frontend una vez que redirija de vuelta.
- Estado global pendiente de definir (Zustand vs Local State).

**Para la próxima sesión:**
- Implementar el manejo del callback de OAuth en el frontend.
- Crear el componente para la captura del mood.

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
