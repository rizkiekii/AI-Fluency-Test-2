#!/usr/bin/env bash

set -euo pipefail

cd "$(dirname "$0")/.."
mkdir -p logs
exec ./mvnw spring-boot:run >logs/stdout.log 2>logs/stderr.log
