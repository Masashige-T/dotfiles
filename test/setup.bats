#!/usr/bin/env bats

setup() {
  TEST_HOME="$(mktemp -d)"
  export HOME="$TEST_HOME"
  DOTFILES_DIR="$(cd "$BATS_TEST_DIRNAME/.." && pwd)"
  export DOTFILES_DIR

  # Put stub brew on PATH and create fake completion dir
  export PATH="${DOTFILES_DIR}/test/stubs:${PATH}"
  FAKE_HOMEBREW="$(mktemp -d)"
  export FAKE_HOMEBREW
  mkdir -p "$FAKE_HOMEBREW/etc/bash_completion.d"

  # Linux スタブ用（テストごとにリセット）
  STUB_DIR=""
}

teardown() {
  rm -rf "$TEST_HOME"
  rm -rf "$FAKE_HOMEBREW"
  if [ -n "${STUB_DIR:-}" ]; then rm -rf "$STUB_DIR"; fi
}

# ヘルパー: run 失敗時に出力を表示
assert_success() {
  if [ "$status" -ne 0 ]; then
    echo "setup.sh failed with status $status" >&2
    echo "$output" >&2
    return 1
  fi
}

@test "dotfiles がホームディレクトリにリンクされること" {
  run bash "$DOTFILES_DIR/setup.sh"
  assert_success

  [ -L "$HOME/.bash_profile" ]
  [ -L "$HOME/.bashrc" ]
  [ -L "$HOME/.gitconfig" ]
  [ -L "$HOME/.gitignore_global" ]
  [ "$(readlink "$HOME/.bash_profile")" = "$DOTFILES_DIR/.bash_profile" ]
}

@test "macOS で ghostty/config がリンクされること" {
  if [[ "$(/usr/bin/uname -s)" != "Darwin" ]]; then
    skip "macOS only"
  fi

  run bash "$DOTFILES_DIR/setup.sh"
  assert_success

  [ -L "$HOME/.config/ghostty/config" ]
  [ "$(readlink "$HOME/.config/ghostty/config")" = "$DOTFILES_DIR/ghostty/config" ]
}

@test "Linux で ghostty/config がスキップされること" {
  # uname スタブで Linux を偽装（teardown で確実に削除）
  STUB_DIR="$(mktemp -d)"
  cp "$DOTFILES_DIR/test/stubs/uname-linux" "$STUB_DIR/uname"

  run env PATH="$STUB_DIR:$PATH" bash "$DOTFILES_DIR/setup.sh"
  assert_success

  [ ! -e "$HOME/.config/ghostty/config" ]
}

@test "starship.toml がリンクされること" {
  run bash "$DOTFILES_DIR/setup.sh"
  assert_success

  [ -L "$HOME/.config/starship.toml" ]
  [ "$(readlink "$HOME/.config/starship.toml")" = "$DOTFILES_DIR/starship.toml" ]
}

@test "既存ファイルが .bak にバックアップされること" {
  echo "old content" > "$HOME/.bash_profile"

  run bash "$DOTFILES_DIR/setup.sh"
  assert_success

  [ -f "$HOME/.bash_profile.bak" ]
  grep -q "old content" "$HOME/.bash_profile.bak"
  [ -L "$HOME/.bash_profile" ]
}

@test "二重実行しても冪等であること" {
  run bash "$DOTFILES_DIR/setup.sh"
  assert_success

  run bash "$DOTFILES_DIR/setup.sh"
  assert_success

  [ -L "$HOME/.bash_profile" ]
  [ ! -e "$HOME/.bash_profile.bak" ]
}
