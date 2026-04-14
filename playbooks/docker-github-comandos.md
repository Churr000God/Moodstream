# Comandos del proyecto — Docker y Git/GitHub (Moodstream)

Lista práctica de comandos que se usan durante el desarrollo y despliegue del proyecto.

---

## Git (local)

### Estado y cambios
```bash
git status
git diff
git diff --staged
git log --oneline --decorate -n 20
```

### Ramas
```bash
git branch
git checkout -b feature/mi-rama
git checkout main
git pull
```

### Commits
```bash
git add <archivo|carpeta>
git commit -m "feat(frontend): ..."
```

### Subir cambios
```bash
git push -u origin feature/mi-rama
git push
```

### Deshacer (higiene)
```bash
git restore <archivo>
git restore --staged <archivo>
git reset --soft HEAD~1
git reset --hard HEAD~1
```

---

## GitHub (flujo)

### Pull Request
- Crear PR desde GitHub UI o con el link que devuelve `git push`.
- Merge recomendado: Squash and Merge (cuando aplique) para mantener historial limpio.

---

## Docker (local o EC2)

### Inspección
```bash
docker --version
docker ps
docker ps -a
docker image ls
docker system df
```

### Build + Run (frontend)
```bash
docker build -t moodstream-frontend-img ./frontend
docker run -d --name moodstream-frontend -p 80:80 --restart unless-stopped moodstream-frontend-img
```

### Logs y operación
```bash
docker logs --tail 100 moodstream-frontend
docker stop moodstream-frontend
docker rm moodstream-frontend
```

### Limpieza
```bash
docker image prune -f
```

---

## EC2 Ubuntu/Debian (Docker)
```bash
sudo apt update && sudo apt upgrade -y
sudo apt install -y docker.io docker-compose-v2 curl
sudo systemctl enable --now docker
```

---

## Scripts AWS del repo (EC2)

Ubicación: `scripts/aws/`

```bash
chmod +x scripts/aws/*.sh

./scripts/aws/01-deploy.sh
./scripts/aws/02-update.sh
./scripts/aws/03-fetch-logs.sh
```

