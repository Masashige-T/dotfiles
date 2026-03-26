#!/bin/bash
# Install packages on Ubuntu/Debian (WSL2) — equivalent to Brewfile on macOS
set -euo pipefail

if [[ "$(uname -s)" != "Linux" ]]; then
  echo "This script is for Linux only." >&2
  exit 1
fi

# -- apt packages --
sudo apt-get update
# NOTE: postgresql / redis は Docker で運用するため省略
sudo apt-get install -y \
  bash-completion \
  git \
  jq \
  tree \
  shellcheck \
  mkcert \
  libnss3-tools \
  unzip

# -- GitHub CLI (gh) --
if ! command -v gh &>/dev/null; then
  sudo mkdir -p -m 755 /etc/apt/keyrings
  curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg \
    | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg >/dev/null
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" \
    | sudo tee /etc/apt/sources.list.d/github-cli.list >/dev/null
  sudo apt-get update
  sudo apt-get install -y gh
  echo "Installed gh"
fi

# -- AWS CLI v2 --
if ! command -v aws &>/dev/null; then
  tmpdir="$(mktemp -d)"
  curl -fsSL "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "$tmpdir/awscliv2.zip"
  unzip -q "$tmpdir/awscliv2.zip" -d "$tmpdir"
  sudo "$tmpdir/aws/install"
  rm -rf "$tmpdir"
  echo "Installed aws-cli"
fi

# -- Starship --
if ! command -v starship &>/dev/null; then
  curl -fsSL https://starship.rs/install.sh | sh -s -- --yes
  echo "Installed starship"
fi

# -- uv (Python package manager) --
if ! command -v uv &>/dev/null; then
  curl -fsSL https://astral.sh/uv/install.sh | sh
  echo "Installed uv"
fi

# -- rbenv + ruby-build --
if [[ ! -d "$HOME/.rbenv" ]]; then
  git clone https://github.com/rbenv/rbenv.git ~/.rbenv
  git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
  echo "Installed rbenv + ruby-build"
fi

# -- tfenv --
if [[ ! -d "$HOME/.tfenv" ]]; then
  git clone https://github.com/tfutils/tfenv.git ~/.tfenv
  echo "Installed tfenv (add ~/.tfenv/bin to PATH)"
fi

# -- bats-core --
if ! command -v bats &>/dev/null; then
  tmpdir="$(mktemp -d)"
  git clone https://github.com/bats-core/bats-core.git "$tmpdir/bats-core"
  sudo "$tmpdir/bats-core/install.sh" /usr/local
  rm -rf "$tmpdir"
  echo "Installed bats-core"
fi

# -- taplo (TOML toolkit) --
if ! command -v taplo &>/dev/null; then
  curl -fsSL https://github.com/tamasfe/taplo/releases/latest/download/taplo-linux-x86_64.gz \
    | gunzip > /tmp/taplo
  chmod +x /tmp/taplo
  sudo mv /tmp/taplo /usr/local/bin/taplo
  echo "Installed taplo"
fi

echo "All packages installed!"
