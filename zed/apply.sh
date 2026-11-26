#!/usr/bin/env bash
set -euo pipefail

ROOT="$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)"
zed_dir="$HOME/.config/zed"
target="$zed_dir/settings.json"
stable="$ROOT/zed/stable-settings.json"
keymap_src="$ROOT/zed/keymap.json"
keymap_dst="$zed_dir/keymap.json"

mkdir -p "$zed_dir"
if [ ! -f "$target" ]; then
  printf '{}\n' > "$target"
fi

tmp=$(mktemp "$target.tmp.XXXXXX")

python3 - "$stable" "$target" "$tmp" <<'PY'
import json
import os
import shutil
import sys
from pathlib import Path


def strip_jsonc(text: str) -> str:
    out = []
    i = 0
    n = len(text)
    in_str = False
    escape = False
    while i < n:
        ch = text[i]
        if in_str:
            out.append(ch)
            if escape:
                escape = False
            elif ch == "\\":
                escape = True
            elif ch == '"':
                in_str = False
            i += 1
            continue
        if ch == '"':
            in_str = True
            out.append(ch)
            i += 1
        elif ch == "/" and i + 1 < n and text[i + 1] == "/":
            i += 2
            while i < n and text[i] != "\n":
                i += 1
        elif ch == "/" and i + 1 < n and text[i + 1] == "*":
            i += 2
            while i + 1 < n and not (text[i] == "*" and text[i + 1] == "/"):
                i += 1
            i += 2
        else:
            out.append(ch)
            i += 1
    # Remove trailing commas before } or ]
    raw = "".join(out)
    res = []
    i = 0
    n = len(raw)
    in_str = False
    escape = False
    while i < n:
        ch = raw[i]
        if in_str:
            res.append(ch)
            if escape:
                escape = False
            elif ch == "\\":
                escape = True
            elif ch == '"':
                in_str = False
            i += 1
            continue
        if ch == '"':
            in_str = True
            res.append(ch)
            i += 1
        elif ch == ",":
            j = i + 1
            while j < n and raw[j] in " \t\r\n":
                j += 1
            if j < n and raw[j] in "}]":
                i += 1
                continue
            res.append(ch)
            i += 1
        else:
            res.append(ch)
            i += 1
    return "".join(res)


def deep_merge(dst, src):
    for k, v in src.items():
        if isinstance(v, dict) and isinstance(dst.get(k), dict):
            deep_merge(dst[k], v)
        else:
            dst[k] = v


def find_bin(name: str):
    home = Path.home()
    candidates = [
        shutil.which(name),
        str(home / ".local/bin" / name),
        str(home / ".cargo/bin" / name),
        f"/opt/homebrew/bin/{name}",
        f"/usr/local/bin/{name}",
    ]
    for c in candidates:
        if c and os.path.isfile(c) and os.access(c, os.X_OK):
            return c
    return None


stable_path, target_path, out_path = map(Path, sys.argv[1:4])
stable = json.loads(stable_path.read_text(encoding="utf-8"))
target_raw = target_path.read_text(encoding="utf-8").strip()
target = json.loads(strip_jsonc(target_raw)) if target_raw else {}

deep_merge(target, stable)

lsp = target.setdefault("lsp", {})
for tool in ("ty", "ruff", "rust-analyzer"):
    bin_path = find_bin(tool)
    if bin_path:
        lsp.setdefault(tool, {}).setdefault("binary", {})["path"] = bin_path

out_path.write_text(json.dumps(target, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")
PY

if cmp -s "$tmp" "$target"; then
  rm -f "$tmp"
  printf '[zed] stable settings unchanged: %s\n' "$target"
else
  stamp=$(date +%Y%m%dT%H%M%S)
  backup="$target.pre-overlay-$stamp"
  cp -p "$target" "$backup"
  chmod 600 "$tmp"
  mv "$tmp" "$target"
  chmod 600 "$target"
  printf '[zed] stable settings applied: %s\n' "$target"
  printf '[zed] backup: %s\n' "$backup"
fi

if [ -f "$keymap_src" ]; then
  if [ -f "$keymap_dst" ] && cmp -s "$keymap_src" "$keymap_dst"; then
    printf '[zed] keymap unchanged: %s\n' "$keymap_dst"
  else
    if [ -f "$keymap_dst" ]; then
      stamp=$(date +%Y%m%dT%H%M%S)
      cp -p "$keymap_dst" "$keymap_dst.pre-overlay-$stamp"
    fi
    cp "$keymap_src" "$keymap_dst"
    chmod 644 "$keymap_dst"
    printf '[zed] keymap applied: %s\n' "$keymap_dst"
  fi
fi
