local function clear()
  local has = require('lazyvim.util').has
  vim.cmd('nohlsearch')
  vim.lsp.buf.clear_references()
  if has('nvim-notify') then
    require('notify').dismiss({ pending = true, silent = true })
  end
  if has('hlslens') then
    require('hlslens.main').stop()
  end
end

vim.keymap.set('n', '<esc>', clear, { desc = 'clear' })

-- increment/decrement
vim.keymap.set('n', '+', '<c-a>')
vim.keymap.set('n', '-', '<c-x>')

-- jump list
vim.keymap.set('n', '[j', '<c-o>')
vim.keymap.set('n', ']j', '<c-i>')
