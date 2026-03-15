-- File type icons for neo-tree, lualine, telescope, alpha
-- Set vim.g.have_nerd_font = false in init.lua if your terminal lacks a Nerd Font
if not vim.g.have_nerd_font then
  vim.notify(
    "⚠ vim.g.have_nerd_font is false — icons will be broken.\n"
      .. "Install a Nerd Font: https://www.nerdfonts.com/\n"
      .. "Then set vim.g.have_nerd_font = true in init.lua",
    vim.log.levels.WARN
  )
end

require("nvim-web-devicons").setup({
  default = true,
})
