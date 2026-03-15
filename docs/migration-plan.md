# Doom Emacs → Neovim Migration Plan

## Source: `~/.config/doom/`

Summary of current Doom Emacs setup to replicate in Neovim.

---

## Phase 1: Core Look & Feel

**Goal:** Make Neovim visually match Doom Emacs immediately.

- [ ] **Theme**: doom-one via `tokyonight.nvim` (doom-one port) or `doom-one.nvim`
- [ ] **Font**: Iosevka Term SS04 (configured in terminal emulator, not Neovim)
- [ ] **Statusline**: `lualine.nvim` — Doom-style modeline with git branch, diagnostics, file info
- [ ] **Dashboard**: `alpha-nvim` — startup screen (Doom removes the logo, so keep it minimal)
- [ ] **Line numbers**: absolute line numbers (already `display-line-numbers-type t`)
- [ ] **Icons**: `nvim-web-devicons` — file type icons for neo-tree, lualine, telescope

## Phase 2: Which-Key + SPC Leader Keybindings

**Goal:** Replicate Doom's mnemonic `SPC` leader system — the defining Doom UX.

- [ ] **which-key.nvim** — popup showing available keybindings after pressing leader
- [ ] Define key groups matching Doom:
  - `SPC f` — file operations (find file, recent files, save)
  - `SPC b` — buffer operations (switch, kill, list)
  - `SPC w` — window management (split, close, navigate)
  - `SPC s` — search (project grep, buffer search)
  - `SPC p` — project (find file in project, switch project)
  - `SPC g` — git (status, blame, log, diff, push, pull)
  - `SPC d` — debug (breakpoints, step, continue)
  - `SPC r` — refactor (rename, code action, imports)
  - `SPC z` — fold (open, close, toggle all)
  - `SPC o` — open (terminal, treemacs)
  - `,` (localleader) — language-specific bindings

## Phase 3: Navigation & Search

**Goal:** Replace ivy/counsel/projectile with Telescope equivalents.

- [ ] **telescope.nvim** (already installed) — configure as primary search
  - `SPC f f` → find file (projectile-find-file)
  - `SPC f r` → recent files
  - `SPC s p` → live grep in project (projectile-grep)
  - `SPC s s` → search in buffer
  - `SPC b b` → switch buffer (ivy-switch-buffer)
  - `SPC SPC` → find file in project
  - `SPC :` → command palette (counsel-M-x → telescope commands)
- [ ] **telescope-fzf-native.nvim** — faster fuzzy matching
- [ ] **project.nvim** or builtin `vim.fn.getcwd()` — project root detection (replaces projectile, search path: `~/dev`)

## Phase 4: LSP + Completion + Diagnostics

**Goal:** Full IDE intelligence matching your Doom LSP setup.

- [ ] **nvim-lspconfig** (already installed) — configure language servers:
  - `rust-analyzer` (Rust)
  - `jdtls` (Java) — via `nvim-jdtls` plugin for full Java support
  - `kotlin_language_server` (Kotlin)
  - `elixirls` / `lexical` (Elixir)
  - `erlang_ls` (Erlang)
  - `pyright` or `pylsp` (Python)
  - `clangd` (C/C++)
  - `bashls` (Shell)
  - `dockerls` (Docker)
  - `yamlls` (YAML)
  - `jsonls` (JSON)
- [ ] **nvim-cmp** or **blink.cmp** — autocompletion (replaces company)
  - LSP source, buffer source, snippet source, path source
  - Idle delay ~0.1s, min prefix 2 chars, show kind icons
- [ ] **fidget.nvim** — LSP progress spinner (replaces lsp-progress-via-spinner)
- [ ] **trouble.nvim** — diagnostics list (replaces flycheck-list-errors)
- [ ] **conform.nvim** — format on save (replaces format +onsave)
- [ ] **nvim-lint** — additional linting beyond LSP
- [ ] LSP keybindings to match Doom/IntelliJ:
  - `gd` → go to definition
  - `gr` → find references
  - `gi` → go to implementation
  - `K` → hover docs
  - `<S-F6>` → rename
  - `<M-CR>` → code action
  - `SPC c f` → format buffer
  - `SPC c o` → organize imports

## Phase 5: Git Integration

**Goal:** Replicate Magit + diff-hl + git-timemachine experience.

- [ ] **neogit** — Magit-style git interface (status, commit, push, pull, rebase)
- [ ] **gitsigns.nvim** — git gutter indicators (replaces diff-hl)
  - Hunk navigation (`]c` / `[c`), stage hunk, reset hunk, blame line
- [ ] **diffview.nvim** — side-by-side diff view (replaces ediff)
- [ ] **telescope** git pickers — branches, commits, stash
- [ ] Leader keybindings matching Doom `SPC g`:
  - `SPC g s` → git status (neogit)
  - `SPC g b` → blame
  - `SPC g l` → file log
  - `SPC g d` → diff current file
  - `SPC g p` → push
  - `SPC g u` → pull

