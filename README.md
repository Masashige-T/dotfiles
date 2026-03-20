# dotfiles

## 対応環境

- **macOS** — Ghostty + Homebrew
- **Windows (WSL2)** — Windows Terminal + apt / Homebrew on Linux

`setup.sh` と `.bash_profile` が OS を自動判定し、環境に応じた設定を適用する。

## Setup

### macOS

```bash
git clone git@github.com:Masashige-T/dotfiles.git ~/Desktop/dotfiles
cd ~/Desktop/dotfiles
./setup.sh
```

### WSL2 (Ubuntu)

```bash
git clone git@github.com:Masashige-T/dotfiles.git ~/dotfiles
cd ~/dotfiles
./setup.sh
```

WSL2 では Ghostty のリンクはスキップされる。Windows Terminal の設定は `windows-terminal/settings.json` を参照し、手動でマージする。

> Windows Terminal の設定ファイル: `%LOCALAPPDATA%\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json`

### シンボリックリンク

`setup.sh` で以下をホームディレクトリにリンクする。既存ファイルは `.bak` にバックアップされる。

| 対象 | 備考 |
|---|---|
| `.bash_profile`, `.bashrc`, `.gitconfig`, `.gitignore_global` | 共通 |
| `ghostty/config` | macOS のみ |
| `starship.toml` | 共通 |

### ターミナル

| 環境 | ターミナル | 設定ファイル |
|---|---|---|
| macOS | [Ghostty](https://ghostty.org/) | `ghostty/config` |
| WSL2 | [Windows Terminal](https://github.com/microsoft/terminal) | `windows-terminal/settings.json` |

どちらも Tokyo Night テーマ、JetBrainsMono Nerd Font、透過度 90% で統一。

### Starship

[Starship](https://starship.rs/) プロンプト（Tokyo Night テーマ）。`setup.sh` で `~/.config/starship.toml` にリンクされる。

### Homebrew パッケージ

[Homebrew](https://brew.sh/) インストール後に実行。WSL2 でも [Homebrew on Linux](https://docs.brew.sh/Homebrew-on-Linux) が使える。

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
