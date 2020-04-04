function start_agent -d "Start the ssh agent"
    echo "Initializing new SSH agent ..."
    ssh-agent -c | sed 's/^echo/#echo/' >$SSH_ENV
    echo "succeeded"
    chmod 600 $SSH_ENV
    . $SSH_ENV >/dev/null
    add_identities
end