-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.g.python3_host_prog = vim.fn.expand('~/.config/nvim/.venv/bin/python')
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0

vim.g.lazyvim_python_lsp = 'pyright'
vim.g.lazyvim_python_ruff = 'ruff'
