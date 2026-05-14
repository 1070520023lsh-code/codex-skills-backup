# Codex Skills Backup

Personal backup of locally installed Codex skills.

## Restore

Copy the skill folders in this repository into:

```powershell
$env:USERPROFILE\.codex\skills
```

Then restart Codex.

## Sync From This Computer

Run:

```powershell
.\sync-skills-backup.ps1
```

The script copies all local skills except `.system`, updates `skills-manifest.txt`, commits changes, and pushes them to GitHub.

## Included Skills

- brainstorming
- pdf
- playwright
- systematic-debugging
- test-driven-development
- verification-before-completion
