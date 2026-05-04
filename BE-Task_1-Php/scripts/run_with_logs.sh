#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT_DIR"

mkdir -p logs

APP_ENV="${APP_ENV:-dev}" \
APP_HOST="${APP_HOST:-0.0.0.0}" \
APP_PORT="${APP_PORT:-8585}" \
php entrypoint/server.php 1>logs/stdout.log 2>logs/stderr.log
