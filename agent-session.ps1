# agent-session.ps1
# Gestiona el ciclo de vida de sesiones de agentes Claude Code en Moodstream
# Uso: .\agent-session.ps1 <comando> [argumentos]

param(
    [Parameter(Position=0)] [string]$Comando,
    [Parameter(Position=1)] [string]$Arg1,
    [Parameter(Position=2)] [string]$Arg2,
    [Parameter(Position=3)] [string]$Arg3
)

# ─── Configuracion ───────────────────────────────────────────────────────────

$ROOT        = $PSScriptRoot
$AGENTS_ROOT = Join-Path $ROOT "AGENTS.md"
$AGENTS_DIR  = Join-Path $ROOT "agents"
$BUNDLE      = Join-Path $ROOT "context-bundle.md"
$SESSIONS    = Join-Path $ROOT "logs\sessions.md"
$LOGS_DIR    = Join-Path $ROOT "logs"

# Contador de sesiones (lee el ultimo numero desde sessions.md)
function Get-NextSessionId {
    param([string]$Rol)
    $fecha = Get-Date -Format "yyyyMMdd"
    if (Test-Path $SESSIONS) {
        $nums = (Get-Content $SESSIONS | Select-String 's-(\d+)-' | ForEach-Object {
            [int]$_.Matches[0].Groups[1].Value
        })
        $next = if ($nums) { ($nums | Measure-Object -Maximum).Maximum + 1 } else { 1 }
    } else {
        $next = 1
    }
    return "s-{0:D3}-{1}-{2}" -f $next, $Rol, $fecha
}

# ─── Colores ─────────────────────────────────────────────────────────────────

function Write-Header  { param($msg) Write-Host "`n$msg" -ForegroundColor Cyan }
function Write-Ok      { param($msg) Write-Host "  OK  $msg" -ForegroundColor Green }
function Write-Warn    { param($msg) Write-Host "  >>  $msg" -ForegroundColor Yellow }
function Write-Err     { param($msg) Write-Host "  !!  $msg" -ForegroundColor Red }
function Write-Divider { Write-Host ("─" * 60) -ForegroundColor DarkGray }

# ─── COMANDO: start ──────────────────────────────────────────────────────────

function Start-Session {
    param([string]$Rol, [string]$Descripcion)

    if (-not $Rol)        { Write-Err "Especifica un rol: backend | frontend | qa | general"; exit 1 }
    if (-not $Descripcion) { Write-Err "Especifica una descripcion de la tarea"; exit 1 }

    $roles_validos = @("backend", "frontend", "qa", "general")
    if ($Rol -notin $roles_validos) {
        Write-Err "Rol '$Rol' no valido. Usa: $($roles_validos -join ' | ')"
        exit 1
    }

    $id    = Get-NextSessionId -Rol $Rol
    $fecha = Get-Date -Format "yyyy-MM-dd HH:mm"

    Write-Header "Iniciando sesion de agente"
    Write-Divider

    # Verificar archivos necesarios
    if (-not (Test-Path $AGENTS_ROOT)) { Write-Err "No se encuentra AGENTS.md en la raiz"; exit 1 }
    if (-not (Test-Path $BUNDLE))      { Write-Warn "context-bundle.md no existe. Ejecuta get-context.ps1 primero." }

    # Leer contenidos
    $contenido_agente = Get-Content $AGENTS_ROOT -Raw -Encoding UTF8

    $contenido_rol = ""
    if ($Rol -ne "general") {
        $archivo_rol = Join-Path $AGENTS_DIR "AGENTS-$Rol.md"
        if (Test-Path $archivo_rol) {
            $contenido_rol = Get-Content $archivo_rol -Raw -Encoding UTF8
        } else {
            Write-Warn "No se encuentra agents/AGENTS-$Rol.md — se usara solo AGENTS.md raiz"
        }
    }

    $contenido_bundle = ""
    if (Test-Path $BUNDLE) {
        $contenido_bundle = Get-Content $BUNDLE -Raw -Encoding UTF8
    }

    # Armar el prompt
    $prompt = @"
<!-- INICIO DE SESION: $id | $fecha -->
<!-- Rol: $Rol | Tarea: $Descripcion -->

$contenido_agente
"@

    if ($contenido_rol) {
        $prompt += @"

---
## Instrucciones adicionales — agente $Rol

$contenido_rol
"@
    }

    if ($contenido_bundle) {
        $prompt += @"

---
## Contexto actual del proyecto

$contenido_bundle
"@
    }

    $prompt += @"

---
## Tarea de esta sesion

ID de sesion: $id
Fecha: $fecha
Tarea: $Descripcion

Al terminar entregame:
1. Resumen de lo que hiciste
2. Log de errores encontrados y sus fixes (formato: Error | Causa raiz | Fix)
3. Si tomaste alguna decision arquitectonica, el borrador del ADR
4. Proximos pasos sugeridos
"@

    # Copiar al portapapeles
    $prompt | Set-Clipboard

    # Guardar prompt en logs para referencia
    $prompt_file = Join-Path $LOGS_DIR "$id-prompt.md"
    $prompt | Set-Content -Path $prompt_file -Encoding UTF8

    # Registrar en sessions.md
    Register-SessionStart -Id $id -Rol $Rol -Descripcion $Descripcion -Fecha $fecha

    Write-Divider
    Write-Ok "Sesion registrada: $id"
    Write-Ok "Prompt copiado al portapapeles"
    Write-Ok "Prompt guardado en: logs\$id-prompt.md"
    Write-Host ""
    Write-Host "  Pega el prompt en Claude Code como primer mensaje." -ForegroundColor White
    Write-Host "  Al terminar ejecuta:" -ForegroundColor DarkGray
    Write-Host "  .\agent-session.ps1 end $id done" -ForegroundColor DarkGray
    Write-Host ""
}

