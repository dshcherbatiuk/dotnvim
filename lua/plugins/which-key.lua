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
  { "<leader>fy", function()
    local path
    local ok, oil = pcall(require, "oil")
    if ok and oil.get_current_dir() then
      local entry = oil.get_cursor_entry()
      if entry then
        path = oil.get_current_dir() .. entry.name
      else
        path = oil.get_current_dir()
      end
    else
      path = vim.fn.expand("%:p")
    end
    vim.fn.setreg("+", path)
    vim.notify("📋 " .. path, vim.log.levels.INFO)
  end, desc = "Copy file path" },
  { "<leader>fd", function()
    local file1 = vim.fn.expand("%:p")
    vim.ui.input({ prompt = "Diff with: ", completion = "file" }, function(file2)
      if file2 and file2 ~= "" then
        vim.cmd("vsplit " .. vim.fn.fnameescape(file2))
        vim.cmd("windo diffthis")
        vim.cmd("windo set scrollbind cursorbind foldlevel=0")
      end
    end)
  end, desc = "Diff with file" },
  { "<leader>fD", "<cmd>windo diffoff<cr>", desc = "Diff off (close diff)" },
  { "<leader>fo", "do", desc = "Diff obtain (pull change)" },
  { "<leader>fp", "dp", desc = "Diff put (push change)" },
  { "<leader>fj", "]c", desc = "Next diff change" },
  { "<leader>fk", "[c", desc = "Prev diff change" },

  -- +buffer
  { "<leader>b", group = "buffer" },
  { "<leader>bb", "<cmd>Telescope buffers<cr>", desc = "Switch buffer" },
  { "<leader>bk", function()
    local buf = vim.api.nvim_get_current_buf()
    local bufs = vim.tbl_filter(function(b)
      return vim.api.nvim_buf_is_valid(b) and vim.bo[b].buflisted
    end, vim.api.nvim_list_bufs())
    if #bufs > 1 then
      vim.cmd("bprevious")
    else
      vim.cmd("enew")
    end
    vim.api.nvim_buf_delete(buf, { force = false })
  end, desc = "Kill buffer" },
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
  { "<leader>pp", function() _G.open_project() end, desc = "Recent projects" },
  { "<leader>pn", function() _G.find_new_project() end, desc = "Find new project" },
  { "<leader>pr", "<cmd>ProjectRoot<cr>", desc = "Go to project root" },

  -- +open
  { "<leader>o", group = "open" },
  { "<leader>op", "<cmd>Oil<cr>", desc = "File explorer (dired)" },
  { "<leader>o-", "<cmd>Oil<cr>", desc = "Open parent directory" },

  -- +git
  { "<leader>g", group = "git" },
  { "<leader>gs", "<cmd>Telescope git_status<cr>", desc = "Git status" },
  { "<leader>gb", function()
    require("telescope.builtin").git_branches({
      attach_mappings = function(_, map)
        map("i", "<S-y>", function()
          local selection = require("telescope.actions.state").get_selected_entry()
          if selection then
            vim.fn.setreg("+", selection.value)
            vim.notify("📋 " .. selection.value, vim.log.levels.INFO)
          end
        end)
        return true
      end,
    })
  end, desc = "Branches" },
  { "<leader>gl", "<cmd>Telescope git_commits<cr>", desc = "Log" },
  { "<leader>gd", "<cmd>DiffviewFileHistory %<cr>", desc = "Diff file history" },
  { "<leader>gD", "<cmd>DiffviewOpen HEAD<cr>", desc = "Diff all changes" },
  { "<leader>gm", "<cmd>DiffviewOpen<cr>", desc = "Merge tool (conflicts)" },
  { "<leader>gq", "<cmd>DiffviewClose<cr>", desc = "Close diff view" },
  { "<leader>gB", function() require("gitsigns").blame_line({ full = true }) end, desc = "Blame line" },
  { "<leader>gp", function() require("gitsigns").preview_hunk() end, desc = "Preview hunk" },
  { "<leader>gr", function() require("gitsigns").reset_hunk() end, desc = "Reset hunk" },
  { "<leader>gS", function() require("gitsigns").stage_hunk() end, desc = "Stage hunk" },
  { "<leader>gu", function() require("gitsigns").undo_stage_hunk() end, desc = "Undo stage hunk" },
  { "<leader>gR", function() require("gitsigns").reset_buffer() end, desc = "Reset buffer" },
  { "<leader>gt", function() require("gitsigns").toggle_current_line_blame() end, desc = "Toggle line blame" },
  { "<leader>gM", function()
    require("telescope.builtin").git_branches({
      prompt_title = "Merge branch",
      attach_mappings = function(prompt_bufnr)
        require("telescope.actions").select_default:replace(function()
          local selection = require("telescope.actions.state").get_selected_entry()
          require("telescope.actions").close(prompt_bufnr)
          if selection then
            local branch = selection.value
            vim.cmd("!git merge " .. branch)
          end
        end)
        return true
      end,
    })
  end, desc = "Merge branch" },
  { "<leader>gP", "<cmd>!git push<cr>", desc = "Push" },
  { "<leader>gF", "<cmd>!git pull<cr>", desc = "Pull" },
  { "<leader>gf", "<cmd>!git fetch<cr>", desc = "Fetch" },

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

  -- +markdown/notes
  { "<leader>m", group = "markdown" },
  { "<leader>mf", desc = "Fold section" },
  { "<leader>mu", desc = "Unfold section" },
  { "<leader>mt", "<cmd>MkdnToggleToDo<cr>", desc = "Toggle TODO" },
  { "<leader>ml", "<cmd>MkdnFollowLink<cr>", desc = "Follow link" },
  { "<leader>mn", "<cmd>MkdnNextHeading<cr>", desc = "Next heading" },
  { "<leader>mp", "<cmd>MkdnPrevHeading<cr>", desc = "Prev heading" },
  { "<leader>mT", "<cmd>MkdnTableFormat<cr>", desc = "Format table" },
  { "<leader>mo", "<cmd>DiagramOpen<cr>", desc = "Open diagram in Preview" },

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

-- IntelliJ-style keybindings
wk.add({
  { "<S-F6>", vim.lsp.buf.rename, desc = "Rename (Shift+F6)" },
  { "<M-CR>", vim.lsp.buf.code_action, desc = "Code action (Alt+Enter)" },
  { "<C-S-n>", "<cmd>Telescope find_files<cr>", desc = "Find file (Ctrl+Shift+N)" },
  { "<C-S-f>", "<cmd>Telescope live_grep<cr>", desc = "Find in path (Ctrl+Shift+F)" },
  { "<F12>", vim.lsp.buf.definition, desc = "Go to definition (F12)" },
  { "<C-F12>", vim.lsp.buf.type_definition, desc = "Go to type (Ctrl+F12)" },
  { "<M-F7>", vim.lsp.buf.references, desc = "Find usages (Alt+F7)" },
  { "<C-q>", vim.lsp.buf.hover, desc = "Quick docs (Ctrl+Q)" },
  { "<F2>", "<cmd>Oil<cr>", desc = "File explorer (dired)" },
  { "-", "<cmd>Oil<cr>", desc = "Open parent directory" },
})
