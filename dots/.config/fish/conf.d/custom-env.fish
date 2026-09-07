# Fish shell environment & aliases ported from dotfiles
if status is-interactive
    # Fast path for ~/.local/bin
    if not contains $HOME/.local/bin $PATH
        set -gx PATH $HOME/.local/bin $PATH
    end

    # SSH IP & prompt detection
    if test -n "$SSH_CLIENT"; or test -n "$SSH_TTY"; or test -n "$SSH_CONNECTION"
        if test -n "$SSH_CONNECTION"
            set -gx SSH_LOCAL_IP (echo $SSH_CONNECTION | awk '{print $3}')
        else if test -n "$SSH_CLIENT"
            set -gx SSH_LOCAL_IP (echo $SSH_CLIENT | awk '{print $1}')
        else
            set -gx SSH_LOCAL_IP "Remote"
        end
        if test -f "$HOME/.config/starship-ssh.toml"
            set -gx STARSHIP_CONFIG "$HOME/.config/starship-ssh.toml"
        end
    end

    # Aliases
    alias cl "clear"
    alias g "git"
    alias v "nvim"
    alias vi "nvim"
    alias vim "nvim"
    alias k "kubectl"
    alias h "helm"
    alias la "ls -a"
    alias zj "zellij"
    alias tocb "wl-copy"
    alias keymap "bat ~/nixos-home-manager/docs/keyboard-layout.md 2>/dev/null; or echo 'Keymap file not found'"

    alias vpn-on "sudo systemctl start wg-quick-wg0"
    alias vpn-off "sudo systemctl stop wg-quick-wg0"
    alias vpn-stat "sudo wg"

    if command -v eza &>/dev/null
        alias ls "eza --icons=auto"
        alias ll "eza -l --icons --git -a"
        alias lt "eza --tree --level=2 --icons --git"
    end

    if command -v bat &>/dev/null
        alias cat "bat --style=plain"
    end

    # Yazi wrapper
    function y
        set tmp (mktemp -t "yazi-cwd.XXXXXX")
        yazi $argv --cwd-file="$tmp"
        if set cwd (command cat -- "$tmp"); and test -n "$cwd"; and test "$cwd" != "$PWD"
            builtin cd -- "$cwd"
        end
        rm -f -- "$tmp"
    end

    # SSH wrapper (Ghostty terminfo fallback)
    function ssh
        if test "$TERM" = "xterm-ghostty"; or test "$TERM_PROGRAM" = "Ghostty"
            if command -v ghostty &>/dev/null
                ghostty +ssh $argv
            else
                TERM=xterm-256color COLORTERM=truecolor command ssh $argv
            end
        else
            TERM=xterm-256color COLORTERM=truecolor command ssh $argv
        end
    end

    # Zellij wrapper
    function zellij
        if test -n "$SSH_CLIENT"; or test -n "$SSH_TTY"; or test -n "$SSH_CONNECTION"
            if test -f "$HOME/.config/zellij/remote.kdl"
                command zellij --config "$HOME/.config/zellij/remote.kdl" $argv
            else
                command zellij $argv
            end
        else
            command zellij $argv
        end
    end

    # Zoxide
    if command -v zoxide &>/dev/null
        zoxide init fish --cmd cd | source
    end

    # FZF integration
    if command -v fzf &>/dev/null
        fzf --fish | source
    end

    # Welcome banner on interactive startup
    if command -v welcome-msg &>/dev/null && not set -q _INIR_WELCOME_SHOWN
        set -g _INIR_WELCOME_SHOWN 1
        welcome-msg
    end
end
