param(
  [string]$Remote = 'origin',
  [string]$Branch = 'main',
  [switch]$Stash
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

$dirty = -not [string]::IsNullOrWhiteSpace((Invoke-Git @('status', '--porcelain')))
$stashName = $null

if ($dirty -and $Stash) {
  $stashName = "auto-stash $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
  Invoke-Git @('stash', 'push', '-u', '-m', $stashName) | Out-Null
}

Invoke-Git @('fetch', $Remote) | Out-Null

$current = Invoke-Git @('rev-parse', '--abbrev-ref', 'HEAD')
if ($current -ne $Branch) {
  Invoke-Git @('checkout', $Branch) | Out-Null
}

Invoke-Git @('pull', '--rebase', $Remote, $Branch) | Out-Null

if ($stashName) {
  $stashes = Invoke-Git @('stash', 'list')
  if ($stashes -match [regex]::Escape($stashName)) {
    Invoke-Git @('stash', 'pop') | Out-Null
  }
}

Write-Host "Actualizado: $Remote/$Branch"
