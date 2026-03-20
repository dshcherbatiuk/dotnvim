local ok, cmp = pcall(require, "cmp")
if not ok then
  return
end

-- Darker background for completion popups
vim.api.nvim_set_hl(0, "CmpNormal", { bg = "#1a1a2e" })
vim.api.nvim_set_hl(0, "CmpDocNormal", { bg = "#1a1a2e" })
vim.api.nvim_set_hl(0, "CmpBorder", { fg = "#51afef", bg = "#1a1a2e" })

local kind_icons = {
  Text = "󰉿", Method = "󰆧", Function = "󰊕", Constructor = "",
  Field = "󰜢", Variable = "󰀫", Class = "󰠱", Interface = "",
  Module = "", Property = "󰜢", Unit = "󰑭", Value = "󰎠",
  Enum = "", Keyword = "󰌋", Snippet = "", Color = "󰏘",
  File = "󰈙", Reference = "󰈇", Folder = "󰉋", EnumMember = "",
  Constant = "󰏿", Struct = "󰙅", Event = "", Operator = "󰆕",
  TypeParameter = "",
}

cmp.setup({
  snippet = {
    expand = function(args)
      vim.snippet.expand(args.body)
    end,
  },
  window = {
    completion = cmp.config.window.bordered({
      winhighlight = "Normal:CmpNormal,FloatBorder:CmpBorder,CursorLine:PmenuSel",
    }),
    documentation = cmp.config.window.bordered({
      winhighlight = "Normal:CmpDocNormal,FloatBorder:CmpBorder",
      max_width = 60,
      max_height = 20,
    }),
  },
  mapping = cmp.mapping.preset.insert({
    ["<C-n>"] = cmp.mapping.select_next_item(),
    ["<C-p>"] = cmp.mapping.select_prev_item(),
    ["<C-d>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-e>"] = cmp.mapping.abort(),
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      else
        fallback()
      end
    end, { "i", "s" }),
    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      else
        fallback()
      end
    end, { "i", "s" }),
  }),
  sources = cmp.config.sources({
    { name = "nvim_lsp" },
  }, {
    { name = "buffer" },
    { name = "path" },
  }),
  formatting = {
    fields = { "abbr", "kind", "menu" },
    format = function(entry, vim_item)
      vim_item.kind = string.format("%s %s", kind_icons[vim_item.kind] or "", vim_item.kind)
      local source_names = {
        nvim_lsp = "[LSP]",
        buffer = "[Buf]",
        path = "[Path]",
      }
      vim_item.menu = source_names[entry.source.name] or ""
      vim_item.abbr = string.sub(vim_item.abbr, 1, 50)
      return vim_item
    end,
  },
})
