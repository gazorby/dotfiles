function __fzf_alt_x -d "Recursively search directories using the last token on commandline"
    set -l current (commandline -t)
    if test -z "$current"
        set current "."
    else
        set current (string replace '~' $HOME "$current")
    end
    set -l query (fd -t d --full-path --hidden './' "$current" | eval (__fzfcmd) $FZF_ALT_C_OPTS)
    if test -n "$query"
        commandline -t "$query"
    end
    commandline -f repaint
end
