set -gx PNPM_HOME $HOME/Library/pnpm
set -gx BUN_INSTALL $HOME/.bun
set -gx EDITOR nvim
set -gx OBSIDIAN_CLI /Applications/Obsidian.app/Contents/MacOS

# 清除 fish 启动问候语
set fish_greeting

# 动态检测 Homebrew 前缀（兼容 Apple Silicon /opt/homebrew 与 Intel /usr/local）
if test -x /opt/homebrew/bin/brew
    set -gx HOMEBREW_PREFIX /opt/homebrew
else if test -x /usr/local/bin/brew
    set -gx HOMEBREW_PREFIX /usr/local
end

# 路径配置 (使用 fish_add_path --global 避免污染 universal fish_user_paths)
if set -q HOMEBREW_PREFIX
    fish_add_path --global $HOMEBREW_PREFIX/bin $HOMEBREW_PREFIX/sbin
    for keg in openjdk sqlite
        if test -d $HOMEBREW_PREFIX/opt/$keg/bin
            fish_add_path --global $HOMEBREW_PREFIX/opt/$keg/bin
        end
    end
end
fish_add_path --global $HOME/.cargo/bin
fish_add_path --global $HOME/.local/bin
fish_add_path --global --append $PNPM_HOME
fish_add_path --global --append $BUN_INSTALL/bin
fish_add_path --global --append $OBSIDIAN_CLI
fish_add_path --global --append /Applications/magpie.app/Contents/MacOS

# 代理配置（统一 127.0.0.1，容器 host 网络模式可用）
set -gx http_proxy http://127.0.0.1:7897
set -gx https_proxy http://127.0.0.1:7897
set -gx HTTP_PROXY http://127.0.0.1:7897
set -gx HTTPS_PROXY http://127.0.0.1:7897
set -gx no_proxy localhost,127.0.0.1,::1
set -gx NO_PROXY localhost,127.0.0.1,::1

# HuggingFace mirror
set -gx HF_ENDPOINT https://hf-mirror.com

# Use Qwen3-Embedding-0.6B for better multilingual (CJK) support
set -gx QMD_EMBED_MODEL "hf:Qwen/Qwen3-Embedding-0.6B-GGUF/Qwen3-Embedding-0.6B-Q8_0.gguf"
# set -gx QMD_RERANK_MODEL "hf:gpustack/bge-reranker-v2-m3-GGUF/bge-reranker-v2-m3-Q8_0.gguf"

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

    # lazygit 快捷方式
    if command -q lazygit
        abbr -a -- lg lazygit
    end

    # Starship Prompt
    if command -q starship
        starship init fish | source
    end

    # Zoxide 智能目录跳转
    if command -q zoxide
        zoxide init fish | source
    end

    if command -q peekaboo
        peekaboo completions fish | source
    end

    # OpenClaw Completion
    if test -f "$HOME/.openclaw/completions/openclaw.fish"
        source "$HOME/.openclaw/completions/openclaw.fish"
    end
end

# Added by OrbStack: command-line tools and integration
# This won't be added again if you remove it.
source ~/.orbstack/shell/init2.fish 2>/dev/null || :

# >>> magpie agy >>>
function agy
    if test -x '/Applications/magpie.app/Contents/MacOS/magpie'
        '/Applications/magpie.app/Contents/MacOS/magpie' agy run $argv
    else
        command agy $argv
    end
end
# <<< magpie agy <<<
