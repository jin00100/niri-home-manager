#!/usr/bin/env bash

# ==============================================================================
# Welcome Banner Router
# - SSH Session: Display compact iNiR gradient banner (Image 2)
# - Local Terminal: Display classic Arch Neofetch layout (Image 1) ONLY if Arch Linux
# - Non-Arch systems: Remain completely silent on local terminals
# ==============================================================================

# 1. SSH Detection
is_ssh() {
  [[ -n "$SSH_CLIENT" || -n "$SSH_TTY" || -n "$SSH_CONNECTION" ]] && return 0
  [[ "$(ps -o comm= -p $PPID 2>/dev/null)" == "sshd" ]]
}

# 2. Arch Linux Detection with First-Time Flag Cache
ARCH_FLAG="${ARCH_FLAG:-$HOME/.config/.is_arch}"
NON_ARCH_FLAG="${NON_ARCH_FLAG:-$HOME/.config/.not_arch}"

is_arch_system() {
  if [[ -f "$ARCH_FLAG" ]]; then
    return 0
  elif [[ -f "$NON_ARCH_FLAG" ]]; then
    return 1
  fi

  if [[ -f /etc/os-release ]] && grep -qiE '^(ID|ID_LIKE)=.*arch' /etc/os-release; then
    touch "$ARCH_FLAG" 2>/dev/null || true
    return 0
  else
    touch "$NON_ARCH_FLAG" 2>/dev/null || true
    return 1
  fi
}

# 3. Execution Logic
if is_ssh; then
  # -------------------------------------------------------------
  # Scenario A: Remote SSH Session -> Compact iNiR gradient banner (Image 2)
  # -------------------------------------------------------------
  printf "\e[?7l"

  os_name="Linux"
  if [[ -f /etc/os-release ]]; then
    os_name=$(grep PRETTY_NAME /etc/os-release | cut -d '"' -f2)
  fi

  echo ""
  echo -e "\x1b[38;2;66;133;244m███████████████████╗   ██████████╗  ██╗   \x1b[0m"
  echo -e "\x1b[38;2;90;117;240m╚══██╔══██╔═════███╗  ██╚════███║  ██║   \x1b[0m"
  echo -e "\x1b[38;2;114;102;235m   ██║  █████╗  ██╔██╗ ██  ██████║  ██║   \x1b[0m"
  echo -e "\x1b[38;2;138;86;231m   ██║  ██╔══╝  ██║╚██╗██  ╚══███║  ██║   \x1b[0m"
  echo -e "\x1b[38;2;161;71;226m   ██║  ██████████║ ╚████████████████████╗\x1b[0m"
  echo -e "\x1b[38;2;185;55;222m   ╚═╝  ╚═══════╚═╝  ╚═══╚═══════╚═══════╝\x1b[0m"
  echo ""

  echo -e "\x1b[1;31m 󰣇 $os_name\x1b[0m"
  echo -e "\x1b[1;33m 󰒋 HOST      : $(uname -n)\x1b[0m"
  echo -e "\x1b[1;32m 󰚌 SESSION   : ${ZELLIJ:+Zellij }${XDG_CURRENT_DESKTOP:-iNiR / Niri}\x1b[0m"
  echo -e "\x1b[1;34m 󰌽 Kernel    : $(uname -r)\x1b[0m"
  echo -e "\x1b[1;35m 󰃰 Date      : $(date +'%Y-%m-%d %H:%M:%S')\x1b[0m"
  echo -e "\x1b[1;36m 󰞷 Shell     : $(ps -p $PPID -o comm= 2>/dev/null || echo "${SHELL##*/}")\x1b[0m"
  echo -e "\x1b[1;37m 󰀉 User      : $(whoami)\x1b[0m"
  echo -e "\nWelcome to your environment, \x1b[1;34m${USER:-$(whoami)}\x1b[0m!\n"

  printf "\e[?7h"

else
  # -------------------------------------------------------------
  # Scenario B: Local Terminal
  # -------------------------------------------------------------
  # If not an Arch Linux system, stay completely silent
  if ! is_arch_system; then
    exit 0
  fi

  # Arch Linux local terminal -> Display classic Arch ASCII + Neofetch layout (Image 1)
  if command -v fastfetch &>/dev/null; then
    echo ""
    fastfetch -c neofetch --color-keys cyan --color-title cyan --logo-color-1 cyan
    echo ""
  elif command -v neofetch &>/dev/null; then
    echo ""
    neofetch
    echo ""
  fi
fi
