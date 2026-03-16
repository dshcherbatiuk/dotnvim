-- nvim-jdtls: Java LSP with extended capabilities
-- Auto-starts jdtls when opening Java files

local ok, jdtls = pcall(require, "jdtls")
if not ok then
  return
end

local function setup_jdtls()
  local ok_cmp, cmp_lsp = pcall(require, "cmp_nvim_lsp")
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  if ok_cmp then
    capabilities = cmp_lsp.default_capabilities(capabilities)
  end

  -- Find project root
  local root_markers = { "pom.xml", "build.gradle", "build.gradle.kts", ".git", "mvnw", "gradlew" }
  local root_dir = require("jdtls.setup").find_root(root_markers)
  if not root_dir then
    root_dir = vim.fn.getcwd()
  end

  -- Workspace dir per project
  local project_name = vim.fn.fnamemodify(root_dir, ":p:h:t")
  local workspace_dir = vim.fn.stdpath("cache") .. "/jdtls-workspace/" .. project_name

  -- Find jdtls install location
  local jdtls_path = vim.fn.exepath("jdtls")
  if jdtls_path == "" then
    vim.notify("jdtls not found. Run: make java", vim.log.levels.ERROR)
    return
  end

  local config = {
    cmd = { "jdtls", "-data", workspace_dir },
    root_dir = root_dir,
    capabilities = capabilities,

    settings = {
      java = {
        signatureHelp = { enabled = true },
        contentProvider = { preferred = "fernflower" },
        completion = {
          favoriteStaticMembers = {
            "org.junit.Assert.*",
            "org.junit.jupiter.api.Assertions.*",
            "org.mockito.Mockito.*",
            "java.util.Objects.requireNonNull",
            "java.util.Objects.requireNonNullElse",
          },
          filteredTypes = {
            "com.sun.*",
            "io.micrometer.shaded.*",
            "java.awt.*",
            "jdk.*",
            "sun.*",
          },
        },
        sources = {
          organizeImports = {
            starThreshold = 9999,
            staticStarThreshold = 9999,
          },
        },
        configuration = {
          updateBuildConfiguration = "interactive",
        },
        maven = {
          downloadSources = true,
        },
        implementationsCodeLens = { enabled = true },
        referencesCodeLens = { enabled = true },
        format = { enabled = true },
      },
    },

    on_attach = function(_, bufnr)
      local opts = { buffer = bufnr }

      -- Standard LSP keybindings
      vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
      vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
      vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
      vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, opts)
      vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
      vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)

      -- IntelliJ-style keybindings
      vim.keymap.set("n", "<S-F6>", vim.lsp.buf.rename, opts)
      vim.keymap.set("n", "<M-CR>", vim.lsp.buf.code_action, opts)
      vim.keymap.set("n", "<C-S-n>", "<cmd>Telescope find_files<cr>", opts)
      vim.keymap.set("n", "<C-S-f>", "<cmd>Telescope live_grep<cr>", opts)
      vim.keymap.set("n", "<F12>", vim.lsp.buf.definition, opts)
      vim.keymap.set("n", "<C-F12>", vim.lsp.buf.type_definition, opts)
      vim.keymap.set("n", "<M-F7>", vim.lsp.buf.references, opts)
      vim.keymap.set("n", "<C-q>", vim.lsp.buf.hover, opts)

      -- Java-specific localleader keybindings (, prefix)
      vim.keymap.set("n", ",o", function() jdtls.organize_imports() end,
        { buffer = bufnr, desc = "Organize imports" })
      vim.keymap.set("n", ",ev", function() jdtls.extract_variable() end,
        { buffer = bufnr, desc = "Extract variable" })
      vim.keymap.set("v", ",ev", function() jdtls.extract_variable(true) end,
        { buffer = bufnr, desc = "Extract variable" })
      vim.keymap.set("n", ",ec", function() jdtls.extract_constant() end,
        { buffer = bufnr, desc = "Extract constant" })
      vim.keymap.set("v", ",ec", function() jdtls.extract_constant(true) end,
        { buffer = bufnr, desc = "Extract constant" })
      vim.keymap.set("v", ",em", function() jdtls.extract_method(true) end,
        { buffer = bufnr, desc = "Extract method" })
      vim.keymap.set("n", ",t", function() jdtls.test_nearest_method() end,
        { buffer = bufnr, desc = "Test method" })
      vim.keymap.set("n", ",T", function() jdtls.test_class() end,
        { buffer = bufnr, desc = "Test class" })

      -- Format on save
      vim.api.nvim_create_autocmd("BufWritePre", {
        buffer = bufnr,
        callback = function()
          vim.lsp.buf.format({ async = false })
        end,
      })
    end,
  }

  jdtls.start_or_attach(config)
end

-- Auto-start jdtls for Java files
vim.api.nvim_create_autocmd("FileType", {
  pattern = "java",
  callback = setup_jdtls,
})
