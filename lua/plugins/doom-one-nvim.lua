-- Doom One theme — matching Doom Emacs doom-one
vim.g.doom_one_cursor_coloring = true
vim.g.doom_one_terminal_colors = true
vim.g.doom_one_italic_comments = true
vim.g.doom_one_enable_treesitter = true
vim.g.doom_one_transparent_background = false

vim.cmd.colorscheme("doom-one")

-- Absolute line numbers (matching Doom config: display-line-numbers-type t)
vim.opt.number = true
vim.opt.relativenumber = false
