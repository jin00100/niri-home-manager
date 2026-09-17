#!/usr/bin/env bash
# Based on https://unix.stackexchange.com/a/602935

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Skip if already unlocked
if "${SCRIPT_DIR}/is_unlocked.sh" 2>/dev/null; then
    exit 0
fi

# Prompt for password if not provided
if [[ -z "${UNLOCK_PASSWORD}" ]]; then
    echo -n 'Login password: ' >&2
    read -s UNLOCK_PASSWORD || return
fi

# Unlock via official daemon interface without killing running services
if [[ -n "${UNLOCK_PASSWORD}" ]]; then
    echo -n "${UNLOCK_PASSWORD}" | gnome-keyring-daemon --unlock 2>/dev/null || true
fi
unset UNLOCK_PASSWORD
exit 0
