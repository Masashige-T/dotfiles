#!/bin/bash
# Symlink dotfiles to home directory

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

files=(.bash_profile .bashrc)

for file in "${files[@]}"; do
  target="$HOME/$file"
  if [ -e "$target" ] && [ ! -L "$target" ]; then
    echo "Backing up existing $file -> $file.bak"
    mv "$target" "$target.bak"
  fi
  ln -sf "$DOTFILES_DIR/$file" "$target"
  echo "Linked $file"
done

# Remove obsolete .profile if it exists and is not a symlink
if [ -f "$HOME/.profile" ] && [ ! -L "$HOME/.profile" ]; then
  mv "$HOME/.profile" "$HOME/.profile.bak"
  echo "Backed up and removed obsolete .profile -> .profile.bak"
fi

echo "Done!"
