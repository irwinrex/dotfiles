# =========================================================
# Environment
# =========================================================

export K9S_CONFIG_DIR="$HOME/.config/k9s"

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
# Oh My Zsh
# =========================================================

export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME=""

plugins=(
  git
  docker
  kubectl
  terraform
  python
  golang
  history-substring-search
  zsh-autosuggestions
  zsh-vi-mode
  zsh-syntax-highlighting
)

# zsh-vi-mode hooks must be defined before oh-my-zsh.sh loads the plugin
zvm_config() {
  ZVM_INSERT_MODE_CURSOR=$ZVM_CURSOR_BEAM
  ZVM_NORMAL_MODE_CURSOR=$ZVM_CURSOR_BLOCK
  ZVM_VISUAL_MODE_CURSOR=$ZVM_CURSOR_BLOCK

  ZVM_VI_HIGHLIGHT_BACKGROUND=none
  ZVM_VI_HIGHLIGHT_FOREGROUND=none
  ZVM_VI_HIGHLIGHT_EXTRASTYLE=none
}

zvm_after_init() {
  bindkey '^[[1;5C' forward-word
  bindkey '^[[1;5D' backward-word
  bindkey '^F' _fzf_file_no_hidden
  bindkey '^\' autosuggest-toggle
  bindkey '^[[A' history-substring-search-up
  bindkey '^[[B' history-substring-search-down
  bindkey '^ ' autosuggest-accept

  # Ctrl+N down, Ctrl+P up, Ctrl+Y select
  bindkey '^N' down-line-or-history
  bindkey '^P' up-line-or-history
  bindkey '^Y' accept-line
  bindkey -M vicmd '^N' down-line-or-history
  bindkey -M vicmd '^P' up-line-or-history

  # Completion menu navigation
  bindkey -M menuselect '^N' menu-complete
  bindkey -M menuselect '^P' reverse-menu-complete
  bindkey -M menuselect '^Y' accept-line

  # FZF history search in both insert and normal modes
  bindkey '^R' fzf-history-widget
  bindkey -M vicmd '^R' fzf-history-widget
}

source "$ZSH/oh-my-zsh.sh"

zmodload -i zsh/complist
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

source "$ZSH_CONFIG_DIR/aliases.zsh"
source "$ZSH_CONFIG_DIR/bindings.zsh"
source "$ZSH_CONFIG_DIR/fzf.zsh"
source "$ZSH_CONFIG_DIR/prompt.zsh"

[[ -f "$ZSH_CONFIG_DIR/local.zsh" ]] && source "$ZSH_CONFIG_DIR/local.zsh"

# =========================================================
# Path
# =========================================================

export PATH="$HOME/.local/bin:$HOME/go/bin:$PATH"
