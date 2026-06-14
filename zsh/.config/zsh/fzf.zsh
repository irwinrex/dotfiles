# =========================================================
# fzf
# =========================================================

export FZF_DEFAULT_COMMAND='fd --type f --hidden --strip-cwd-prefix'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

export FZF_DEFAULT_OPTS='
  --height=60%
  --layout=reverse
  --border=rounded
  --prompt="  "
  --pointer="  "
  --preview-window=right:65%:wrap:border-left
'

_fzf_preview_cmd() {
  if command -v bat >/dev/null 2>&1; then
    echo 'bat --color=always --style=plain,numbers --line-range=:500 {}'
  else
    echo 'cat -n {}'
  fi
}

export FZF_CTRL_T_OPTS="--preview '$(_fzf_preview_cmd)'"

_fzf_file_no_hidden() {
  local cmd result
  cmd=$(echo "$FZF_DEFAULT_COMMAND" | sed 's/--hidden //')
  result=$(eval "${cmd:-find . -type f}" | fzf --preview "$(_fzf_preview_cmd)") \
    && LBUFFER+="$result"
  zle reset-prompt
}
zle -N _fzf_file_no_hidden
