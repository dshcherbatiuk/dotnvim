#!/usr/bin/env bash
set -euo pipefail

# Setup external dependencies for Neovim plugins

echo "🔍 Checking Homebrew..."
if ! command -v brew &>/dev/null; then
  echo "❌ Homebrew not found. Install from https://brew.sh"
  exit 1
fi

echo "🔍 Checking ImageMagick..."
if command -v magick &>/dev/null || command -v convert &>/dev/null; then
  echo "✅ ImageMagick already installed"
else
  echo "📦 Installing ImageMagick..."
  brew install imagemagick
  echo "✅ ImageMagick installed"
fi

echo "🔍 Checking Node.js..."
if ! command -v npm &>/dev/null; then
  echo "❌ npm not found. Install Node.js first: brew install node"
  exit 1
fi

echo "🔍 Checking mermaid-cli (mmdc)..."
if command -v mmdc &>/dev/null; then
  echo "✅ mermaid-cli already installed"
else
  echo "📦 Installing mermaid-cli..."
  npm install -g @mermaid-js/mermaid-cli
  echo "✅ mermaid-cli installed"
fi

echo ""
echo "🎉 Done! All dependencies installed."
