#!/usr/bin/env bash
set -euo pipefail

ROOT="$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)"
target="$HOME/.codex/config.toml"
stable="$ROOT/codex/stable.toml"

if ! command -v uv >/dev/null 2>&1; then
  printf '[codex] skip: uv is not installed\n' >&2
  exit 1
fi

mkdir -p "$HOME/.codex"
if [ ! -f "$target" ]; then
  : > "$target"
fi

tmp=$(mktemp "$target.tmp.XXXXXX")

uv run --quiet --no-project --managed-python --with tomlkit python - "$stable" "$target" "$tmp" <<'PY'
import sys
from pathlib import Path

import tomlkit
from tomlkit.items import Table

stable_path = Path(sys.argv[1])
target_path = Path(sys.argv[2])
out_path = Path(sys.argv[3])

stable = tomlkit.parse(stable_path.read_text())
target = tomlkit.parse(target_path.read_text()) if target_path.stat().st_size else tomlkit.document()


def merge(dst, src):
    for key, value in src.items():
        if isinstance(value, Table) and isinstance(dst.get(key), Table):
            merge(dst[key], value)
        else:
            dst[key] = value


merge(target, stable)

notify_client = Path.home() / ".codex/computer-use/Codex Computer Use.app/Contents/SharedSupport/SkyComputerUseClient.app/Contents/MacOS/SkyComputerUseClient"
if notify_client.is_file():
    target["notify"] = [str(notify_client), "turn-ended"]

out_path.write_text(tomlkit.dumps(target))
out_path.chmod(0o600)
PY

changed=0
if ! cmp -s "$tmp" "$target"; then
  stamp=$(date +%Y%m%dT%H%M%S)
  backup="$target.pre-overlay-$stamp"
  cp -p "$target" "$backup"
  mv "$tmp" "$target"
  chmod 600 "$target"
  changed=1
  printf '[codex] stable settings applied: %s\n' "$target"
  printf '[codex] backup: %s\n' "$backup"
else
  rm -f "$tmp"
  printf '[codex] stable settings unchanged: %s\n' "$target"
fi

if [ "$changed" -eq 0 ]; then
  printf '[codex] no changes\n'
fi
