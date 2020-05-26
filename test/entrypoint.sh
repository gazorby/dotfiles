#!/usr/bin/env sh

/bin/chezmoi init https://github.com/Gazorby/dotfiles.git
sed -i '/^.*starship init fish.*$/d' ~/.local/share/chezmoi/private_dot_config/private_fish/config.fish.tmpl

exec "$@"
