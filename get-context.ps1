# get-context.ps1 — Genera bundle de contexto y lo copia al portapapeles
#
# Uso:
#   .\get-context.ps1                    -> README + journal + log + DDP
#   .\get-context.ps1 -Modo oauth        -> README + journal + log + oauth-deezer.md
#   .\get-context.ps1 -Modo bd           -> README + journal + log + db-schema.md
#   .\get-context.ps1 -Modo arquitectura -> README + journal + log + DDP + ADRs
#   .\get-context.ps1 -Modo full         -> README + journal + log + todos specs + ADRs

param([string]$Modo = "default")

$base = $PSScriptRoot
$bundle = ""
$sep = "`n`n---`n`n"

function Add-File($path, $label) {
    if (Test-Path $path) {
        return "### $label`n`n$(Get-Content $path -Raw -Encoding UTF8)"
    }
    Write-Warning "No encontrado: $path"
    return ""
}

function Get-UltimoLog {
    Get-ChildItem "$base\logs\*.md" -ErrorAction SilentlyContinue |
        Where-Object { $_.Name -ne "log-template.md" } |
        Sort-Object LastWriteTime -Descending |
        Select-Object -First 1
}

# Siempre incluir
$bundle += Add-File "$base\000-README.md" "000-README.md"
$bundle += $sep + (Add-File "$base\journal.md" "journal.md")

$log = Get-UltimoLog
if ($log) { $bundle += $sep + (Add-File $log.FullName "ULTIMO LOG: $($log.Name)") }

# Por modo
switch ($Modo) {
    "oauth"        { $bundle += $sep + (Add-File "$base\specs\oauth-deezer.md" "specs/oauth-deezer.md") }
    "bd"           { $bundle += $sep + (Add-File "$base\specs\db-schema.md"    "specs/db-schema.md") }
    "arquitectura" {
        $bundle += $sep + (Add-File "$base\specs\DDP-v1.1.md" "specs/DDP-v1.1.md")
        Get-ChildItem "$base\decisions\*.md" | Where { $_.Name -ne "ADR-template.md" } | Sort Name | ForEach {
            $bundle += $sep + (Add-File $_.FullName "decisions/$($_.Name)")
        }
    }
    "full" {
        Get-ChildItem "$base\specs\*.md" -ErrorAction SilentlyContinue | ForEach {
            $bundle += $sep + (Add-File $_.FullName "specs/$($_.Name)")
        }
        Get-ChildItem "$base\decisions\*.md" | Where { $_.Name -ne "ADR-template.md" } | Sort Name | ForEach {
            $bundle += $sep + (Add-File $_.FullName "decisions/$($_.Name)")
        }
    }
    default        { $bundle += $sep + (Add-File "$base\specs\DDP-v1.1.md" "specs/DDP-v1.1.md") }
}

$bundle | Set-Content "$base\context-bundle.md" -Encoding UTF8
$bundle | Set-Clipboard

$lineas = ($bundle -split "`n").Count
Write-Host ""
Write-Host "  Bundle listo (modo: $Modo)" -ForegroundColor Green
Write-Host "  Lineas: $lineas  |  Guardado: context-bundle.md" -ForegroundColor Cyan
Write-Host "  Copiado al portapapeles — Ctrl+V en Claude" -ForegroundColor Yellow
Write-Host ""
