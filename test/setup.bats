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

@test "WSL2 で Windows Terminal settings.json がコピーされること" {
  # uname スタブで Linux を偽装
  STUB_DIR="$(mktemp -d)"
  cp "$DOTFILES_DIR/test/stubs/uname-linux" "$STUB_DIR/uname"

  # 偽の Windows Terminal ディレクトリを /mnt/c/Users 相当に作成
  fake_wt_dir="$TEST_HOME/mnt_c/Users/testuser/AppData/Local/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState"
  mkdir -p "$fake_wt_dir"
  echo '{"existing": true}' > "$fake_wt_dir/settings.json"

  # setup.sh 内の /mnt/c/Users を偽パスに差し替えて実行
  sed "s|/mnt/c/Users|$TEST_HOME/mnt_c/Users|" "$DOTFILES_DIR/setup.sh" > "$STUB_DIR/setup.sh"

  run env DOTFILES_DIR="$DOTFILES_DIR" PATH="$STUB_DIR:$PATH" bash "$STUB_DIR/setup.sh"
  assert_success

  # シンボリックリンクではなくコピーであること
  [ -f "$fake_wt_dir/settings.json" ]
  [ ! -L "$fake_wt_dir/settings.json" ]
  diff -q "$DOTFILES_DIR/windows-terminal/settings.json" "$fake_wt_dir/settings.json"
  # 元ファイルがバックアップされていること
  [ -f "$fake_wt_dir/settings.json.bak" ]
}

@test "WSL2 で Windows Terminal ディレクトリが存在しない場合スキップされること" {
  STUB_DIR="$(mktemp -d)"
  cp "$DOTFILES_DIR/test/stubs/uname-linux" "$STUB_DIR/uname"

  # /mnt/c/Users が存在しない状態で実行
  sed "s|/mnt/c/Users|$TEST_HOME/nonexistent|" "$DOTFILES_DIR/setup.sh" > "$STUB_DIR/setup.sh"

  run env DOTFILES_DIR="$DOTFILES_DIR" PATH="$STUB_DIR:$PATH" bash "$STUB_DIR/setup.sh"
  assert_success

  [[ "$output" == *"Skipped Windows Terminal"* ]]
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
