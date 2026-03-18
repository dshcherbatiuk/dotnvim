local ok, oil = pcall(require, "oil")
if not ok then
  return
end

oil.setup({
  -- Auto-refresh when files change externally
  watch_for_changes = true,
  -- Show hidden files like dired's C-u s
  view_options = {
    show_hidden = true,
  },
  -- Column display similar to dired
  columns = {
    "icon",
    "permissions",
    "size",
    "mtime",
  },
  -- Open parent directory in current buffer (like dired's -)
  keymaps = {
    ["-"] = "actions.parent",
    ["<CR>"] = "actions.select",
    ["<C-v>"] = "actions.select_vsplit",
    ["<C-s>"] = "actions.select_split",
    ["<C-p>"] = "actions.preview",
    ["q"] = "actions.close",
    ["g?"] = "actions.show_help",
    ["g."] = "actions.toggle_hidden",
    ["_"] = "actions.open_cwd",
    ["gr"] = "actions.refresh",
  },
  -- Use floating window for preview
  float = {
    padding = 2,
    max_width = 100,
    max_height = 30,
  },
})

-- Diff two files: visual select 2 files in Oil, press D
vim.api.nvim_create_autocmd("FileType", {
  pattern = "oil",
  callback = function(args)
    vim.keymap.set("v", "D", function()
      local oil_dir = oil.get_current_dir()
      local start_line = vim.fn.line("v")
      local end_line = vim.fn.line(".")
      if start_line > end_line then
        start_line, end_line = end_line, start_line
      end
      local entries = {}
      for lnum = start_line, end_line do
        local entry = oil.get_entry_on_line(0, lnum)
        if entry and entry.type == "file" then
          table.insert(entries, oil_dir .. entry.name)
        end
      end
      if #entries == 2 then
        vim.cmd("tabnew " .. vim.fn.fnameescape(entries[1]))
        vim.cmd("vsplit " .. vim.fn.fnameescape(entries[2]))
        -- Enable diff with sync scroll + collapse unchanged
        vim.cmd("windo diffthis")
        vim.cmd("windo set scrollbind cursorbind foldlevel=0")
      else
        vim.notify("Select exactly 2 files to diff", vim.log.levels.WARN)
      end
    end, { buffer = args.buf, desc = "Diff selected files" })
  end,
})
