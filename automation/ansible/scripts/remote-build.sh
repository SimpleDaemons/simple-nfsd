#!/usr/bin/env bash
# Thin wrapper → monorepo shared automation/build
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ANSIBLE="$(cd "$SCRIPT_DIR/.." && pwd)"
PROJECT_ROOT="$(cd "$PROJECT_ANSIBLE/../.." && pwd)"
PROJECT_NAME="$(basename "$PROJECT_ROOT")"
MONOREPO_ROOT="$(cd "$PROJECT_ROOT/../.." && pwd)"
SHARED="${MONOREPO_ROOT}/automation/build/scripts/remote-build.sh"
if [ -x "$SHARED" ]; then
  exec "$SHARED" -p "$PROJECT_NAME" "$@"
fi
echo "[ERROR] Shared remote-build not found: $SHARED" >&2
echo "Run from a SimpleDaemons monorepo checkout." >&2
exit 1

