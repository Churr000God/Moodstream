# Moodstream — instrucciones del agente

## Fuente de verdad
- Lee `specs/DDP-v1.1.md` antes de cualquier tarea.
- Para OAuth: lee `specs/oauth-deezer.md`.
- Para base de datos: lee `specs/db-schema.md`.
- Para UI/UX frontend: sigue `moodstream_design_proposal.html` como design system obligatorio.
- No implementes funcionalidades fuera del DDP sin aprobación explícita del usuario.

## Scope MVP — no salgas de esto
- OAuth Deezer (flujo completo, sin refresh token — estrategia de re-auth pendiente, ver journal.md)
- Captura de mood del usuario
- Clasificación de tracks por mood
- Generación y guardado de playlist
- Límite: 5 playlists por día por usuario

## Reglas de trabajo
- Cada error y su fix → `logs/YYYY-MM-DD-[area]-[status].md`
- Decisión arquitectónica → nuevo archivo en `decisions/` siguiendo `decisions/ADR-template.md`
- Nunca expongas secrets ni API keys en el cliente ni en el código
- Commits atómicos con mensaje descriptivo en español
- Antes de instalar una dependencia nueva, avisa y justifica
- Al terminar cada tarea, entrega el log de sesión en formato del template

## Contexto disponible en este vault
- `context-bundle.md` — estado comprimido del proyecto (generado por get-context.ps1)
- `journal.md` — decisiones y aprendizajes por fecha, léelo para entender el historial
- `decisions/ADR-2026-03-22-stack.md` — stack tecnológico decidido
- `backlog/roadmap.md` — prioridades y sprints

## Qué archivos pegar según la tarea
| Tarea | Archivos a incluir |
|---|---|
| Feature nueva | README + log + DDP + sprint |
| OAuth / Deezer | README + log + oauth-deezer.md |
| Base de datos | README + log + db-schema.md |
| Arquitectura | README + ADRs + DDP |

## Al terminar la sesión
1. Guarda log en `logs/YYYY-MM-DD-[area]-[status].md`
2. Si hubo decisión arquitectónica → crea ADR en `decisions/`
3. Actualiza `backlog/roadmap.md` si cambió el scope
4. Registra entrada en `logs/sessions.md`
