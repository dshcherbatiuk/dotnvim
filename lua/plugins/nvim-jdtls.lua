-- nvim-jdtls: Java LSP with extended capabilities + debugging
-- Auto-starts jdtls when opening Java files

local ok, jdtls = pcall(require, "jdtls")
if not ok then
  return
end

-- Find debug adapter bundles
local function get_debug_bundles()
  local bundles = {}
  local java_debug_jar = vim.fn.glob(
    vim.fn.expand("~/.local/share/nvim/java-debug/com.microsoft.java.debug.plugin/target/com.microsoft.java.debug.plugin-*.jar"),
    true
  )
  if java_debug_jar ~= "" then
    table.insert(bundles, java_debug_jar)
  end

  local java_test_jars = vim.fn.glob(
    vim.fn.expand("~/.local/share/nvim/vscode-java-test/server/*.jar"),
    true, true
  )
  for _, jar in ipairs(java_test_jars or {}) do
    if not vim.endswith(jar, "com.microsoft.java.test.runner-jar-with-dependencies.jar")
      and not vim.endswith(jar, "jacocoagent.jar") then
      table.insert(bundles, jar)
    end
  end

  return bundles
end

local function setup_jdtls()
  local ok_cmp, cmp_lsp = pcall(require, "cmp_nvim_lsp")
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  if ok_cmp then
    capabilities = cmp_lsp.default_capabilities(capabilities)
  end

  -- Find project root: prioritize .git to get the whole repo, not a submodule
  local root_dir = require("jdtls.setup").find_root({ ".git" })
    or require("jdtls.setup").find_root({ "pom.xml", "build.gradle", "build.gradle.kts", "mvnw", "gradlew" })
    or vim.fn.getcwd()

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
    cmd = { "jdtls", "--jvm-arg=-Xmx6g", "--jvm-arg=-XX:+UseG1GC", "-data", workspace_dir },
    root_dir = root_dir,
    capabilities = capabilities,
    init_options = {
      bundles = get_debug_bundles(),
    },

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
          updateBuildConfiguration = "automatic",
          runtimes = (function()
            local runtimes = {}
            local java_home_cmd = "/usr/libexec/java_home"
            for _, ver in ipairs({ { name = "JavaSE-21", version = "21" }, { name = "JavaSE-25", version = "25" } }) do
              local path = vim.fn.system(java_home_cmd .. " -v " .. ver.version .. " 2>/dev/null"):gsub("%s+$", "")
              if vim.v.shell_error == 0 and path ~= "" then
                table.insert(runtimes, {
                  name = ver.name,
                  path = path,
                  default = ver.version == "25",
                })
              end
            end
            return #runtimes > 0 and runtimes or nil
          end)(),
        },
        autobuild = { enabled = true },
        eclipse = {
          downloadSources = true,
        },
        -- Recognize generated sources (Dagger, annotation processors)
        project = {
          referencedLibraries = {
            "lib/**/*.jar",
            "build/libs/**/*.jar",
          },
          sourcePaths = {
            "src/main/java",
            "src/test/java",
            "build/generated/sources/annotationProcessor/java/main",
            "target/generated-sources/annotations",
          },
        },
        maven = {
          downloadSources = true,
        },
        implementationsCodeLens = { enabled = true },
        referencesCodeLens = { enabled = true },
        format = { enabled = true },
        codeGeneration = {
          generateComments = true,
          useBlocks = true,
        },
      },
    },

    on_attach = function(_, bufnr)
      local opts = { buffer = bufnr }

      -- Standard LSP keybindings (via Telescope)
      vim.keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<cr>", opts)
      vim.keymap.set("n", "gr", "<cmd>Telescope lsp_references<cr>", opts)
      vim.keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<cr>", opts)
      vim.keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<cr>", opts)
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

      -- Java localleader keybindings (, prefix)
      -- Import
      vim.keymap.set("n", ",o", function() jdtls.organize_imports() end,
        { buffer = bufnr, desc = "Organize imports" })

      -- Extract / Refactor
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
      vim.keymap.set("n", ",ef", function() jdtls.extract_field() end,
        { buffer = bufnr, desc = "Extract field" })

      -- Generate (Alt+Insert in IntelliJ)
      vim.keymap.set("n", ",gc", function() jdtls.generate_constructors() end,
        { buffer = bufnr, desc = "Generate constructor" })
      vim.keymap.set("n", ",gg", function() jdtls.generate_getters_and_setters() end,
        { buffer = bufnr, desc = "Generate getters/setters" })
      vim.keymap.set("n", ",gt", function() jdtls.generate_to_string() end,
        { buffer = bufnr, desc = "Generate toString()" })
      vim.keymap.set("n", ",ge", function() jdtls.generate_equals_and_hash_code() end,
        { buffer = bufnr, desc = "Generate equals/hashCode" })
      vim.keymap.set("n", ",gd", function() jdtls.generate_delegate_methods() end,
        { buffer = bufnr, desc = "Generate delegate methods" })
      vim.keymap.set("n", ",gi", function() jdtls.super_implementation() end,
        { buffer = bufnr, desc = "Go to super implementation" })

      -- Move
      vim.keymap.set("n", ",mt", function() jdtls.move_type() end,
        { buffer = bufnr, desc = "Move type" })
      vim.keymap.set("n", ",mm", function() jdtls.move_method() end,
        { buffer = bufnr, desc = "Move method" })
      vim.keymap.set("n", ",mf", function() jdtls.move_field() end,
        { buffer = bufnr, desc = "Move field" })

      -- Test
      vim.keymap.set("n", ",t", function() jdtls.test_nearest_method() end,
        { buffer = bufnr, desc = "Test method" })
      vim.keymap.set("n", ",T", function() jdtls.test_class() end,
        { buffer = bufnr, desc = "Test class" })

      -- Tools
      vim.keymap.set("n", ",jp", function() jdtls.javap() end,
        { buffer = bufnr, desc = "Show bytecode" })
      vim.keymap.set("n", ",js", function() jdtls.jshell() end,
        { buffer = bufnr, desc = "Open JShell" })

      -- Setup DAP after jdtls is ready
      jdtls.setup_dap({ hotcodereplace = "auto" })

      -- Java-specific commands
      vim.keymap.set("n", ",R", "<cmd>JdtWipeDataAndRestart<cr>",
        { buffer = bufnr, desc = "Restart jdtls (clean)" })
      vim.keymap.set("n", ",u", "<cmd>JdtUpdateConfig<cr>",
        { buffer = bufnr, desc = "Update project config" })
      vim.keymap.set("n", ",b", "<cmd>!./gradlew build<cr>",
        { buffer = bufnr, desc = "Gradle build" })

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

-- Auto-restart jdtls on crash: clean workspace and retry once
local jdtls_retried = {}

vim.api.nvim_create_autocmd("LspDetach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client and client.name == "jdtls" and client.is_stopped() then
      local root = client.config.root_dir or ""
      local project_name = vim.fn.fnamemodify(root, ":p:h:t")
      local ws = vim.fn.stdpath("cache") .. "/jdtls-workspace/" .. project_name

      if not jdtls_retried[project_name] then
        jdtls_retried[project_name] = true
        vim.notify("🔄 jdtls crashed — cleaning workspace and restarting...", vim.log.levels.WARN)
        vim.fn.delete(ws, "rf")
        vim.defer_fn(setup_jdtls, 2000)
      end
    end
  end,
})

-- Auto-start jdtls for Java files
vim.api.nvim_create_autocmd("FileType", {
  pattern = "java",
  callback = function()
    jdtls_retried = {}
    setup_jdtls()
  end,
})
