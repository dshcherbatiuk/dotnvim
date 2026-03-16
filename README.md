# dotnvim

Personal Neovim IDE configuration. Uses [rocks.nvim](https://github.com/nvim-neorocks/rocks.nvim) as plugin manager.

## Quick Start

```bash
git clone git@github.com:dshcherbatiuk/dotnvim.git ~/.config/nvim
cd ~/.config/nvim
make setup
```

## Commands

```
make setup     # First-time setup: fonts + deps + sync plugins
make pull      # Pull latest config + sync plugins
make push      # Commit and push config changes
make sync      # Sync plugins from rocks.toml
make upgrade   # Update all plugins to latest
make doctor    # Diagnose issues: fonts, LSP servers, plugins
make fonts     # Install Nerd Font + configure Kitty
make deps      # Install external deps (ImageMagick, mermaid-cli)
make backup    # Backup config to ~/.config/nvim.bak
make clean     # Wipe plugin cache for fresh install
make edit      # Open config in Neovim
```

## Requirements

- Neovim >= 0.10
- [Homebrew](https://brew.sh) (for font installation)
- [Kitty](https://sw.kovidgoyal.net/kitty/) terminal (>= 28.0, for inline image rendering)
- [Node.js](https://nodejs.org/) (for mermaid-cli)
- A [Nerd Font](https://www.nerdfonts.com/) (`make fonts` installs one)

## Markdown Features

Markdown files have org-mode-like editing powered by mkdnflow + render-markdown.nvim:

- **Folding** — `<leader>mf` / `<leader>mu` to fold/unfold sections
- **TODO/Checkboxes** — `<C-Space>` to toggle, cycles through `[ ]` / `[-]` / `[x]`
- **Heading navigation** — `]]` / `[[` to jump between headings, `+` / `=` to promote/demote
- **Link following** — `<CR>` to follow, `<BS>` to go back
- **Tables** — `<Tab>` / `<S-Tab>` to navigate cells, `<leader>mT` to format
- **Mermaid diagrams** — rendered as inline images via Kitty graphics protocol (`make deps` installs ImageMagick + mermaid-cli)

## Structure

```
init.lua          # Entry point: leader keys + rocks.nvim bootstrap
rocks.toml        # Plugin declarations (auto-synced)
lua/plugins/      # Per-plugin config (auto-loaded by rocks-config.nvim)
scripts/          # Setup scripts (fonts, etc.)
docs/             # Migration plan and notes
Makefile          # CLI entry point
```

## Adding a Plugin

1. Add the plugin to `rocks.toml`
2. Create `lua/plugins/<plugin-name>.lua` with setup config
3. Restart Neovim (auto-sync will install it)
