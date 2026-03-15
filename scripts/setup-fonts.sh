#!/usr/bin/env bash
set -euo pipefail

# Setup Iosevka Term Nerd Font for Neovim + Kitty

echo "🔍 Checking Homebrew..."
if ! command -v brew &>/dev/null; then
  echo "❌ Homebrew not found. Install from https://brew.sh"
  exit 1
fi

echo "🔍 Checking for Iosevka Term Nerd Font..."
if fc-list | grep -qi "Iosevka.*Nerd"; then
  echo "✅ Iosevka Nerd Font already installed"
else
  echo "📦 Installing Iosevka Term Nerd Font..."
  brew install --cask font-iosevka-term-nerd-font
  echo "✅ Font installed"
fi

# Configure Kitty if config exists
KITTY_CONF="$HOME/.config/kitty/kitty.conf"
if [ -f "$KITTY_CONF" ]; then
  if grep -q "^font_family.*Iosevka" "$KITTY_CONF"; then
    echo "✅ Kitty already configured with Iosevka"
  else
    echo "🔧 Configuring Kitty font..."
    # Replace commented font_family block or add after font section marker
    if grep -q "^# font_family" "$KITTY_CONF"; then
      sed -i '' '/^# font_family.*mononoki/a\
font_family      IosevkaTerm Nerd Font\
bold_font        IosevkaTerm Nerd Font Bold\
italic_font      IosevkaTerm Nerd Font Italic\
bold_italic_font IosevkaTerm Nerd Font Bold Italic' "$KITTY_CONF"
    else
      # Prepend to file if no font_family line found
      sed -i '' '1i\
font_family      IosevkaTerm Nerd Font\
bold_font        IosevkaTerm Nerd Font Bold\
italic_font      IosevkaTerm Nerd Font Italic\
bold_italic_font IosevkaTerm Nerd Font Bold Italic\
' "$KITTY_CONF"
    fi
    echo "✅ Kitty font configured"
    echo "🔄 Reload Kitty with: Cmd+Ctrl+, or restart Kitty"
  fi
else
  echo "⚠️  Kitty config not found at $KITTY_CONF"
fi

echo ""
echo "🎉 Done! Restart Kitty to apply changes."
