#!/bin/bash
# 03-fetch-logs.sh
# Descripción: Script para obtener los últimos 100 logs del contenedor frontend.
# Los imprime en pantalla y los guarda con timestamp en una carpeta dedicada.

set -e # Salir inmediatamente en caso de error

# Variables
CONTAINER_NAME="moodstream-frontend"
LOG_DIR="./logs/aws-logs"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
LOG_FILE="${LOG_DIR}/frontend_${TIMESTAMP}.log"
LINES=100

echo "📂 Preparando directorio de logs..."
# 1. Crear el directorio si no existe de manera idempotente
mkdir -p "$LOG_DIR"

# 2. Verificar si el contenedor está corriendo
if ! sudo docker ps -a --format '{{.Names}}' | grep -Eq "^${CONTAINER_NAME}\$"; then
    echo "❌ Error: El contenedor '$CONTAINER_NAME' no existe."
    exit 1
fi

echo "📜 Obteniendo los últimos $LINES logs del contenedor '$CONTAINER_NAME'..."

# 3. Guardar logs en el archivo con rotación de timestamp
sudo docker logs --tail $LINES $CONTAINER_NAME > "$LOG_FILE" 2>&1

echo "=========================================="
echo "📄 Mostrando últimos logs en pantalla:"
echo "=========================================="
# 4. Imprimir el archivo por consola
cat "$LOG_FILE"
echo "=========================================="

# 5. Seguridad: Dar permisos restrictivos al archivo de logs (solo lectura para el dueño)
chmod 644 "$LOG_FILE"

echo "✅ Logs guardados exitosamente en: $LOG_FILE"
