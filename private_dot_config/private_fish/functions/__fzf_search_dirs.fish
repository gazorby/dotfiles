function __fzf_search_dirs -d "Recursively search directories using the last token on commandline"
    set -l current (commandline -t)
    if test -z "$current"
        set current "."
    else
        set current (string replace '~' $HOME "$current")
    end
    set -l COMMAND
    if test "$argv[1]" = "hidden"
        set COMMAND "$FZF_CD_WITH_HIDDEN_COMMAND"
    else
        set COMMAND "$FZF_ALT_C_COMMAND"
    end
    set -l query (eval "$COMMAND "$current" | "(__fzfcmd)" $FZF_ALT_C_OPTS")
    if test -n "$query"
        commandline -t "$query"
    end
    commandline -f repaint
end
