-- Gradle: syntax highlighting + build keybindings
-- Handles .gradle (Groovy) files

-- Detect gradle files as groovy
vim.filetype.add({
  extension = {
    gradle = "groovy",
  },
})

-- Localleader keybindings for Gradle files
vim.api.nvim_create_autocmd("FileType", {
  pattern = "groovy",
  callback = function(args)
    local opts = { buffer = args.buf }

    vim.keymap.set("n", ",b", "<cmd>!./gradlew build<cr>", vim.tbl_extend("force", opts, { desc = "Gradle build" }))
    vim.keymap.set("n", ",t", "<cmd>!./gradlew test<cr>", vim.tbl_extend("force", opts, { desc = "Gradle test" }))
    vim.keymap.set("n", ",c", "<cmd>!./gradlew clean<cr>", vim.tbl_extend("force", opts, { desc = "Gradle clean" }))
    vim.keymap.set("n", ",r", "<cmd>!./gradlew run<cr>", vim.tbl_extend("force", opts, { desc = "Gradle run" }))
    vim.keymap.set("n", ",d", "<cmd>!./gradlew dependencies<cr>", vim.tbl_extend("force", opts, { desc = "Gradle dependencies" }))
    vim.keymap.set("n", ",T", "<cmd>!./gradlew tasks<cr>", vim.tbl_extend("force", opts, { desc = "Gradle tasks" }))
  end,
})
