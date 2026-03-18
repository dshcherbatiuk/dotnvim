require("nvim-treesitter.configs").setup({
  ensure_installed = {
    "markdown",
    "markdown_inline",
    "lua",
    "vim",
    "vimdoc",
    "query",
    "java",
    "rust",
    "toml",
    "groovy",
    "make",
    "bash",
    "dockerfile",
    "xml",
    "yaml",
    "json",
  },
  highlight = {
    enable = true,
  },
})
