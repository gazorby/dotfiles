function sshsv -d "Install a public key on a host" -a host key
    set -q key[1]; or set key ~/.ssh/id_rsa.pub
    ssh-copy-id -i $key $host
end
