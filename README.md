# dotnvim

Personal Neovim configuration inspired by Doom Emacs. Uses [rocks.nvim](https://github.com/nvim-neorocks/rocks.nvim) as plugin manager.

## Quick Start

```bash
git clone git@github.com:dshcherbatiuk/dotnvim.git ~/.config/nvim
cd ~/.config/nvim
make setup
```

## Commands

```
make setup     # First-time setup: install fonts + sync plugins
make pull      # Pull latest config + sync plugins
make push      # Commit and push config changes
make sync      # Sync plugins from rocks.toml
make upgrade   # Update all plugins to latest
make doctor    # Diagnose issues: fonts, LSP servers, plugins
make fonts     # Install Nerd Font + configure Kitty
make backup    # Backup config to ~/.config/nvim.bak
make clean     # Wipe plugin cache for fresh install
make edit      # Open config in Neovim
```

## Requirements

- Neovim >= 0.10
- [Homebrew](https://brew.sh) (for font installation)
- [Kitty](https://sw.kovidgoyal.net/kitty/) terminal
- A [Nerd Font](https://www.nerdfonts.com/) (`make fonts` installs one)

## Structure

```
init.lua          # Entry point: leader keys + rocks.nvim bootstrap
rocks.toml        # Plugin declarations (auto-synced)
lua/plugins/      # Per-plugin config (auto-loaded by rocks-config.nvim)
scripts/          # Setup scripts (fonts, etc.)
docs/             # Migration plan and notes
Makefile          # CLI entry point (Doom Emacs style)
```

## Adding a Plugin

1. Add the plugin to `rocks.toml`
2. Create `lua/plugins/<plugin-name>.lua` with setup config
3. Restart Neovim (auto-sync will install it)
