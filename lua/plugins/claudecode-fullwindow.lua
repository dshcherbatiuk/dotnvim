-- Full-window terminal provider for claudecode.nvim.
--
-- The bundled providers put Claude in a side split. This one makes it an
-- ordinary buffer filling the current window, Doom-style: switch away with any
-- buffer command and the process keeps running.
--
-- Implements the provider contract claudecode.terminal validates against:
-- setup, open, close, simple_toggle, focus_toggle, get_active_bufnr, is_available.

local M = {}

local utils = require("claudecode.utils")

local bufnr = nil
local jobid = nil
local prev_bufnr = nil
local config = {}

local function reset()
  bufnr = nil
  jobid = nil
end

local function buf_valid()
  return bufnr ~= nil and vim.api.nvim_buf_is_valid(bufnr)
end

---@return integer|nil winid A window currently displaying the terminal, if any
local function terminal_win()
  if not buf_valid() then
    return nil
  end
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    if vim.api.nvim_win_get_buf(win) == bufnr then
      return win
    end
  end
  return nil
end

local function start_insert(effective_config)
  if (effective_config or config).auto_insert ~= false then
    vim.cmd("startinsert")
  end
end

---Display the terminal buffer in the current window, remembering what it replaced.
local function show(effective_config)
  local current = vim.api.nvim_get_current_buf()
  if current ~= bufnr then
    prev_bufnr = current
  end
  vim.api.nvim_win_set_buf(0, bufnr)
  start_insert(effective_config)
end

---Swap the window showing the terminal back to whatever it replaced. The buffer
---and job survive, which is what makes switching away non-destructive.
local function hide()
  local win = terminal_win()
  if not win then
    return
  end

  local target = prev_bufnr
  if not (target and vim.api.nvim_buf_is_valid(target) and target ~= bufnr) then
    target = vim.fn.bufnr("#")
  end

  if target and target > 0 and target ~= bufnr and vim.api.nvim_buf_is_valid(target) then
    vim.api.nvim_win_set_buf(win, target)
  else
    vim.api.nvim_win_call(win, function()
      vim.cmd("enew")
    end)
  end
end

---@param focus boolean When false the terminal is spawned but the window is
---handed straight back, so an auto-start never steals what the user is looking at.
local function create(cmd_string, env_table, effective_config, focus)
  local origin_buf = vim.api.nvim_get_current_buf()
  local origin_win = vim.api.nvim_get_current_win()
  prev_bufnr = origin_buf

  local function restore_origin()
    if vim.api.nvim_win_is_valid(origin_win) and vim.api.nvim_buf_is_valid(origin_buf) then
      vim.api.nvim_win_set_buf(origin_win, origin_buf)
    end
  end

  -- Not `enew`: that reuses the current buffer when it is empty and unnamed, so
  -- the terminal would inherit its options — including buflisted=false from the
  -- alpha dashboard, which hides it from the buffer picker.
  local term_buf = vim.api.nvim_create_buf(true, false)
  vim.api.nvim_win_set_buf(origin_win, term_buf)

  -- parse_command keeps quoted args and bracketed model aliases like opus[1m]
  -- intact; splitting on whitespace here would corrupt them.
  jobid = vim.fn.termopen(utils.parse_command(cmd_string), {
    env = env_table,
    cwd = effective_config.cwd,
    on_exit = function(exited_job_id)
      vim.schedule(function()
        if exited_job_id ~= jobid then
          return
        end
        local finished = bufnr
        reset()
        if effective_config.auto_close == false then
          return
        end
        if finished and vim.api.nvim_buf_is_valid(finished) then
          pcall(vim.api.nvim_buf_delete, finished, { force = true })
        end
      end)
    end,
  })

  if not jobid or jobid == 0 then
    vim.notify("❌ Failed to start Claude terminal", vim.log.levels.ERROR)
    reset()
    restore_origin()
    return false
  end

  bufnr = vim.api.nvim_get_current_buf()
  vim.bo[bufnr].bufhidden = "hide"
  vim.bo[bufnr].buflisted = true

  if focus then
    start_insert(effective_config)
  else
    restore_origin()
  end
  return true
end

---@param term_config table
function M.setup(term_config)
  config = term_config or {}
end

---@param cmd_string string
---@param env_table table
---@param effective_config table
---@param focus boolean?
function M.open(cmd_string, env_table, effective_config, focus)
  focus = utils.normalize_focus(focus)

  if not buf_valid() then
    return create(cmd_string, env_table, effective_config, focus)
  end

  local win = terminal_win()
  if win then
    if focus then
      vim.api.nvim_set_current_win(win)
      start_insert(effective_config)
    end
  elseif focus then
    show(effective_config)
  end
  return true
end

function M.close()
  hide()
  if jobid then
    pcall(vim.fn.jobstop, jobid)
  end
  if buf_valid() then
    pcall(vim.api.nvim_buf_delete, bufnr, { force = true })
  end
  reset()
end

---Show the terminal if hidden, hide it if visible.
function M.simple_toggle(cmd_string, env_table, effective_config)
  if not buf_valid() then
    return create(cmd_string, env_table, effective_config, true)
  end

  if terminal_win() then
    hide()
  else
    show(effective_config)
  end
  return true
end

---Hide only when already focused; otherwise focus or show it.
function M.focus_toggle(cmd_string, env_table, effective_config)
  if not buf_valid() then
    return create(cmd_string, env_table, effective_config, true)
  end

  local win = terminal_win()
  if win and win == vim.api.nvim_get_current_win() then
    hide()
  elseif win then
    vim.api.nvim_set_current_win(win)
    start_insert(effective_config)
  else
    show(effective_config)
  end
  return true
end

---@return integer|nil
function M.get_active_bufnr()
  return buf_valid() and bufnr or nil
end

---@return boolean
function M.is_available()
  return true
end

return M
