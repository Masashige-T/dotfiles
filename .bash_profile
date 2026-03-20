# shellcheck shell=bash

# -- OS detection --
case "$(uname -s)" in
  Darwin) _OS=mac ;;
  Linux)  _OS=linux ;;
esac

# -- macOS only --
if [[ "$_OS" == "mac" ]]; then
  # Suppress "default interactive shell is now zsh" warning
  export BASH_SILENCE_DEPRECATION_WARNING=1
fi

# -- Homebrew --
if [[ "$_OS" == "mac" ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x /home/linuxbrew/.linuxbrew/bin/brew ]]; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

# -- PATH --
export PATH="$HOME/.local/bin:$PATH"

# -- Ruby (rbenv) --
if [[ -d "$HOME/.rbenv" ]]; then
  export PATH="$HOME/.rbenv/bin:$PATH"
  eval "$(rbenv init -)"
fi

# -- Node (Volta) --
export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"

# -- Rust (Cargo) --
if [[ -f "$HOME/.cargo/env" ]]; then
  # shellcheck source=/dev/null
  . "$HOME/.cargo/env"
fi

# -- Bun --
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# -- OrbStack (macOS only) --
if [[ "$_OS" == "mac" ]]; then
  # shellcheck source=/dev/null
  source ~/.orbstack/shell/init.bash 2>/dev/null || :
fi

# -- Bash Completion --
if command -v brew &>/dev/null; then
  # shellcheck source=/dev/null
  [[ -r "$(brew --prefix)/etc/profile.d/bash_completion.sh" ]] && . "$(brew --prefix)/etc/profile.d/bash_completion.sh"
elif [[ -f /usr/share/bash-completion/bash_completion ]]; then
  # shellcheck source=/dev/null
  . /usr/share/bash-completion/bash_completion
fi

# -- Interactive shell settings --
if [ -f ~/.bashrc ]; then
  # shellcheck source=/dev/null
  source ~/.bashrc
fi
