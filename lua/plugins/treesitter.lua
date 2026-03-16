require("nvim-treesitter.configs").setup({
  ensure_installed = {
    "markdown",
    "markdown_inline",
    "lua",
    "vim",
    "vimdoc",
    "query",
  },
  highlight = {
    enable = true,
  },
})
