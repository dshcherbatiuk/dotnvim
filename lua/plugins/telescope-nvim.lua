local ok, telescope = pcall(require, "telescope")
if not ok then
  vim.notify("telescope.nvim not loaded yet — run :Rocks sync", vim.log.levels.WARN)
  return
end

telescope.setup({
  defaults = {
    prompt_prefix = "   ",
    selection_caret = "  ",
    sorting_strategy = "ascending",
    layout_config = {
      horizontal = {
        prompt_position = "top",
        width = 0.95,
        preview_width = 0.55,
      },
    },
  },
  pickers = {
    git_status = {
      git_icons = {
        added = " ",
        changed = " ",
        copied = " ",
        deleted = " ",
        renamed = " ",
        unmerged = " ",
        untracked = " ",
      },
      layout_config = {
        horizontal = {
          preview_width = 0.6,
        },
      },
    },
  },
  extensions = {
    ["ui-select"] = {
      require("telescope.themes").get_dropdown({}),
    },
  },
})

-- Route vim.ui.select through Telescope so pickers owned by other plugins —
-- LSP code actions, Claude model selection — match the rest of the config
-- instead of falling back to Neovim's plain numbered prompt.
pcall(telescope.load_extension, "ui-select")
