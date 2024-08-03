return {
  {
    'linux-cultist/venv-selector.nvim',
    opts = {
      settings = {
        search = {
          miniconda_envs = {
            command = "$FD 'bin/python$' /usr/local/Caskroom/miniconda/base/envs --full-path --color never",
            type = 'anaconda',
          },
          miniconda_base = {
            command = "$FD '/python$' /usr/local/Caskroom/miniconda/base/bin --full-path --color never",
            type = 'anaconda',
          },
        },
      },
    },
  },
}
