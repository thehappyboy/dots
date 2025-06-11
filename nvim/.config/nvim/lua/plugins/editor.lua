return {
  {
    'linux-cultist/venv-selector.nvim',
    enabled = function()
      return LazyVim.has('telescope.nvim') or LazyVim.has('fzf-lua')
    end,
  },

  {
    'max397574/better-escape.nvim',
    config = function()
      require('better_escape').setup()
    end,
  },
}
