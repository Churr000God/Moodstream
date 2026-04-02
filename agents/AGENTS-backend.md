# Agente backend — instrucciones adicionales

> Usa junto con AGENTS.md raíz. Este archivo agrega reglas específicas del backend.

## Stack backend (ver ADR-2026-03-22-stack.md)
- Define aquí tu runtime, framework, ORM, etc.

## Convenciones de endpoints
- REST, rutas en kebab-case, versión en URL: /api/v1/...
- Respuestas: { data, error, meta }
- Errores HTTP estándar + mensaje descriptivo en español

## Base de datos
- Leer `specs/db-schema.md` antes de cualquier migración
- Nunca borrar columnas sin antes deprecarlas
- Migraciones reversibles siempre

## Auth / OAuth Deezer
- Leer `specs/oauth-deezer.md` completo
- Deezer no tiene refresh token — implementar re-auth explícita, NO silenciosa
- Nunca guardar access_token en localStorage, solo en memoria o cookie httpOnly

## Límites de negocio a validar en backend
- Máximo 5 playlists por usuario por día
- Validar mood en enum antes de clasificar
