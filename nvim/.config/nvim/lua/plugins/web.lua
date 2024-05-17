return {
  {
    'ray-x/web-tools.nvim',
    ft = { 'html', 'javascript' },
    cmd = { 'BrowserOpen', 'Npm', 'Yarn', 'Prettier' },
    keys = {
      -- stylua: ignore
      { '<leader>cw', '<cmd>BrowserOpen<cr>', desc = 'Open Browser' },
      -- {'<leader>cy', '<cmd>Yarn<cr>', desc = 'Yarn'},
      -- {'<leader>cp', '<cmd>Prettier<cr>', desc = 'Prettier'},
    },
    config = function()
      require('web-tools').setup({ debug = true })
    end,
  },

  {
    'neovim/nvim-lspconfig',
    opts = {
      servers = {
        html = {},
        cssls = {},
      },
    },
  },
}
