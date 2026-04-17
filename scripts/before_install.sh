#!/usr/bin/env bash
set -euo pipefail

APP_DIR="/home/ec2-user/moodstream"
export COMPOSE_PROJECT_NAME="${COMPOSE_PROJECT_NAME:-moodstream}"

if ! command -v docker >/dev/null 2>&1; then
  echo "docker no está instalado en la instancia"
  exit 1
fi

if ! docker info >/dev/null 2>&1; then
  echo "docker no está disponible (daemon detenido o permisos insuficientes)"
  exit 1
fi

COMPOSE=()
if docker compose version >/dev/null 2>&1; then
  COMPOSE=(docker compose)
elif command -v docker-compose >/dev/null 2>&1; then
  COMPOSE=(docker-compose)
else
  echo "docker compose no está disponible"
  exit 1
fi

mkdir -p "$APP_DIR"

if [ -f "$APP_DIR/docker-compose.yml" ]; then
  cd "$APP_DIR"
  "${COMPOSE[@]}" down --remove-orphans || true
fi
