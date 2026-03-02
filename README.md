# dotfiles

## Setup

```bash
git clone git@github.com:Masashige-T/dotfiles.git ~/Desktop/dotfiles
cd ~/Desktop/dotfiles
```

### シンボリックリンク

Bash 設定と Git 設定をホームディレクトリにリンクする。既存ファイルは `.bak` にバックアップされる。

```bash
./setup.sh
```

対象: `.bash_profile`, `.bashrc`, `.gitconfig`, `.gitignore_global`, `ghostty/config`

### cmux / Ghostty

[cmux](https://cmux.dev/) のターミナル設定（Ghostty ベース）。`setup.sh` で `~/.config/ghostty/config` にリンクされる。

設定を変更した場合、cmux 上で `Cmd+Shift+,` でリロードできる。

### Homebrew パッケージ

[Homebrew](https://brew.sh/) インストール後に実行。

```bash
brew bundle --file=~/Desktop/dotfiles/Brewfile
```

### ランタイム (Homebrew で入らないもの)

```bash
# Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# Node (Volta)
volta install node

# Ruby (rbenv)
rbenv install 3.4.3
rbenv global 3.4.3

# Bun
curl -fsSL https://bun.sh/install | bash
```

## メンテナンス

### Brewfile を現状に更新したい時

```bash
brew bundle dump --file=~/Desktop/dotfiles/Brewfile --force
```

`--force` で既存の Brewfile を上書きする。必要に応じて中身を精査してから commit。
