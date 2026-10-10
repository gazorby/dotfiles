# Install fisher if not already installed
install_fisher

###################################
# Variables
###################################

# Sometimes this is not in PATH
fish_add_path $HOME/.local/bin
fish_add_path $HOME/.cargo/bin
fish_add_path $HOME/.dotnet
fish_add_path $HOME/.yarn/bin
fish_add_path $HOME/.poetry/bin
fish_add_path $HOME/.krew/bin
fish_add_path /usr/lib/passenger/bin
fish_add_path /lib/passenger/bin

set -q fisher_path; or set -Ux fisher_path "$HOME/.config/fish"

# Standalone env vars
set -gx EDITOR ms
set -gx BAT_STYLE plain
set -gx CARGO_INSTALL_ROOT ~/.cargo

# Colorize manpages using bat
set -q MANPAGER; or set -Ux MANPAGER 'sh -c "col -bx | bat --language=man --style=grid --color=always --decorations=always"'
set -q MANROFFOPT; or set -Ux MANROFFOPT -c

# Docker
set -q DOCKER_CONFIG; or set -Ux DOCKER_CONFIG "$HOME/.docker"

# fzf
set -gx FZF_DEFAULT_OPTS "
    --layout=reverse
    --height=90%
    --prompt='~ ' --pointer='▶' --marker='✓'
    --multi
    --cycle
    --color='$(fzf_theme_colors)'
    --bind='ctrl-a:select-all'
    --bind='?:toggle-preview'
    --bind='ctrl-o:execute(\$EDITOR {+} &> /dev/tty)'
    --bind='ctrl-v:execute(code {+})'
    --bind='tab:down,shift-tab:up,ctrl-space:toggle+down'
"

# fzf.fish fish plugin
fzf_configure_bindings --directory=\cf --processes=\cp --git_log=\cg --git_status=\eg --variables=\cv --history=

# Use eza to list files (with colors) if present
set fzf_preview_dir_cmd eza --all --color=always

set -gx fzf_fd_opts --follow
# Bind ctrl+h to reload with hidden files
set -a fzf_directory_opts --bind='ctrl-h:reload(fd --type file --color=always --hidden --follow --exclude .git)'
# Bind ctrl+x to reload with executable files
set -a fzf_directory_opts --bind='ctrl-x:reload(fd --type executable --color=always --hidden --follow --exclude .git)'
# Bind ctrl+d to reload with directories only
set -a fzf_directory_opts --bind='ctrl-d:reload(fd --type directory --color=always --hidden --follow --exclude .git)'
# Bind ctrl+f to reload with the default search options
set -a fzf_directory_opts --bind='ctrl-f:reload(fd --type file --color=always --follow)'
# Bind ctrl+o to open the current item
set -a fzf_directory_opts --bind='ctrl-o:execute($EDITOR {} &> /dev/tty)'

# --width=20 lets delta fill the preview pane, whose width it cannot detect
set -gx fzf_diff_highlighter delta --paging=never --width=20

# Forgit fish plugin
set -U forgit_log glo:
set -U forgit_diff gd:
set -U forgit_add ga:
set -U forgit_reset_head grh:
set -U forgit_ignore gif
set -U forgit_restore gcf:
set -U forgit_clean gclean:
set -U forgit_stash_show gss:
set -U forgit_cherry_pick gcp:
set -U forgit_rebase grb:

# autopair fish plugin
set -g autopair_complete_command _fifc

###################################
# Auto add ssh keys at login
###################################
if status --is-login
    setenv SSH_ENV $HOME/.ssh/environment

    if test -z "$SSH_AGENT_PID"; and test -f $SSH_ENV
        . $SSH_ENV >/dev/null
    end

    # ssh-add -l exits 1 when the agent holds no keys, 2 when it is unreachable
    ssh-add -l >/dev/null 2>&1
    switch $status
        case 1
            add_identities
        case 2
            start_agent
    end
end

###################################
# Keybindings
###################################

if status is-interactive
    bind ctrl-h backward-kill-path-component
end

###################################
# Aliases/Abbreviations
###################################

alias cf fzf-bcd-widget
alias gpgunlock 'echo test | gpg --clearsign > /dev/null && echo unlocked'
alias typora 'open -a typora'

abbr b bat
abbr nv nvim
abbr m mise
abbr pc pre-commit
abbr cl claude
abbr lzg lazygit
abbr gdv "git -c core.pager='delta --side-by-side' diff"
abbr lzgf lazygit -sm full
abbr gt glab-tui
abbr glt glab-tui

###################################
# Sources
###################################

if status is-interactive
    # Starship
    starship init fish --print-full-init | source

    # Atuin
    atuin init fish | source

    bind alt-r _atuin_search
    bind -M insert alt-r _atuin_search

    # Colors
    set -x LS_COLORS (vivid generate molokai)

    # zoxide
    zoxide init fish | source

    # fifc
    fifc \
        --regex '^(pacman|paru)(\\h*\\-S)?\\h+' \
        --source 'pacman --color=always -Ss "$fifc_token" | string match -r \'^[^\\h+].*\'' \
        --extract '.*/(.*?)\\h.*' \
        --fzf-options "--query ''" \
        --preview 'pacman -Si "$fifc_extracted"'

    fifc \
        --regex '.*\*{2}.*' \
        --source 'rg --hidden -l --no-messages (string match -r -g \'.*\*{2}(.*)\' "$fifc_commandline")' \
        --preview 'batgrep --smart-case --color --paging=never (string match -r -g \'.*\*{2}(.*)\' "$fifc_commandline") "$fifc_candidate"' \
        --fzf-options "--query ''" \
        --open 'batgrep --color (string match -r -g \'.*\*{2}(.*)\' "$fifc_commandline") "$fifc_candidate" | less -R' \
        --order 1
end

# Set tty for gpg
set -gx GPG_TTY (tty)

# fifc config
set -gx fifc_exa_opts --all --color=always --icons
