#!/usr/bin/env bash
set -euo pipefail

# Bootstrap rocks.nvim and its build dependencies

echo "🔧 Checking build dependencies for rocks.nvim..."

if ! command -v brew &>/dev/null; then
  echo "❌ Homebrew not found. Install from https://brew.sh"
  exit 1
fi

# cmake is required by luarocks
echo "🔍 Checking cmake..."
if command -v cmake &>/dev/null; then
  echo "✅ cmake found"
else
  echo "📦 Installing cmake..."
  brew install cmake
  echo "✅ cmake installed"
fi

# luarocks build also needs unzip
echo "🔍 Checking unzip..."
if command -v unzip &>/dev/null; then
  echo "✅ unzip found"
else
  echo "📦 Installing unzip..."
  brew install unzip
  echo "✅ unzip installed"
fi

echo ""
echo "🚀 Bootstrapping rocks.nvim..."
echo "   Opening Neovim to install rocks.nvim (first run)..."
echo "   This may take a minute. Press ENTER if prompted."
echo ""

# First run: let rocks.nvim bootstrap itself
nvim --headless -c "sleep 30" -c "qa!" 2>&1 || true

# Verify installation
if [ -d "$HOME/.local/share/nvim/rocks/lib/luarocks/rocks-5.1/rocks.nvim" ]; then
  echo "✅ rocks.nvim installed successfully"
else
  echo "⚠️  rocks.nvim may not have installed. Open nvim manually and wait for bootstrap."
fi
