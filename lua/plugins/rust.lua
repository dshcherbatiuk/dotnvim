-- Rust: rust-analyzer LSP with extended settings
-- Separate file following single-responsibility principle

local ok_lsp, lspconfig = pcall(require, "lspconfig")
if not ok_lsp then
  return
end

if vim.fn.executable("rust-analyzer") ~= 1 then
  return
end

local ok_cmp, cmp_lsp = pcall(require, "cmp_nvim_lsp")
local capabilities = vim.lsp.protocol.make_client_capabilities()
if ok_cmp then
  capabilities = cmp_lsp.default_capabilities(capabilities)
end

-- DAP: codelldb debug adapter for Rust
local ok_dap, dap = pcall(require, "dap")
if ok_dap then
  local codelldb_dir = vim.fn.expand("~/.local/share/nvim/codelldb/extension/adapter")
  local codelldb_path = codelldb_dir .. "/codelldb"
  local liblldb_path = codelldb_dir .. "/liblldb.dylib"

  if vim.fn.filereadable(codelldb_path) == 1 then
    dap.adapters.codelldb = {
      type = "server",
      port = "${port}",
      executable = {
        command = codelldb_path,
        args = { "--port", "${port}" },
      },
    }

    dap.configurations.rust = {
      {
        name = "Launch",
        type = "codelldb",
        request = "launch",
        program = function()
          return vim.fn.input("Executable: ", vim.fn.getcwd() .. "/target/debug/", "file")
        end,
        cwd = "${workspaceFolder}",
        stopOnEntry = false,
      },
      {
        name = "Launch (cargo build first)",
        type = "codelldb",
        request = "launch",
        preLaunchTask = "cargo build",
        program = function()
          return vim.fn.input("Executable: ", vim.fn.getcwd() .. "/target/debug/", "file")
        end,
        cwd = "${workspaceFolder}",
        stopOnEntry = false,
      },
    }
  end
end

lspconfig.rust_analyzer.setup({
  capabilities = capabilities,
  on_attach = function(_, bufnr)
    -- Standard LSP keybindings
    if _G.lsp_on_attach then
      _G.lsp_on_attach(_, bufnr)
    end

    -- Rust localleader keybindings (, prefix)
    vim.keymap.set("n", ",r", "<cmd>!cargo run<cr>",
      { buffer = bufnr, desc = "Cargo run" })
    vim.keymap.set("n", ",b", "<cmd>!cargo build<cr>",
      { buffer = bufnr, desc = "Cargo build" })
    vim.keymap.set("n", ",t", "<cmd>!cargo test<cr>",
      { buffer = bufnr, desc = "Cargo test" })
    vim.keymap.set("n", ",c", "<cmd>!cargo clippy<cr>",
      { buffer = bufnr, desc = "Cargo clippy" })
    vim.keymap.set("n", ",f", function()
      vim.lsp.buf.format({ async = true })
    end, { buffer = bufnr, desc = "Format" })
    vim.keymap.set("n", ",e", function()
      vim.lsp.buf.code_action({ context = { only = { "quickfix" } } })
    end, { buffer = bufnr, desc = "Quick fix" })
    vim.keymap.set("n", ",d", "<cmd>!cargo doc --open<cr>",
      { buffer = bufnr, desc = "Open docs" })
    vim.keymap.set("n", ",w", "<cmd>!cargo watch -x check<cr>",
      { buffer = bufnr, desc = "Cargo watch" })

    -- Format on save
    vim.api.nvim_create_autocmd("BufWritePre", {
      buffer = bufnr,
      callback = function()
        vim.lsp.buf.format({ async = false })
      end,
    })
  end,
  settings = {
    ["rust-analyzer"] = {
      checkOnSave = {
        command = "clippy",
      },
      cargo = {
        allFeatures = true,
        loadOutDirsFromCheck = true,
      },
      procMacro = {
        enable = true,
      },
      inlayHints = {
        lifetimeElisionHints = { enable = "always" },
        typeHints = { enable = true },
        parameterHints = { enable = true },
      },
    },
  },
})
