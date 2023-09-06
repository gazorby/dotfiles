function add_identities -d "Add ssh identities"
    set -l existing_keys (ssh-add -l)
    for file in (grep -slR "PRIVATE" $HOME/.ssh/)
        if string match (string join '' '*' (ssh-keygen -lf "$file") '*') "$existing_keys"
            ssh-add "$file"
        end
    end
end
