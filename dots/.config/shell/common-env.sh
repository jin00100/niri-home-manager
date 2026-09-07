# [Environment Detection]
export PATH="$HOME/.local/bin:$PATH"

function is_ssh() { 
  [[ -n "$SSH_CLIENT" || -n "$SSH_TTY" || -n "$SSH_CONNECTION" ]] && return 0
  [[ "$(ps -o comm= -p $PPID 2>/dev/null)" == "sshd" ]]
}
function is_container() {
  [[ -n "$DISTROBOX_ENTER_PATH" ]] || [[ -e /run/.containerenv ]] || [[ -e /.dockerenv ]] || grep -qE "docker|podman|containerd" /proc/1/cgroup 2>/dev/null
}
function is_vscode() { [[ "$TERM_PROGRAM" == "vscode" || -n "$VSCODE_IPC_HOOK_CLI" || -n "$VSCODE_PID" ]]; }

# [Container Error Shield]
if is_container; then
  function alias() {
    case "$1" in
      ls=*eza*) builtin alias ls='ls --color=auto' ;;
      ll=*eza*) builtin alias ll='ls -al --color=auto' ;;
      lt=*eza*) builtin alias lt='ls -R --color=auto' ;;
      cat=*bat*) builtin alias cat='cat' ;;
      v=*nvim*) builtin alias v='vi' ;;
      *) builtin alias "$@" ;;
    esac
  }
  builtin alias ls='ls --color=auto'
  builtin alias ll='ls -al --color=auto'
  builtin alias lt='ls -R --color=auto'
  for cmd in atuin starship welcome-msg eza bat zoxide nvim; do
    if ! command -v "$cmd" &>/dev/null; then eval "$cmd() { :; }"; fi
  done
fi

# [SSH Terminfo & IP Detection & Starship Prompt]
if is_ssh; then
  export TERMINFO_DIRS="$HOME/.terminfo:/usr/share/terminfo"
  if [[ "$TERM" == "xterm-ghostty" ]]; then
    if ! infocmp xterm-ghostty >/dev/null 2>&1; then
      export TERM=xterm-256color
    fi
    export COLORTERM=truecolor
  fi
  # Extract IP for the Starship prompt IP pill
  if [[ -n "$SSH_CONNECTION" ]]; then
    export SSH_LOCAL_IP=$(echo "$SSH_CONNECTION" | awk '{print $3}')
  elif [[ -n "$SSH_CLIENT" ]]; then
    export SSH_LOCAL_IP=$(echo "$SSH_CLIENT" | awk '{print $1}')
  else
    export SSH_LOCAL_IP="Remote"
  fi
  if [[ -f "$HOME/.config/starship-ssh.toml" ]]; then
    export STARSHIP_CONFIG="$HOME/.config/starship-ssh.toml"
  fi
elif is_container; then
  if [[ -f "$HOME/.config/starship-docker.toml" ]]; then
    export STARSHIP_CONFIG="$HOME/.config/starship-docker.toml"
  fi
fi

# [Quick Aliases]
alias cl="clear"
alias g="git"
alias v="nvim"
alias vi="nvim"
alias vim="nvim"
alias k="kubectl"
alias h="helm"
alias la="ls -a"
alias zj="zellij"
alias tocb="wl-copy"
alias keymap="bat ~/nixos-home-manager/docs/keyboard-layout.md 2>/dev/null || echo 'Keymap file not found'"

# WireGuard Aliases
alias vpn-on="sudo systemctl start wg-quick-wg0"
alias vpn-off="sudo systemctl stop wg-quick-wg0"
alias vpn-stat="sudo wg"

# Dynamic Aliases (Host)
if ! is_container; then
  if command -v eza &>/dev/null; then
    alias ls="eza"
    alias ll="eza -l --icons --git -a"
    alias lt="eza --tree --level=2 --icons --git"
  fi
  if command -v bat &>/dev/null; then
    alias cat="bat --style=plain"
  fi
fi

# [SSH Wrapper]
function ssh() {
  if ! is_ssh && [[ "$TERM" == "xterm-ghostty" || "$TERM_PROGRAM" == "Ghostty" ]]; then
    ghostty +ssh "$@"
  else
    TERM=xterm-256color COLORTERM=truecolor command ssh "$@"
  fi
}

# [Zellij Wrapper]
function zellij() {
  if is_ssh || is_container; then
    if [[ -f "$HOME/.config/zellij/remote.kdl" ]]; then
      command zellij --config "$HOME/.config/zellij/remote.kdl" "$@"
    else
      command zellij "$@"
    fi
  else
    command zellij "$@"
  fi
}

# [Yazi Wrapper]
function y() {
  local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
  command yazi "$@" --cwd-file="$tmp"
  if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
    builtin cd -- "$cwd"
  fi
  rm -f -- "$tmp"
}

# [Zoxide & FZF Integration]
if [[ -n "$ZSH_VERSION" ]]; then
  if command -v zoxide &>/dev/null; then
    eval "$(zoxide init zsh --cmd cd)"
  fi
  if command -v fzf &>/dev/null; then
    eval "$(fzf --zsh 2>/dev/null || true)"
  fi
elif [[ -n "$BASH_VERSION" ]]; then
  if command -v zoxide &>/dev/null; then
    eval "$(zoxide init bash --cmd cd)"
  fi
  if command -v fzf &>/dev/null; then
    eval "$(fzf --bash 2>/dev/null || true)"
  fi
fi

# [Kubernetes & Helm Autocompletion Cached]
mkdir -p "$HOME/.cache/shell_completion"
_sh_type="bash"
[[ -n "$ZSH_VERSION" ]] && _sh_type="zsh"

if command -v kubectl &>/dev/null; then
  if [[ ! -f "$HOME/.cache/shell_completion/kubectl_completion.${_sh_type}" ]]; then
    kubectl completion "${_sh_type}" > "$HOME/.cache/shell_completion/kubectl_completion.${_sh_type}" 2>/dev/null
  fi
  [[ -f "$HOME/.cache/shell_completion/kubectl_completion.${_sh_type}" ]] && source "$HOME/.cache/shell_completion/kubectl_completion.${_sh_type}"
fi
if command -v helm &>/dev/null; then
  if [[ ! -f "$HOME/.cache/shell_completion/helm_completion.${_sh_type}" ]]; then
    helm completion "${_sh_type}" > "$HOME/.cache/shell_completion/helm_completion.${_sh_type}" 2>/dev/null
  fi
  [[ -f "$HOME/.cache/shell_completion/helm_completion.${_sh_type}" ]] && source "$HOME/.cache/shell_completion/helm_completion.${_sh_type}"
fi
unset _sh_type

# [GitLab CLI Configuration]
if [[ -f /run/secrets/gitlab_token ]] && ! is_container; then
  export GITLAB_TOKEN=$(cat /run/secrets/gitlab_token)
  export GITLAB_HOST="192.168.0.230"
fi
