###################################
# Variables
###################################

set default_user $USER

# Sometimes this is not in PATH
set -ag fish_user_paths "$HOME"/.local/bin
set -ag fish_user_paths /lib/passenger/bin
set -ag fish_user_paths /usr/lib/passenger/bin
set -ag fish_user_paths $HOME/.cargo/bin
set -ag fish_user_paths $HOME/.dotnet
set -ag fish_user_paths $HOME/.yarn/bin

# prettier prompt when using pipenv
set -x PIPENV_SHELL_FANCY "false"

# Go
if type -q go
    set -gx GOPATH "$HOME/go"
    set -gx GOBIN "$GOPATH/bin"
    set -gx GO111MODULE "on"
    set -ag fish_user_paths "$GOBIN"
end

# fzf
if type -q fzf
    set -x FZF_DEFAULT_OPTS "--margin 0,1 --layout reverse --height 60%"

    if type -q rg
        set -x FZF_DEFAULT_COMMAND 'rg --files --no-ignore --hidden --follow -g "!{.git,node_modules}/*" 2> /dev/null'
    else
        set -x FZF_DEFAULT_COMMAND 'find -L . \( -path ./.git -prune -path ./node_modules -prune \) -o -print -type f 2> /dev/null'
    end

    # search for a file in the home directory
    if type -q fd
        set -x FZF_ALT_C_COMMAND "fd -t d --full-path './'"
    else
        set -x FZF_ALT_C_COMMAND "find . -type d"
    end

    # search for a file in the current dierctory
    set -x FZF_CTRL_T_COMMAND "$FZF_DEFAULT_COMMAND"

    # preview files on the right side
    set -x FZF_CTRL_T_OPTS "--preview 'highlight -O ansi -l {} 2> /dev/null || cat {} || tree -C {} 2> /dev/null | head -200' \
                            $FZF_CUSTOM_OPTIONS"


    # preview directory sub tree
    set -x FZF_ALT_C_OPTS "--preview 'tree -C {} | head -200' $FZF_CUSTOM_OPTIONS"
end

###################################
# Auto add ssh keys at login
###################################
if status --is-login
    setenv SSH_ENV $HOME/.ssh/environment

    if [ -n "$SSH_AGENT_PID" ]
        ps -ef | grep $SSH_AGENT_PID | grep ssh-agent >/dev/null
        if [ $status -eq 0 ]
            add_identities
        end
    else
        if [ -f $SSH_ENV ]
            . $SSH_ENV >/dev/null
        end
        ps -ef | grep $SSH_AGENT_PID | grep -v grep | grep ssh-agent >/dev/null
        if [ $status -eq 0 ]
            add_identities
        else
            start_agent
        end
    end

end

###################################
# Keybindings
###################################

bind \cx 'fzf-complete'
bind \cH backward-kill-path-component

###################################
# Aliases
###################################

alias cf 'fzf-bcd-widget'

# exa aliases
alias l 'exa'
alias ll 'exa --long --all --group --header'
alias la 'exa --long --all --header --binary --group --links --inode --blocks'
alias ld 'exa --list-dirs'
alias lt 'exa --tree --level'
alias lg 'exa --long --git'
alias le 'exa --long --extended'

alias cl 'clear'

eval (starship init fish)

source ~/.asdf/asdf.fish
