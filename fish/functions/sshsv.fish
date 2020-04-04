function sshsv -d "Save ssh password for a given host"
    if set -q $argv[2]
        set id_rsa "~/.ssh/id_rsa.pub"
    else
        set id_rsa $argv[2]
    end
    ssh "$argv[1]" mkdir -p .ssh && cat "$id_rsa" | ssh "$argv[1]" 'cat >> ~/.ssh/authorized_keys'
end