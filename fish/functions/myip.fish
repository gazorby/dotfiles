function myip -d "Get ip address"
    ip addr | rg "scope global" | rg -o --pcre2 '(?<=inet )[\d.]+'
end