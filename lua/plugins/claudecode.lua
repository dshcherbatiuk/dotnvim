-- claudecode.nvim: exposes Neovim to the Claude Code CLI as an MCP server over
-- WebSocket, so proposed edits arrive as reviewable diffs instead of landing on
-- disk. Keymaps live in which-key.lua with the other leader mappings.

local ok, claudecode = pcall(require, "claudecode")
if not ok then
  return
end

-- The native provider avoids pulling in snacks.nvim, which upstream lists as a
-- dependency but only uses to host the terminal window.
claudecode.setup({
  terminal = {
    provider = "native",
  },
})
