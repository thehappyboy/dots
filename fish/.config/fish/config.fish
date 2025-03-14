set -gx PNPM_HOME $HOME/Library/pnpm
set -gx EDITOR nvim

# 系统路径（使用一次性的 fish_add_path）
set -gx fish_user_paths \
    /usr/local/sbin \
    $HOME/.local/bin \
    $HOME/Library/pnpm

# macOS 版本判断优化（使用数学比较）
set -l mac_version (string split . (sw_vers -productVersion))[1]
if test $mac_version -le 12
    set -gx HOMEBREW_NO_INSTALL_FROM_API 1
    set -gx HOMEBREW_NO_AUTO_UPDATE 1
end

# 代理配置（推荐仅在需要时启用）
set -gx http_proxy "http://127.0.0.1:7890"
set -gx https_proxy "http://127.0.0.1:7890"
set -gx all_proxy "socks5://127.0.0.1:7890"

# 文件系统增强
abbr -a -- qs "open -a Qspace\ Pro"
abbr -a -- md "mkdir -p"
abbr -a -- rmr "rm -rf"
abbr -a -- p "ps -f"
abbr -a -- grep "grep --color"

# 核心工具增强（条件式别名）
if command -q bat
    abbr -a -- cat bat
end

if command -q nvim
    abbr -a -- vim nvim
    abbr -a -- vi nvim
    abbr -a -- v nvim
end

# Git 工作流（语义化别名）
if command -q git
    abbr -a -- g git
    abbr -a -- ga "git add"
    abbr -a -- ga. "git add ."
    abbr -a -- gst "git status -s"
    abbr -a -- gcm "git commit -m"
    abbr -a -- gps "git push"
    abbr -a -- gpl "git pull --rebase"
    abbr -a -- glog "git log --graph --pretty=format:'%C(auto)%h %s %C(blue)%an%Creset'"
end

# Homebrew 快捷方式（带自动清理）
if command -q brew
    abbr -a -- bws "brew search"
    abbr -a -- bwi "brew install"
    abbr -a -- bwc "brew install --cask"
    abbr -a -- bwu "brew update && brew upgrade"
    abbr -a -- bcu "brew cleanup --prune=all"
end
