# Suppress macOS "default interactive shell is now zsh" warning
export BASH_SILENCE_DEPRECATION_WARNING=1

# ── Homebrew ──
eval "$(/opt/homebrew/bin/brew shellenv)"

# ── PATH ──
export PATH="$HOME/.local/bin:$PATH"

# ── Ruby (rbenv) ──
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"

# ── Node (Volta) ──
export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"

# ── Rust (Cargo) ──
. "$HOME/.cargo/env"

# ── Bun ──
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# ── OrbStack ──
source ~/.orbstack/shell/init.bash 2>/dev/null || :

# ── Interactive shell settings ──
if [ -f ~/.bashrc ]; then
  source ~/.bashrc
fi
