return {
  { 'mfussenegger/nvim-dap', keys = {
    { '<leader>dB', false },
    { '<leader>db', false },
  } },
  {
    'Weissle/persistent-breakpoints.nvim',
    event = 'BufReadPost',
    opts = {
      load_breakpoints_event = { 'BufReadPost' },
    },
    keys = {
      {
        '<leader>db',
        function()
          require('persistent-breakpoints.api').toggle_breakpoint()
        end,
        { silent = true },
        desc = 'Toggle breakpoint',
      },
      {
        '<leader>dB',
        function()
          require('persistent-breakpoints.api').clear_all_breakpoints()
        end,
        { silent = true },
        desc = 'Clear Breakpoints',
      },
    },
  },
}
