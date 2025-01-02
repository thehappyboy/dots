set -Ux fish_user_paths
fish_add_path /usr/local/sbin/
fish_add_path /usr/local/mysql/bin/

export HOMEBREW_NO_INSTALL_FROM_API=1
export HOMEBREW_NO_AUTO_UPDATE=1


set -Ux https_proxy "http://127.0.0.1:7890"
set -Ux http_proxy "http://127.0.0.1:7890"
set -Ux all_proxy "socks5://127.0.0.1:7890"

# misc
abbr qs "open -a Qspace\ Pro"
abbr h history
abbr md "mkdir -p"
abbr rmr "rm -rf"
abbr p "ps -f"
abbr grep "grep --color"

if command -sq lazygit
    abbr lg lazygit
end

if command -sq bat
    abbr cat bat
end

if command -sq nvim
    alias vim="nvim"
    alias vi="nvim"
    alias v="nvim"
    set -gx EDITOR nvim
end

if command -sq conda
    abbr cdc "conda create -n"
    abbr cda "conda activate"
    abbr cdd "conda deactivate"
end

if command -sq brew
    abbr bws "brew search"
    abbr bwi "brew install"
    abbr bwc "brew install --cask"
    abbr bwu "brew update"
    abbr bcu "brew cleanup --prune all"
end


if command -sq tmux
    abbr t tmux
    abbr tc "tmux attach"
    abbr ta "tmux attach -t"
    abbr tl "tmux ls"
    abbr tk "tmux kill-session -t"
end

if command -sq git
    abbr g git
    abbr ga "git add"
    abbr gaa "git add --all"
    abbr gst "git status"
    abbr gc "git clone"
    abbr gcm "git commit -m"
    abbr gl "git log"
    abbr gps "git push"
    abbr gpl "git pull"
    abbr grm "git rm"
    abbr grmc "git rm --cached"
end

alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
