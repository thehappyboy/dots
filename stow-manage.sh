#!/bin/sh
set -eu

ROOT="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
TARGET="${HOME}"
MODULES="npm uv bat fish git nvim ruff warp ghostty starship"

for command in stow jq uv; do
  if ! command -v "$command" >/dev/null 2>&1; then
    printf '[stow] missing required command: %s\n' "$command" >&2
    printf '[stow] install the Brewfile first, then rerun this script\n' >&2
    exit 1
  fi
done

for module in $MODULES; do
  stow --dir="$ROOT" --target="$TARGET" --restow "$module"
done

# Sublime Text - target 是 ~/Library/... 下的 Packages/User
SUBLIME_TARGET="$HOME/Library/Application Support/Sublime Text/Packages/User"
mkdir -p "$SUBLIME_TARGET"
stow --dir="$ROOT" --target="$SUBLIME_TARGET" --restow sublime

if [ "${DOTS_DEFER_OVERLAYS:-0}" = "1" ]; then
  printf '[stow] optional app configs deferred to post-install\n'
else
  "$ROOT/apply-overlays.sh" --ask
fi
