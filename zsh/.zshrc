# 代理配置
export http_proxy=http://192.168.139.3:7897
export https_proxy=http://192.168.139.3:7897
export no_proxy=localhost,127.0.0.1,::1


# >>> magpie agy >>>
function agy {
  if [ -x '/Applications/magpie.app/Contents/MacOS/magpie' ]; then '/Applications/magpie.app/Contents/MacOS/magpie' agy run "$@"; else command agy "$@"; fi
}
# <<< magpie agy <<<
