#!/usr/bin/env bash
set -euo pipefail

APP_DIR="/home/ec2-user/moodstream"
export COMPOSE_PROJECT_NAME="${COMPOSE_PROJECT_NAME:-moodstream}"

ensure_compose() {
  if docker compose version >/dev/null 2>&1; then
    COMPOSE=(docker compose)
    return 0
  fi

  if command -v docker-compose >/dev/null 2>&1; then
    COMPOSE=(docker-compose)
    return 0
  fi

  if command -v apt-get >/dev/null 2>&1; then
    apt-get update -y
    apt-get install -y docker-compose-plugin || apt-get install -y docker-compose
  elif command -v dnf >/dev/null 2>&1; then
    dnf install -y docker-compose-plugin || dnf install -y docker-compose
  elif command -v yum >/dev/null 2>&1; then
    yum install -y docker-compose-plugin || yum install -y docker-compose
  else
    return 1
  fi

  if docker compose version >/dev/null 2>&1; then
    COMPOSE=(docker compose)
    return 0
  fi

  if command -v docker-compose >/dev/null 2>&1; then
    COMPOSE=(docker-compose)
    return 0
  fi

  return 1
}

if ! command -v docker >/dev/null 2>&1; then
  echo "docker no está instalado en la instancia"
  exit 1
fi

if ! docker info >/dev/null 2>&1; then
  echo "docker no está disponible (daemon detenido o permisos insuficientes)"
  exit 1
fi

COMPOSE=()
if ! ensure_compose; then
  echo "docker compose no está disponible"
  exit 1
fi

if [ ! -f "$APP_DIR/docker-compose.yml" ]; then
  echo "No se encontró docker-compose.yml en $APP_DIR"
  exit 1
fi

cd "$APP_DIR"
("${COMPOSE[@]}" up -d --build --remove-orphans)
