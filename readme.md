# dots

macOS dotfiles managed with GNU Stow.

## Apply

```sh
./stow-manage.sh
```

### Fresh Mac

```sh
git clone https://github.com/thehappyboy/dots.git "$HOME/dots"
cd "$HOME/dots"
./new_mac/bootstrap.sh
```

`bootstrap.sh` follows the original setup order:

1. `settings.sh` applies macOS preferences.
2. `brew_install.sh` installs Homebrew and the Brewfile.
3. `stow-manage.sh` applies static modules.
4. `post_install.sh` creates the Neovim Python venv, syncs magpie, asks before
   applying the optional application configs and checks CLIs.

To skip the macOS settings step:

```sh
SKIP_MACOS_SETTINGS=1 ./new_mac/bootstrap.sh
```

The four steps can also be run separately:

```sh
./new_mac/settings.sh
./new_mac/brew_install.sh
./stow-manage.sh
./new_mac/post_install.sh
```

For an existing machine with Homebrew and the Brewfile already installed:

```sh
./stow-manage.sh
./new_mac/post_install.sh
```

Static Stow modules:

- npm, uv, bat, fish, git, nvim, ruff, warp, ghostty, starship
- agy (`~/.gemini/antigravity-cli/settings.json`)
- sublime (custom target under `~/Library/Application Support/Sublime Text/Packages/User`)

Optional overlay modules preserve app- and magpie-managed dynamic state. They
are offered after the static modules and, during bootstrap, after magpie sync:

- `claude`: stable Claude Code keys; model/env/model picker stay owned by magpie.
- `codex`: stable Codex keys; gateway, model catalog and MCP stay owned by magpie.
- `claude-desktop-3p`: stable Desktop preferences and policy; gateway, models, MCP and skills stay owned by magpie.

The three overlays are opt-in. During bootstrap they are offered one by one,
and a non-interactive run skips them. To apply or reapply them later:

Running `./stow-manage.sh` directly asks immediately after the static modules;
bootstrap defers the prompts until after magpie sync.

```sh
./apply-overlays.sh          # ask for each config
./apply-overlays.sh --yes    # apply all
./apply-overlays.sh --no     # skip all
```

Launch Claude Desktop 3P once before applying its overlay, otherwise the
overlay has no profile to update.

`new_mac/` contains bootstrap scripts. `new_mac/post_install.sh` creates the
Neovim Python venv, syncs magpie, offers the optional overlays and checks CLI
presence.
RTK hooks are injected by magpie for Claude Code, Codex and Antigravity CLI;
they are intentionally not stored in dots.

Retired configs: zed, cursor, rime, zsh and tmux. They are kept under
`~/Library/Application Support/dots-retired/` when removed from this repo.

## Sublime Text (macOS)

用户设置和 Package Control 插件清单保存在 `sublime/`，链接到 `~/Library/Application Support/Sublime Text/Packages/User/`：

```sh
mkdir -p "$HOME/Library/Application Support/Sublime Text/Packages/User"
stow --dir="$HOME/dots" --target="$HOME/Library/Application Support/Sublime Text/Packages/User" sublime
```

首次迁移已有配置时先备份并处理同名文件冲突。缓存、会话、证书和插件实体不纳入版本管理。语言服务器由 `LSP`、`LSP-tsgo`、`LSP-pyright` 和 `LSP-rust-analyzer` 提供；TypeScript 使用官方全球 TypeScript 7 的 `tsc --lsp` 入口。

### Sublime 编辑偏好

- BerkeleyMonoNF 14；Catppuccin Latte / Mocha 随系统明暗切换，Adaptive 界面主题。
- JSON/YAML/JS/TS：2 空格；Python/Rust：4 空格。Markdown 自动换行到 100 列，保留行尾双空格。
- Pretty JSON：`Cmd+Alt+J` 格式化 JSON，保留中文和键顺序，保存时校验。
- Catppuccin 和 Pretty JSON 由 Package Control 清单管理；本机首次通过上游 Git 仓库安装。
- 未安装语言服务器；以上语言使用 Sublime 内置语法高亮。
