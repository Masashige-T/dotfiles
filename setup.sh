#!/bin/bash
# Symlink dotfiles to home directory

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

files=(.bash_profile .bashrc .gitconfig .gitignore_global)

for file in "${files[@]}"; do
  target="$HOME/$file"
  if [ -e "$target" ] && [ ! -L "$target" ]; then
    echo "Backing up existing $file -> $file.bak"
    mv "$target" "$target.bak"
  fi
  ln -sf "$DOTFILES_DIR/$file" "$target"
  echo "Linked $file"
done

# -- Ghostty config --
ghostty_dir="$HOME/.config/ghostty"
ghostty_target="$ghostty_dir/config"
mkdir -p "$ghostty_dir"
if [ -e "$ghostty_target" ] && [ ! -L "$ghostty_target" ]; then
  echo "Backing up existing ghostty/config -> config.bak"
  mv "$ghostty_target" "$ghostty_target.bak"
fi
ln -sf "$DOTFILES_DIR/ghostty/config" "$ghostty_target"
echo "Linked ghostty/config"

# -- Starship config --
starship_dir="$HOME/.config"
starship_target="$starship_dir/starship.toml"
mkdir -p "$starship_dir"
if [ -e "$starship_target" ] && [ ! -L "$starship_target" ]; then
  echo "Backing up existing starship.toml -> starship.toml.bak"
  mv "$starship_target" "$starship_target.bak"
fi
ln -sf "$DOTFILES_DIR/starship.toml" "$starship_target"
echo "Linked starship.toml"

# -- Shell completions --
completion_dir="$(brew --prefix)/etc/bash_completion.d"
command -v npm  &>/dev/null && npm completion      > "$completion_dir/npm"
command -v pnpm &>/dev/null && pnpm completion bash > "$completion_dir/pnpm"
echo "Generated shell completions"

# Remove obsolete .profile if it exists and is not a symlink
if [ -f "$HOME/.profile" ] && [ ! -L "$HOME/.profile" ]; then
  mv "$HOME/.profile" "$HOME/.profile.bak"
  echo "Backed up and removed obsolete .profile -> .profile.bak"
fi

echo "Done!"
