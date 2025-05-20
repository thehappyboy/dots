return {
  -- lua with lazy.nvim
  {
    'max397574/better-escape.nvim',
    event = 'VeryLazy',
    config = function()
      require('better_escape').setup()
    end,
  },

  {
    'linux-cultist/venv-selector.nvim',
    enabled = function()
      return LazyVim.has('telescope.nvim') or LazyVim.has('fzf-lua')
    end,
  },
}
