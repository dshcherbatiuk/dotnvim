local ok, diffview = pcall(require, "diffview")
if not ok then
  return
end

diffview.setup({
  enhanced_diff_hl = true,
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
