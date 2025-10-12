#!/usr/bin/env bash

# -----------------------------------------------------------------------------
# settings.sh - macOS 个性化设置脚本
#
# 这个脚本会自动配置 macOS 的系统和应用设置，以提升用户体验，
# 特别是对于开发者和高级用户。
# -----------------------------------------------------------------------------

# 在开始之前，退出所有打开的“系统偏好设置”面板，防止覆盖后续设置
osascript -e 'tell application "System Preferences" to quit'

# 脚本开始时请求管理员权限
echo "请输入您的密码以开始设置..."
sudo -v

# 保持 sudo 会话，直到脚本执行完毕
while true; do
  sudo -n true
  sleep 60
  kill -0 "$$" || exit
done 2>/dev/null &

# -----------------------------------------------------------------------------
# 安全性设置
# -----------------------------------------------------------------------------

# 警告：此命令会禁用 Gatekeeper，允许运行任何来源的应用。请谨慎使用。
spctl --master-disable

# 清除当前账户的所有密码策略
pwpolicy -clearaccountpolicies

###############################################################################
# 通用 UI/UX 设置                                                             #
###############################################################################

# 禁用文本输入时的自动填充建议
defaults write -g NSAutoFillHeuristicControllerEnabled -bool false

# 设置边栏图标大小为中等
defaults write NSGlobalDomain NSTableViewDefaultSizeMode -int 2

# 始终显示滚动条
# 可选值: `WhenScrolling`, `Automatic`, `Always`
defaults write NSGlobalDomain AppleShowScrollBars -string "Always"

# 加快 Cocoa 应用的窗口缩放速度
defaults write NSGlobalDomain NSWindowResizeTime -float 0.001

# 默认展开“存储”面板
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true

# 默认展开“打印”面板
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true

# 默认保存到本地磁盘，而不是 iCloud
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

# 打印任务完成后自动退出打印机应用
defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true

# 禁用“您确定要打开此应用程序吗？”的警告对话框
defaults write com.apple.LaunchServices LSQuarantine -bool false

# 禁用崩溃报告程序
defaults write com.apple.CrashReporter DialogType -string "none"

# 在登录窗口点击时钟时，显示 IP 地址、主机名、操作系统版本等信息
sudo defaults write /Library/Preferences/com.apple.loginwindow AdminHostInfo HostName

# -----------------------------------------------------------------------------
# 输入优化 (专为代码编写)
# -----------------------------------------------------------------------------

# 禁用自动大写
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false

# 禁用智能破折号
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false

# 禁用自动句号
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false

# 禁用智能引号
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false

# 禁用自动拼写纠正
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

###############################################################################
# 触控板、鼠标、键盘等输入设备                                                #
###############################################################################

# 将 F1-F12 键用作标准功能键
defaults write -globalDomain com.apple.keyboard.fnState -int 1

# 触控板：为当前用户和登录屏幕启用“轻点来点按”
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

# 设置一个极快的键盘重复速率
defaults write NSGlobalDomain KeyRepeat -int 1
defaults write NSGlobalDomain InitialKeyRepeat -int 15

###############################################################################
# 屏幕设置                                                                    #
###############################################################################

# 屏幕保护程序或睡眠后立即要求输入密码
# defaults write com.apple.screensaver askForPassword -int 1
# defaults write com.apple.screensaver askForPasswordDelay -int 0

# 将屏幕截图保存到桌面
defaults write com.apple.screencapture location -string "${HOME}/Desktop"

# 设置屏幕截图格式为 PNG (其他可选: BMP, GIF, JPG, PDF, TIFF)
defaults write com.apple.screencapture type -string "png"

# 禁用屏幕截图的阴影
defaults write com.apple.screencapture disable-shadow -bool true

# 在非 Apple LCD 上启用亚像素字体渲染
# defaults write NSGlobalDomain AppleFontSmoothing -int 1

###############################################################################
# Finder (访达) 设置                                                          #
###############################################################################

# 允许通过 ⌘ + Q 退出 Finder
defaults write com.apple.finder QuitMenuItem -bool true

# 禁用 Finder 的窗口和“显示简介”动画
defaults write com.apple.finder DisableAllAnimations -bool true

# 新建 Finder 窗口时默认打开桌面
# PfDe = Desktop, PfDo = Documents, PfHm = Home
defaults write com.apple.finder NewWindowTarget -string "PfDe"
defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}/Desktop/"

# 在桌面上显示外置硬盘和可移除媒体的图标
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool false
defaults write com.apple.finder ShowMountedServersOnDesktop -bool false
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true

# 显示所有文件扩展名
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# 显示状态栏
defaults write com.apple.finder ShowStatusBar -bool true

# 显示路径栏
defaults write com.apple.finder ShowPathbar -bool true

# 在 Finder 窗口标题中显示完整的 POSIX 路径
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

# 按名称排序时，保持文件夹在顶部
defaults write com.apple.finder _FXSortFoldersFirst -bool true

# 搜索时，默认搜索当前文件夹
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

# 禁用更改文件扩展名时的警告
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# 避免在网络或 USB 卷上创建 .DS_Store 文件
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# 禁用磁盘映像验证
defaults write com.apple.frameworks.diskimages skip-verify -bool true
defaults write com.apple.frameworks.diskimages skip-verify-locked -bool true
defaults write com.apple.frameworks.diskimages skip-verify-remote -bool true

# 挂载卷时自动打开新的 Finder 窗口
defaults write com.apple.frameworks.diskimages auto-open-ro-root -bool true
defaults write com.apple.frameworks.diskimages auto-open-rw-root -bool true
defaults write com.apple.finder OpenWindowForNewRemovableDisk -bool true

# 默认使用列表视图 (Nlsv)
# 其他视图模式: `icnv` (图标), `clmv` (分栏), `glyv` (画廊)
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

# 禁用清空废纸篓前的警告
defaults write com.apple.finder WarnOnEmptyTrash -bool false

# 显示 ~/Library 文件夹
chflags nohidden ~/Library

###############################################################################
# Dock (程序坞) 设置                                                          #
###############################################################################

# 设置 Dock 中图标的大小为 36 像素
defaults write com.apple.dock tilesize -int 36

# 清空 Dock 中所有默认的应用图标
defaults write com.apple.dock persistent-apps -array

# 【用户要求】将 Dock 放置在屏幕底部
defaults write com.apple.dock orientation -string "bottom"

# 禁用从 Dock 启动应用程序的动画
defaults write com.apple.dock launchanim -bool false

# 加快 Mission Control 的动画速度
defaults write com.apple.dock expose-animation-duration -float 0.1

# 【用户要求】自动隐藏和显示 Dock
defaults write com.apple.dock autohide -bool true

# 使隐藏应用的图标在 Dock 中变为半透明
defaults write com.apple.dock showhidden -bool true

# 不在 Dock 中显示最近使用的应用
defaults write com.apple.dock show-recents -bool false

###############################################################################
# Photos (照片)                                                               #
###############################################################################

# 插入设备时，防止“照片”应用自动打开
defaults -currentHost write com.apple.ImageCapture disableHotPlug -bool true

###############################################################################
# 重启受影响的应用以使更改生效                                                #
###############################################################################

echo "正在应用设置..."

for app in "Dock" "Finder" "SystemUIServer"; do
  killall "${app}" >/dev/null 2>&1
done

echo "✅ 设置完成！"
echo "请注意：部分更改可能需要您注销或重启电脑才能完全生效。"
