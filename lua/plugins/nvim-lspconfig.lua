local ok_lsp, lspconfig = pcall(require, "lspconfig")
if not ok_lsp then
  return
end

local ok_cmp, cmp_lsp = pcall(require, "cmp_nvim_lsp")
local capabilities = vim.lsp.protocol.make_client_capabilities()
if ok_cmp then
  capabilities = cmp_lsp.default_capabilities(capabilities)
end

-- Shared on_attach for all LSP servers
local on_attach = function(_, bufnr)
  local opts = { buffer = bufnr }
  vim.keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<cr>", opts)
  vim.keymap.set("n", "gr", "<cmd>Telescope lsp_references<cr>", opts)
  vim.keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<cr>", opts)
  vim.keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<cr>", opts)
  vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
  vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
  vim.keymap.set("n", "<S-F6>", vim.lsp.buf.rename, opts)
  vim.keymap.set("n", "<M-CR>", vim.lsp.buf.code_action, opts)
end

-- Store shared config for use by other plugins (e.g. nvim-jdtls)
vim.g._lsp_capabilities = capabilities
vim.g._lsp_on_attach = nil -- functions can't go in vim.g, use global
_G.lsp_on_attach = on_attach
_G.lsp_capabilities = capabilities

-- Diagnostics display
vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  underline = true,
  update_in_insert = false,
  float = { border = "rounded" },
})

-- Servers: { lspconfig_name, binary_name }
-- Java is handled separately by nvim-jdtls
-- Rust is handled separately below
local servers = {
  { "pyright", "pyright-langserver" },
  { "clangd", "clangd" },
  { "bashls", "bash-language-server" },
  { "dockerls", "docker-langserver" },
  { "yamlls", "yaml-language-server" },
  { "jsonls", "vscode-json-language-server" },
}

for _, entry in ipairs(servers) do
  local server, binary = entry[1], entry[2]
  if vim.fn.executable(binary) == 1 then
    lspconfig[server].setup({
      capabilities = capabilities,
      on_attach = on_attach,
    })
  end
end
