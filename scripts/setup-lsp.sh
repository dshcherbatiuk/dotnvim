#!/usr/bin/env bash
set -euo pipefail

# Install language servers for Neovim LSP

echo "🔧 Setting up language servers..."
echo ""

# Check npm
if ! command -v npm &>/dev/null; then
  echo "❌ npm not found. Install Node.js first: brew install node"
  exit 1
fi

# npm-based language servers
npm_servers=(
  "yaml-language-server"
  "bash-language-server"
  "vscode-langservers-extracted"
  "dockerfile-language-server-nodejs"
  "pyright"
)

for server in "${npm_servers[@]}"; do
  echo "🔍 Checking $server..."
  if npm list -g "$server" &>/dev/null; then
    echo "✅ $server already installed"
  else
    echo "📦 Installing $server..."
    npm install -g "$server"
    echo "✅ $server installed"
  fi
done

# Brew-based language servers
echo ""
echo "🔍 Checking Homebrew servers..."

if ! command -v brew &>/dev/null; then
  echo "⚠️  Homebrew not found, skipping brew-based servers"
else
  brew_servers=(
    "rust-analyzer"
    "clang-format"
  )

  for server in "${brew_servers[@]}"; do
    echo "🔍 Checking $server..."
    if command -v "$server" &>/dev/null; then
      echo "✅ $server already installed"
    else
      echo "📦 Installing $server..."
      brew install "$server"
      echo "✅ $server installed"
    fi
  done
fi

echo ""
echo "🎉 Language servers ready!"
echo ""
echo "  yaml-language-server    — YAML"
echo "  bash-language-server    — Bash/Shell"
echo "  vscode-json-language-server — JSON"
echo "  docker-langserver       — Dockerfile"
echo "  pyright                 — Python"
echo "  rust-analyzer           — Rust"
echo ""
echo "Java (jdtls) is installed separately: make java"
