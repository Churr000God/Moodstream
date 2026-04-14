#!/bin/bash
# 02-update.sh
# Descripción: Script para actualizar la aplicación de frontend sin downtime manual prolongado.
# Reconstruye la imagen, elimina el contenedor viejo y arranca el nuevo en un solo comando encadenado.

set -e # Salir inmediatamente en caso de error

# Variables
CONTAINER_NAME="moodstream-frontend"
IMAGE_NAME="moodstream-frontend-img"
PORT="80"
DOCKERFILE_DIR="./frontend"

echo "🔄 Iniciando actualización del Frontend en AWS EC2..."

# 1. Asegurar tener el código más reciente 
# (Descomenta la siguiente línea si usas git en el servidor)
# echo "📥 Haciendo git pull..."
# git pull origin main

# 2. Construir la nueva versión de la imagen Docker
echo "🔨 Construyendo la nueva imagen Docker: $IMAGE_NAME..."
sudo docker build -t $IMAGE_NAME $DOCKERFILE_DIR

# 3. Intercambio rápido de contenedor (Zero-ish downtime local)
echo "🛑 Reemplazando contenedor existente..."

# Intentar detener y borrar el antiguo contenedor (si existe) de forma segura y controlada
if sudo docker ps -a --format '{{.Names}}' | grep -Eq "^${CONTAINER_NAME}\$"; then
    echo "⚠️  Deteniendo el contenedor $CONTAINER_NAME anterior..."
    sudo docker stop $CONTAINER_NAME
    sudo docker rm $CONTAINER_NAME
fi

# 4. Levantar la nueva versión de inmediato
echo "🚢 Levantando el nuevo contenedor en el puerto $PORT..."
sudo docker run -d \
    --name $CONTAINER_NAME \
    -p $PORT:80 \
    --restart unless-stopped \
    $IMAGE_NAME

# 5. Limpieza del sistema (opcional, borra imágenes 'dangling' para no llenar disco en AWS)
echo "🧹 Limpiando imágenes antiguas sin uso..."
sudo docker image prune -f

echo "=========================================="
echo "✅ Actualización completada."
echo "🌍 El frontend fue actualizado y corre en el puerto $PORT."
echo "=========================================="
