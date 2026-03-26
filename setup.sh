#!/bin/bash
# Symlink dotfiles to home directory

DOTFILES_DIR="${DOTFILES_DIR:-$(cd "$(dirname "$0")" && pwd)}"

# -- OS detection --
case "$(uname -s)" in
  Darwin) _OS=mac ;;
  Linux)  _OS=linux ;;
esac

# -- Helper: create symlink with backup --
link_file() {
  local src="$1" target="$2"
  mkdir -p "$(dirname "$target")"
  if [ -e "$target" ] && [ ! -L "$target" ]; then
    echo "Backing up existing $(basename "$target") -> $(basename "$target").bak"
    mv "$target" "$target.bak"
  fi
  ln -sf "$src" "$target"
  echo "Linked $(basename "$target")"
}

# -- Dotfiles --
files=(.bash_profile .bashrc .gitconfig .gitignore_global)

for file in "${files[@]}"; do
  link_file "$DOTFILES_DIR/$file" "$HOME/$file"
done

# -- Ghostty config (macOS only) --
if [[ "$_OS" == "mac" ]]; then
  link_file "$DOTFILES_DIR/ghostty/config" "$HOME/.config/ghostty/config"
fi

# -- Starship config --
link_file "$DOTFILES_DIR/starship.toml" "$HOME/.config/starship.toml"

# -- Windows Terminal config (WSL2 only) --
if [[ "$_OS" == "linux" ]]; then
  wt_base="/mnt/c/Users"
  wt_package="Microsoft.WindowsTerminal_8wekyb3d8bbwe"
  wt_target=""
  if [ -d "$wt_base" ]; then
    for user_dir in "$wt_base"/*/; do
      candidate="${user_dir}AppData/Local/Packages/${wt_package}/LocalState/settings.json"
      if [ -d "$(dirname "$candidate")" ]; then
        wt_target="$candidate"
        break
      fi
    done
  fi
  if [ -n "$wt_target" ]; then
    link_file "$DOTFILES_DIR/windows-terminal/settings.json" "$wt_target"
  else
    echo "Skipped Windows Terminal: settings directory not found"
  fi
fi

# -- Shell completions --
if command -v brew &>/dev/null; then
  completion_dir="$(brew --prefix)/etc/bash_completion.d"
  command -v npm  &>/dev/null && npm completion      > "$completion_dir/npm"
  command -v pnpm &>/dev/null && pnpm completion bash > "$completion_dir/pnpm"
  echo "Generated shell completions"
fi

# Remove obsolete .profile if it exists and is not a symlink
if [ -f "$HOME/.profile" ] && [ ! -L "$HOME/.profile" ]; then
  mv "$HOME/.profile" "$HOME/.profile.bak"
  echo "Backed up and removed obsolete .profile -> .profile.bak"
fi

# -- Package installation hint (Linux) --
if [[ "$_OS" == "linux" ]]; then
  echo ""
  echo "Run ./install-packages-linux.sh to install CLI tools (apt + installers)"
fi

echo "Done!"
