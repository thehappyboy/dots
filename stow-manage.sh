#!/bin/sh
set -eu

ROOT="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
TARGET="${HOME}"
MODULES="npm uv bat fish git nvim ruff warp ghostty starship agy"

for module in $MODULES; do
  stow --dir="$ROOT" --target="$TARGET" --restow "$module"
done

# Sublime Text - target 是 ~/Library/... 下的 Packages/User
SUBLIME_TARGET="$HOME/Library/Application Support/Sublime Text/Packages/User"
mkdir -p "$SUBLIME_TARGET"
stow --dir="$ROOT" --target="$SUBLIME_TARGET" --restow sublime

for script in \
  "$ROOT/claude/apply.sh" \
  "$ROOT/codex/apply.sh" \
  "$ROOT/claude-desktop-3p/apply.sh"
do
  if [ -x "$script" ]; then
    "$script"
  else
    printf '[stow] skip non-executable overlay: %s\n' "$script" >&2
  fi
done
