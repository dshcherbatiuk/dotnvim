local ok, render_markdown = pcall(require, "render-markdown")
if not ok then
  return
end

render_markdown.setup({
  enabled = true,
  render_modes = { "n", "c" },
  -- Anti-conceal: show raw syntax on cursor line for editing
  anti_conceal = {
    enabled = true,
  },
  heading = {
    enabled = true,
    sign = true,
    icons = { "# ", "## ", "### ", "#### ", "##### ", "###### " },
  },
  code = {
    enabled = true,
    sign = true,
    style = "full",
    left_pad = 1,
    right_pad = 1,
  },
  checkbox = {
    enabled = true,
    unchecked = { icon = "  " },
    checked = { icon = "  " },
  },
  bullet = {
    enabled = true,
    icons = { "●", "○", "◆", "◇" },
  },
  pipe_table = {
    enabled = true,
    style = "full",
  },
  link = {
    enabled = true,
  },
})
