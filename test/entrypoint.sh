#!/usr/bin/env sh

/bin/chezmoi init $GIT_REPO
sed -i '/^.*starship init fish.*$/d' ~/.local/share/chezmoi/private_dot_config/private_fish/config.fish.tmpl

exec "$@"
