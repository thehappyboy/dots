#!/usr/bin/env bash
set -euo pipefail

ROOT="$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)"
target="$HOME/.gemini/antigravity-cli/settings.json"
stable="$ROOT/agy/stable-settings.json"

mkdir -p "$HOME/.gemini/antigravity-cli"
if [ ! -f "$target" ]; then
  printf '{}\n' > "$target"
fi

tmp=$(mktemp "$target.tmp.XXXXXX")
jq --slurpfile stable "$stable" '
  (.permissions.allow // []) as $existing_allow
  | (. * $stable[0])
  | .permissions.allow = (($existing_allow + ($stable[0].permissions.allow // [])) | unique)
' "$target" > "$tmp"

if cmp -s "$tmp" "$target"; then
  rm -f "$tmp"
  printf '[agy] stable settings unchanged: %s\n' "$target"
  exit 0
fi

stamp=$(date +%Y%m%dT%H%M%S)
backup="$target.pre-overlay-$stamp"
cp -p "$target" "$backup"
chmod 600 "$tmp"
mv "$tmp" "$target"
chmod 600 "$target"

printf '[agy] stable settings applied: %s\n' "$target"
printf '[agy] backup: %s\n' "$backup"
