#!/usr/bin/env bash
set -euo pipefail

ROOT="$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)"
target="$HOME/.claude/settings.json"
stable="$ROOT/claude/stable-settings.json"

mkdir -p "$HOME/.claude"
if [ ! -f "$target" ]; then
  printf '{}\n' > "$target"
fi

tmp=$(mktemp "$target.tmp.XXXXXX")
jq --slurpfile stable "$stable" '
  . + $stable[0]
' "$target" > "$tmp"

if cmp -s "$tmp" "$target"; then
  rm -f "$tmp"
  printf '[claude] stable settings unchanged: %s\n' "$target"
  exit 0
fi

stamp=$(date +%Y%m%dT%H%M%S)
backup="$target.pre-overlay-$stamp"
cp -p "$target" "$backup"
chmod 600 "$tmp"
mv "$tmp" "$target"
chmod 600 "$target"

printf '[claude] stable settings applied: %s\n' "$target"
printf '[claude] backup: %s\n' "$backup"
