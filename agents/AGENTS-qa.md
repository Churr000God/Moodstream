# Agente QA — instrucciones adicionales

> Usa junto con AGENTS.md raíz. Este archivo agrega reglas específicas de calidad.

## Cobertura mínima MVP
- Happy path OAuth completo
- Límite de 5 playlists/día: caso exacto en el límite y caso excedido
- Clasificación de mood: al menos un test por cada valor del enum

## Herramientas (ajustar según ADR de stack)
- Tests unitarios: define aquí tu framework
- Lint: ESLint + reglas definidas en el repo

## Antes de marcar una tarea como done
- Sin errores de lint
- Tests del área modificada en verde
- No hay secrets en el diff
