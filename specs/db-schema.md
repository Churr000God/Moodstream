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
