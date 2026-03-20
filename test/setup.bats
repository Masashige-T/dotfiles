#!/usr/bin/env bats

setup() {
  TEST_HOME="$(mktemp -d)"
  export HOME="$TEST_HOME"
  DOTFILES_DIR="$(cd "$BATS_TEST_DIRNAME/.." && pwd)"
  export DOTFILES_DIR

  # Put stub brew on PATH and create fake completion dir
  export PATH="${DOTFILES_DIR}/test/stubs:${PATH}"
  mkdir -p /tmp/fake-homebrew/etc/bash_completion.d
}

teardown() {
  rm -rf "$TEST_HOME"
  rm -rf /tmp/fake-homebrew
}

@test "symlinks dotfiles to home directory" {
  run bash "$DOTFILES_DIR/setup.sh"
  [ "$status" -eq 0 ]

  [ -L "$HOME/.bash_profile" ]
  [ -L "$HOME/.bashrc" ]
  [ -L "$HOME/.gitconfig" ]
  [ -L "$HOME/.gitignore_global" ]
  [ "$(readlink "$HOME/.bash_profile")" = "$DOTFILES_DIR/.bash_profile" ]
}

@test "symlinks ghostty config" {
  run bash "$DOTFILES_DIR/setup.sh"
  [ "$status" -eq 0 ]

  [ -L "$HOME/.config/ghostty/config" ]
  [ "$(readlink "$HOME/.config/ghostty/config")" = "$DOTFILES_DIR/ghostty/config" ]
}

@test "symlinks starship.toml" {
  run bash "$DOTFILES_DIR/setup.sh"
  [ "$status" -eq 0 ]

  [ -L "$HOME/.config/starship.toml" ]
  [ "$(readlink "$HOME/.config/starship.toml")" = "$DOTFILES_DIR/starship.toml" ]
}

@test "backs up existing files before linking" {
  echo "old content" > "$HOME/.bash_profile"

  run bash "$DOTFILES_DIR/setup.sh"
  [ "$status" -eq 0 ]

  [ -f "$HOME/.bash_profile.bak" ]
  [ -L "$HOME/.bash_profile" ]
}
