function ocmcporter --wraps=mcporter --description="Wrap mcporter with workspace config"
    mcporter --config $HOME/.openclaw/workspace/config/mcporter.json $argv
end
