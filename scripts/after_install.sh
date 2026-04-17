#!/usr/bin/env bash
set -euo pipefail

APP_DIR="/home/ec2-user/moodstream"

if [ ! -d "$APP_DIR" ]; then
  echo "Directorio de aplicación no existe: $APP_DIR"
  exit 1
fi

mkdir -p "$APP_DIR/logs/codedeploy"

if [ -d "$APP_DIR/scripts" ]; then
  find "$APP_DIR/scripts" -maxdepth 2 -type f -name "*.sh" -exec chmod 755 {} \;
fi

chown -R ec2-user:ec2-user "$APP_DIR/logs" || true
