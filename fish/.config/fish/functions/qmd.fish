function qmd
    # -l = local (函数作用域), -x = export (环境变量)
    # 函数退出后自动恢复之前的值
    set -lx XDG_CONFIG_HOME $HOME/.cache/qmd/xdg-config
    set -lx XDG_CACHE_HOME $HOME/.cache/qmd/xdg-cache

    command qmd $argv
end
