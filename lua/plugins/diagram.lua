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

-- Open nearest mermaid diagram in external viewer (Preview on macOS)
vim.api.nvim_create_user_command("DiagramOpen", function()
  local cache_dir = vim.fn.stdpath("cache") .. "/diagram-cache/mermaid"
  local bufnr = vim.api.nvim_get_current_buf()
  local cursor_row = vim.api.nvim_win_get_cursor(0)[1]
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

  -- Find the nearest mermaid block containing or above the cursor
  local block_start, block_end = nil, nil
  local best_start, best_end = nil, nil
  for i, line in ipairs(lines) do
    if line:match("^```mermaid") then
      block_start = i
    elseif block_start and line:match("^```$") then
      block_end = i
      if block_start <= cursor_row and cursor_row <= block_end then
        best_start, best_end = block_start, block_end
        break
      elseif block_start <= cursor_row then
        best_start, best_end = block_start, block_end
      end
      block_start = nil
    end
  end

  if not best_start or not best_end then
    vim.notify("No mermaid block found", vim.log.levels.WARN)
    return
  end

  -- Extract source and find cached image
  local source = table.concat(
    vim.api.nvim_buf_get_lines(bufnr, best_start, best_end - 1, false), "\n"
  )
  local hash = vim.fn.sha256("mermaid:" .. source)
  local path = cache_dir .. "/" .. hash .. ".png"

  if vim.fn.filereadable(path) == 1 then
    vim.fn.jobstart({ "open", path })
  else
    vim.notify("Diagram not yet rendered. Wait for render to complete.", vim.log.levels.WARN)
  end
end, {})

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
