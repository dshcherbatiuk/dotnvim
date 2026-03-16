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
