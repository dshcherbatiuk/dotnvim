local ok, diffview = pcall(require, "diffview")
if not ok then
  return
end

local actions = require("diffview.actions")

diffview.setup({
  enhanced_diff_hl = true,
  keymaps = {
    file_panel = {
      { "n", "q", false },
    },
    file_history_panel = {
      { "n", "q", false },
    },
  },
  view = {
    default = {
      layout = "diff2_horizontal",
    },
    merge_tool = {
      layout = "diff3_mixed",
      disable_diagnostics = true,
    },
    file_history = {
      layout = "diff2_horizontal",
    },
  },
  file_panel = {
    listing_style = "tree",
    win_config = {
      position = "left",
      width = 35,
    },
  },
})
