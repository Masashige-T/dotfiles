# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

macOS dotfiles repo for Bash + Ghostty + Starship setup. The repo lives at `~/Desktop/dotfiles` and uses symlinks to deploy config files to their expected locations.

## Key Commands

```bash
# Deploy all symlinks (backs up existing files as .bak)
./setup.sh

# Install Homebrew packages
brew bundle --file=~/Desktop/dotfiles/Brewfile

# Update Brewfile from currently installed packages
brew bundle dump --file=~/Desktop/dotfiles/Brewfile --force
```

## Architecture

- **`setup.sh`** — Creates symlinks from this repo into `$HOME` and `~/.config/`. Also generates shell completions (npm, pnpm) into Homebrew's `bash_completion.d`.
- **`.bash_profile`** — Login shell: Homebrew, PATH setup (rbenv, Volta, Cargo, Bun, OrbStack), bash-completion. Sources `.bashrc`.
- **`.bashrc`** — Interactive shell: only initializes Starship prompt.
- **`starship.toml`** — Starship prompt config with Tokyo Night theme and Nerd Font icons. Shows directory, git, and language versions (Node, Bun, Ruby, Rust, Python, Go, PHP).
- **`ghostty/config`** — Ghostty terminal: JetBrainsMono Nerd Font, Tokyo Night palette, semi-transparent background. Shell is `/opt/homebrew/bin/bash --login`.
- **`Brewfile`** — Homebrew taps, formulae, casks, and VS Code extensions.
- **`.gitconfig`** / **`.gitignore_global`** — Git identity and global ignores.

## Symlink Targets

| Source | Destination |
|---|---|
| `.bash_profile`, `.bashrc`, `.gitconfig`, `.gitignore_global` | `~/` |
| `ghostty/config` | `~/.config/ghostty/config` |
| `starship.toml` | `~/.config/starship.toml` |

## Lint & Test

```bash
# Run all checks (ShellCheck + taplo + bats)
./lint.sh

# Individual tools
shellcheck setup.sh .bash_profile .bashrc
taplo check starship.toml
bats test/
```

CI runs the same checks on push/PR to `main` via `.github/workflows/ci.yml`.

## Workflow

- タスク完了時は `./lint.sh` を実行して全チェックがパスすることを確認してから commit → push する。
- ユーザーとの会話は日本語で行う。

## Notes

- README and commit messages are in Japanese.
- Runtime version managers (rbenv, Volta) are configured in `.bash_profile` but installed separately — not via `setup.sh`.
