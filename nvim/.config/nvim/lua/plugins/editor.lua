return {
  -- lua with lazy.nvim
  {
    'max397574/better-escape.nvim',
    event = 'VeryLazy',
    config = function()
      require('better_escape').setup()
    end,
  },
}
