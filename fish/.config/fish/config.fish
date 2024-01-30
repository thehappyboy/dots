set -Ux fish_user_paths
fish_add_path /usr/local/sbin/
fish_add_path /Library/Frameworks/Python.framework/Versions/3.12/bin/

# misc
abbr qs "open -a Qspace\ Pro"
# abbr python python3
# abbr pip pip3
abbr h history
abbr md "mkdir -p"
abbr rmr "rm -rf"
abbr p "ps -f"
abbr grep "grep --color"
abbr vd "cd ~/.config/nvim; nvim"

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

if command -sq vf
    abbr vfn "vf new"
    abbr vfa "vf activate"
    abbr vfd "vf deactivate"
end

if command -sq conda
    abbr cc "conda create -n"
    abbr ca "conda activate"
    abbr cd "conda deactivate"
end

if command -sq brew
    abbr bws "brew search"
    abbr bwi "brew install"
    abbr bwc "brew install --cask"
    abbr bwu "brew update"
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

if command -sq starship
    starship init fish | source
end
