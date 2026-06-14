# =========================================================
# Built-in plugin manager
# =========================================================

ZPLUGINDIR="${ZDOTDIR:-$HOME/.config/zsh}/plugins"

_zplugin_load() {
  local plugin_path="${ZPLUGINDIR}/${2}"
  if [[ ! -d "$plugin_path" ]]; then
    mkdir -p "$ZPLUGINDIR"
    echo "Installing ${2}..."
    if ! git clone --depth=1 "https://github.com/${1}/${2}" "$plugin_path" 2>/dev/null; then
      echo "WARNING: failed to install ${2}" >&2
      return 1
    fi
  fi
  if [[ -f "${plugin_path}/${2}.plugin.zsh" ]]; then
    source "${plugin_path}/${2}.plugin.zsh"
  elif [[ -f "${plugin_path}/${2}.zsh" ]]; then
    source "${plugin_path}/${2}.zsh"
  fi
}

zplugin-update() {
  local dir
  for dir in "$ZPLUGINDIR"/*/; do
    echo "Updating ${dir:t}..."
    git -C "$dir" pull --ff-only 2>/dev/null || echo "  WARNING: failed to update ${dir:t}"
  done
}

_zplugin_load zsh-users zsh-autosuggestions
_zplugin_load zsh-users zsh-history-substring-search
_zplugin_load jeffreytse zsh-vi-mode
_zplugin_load zdharma-continuum fast-syntax-highlighting
