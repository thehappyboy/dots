return {
  -- Better increase/descrease
  {
    'monaqa/dial.nvim',
    -- stylua: ignore
    keys = {
      { "<C-a>", function() return require("dial.map").inc_normal() end, expr = true, desc = "Increment" },
      { "<C-x>", function() return require("dial.map").dec_normal() end, expr = true, desc = "Decrement" },
    },
    config = function()
      local augend = require('dial.augend')
      require('dial.config').augends:register_group({
        default = {
          augend.integer.alias.decimal,
          augend.integer.alias.hex,
          augend.date.alias['%Y/%m/%d'],
          augend.constant.alias.bool,
          augend.semver.alias.semver,
          augend.constant.new({ elements = { 'let', 'const' } }),
        },
      })
    end,
  },

  -- Incremental rename
  {
    'smjonas/inc-rename.nvim',
    cmd = 'IncRename',
    config = true,
  },

  {
    'hrsh7th/nvim-cmp',
    opts = {
      window = {
        completion = require('cmp.config.window').bordered(),
        documentation = require('cmp.config.window').bordered(),
      },
      duplicates = {
        buffer = 1,
        path = 1,
        nvim_lsp = 0,
        luasnip = 1,
      },
    },
  },

  { 'rafamadriz/friendly-snippets', enabled = false },
  {
    'L3MON4D3/LuaSnip',
    config = function(_, opts)
      local ls = require('luasnip')
      ls.setup(opts)
      require('luasnip.loaders.from_vscode').lazy_load({ paths = { './my_snippets' } })
      -- ls.filetype_extend('htmldjango', { 'html' })
    end,
  },
}
