-- claudecode.nvim: exposes Neovim to the Claude Code CLI as an MCP server over
-- WebSocket, so proposed edits arrive as reviewable diffs instead of landing on
-- disk. Keymaps live in which-key.lua with the other leader mappings.

local ok, claudecode = pcall(require, "claudecode")
if not ok then
  return
end

claudecode.setup({
  terminal = {
    provider = require("plugins.claudecode-fullwindow"),
  },
  diff_opts = {
    -- The terminal owns a whole window rather than a sized split, so there is
    -- no width for the plugin to manage across the diff lifecycle.
    auto_resize_terminal = false,
  },
})

-- Claude Code keys its conversation history by working directory, so each
-- project needs a session rooted in its own cwd. There are two ways to arrive in
-- a project: starting Neovim inside one, and switching with the project pickers,
-- which cd before opening Oil. Neither event covers the other — cd to the
-- directory you are already in fires nothing at all.

local function in_project()
  return vim.fs.find({ ".git" }, { upward = true, path = vim.fn.getcwd() })[1] ~= nil
end

---Start Claude for the current working directory, unless one is already running.
---@param on_conflict string? Warning to show when a session is already alive
local function autostart(on_conflict)
  if not in_project() then
    return
  end

  local ok_terminal, terminal = pcall(require, "claudecode.terminal")
  if not ok_terminal then
    return
  end

  -- A running session is deliberately left alone: it holds a conversation that
  -- restarting would discard, and it stays rooted where it started.
  if terminal.get_active_terminal_bufnr() then
    if on_conflict then
      vim.notify(on_conflict, vim.log.levels.WARN)
    end
    return
  end

  local started, err = pcall(terminal.ensure_visible)
  if not started then
    vim.notify("❌ Claude autostart failed: " .. tostring(err), vim.log.levels.ERROR)
  end
end

vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    autostart()
  end,
})

vim.api.nvim_create_autocmd("DirChanged", {
  callback = function()
    if vim.v.vim_did_enter == 0 then
      return
    end
    autostart("⚠️ Claude is still rooted in the previous project — close it to start one here")
  end,
})
