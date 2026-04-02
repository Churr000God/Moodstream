# Ciclo de vida de agentes — Moodstream

Guia de referencia para iniciar, trabajar y cerrar sesiones con Claude Code.

---

## Flujo rapido

```
1. .\get-context.ps1
2. .\agent-session.ps1 start [rol] "[descripcion]"
3. Pega el prompt en Claude Code → trabaja
4. .\agent-session.ps1 end [id] [estado]
```

---

## 1. Antes de abrir Claude Code

```powershell
.\get-context.ps1
```

Actualiza context-bundle.md con el estado actual del proyecto.

---

## 2. Iniciar una sesion

```powershell
.\agent-session.ps1 start <rol> "<descripcion>"
```

### Roles

| Rol      | Instrucciones adicionales   |
|----------|-----------------------------|
| backend  | agents/AGENTS-backend.md    |
| frontend | agents/AGENTS-frontend.md   |
| qa       | agents/AGENTS-qa.md         |
| general  | solo AGENTS.md raiz         |

### Ejemplos

```powershell
.\agent-session.ps1 start backend  "implementar OAuth Deezer handshake"
.\agent-session.ps1 start frontend "crear componente MoodSelector"
.\agent-session.ps1 start qa       "tests de limite 5 playlists por dia"
.\agent-session.ps1 start general  "revisar DDP seccion 3"
```

El script genera un prompt listo para copiar (tambien lo copia al portapapeles).
Pegalo como **primer mensaje** en Claude Code.

---

## 3. Archivos a incluir segun la tarea

| Tarea             | Archivos extra a dar al agente      |
|-------------------|-------------------------------------|
| Feature nueva     | specs/DDP-v1.1.md seccion relevante |
| OAuth / Deezer    | specs/oauth-deezer.md               |
| Base de datos     | specs/db-schema.md                  |
| Arquitectura      | decisions/ todos los ADRs           |

---

## 4. Cerrar una sesion

```powershell
.\agent-session.ps1 end <id> <estado> ["nota"]
```

### Estados

| Estado    | Cuando                                  |
|-----------|-----------------------------------------|
| done      | tarea completada                        |
| parcial   | avance, queda trabajo pendiente         |
| bloqueado | no se pudo continuar por un impedimento |

### Ejemplos

```powershell
.\agent-session.ps1 end s-001-backend-20260401 done
.\agent-session.ps1 end s-002-frontend-20260401 parcial "falta conectar con backend"
.\agent-session.ps1 end s-003-qa-20260401 bloqueado "Deezer devuelve 403"
```

### Checklist antes de cerrar

- [ ] git commit con los cambios de la sesion
- [ ] Log en logs/YYYY-MM-DD-[area]-[status].md
- [ ] Decision arquitectonica → ADR en decisions/
- [ ] Cambio de scope → backlog/roadmap.md actualizado
- [ ] Sin secrets en el codigo

---

## 5. Ver estado de sesiones

```powershell
.\agent-session.ps1 status
```

---

## Referencia rapida

```powershell
.\get-context.ps1                                                    # actualizar contexto
.\agent-session.ps1 start backend  "tarea"                          # iniciar agente backend
.\agent-session.ps1 start frontend "tarea"                          # iniciar agente frontend
.\agent-session.ps1 start qa       "tarea"                          # iniciar agente qa
.\agent-session.ps1 status                                           # ver sesiones
.\agent-session.ps1 end s-001-backend-20260401 done                 # cerrar ok
.\agent-session.ps1 end s-001-backend-20260401 parcial "nota"       # cerrar parcial
.\agent-session.ps1 end s-001-backend-20260401 bloqueado "nota"     # cerrar bloqueado
```