# ─── COMANDO: end ────────────────────────────────────────────────────────────

function End-Session {
    param([string]$Id, [string]$Estado, [string]$Nota)

    if (-not $Id)     { Write-Err "Especifica el ID de sesion"; exit 1 }
    if (-not $Estado) { Write-Err "Especifica el estado: done | parcial | bloqueado"; exit 1 }

    $estados_validos = @("done", "parcial", "bloqueado")
    if ($Estado -notin $estados_validos) {
        Write-Err "Estado '$Estado' no valido. Usa: done | parcial | bloqueado"
        exit 1
    }

    $iconos = @{ done = "OK"; parcial = ">>"; bloqueado = "!!" }
    $icono  = $iconos[$Estado]
    $fecha  = Get-Date -Format "yyyy-MM-dd"

    Write-Header "Cerrando sesion: $Id"
    Write-Divider

    # Actualizar sessions.md
    if (-not (Test-Path $SESSIONS)) {
        Write-Warn "No se encuentra logs/sessions.md — creando..."
        New-SessionsFile
    }

    $contenido = Get-Content $SESSIONS -Raw -Encoding UTF8
    # Buscar la fila del ID y actualizar estado y fecha
    $linea_nueva = $null
    $lineas = Get-Content $SESSIONS -Encoding UTF8
    $lineas_out = foreach ($linea in $lineas) {
        if ($linea -match [regex]::Escape($Id)) {
            # Reemplazar estado (columna 4) y fecha (ultima columna)
            $partes = $linea -split '\|'
            if ($partes.Count -ge 6) {
                $partes[4] = " $icono $Estado "
                $partes[6] = " $fecha "
                if ($Nota) { $partes[5] = " $Nota " }
                $linea = $partes -join '|'
            }
        }
        $linea
    }
    $lineas_out | Set-Content $SESSIONS -Encoding UTF8

    Write-Ok "sessions.md actualizado"

    # Mostrar checklist
    Write-Host ""
    Write-Host "  Checklist de cierre:" -ForegroundColor White
    Write-Host "  [ ] git commit con los cambios de la sesion" -ForegroundColor DarkGray
    Write-Host "  [ ] Log de errores en logs\$fecha-[area]-[status].md" -ForegroundColor DarkGray
    Write-Host "  [ ] Si hubo decision arquitectonica → ADR en decisions\" -ForegroundColor DarkGray
    Write-Host "  [ ] Si cambio el scope → backlog\roadmap.md actualizado" -ForegroundColor DarkGray
    Write-Host "  [ ] Sin secrets en el codigo" -ForegroundColor DarkGray
    Write-Host ""

    if ($Estado -eq "bloqueado" -and $Nota) {
        Write-Warn "Sesion bloqueada: $Nota"
        Write-Warn "Registra el impedimento en journal.md antes de continuar"
    }

    Write-Ok "Sesion $Id cerrada como: $Estado"
    Write-Host ""
}

# ─── COMANDO: status ─────────────────────────────────────────────────────────

