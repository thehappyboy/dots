return {
  {
    'williamboman/mason.nvim',
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        'isort',
        'djlint',
      })
    end,
  },
  {
    'stevearc/conform.nvim',
    opts = {
      formatters_by_ft = {
        ['python'] = { 'isort', 'black' },
        ['htmldjango'] = { 'prettier', 'djlint' },
      },
      formatters = {
        black = {
          prepend_args = { '-l', '120', '-S' },
        },
      },
    },
  },
}
