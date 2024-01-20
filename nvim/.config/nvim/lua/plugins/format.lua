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
        ['javascript'] = { 'prettier' },
        ['javascriptreact'] = { 'prettier' },
        ['typescript'] = { 'prettier' },
        ['typescriptreact'] = { 'prettier' },
        ['vue'] = { 'prettier' },
        ['css'] = { 'prettier' },
        ['scss'] = { 'prettier' },
        ['less'] = { 'prettier' },
        ['html'] = { 'prettier' },
        ['json'] = { 'prettier' },
        ['jsonc'] = { 'prettier' },
        ['yaml'] = { 'prettier' },
        ['markdown'] = { 'prettier' },
        ['markdown.mdx'] = { 'prettier' },
        ['graphql'] = { 'prettier' },
        ['handlebars'] = { 'prettier' },
      },
      formatters = {
        black = {
          prepend_args = { '-l', '120', '-S' },
        },
      },
    },
  },
}
