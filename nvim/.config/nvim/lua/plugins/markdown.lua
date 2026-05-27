return {

  -- preview markdown
  {
    "selimacerbas/markdown-preview.nvim",
    dependencies = { "selimacerbas/live-server.nvim" },
    keys = {
      { "<leader>cp", ft = "markdown", "<cmd>MarkdownPreview<cr>", desc = "Markdown Preview" },
    },
    config = function()
      require("markdown_preview").setup({
        -- all optional; sane defaults shown
        instance_mode = "takeover", -- "takeover" (one tab) or "multi" (tab per instance)
        port = 0, -- 0 = auto (8421 for takeover, OS-assigned for multi)
        open_browser = true,
        default_theme = "dark", -- "dark" or "light"; initial preview theme
        debounce_ms = 300,
      })
    end,
  },

  -- render in editor
  {
    "MeanderingProgrammer/render-markdown.nvim",
    opts = {
      code = {
        sign = false,
        width = "block",
        right_pad = 1,
      },
      heading = {
        sign = false,
        icons = {},
      },
      checkbox = {
        enabled = false,
      },
    },
    ft = { "markdown", "norg", "rmd", "org", "codecompanion" },
    config = function(_, opts)
      require("render-markdown").setup(opts)
      Snacks.toggle({
        name = "Render Markdown",
        get = require("render-markdown").get,
        set = require("render-markdown").set,
      }):map("<leader>um")
    end,
  },

  -- edit enhanced
  {
    "yousefhadder/markdown-plus.nvim",
    ft = "markdown",
    opts = {},
  },

  --lint
  {
    "mason-org/mason.nvim",
    opts = { ensure_installed = { "markdownlint-cli2", "markdown-toc" } },
  },

  {
    "mfussenegger/nvim-lint",
    optional = true,
    opts = {
      linters_by_ft = {
        markdown = { "markdownlint-cli2" },
      },
    },
    config = function()
      local linter = require("lint.linters.markdownlint-cli2")
      local config_path = vim.fn.stdpath("config") .. "/markdownlint.jsonc"
      table.insert(linter.args, 1, config_path)
      table.insert(linter.args, 1, "--config")
      require("lint").linters.markdownlint_cli2 = linter
    end,
  },

  -- format
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters = {
        ["markdown-toc"] = {
          condition = function(_, ctx)
            for _, line in ipairs(vim.api.nvim_buf_get_lines(ctx.buf, 0, -1, false)) do
              if line:find("<!%-%- toc %-%->") then
                return true
              end
            end
          end,
        },
        ["markdownlint-cli2"] = {
          condition = function(_, ctx)
            local diag = vim.tbl_filter(function(d)
              return d.source == "markdownlint"
            end, vim.diagnostic.get(ctx.buf))
            return #diag > 0
          end,
          prepend_args = { "--config", vim.fn.stdpath("config") .. "/markdownlint.jsonc" },
        },
      },
      formatters_by_ft = {
        ["markdown"] = { "prettier", "markdownlint-cli2", "markdown-toc" },
        ["markdown.mdx"] = { "prettier", "markdownlint-cli2", "markdown-toc" },
      },
    },
  },
}
