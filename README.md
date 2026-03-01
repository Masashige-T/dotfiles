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

対象: `.bash_profile`, `.bashrc`, `.gitconfig`, `.gitignore_global`

### Homebrew パッケージ

[Homebrew](https://brew.sh/) インストール後に実行。

```bash
brew bundle --file=~/Desktop/dotfiles/Brewfile
```

## メンテナンス

### Brewfile を現状に更新したい時

```bash
brew bundle dump --file=~/Desktop/dotfiles/Brewfile --force
```

`--force` で既存の Brewfile を上書きする。必要に応じて中身を精査してから commit。
