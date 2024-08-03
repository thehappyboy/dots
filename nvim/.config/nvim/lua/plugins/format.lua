return {
  {
    'williamboman/mason.nvim',
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        'black',
        'isort',
        'prettier',
        'djlint',
      })
    end,
  },
  {
    'stevearc/conform.nvim',
    opts = {
      formatters_by_ft = {
        ['python'] = { 'isort', 'black' },
      },
      formatters = {
        black = {
          prepend_args = { '-l', '120', '-S' },
        },
      },
    },
  },
}
