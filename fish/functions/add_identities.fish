function add_identities -d "Add ssh identities"
    grep -slR "PRIVATE" $HOME/.ssh/ | xargs ssh-add
end