local config_path = vim.fn.stdpath("config") .. "/markdownlint.jsonc"

return {
  -- nvim-lint: 诊断源头
  {
    "mfussenegger/nvim-lint",
    opts = function(_, opts)
      opts.linters = opts.linters or {}
      opts.linters["markdownlint-cli2"] = {
        prepend_args = { "--config", config_path },
      }
    end,
  },

  -- conform.nvim: 格式化源头
  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      opts.formatters = opts.formatters or {}
      opts.formatters["markdownlint-cli2"] = {
        prepend_args = { "--config", config_path },
      }
    end,
  },
}
