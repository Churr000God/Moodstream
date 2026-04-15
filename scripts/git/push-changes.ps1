param(
  [Parameter(Position = 0)]
  [string]$Message,

  [string]$Remote = 'origin',

  [switch]$AllowMain
)

$ErrorActionPreference = 'Stop'

function Invoke-Git([Parameter(Mandatory = $true)][string[]]$Args) {
  $out = & git @Args 2>&1
  if ($LASTEXITCODE -ne 0) {
    throw ($out | Out-String)
  }
  return ($out | Out-String).Trim()
}

Invoke-Git @('rev-parse', '--is-inside-work-tree') | Out-Null

$branch = Invoke-Git @('rev-parse', '--abbrev-ref', 'HEAD')
if (-not $AllowMain -and $branch -eq 'main') {
  $stamp = Get-Date -Format 'yyyyMMdd-HHmmss'
  $branch = "feature/auto-$stamp"
  Invoke-Git @('checkout', '-b', $branch) | Out-Null
}

if ([string]::IsNullOrWhiteSpace($Message)) {
  $Message = "chore: sync $(Get-Date -Format 'yyyy-MM-dd HH:mm')"
}

Invoke-Git @('status', '--porcelain') | Out-Null
Invoke-Git @('add', '-A') | Out-Null

$staged = Invoke-Git @('diff', '--cached', '--name-only')
if ([string]::IsNullOrWhiteSpace($staged)) {
  Write-Host "No hay cambios para commitear."
  exit 0
}

Invoke-Git @('commit', '-m', $Message) | Out-Null
Invoke-Git @('push', '-u', $Remote, $branch) | Out-Null

Write-Host "Listo: $branch"
