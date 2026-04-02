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
