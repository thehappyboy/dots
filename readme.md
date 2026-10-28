# dots

my dots file config:

- nvim
- fish
- git
- bat
- warp
- cursor
- tmuxa
- ruff
- zed

## Sublime Text (macOS)

用户设置和 Package Control 插件清单保存在 `sublime/`，链接到 `~/Library/Application Support/Sublime Text/Packages/User/`：

```sh
mkdir -p "$HOME/Library/Application Support/Sublime Text/Packages/User"
stow --dir="$HOME/dots" --target="$HOME/Library/Application Support/Sublime Text/Packages/User" sublime
```

首次迁移已有配置时先备份并处理同名文件冲突。缓存、会话、证书和插件实体不纳入版本管理。

### Sublime 编辑偏好

- BerkeleyMono Nerd Font 14；Catppuccin Latte / Mocha 随系统明暗切换，Adaptive 界面主题。
- JSON/YAML/JS/TS：2 空格；Python/Rust：4 空格。Markdown 自动换行到 100 列，保留行尾双空格。
- Pretty JSON：`Cmd+Alt+J` 格式化 JSON，保留中文和键顺序，保存时校验。
- Catppuccin 和 Pretty JSON 由 Package Control 清单管理；本机首次通过上游 Git 仓库安装。
- 未安装语言服务器；以上语言使用 Sublime 内置语法高亮。
