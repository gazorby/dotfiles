function fzf-select -d 'fzf commandline job and print unescaped selection back to commandline'
    set -l cmd (commandline -j)
    [ "$cmd" ]
    or return
    eval $cmd | eval (__fzfcmd) -m --tiebreak=index --select-1 --exit-0 | string join ' ' | read -l result
    [ "$result" ]
    and commandline -j -- $result
    commandline -f repaint
end