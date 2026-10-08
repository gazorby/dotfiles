#!/bin/sh

mkdir -p "$HOME/.local/chezmoi_system"
mkdir -p "$HOME/.ssh/sockets"

# mise fish completions
mkdir -p ~/.config/fish/completions
mise use -g usage
mise completion fish > ~/.config/fish/completions/mise.fish || true

# atuin fish completions
atuin gen-completions --shell fish --out-dir ~/.config/fish/completions || true

# starship fish completions
starship completions fish > ~/.config/fish/completions/starship.fish || true

# chezmoi fish completions
"$CHEZMOI_EXECUTABLE" completion fish --output ~/.config/fish/completions/chezmoi.fish || true

# procs fish completions
procs --gen-completion-out fish > ~/.config/fish/completions/procs.fish || true

# git-delta fish completions
delta --generate-completion fish > ~/.config/fish/completions/delta.fish || true
