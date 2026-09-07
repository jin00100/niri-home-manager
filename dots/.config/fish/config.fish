if status is-interactive
    # No greeting
    set fish_greeting

    # Use starship prompt
    if command -v starship &>/dev/null
        starship init fish | source
    end

    # Apply terminal color sequences (Material You from wallpaper)
    if test -f ~/.local/state/quickshell/user/generated/terminal/sequences.txt
        if test -x /bin/cat
            /bin/cat ~/.local/state/quickshell/user/generated/terminal/sequences.txt 2>/dev/null
        else
            command cat ~/.local/state/quickshell/user/generated/terminal/sequences.txt 2>/dev/null
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

    # Welcome banner on interactive startup
    if command -v welcome-msg &>/dev/null && not set -q _INIR_WELCOME_SHOWN
        set -g _INIR_WELCOME_SHOWN 1
        welcome-msg
    end
end
