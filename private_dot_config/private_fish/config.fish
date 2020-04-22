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
set -ag fish_user_paths /home/linuxbrew/.linuxbrew/bin
set -ag fish_user_paths $HOME/.linuxbrew/bin

set -gx EDITOR "nvim"

# Go
if type -q go
    set -Ux GOPATH "$HOME/go"
    set -Ux GOBIN "$GOPATH/bin"
    set -Ux GO111MODULE "on"
    set -ag fish_user_paths "$GOBIN"
end

# Colorize manpages using bat
if type -q bat
    if ! set -q MANPAGER; set -Ux MANPAGER 'sh -c "col -bx | bat --language=man --style=grid --color=always --decorations=always"'; end
    if ! set -q MANROFFOPT set -Ux MANROFFOPT '-c'; end
end

# fzf
if type -q fzf
    # Default command
    if type -q rg
        set -gx FZF_DEFAULT_COMMAND 'rg --files --hidden --follow -g "!**/{.git,node_modules}/**" 2> /dev/null'
    else
        set -gx FZF_DEFAULT_COMMAND 'find -L . \( -path ./.git -prune -path ./node_modules -prune \) -o -print -type f 2> /dev/null'
    end

    # search for a file in the home directory
    if type -q fd
        set -gx FZF_ALT_C_COMMAND "fd -t d --full-path './'"
    else
        set -gx FZF_ALT_C_COMMAND "find . -type d"
    end
    # search for a file in the current dierctory
    set -gx FZF_CTRL_T_COMMAND "$FZF_DEFAULT_COMMAND"

    # margin, height and color
    set -gx FZF_DEFAULT_OPTS "--margin 0,1 --layout reverse --height 60% --color 'fg:#bbccdd,fg+:#ddeeff,bg:#334455,preview-bg:#223344,border:#778899'"
    # preview files on the right side
    set -gx FZF_CTRL_T_OPTS "--preview 'bat --style=numbers --color=always {} | head -500'"
    # preview directory sub tree
    set -gx FZF_ALT_C_OPTS "--preview 'exa --tree --level 3 {} | head -200'"

    # jethrokuan/fzf fish plugin
    set -gx FZF_FIND_FILE_COMMAND 'rg --files --hidden --follow -g "!**/{.git,node_modules}/**" . \$dir 2> /dev/null'
    set -gx FZF_OPEN_COMMAND "$FZF_FIND_FILE_COMMAND"
    set -gx FZF_CD_COMMAND "fd -t d --full-path './'"
    set -gx FZF_CD_WITH_HIDDEN_COMMAND "fd -t d --hidden --full-path './'"
    set -gx FZF_PREVIEW_DIR_CMD "exa --tree --level 3"
    set -gx FZF_PREVIEW_FILE_CMD "bat --style=numbers --color=always"
    set -gx FZF_ENABLE_OPEN_PREVIEW 1
    if ! set -q FZF_COMPLETE; set -Ux FZF_COMPLETE 3; end

    # fzf-complete with ctrl+x
    bind \cx 'fzf-complete'

    alias cf 'fzf-bcd-widget'

    # Enable keybindings on fedora
    if test -f /usr/share/fzf/shell/key-bindings.fish
        source /usr/share/fzf/shell/key-bindings.fish
    end
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
# Auto add fisher and plugins
# on a fresh install
###################################
if not functions -q fisher
    set -q XDG_CONFIG_HOME; or set XDG_CONFIG_HOME $HOME/.config
    curl https://git.io/fisher --create-dirs -sLo $XDG_CONFIG_HOME/fish/functions/fisher.fish
    fish -c fisher
end

###################################
# Keybindings
###################################

bind \cH backward-kill-path-component

###################################
# Aliases
###################################

# exa aliases
if type -q exa
    alias l 'exa'
    alias ll 'exa --long --all --group --header'
    alias la 'exa --long --all --header --binary --group --links --inode --blocks'
    alias ld 'exa --list-dirs'
    alias lt 'exa --tree --level'
    alias lg 'exa --long --header --git'
    alias le 'exa --long --header --extended'
else
    alias l 'ls'
    alias ll 'ls --all --color -l --human-readable'
    alias la 'ls --all --color -l --human-readable --inode'
    alias ld 'ls --all --color -l --human-readable --directory'
end

alias cl 'clear'

if type -q starship
    eval (starship init fish)
end

if test -f $HOME/.asdf/asdf.fish
    source $HOME/.asdf/asdf.fish
else if test -f /opt/asdf-vm/asdf.fish
    source /opt/asdf-vm/asdf.fish
end
