function chrome-debug
    set -l CHROME "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
    set -l PORT 9222

    # 如果 Chrome 在跑，先彻底退出（否则端口不生效）
    if pgrep -x "Google Chrome" >/dev/null
        echo "关闭现有 Chrome..."
        pkill -x "Google Chrome"
        sleep 2
    end

    echo "启动 Chrome (remote-debug-port=$PORT)..."
    nohup "$CHROME" --remote-debug-port=$PORT >/dev/null 2>&1 &
    disown
    echo "已启动，端口 $PORT"
end
