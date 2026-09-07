# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Personal Neovim configuration using **rocks.nvim** as the plugin manager (luarocks-based, not lazy.nvim/packer).

## Architecture

- `init.lua` — Entry point. Sets leader keys (`<Space>` / `,` for local leader) and bootstraps rocks.nvim.
- `rocks.toml` — Plugin declarations (equivalent to a lockfile). Plugins are added/updated here via `:Rocks install <plugin>` or by editing the TOML directly.
- `lua/plugins/` — Per-plugin configuration files. rocks-config.nvim auto-loads these by plugin name (configured via `plugins_dir = "plugins/"` in rocks.toml).

## Plugin Management (rocks.nvim)

rocks.nvim uses luarocks instead of git-based plugin managers. Key differences:

- **Install a plugin:** `:Rocks install <plugin>` (or add to `[plugins]` in `rocks.toml`)
- **Update plugins:** `:Rocks update`
- **Sync after editing rocks.toml:** `:Rocks sync`
- Git-sourced plugins use `rocks-git.nvim` with `git = "owner/repo"` syntax in rocks.toml
- Plugin data lives in `~/.local/share/nvim/rocks/`
- Config auto-loading is handled by `rocks-config.nvim` — create `lua/plugins/<plugin-name>.lua` to configure a plugin (no explicit `require` wiring needed)

## Current Plugins

Authoritative list is `rocks.toml` — this grouping is for orientation only.

- **LSP & completion** — nvim-lspconfig, nvim-jdtls (Java), nvim-cmp with cmp-nvim-lsp / cmp-buffer / cmp-path
- **Debugging** — nvim-dap, nvim-dap-ui, nvim-nio
- **Git** — gitsigns.nvim, diffview.nvim
- **AI** — claudecode.nvim (Claude Code MCP bridge; keymaps in `which-key.lua` under `+ai`)
- **Navigation** — telescope.nvim, project.nvim, oil.nvim
- **Editing** — nvim-treesitter, which-key.nvim
- **Markdown & diagrams** — neorg, mkdnflow, render-markdown.nvim, image.nvim, diagram.nvim
- **UI** — doom-one, lualine.nvim, alpha-nvim, nvim-web-devicons

Language tooling is installed outside the plugin manager by `make java` / `make rust` / `make lsp`; see `scripts/`.

## Adding Plugin Configuration

Create `lua/plugins/<plugin-name>.lua` with the setup call. The filename must match the plugin name in rocks.toml. Example: `lua/plugins/treesitter.lua` configures `nvim-treesitter`.
