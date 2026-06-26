function lark --wraps=lark-cli
    env LARK_CLI_NO_PROXY=1 lark-cli $argv
end
