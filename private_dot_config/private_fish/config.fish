# Install fisher if not already installed
if not type -q fisher; and not set -q _installing_fisher
    set -gx _installing_fisher 1
    if test -f "$__fish_config_dir/fish_plugins"
        cp "$__fish_config_dir/fish_plugins" "$__fish_config_dir/fish_plugins.tmp"
        curl -sL https://git.io/fisher | source && fisher install jorgebucaran/fisher
        cp "$__fish_config_dir/fish_plugins.tmp" "$__fish_config_dir/fish_plugins"
        fisher update
        rm "$__fish_config_dir/fish_plugins.tmp"
    else
        curl -sL https://git.io/fisher | source && fisher install jorgebucaran/fisher
    end

    set -e _installing_fisher
end
###################################
# Variables
###################################

# Sometimes this is not in PATH
set -ag fish_user_paths "$HOME"/.local/bin
set -ag fish_user_paths /lib/passenger/bin
set -ag fish_user_paths /usr/lib/passenger/bin
set -ag fish_user_paths $HOME/.cargo/bin
set -ag fish_user_paths $HOME/.dotnet
set -ag fish_user_paths $HOME/.yarn/bin
set -ag fish_user_paths $HOME/.poetry/bin
set -ag fish_user_paths $HOME/.krew/bin

set -q fisher_path; or set -Ux fisher_path "$HOME/.config/fish"

# Standalone env vars
set -gx EDITOR vim
set -gx BAT_STYLE plain

# Colors
set -x LS_COLORS (vivid generate molokai)


# Go
if type -q go
    set -q GOPATH; or set -Ux GOPATH "$HOME/go"
    set -q GOBIN; or set -Ux GOBIN "$GOPATH/bin"
    set -q GO111MODULE; or set -Ux GO111MODULE on
    set -ag fish_user_paths "$GOBIN"
end

# Colorize manpages using bat
if type -q bat
    set -q MANPAGER; or set -Ux MANPAGER 'sh -c "col -bx | bat --language=man --style=grid --color=always --decorations=always"'
    set -q MANROFFOPT; or set -Ux MANROFFOPT -c
end

# fzf
if type -q fzf
    set -Ux FZF_DEFAULT_OPTS "
        --layout=reverse
        --height=90%
        --prompt='~ ' --pointer='▶' --marker='✓'
        --multi
        --color='hl:148,hl+:154,pointer:032,marker:010,bg+:237,gutter:008'
        --bind='ctrl-y:execute-silent(echo {+} | xclip)'
        --bind='ctrl-a:select-all'
        --bind='?:toggle-preview'
        --bind='ctrl-o:execute(fzf_file_open {+} &> /dev/tty)' --bind='ctrl-v:execute(code {+})'
    "

    if type -q fzf_configure_bindings
        fzf_configure_bindings --directory=\cf --processes=\cp --git_log=\cg --history=\cr
    end

    # Use exa to list files (with colors) if present
    if type -q exa
        set -gx fzf_preview_dir_cmd exa --all --color=always
    end

    set -gx fzf_fd_opts --follow
    # Bind ctrl+h to reload with hidden files
    set -a fzf_dir_opts --bind='ctrl-h:reload(fd --type file --color=always --hidden --follow --exclude .git)'
    # Bind ctrl+x to reload with executable files
    set -a fzf_dir_opts --bind='ctrl-x:reload(fd --type executable --color=always --hidden --follow --exclude .git)'
    # Bind ctrl+d to reload with directories only
    set -a fzf_dir_opts --bind='ctrl-d:reload(fd --type directory --color=always --hidden --follow --exclude .git)'
    # Bind ctrl+f to reload with the default search options
    set -a fzf_dir_opts --bind='ctrl-f:reload(fd --type file --color=always --follow)'
    # Bind ctrl+o to open the current item
    set -a fzf_dir_opts --bind="ctrl-o:execute(nvim {} &> /dev/tty)"

    set -gx fzf_preview_file_cmd fzf_file_preview

    # Use bat to preview files if present
    if not type -q bat
        set -gx fzf_preview_file_cmd cat
    end
    # find -L . \( -path ./.git -prune -path ./node_modules -prune \) -o -print -type f 2> /dev/null
    # Use delta to show git diff when searching through git log
    if type -q delta
        set -gx fzf_git_log_opts --preview='git show {1} | delta'
    end

    # Forgit plugin
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
end

###################################
# Auto add ssh keys at login
###################################
if status --is-login
    setenv SSH_ENV $HOME/.ssh/environment

    if test -n "$SSH_AGENT_PID"
        ps -ef | grep $SSH_AGENT_PID | grep ssh-agent >/dev/null
        if [ $status -eq 0 ]
            add_identities
        end
    else
        if test -f $SSH_ENV
            . $SSH_ENV >/dev/null
        end
        ps -ef | grep $SSH_AGENT_PID | grep -v grep | grep ssh-agent >/dev/null
        if test $status -eq 0
            add_identities
        else
            start_agent
        end
    end

end


###################################
# Keybindings
###################################

bind \cH backward-kill-path-component

###################################
# Aliases
###################################

alias cl clear
alias cf fzf-bcd-widget

###################################
# Sources
###################################

if type -q starship
    eval (starship init fish)
end

source /opt/asdf-vm/asdf.fish

if type -q direnv
    direnv hook fish | source
end

set -gx GPG_TTY (tty)

# fifc
if type -q fifc
    fifc \
        -r '^(pacman|paru)(\\h*\\-S)?\\h+' \
        -s 'pacman --color=always -Ss "$fifc_token" | string match -r \'^[^\\h+].*\'' \
        -e '.*/(.*?)\\h.*' \
        -f "--query ''" \
        -p 'pacman -Si "$fifc_extracted"'

    fifc \
        -r '.*\*{2}.*' \
        -s 'rg --hidden -l --no-messages (string match -r -g \'.*\*{2}(.*)\' "$fifc_commandline")' \
        -p 'batgrep --color --paging=never (string match -r -g \'.*\*{2}(.*)\' "$fifc_commandline") "$fifc_candidate"' \
        -f "--query ''" \
        -o 'batgrep --color (string match -r -g \'.*\*{2}(.*)\' "$fifc_commandline") "$fifc_candidate" | less -R' \
        -O 1
end

if type -q scw
    # Scaleway CLI autocomplete initialization.
    eval (scw autocomplete script shell=fish)
end
