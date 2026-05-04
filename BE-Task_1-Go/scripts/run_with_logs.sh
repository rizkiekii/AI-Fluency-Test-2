#!/usr/bin/env bash

set -euo pipefail

cd "$(dirname "$0")/.."
mkdir -p logs
exec go run ./cmd/api 1>logs/stdout.log 2>logs/stderr.log