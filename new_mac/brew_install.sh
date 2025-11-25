#!/usr/bin/env bash

# -----------------------------------------------------------------------------
# brew_install.sh - 自动安装 Homebrew 及 Brewfile 中的依赖
#
# 该脚本会执行以下操作：
# 1. 检查并安装 Apple Command Line Tools.
# 2. 设置临时的代理（如有需要）.
# 3. 从 GitHub 克隆配置文件仓库.
# 4. 检查并安装 Homebrew.
# 5. 使用 Brewfile 安装所有指定的软件包.
# 6. 清理 Homebrew 缓存.
# -----------------------------------------------------------------------------

# 如果任何命令失败，则立即退出脚本
set -e

# --- 配置变量 ---
# 将你的配置文件仓库地址和本地路径定义为变量，方便修改
DOTFILES_REPO="https://github.com/thehappyboy/dots.git"
DOTFILES_DIR="${HOME}/dots"

# --- 辅助函数 ---

# 检查并安装 Xcode Command Line Tools
install_xcode_tools() {
  echo "--> 检查 Xcode Command Line Tools..."
  if ! xcode-select -p &>/dev/null; then
    echo "未找到 Command Line Tools，正在开始安装..."
    echo "请在弹出的窗口中点击 '安装' 并等待安装完成，然后重新运行此脚本。"
    xcode-select --install
    # 等待用户完成安装
    read -p "Command Line Tools 安装完成后，请按 Enter 键继续..."
  else
    echo "Command Line Tools 已安装。"
  fi
}

# 设置代理（仅对当前脚本会话有效）
setup_proxy() {
  echo "--> 正在为当前会话设置代理..."
  # 注意：请确保你的代理服务正在 http://127.0.0.1:6152 (HTTP)
  # 和 socks5://127.0.0.1:6153 (SOCKS5) 上运行
  export https_proxy=http://127.0.0.1:6152
  export http_proxy=http://127.0.0.1:6152
  export all_proxy=socks5://127.0.0.1:6153
  echo "代理已设置。"
}

# 克隆配置文件仓库
clone_dotfiles_repo() {
  echo "--> 准备克隆配置文件..."
  if [ -d "$DOTFILES_DIR" ]; then
    echo "配置文件目录 '$DOTFILES_DIR' 已存在，跳过克隆。"
    echo "如需更新，请手动进入目录执行 'git pull'。"
  else
    echo "正在从 '$DOTFILES_REPO' 克隆到 '$DOTFILES_DIR'..."
    git clone "$DOTFILES_REPO" "$DOTFILES_DIR"
  fi
}

# 检查并安装 Homebrew
install_homebrew() {
  echo "--> 检查 Homebrew..."
  if ! command -v brew &>/dev/null; then
    echo "未找到 Homebrew，正在开始安装..."
    # 使用非交互模式进行安装
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # 将 Homebrew 添加到当前 Shell 的 PATH 中，以便立即使用
    # 兼容 Apple Silicon 和 Intel Mac
    echo "--> 将 Homebrew 添加到当前会话的 PATH..."
    if [[ -f "/opt/homebrew/bin/brew" ]]; then # Apple Silicon
      eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [[ -f "/usr/local/bin/brew" ]]; then # Intel
      eval "$(/usr/local/bin/brew shellenv)"
    fi
    echo "Homebrew 安装并配置成功。"
  else
    echo "Homebrew 已安装。"
  fi
}

# --- 主函数 ---
main() {
  ## nor nessessary, homebrew will check and install command_line_tools
  # install_xcode_tools
  setup_proxy
  clone_dotfiles_repo
  install_homebrew

  BREWFILE_PATH="${DOTFILES_DIR}/new_mac/Brewfile"
  if [ -f "$BREWFILE_PATH" ]; then
    echo "--> 找到 Brewfile，正在安装依赖..."
    brew bundle --file "$BREWFILE_PATH"
  else
    echo "--> 警告：在 '$BREWFILE_PATH' 未找到 Brewfile，跳过依赖安装。"
  fi

  echo "--> 正在清理 Homebrew 缓存..."
  brew cleanup --prune=all

  echo -e "\n✅ Homebrew 及相关依赖已全部处理完毕！"
}

# --- 执行脚本 ---
main
