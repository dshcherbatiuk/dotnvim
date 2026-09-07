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

-- Claude Code keys its conversation history by working directory, so a session
-- belongs to the project it started in. Both project pickers cd before opening
-- Oil, which makes DirChanged the moment a project is chosen.
--
-- Starting Neovim inside a project deliberately does not autostart. A bare
-- editor stays bare; Claude is picked along with the project.

local function in_project()
  return vim.fs.find({ ".git" }, { upward = true, path = vim.fn.getcwd() })[1] ~= nil
end

-- Directories already granted to the live session. Reset whenever a new session
-- starts, since access does not survive the process it was granted to.
local granted = {}

---Start Claude for the current project, or widen the running session to include it.
local function autostart()
  if not in_project() then
    return
  end

  local ok_terminal, terminal = pcall(require, "claudecode.terminal")
  if not ok_terminal then
    return
  end

  local cwd = vim.fn.getcwd()

  -- A live session keeps its conversation and its original root. Rather than
  -- restarting it and losing that, grant it access to the newly opened
  -- repository, so a single task can span several of them.
  if terminal.get_active_terminal_bufnr() then
    if granted[cwd] then
      return
    end

    local sent, err = pcall(terminal.send_to_terminal, "/add-dir " .. cwd)
    if sent then
      granted[cwd] = true
      vim.notify("📂 Claude can now read " .. vim.fn.fnamemodify(cwd, ":~"), vim.log.levels.INFO)
    else
      vim.notify("❌ Could not widen Claude's access: " .. tostring(err), vim.log.levels.ERROR)
    end
    return
  end

  local started, err = pcall(terminal.ensure_visible)
  if not started then
    vim.notify("❌ Claude autostart failed: " .. tostring(err), vim.log.levels.ERROR)
    return
  end

  granted = { [cwd] = true }
end

-- Choosing a project is the real trigger, and the pickers call this directly.
-- DirChanged cannot stand in for it: re-selecting the project you are already in
-- changes nothing and fires no event.
vim.api.nvim_create_user_command("ClaudeAutostart", autostart, {
  desc = "Start Claude for the current project, or widen the running session to it",
})

-- Still worth watching, to cover a cd made outside the pickers.
vim.api.nvim_create_autocmd("DirChanged", {
  callback = function()
    if vim.v.vim_did_enter == 0 then
      return
    end
    autostart()
  end,
})
