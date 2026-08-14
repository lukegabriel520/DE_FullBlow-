param(
  [Parameter(Mandatory = $true, Position = 0)]
  [string]$SqlFile
)

$ErrorActionPreference = "Stop"

$Root = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
Set-Location $Root

if (-not (Test-Path $SqlFile)) {
  Write-Error "File not found: $SqlFile"
  exit 1
}

Get-Content -Path $SqlFile -Raw | docker compose exec -T postgres psql -U de_student -d ecommerce -f -
