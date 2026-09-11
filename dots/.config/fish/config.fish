if status is-interactive
    # Ensure local bin is in PATH
    fish_add_path ~/.local/bin

    # No greeting
    set fish_greeting

    # Use starship prompt
    if command -v starship &>/dev/null
        starship init fish | source
    end

    # Apply terminal color sequences (Material You from wallpaper) - skip in SSH sessions
    if not set -q SSH_CLIENT; and not set -q SSH_TTY
        if test -f ~/.local/state/quickshell/user/generated/terminal/sequences.txt
            if test -x /bin/cat
                /bin/cat ~/.local/state/quickshell/user/generated/terminal/sequences.txt 2>/dev/null
            else
                command cat ~/.local/state/quickshell/user/generated/terminal/sequences.txt 2>/dev/null
            end
        end
    end

    # Aliases
    alias clear "printf '\033[2J\033[3J\033[1;1H'" # fix: kitty doesn't clear scrollback properly
    alias celar "printf '\033[2J\033[3J\033[1;1H'"
    alias claer "printf '\033[2J\033[3J\033[1;1H'"
    if command -v eza &>/dev/null
        alias ls 'eza --icons=auto'
    end
    alias q 'inir run'
    if test -x /usr/bin/fastfetch
        alias fastfetch /usr/bin/fastfetch
    end

    # Desktop Session & OS Switchers
    alias use-mac "command -v asahi-bless >/dev/null; and sudo asahi-bless; and sudo reboot; or echo 'asahi-bless not found (not on Apple Silicon)'"
    alias reboot-macos "use-mac"
    alias use-niri "printf '[Autologin]\nUser=%s\nSession=niri\n' \$USER | sudo tee /etc/sddm.conf.d/autologin.conf >/dev/null; and echo 'Switched to Niri session. Run sudo reboot to apply.'"
    alias use-hyprland "printf '[Autologin]\nUser=%s\nSession=hyprland\n' \$USER | sudo tee /etc/sddm.conf.d/autologin.conf >/dev/null; and echo 'Switched to Hyprland session. Run sudo reboot to apply.'"

    # Welcome banner on interactive startup
    if command -v welcome-msg &>/dev/null && not set -q _INIR_WELCOME_SHOWN
        set -g _INIR_WELCOME_SHOWN 1
        welcome-msg
    end
end
