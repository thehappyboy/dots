# 获取 macOS 版本号
macos_version=$(sw_vers -productVersion | cut -d. -f1)

# 检查 macOS 版本是否为 12 或更早
if (( macos_version <= 12 )); then
  export HOMEBREW_NO_INSTALL_FROM_API=1
  export HOMEBREW_NO_AUTO_UPDATE=1
fi


