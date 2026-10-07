#!/bin/sh

mkdir -p "$HOME/.local/chezmoi_system"
mkdir -p "$HOME/.ssh/sockets"

# mise fish completions
mkdir -p ~/.config/fish/completions
mise use -g usage
mise completion fish > ~/.config/fish/completions/mise.fish

# atuin fish completions
atuin gen-completions --shell fish --out-dir ~/.config/fish/completions

# starship fish completions
starship completions fish > ~/.config/fish/completions/starship.fish

# chezmoi fish completions
chezmoi completion fish --output ~/.config/fish/completions/chezmoi.fish

# procs fish completions
procs --gen-completion-out fish > ~/.config/fish/completions/procs.fish

# git-delta fish completions
delta --generate-completion fish > ~/.config/fish/completions/delta.fish