## Phase 6: File Explorer

**Goal:** Configure neo-tree to match treemacs behavior.

- [ ] **neo-tree.nvim** (already installed) — configure:
  - Width 30, follow mode, git status icons, file watchers
  - Keybinding: `SPC o p` or `<F2>` to toggle (matching Doom)
  - `o` to open in last window, `v` for vertical split

## Phase 7: Terminal & Debugging

**Goal:** Integrated terminal and DAP debugging.

- [ ] **toggleterm.nvim** — terminal integration (replaces vterm)
  - `SPC o t` or `<M-F12>` to toggle
  - Scrollback 10000
- [ ] **nvim-dap** + **nvim-dap-ui** — debugging (replaces dap-mode)
  - Rust: codelldb or lldb-vscode adapter
  - Java: java-debug-adapter via nvim-jdtls
  - `SPC d` prefix for all debug operations
  - Breakpoint toggle, step in/over/out, continue, inspect

## Phase 8: Editor Enhancements

**Goal:** Match remaining Doom editor features.

- [ ] **nvim-treesitter** (already installed) — add textobjects, folding
  - `nvim-treesitter-textobjects` — smart text objects
  - Treesitter-based code folding (replaces origami)
- [ ] **nvim-autopairs** — auto-close brackets (replaces smartparens)
- [ ] **Comment.nvim** — comment toggling (`gcc`, `gc` in visual)
- [ ] **luasnip** + **friendly-snippets** — snippets (replaces yasnippet)
- [ ] **todo-comments.nvim** — highlight TODO/FIXME/HACK (replaces hl-todo)
- [ ] **editorconfig.nvim** — respect .editorconfig files
- [ ] **vim-illuminate** — highlight symbol under cursor (replaces lsp-enable-symbol-highlighting)
- [ ] **nvim-surround** — surround text objects

## Phase 9: Language-Specific Configs

**Goal:** Per-language configurations matching Doom localleader bindings.

Each language gets `lua/plugins/<lang>.lua` with:
- LSP server setup
- Format on save rules
- Localleader (`,`) keybindings for test/run/build
- Language-specific settings (tab width, etc.)

Languages by priority (based on Doom config):
1. **Rust** — rust-analyzer, cargo commands, clippy, format on save
2. **Java** — jdtls, Maven, DAP debugging, organize imports
3. **Kotlin** — kotlin-language-server, format on save
4. **Elixir** — elixirls, ExUnit test runner, mix integration
5. **Python** — pyright, format on save
6. **Erlang** — erlang_ls
7. **C/C++** — clangd
8. **Shell** — bashls
9. **YAML/JSON/Markdown/Docker** — respective LSP servers

## Phase 10: IntelliJ-Style Keybindings (Optional Layer)

**Goal:** Preserve your IntelliJ muscle memory alongside Doom SPC bindings.

- [ ] `C-S-n` → find file
- [ ] `C-S-f` → search in project
- [ ] `C-b` / `F12` → go to definition
- [ ] `S-F6` → rename
- [ ] `M-CR` → code action
- [ ] `F7/F8/F9` → debug step in/over/continue
- [ ] `C-F8` → toggle breakpoint
- [ ] `S-F10` → run
- [ ] `S-F9` → debug

---

## Plugin Summary (Neovim equivalents)

| Doom Module / Package | Neovim Equivalent |
|---|---|
| doom-one theme | `doom-one.nvim` or `tokyonight.nvim` |
| doom-modeline | `lualine.nvim` |
| doom-dashboard | `alpha-nvim` |
| evil | Native Vim keybindings |
| ivy/counsel | `telescope.nvim` |
| projectile | `project.nvim` or telescope builtins |
| company | `nvim-cmp` or `blink.cmp` |
| lsp-mode + lsp-ui | `nvim-lspconfig` + native LSP |
| flycheck | Built-in `vim.diagnostic` |
| magit | `neogit` |
| diff-hl | `gitsigns.nvim` |
| ediff | `diffview.nvim` |
| vterm | `toggleterm.nvim` |
| dap-mode | `nvim-dap` + `nvim-dap-ui` |
| treesitter | `nvim-treesitter` (already installed) |
| origami (folding) | Treesitter folding / `nvim-ufo` |
| smartparens | `nvim-autopairs` |
| which-key | `which-key.nvim` |
| hl-todo | `todo-comments.nvim` |
| snippets | `luasnip` + `friendly-snippets` |
| neotree/treemacs | `neo-tree.nvim` (already installed) |
| editorconfig | `editorconfig.nvim` |
| evil-multiedit | `vim-visual-multi` |

---

## Recommended Implementation Order

Start with phases 1-3 (look, keybindings, navigation) — this gives the Doom feel immediately.
Then phase 4 (LSP) makes it a usable IDE.
Phases 5-10 add depth incrementally.

Each phase is one conversation session — configure, test, commit.
