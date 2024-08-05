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
      basedpyright = {
        settings = {
          basedpyright = {
            analysis = {
              diagnosticSeverityOverrides = {
                reportImplicitOverride = false,
                reportUnknownVariableType = false,
                -- reportMissingParameterType = false,
                reportUnknownParameterType = false,
                reportUnkownVariableType = false,
              },
            },
          },
        },
      },
    },
    setup = {
      ['*'] = function(server, _)
        require('lspconfig')[server].setup({ handlers = handlers })
      end,
    },
  },
}
