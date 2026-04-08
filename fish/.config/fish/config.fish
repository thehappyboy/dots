set -gx PNPM_HOME $HOME/Library/pnpm
set -gx BUN_INSTALL $HOME/.bun
set -gx EDITOR nvim
set -gx OBSIDIAN_CLI /Applications/Obsidian.app/Contents/MacOS

# 路径配置 (使用 fish_add_path 自动处理去重)
fish_add_path /opt/homebrew/bin
fish_add_path /opt/homebrew/opt/openjdk/bin
fish_add_path /opt/homebrew/opt/sqlite/bin
fish_add_path $HOME/.local/bin
fish_add_path $PNPM_HOME
fish_add_path $BUN_INSTALL/bin
fish_add_path $OBSIDIAN_CLI

# 代理配置 (默认开启)
set -gx http_proxy "http://127.0.0.1:6152"
set -gx https_proxy "http://127.0.0.1:6152"
set -gx all_proxy "socks5://127.0.0.1:6153"

# HuggingFace mirror
set -gx HF_ENDPOINT https://hf-mirror.com

# 交互式会话配置
if status is-interactive
    # 导航快捷键
    abbr -a -- ... "cd ../.."
    abbr -a -- .... "cd ../../.."
    abbr -a -- ..... "cd ../../../.."

    # 文件系统操作
    abbr -a -- md "mkdir -p"
    abbr -a -- rmr "rm -rf"
    abbr -a -- qs "open -a Qspace\ Pro"

    # 工具增强
    abbr -a -- p "ps -f"
    abbr -a -- grep "grep --color=auto"

    # 现代工具替换
    if command -q bat
        abbr -a -- cat bat
    end

    if command -q nvim
        abbr -a -- vim nvim
        abbr -a -- vi nvim
        abbr -a -- v nvim
    end

    # Git 缩写
    if command -q git
        abbr -a -- g git
        abbr -a -- ga "git add"
        abbr -a -- gaa "git add ."
        abbr -a -- gst "git status -s"
        abbr -a -- gcm "git commit -m"
        abbr -a -- gps "git push"
        abbr -a -- gpl "git pull --rebase"
        abbr -a -- glog "git log --graph --pretty=format:'%C(auto)%h %s %C(blue)%an%Creset'"
    end

    # Homebrew 快捷方式
    if command -q brew
        abbr -a -- bws "brew search"
        abbr -a -- bwi "brew install"
        abbr -a -- bwc "brew install --cask"
        abbr -a -- bwu "brew update && brew upgrade"
        abbr -a -- bcu "brew cleanup --prune=all"
    end

    # Bun 快捷方式
    if command -q bun
        abbr -a -- b bun
        abbr -a -- bi "bun install"
        abbr -a -- ba "bun add"
        abbr -a -- br "bun run"
    end

    # Starship Prompt
    if command -q starship
        starship init fish | source
    end
end

# Added by OrbStack: command-line tools and integration
# This won't be added again if you remove it.
source ~/.orbstack/shell/init2.fish 2>/dev/null || :

# OpenClaw Completion
source "/Users/hades/.openclaw/completions/openclaw.fish"

# QMD 别名（隔离 XDG 目录）
# alias qmd 'env XDG_CONFIG_HOME=$HOME/.cache/qmd/xdg-config XDG_CACHE_HOME=$HOME/.cache/qmd/xdg-cache command qmd $argv'
