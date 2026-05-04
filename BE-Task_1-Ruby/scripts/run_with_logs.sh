#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

cd "$ROOT_DIR"
mkdir -p logs
export HOST="${HOST:-0.0.0.0}"
export PORT="${PORT:-8585}"
export RAILS_ENV="${RAILS_ENV:-development}"

exec bundle exec ruby entrypoint/server.rb 1>logs/stdout.log 2>logs/stderr.log
