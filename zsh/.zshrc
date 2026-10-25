source "${XDG_CONFIG_HOME:-$HOME/.config}/zsh/.zshrc"
export PATH="$HOME/.local/bin:$PATH"

# bun completions
[ -s "/Users/irwinrex-equipo/.bun/_bun" ] && source "/Users/irwinrex-equipo/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
