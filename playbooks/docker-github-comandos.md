# Comandos del proyecto — Docker y Git/GitHub (Moodstream)

Lista práctica de comandos que se usan durante el desarrollo y despliegue del proyecto.

---

## Conceptos clave (Git)

### Repositorio
Un repositorio es la carpeta del proyecto con historial de cambios. Contiene:
- el código y archivos del proyecto
- la carpeta oculta `.git/` con el historial, ramas y referencias

En este proyecto, `Moodstream/` es el repositorio. Los comandos `git status`, `git log`, `git diff` trabajan sobre este repositorio.

### Índice (staging area)
El índice es un “área intermedia” entre tu carpeta de trabajo (working directory) y el historial (commits).
- `git add ...` copia los cambios seleccionados al índice
- `git commit ...` crea un commit usando lo que esté en el índice
- `git diff` muestra cambios sin preparar (working directory)
- `git diff --staged` muestra lo que ya está en el índice y se irá al próximo commit

### Rama (branch)
Una rama es una línea independiente de trabajo (un puntero a una secuencia de commits).
- `main` suele ser la rama estable
- `feature/...` se usa para desarrollar una funcionalidad sin romper `main`

`git checkout -b feature/mi-rama` crea una rama nueva y cambia a ella.

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

## Conceptos clave (Docker)

### Imagen
Una imagen es un “paquete” inmutable con todo lo necesario para correr un servicio (archivos + dependencias + configuración base).
- Se construye con `docker build ...` usando un `Dockerfile`.

### Contenedor
Un contenedor es una instancia en ejecución (o detenida) de una imagen.
- `docker run ...` crea y arranca un contenedor desde una imagen.
- `docker ps` lista contenedores corriendo; `docker ps -a` incluye detenidos.
- `docker logs ...` muestra la salida del contenedor (lo que la app escribe a stdout/stderr).

### Puertos
El mapeo `-p 80:80` significa:
- puerto 80 del host (EC2) → puerto 80 dentro del contenedor
Si cambias el puerto del host, el contenedor puede seguir escuchando en 80 internamente.

### Redes (networks)
Docker conecta contenedores mediante redes. La red por defecto suele ser `bridge`.
- Una red Docker NO es lo mismo que una “subred” (subnet) de AWS, pero se relacionan:
  - AWS Subnet: segmento de red de tu VPC (infra de AWS).
  - Docker Network: red virtual dentro del host (la instancia EC2).

En este proyecto (por ahora) el frontend corre como un único contenedor, por eso los comandos se enfocan en build/run/logs. Si luego agregas backend + db en contenedores, aparecerán comandos como `docker network create` y `docker compose`.

### Inspección
```bash
docker --version /** para ver versión */
docker ps /** para ver contenedores actuales */
docker ps -a /** para ver todos los contenedores */
docker system df /** para ver espacio en disco */
```

### Build + Run (frontend)
```bash
docker build -t moodstream-frontend-img ./frontend /** para construir imagen de frontend */
docker run -d --name moodstream-frontend -p 80:80 --restart unless-stopped moodstream-frontend-img /** para iniciar contenedor de frontend */
```

### Logs y operación
```bash
docker logs --tail 100 moodstream-frontend /** para ver logs de frontend */
docker stop moodstream-frontend /** para detener frontend */
docker rm moodstream-frontend /** para eliminar frontend */
```

### Limpieza
```bash
docker image prune -f /** para eliminar imágenes no utilizadas */
```

---

## EC2 Ubuntu/Debian (Docker)
```bash
sudo apt update && sudo apt upgrade -y /** para actualizar sistema */
sudo apt install -y docker.io docker-compose-v2 curl /** para instalar Docker y Compose */
sudo systemctl enable --now docker /** para iniciar Docker */
```

---

## Scripts AWS del repo (EC2)

Ubicación: `scripts/aws/`

```bash
chmod +x scripts/aws/*.sh

./scripts/aws/01-deploy.sh /** para desplegar el proyecto */
./scripts/aws/02-update.sh /** para actualizar el proyecto */
./scripts/aws/03-fetch-logs.sh /** para obtener logs de AWS */
```

