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
