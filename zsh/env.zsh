# eval "$(starship init zsh)"
eval "$(zoxide init --cmd cd zsh)"
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /opt/homebrew/opt/zsh-fast-syntax-highlighting/share/zsh-fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh
# Set up fzf key bindings and fuzzy completion
source <(fzf --zsh)


export FORTUNE_PATH="$HOME/.local/share/fortune"


export PATH="/opt/homebrew/opt/trash/bin:$PATH"
export PATH="/opt/homebrew/bin:$PATH"
export PATH="/opt/homebrew/sbin:$PATH"
# proxy
export http_proxy=http://127.0.0.1:7897
export https_proxy=http://127.0.0.1:7897

export PATH="$HOME/bin:$PATH"
export PATH="$HOME/dotfiles/scripts:$PATH"
export HOMEBREW_NO_INSTALL_CLEANUP=1
export HOMEBREW_NO_ENV_HINTS=1
