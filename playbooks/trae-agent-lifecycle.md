# Ciclo de vida de agentes — Trae (Moodstream)

Guía para iniciar, trabajar y cerrar sesiones usando los agentes dentro de Trae, sin bundles manuales ni copy/paste de contexto.

---

## Flujo rápido

```
1) Abre Trae en la raíz del repo Moodstream/
2) Prompt inicial (rol + objetivo + restricciones + archivos clave)
3) Trabaja con el agente (ediciones + comandos + verificación)
4) Cierre de sesión (logs + journal + sessions + push/PR)
```

---

## 1) Antes de empezar

### Reglas obligatorias
- Lee `000-README.md` y `AGENTS.md` para reglas globales del proyecto.
- Si es Frontend, sigue `agents/AGENTS-frontend.md` (incluye el design system y `moodstream_design_proposal.html`).
- No agregues dependencias nuevas sin justificarlo.
- Nunca expongas secrets ni tokens en el cliente ni en el repo.
- Mantén el trabajo dentro del MVP definido en `specs/DDP-v1.1.md`.

### Contexto recomendado (sin script)
En Trae no necesitas generar `context-bundle.md` para pegarlo. En el prompt inicial indícale al agente que lea:
- `000-README.md`
- el último archivo en `logs/` (si existe)
- el spec relevante (`specs/DDP-v1.1.md`, `specs/oauth-deezer.md`, `specs/db-schema.md`)
- ADRs relevantes en `decisions/` si vas a tomar una decisión

---

## 2) Iniciar una sesión

### Prompt base (copiar/pegar)

```
Rol: [frontend|backend|qa|general]
Hoy quiero: [una acción concreta y verificable]

Lee primero:
- 000-README.md
- AGENTS.md
- agents/AGENTS-[rol].md (si aplica)
- último archivo de logs/
- spec relevante (DDP / oauth-deezer / db-schema)

Restricciones:
- MVP only
- sin secretos en cliente
- no instalar dependencias nuevas sin justificar

Entrega al final:
- cambios implementados (lista breve)
- comandos de verificación ejecutados (lint/typecheck/tests)
- log de sesión en logs/YYYY-MM-DD-[area]-[status].md
- actualización de journal.md y logs/sessions.md (si corresponde)
```

### Ejemplos por rol

Frontend
```
Rol: frontend
Hoy quiero: implementar la landing y la barra de navegación siguiendo moodstream_design_proposal.html
Spec: specs/DDP-v1.1.md
```

OAuth / Deezer
```
Rol: backend
Hoy quiero: implementar GET /deezer/oauth/start y GET /deezer/oauth/callback según specs/oauth-deezer.md
Spec: specs/oauth-deezer.md
```

Base de datos
```
Rol: backend
Hoy quiero: crear tablas y RLS base según specs/db-schema.md
Spec: specs/db-schema.md
```

---

## 3) Durante la sesión (cómo trabajar con Trae)

### Principio clave
Trae puede leer/editar archivos y ejecutar comandos. Tu trabajo es guiar la intención, revisar diffs y aceptar/rechazar cambios.

### Patrón de trabajo recomendado
1. Pedir un plan corto (lista de tareas) antes de cambiar archivos.
2. Implementación por iteraciones pequeñas:
   - una vista / componente / endpoint por iteración
   - verificación al final de cada iteración
3. Mantener disciplina de verificación:
   - Frontend: `npm run typecheck` y `npm run lint` (y `npm run dev` si aplica)
   - Backend: comandos del repo (lint/tests) si existen

---

## 4) Cerrar una sesión

### Checklist de cierre (obligatorio)
- Cambios verificados (lint/typecheck/tests según el proyecto).
- Log técnico en `logs/YYYY-MM-DD-[area]-[status].md` (usar el template).
- Entrada en `journal.md` con:
  - decisiones tomadas
  - riesgos abiertos
  - próximo paso claro
- Actualizar `logs/sessions.md` (estado y próximo paso).
- Si hubo decisión arquitectónica: crear ADR en `decisions/` (usando `decisions/ADR-template.md`).
- Si el trabajo se va a subir al repo:
  - commits atómicos
  - push a una rama feature
  - PR hacia `main`

### Prompt de cierre (copiar/pegar)

```
Cierre de sesión:
- Ejecuta los comandos de verificación del proyecto (lint/typecheck/tests).
- Genera el log en logs/YYYY-MM-DD-[area]-[status].md (con completado, errores, pendientes).
- Actualiza journal.md y logs/sessions.md.
- Si hay cambios listos para subir: crea commits atómicos en español y empuja a una rama feature.
```

---

## 5) Estados de sesión

Usa estos estados para nombrar el log y para `logs/sessions.md`:
- ✅ ok: se completó el objetivo
- ⚠️ parcial: hubo avance pero quedó trabajo pendiente
- ❌ bloqueado: no se puede continuar por un impedimento (describir causa y workaround)

