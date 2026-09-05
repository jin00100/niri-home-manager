#!/usr/bin/env bash
# iNiR DevOps & CLI tools installer
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PYTHON_SCRIPT="${SCRIPT_DIR}/install-devops-tools.py"

echo "[iNiR]: Installing CLI & DevOps tools (bat, zoxide, fzf, yazi, zellij, nvim, lazygit)..."

if command -v python3 >/dev/null 2>&1; then
    python3 "${PYTHON_SCRIPT}"
else
    echo "[iNiR]: python3 not found, skipping standalone CLI tools download."
fi
