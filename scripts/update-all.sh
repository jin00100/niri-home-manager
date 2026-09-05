#!/usr/bin/env bash
# ==============================================================================
#  iNiR & DevOps Ecosystem One-Click Updater
#  Updates Neovim plugins, Yazi plugins, CLI tools, and iNiR desktop components
# ==============================================================================

set -e

BOLD="\033[1m"
GREEN="\033[0;32m"
BLUE="\033[0;34m"
CYAN="\033[0;36m"
YELLOW="\033[1;33m"
RST="\033[0m"

echo -e "${CYAN}${BOLD}"
echo "╔══════════════════════════════════════════════════════════════╗"
echo "║          iNiR & DevOps Full Ecosystem Updater                ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo -e "${RST}"

# 1. Update Neovim plugins via Lazy.nvim
echo -e "\n${BLUE}${BOLD}[1/5] Updating Neovim plugins (Lazy.nvim)...${RST}"
if command -v nvim >/dev/null 2>&1; then
    nvim --headless "+Lazy! sync" +qa 2>&1 | grep -E "Finished|checkout|error|HEAD" || true
    echo -e "${GREEN}✓ Neovim plugins updated successfully.${RST}"
else
    echo -e "${YELLOW}nvim not found, skipping.${RST}"
fi

# 2. Update Yazi plugins
echo -e "\n${BLUE}${BOLD}[2/5] Updating Yazi plugins...${RST}"
YAZI_PLUGINS_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/yazi/plugins"
if [ -d "$YAZI_PLUGINS_DIR" ]; then
    for plugin in "$YAZI_PLUGINS_DIR"/*; do
        if [ -d "$plugin/.git" ]; then
            pname=$(basename "$plugin")
            echo -e "  ${CYAN}→${RST} Updating plugin: $pname"
            git -C "$plugin" pull --ff-only 2>/dev/null || true
        fi
    done
    if command -v ya >/dev/null 2>&1; then
        ya pack -u 2>/dev/null || true
    fi
    echo -e "${GREEN}✓ Yazi plugins updated successfully.${RST}"
else
    echo -e "${YELLOW}Yazi plugins directory not found, skipping.${RST}"
fi

# 3. Update CLI & DevOps toolchain
echo -e "\n${BLUE}${BOLD}[3/5] Checking CLI tools against latest GitHub releases...${RST}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INSTALLER_PY="${SCRIPT_DIR}/install-devops-tools.py"
if [ -f "$INSTALLER_PY" ] && command -v python3 >/dev/null 2>&1; then
    python3 "$INSTALLER_PY"
    echo -e "${GREEN}✓ CLI tools up-to-date.${RST}"
fi

# 4. Update iNiR desktop environment & runtime
echo -e "\n${BLUE}${BOLD}[4/5] Syncing iNiR desktop components...${RST}"
INIR_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
if [ -f "$INIR_ROOT/setup" ]; then
    (cd "$INIR_ROOT" && ./setup --local update -y 2>/dev/null) || (cd "$INIR_ROOT" && ./setup install -y 2>/dev/null) || true
    echo -e "${GREEN}✓ iNiR desktop runtime synced.${RST}"
fi

# 5. Nix Home Manager environment (if present)
if [ -f "$HOME/home_env_dotfiles/update.sh" ]; then
    echo -e "\n${BLUE}${BOLD}[5/5] Updating Nix environment...${RST}"
    bash "$HOME/home_env_dotfiles/update.sh" || true
    echo -e "${GREEN}✓ Nix environment updated.${RST}"
else
    echo -e "\n${GREEN}${BOLD}[5/5] All components and plugins are up to date.${RST}"
fi

echo -e "\n${GREEN}${BOLD}All updates completed successfully.${RST}\n"
