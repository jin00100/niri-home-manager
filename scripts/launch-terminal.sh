#!/usr/bin/env bash
# Launch the configured terminal emulator
# Reads from iNiR config, falls back to kitty (project default)

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=scripts/lib/config-path.sh
source "$SCRIPT_DIR/lib/config-path.sh"

CONFIG_FILE="$(inir_config_file)"

if [[ -f "$CONFIG_FILE" ]]; then
    TERMINAL=$(grep -o '"terminal"[[:space:]]*:[[:space:]]*"[^"]*"' "$CONFIG_FILE" \
        | head -1 \
        | sed 's/.*"terminal"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/')
fi

TERMINAL="${TERMINAL:-kitty}"

# Prefer Fish shell in iNiR session if available and no command args are specified
EXTRA_ARGS=()
if [[ $# -eq 0 ]] && command -v fish &>/dev/null; then
    case "$TERMINAL" in
        kitty) EXTRA_ARGS=(-o "shell=fish") ;;
        ghostty) EXTRA_ARGS=(--command=fish) ;;
        foot) EXTRA_ARGS=(fish) ;;
        alacritty) EXTRA_ARGS=(-e fish) ;;
    esac
fi

if [[ -x "/usr/bin/$TERMINAL" ]]; then
    exec "/usr/bin/$TERMINAL" "${EXTRA_ARGS[@]}" "$@"
elif command -v "$TERMINAL" &>/dev/null; then
    exec "$TERMINAL" "${EXTRA_ARGS[@]}" "$@"
fi

# Fallback chain: project default first, then popular alternatives
for fallback in kitty foot ghostty alacritty wezterm konsole xterm; do
    FALLBACK_ARGS=()
    if [[ $# -eq 0 ]] && command -v fish &>/dev/null; then
        case "$fallback" in
            kitty) FALLBACK_ARGS=(-o "shell=fish") ;;
            ghostty) FALLBACK_ARGS=(--command=fish) ;;
            foot) FALLBACK_ARGS=(fish) ;;
            alacritty) FALLBACK_ARGS=(-e fish) ;;
        esac
    fi
    if [[ -x "/usr/bin/$fallback" ]]; then
        exec "/usr/bin/$fallback" "${FALLBACK_ARGS[@]}" "$@"
    elif command -v "$fallback" &>/dev/null; then
        exec "$fallback" "${FALLBACK_ARGS[@]}" "$@"
    fi
done

echo "No terminal emulator found" >&2
exit 1
