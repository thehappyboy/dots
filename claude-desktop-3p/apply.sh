#!/usr/bin/env bash
set -euo pipefail

ROOT="$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)"
base="$HOME/Library/Application Support/Claude-3p"
config="$base/claude_desktop_config.json"
library="$base/configLibrary"
meta="$library/_meta.json"
policy="$ROOT/claude-desktop-3p/policies.json"

if [ ! -f "$config" ] || [ ! -f "$meta" ]; then
  printf '[claude-desktop-3p] skip: launch Claude-3p once first\n'
  exit 0
fi

if ! command -v jq >/dev/null 2>&1; then
  printf '[claude-desktop-3p] skip: jq is not installed\n' >&2
  exit 1
fi

applied_id=$(jq -r '.appliedId // empty' "$meta")
profile="$library/$applied_id.json"
if [ -z "$applied_id" ] || [ ! -f "$profile" ]; then
  printf '[claude-desktop-3p] skip: active config profile not found\n'
  exit 0
fi

tmp_config=$(mktemp "$config.tmp.XXXXXX")
jq --slurpfile policy "$policy" '
  .deploymentMode = $policy[0].deploymentMode
  | .preferences = ((.preferences // {}) + $policy[0].preferences)
  | .preferences.bypassPermissionsOptInByAccount =
      ((.preferences.bypassPermissionsOptInByAccount // {}) | with_entries(.value = true))
  | .preferences.bypassPermissionsGateByAccount =
      ((.preferences.bypassPermissionsGateByAccount // {}) | with_entries(.value = true))
  | .preferences.bypassPermissionsGateWithoutDeviceLockByAccount =
      ((.preferences.bypassPermissionsGateWithoutDeviceLockByAccount // {}) | with_entries(.value = true))
  | .preferences.coworkModelAutoFallbackByAccount =
      ((.preferences.coworkModelAutoFallbackByAccount // {}) | with_entries(.value = true))
  | .preferences.chicagoChoiceByOrgAccount =
      ((.preferences.chicagoChoiceByOrgAccount // {}) | with_entries(
        .value = ((.value // {}) + $policy[0].orgAccountPreferences)
      ))
' "$config" > "$tmp_config"

tmp_profile=$(mktemp "$profile.tmp.XXXXXX")
jq --slurpfile policy "$policy" '. + $policy[0].profile' "$profile" > "$tmp_profile"

if cmp -s "$tmp_config" "$config" && cmp -s "$tmp_profile" "$profile"; then
  rm -f "$tmp_config" "$tmp_profile"
  printf '[claude-desktop-3p] stable preferences unchanged: %s\n' "$config"
  exit 0
fi

stamp=$(date +%Y%m%dT%H%M%S)
cp -p "$config" "$config.pre-overlay-$stamp"
cp -p "$profile" "$profile.pre-overlay-$stamp"

chmod 600 "$tmp_config" "$tmp_profile"
mv "$tmp_config" "$config"
mv "$tmp_profile" "$profile"
chmod 600 "$config" "$profile"

printf '[claude-desktop-3p] stable preferences applied: %s\n' "$config"
printf '[claude-desktop-3p] active profile: %s\n' "$profile"
printf '[claude-desktop-3p] backups: %s.pre-overlay-%s, %s.pre-overlay-%s\n' "$config" "$stamp" "$profile" "$stamp"
