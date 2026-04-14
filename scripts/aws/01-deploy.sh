#!/bin/bash
# 01-deploy.sh
# Descripción: Script idempotente para el despliegue inicial del frontend en instancias EC2.
# Este script instala Docker si no está presente y levanta el contenedor.

set -e # Salir inmediatamente si algún comando falla

# Variables
CONTAINER_NAME="moodstream-frontend"
IMAGE_NAME="moodstream-frontend-img"
PORT="80"
DOCKERFILE_DIR="./frontend"

echo "🚀 Iniciando despliegue de Moodstream Frontend en AWS EC2..."

# 1. Verificar e instalar Docker (idempotente)
if ! command -v docker &> /dev/null; then
    echo "📦 Docker no encontrado. Instalando dependencias..."
    sudo apt update && sudo apt upgrade -y
    sudo apt install -y docker.io docker-compose-v2 curl
    sudo systemctl enable --now docker
    echo "✅ Docker instalado exitosamente."
else
    echo "✅ Docker ya está instalado."
fi

# 2. Construir la imagen Docker del Frontend
echo "🔨 Construyendo la imagen Docker: $IMAGE_NAME..."
sudo docker build -t $IMAGE_NAME $DOCKERFILE_DIR

# 3. Limpiar contenedores huérfanos si existen (por seguridad)
if sudo docker ps -a --format '{{.Names}}' | grep -Eq "^${CONTAINER_NAME}\$"; then
    echo "⚠️  El contenedor $CONTAINER_NAME ya existe. Deteniendo y eliminando..."
    sudo docker stop $CONTAINER_NAME || true
    sudo docker rm $CONTAINER_NAME || true
fi

# 4. Desplegar el contenedor
echo "🚢 Levantando el contenedor en el puerto $PORT..."
sudo docker run -d \
    --name $CONTAINER_NAME \
    -p $PORT:80 \
    --restart unless-stopped \
    $IMAGE_NAME

echo "=========================================="
echo "✅ Despliegue completado."
echo "🌍 El frontend está corriendo en el puerto $PORT."
echo "🔍 Puedes verificar el estado con: sudo docker ps"
echo "=========================================="
