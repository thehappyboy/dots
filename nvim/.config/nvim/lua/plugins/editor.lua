return {
  {
    'max397574/better-escape.nvim',
    event = 'InsertEnter',
    config = true,
  },

  {
    'Bekaboo/dropbar.nvim',
    event = 'UIEnter',
  },

  {
    'Wansmer/treesj',
    keys = {
      { 'J', '<cmd>TSJToggle<cr>', desc = 'Join Toggle' },
    },
    opts = { use_default_keymaps = false, max_join_length = 150 },
  },

  {
    'smoka7/multicursors.nvim',
    event = 'VeryLazy',
    dependencies = 'smoka7/hydra.nvim',
    opts = {},
    cmd = { 'MCstart', 'MCvisual', 'MCclear', 'MCpattern', 'MCvisualPattern', 'MCunderCursor' },
    keys = {
      mode = { 'v', 'n' },
      '<leader>m',
      '<cmd>MCstart<cr>',
      desc = 'Multicursor',
    },
  },
}
