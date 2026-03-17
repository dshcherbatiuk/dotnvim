local ok, project = pcall(require, "project_nvim")
if not ok then
  return
end

project.setup({
  -- Detection methods: look for these markers to find project root
  detection_methods = { "pattern", "lsp" },

  patterns = { ".git" },

  -- Don't change cwd automatically on BufEnter, only when opening a project
  silent_chdir = true,

  -- Scope: change cwd for the whole tab
  scope_chdir = "tab",

  -- Where to look for projects
  datapath = vim.fn.stdpath("data"),
})

-- Integrate with Telescope — SPC p p shows recent projects
local ok_telescope, telescope = pcall(require, "telescope")
if ok_telescope then
  telescope.load_extension("projects")
end

-- Custom project picker that opens Oil (directory view) on selection
_G.open_project = function()
  local pickers = require("telescope.pickers")
  local finders = require("telescope.finders")
  local conf = require("telescope.config").values
  local actions = require("telescope.actions")
  local action_state = require("telescope.actions.state")

  local history = require("project_nvim.utils.history")
  local results = history.get_recent_projects()

  pickers.new({}, {
    prompt_title = "Projects",
    finder = finders.new_table({
      results = results,
      entry_maker = function(entry)
        local name = vim.fn.fnamemodify(entry, ":t")
        return {
          value = entry,
          display = name .. "  " .. entry:gsub(vim.fn.expand("$HOME"), "~"),
          ordinal = entry,
        }
      end,
    }),
    sorter = conf.generic_sorter({}),
    attach_mappings = function(prompt_bufnr)
      actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        local selection = action_state.get_selected_entry()
        if selection then
          vim.cmd("cd " .. selection.value)
          vim.cmd("Oil " .. selection.value)
        end
      end)
      return true
    end,
  }):find()
end
