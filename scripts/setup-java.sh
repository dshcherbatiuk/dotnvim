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

# Required Java versions (jdtls needs 21+, projects may need 25)
JAVA_VERSIONS=(21 25)

for ver in "${JAVA_VERSIONS[@]}"; do
  echo "🔍 Checking Java $ver..."
  if /usr/libexec/java_home -v "$ver" &>/dev/null; then
    echo "✅ Java $ver found"
  else
    echo "📦 Installing Java (OpenJDK $ver)..."
    brew install "openjdk@$ver"
    sudo ln -sfn "$(brew --prefix "openjdk@$ver")/libexec/openjdk.jdk" "/Library/Java/JavaVirtualMachines/openjdk-$ver.jdk"
    echo "✅ Java $ver installed"
  fi
done

# Default to Java 25
export JAVA_HOME=$(/usr/libexec/java_home -v 25 2>/dev/null || /usr/libexec/java_home -v 21)
echo "✅ JAVA_HOME → $JAVA_HOME"

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

# java-debug adapter
JAVA_DEBUG_DIR="$HOME/.local/share/nvim/java-debug"
echo "🔍 Checking java-debug..."
if [ -d "$JAVA_DEBUG_DIR" ]; then
  echo "✅ java-debug already installed"
else
  echo "📦 Installing java-debug..."
  git clone https://github.com/microsoft/java-debug.git "$JAVA_DEBUG_DIR"
  cd "$JAVA_DEBUG_DIR"
  ./mvnw clean install -DskipTests
  cd -
  echo "✅ java-debug installed"
fi

# java-test adapter
JAVA_TEST_DIR="$HOME/.local/share/nvim/vscode-java-test"
echo "🔍 Checking vscode-java-test..."
if [ -d "$JAVA_TEST_DIR" ]; then
  echo "✅ vscode-java-test already installed"
else
  echo "📦 Installing vscode-java-test (pinned to 0.44.0)..."
  git clone --branch 0.44.0 --depth 1 https://github.com/microsoft/vscode-java-test.git "$JAVA_TEST_DIR"
  cd "$JAVA_TEST_DIR"
  npm install
  npm run build-plugin
  cd -
  echo "✅ vscode-java-test installed"
fi

echo ""
echo "🎉 Java IDE tooling ready!"
echo ""
echo "  jdtls            — Java Language Server (LSP)"
echo "  mvn              — Maven build tool"
echo "  gradle           — Gradle build tool"
echo "  google-java-format — Code formatter"
