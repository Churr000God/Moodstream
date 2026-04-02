# Documento de Definición del Proyecto

**Fecha:** 2026-03-22  
**Versión:** 1.1

## A. Información general
- **Nombre del proyecto:** Moodstream
- **Objetivo principal:** Generar playlists en Deezer ajustadas al estado emocional declarado por el usuario.
- **Problema que resuelve:** Facilita descubrir música acorde al mood para expresarlo o superarlo (escape/inspiración/gestión emocional).
- **Público objetivo:** Personas que buscan inspiración o escape emocional; sin panel especial para terapeutas.
- **Tipo de plataforma:** Aplicación web con login y conexión a Deezer.

## B. Usuarios y roles
- **Usuario:** Persona que conecta su cuenta Deezer.  
  **Permisos principales:** Iniciar sesión, conectar Deezer, capturar mood, generar/guardar playlist (hasta 5/día).

## C. Requisitos funcionales
- **RF01** — Autenticación de usuarios (login/registro).
- **RF02** — Conectar cuenta de Deezer mediante OAuth.
- **RF03** — Capturar mood vía texto libre guiado con preguntas.
- **RF04** — Clasificar emoción y objetivo ("expresar" vs "superar").
- **RF05** — Generar playlist acorde al mood y objetivo.
- **RF06** — Guardar la playlist directamente en la cuenta Deezer del usuario.
- **RF07** — (Fase 2) Compartir link de la playlist.
- **RF08** — (Fase 2) Regenerar playlist ajustando el mood.
- **RF09** — (Fase 2) Analytics/perfiles básicos (opcional).

## D. Reglas del negocio
- **RN01** — Diferenciar intención "expresar" vs "superar" para ajustar energía/tono.
- **RN02** — Máximo 5 playlists por usuario al día.
- **RN03** — Excluir géneros/temas sexuales o muy explícitos (especialmente en contextos de duelo).

## E. Requisitos no funcionales
- **Diseño responsive:** Sí.
- **Seguridad:** HTTPS/SSL; OAuth Deezer.
- **Rendimiento esperado:** Por definir (p.ej., respuesta < 2s con caché).
- **Disponibilidad:** Por definir (p.ej., 99%).
- **Accesibilidad:** Contrastes adecuados en modo claro/oscuro.
- **Otros:** Por definir.

## F. Alcance del MVP
- **Dentro:** Login, conexión Deezer (OAuth), captura de mood guiada, clasificar emoción/intención, generar y guardar playlist en Deezer, límite 5/día.
- **Fase 2+:** Compartir link, regenerar playlist, analytics/perfiles, panel admin (opcional).

## G. Mapa del sitio / módulos
- Landing/login
- Onboarding conexión Deezer
- Captura de mood (formulario guiado)
- Resultado de playlist (vista y guardado)
- (Fase 2) Compartir / regenerar
- (Opcional) Perfil/ajustes

## H. Identidad visual
- **Logo existente:** Por definir
- **Paleta:** Inspirada en Deezer, oscuro por defecto con sensación de tranquilidad; soportar claro/oscuro.
- **Tipografía:** Por definir
- **Estilo:** Moderno, tranquilo, minimal.
- **Referencias:** Deezer (oscuro, calmado).

## I. Stack tecnológico
- **Frontend:** React.
- **Backend:** Node.js.
- **Base de datos:** Supabase (Postgres).
- **Hosting / Infra:** VPS.
- **Integraciones:** API Deezer (OAuth + creación de playlists).
- **Dominio / SSL:** Requiere SSL; dominio por definir.

## J. Tiempo y recursos
- **Fecha de lanzamiento objetivo:** Primera semana de mayo.
- **Equipo de desarrollo:** Por definir.
- **Presupuesto estimado:** Por definir.

## K. Aspectos legales
- **Aviso de privacidad:** Por definir (OAuth, datos de perfil).
- **Términos y condiciones:** Por definir.
- **Manejo de datos personales:** Necesario (acceso a cuenta Deezer).
- **Facturación / CFDI:** No aplica por ahora.
- **Normativas aplicables:** Por definir.
