#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$SCRIPT_DIR/lib/module-runtime.sh"
COLOR_MODULE_ID="niri"

COLORS_FILE="$STATE_DIR/user/generated/colors.json"
NIRI_CONF="${XDG_CONFIG_HOME:-$HOME/.config}/niri/config.d/20-layout-and-overview.kdl"

[[ -f "$COLORS_FILE" ]] || exit 0
[[ -f "$NIRI_CONF" ]] || exit 0

primary=$(jq -r '.primary // empty' "$COLORS_FILE")
container=$(jq -r '.primary_container // empty' "$COLORS_FILE")

[[ -n "$primary" && -n "$container" ]] || exit 0

# Replace active-gradient in Niri's focus-ring
sed -i -E "s|active-gradient from=\"[^\"]+\" to=\"[^\"]+\"|active-gradient from=\"$primary\" to=\"$container\"|" "$NIRI_CONF"

# Hot-reload Niri if active socket is present
socket=$(ls /run/user/$(id -u)/niri*.sock 2>/dev/null | head -n 1 || true)
if [[ -n "$socket" ]]; then
    NIRI_SOCKET="$socket" niri msg action load-config-file 2>/dev/null || true
fi
