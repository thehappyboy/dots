#!/usr/bin/env bash
set -euo pipefail

log() { printf '[post-install] %s\n' "$*"; }
warn() { printf '[post-install] WARN: %s\n' "$*" >&2; }

# Neovim's Python provider is intentionally a local venv. The nvim config
# points at this exact path, so keep it independent of the user's global Python.
if ! command -v nvim >/dev/null 2>&1 || ! command -v uv >/dev/null 2>&1; then
  warn "nvim or uv is missing; install the Brewfile before running post-install"
  exit 1
fi
if ! command -v jq >/dev/null 2>&1; then
  warn "jq is missing; install the Brewfile before running post-install"
  exit 1
fi

venv="$HOME/.config/nvim/.venv"
if [ ! -x "$venv/bin/python" ]; then
  log "creating Neovim Python venv: $venv"
  uv venv "$venv"
fi
log "installing pynvim into $venv"
uv pip install --python "$venv/bin/python" pynvim
"$venv/bin/python" -c 'import pynvim; print("[post-install] pynvim OK:", pynvim.__version__)'

root="$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)"

if command -v magpie >/dev/null 2>&1; then
  log "syncing magpie library"
  magpie library sync || warn "magpie library sync failed"
  magpie claude-desktop provider magpie || warn "could not switch Claude Desktop to magpie"
fi

# Keep the stable parts of Claude/Codex/Desktop 3P settings after magpie or
# an app writes its dynamic state. All scripts preserve unrelated keys.
for script in \
  "$root/claude/apply.sh" \
  "$root/codex/apply.sh" \
  "$root/claude-desktop-3p/apply.sh"
do
  if [ -x "$script" ]; then
    "$script"
  fi
done

log "CLI presence:"
for cmd in lark-cli desktop-commander opencli qmd mcporter playwright; do
  if command -v "$cmd" >/dev/null 2>&1; then
    printf '  OK   %s -> %s\n' "$cmd" "$(command -v "$cmd")"
  else
    printf '  WARN %s not on PATH\n' "$cmd"
  fi
done

if command -v lark-cli >/dev/null 2>&1; then
  if lark-cli doctor 2>/dev/null | jq -e '.ok == true' >/dev/null; then
    log "lark-cli doctor: OK (interactive user auth may still be required)"
  else
    warn "lark-cli doctor reported a problem; run it directly"
  fi
fi

if command -v opencli >/dev/null 2>&1; then
  if opencli doctor 2>/dev/null | jq -e '.ok == true and .data.connectivity.ok == true' >/dev/null; then
    log "opencli doctor: OK"
  else
    warn "opencli doctor reports a disconnected browser bridge; run it directly"
  fi
fi

cat <<'EOF'
[post-install] Manual next steps (interactive login is intentionally not automated):
  lark-cli doctor && lark-cli auth login --help
  opencli doctor && opencli auth status
  opencli extension: install the Browser Bridge extension if doctor says it is disconnected
  qmd init                         # only if you use a local QMD index
  magpie library sync              # keep MCP/skills assigned to Claude Desktop
EOF
