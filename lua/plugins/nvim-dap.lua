-- DAP: Debug Adapter Protocol base config + UI

local ok_dap, dap = pcall(require, "dap")
if not ok_dap then
  return
end

local ok_ui, dapui = pcall(require, "dapui")
if ok_ui then
  dapui.setup({
    layouts = {
      {
        elements = {
          { id = "scopes", size = 0.4 },
          { id = "breakpoints", size = 0.2 },
          { id = "stacks", size = 0.2 },
          { id = "watches", size = 0.2 },
        },
        position = "left",
        size = 40,
      },
      {
        elements = {
          { id = "repl", size = 0.5 },
          { id = "console", size = 0.5 },
        },
        position = "bottom",
        size = 10,
      },
    },
  })

  -- Auto open/close UI on debug events
  dap.listeners.after.event_initialized["dapui_config"] = function()
    dapui.open()
  end
  dap.listeners.before.event_terminated["dapui_config"] = function()
    dapui.close()
  end
  dap.listeners.before.event_exited["dapui_config"] = function()
    dapui.close()
  end
end

-- Breakpoint signs
vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "DiagnosticError" })
vim.fn.sign_define("DapBreakpointCondition", { text = "", texthl = "DiagnosticWarn" })
vim.fn.sign_define("DapLogPoint", { text = "", texthl = "DiagnosticInfo" })
vim.fn.sign_define("DapStopped", { text = "→", texthl = "DiagnosticOk", linehl = "DapStoppedLine" })
vim.api.nvim_set_hl(0, "DapStoppedLine", { bg = "#304030" })
