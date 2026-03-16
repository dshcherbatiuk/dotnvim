#!/usr/bin/env bash
set -euo pipefail

# Setup Java IDE dependencies for Neovim

echo "☕ Setting up Java IDE tooling..."
echo ""

# Check Homebrew
if ! command -v brew &>/dev/null; then
  echo "❌ Homebrew not found. Install from https://brew.sh"
  exit 1
fi

# Check Java
echo "🔍 Checking Java..."
if command -v java &>/dev/null; then
  java_version=$(java -version 2>&1 | head -1)
  echo "✅ Java found: $java_version"
else
  echo "❌ Java not found. Install with: brew install openjdk"
  exit 1
fi

# jdtls — Eclipse Java Language Server
echo "🔍 Checking jdtls..."
if command -v jdtls &>/dev/null; then
  echo "✅ jdtls already installed"
else
  echo "📦 Installing jdtls..."
  brew install jdtls
  echo "✅ jdtls installed"
fi

# Maven
echo "🔍 Checking Maven..."
if command -v mvn &>/dev/null; then
  echo "✅ Maven already installed"
else
  echo "📦 Installing Maven..."
  brew install maven
  echo "✅ Maven installed"
fi

# Gradle
echo "🔍 Checking Gradle..."
if command -v gradle &>/dev/null; then
  echo "✅ Gradle already installed"
else
  echo "📦 Installing Gradle..."
  brew install gradle
  echo "✅ Gradle installed"
fi

# google-java-format — formatter
echo "🔍 Checking google-java-format..."
if command -v google-java-format &>/dev/null; then
  echo "✅ google-java-format already installed"
else
  echo "📦 Installing google-java-format..."
  brew install google-java-format
  echo "✅ google-java-format installed"
fi

echo ""
echo "🎉 Java IDE tooling ready!"
echo ""
echo "  jdtls            — Java Language Server (LSP)"
echo "  mvn              — Maven build tool"
echo "  gradle           — Gradle build tool"
echo "  google-java-format — Code formatter"
