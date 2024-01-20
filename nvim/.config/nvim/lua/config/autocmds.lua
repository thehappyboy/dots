-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

local function is_django_project()
  -- 获取当前的路径
  local path = vim.fn.expand('%:p:h')

  -- 检查五级以内的路径内是否存在 manage.py 文件
  for _ = 1, 5 do
    if vim.fn.filereadable(path .. '/manage.py') == 1 then
      return true
    end
    -- 当前路径的父路径
    path = vim.fn.fnamemodify(path, ':h')
  end

  return false
end

local function set_py_file_for_django()
  local file_type = vim.bo.filetype
  local ls_exists, luasnip = pcall(require, 'luasnip')

  if file_type == 'python' and is_django_project() then
    if ls_exists then
      luasnip.filetype_extend('python', { 'django' })
      vim.treesitter.language.register('python', 'django')
    end
  end
end

local function set_html_file_for_django()
  local file_type = vim.bo.filetype
  local ls_exists, luasnip = pcall(require, 'luasnip')

  if file_type == 'html' and is_django_project() then
    vim.bo.filetype = 'htmldjango'
    if ls_exists then
      luasnip.filetype_extend('htmldjango', { 'html' })
    end
  end
end

vim.api.nvim_create_autocmd('Filetype', {
  pattern = 'html',
  callback = set_html_file_for_django,
})

vim.api.nvim_create_autocmd('Filetype', {
  pattern = 'python',
  callback = set_py_file_for_django,
})
