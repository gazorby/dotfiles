#!/bin/sh

mkdir -p "$HOME/.ssh/sockets"

# mise fish completions
mkdir -p ~/.config/fish/completions
mise use -g usage
mise completion fish > ~/.config/fish/completions/mise.fish 2>/dev/null || true

# atuin fish completions
atuin gen-completions --shell fish --out-dir ~/.config/fish/completions 2>/dev/null || true

# starship fish completions
starship completions fish > ~/.config/fish/completions/starship.fish 2>/dev/null || true

# chezmoi fish completions
"$CHEZMOI_EXECUTABLE" completion fish --output ~/.config/fish/completions/chezmoi.fish 2>/dev/null || true

# procs fish completions
procs --gen-completion-out fish > ~/.config/fish/completions/procs.fish 2>/dev/null || true

# git-delta fish completions
delta --generate-completion fish > ~/.config/fish/completions/delta.fish 2>/dev/null || true
