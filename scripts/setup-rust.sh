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

# Rust toolchain
echo "🔍 Checking Rust toolchain..."
if command -v rustc &>/dev/null; then
  echo "✅ rustc $(rustc --version | awk '{print $2}')"
else
  echo "📦 Installing stable toolchain..."
  rustup install stable
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
  cargo install cargo-watch
  echo "✅ cargo-watch installed"
fi

echo ""
echo "🎉 Rust IDE tooling ready!"
echo ""
echo "  rustc          — Rust compiler"
echo "  rust-analyzer  — Language server (LSP)"
echo "  clippy         — Linter"
echo "  rustfmt        — Formatter"
echo "  cargo-watch    — Auto-rebuild on save"
