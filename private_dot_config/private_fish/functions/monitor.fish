function monitor -d " Continuously monitor a given file with syntax highlighting"
    tail -f "$argv" | bat --paging=never -l log
end
