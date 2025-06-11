return {
  {
    'neovim/nvim-lspconfig',
    opts = {
      servers = {
        djlsp = {
          init_options = {
            -- django_settings_module = "",
            docker_compose_file = 'docker-compose.yml',
            docker_compose_service = 'django',
          },
        },
        ruff = {
          init_options = {
            settings = {
              organizeImports = false,
            },
          },
        },
      },
    },
  },
}
