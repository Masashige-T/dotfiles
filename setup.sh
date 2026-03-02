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

# -- Ghostty (cmux) config --
ghostty_dir="$HOME/.config/ghostty"
ghostty_target="$ghostty_dir/config"
mkdir -p "$ghostty_dir"
if [ -e "$ghostty_target" ] && [ ! -L "$ghostty_target" ]; then
  echo "Backing up existing ghostty/config -> config.bak"
  mv "$ghostty_target" "$ghostty_target.bak"
fi
ln -sf "$DOTFILES_DIR/ghostty/config" "$ghostty_target"
echo "Linked ghostty/config"

# Remove obsolete .profile if it exists and is not a symlink
if [ -f "$HOME/.profile" ] && [ ! -L "$HOME/.profile" ]; then
  mv "$HOME/.profile" "$HOME/.profile.bak"
  echo "Backed up and removed obsolete .profile -> .profile.bak"
fi

echo "Done!"
