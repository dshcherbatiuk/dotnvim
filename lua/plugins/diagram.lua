local ok, diagram = pcall(require, "diagram")
if not ok then
  return
end

diagram.setup({
  events = {
    render_buffer = { "BufWinEnter", "InsertLeave" },
    clear_buffer = { "BufLeave" },
  },
  renderer_options = {
    mermaid = {
      theme = "dark",
      background = "transparent",
      scale = 3,
    },
  },
})

-- Auto-fold mermaid code blocks to hide source code
vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    vim.opt_local.foldmethod = "manual"

    -- Fold all mermaid code blocks after a short delay (wait for treesitter)
    vim.defer_fn(function()
      local bufnr = vim.api.nvim_get_current_buf()
      if not vim.api.nvim_buf_is_valid(bufnr) then return end
      if vim.bo[bufnr].filetype ~= "markdown" then return end

      local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
      local fold_start = nil
      for i, line in ipairs(lines) do
        if line:match("^```mermaid") then
          fold_start = i
        elseif fold_start and line:match("^```$") then
          -- Fold content + closing fence, keep opening fence visible for image anchor
          if i > fold_start + 1 then
            vim.cmd((fold_start + 1) .. "," .. i .. "fold")
          end
          fold_start = nil
        end
      end
    end, 500)
  end,
})
