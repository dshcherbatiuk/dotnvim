#!/usr/bin/env bash
set -euo pipefail

# Setup Rust IDE dependencies for Neovim

echo "🦀 Setting up Rust IDE tooling..."
echo ""

# Check rustup
echo "🔍 Checking rustup..."
if command -v rustup &>/dev/null; then
  echo "✅ rustup found"
else
  echo "📦 Installing rustup..."
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
  source "$HOME/.cargo/env"
  echo "✅ rustup installed"
fi

# Rust toolchain — ensure stable is installed and up to date
echo "🔍 Checking Rust toolchain..."
if command -v rustc &>/dev/null; then
  echo "✅ rustc $(rustc --version | awk '{print $2}')"
  echo "📦 Updating stable toolchain..."
  rustup update stable
  echo "✅ Rust stable updated to $(rustc --version | awk '{print $2}')"
else
  echo "📦 Installing stable toolchain..."
  rustup install stable
  rustup default stable
  echo "✅ Rust stable installed"
fi

# rust-analyzer
echo "🔍 Checking rust-analyzer..."
if command -v rust-analyzer &>/dev/null; then
  echo "✅ rust-analyzer already installed"
else
  echo "📦 Installing rust-analyzer..."
  rustup component add rust-analyzer
  echo "✅ rust-analyzer installed"
fi

# clippy
echo "🔍 Checking clippy..."
if command -v clippy-driver &>/dev/null; then
  echo "✅ clippy already installed"
else
  echo "📦 Installing clippy..."
  rustup component add clippy
  echo "✅ clippy installed"
fi

# rustfmt
echo "🔍 Checking rustfmt..."
if command -v rustfmt &>/dev/null; then
  echo "✅ rustfmt already installed"
else
  echo "📦 Installing rustfmt..."
  rustup component add rustfmt
  echo "✅ rustfmt installed"
fi

# cargo-watch (optional, for auto-rebuild)
echo "🔍 Checking cargo-watch..."
if command -v cargo-watch &>/dev/null; then
  echo "✅ cargo-watch already installed"
else
  echo "📦 Installing cargo-watch..."
  cargo install --locked cargo-watch
  echo "✅ cargo-watch installed"
fi

# codelldb — debug adapter for Rust
CODELLDB_DIR="$HOME/.local/share/nvim/codelldb"
echo "🔍 Checking codelldb..."
if [ -d "$CODELLDB_DIR" ]; then
  echo "✅ codelldb already installed"
else
  echo "📦 Installing codelldb..."
  ARCH=$(uname -m)
  if [ "$ARCH" = "arm64" ]; then
    CODELLDB_ARCH="aarch64"
  else
    CODELLDB_ARCH="x86_64"
  fi
  CODELLDB_URL="https://github.com/vadimcn/codelldb/releases/latest/download/codelldb-${CODELLDB_ARCH}-darwin.vsix"
  mkdir -p "$CODELLDB_DIR"
  curl -L "$CODELLDB_URL" -o /tmp/codelldb.vsix
  cd "$CODELLDB_DIR"
  unzip -o /tmp/codelldb.vsix
  rm /tmp/codelldb.vsix
  cd -
  echo "✅ codelldb installed"
fi

echo ""
echo "🎉 Rust IDE tooling ready!"
echo ""
echo "  rustc          — Rust compiler"
echo "  rust-analyzer  — Language server (LSP)"
echo "  clippy         — Linter"
echo "  rustfmt        — Formatter"
echo "  cargo-watch    — Auto-rebuild on save"
echo "  codelldb       — Debug adapter"
