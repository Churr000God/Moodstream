# Guía de Flujo de Trabajo — Moodstream Vault

Última actualización: 2026-03-23

---

## ¿Qué es este vault y para qué sirve?

Este vault de Obsidian es la **fuente de verdad** del proyecto Moodstream.
Contiene toda la documentación técnica, decisiones arquitectónicas, bitácoras
de sesiones y el roadmap. Su propósito es que tú y cualquier agente (Claude,
Claude Code, etc.) puedan retomar el trabajo sin perder contexto.

---

## Estructura de archivos
```
Moodstream/
├── 000-README.md           ← Instrucciones para agentes (pegar siempre)
├── get-context.ps1         ← Script que arma el bundle de contexto
├── context-bundle.md       ← Bundle generado automáticamente (no editar)
├── specs/
│   ├── DDP-v1.1.md         ← Documento de Definición del Proyecto
│   ├── oauth-deezer.md     ← Flujo OAuth Deezer documentado
│   └── db-schema.md        ← Esquema de base de datos (SQL)
├── decisions/
│   ├── ADR-template.md     ← Template para nuevas decisiones
│   └── ADR-YYYY-MM-DD-*.md ← Decisiones tomadas
├── logs/
│   ├── log-template.md     ← Template para bitácoras
│   └── YYYY-MM-DD-*.md     ← Bitácoras de sesiones
├── backlog/
│   └── roadmap.md          ← Sprints MVP + Fase 2
└── playbooks/
    ├── session-start.md    ← Cómo iniciar una sesión
    └── workflow-guide.md   ← Este archivo
```

---

## Script get-context.ps1 — Referencia rápida

El script lee los archivos del vault, los concatena y los copia al portapapeles.
Solo tienes que hacer Ctrl+V en Claude para cargar el contexto.

### Modos disponibles

| Comando | Cuándo usarlo |
|---|---|
| `.\get-context.ps1` | Feature general, bug fix, cualquier tarea sin área específica |
| `.\get-context.ps1 -Modo oauth` | Todo lo relacionado con login, OAuth Deezer, tokens |
| `.\get-context.ps1 -Modo bd` | Migraciones, esquema, queries, Supabase |
| `.\get-context.ps1 -Modo arquitectura` | Decisiones de diseño, estructura de código, dependencias |
| `.\get-context.ps1 -Modo full` | Inicio de sprint, sesiones largas, onboarding de alguien nuevo |

### Qué incluye cada modo

| Modo | Archivos incluidos |
|---|---|
| default | README + último log + DDP |
| oauth | README + último log + oauth-deezer.md |
| bd | README + último log + db-schema.md |
| arquitectura | README + último log + DDP + todos los ADRs |
| full | README + último log + todos los specs + todos los ADRs |

---

## Flujo de trabajo completo por tipo de sesión

### Sesión de desarrollo (feature nueva o bug fix)
```
1. Abre tu terminal en la carpeta Moodstream/
2. Ejecuta el modo que corresponda:
      .\get-context.ps1              (general)
      .\get-context.ps1 -Modo oauth  (si es algo de Deezer)
      .\get-context.ps1 -Modo bd     (si es algo de Supabase)
3. Abre Claude o Claude Code
4. Ctrl+V para pegar el contexto
5. Describe tu tarea:
      "Tarea: implementar POST /mood con clasificación básica.
       Restricciones: MVP only, sin secretos en cliente.
       Al terminar dame el log de sesión."
6. Trabaja con el agente
7. Al terminar: copia el log que Claude genere y guárdalo en logs/
```

### Sesión de decisión arquitectónica
```
1. .\get-context.ps1 -Modo arquitectura
2. Ctrl+V en Claude
3. "Necesito decidir entre X e Y para [contexto]. Evalúa pros y contras."
4. Una vez decidido, crea el ADR en decisions/:
      Copia ADR-template.md → renómbralo ADR-YYYY-MM-DD-tema.md
      Rellena los campos
5. Actualiza backlog/roadmap.md si la decisión genera nuevas tareas
```

### Inicio de sprint
```
1. .\get-context.ps1 -Modo full
2. Ctrl+V en Claude
3. "Vamos a iniciar el Sprint X. Revisa el roadmap y dime:
    - ¿Hay dependencias bloqueantes entre tareas?
    - ¿Qué orden recomiendas para las tareas?
    - ¿Qué specs faltan o están incompletos?"
4. Actualiza backlog/roadmap.md con el resultado
```

### Actualizar un spec (oauth, bd, etc.)
```
1. Edita el archivo en specs/ directamente en Obsidian
2. No necesitas script — los specs son fuente de verdad estática
3. Si el cambio implica una decisión → crea ADR
4. Si el cambio fue resultado de una sesión → actualiza el log del día
```

---

## Cómo escribir un buen log de sesión

Guarda los logs en: logs/YYYY-MM-DD-[area]-[status].md

Ejemplos de nombres:
- 2026-03-25-oauth-ok.md
- 2026-03-27-playlist-gen-parcial.md
- 2026-03-28-deploy-bloqueado.md

Usa el template en logs/log-template.md. Lo mínimo útil:
```markdown
## ✅ Completado
- Implementado POST /mood con clasificación básica

## ❌ Errores
Error: Cannot read property 'token' of undefined
Causa: El middleware de auth no adjunta user al request
Fix: Añadir req.user = decoded en auth.middleware.js

## 📌 Pendientes
- [ ] Agregar validación de schema con Zod
- [ ] Test de integración para el endpoint
```

---

## Cómo escribir un buen ADR

Guarda los ADRs en: decisions/ADR-YYYY-MM-DD-tema.md

Lo mínimo útil:
```markdown
# ADR-2026-03-25 — Zustand sobre Redux para estado global

**Estado:** Aceptado

## Decisión
Usar Zustand para manejar el estado global del frontend.

## Por qué no Redux
Redux requiere más boilerplate (actions, reducers, store config).
Para MVP con 2-3 slices de estado (auth, deezer, playlist) es excesivo.

## Trade-offs
Zustand es menos conocido en equipos grandes, pero para este proyecto
el equipo es pequeño y la curva de aprendizaje es mínima.
```

---

## Checklist antes de cerrar una sesión

- [ ] ¿Guardé el log en logs/?
- [ ] ¿Hubo decisión arquitectónica? → ADR en decisions/
- [ ] ¿Hay tareas nuevas o completadas? → actualizar backlog/roadmap.md
- [ ] ¿Cambió algo en el esquema BD u OAuth? → actualizar specs/
- [ ] ¿El próximo que abra el vault entendería dónde quedamos?

---

## Comandos de referencia rápida
```powershell
# Generar contexto y copiar al portapapeles
.\get-context.ps1
.\get-context.ps1 -Modo oauth
.\get-context.ps1 -Modo bd
.\get-context.ps1 -Modo arquitectura
.\get-context.ps1 -Modo full

# Ver el bundle generado
code context-bundle.md           # si tienes VS Code
notepad context-bundle.md        # si no

# Ver último log rápido
Get-ChildItem logs\*.md | Where { $_.Name -ne "log-template.md" } | Sort LastWriteTime -Desc | Select -First 1 | Get-Content

# Ver todos los ADRs
Get-ChildItem decisions\*.md | Where { $_.Name -ne "ADR-template.md" } | Select Name, LastWriteTime
```
