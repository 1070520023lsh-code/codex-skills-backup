param(
  [string]$SkillsDir = "$env:USERPROFILE\.codex\skills",
  [string]$BackupDir = $PSScriptRoot
)

$ErrorActionPreference = "Stop"

if (-not (Test-Path -LiteralPath $SkillsDir)) {
  throw "Skills directory not found: $SkillsDir"
}

if (-not (Test-Path -LiteralPath (Join-Path $BackupDir ".git"))) {
  throw "Backup directory is not a git repository: $BackupDir"
}

$excluded = @(".system")
$skills = Get-ChildItem -LiteralPath $SkillsDir -Directory |
  Where-Object { $excluded -notcontains $_.Name } |
  Sort-Object Name

foreach ($skill in $skills) {
  $destination = Join-Path $BackupDir $skill.Name
  if (Test-Path -LiteralPath $destination) {
    Remove-Item -LiteralPath $destination -Recurse -Force
  }
  Copy-Item -LiteralPath $skill.FullName -Destination $destination -Recurse -Force
}

$manifest = Join-Path $BackupDir "skills-manifest.txt"
$skills.Name | Set-Content -LiteralPath $manifest -Encoding utf8

Push-Location $BackupDir
try {
  git add .
  $changes = git status --porcelain
  if (-not $changes) {
    Write-Host "No skill changes to back up."
    exit 0
  }

  $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
  git commit -m "Sync Codex skills $timestamp"
  git push
}
finally {
  Pop-Location
}

