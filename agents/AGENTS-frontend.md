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

## Design system (obligatorio)
- Fuente de verdad UI: `moodstream_design_proposal.html` (en la raíz del vault Moodstream)
- Tipografía:
  - Títulos emocionales: DM Serif Display (`--font-serif`)
  - UI / cuerpo: DM Sans (`--font-sans`)
- Estilo visual: Liquid Dark Ambient (fondo casi negro, superficies en capas, acento púrpura)
- Tokens CSS: se definen y mantienen en `frontend/src/index.css` (no duplicar tokens en cada componente)
- Componentes base CSS:
  - Botones: `.btn` + variantes `.btn--primary` / `.btn--ghost` / `.btn--deezer` y tamaño `.btn--sm`
  - Cards: `.card` y `.card--sm`
- Accesibilidad: focus visible con `box-shadow 0 0 0 3px ...` y soporte `prefers-reduced-motion`

## UX / mood
- El flujo de captura de mood es el core de la app — priorizar claridad sobre estética
- No bloquear UI durante llamadas a Deezer, siempre mostrar loading state

## Secrets
- Nunca hardcodear APP_ID ni ningún token en el cliente
- Variables de entorno con prefijo público solamente
