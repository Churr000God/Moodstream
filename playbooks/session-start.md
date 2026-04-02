# Playbook — Iniciar sesión con Claude

## Antes de la sesión
Define en una línea: "Hoy quiero: [acción concreta]"

## Bundle de contexto (pegar al inicio del prompt)
000-README.md + último log + spec relevante + ADRs si hay decisión arquitectónica

## Prompt base
```
[bundle de contexto]
---
Tarea: [descripción]
Restricciones: MVP only · sin secretos en cliente · al terminar dame el log de sesión
```

## Al terminar
1. Guarda log en logs/YYYY-MM-DD-[area]-[status].md
2. Si hubo decisión → ADR en decisions/
3. Actualiza backlog/roadmap.md

## Qué archivos pegar
Feature nueva → README + log + DDP + sprint
OAuth/Deezer  → README + log + oauth-deezer.md
BD            → README + log + db-schema.md
Arquitectura  → README + ADRs + DDP
