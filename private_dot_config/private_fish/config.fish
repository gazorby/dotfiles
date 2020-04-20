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

# Go
if type -q go
    set -gx GOPATH "$HOME/go"
    set -gx GOBIN "$GOPATH/bin"
    set -gx GO111MODULE "on"
    set -ag fish_user_paths "$GOBIN"
end

# Colorize manpages using bat
if type -q bat
    if ! set -q MANPAGER; set -Ux MANPAGER 'sh -c "col -bx | bat --language=man --style=grid --color=always --decorations=always"'; end
    if ! set -q MANROFFOPT set -Ux MANROFFOPT '-c'; end
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
    set -x FZF_CTRL_T_OPTS "--preview 'bat --style=numbers --color=always {} | head -500' \
                            $FZF_CUSTOM_OPTIONS"


    # preview directory sub tree
    set -x FZF_ALT_C_OPTS "--preview 'tree -C {} | head -200' $FZF_CUSTOM_OPTIONS"

    # fzf keybindings
    bind \cx 'fzf-complete'

    # fzf aliases
    alias cf 'fzf-bcd-widget'

else if ! test -d $HOME/.fzf
    git clone --depth 1 https://github.com/junegunn/fzf.git $HOME/.fzf
    $HOME/.fzf/install --no-bash --no-zsh --all --64
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
else
    curl -fsSL https://starship.rs/install.sh | bash
end

if test -f $HOME/.asdf/asdf.fish
    source $HOME/.asdf/asdf.fish
else
    git clone https://github.com/asdf-vm/asdf.git $HOME/.asdf
    git --git-dir=$HOME/.asdf/.git checkout (git --git-dir=$HOME/.asdf/.git describe --abbrev=0 --tags)
end
