local ok, wk = pcall(require, "which-key")
if not ok then
  return
end

wk.setup({
  preset = "modern",
  delay = 200,
  icons = {
    breadcrumb = "»",
    separator = "➜",
    group = "+",
  },
})

-- SPC leader keybindings (Doom-style mnemonic groups)
wk.add({
  -- +file
  { "<leader>f", group = "file" },
  { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find file" },
  { "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Recent files" },
  { "<leader>fs", "<cmd>w<cr>", desc = "Save file" },
  { "<leader>fS", "<cmd>wa<cr>", desc = "Save all" },
  { "<leader>fn", "<cmd>enew<cr>", desc = "New file" },

  -- +buffer
  { "<leader>b", group = "buffer" },
  { "<leader>bb", "<cmd>Telescope buffers<cr>", desc = "Switch buffer" },
  { "<leader>bd", "<cmd>bdelete<cr>", desc = "Kill buffer" },
  { "<leader>bn", "<cmd>bnext<cr>", desc = "Next buffer" },
  { "<leader>bp", "<cmd>bprevious<cr>", desc = "Previous buffer" },
  { "<leader>bs", "<cmd>w<cr>", desc = "Save buffer" },

  -- +window
  { "<leader>w", group = "window" },
  { "<leader>wv", "<cmd>vsplit<cr>", desc = "Split vertical" },
  { "<leader>ws", "<cmd>split<cr>", desc = "Split horizontal" },
  { "<leader>wd", "<cmd>close<cr>", desc = "Close window" },
  { "<leader>wh", "<C-w>h", desc = "Move left" },
  { "<leader>wj", "<C-w>j", desc = "Move down" },
  { "<leader>wk", "<C-w>k", desc = "Move up" },
  { "<leader>wl", "<C-w>l", desc = "Move right" },
  { "<leader>w=", "<C-w>=", desc = "Balance windows" },
  { "<leader>wm", "<cmd>only<cr>", desc = "Maximize" },

  -- +search
  { "<leader>s", group = "search" },
  { "<leader>sp", "<cmd>Telescope live_grep<cr>", desc = "Search project" },
  { "<leader>ss", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "Search buffer" },
  { "<leader>sf", "<cmd>Telescope find_files<cr>", desc = "Search files" },
  { "<leader>sh", "<cmd>Telescope help_tags<cr>", desc = "Search help" },
  { "<leader>sr", "<cmd>Telescope resume<cr>", desc = "Resume search" },

  -- +project
  { "<leader>p", group = "project" },
  { "<leader>pf", "<cmd>Telescope find_files<cr>", desc = "Find file in project" },
  { "<leader>pp", "<cmd>Telescope find_files cwd=~/dev<cr>", desc = "Switch project" },

  -- +open
  { "<leader>o", group = "open" },
  { "<leader>op", "<cmd>Neotree toggle<cr>", desc = "File explorer" },
  { "<leader>oP", "<cmd>Neotree reveal<cr>", desc = "Find in explorer" },

  -- +git (placeholders — expanded in Phase 5)
  { "<leader>g", group = "git" },
  { "<leader>gs", "<cmd>Telescope git_status<cr>", desc = "Git status" },
  { "<leader>gb", "<cmd>Telescope git_branches<cr>", desc = "Branches" },
  { "<leader>gl", "<cmd>Telescope git_commits<cr>", desc = "Log" },

  -- +code
  { "<leader>c", group = "code" },
  { "<leader>ca", vim.lsp.buf.code_action, desc = "Code action" },
  { "<leader>cr", vim.lsp.buf.rename, desc = "Rename" },
  { "<leader>cf", function() vim.lsp.buf.format({ async = true }) end, desc = "Format" },
  { "<leader>cd", vim.diagnostic.open_float, desc = "Line diagnostics" },

  -- +debug (placeholders — expanded in Phase 7)
  { "<leader>d", group = "debug" },

  -- +refactor
  { "<leader>r", group = "refactor" },
  { "<leader>rr", vim.lsp.buf.rename, desc = "Rename" },
  { "<leader>ra", vim.lsp.buf.code_action, desc = "Code action" },

  -- Top-level shortcuts
  { "<leader><leader>", "<cmd>Telescope find_files<cr>", desc = "Find file" },
  { "<leader>:", "<cmd>Telescope commands<cr>", desc = "Commands" },
  { "<leader>/", "<cmd>Telescope live_grep<cr>", desc = "Search project" },
  { "<leader>,", "<cmd>Telescope buffers<cr>", desc = "Switch buffer" },
  { "<leader>.", "<cmd>Telescope find_files<cr>", desc = "Find file" },
  { "<leader>q", "<cmd>qa<cr>", desc = "Quit" },

  -- +help
  { "<leader>h", group = "help" },
  { "<leader>hk", "<cmd>Telescope keymaps<cr>", desc = "Keymaps" },
  { "<leader>hh", "<cmd>Telescope help_tags<cr>", desc = "Help tags" },
  { "<leader>hm", "<cmd>Telescope man_pages<cr>", desc = "Man pages" },
})

-- LSP goto keybindings (normal mode, no leader)
wk.add({
  { "gd", vim.lsp.buf.definition, desc = "Go to definition" },
  { "gr", vim.lsp.buf.references, desc = "Find references" },
  { "gi", vim.lsp.buf.implementation, desc = "Go to implementation" },
  { "gt", vim.lsp.buf.type_definition, desc = "Go to type definition" },
  { "K", vim.lsp.buf.hover, desc = "Hover docs" },
  { "[d", vim.diagnostic.goto_prev, desc = "Previous diagnostic" },
  { "]d", vim.diagnostic.goto_next, desc = "Next diagnostic" },
})

-- IntelliJ-style keybindings (from your Doom config)
wk.add({
  { "<S-F6>", vim.lsp.buf.rename, desc = "Rename" },
  { "<M-CR>", vim.lsp.buf.code_action, desc = "Code action" },
  { "<F2>", "<cmd>Neotree toggle<cr>", desc = "File explorer" },
})
