#!/bin/bash
# Run all linters and tests
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
failed=0

echo "=== ShellCheck ==="
if shellcheck "$DOTFILES_DIR"/setup.sh "$DOTFILES_DIR"/.bash_profile "$DOTFILES_DIR"/.bashrc; then
  echo "✔ ShellCheck passed"
else
  echo "✘ ShellCheck failed"
  failed=1
fi

echo ""
echo "=== taplo (TOML) ==="
if taplo check "$DOTFILES_DIR/starship.toml"; then
  echo "✔ taplo passed"
else
  echo "✘ taplo failed"
  failed=1
fi

echo ""
echo "=== bats (tests) ==="
if bats "$DOTFILES_DIR/test/"; then
  echo "✔ bats passed"
else
  echo "✘ bats failed"
  failed=1
fi

echo ""
if [ "$failed" -eq 0 ]; then
  echo "All checks passed!"
else
  echo "Some checks failed."
  exit 1
fi
