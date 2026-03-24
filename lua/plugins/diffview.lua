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
    diff3 = {
      { "n", "<leader>1", actions.diffget("ours"), { desc = "Accept left (ours)" } },
      { "n", "<leader>3", actions.diffget("theirs"), { desc = "Accept right (theirs)" } },
      { "n", "<leader>2", actions.diffget("base"), { desc = "Accept base" } },
      { "n", "]x", actions.next_conflict, { desc = "Next conflict" } },
      { "n", "[x", actions.prev_conflict, { desc = "Prev conflict" } },
    },
    diff2 = {
      { "n", "]x", actions.next_conflict, { desc = "Next conflict" } },
      { "n", "[x", actions.prev_conflict, { desc = "Prev conflict" } },
    },
  },
  view = {
    default = {
      layout = "diff2_horizontal",
    },
    merge_tool = {
      layout = "diff3_horizontal",
      disable_diagnostics = true,
      winbar_info = true,
    },
    file_history = {
      layout = "diff2_horizontal",
    },
  },
  file_panel = {
    listing_style = "tree",
    tree_options = {
      flatten_dirs = true,
      folder_statuses = "only_folded",
    },
    win_config = {
      position = "left",
      width = 30,
    },
  },
  signs = {
    fold_closed = "",
    fold_open = "",
    done = "✓",
  },
  file_history_panel = {
    win_config = {
      height = 12,
    },
  },
})

local status_icons = {
  A = { icon = " ", hl = "DiffAdd" },
  M = { icon = " ", hl = "DiffChange" },
  D = { icon = " ", hl = "DiffDelete" },
  R = { icon = " ", hl = "DiffChange" },
  C = { icon = " ", hl = "DiffChange" },
  U = { icon = " ", hl = "DiffText" },
  ["?"] = { icon = " ", hl = "Comment" },
}

-- Telescope picker for conflict files (like JetBrains Conflicts dialog)
_G.telescope_conflicts = function()
  local pickers = require("telescope.pickers")
  local finders = require("telescope.finders")
  local conf = require("telescope.config").values
  local tele_actions = require("telescope.actions")
  local action_state = require("telescope.actions.state")
  local entry_display = require("telescope.pickers.entry_display")

  -- Get conflict files with status from git
  local raw = vim.fn.systemlist("git diff --name-status --diff-filter=U")
  if #raw == 0 then
    vim.notify("No conflicts found", vim.log.levels.INFO)
    return
  end

  local entries = {}
  for _, line in ipairs(raw) do
    local status, file = line:match("^(%S+)%s+(.+)$")
    if status and file then
      table.insert(entries, { status = status:sub(1, 1), file = file })
    end
  end

  local displayer = entry_display.create({
    separator = " ",
    items = {
      { width = 2 },
      { remaining = true },
    },
  })

  pickers.new({}, {
    prompt_title = "Conflicts",
    finder = finders.new_table({
      results = entries,
      entry_maker = function(entry)
        local si = status_icons[entry.status] or status_icons["?"]
        return {
          value = entry.file,
          ordinal = entry.file,
          display = function(e)
            return displayer({
              { si.icon, si.hl },
              e.value,
            })
          end,
        }
      end,
    }),
    sorter = conf.generic_sorter({}),
    previewer = conf.file_previewer({}),
    attach_mappings = function(prompt_bufnr, map)
      -- Enter: open in merge tool (no file panel)
      tele_actions.select_default:replace(function()
        tele_actions.close(prompt_bufnr)
        local selection = action_state.get_selected_entry()
        if selection then
          vim.cmd("DiffviewOpen -- " .. selection.value)
        end
      end)
      -- Ctrl+a: accept ours for entire file
      map("i", "<C-a>", function()
        local selection = action_state.get_selected_entry()
        if selection then
          vim.fn.system("git checkout --ours " .. selection.value)
          vim.fn.system("git add " .. selection.value)
          vim.notify("✅ Accepted ours: " .. selection.value, vim.log.levels.INFO)
        end
      end)
      -- Ctrl+t: accept theirs for entire file
      map("i", "<C-t>", function()
        local selection = action_state.get_selected_entry()
        if selection then
          vim.fn.system("git checkout --theirs " .. selection.value)
          vim.fn.system("git add " .. selection.value)
          vim.notify("✅ Accepted theirs: " .. selection.value, vim.log.levels.INFO)
        end
      end)
      return true
    end,
  }):find()
end
