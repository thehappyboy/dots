#!/bin/sh
set -eu

ROOT="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
MODE="${1:-ask}"

case "$MODE" in
  --ask|ask) MODE=ask ;;
  --yes|yes) MODE=yes ;;
  --no|no) MODE=no ;;
  -h|--help)
    cat <<'EOF'
Usage: ./apply-overlays.sh [--ask|--yes|--no]

  --ask  Ask before each optional application config (default).
  --yes  Apply all optional application configs without prompting.
  --no   Skip all optional application configs.

Claude Desktop 3P must have been launched once before its config can be
applied; otherwise its overlay is a no-op.
EOF
    exit 0
    ;;
  *)
    printf 'unknown option: %s\n' "$MODE" >&2
    exit 2
    ;;
esac

if [ "$MODE" = ask ] && [ ! -t 0 ]; then
  printf '[overlays] non-interactive stdin: skipped optional app configs\n'
  printf '[overlays] run ./apply-overlays.sh to choose, or ./apply-overlays.sh --yes to apply all\n'
  exit 0
fi

claude_detected=false
if command -v claude >/dev/null 2>&1 || [ -f "$HOME/.claude/settings.json" ]; then
  claude_detected=true
fi

codex_detected=false
if command -v codex >/dev/null 2>&1 || [ -f "$HOME/.codex/config.toml" ] || [ -d "/Applications/Codex.app" ]; then
  codex_detected=true
fi

desktop_detected=false
if [ -d "/Applications/Claude-3p.app" ] || [ -d "$HOME/Applications/Claude-3p.app" ] || \
   [ -f "$HOME/Library/Application Support/Claude-3p/claude_desktop_config.json" ]; then
  desktop_detected=true
fi

agy_detected=false
if command -v agy >/dev/null 2>&1 || [ -f "$HOME/.gemini/antigravity-cli/settings.json" ]; then
  agy_detected=true
fi

zed_detected=false
if [ -d "/Applications/Zed.app" ] || [ -d "$HOME/Applications/Zed.app" ] || \
   command -v zed >/dev/null 2>&1 || [ -f "$HOME/.config/zed/settings.json" ]; then
  zed_detected=true
fi

confirm() {
  label=$1
  detected=$2

  if [ "$MODE" = yes ]; then
    return 0
  fi
  if [ "$MODE" = no ]; then
    return 1
  fi

  if [ "$detected" = true ]; then
    printf '[overlays] %s detected\n' "$label"
  else
    printf '[overlays] %s not detected; default is skip\n' "$label"
  fi
  printf '[overlays] apply %s config? [y/N] ' "$label"
  IFS= read -r answer || answer=
  case "$answer" in
    y|Y|yes|YES) return 0 ;;
    *) return 1 ;;
  esac
}

apply_one() {
  label=$1
  script=$2
  detected=$3

  if [ ! -x "$script" ]; then
    printf '[overlays] skip non-executable: %s\n' "$script" >&2
    return 0
  fi

  if confirm "$label" "$detected"; then
    printf '[overlays] applying %s\n' "$label"
    "$script"
  else
    printf '[overlays] skipped %s\n' "$label"
  fi
}

apply_one "Claude Code" "$ROOT/claude/apply.sh" "$claude_detected"
apply_one "Codex" "$ROOT/codex/apply.sh" "$codex_detected"
apply_one "Claude Desktop 3P" "$ROOT/claude-desktop-3p/apply.sh" "$desktop_detected"
apply_one "Antigravity CLI (agy)" "$ROOT/agy/apply.sh" "$agy_detected"
apply_one "Zed" "$ROOT/zed/apply.sh" "$zed_detected"
