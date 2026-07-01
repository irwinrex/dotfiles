# =========================================================
# History
# =========================================================

HISTFILE="$HOME/.local/state/zsh/history"
HISTSIZE=100000
SAVEHIST=100000

setopt EXTENDED_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_VERIFY
setopt SHARE_HISTORY
setopt INC_APPEND_HISTORY_TIME

# =========================================================
# Options
# =========================================================

setopt AUTO_CD
setopt NO_BEEP
setopt GLOBDOTS
setopt INTERACTIVE_COMMENTS
setopt NUMERIC_GLOB_SORT

# =========================================================
# Completion
# =========================================================

autoload -Uz compinit
if [[ -f "$HOME/.cache/zsh/zcompdump" ]]; then
  compinit -C -d "$HOME/.cache/zsh/zcompdump"
else
  mkdir -p "$HOME/.cache/zsh"
  compinit -d "$HOME/.cache/zsh/zcompdump"
fi

zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# =========================================================
# zoxide
# =========================================================

eval "$(zoxide init zsh)"

# =========================================================
# fzf
# =========================================================

if [[ -f /opt/homebrew/opt/fzf/shell/key-bindings.zsh ]]; then
  source /opt/homebrew/opt/fzf/shell/key-bindings.zsh
  source /opt/homebrew/opt/fzf/shell/completion.zsh
elif [[ -f /usr/local/opt/fzf/shell/key-bindings.zsh ]]; then
  source /usr/local/opt/fzf/shell/key-bindings.zsh
  source /usr/local/opt/fzf/shell/completion.zsh
elif [[ -f /usr/share/fzf/key-bindings.zsh ]]; then
  source /usr/share/fzf/key-bindings.zsh
  source /usr/share/fzf/completion.zsh
elif [[ -f /usr/share/doc/fzf/examples/key-bindings.zsh ]]; then
  source /usr/share/doc/fzf/examples/key-bindings.zsh
  source /usr/share/doc/fzf/examples/completion.zsh
fi

# =========================================================
# Modular config
# =========================================================

ZSH_CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/zsh"

source "$ZSH_CONFIG_DIR/plugins.zsh"
source "$ZSH_CONFIG_DIR/aliases.zsh"
source "$ZSH_CONFIG_DIR/bindings.zsh"
source "$ZSH_CONFIG_DIR/fzf.zsh"
source "$ZSH_CONFIG_DIR/prompt.zsh"

[[ -f "$ZSH_CONFIG_DIR/local.zsh" ]] && source "$ZSH_CONFIG_DIR/local.zsh"

# =========================================================
# Path
# =========================================================

export PATH="$HOME/.local/bin:$HOME/go/bin:$PATH"
