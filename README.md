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
make setup          # First-time setup: nvim + fonts + deps + sync plugins
make pull           # Pull latest config + sync plugins
make push           # Commit and push config changes
make sync           # Sync plugins from rocks.toml
make upgrade        # Update all plugins to latest
make doctor         # Diagnose issues: fonts, LSP servers, plugins
make open           # Open Neovim with project picker
make nvim           # Install or update Neovim
make fonts          # Install Nerd Font + configure Kitty
make deps           # Install external deps (ImageMagick, mermaid-cli)
make lsp            # Install language servers (yaml, bash, json, python, etc.)
make java           # Install Java IDE tooling (jdtls, maven, gradle)
make rust           # Install Rust IDE tooling (rust-analyzer, clippy, rustfmt)
make clean-projects # Clear remembered projects list
make backup         # Backup config to ~/.config/nvim.bak
make clean          # Wipe plugin cache for fresh install
make edit           # Open config in Neovim
```

## Requirements

- [Homebrew](https://brew.sh) (for all installations)
- [Kitty](https://sw.kovidgoyal.net/kitty/) terminal (>= 28.0, for inline image rendering)
- [Node.js](https://nodejs.org/) (for mermaid-cli and npm-based LSP servers)
- A [Nerd Font](https://www.nerdfonts.com/) (`make fonts` installs one)

Neovim >= 0.10 is installed automatically by `make setup` or `make nvim`.

## Keybindings

Leader: `Space` | Local leader: `,`

### Global (SPC prefix)

| Key | Action |
|-----|--------|
| `SPC f f` | Find file |
| `SPC f r` | Recent files |
| `SPC s p` | Search project (grep) |
| `SPC b b` | Switch buffer |
| `SPC p p` | Recent projects |
| `SPC p n` | Find new project |
| `SPC g d` | Diff file history |
| `SPC g D` | Diff all changes |
| `SPC g B` | Blame line |
| `SPC g S` | Stage hunk |
| `SPC g r` | Reset hunk |
| `SPC g t` | Toggle line blame |

### IntelliJ-style

| Key | Action |
|-----|--------|
| `Shift+F6` | Rename |
| `Alt+Enter` | Code action |
| `Ctrl+Shift+N` | Find file |
| `Ctrl+Shift+F` | Find in path |
| `F12` | Go to definition |
| `Alt+F7` | Find usages |
| `Ctrl+Q` | Quick docs |

### LSP

| Key | Action |
|-----|--------|
| `gd` | Go to definition |
| `gr` | Find references |
| `gi` | Go to implementation |
| `K` | Hover docs |

### Folding

| Key | Action |
|-----|--------|
| `za` | Toggle fold |
| `zc` / `zo` | Close / open fold |
| `zM` / `zR` | Close all / open all |

### Language-specific (localleader `,`)

**Java:** `, o` organize imports | `, t` test method | `, T` test class | `, ev/ec/em` extract variable/constant/method

**Rust:** `, r` cargo run | `, b` build | `, t` test | `, c` clippy | `, f` format | `, d` docs | `, w` watch

## Structure

```
init.lua              # Entry point: leader keys, options, rocks.nvim bootstrap
rocks.toml            # Plugin declarations (auto-synced)
lua/plugins/          # Per-plugin config (auto-loaded by rocks-config.nvim)
  nvim-lspconfig.lua  # Shared LSP setup + simple servers
  nvim-jdtls.lua      # Java LSP (jdtls)
  rust.lua            # Rust LSP (rust-analyzer)
  nvim-cmp.lua        # Autocompletion
  gitsigns.lua        # Git gutter signs
  diffview.lua        # Side-by-side diffs
  project.lua         # Project detection + picker
  which-key.lua       # Keybinding groups
  ...
scripts/              # Setup scripts
  setup-nvim.sh       # Install/update Neovim
  setup-fonts.sh      # Nerd Font + Kitty
  setup-deps.sh       # ImageMagick, mermaid-cli
  setup-lsp.sh        # Language servers
  setup-java.sh       # Java tooling
  setup-rust.sh       # Rust tooling
Makefile              # CLI entry point
```

## Adding a Plugin

1. Add the plugin to `rocks.toml`
2. Create `lua/plugins/<plugin-name>.lua` with setup config
3. Run `:Rocks sync` or `make sync`

## Adding a Language

1. Create `scripts/setup-<lang>.sh` — install language server + tools
2. Add `make <lang>` target to Makefile
3. Create `lua/plugins/<lang>.lua` — LSP config + localleader keybindings
4. Add treesitter parser to `lua/plugins/treesitter.lua`
