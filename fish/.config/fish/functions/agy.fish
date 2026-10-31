function agy
    if test -x '/Applications/magpie.app/Contents/MacOS/magpie'
        '/Applications/magpie.app/Contents/MacOS/magpie' agy run $argv
    else
        command agy $argv
    end
end
