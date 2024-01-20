local border = 'rounded'
local handlers = {
  ['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, { border = border }),
  ['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = border }),
}

return {
  'neovim/nvim-lspconfig',
  opts = {
    inlay_hints = {
      enabled = true,
    },
    servers = {
      lua_ls = {
        settings = {
          Lua = {
            hint = {
              enable = true,
              arrayIndex = 'Enable',
            },
          },
        },
      },
      ruff_lsp = {
        init_options = {
          settings = {
            args = {
              'line-length=120',
            },
          },
        },
      },
    },
    setup = {
      ['*'] = function(server, opts)
        require('lspconfig')[server].setup({ handlers = handlers })
      end,
    },
  },
}
