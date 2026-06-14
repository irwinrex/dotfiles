export VIRTUAL_ENV_DISABLE_PROMPT=1
export STARSHIP_CONFIG="${XDG_CONFIG_HOME:-$HOME/.config}/zsh/starship.toml"
eval "$(starship init zsh)"
