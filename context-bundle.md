### 000-README.md

# Moodstream — Vault de Conocimiento

> Fuente de verdad del proyecto. Todo agente debe leer este archivo antes de ejecutar cualquier tarea.

---

## Instrucciones para agentes / Claude Code
```
Eres un agente de desarrollo trabajando en Moodstream.
REGLAS OBLIGATORIAS:
1. Lee specs/DDP-v1.1.md antes de cualquier tarea de feature o diseño.
2. Lee el último archivo en logs/ para entender el estado técnico actual.
3. Lee journal.md para ver decisiones, atajos y riesgos abiertos.
4. Lee las decisions/ relevantes antes de tomar decisiones arquitectónicas.
5. NO inventes requisitos fuera del DDP. Si algo no está definido, pregunta.
6. Prioriza siempre el MVP. No construyas Fase 2 salvo flags/hooks mínimos.
7. NUNCA expongas secretos, API keys ni tokens en código cliente.
8. Al terminar tu tarea:
   a) Crea logs/YYYY-MM-DD-[area]-[status].md con errores, causa raíz, pruebas, fix, lecciones.
   b) Agrega entrada al inicio de journal.md: decisiones, atajos, riesgos, próxima sesión.
   c) Si hubo decisión arquitectónica → crea decisions/ADR-YYYY-MM-DD-[tema].md.
   d) Si hay pendientes nuevos → actualiza backlog/roadmap.md.
```

---

## Estructura del vault

| Archivo / Carpeta | Contenido |
|---|---|
| `000-README.md` | Instrucciones para agentes y contexto general. |
| `journal.md` | Resumen diario: decisiones, atajos, riesgos. Leer siempre. |
| `get-context.ps1` | Genera el bundle de contexto y lo copia al portapapeles. |
| `specs/` | DDP, flujo OAuth, esquema BD. |
| `decisions/` | ADRs: qué se decidió, por qué, fecha. |
| `logs/` | Bitácoras técnicas: errores, pruebas, fixes. |
| `backlog/` | Roadmap y tickets MVP + Fase 2. |
| `playbooks/` | Procedimientos repetibles. |

---

## Flujo de sesión

**Al iniciar:**
1. README (este archivo)
2. journal.md (aprendizajes y riesgos abiertos)
3. Último logs/ (detalle técnico de la sesión anterior)
4. Spec relevante según la tarea

**Al terminar:**
1. logs/ → bitácora técnica detallada
2. journal.md → nueva entrada al inicio
3. decisions/ → ADR si hubo decisión arquitectónica
4. backlog/roadmap.md → actualizar tareas

---

## Contexto rápido

- Producto: App web que genera playlists en Deezer según estado emocional del usuario
- Diferenciador: clasifica "expresar" vs "superar" → ajusta energía/tono de la música
- Stack: React · Node.js · Supabase (Postgres) · VPS · API Deezer
- MVP target: primera semana de mayo 2026
- Límite: máx. 5 playlists/usuario/día

---

## Setup rápido

Backend /backend/.env:
  PORT=3001 · SUPABASE_URL · SUPABASE_SERVICE_KEY · DEEZER_APP_ID
  DEEZER_SECRET · DEEZER_REDIRECT_URI · JWT_SECRET · ENCRYPTION_KEY

Frontend /frontend/.env:
  VITE_API_URL=http://localhost:3001 · VITE_DEEZER_APP_ID

Levantar:
  cd backend && npm install && npm run dev
  cd frontend && npm install && npm run dev

Última actualización: 2026-03-23


---

### journal.md

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


---

### ULTIMO LOG: 2026-03-23-setup-ok.md

# Log — 2026-03-23 — Setup vault — ✅ ok
**Sesión con:** Claude (Cowork)
**Objetivo:** Crear vault Obsidian como fuente de verdad del proyecto.

