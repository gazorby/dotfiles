function unusedport -d "get unused unix port"
    set -l used_ports (ss --unix --no-header | awk '{print $6}')
    random (date +%s) # set seed
    set -l random_port (random 1023 65535)

    while contains $random_port $used_ports
        set random_port (random 1023 65535)
    end

    echo $random_port
end