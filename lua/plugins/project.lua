local ok, project = pcall(require, "project_nvim")
if not ok then
  return
end

project.setup({
  -- Detection methods: look for these markers to find project root
  detection_methods = { "pattern", "lsp" },

  -- Project root markers (order matters — first match wins)
  patterns = {
    ".git",
    "pom.xml",
    "build.gradle",
    "build.gradle.kts",
    "Cargo.toml",
    "package.json",
    "Makefile",
    "mix.exs",
    "pyproject.toml",
    "setup.py",
    "go.mod",
  },

  -- Don't change cwd automatically on BufEnter, only when opening a project
  silent_chdir = true,

  -- Scope: change cwd for the whole tab
  scope_chdir = "tab",

  -- Where to look for projects
  datapath = vim.fn.stdpath("data"),
})

-- Integrate with Telescope — SPC p p shows recent projects
local ok_telescope, telescope = pcall(require, "telescope")
if ok_telescope then
  telescope.load_extension("projects")
end
