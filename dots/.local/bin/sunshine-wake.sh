#!/usr/bin/env bash
# /dots/.local/bin/sunshine-wake.sh
# Wake / trigger screen damage for Niri Wayland compositor on Moonlight connect
export WAYLAND_DISPLAY="${WAYLAND_DISPLAY:-wayland-1}"
export XDG_RUNTIME_DIR="${XDG_RUNTIME_DIR:-/run/user/$(id -u)}"

setsid -f bash -c '
  for i in {1..6}; do
    ydotool mousemove -x 1 -y 1 2>/dev/null || true
    ydotool mousemove -x -1 -y -1 2>/dev/null || true
    /usr/bin/qs -p "${XDG_CONFIG_HOME:-$HOME/.config}/quickshell/inir" ipc call lock focus 2>/dev/null || true
    sleep 0.4
  done
' </dev/null >/dev/null 2>&1

exit 0
