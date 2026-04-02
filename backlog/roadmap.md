# Roadmap MVP — 6 semanas (23 mar → 4 may 2026)

## Sprint 0 — Setup (24–30 mar)
- [ ] Repo + estructura carpetas frontend/backend
- [ ] React + Vite + Zustand + Router
- [ ] Node.js + Express base
- [ ] Supabase: proyecto + migraciones
- [ ] Registrar app Deezer Developers
- [ ] .env.example + GitHub Actions CI

## Sprint 1 — Auth + OAuth Deezer (31 mar – 6 abr)
- [ ] Supabase Auth: login/registro
- [ ] Rutas protegidas frontend
- [ ] GET /deezer/oauth/start + callback
- [ ] Token cifrado en deezer_tokens
- [ ] Test integración: OAuth end-to-end

## Sprint 2 — Mood + Clasificación (7–13 abr)
- [ ] Formulario guiado de mood
- [ ] POST /mood → emotion_tags + parámetros musicales
- [ ] Lógica: expresar vs superar → energía/valencia

## Sprint 3 — Playlist (14–20 abr)
- [ ] POST /playlist (genera desde parámetros)
- [ ] Búsqueda Deezer por mood/género
- [ ] Filtro contenido explícito (RN03)
- [ ] POST /playlist/save (guarda en Deezer)
- [ ] Control cuota 5/día (RN02)
- [ ] Vista resultado + botón guardar

## Sprint 4 — Polish + Deploy (21 abr – 4 may)
- [ ] Diseño oscuro + responsive
- [ ] Manejo errores UI
- [ ] Tests integración endpoints clave
- [ ] VPS + HTTPS/SSL (Let's Encrypt)
- [ ] Smoke test producción

## Fase 2 (post-MVP)
F2-01 Compartir link | F2-02 Regenerar | F2-03 Analytics | F2-04 Admin
