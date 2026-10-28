-- Overrides for lazyvim.plugins.extras.lang.markdown.
-- The extra already provides conform formatters (markdown-toc / markdownlint-cli2),
-- mason tools, nvim-lint, marksman, render-markdown and its <leader>um toggle.
return {
  -- drop iamcco/markdown-preview.nvim in favour of mdkite
  { "iamcco/markdown-preview.nvim", enabled = false },

  {
    "selimacerbas/mdkite.nvim",
    dependencies = { "selimacerbas/kitehost.nvim" },
    cmd = { "MdKite" },
    keys = {
      { "<leader>cp", ft = "markdown", "<cmd>MdKite<cr>", desc = "Markdown Preview" },
    },
    config = function()
      require("mdkite").setup({
        instance_mode = "takeover", -- "takeover" (one tab) or "multi" (tab per instance)
        port = 0, -- 0 = auto (8421 for takeover, OS-assigned for multi)
        open_browser = true,
        default_theme = "light", -- "dark" or "light"; initial preview theme
        custom_css = "~/.config/nvim/mdkite.css", -- Paper palette, layered over bundled styles
        debounce_ms = 300,
      })
    end,
  },

  -- edit enhanced
  {
    "yousefhadder/markdown-plus.nvim",
    ft = "markdown",
    opts = {},
  },

  -- point lint and format at the rules file in the config dir
  {
    "mfussenegger/nvim-lint",
    optional = true,
    opts = {
      linters = {
        ["markdownlint-cli2"] = {
          prepend_args = { "--config", vim.fn.stdpath("config") .. "/markdownlint.jsonc" },
        },
      },
    },
  },

  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters = {
        ["markdownlint-cli2"] = {
          prepend_args = { "--config", vim.fn.stdpath("config") .. "/markdownlint.jsonc" },
        },
      },
    },
  },
}
