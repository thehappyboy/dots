return {

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
        snippets = 1,
      },
    },
  },

  { 'rafamadriz/friendly-snippets', enabled = false },
  -- {
  --   'L3MON4D3/LuaSnip',
  --   config = function(_, opts)
  --     local ls = require('luasnip')
  --     ls.setup(opts)
  --     require('luasnip.loaders.from_vscode').lazy_load({ paths = { './my_snippets' } })
  --     -- ls.filetype_extend('htmldjango', { 'html' })
  --   end,
  -- },

  {
    'garymjr/nvim-snippets',
    opts = {
      -- friendly_snippets = true,
      extended_filetypes = {
        django = { 'python' },
        htmldjango = { 'html' },
      },
    },
    dependencies = { 'rafamadriz/friendly-snippets' },
  },
}
