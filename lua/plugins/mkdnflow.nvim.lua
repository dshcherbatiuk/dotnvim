local ok, mkdnflow = pcall(require, "mkdnflow")
if not ok then
  return
end

mkdnflow.setup({
  modules = {
    bib = false,
    buffers = true,
    conceal = true,
    cursor = true,
    folds = true,
    foldtext = true,
    links = true,
    lists = true,
    maps = true,
    paths = true,
    tables = true,
    yaml = false,
  },
  -- Org-mode-like folding
  folds = {
    rmd_style = true,
  },
  -- Link concealing (like org-mode)
  conceal = {
    enabled = true,
  },
  -- TODO/checkbox cycling
  to_do = {
    symbols = { " ", "-", "x" },
    update_parents = true,
    not_started = " ",
    in_progress = "-",
    complete = "x",
  },
  -- Follow links in current window
  links = {
    style = "markdown",
    conceal = true,
    transform_explicit = false,
  },
  -- Table formatting
  tables = {
    trim_whitespace = true,
    format_on_move = true,
    auto_extend_rows = true,
    auto_extend_cols = true,
  },
  mappings = {
    MkdnEnter = { { "n", "v" }, "<CR>" },
    MkdnTab = { "i", "<Tab>" },
    MkdnSTab = { "i", "<S-Tab>" },
    MkdnNextLink = { "n", "<Tab>" },
    MkdnPrevLink = { "n", "<S-Tab>" },
    MkdnNextHeading = { "n", "]]" },
    MkdnPrevHeading = { "n", "[[" },
    MkdnGoBack = { "n", "<BS>" },
    MkdnGoForward = false,
    MkdnCreateLink = false,
    MkdnCreateLinkFromClipboard = false,
    MkdnDestroyLink = false,
    MkdnMoveSource = false,
    MkdnYankAnchorLink = false,
    MkdnYankFileAnchorLink = false,
    MkdnIncreaseHeading = { "n", "+" },
    MkdnDecreaseHeading = { "n", "=" },
    MkdnToggleToDo = { { "n", "v" }, "<C-Space>" },
    MkdnNewListItem = false,
    MkdnNewListItemBelowInsert = { "n", "o" },
    MkdnNewListItemAboveInsert = { "n", "O" },
    MkdnExtendList = false,
    MkdnUpdateNumbering = { "n", "<leader>nn" },
    MkdnTableNextCell = { "i", "<Tab>" },
    MkdnTablePrevCell = { "i", "<S-Tab>" },
    MkdnTableNextRow = false,
    MkdnTablePrevRow = { "i", "<M-CR>" },
    MkdnTableNewRowBelow = { "n", "<leader>ir" },
    MkdnTableNewRowAbove = { "n", "<leader>iR" },
    MkdnTableNewColAfter = { "n", "<leader>ic" },
    MkdnTableNewColBefore = { "n", "<leader>iC" },
    MkdnFoldSection = { "n", "<leader>mf" },
    MkdnUnfoldSection = { "n", "<leader>mu" },
  },
})