function Show-Status {
    Write-Header "Sesiones activas — Moodstream"
    Write-Divider

    if (-not (Test-Path $SESSIONS)) {
        Write-Warn "No hay sesiones registradas aun."
        Write-Host "  Inicia una con: .\agent-session.ps1 start <rol> `"descripcion`"" -ForegroundColor DarkGray
        return
    }

    Get-Content $SESSIONS -Encoding UTF8 | ForEach-Object {
        if ($_ -match '^\|.*\|') {
            if ($_ -match 'OK.*done') {
                Write-Host $_ -ForegroundColor Green
            } elseif ($_ -match '!!.*bloqueado') {
                Write-Host $_ -ForegroundColor Red
            } elseif ($_ -match '>>.*parcial') {
                Write-Host $_ -ForegroundColor Yellow
            } elseif ($_ -match 'pendiente') {
                Write-Host $_ -ForegroundColor DarkGray
            } else {
                Write-Host $_
            }
        } else {
            Write-Host $_ -ForegroundColor DarkGray
        }
    }
    Write-Host ""
}

# ─── Helpers ─────────────────────────────────────────────────────────────────

function Register-SessionStart {
    param($Id, $Rol, $Descripcion, $Fecha)

    if (-not (Test-Path $SESSIONS)) { New-SessionsFile }

    # Acortar descripcion si es muy larga
    $desc_corta = if ($Descripcion.Length -gt 35) { $Descripcion.Substring(0,35) + "..." } else { $Descripcion }

    $nueva_fila = "| $Id | $Rol | $desc_corta | >> activo | — | $Fecha |"

    # Insertar antes de la ultima linea de la tabla (antes del primer separador de estados)
    $lineas   = Get-Content $SESSIONS -Encoding UTF8
    $insertar = $false
    $out      = [System.Collections.Generic.List[string]]::new()

    foreach ($linea in $lineas) {
        $out.Add($linea)
        # Insertar despues de la fila de encabezados de la tabla
        if ($linea -match '^\|[-| ]+\|$' -and -not $insertar) {
            $out.Add($nueva_fila)
            $insertar = $true
        }
    }

    $out | Set-Content $SESSIONS -Encoding UTF8
}

function New-SessionsFile {
    $contenido = @"
# Sessions — Moodstream

Tabla de sesiones. Actualizar al inicio y al cierre de cada sesion.

| ID | Rol | Tarea | Estado | Nota | Fecha |
|----|-----|-------|--------|------|-------|

## Leyenda de estados
- >> activo    — sesion en curso
- OK done      — completada
- >> parcial   — avance, queda trabajo
- !! bloqueado — impedimento activo
"@
    $contenido | Set-Content $SESSIONS -Encoding UTF8
}

# ─── Entry point ─────────────────────────────────────────────────────────────

switch ($Comando) {
    "start"  { Start-Session -Rol $Arg1 -Descripcion $Arg2 }
    "end"    { End-Session   -Id $Arg1  -Estado $Arg2 -Nota $Arg3 }
    "status" { Show-Status }
    default  {
        Write-Host ""
        Write-Host "  agent-session.ps1 — gestor de sesiones de agentes" -ForegroundColor Cyan
        Write-Host ""
        Write-Host "  Comandos:" -ForegroundColor White
        Write-Host "    start <rol> `"descripcion`"   Inicia una sesion nueva" -ForegroundColor DarkGray
        Write-Host "    end   <id>  <estado> [nota]  Cierra una sesion" -ForegroundColor DarkGray
        Write-Host "    status                        Ver sesiones activas" -ForegroundColor DarkGray
        Write-Host ""
        Write-Host "  Roles: backend | frontend | qa | general" -ForegroundColor DarkGray
        Write-Host "  Estados: done | parcial | bloqueado" -ForegroundColor DarkGray
        Write-Host ""
        Write-Host "  Ejemplos:" -ForegroundColor White
        Write-Host "    .\agent-session.ps1 start backend `"OAuth Deezer handshake`"" -ForegroundColor DarkGray
        Write-Host "    .\agent-session.ps1 status" -ForegroundColor DarkGray
        Write-Host "    .\agent-session.ps1 end s-001-backend-20260401 done" -ForegroundColor DarkGray
        Write-Host "    .\agent-session.ps1 end s-002-frontend-20260401 parcial `"falta conectar API`"" -ForegroundColor DarkGray
        Write-Host ""
    }
}