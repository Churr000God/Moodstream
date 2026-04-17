#!/usr/bin/env bash
set -euo pipefail

APP_DIR="/home/ec2-user/moodstream"
LOG_DIR="${APP_DIR}/logs/codedeploy"
TIMESTAMP="$(date +%Y%m%d_%H%M%S)"
export COMPOSE_PROJECT_NAME="${COMPOSE_PROJECT_NAME:-moodstream}"

mkdir -p "$LOG_DIR"

COMPOSE=()
if command -v docker >/dev/null 2>&1 && docker compose version >/dev/null 2>&1; then
  COMPOSE=(docker compose)
elif command -v docker-compose >/dev/null 2>&1; then
  COMPOSE=(docker-compose)
fi

if [ ! -f "$APP_DIR/docker-compose.yml" ]; then
  echo "No se encontró docker-compose.yml en $APP_DIR"
  exit 1
fi

cd "$APP_DIR"

STATUS_FILE="${LOG_DIR}/status_${TIMESTAMP}.log"
LOG_FILE="${LOG_DIR}/compose_${TIMESTAMP}.log"

if [ "${#COMPOSE[@]}" -gt 0 ]; then
  "${COMPOSE[@]}" ps > "$STATUS_FILE" 2>&1 || true
  "${COMPOSE[@]}" logs --timestamps --tail 200 > "$LOG_FILE" 2>&1 || true
  chmod 640 "$STATUS_FILE" "$LOG_FILE" || true
fi

if ! command -v curl >/dev/null 2>&1; then
  echo "curl no está instalado; no se puede validar el servicio por HTTP"
  exit 1
fi

backend_ok=0
frontend_ok=0

for _ in $(seq 1 30); do
  if curl -fsS "http://localhost:3001/health" >/dev/null 2>&1; then
    backend_ok=1
  fi

  if curl -fsS "http://localhost:5173" >/dev/null 2>&1; then
    frontend_ok=1
  fi

  if [ "$backend_ok" -eq 1 ] && [ "$frontend_ok" -eq 1 ]; then
    exit 0
  fi

  sleep 2
done

echo "Validación fallida: backend_ok=$backend_ok frontend_ok=$frontend_ok"
exit 1
