# Agente frontend — instrucciones adicionales

> Usa junto con AGENTS.md raíz. Este archivo agrega reglas específicas del frontend.

## Stack frontend (ver ADR-2026-03-22-stack.md)
- Define aquí tu framework, librería de UI, manejo de estado

## Estado global
- Zustand vs Redux: pendiente de decidir formalmente (ver journal.md 2026-03-23)
- Mientras no se decida: usar estado local con useState, no instalar ninguno de los dos

## Convenciones de componentes
- Nombres en PascalCase
- Un componente por archivo
- Props tipadas con TypeScript

## UX / mood
- El flujo de captura de mood es el core de la app — priorizar claridad sobre estética
- No bloquear UI durante llamadas a Deezer, siempre mostrar loading state

## Secrets
- Nunca hardcodear APP_ID ni ningún token en el cliente
- Variables de entorno con prefijo público solamente
