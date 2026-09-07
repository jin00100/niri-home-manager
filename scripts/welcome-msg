#!/usr/bin/env bash
# Disable line wrapping
printf "\e[?7l"

os_name="Linux"
if [[ -f /etc/os-release ]]; then
  os_name=$(grep PRETTY_NAME /etc/os-release | cut -d '"' -f2)
fi

echo ""
echo -e "\x1b[38;2;66;133;244m███████████████████╗   ██████████╗  ██╗   \x1b[0m"
echo -e "\x1b[38;2;90;117;240m╚══██╔══██╔═════████╗  ██╚════███║  ██║   \x1b[0m"
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

# Re-enable line wrapping
printf "\e[?7h"
