# Scripts Git — Moodstream

Guía rápida para usar los scripts de automatización de Git en este repo.

## Requisitos
- Tener `git` instalado y accesible desde la terminal.
- Tener permisos para hacer `push` al repositorio remoto configurado.
- Ejecutar los comandos desde la raíz del repo `Moodstream/`.
- En Windows: PowerShell (`pwsh`) recomendado.

## 1) Actualizar el proyecto local

Script: `scripts/git/update-local.ps1`

### Uso básico (actualizar main)
```powershell
.\scripts\git\update-local.ps1 -Remote origin -Branch main
```

### Si tienes cambios locales sin commitear (recomendado)
Este modo guarda temporalmente tus cambios (stash), actualiza y luego intenta re-aplicarlos.
```powershell
.\scripts\git\update-local.ps1 -Remote origin -Branch main -Stash
```

### Qué hace
- `git fetch <remote>`
- `git checkout <branch>` (si no estás en esa rama)
- `git pull --rebase <remote> <branch>`
- Si usaste `-Stash` y el repo estaba “sucio”: `git stash push -u` y luego `git stash pop`

## 2) Subir cambios al repositorio (commit + push)

Script: `scripts/git/push-changes.ps1`

### Uso básico (crea rama si estás en main)
```powershell
.\scripts\git\push-changes.ps1 "feat: mi cambio"
```

### Subir a un remoto específico
```powershell
.\scripts\git\push-changes.ps1 "chore: update" -Remote origin
```

### Permitir commit directo en main (no recomendado)
```powershell
.\scripts\git\push-changes.ps1 "hotfix: ..." -AllowMain
```

### Qué hace
- Detecta la rama actual con `git rev-parse --abbrev-ref HEAD`
- Si estás en `main` y NO pasas `-AllowMain`, crea una rama `feature/auto-YYYYMMDD-HHmmss`
- `git add -A`
- Si no hay cambios staged, termina sin commitear
- `git commit -m "<mensaje>"`
- `git push -u <remote> <rama>`

## Notas prácticas
- Si `update-local.ps1` falla diciendo que tienes cambios sin stage, vuelve a ejecutar con `-Stash`.
- Si tienes conflictos durante `pull --rebase`, resuélvelos y continúa con:
  - `git rebase --continue`
  - o cancela con `git rebase --abort`

