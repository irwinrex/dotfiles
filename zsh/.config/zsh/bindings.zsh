# =========================================================
# Native Vi Mode
# =========================================================

bindkey -v

# =========================================================
# zsh-vi-mode cursors
# =========================================================

ZVM_INSERT_MODE_CURSOR=$ZVM_CURSOR_BEAM
ZVM_NORMAL_MODE_CURSOR=$ZVM_CURSOR_BLOCK
ZVM_VISUAL_MODE_CURSOR=$ZVM_CURSOR_BLOCK

ZVM_VI_HIGHLIGHT_BACKGROUND=none
ZVM_VI_HIGHLIGHT_FOREGROUND=none
ZVM_VI_HIGHLIGHT_EXTRASTYLE=none

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
