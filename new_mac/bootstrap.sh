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

log "3/4 Stow modules and overlays"
"$ROOT/stow-manage.sh"

log "4/4 Post-install checks and Neovim Python"
"$ROOT/new_mac/post_install.sh"

log "complete"
