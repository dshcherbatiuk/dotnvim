#!/usr/bin/env bash
set -euo pipefail

# Install or update Neovim

NVIM_MIN_VERSION="0.10"

echo "🔍 Checking Neovim..."

if command -v nvim &>/dev/null; then
  current_version=$(nvim --version | head -1 | grep -oE '[0-9]+\.[0-9]+')
  echo "✅ Neovim $current_version found"

  # Check minimum version
  if printf '%s\n' "$NVIM_MIN_VERSION" "$current_version" | sort -V | head -1 | grep -q "$NVIM_MIN_VERSION"; then
    echo "✅ Version $current_version meets minimum $NVIM_MIN_VERSION"
  else
    echo "⚠️  Version $current_version is below minimum $NVIM_MIN_VERSION"
    echo "📦 Upgrading Neovim..."
    brew upgrade neovim
    echo "✅ Neovim upgraded to $(nvim --version | head -1 | grep -oE '[0-9]+\.[0-9]+\.[0-9]+')"
  fi
else
  echo "📦 Neovim not found. Installing..."

  if ! command -v brew &>/dev/null; then
    echo "❌ Homebrew not found. Install from https://brew.sh"
    exit 1
  fi

  brew install neovim
  echo "✅ Neovim $(nvim --version | head -1 | grep -oE '[0-9]+\.[0-9]+\.[0-9]+') installed"
fi
