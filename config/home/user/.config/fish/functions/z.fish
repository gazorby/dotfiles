function z --description "List recent directories"
    set dir (fasd -Rdl "$1" | fzf -1 -0 --no-sort +m) && cd "$dir" || return 1
end