## ✅ Completado
- Estructura vault: specs/, decisions/, logs/, backlog/, playbooks/
- 000-README.md con instrucciones para agentes
- specs/DDP-v1.1.md, oauth-deezer.md, db-schema.md
- ADR-2026-03-22-stack.md
- Templates ADR y log
- backlog/roadmap.md (4 sprints hasta mayo)
- playbooks/session-start.md

## 📌 Próxima sesión
- [ ] Scaffolding repo frontend + backend
- [ ] Decidir Zustand vs Redux → ADR
- [ ] Registrar app en Deezer Developers


---

### specs/db-schema.md

# Esquema BD — Supabase (Postgres) MVP

## Tablas
users            → id, email, deezer_id, deezer_username, created_at
deezer_tokens    → id, user_id (FK), access_token_encrypted (AES-256), created_at
playlists        → id, user_id, mood_text, intention (expresar|superar), emotion_tags[], tracks (JSONB), deezer_playlist_id, saved_to_deezer, created_at
mood_logs        → id, user_id, playlist_id, mood_text, intention, emotion_tags[], created_at [insertar desde MVP, usar en Fase 2]

## Cuota diaria (RN02)
SELECT COUNT(*) FROM playlists WHERE user_id=$1 AND created_at >= NOW() - INTERVAL 24h
Si >= 5 → rechazar con 429

## RLS
Habilitar en todas las tablas. Backend usa SERVICE_KEY (bypass). Frontend usa anon key (respeta RLS).


---

### specs/DDP-v1.1.md

# Documento de Definición del Proyecto v1.1
Fecha: 2026-03-22

## Requisitos funcionales (MVP)
- RF01: Autenticación (login/registro)
- RF02: OAuth Deezer
- RF03: Captura de mood vía texto guiado
- RF04: Clasificar "expresar" vs "superar"
- RF05: Generar playlist según mood/intención
- RF06: Guardar playlist en cuenta Deezer

## Reglas de negocio
- RN01: expresar → energía acorde al mood; superar → energía progresiva/positiva
- RN02: máximo 5 playlists/usuario/día
- RN03: excluir contenido explícito/sexual (especialmente en duelo)

## Stack
React · Node.js · Supabase (Postgres) · VPS · API Deezer (OAuth + playlists)

## Fase 2 (fuera del MVP)
RF07 Compartir link · RF08 Regenerar · RF09 Analytics · Panel admin


---

### specs/oauth-deezer.md

# Flujo OAuth Deezer
⚠️ Deezer NO tiene refresh token. Detectar 401 → redirigir a re-auth.

## Endpoints
GET  /deezer/oauth/start      → redirige a Deezer con perms: basic_access,email,manage_library
GET  /deezer/oauth/callback   → intercambia code por token → cifra con AES-256 → guarda en deezer_tokens

## Crear playlist
POST https://api.deezer.com/user/{id}/playlists   → crea
POST https://api.deezer.com/playlist/{id}/tracks  → agrega tracks

## Variables requeridas
DEEZER_APP_ID · DEEZER_SECRET · DEEZER_REDIRECT_URI · ENCRYPTION_KEY (32 chars)

## Pendientes
- [ ] Re-autenticación silenciosa al detectar 401
- [ ] Política de limpieza de tokens antiguos


---

### decisions/ADR-2026-03-22-stack.md

# ADR-2026-03-22 — Stack tecnológico
**Estado:** Aceptado | **Área:** Frontend · Backend · BD · Infra

## Decisión
React + Vite · Node.js + Express · Supabase · Zustand · VPS

## Por qué no otras opciones
- Next.js: innecesario para MVP SPA; considerar en Fase 2 si se necesita SSR
- Firebase: Supabase tiene SQL real, RLS nativo, open-source
- Serverless: VPS da más control sobre tokens cifrados y callbacks OAuth

## Pendientes
- [ ] Zustand vs Redux → crear ADR
- [ ] Prisma vs consultas directas Supabase
- [ ] SSL en VPS (Let's Encrypt)

