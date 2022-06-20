# Install fisher if not already installed
if not type -q fisher; and not set -q _installing_fisher
    set -gx _installing_fisher 1
    curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher update
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

set -q fisher_path; or set -Ux fisher_path "$HOME/.config/fish"

# Standalone env vars
set -gx EDITOR "vim"
set -gx BAT_STYLE "plain"

# Go
if type -q go
    set -q GOPATH; or set -Ux GOPATH "$HOME/go"
    set -q GOBIN; or set -Ux GOBIN "$GOPATH/bin"
    set -q GO111MODULE; or set -Ux GO111MODULE "on"
    set -ag fish_user_paths "$GOBIN"
end

# Colorize manpages using bat
if type -q bat
    set -q MANPAGER; or set -Ux MANPAGER 'sh -c "col -bx | bat --language=man --style=grid --color=always --decorations=always"'
    set -q MANROFFOPT; or set -Ux MANROFFOPT '-c'
end

# fzf
if type -q fzf
    # margin, cycle scrolling, layout, height and color
    # set -gx FZF_DEFAULT_OPTS "--cycle --reverse --height 60% --color 'fg:#bbccdd,fg+:#ddeeff,bg:#1B1C1D,preview-bg:#1B1C1D,border:#778899'"

    # Use mcfly for searching history, fallback to fzf.fish
    # both are ctrl-r binded
    if type -q mcfly
        fzf_configure_bindings --history
        mcfly init fish | source
        set -gx MCFLY_FUZZY 2
        set -gx MCFLY_RESULTS 20
        set -gx MCFLY_INTERFACE_VIEW BOTTOM
    else
        fzf_configure_bindings
    end

    # Use exa to list files (with colors) if present
    if type -q exa
        set -gx fzf_preview_dir_cmd exa --all --color=always
    end

    # Use bat to preview files if present
    if not type -q bat
        set -gx fzf_preview_file_cmd cat
    end

    # Use delta to show git diff when searching through git log
    if type -q delta
        set -gx fzf_git_log_opts --preview='git show {1} | delta'
    end

    # Use ctrl+o when searching paths to open the current item
    set --export fzf_dir_opts --bind "ctrl-o:execute(vim {} &> /dev/tty)"

    # Forgit plugin
    set -g forgit_log glo*
    set -g forgit_diff gd*
    set -g forgit_add ga*
    set -g forgit_reset_head grh*
    set -g forgit_ignore gi*
    set -g forgit_restore gcf*
    set -g forgit_clean gclean*
    set -g forgit_stash_show gss*
    set -g forgit_cherry_pick gcp*
    set -g forgit_rebase grb*
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

alias cl 'clear'
alias cf 'fzf-bcd-widget'

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
