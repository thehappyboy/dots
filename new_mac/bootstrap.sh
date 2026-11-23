#!/usr/bin/env bash
set -euo pipefail

ROOT="$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)"

log() { printf '[bootstrap] %s\n' "$*"; }

log "1/4 macOS system settings"
if [ "${SKIP_MACOS_SETTINGS:-0}" = "1" ]; then
  log "skipped (SKIP_MACOS_SETTINGS=1)"
else
  "$ROOT/new_mac/settings.sh"
fi

log "2/4 Homebrew and Brewfile"
"$ROOT/new_mac/brew_install.sh"

for command in stow jq uv nvim; do
  if ! command -v "$command" >/dev/null 2>&1; then
    printf '[bootstrap] missing required command: %s\n' "$command" >&2
    printf '[bootstrap] check the Brewfile result before applying dotfiles\n' >&2
    exit 1
  fi
done

log "3/4 Stow static modules"
DOTS_DEFER_OVERLAYS=1 "$ROOT/stow-manage.sh"

log "4/4 Post-install checks, Neovim Python and optional app configs"
"$ROOT/new_mac/post_install.sh"

log "complete"
