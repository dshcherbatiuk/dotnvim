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
      },
    },
  },
})
