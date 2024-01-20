local dir = vim.fn.expand('~/obsidian/notes')

return {
  'epwalsh/obsidian.nvim',
  version = '*',
  event = string.format('BufReadPre %s/**.md', dir),
  dependencies = {
    'nvim-lua/plenary.nvim',
  },
  opts = {
    dir = dir,
    daily_notes = {
      date_format = '%Y_%m_%d',
    },
    completion = {
      nvim_cmp = true,
      min_chars = 0,
    },
  },
}
