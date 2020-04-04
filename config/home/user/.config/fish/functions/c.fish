function c -d "Browse chromium history"
    set google_history "$HOME/.config/BraveSoftware/Brave-Browser/Default/History"
    set cols (math $COLUMNS / 3)
    set sep '{::}'
    set open "xdg-open"

    cp -f "$google_history" /tmp/h
    sqlite3 -separator $sep /tmp/h \
        "select substr(title, 1, $cols), url
        from urls order by last_visit_time desc" |
    awk -F $sep '{printf "%-'$cols's  \x1b[36m%s\x1b[m\n", $argv[1], $argv[2]}' |
    fzf --ansi --multi | sed 's#.*\(https*://\)#\1#' | xargs $open >/dev/null 2>/dev/null
end