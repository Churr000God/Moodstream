# Comandos del proyecto — Docker y Git/GitHub (Moodstream)

Lista práctica de comandos que se usan durante el desarrollo y despliegue del proyecto.

---

## Git (local)

### Estado y cambios
```bash
git status /** para ver estado */
git diff /** para ver cambios */
git diff --staged /** para ver cambios en el índice */
git log --oneline --decorate -n 20 /** para ver últimos commits */
```

### Ramas
```bash
git branch /** para ver ramas */
git checkout -b feature/mi-rama /** para crear una nueva rama */
git checkout main /** para actualizar main */
git pull /** para obtener cambios de GitHub */
```

### Commits
```bash
git add <archivo|carpeta> /** para agregar cambios al índice */
git commit -m "feat(frontend): ..." /** para crear un commit */
```

### Subir cambios
```bash
git push -u origin feature/mi-rama /** para subir cambios a GitHub  en la rama actual */
git push /** para actualizar GitHub */
```

### Deshacer (higiene)
```bash
git restore <archivo> /** para restaurar archivo */
git restore --staged <archivo> /** para restaurar archivo en el índice */   
git reset --soft HEAD~1 /** para restaurar commit */
git reset --hard HEAD~1 /** para restaurar commit y índice */
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

