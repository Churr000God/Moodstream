#!/usr/bin/env bash
set -euo pipefail

APP_DIR="/home/ec2-user/moodstream"
LOG_DIR="${APP_DIR}/logs/codedeploy"
TIMESTAMP="$(date +%Y%m%d_%H%M%S)"
export COMPOSE_PROJECT_NAME="${COMPOSE_PROJECT_NAME:-moodstream}"

mkdir -p "$LOG_DIR"

ensure_compose() {
  if command -v docker >/dev/null 2>&1 && docker compose version >/dev/null 2>&1; then
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
    true
  fi

  if command -v docker >/dev/null 2>&1 && docker compose version >/dev/null 2>&1; then
    COMPOSE=(docker compose)
    return 0
  fi

  if command -v docker-compose >/dev/null 2>&1; then
    COMPOSE=(docker-compose)
    return 0
  fi

  if ! command -v curl >/dev/null 2>&1; then
    if command -v apt-get >/dev/null 2>&1; then
      apt-get update -y
      apt-get install -y curl
    elif command -v dnf >/dev/null 2>&1; then
      dnf install -y curl
    elif command -v yum >/dev/null 2>&1; then
      yum install -y curl
    fi
  fi

  if command -v curl >/dev/null 2>&1; then
    arch="$(uname -m)"
    if [ "$arch" = "x86_64" ]; then
      arch="x86_64"
    elif [ "$arch" = "aarch64" ] || [ "$arch" = "arm64" ]; then
      arch="aarch64"
    else
      return 1
    fi

    version="${DOCKER_COMPOSE_VERSION:-v2.27.0}"
    dest_dir="/usr/local/lib/docker/cli-plugins"
    mkdir -p "$dest_dir"
    curl -fsSL "https://github.com/docker/compose/releases/download/${version}/docker-compose-linux-${arch}" -o "${dest_dir}/docker-compose"
    chmod 755 "${dest_dir}/docker-compose"
  fi

  if command -v docker >/dev/null 2>&1 && docker compose version >/dev/null 2>&1; then
    COMPOSE=(docker compose)
    return 0
  fi

  if command -v docker-compose >/dev/null 2>&1; then
    COMPOSE=(docker-compose)
    return 0
  fi

  return 1
}

COMPOSE=()
ensure_compose || true

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
