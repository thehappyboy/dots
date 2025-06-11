local function has(plugin)
  local plugins = require('lazy.core.config').spec.plugins
  return plugins[plugin] ~= nil
end

return {
  {
    'linux-cultist/venv-selector.nvim',
    enabled = function()
      -- cond = function()
      return has('fzf-lua') or has('telescope.nvim')
    end,
  },

  {
    'max397574/better-escape.nvim',
    config = function()
      require('better_escape').setup()
    end,
  },
}
