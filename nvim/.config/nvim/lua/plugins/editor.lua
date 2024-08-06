return {
  {
    'max397574/better-escape.nvim',
    event = 'InsertEnter',
    config = true,
  },

  {
    'Bekaboo/dropbar.nvim',
    event = 'UIEnter',
  },

  {
    'Wansmer/treesj',
    keys = {
      { 'J', '<cmd>TSJToggle<cr>', desc = 'Join Toggle' },
    },
    opts = { use_default_keymaps = false, max_join_length = 150 },
  },

  {
    'smoka7/multicursors.nvim',
    event = 'VeryLazy',
    dependencies = 'smoka7/hydra.nvim',
    opts = {},
    cmd = { 'MCstart', 'MCvisual', 'MCclear', 'MCpattern', 'MCvisualPattern', 'MCunderCursor' },
    -- stylua: ignore
    keys = {
      { mode = { 'v', 'n' }, '<leader>m', '<cmd>MCstart<cr>', desc = 'Multicursor' },
    },
  },

  {
    'chrisgrieser/nvim-origami',
    event = 'BufReadPost', -- later or on keypress would prevent saving folds
    opts = {}, -- needed even when using default config
  },

  {
    'kevinhwang91/nvim-ufo',
    dependencies = { 'kevinhwang91/promise-async' },
    event = 'VeryLazy',
    opts = {
      provider_selector = function(bufnr, filetype, buftype)
        return { 'treesitter', 'indent' }
      end,
      fold_virt_text_handler = function(virtText, lnum, endLnum, width, truncate)
        local newVirtText = {}
        local suffix = (' 󰁂 %d '):format(endLnum - lnum)
        local sufWidth = vim.fn.strdisplaywidth(suffix)
        local targetWidth = width - sufWidth
        local curWidth = 0
        for _, chunk in ipairs(virtText) do
          local chunkText = chunk[1]
          local chunkWidth = vim.fn.strdisplaywidth(chunkText)
          if targetWidth > curWidth + chunkWidth then
            table.insert(newVirtText, chunk)
          else
            chunkText = truncate(chunkText, targetWidth - curWidth)
            local hlGroup = chunk[2]
            table.insert(newVirtText, { chunkText, hlGroup })
            chunkWidth = vim.fn.strdisplaywidth(chunkText)
            -- str width returned from truncate() may less than 2nd argument, need padding
            if curWidth + chunkWidth < targetWidth then
              suffix = suffix .. (' '):rep(targetWidth - curWidth - chunkWidth)
            end
            break
          end
          curWidth = curWidth + chunkWidth
        end
        table.insert(newVirtText, { suffix, 'MoreMsg' })
        return newVirtText
      end,
    },
    config = function(_, opts)
      vim.o.foldcolumn = '0' -- '0' is not bad
      vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
      vim.o.foldlevelstart = 1
      vim.o.foldenable = true
      vim.o.foldnestmax = 4

      require('ufo').setup(opts)
    end,
  },
}
