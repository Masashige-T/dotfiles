# shellcheck shell=bash
# Suppress macOS "default interactive shell is now zsh" warning
export BASH_SILENCE_DEPRECATION_WARNING=1

# -- Homebrew --
eval "$(/opt/homebrew/bin/brew shellenv)"

# -- PATH --
export PATH="$HOME/.local/bin:$PATH"

# -- Ruby (rbenv) --
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"

# -- Node (Volta) --
export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"

# -- Rust (Cargo) --
# shellcheck source=/dev/null
. "$HOME/.cargo/env"

# -- Bun --
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# -- OrbStack --
# shellcheck source=/dev/null
source ~/.orbstack/shell/init.bash 2>/dev/null || :

# -- Bash Completion --
# shellcheck source=/dev/null
[[ -r "$(brew --prefix)/etc/profile.d/bash_completion.sh" ]] && . "$(brew --prefix)/etc/profile.d/bash_completion.sh"

# -- Interactive shell settings --
if [ -f ~/.bashrc ]; then
  # shellcheck source=/dev/null
  source ~/.bashrc
fi
