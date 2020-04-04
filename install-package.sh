#!/usr/bin/env bash

############################################################
# PRIVATE FUNCTIONS
############################################################

# PRIVATE
_lock()             { flock -$1 $LOCKFD; }
_no_more_locking()  { _lock u; _lock xn && rm -f $LOCKFILE; }
_prepare_locking()  { eval "exec $LOCKFD>\"$LOCKFILE\""; }

# PUBLIC
# obtain an exclusive lock immediately or exit
exlock_now() {
    if ! _lock xn; then
        on_exit error "Couldn't acquire the lock!"
        exit 1
    fi
}
exlock()            { _lock x; }   # obtain an exclusive lock
shlock()            { _lock s; }   # obtain a shared lock
unlock()            { _lock u; }   # drop a lock

############################################################
# display script usage
# Arguments
# $1 : Cause that showing up this help
############################################################
function usage() {
    # Empty string if param 1 empty
    local error=${1:-""}
    echo ""
    echo -e "\e[31m$error\e[0m\n"

    echo -e "Usage :\n"
    echo -e "\e[1m\e[33m"./"$PROGNAME".sh"\e[0m [option]"
    echo -e ""
    echo -e "   \e[1m--dep <package list>\e[0m          Try to install a list of packages\n"
    echo -e "   \e[1m--dep-file <file>\e[0m             Try to install all packages listed in file\n"
    echo -e "   \e[1m--fallback -f INSTALL STRING\e[0m  Set a fallback package manager in case the one automatically detected failed\n"
    echo -e "   \e[1m--debug\e[0m                       Run script in debug mode (All executed commands are displayed)\n"
    echo -e "   \e[1m-q --quiet\e[0m                    No output\n"
    echo -e "   \e[1m--logs\e[0m                        Print logs\n"
    echo -e "   \e[1m--lock\e[0m                        Lock the script (only one instance can be executed)\n"
    echo -e "   \e[1m--info\e[0m                        Display OS type, Version and package manager found by the script\n"
    echo -e "   \e[1m--strict\e[0m                      Run script in scrict mode (enable error when trying to expand an unset parameter)\n"
    echo -e "   \e[1m-h --help\e[0m                     Show this help \n"
}

############################################################
# PRIVATE (better to use use shortcuts)
# Display logs
#
# Arguments :
#
#   $1 (required): loglevel
#       - info, warning, error, step and info will be
#         displayed like this : " [colored loglevel] message "
#       - title will show " ==> bold title "
#       - none will only show the message
#       Any other loglevel (except title and none) will be green
#
#   $2 (required): where to write log message
#       - out : display the log immediatly
#       - exit : log will be displayed on script exit
#       - persist : write to a log file
############################################################

function _log () {
    local message="$3"
    local loglevel="$1"
    local where="$2"
    local loglevel_out

    if [[ $loglevel = warning ]]; then
        # Yellow
        loglevel_out="[$YELLOW$loglevel$NORMAL] "
    elif [[ $loglevel = error ]]; then
        # Red
        loglevel_out="[$RED$loglevel$NORMAL] "
    elif [[ $loglevel = step ]]; then
        # Cyan
        loglevel_out="[$CYAN$loglevel$NORMAL] "
    elif [[ $loglevel = none ]]; then
        loglevel_out=""
    elif [[ $loglevel = title && $where != persist ]]; then
        # ==> title
        loglevel_out="\n$BLUE==>$NORMAL "
        message="$BOLD$message$NORMAL"
    elif [[ $loglevel =~ ^info|.*$ ]]; then
        # Green
        loglevel_out="[$GREEN$loglevel$NORMAL] "
    fi

    # output     - [loglevel] message
    if [[ $where = now && $QUIET = 0 ]]; then
        # No newline if info is a step
        if [[ $loglevel = step ]]; then
            echo -ne "$loglevel_out$message "
        else
            echo -e "$loglevel_out$message"
        fi

    # Write logs in temp file which is read on script exit
    elif [[ $where = exit && $QUIET = 0 ]]; then
        # Put 2 space space before each line
        tmp=$(
            echo -e "$message" | sed -e '
                s/^\b/________  ________/g
                s/\n\b/________\n  ________/g
                s/________//g
            '
        )
        echo -e "$loglevel_out\n$tmp\n" >> "$OUT_END"
    fi

    if [[ $LOG = 1 ]]; then
        loglevel=$(sed "s/title/info/g" <<< "$loglevel")
        local date="[$(date '+%Y-%m-%d %H:%M:%S')]"
        touch $LOG_FILE
        echo -e "$date[$loglevel]\t"${@:3}"" >> $LOG_FILE
    fi
}

############################################################
# PUBLIC FUNCTIONS
############################################################

############################################################
# Log shortcut functions
############################################################
info ()         { _log info now "$*"; }
error ()        { _log error now "$*"; }
warning ()      { _log warning now "$*"; }
title ()        { _log title now  "$*"; }
on_exit ()      { _log "$1" exit "${@:2}"; }

############################################################
# Check dependencies
#
# Usage :
# check_dep [install | exit] (package | command-names,.../package-names,...)
#
# You can specify multiple command names or package names by
# separating them with a coma :
#
# check_dep install name1,name2/package1,package2,package3
#
# If name1 is not found, it will test name2 and so on. Same
# for packages.
#
# Arguments :
#   $1 (optionnal): What to do if package isn't installed
#
#           install : try to install it with the package manager
#                     set in $INST variable.
#                     If $INST install failed,
#                     it will try to install with package
#                     found in $INST_FALLBACK if set.
#                     If $INST_FALLBACK install failed, it will exit
#
#           exit    : exit script immediatly
#
#   $2* (required): command-name or command-name/package-name
#
#           if command name and package name are different :
#           check_dep [option] command-name/package-name
#
#           if command-name and package-name are the same
#           check_dep [option] command-name
############################################################
function check_dep () {
    local PARAM=''
    local MISSING_DEP=''
    local name=''
    local command=''
    local command_exist=''
    local fallback_pm=''

    for option in $@; do
        case $option in
            install|exit)
                PARAM=$1
                shift
                ;;

            --)              # End of all options.
                shift
                break
                ;;
            *)               # Default case: No more options, so break out of the loop.
                continue
        esac
    done

    local DEP=$*

    for req in ${DEP}
    do
        command_exist='false'
        if [[ $req == *"/"* ]]; then
            command=${req%/*}
            name=${req##*/}
        else
            command="$req"
            name="$req"
        fi
        for c in ${command//,/ }; do
            # Will bypass aliases
            if command -v $c 2>&1 > /dev/null; then
                command_exist='true'
            fi
        done
        
        if [[ $command_exist = false ]]; then
            MISSING_DEP='true'
            if [[ $PARAM == exit ]]; then
                on_exit error "$name isn't installed !"
            elif [[ $PARAM == install ]]; then
                check_superuser
                for n in ${name//,/ }; do
                    info "$name isn't installed, try installing using $INST";
                    run_as_root $INST "$n"
                    if [[ $? -ne 0 ]]; then
                        if ! [[ $INST_FALLBACK  = "" ]]; then
                            info "trying using $INST_FALLBACK"
                            $INST_FALLBACK "$n"
                            if [[ $? -ne 0 ]]; then
                                INSTALL_FAILURE='true'
                            fi
                        fi
                    fi
                done
            fi
        fi
    done

    if [[ ($MISSING_DEP == true && $PARAM == exit) || $INSTALL_FAILURE == true ]]; then
        exit 1
    fi
    return 0
}

############################################################
# Set the OS and VERSION variables
# OS example : ubuntu, fedora, opensuse etc.
# VERSION example : 18.0.4, 19.10, 29, 30 etc.
# No arguments
############################################################
function get_distro () {
    if type lsb_release >/dev/null 2>&1; then
        # linuxbase.org
        OS=$(lsb_release -si)
        VER=$(lsb_release -sr)
    elif [ -f /etc/lsb-release ]; then
        # For some versions of Debian/Ubuntu without lsb_release command
        . /etc/lsb-release
        OS=$DISTRIB_ID
        VER=$DISTRIB_RELEASE
    elif [ -f /etc/debian_version ]; then
        # Older Debian/Ubuntu/etc.
        OS=Debian
        VER=$(cat /etc/debian_version)
    elif [ -f /etc/os-release ]; then
        # freedesktop.org and systemd
        . /etc/os-release
        OS=$NAME
        VER=$VERSION_ID
    elif [ -f /etc/SuSe-release ]; then
        # Older SuSE/etc.
        ...
    elif [ -f /etc/redhat-release ]; then
        # Older Red Hat, CentOS, etc.
        ...
    else
        # Fall back to uname, e.g. "Linux <version>", also works for BSD, etc.
        OS=$(uname -s)
        VER=$(uname -r)
    fi
}

############################################################
# Set package manager in INST variable based OS and VERSION
# No arguments
############################################################
function set_papckage_manager () {
    get_distro
    if ! [[ -z $OS ]]; then
        # OS=$(echo "$OS" | tr '[:upper:]' '[:lower:]')
        OS=$(toLowerCase $OS)
        if [[ $OS == 'fedora' ]]; then
            INST='dnf install -y'
            REM='dnf remove -y'
        elif [[ $OS =~ ^.*(ubuntu|debian).*$ ]]; then
            INST='apt-get install -y'
            REM='dnf remove -y'
        elif [[ $OS =~ ^.*opensuse.*$ ]]; then
            INST='zypper install -y'
            REM='dnf remove -y'
        elif [[ $OS =~ ^.*manjarolinux.*$ ]]; then
            INST='pacman -S --noconfirm --needed'
            INST_FALLBACK='yay -S --noconfirm --needed'
            REM='pacman -R --noconfirm'
        fi
    fi
}

############################################################
# Validate we have superuser access as root (via sudo if requested)
# OUTS: None
#
# Arguments :
#   $1 (optional) :
#       Set to any value to not attempt root access via sudo
############################################################
function check_superuser() {
    local superuser test_euid
    if [[ $EUID -eq 0 ]]; then
        superuser=true
    elif [[ -z ${1-} ]]; then
        if check_dep sudo; then
            info 'Sudo: Updating cached credentials ...'
            if ! sudo -v; then
                error "Sudo: Couldn't acquire credentials ..." \
                              "${fg_red-}"
            else
                test_euid="$(sudo -H -- "$BASH" -c 'printf "%s" "$EUID"')"
                if [[ $test_euid -eq 0 ]]; then
                    superuser=true
                fi
            fi
        fi
    fi

    if [[ -z ${superuser-} ]]; then
        error 'Unable to acquire superuser credentials.' "${fg_red-}"
        return 1
    fi

    info 'Successfully acquired superuser credentials.'
    return 0
}

############################################################
# Run the requested command as root (via sudo if requested)
# OUTS: None
#
# Arguments :
#   $1 (optional): Set to zero to not attempt execution via sudo
#   $@ (required): Passed through for execution as root user
############################################################
function run_as_root() {
    if [[ $# -eq 0 ]]; then
        on_exit error 'Missing required argument to run_as_root()!' 2
    fi

    local try_sudo
    if [[ ${1-} =~ ^0$ ]]; then
        try_sudo=true
        shift
    fi

    if [[ $EUID -eq 0 ]]; then
        "$@"
    elif [[ -z ${try_sudo-} ]]; then
        sudo -H -- "$@"
    else
        on_exit error "Unable to run requested command as root: $*" 1
    fi
}

# UTILITY FUNCTIONS

############################################################
# Trim whitespace from a string
#
# Arguments :
# $* (required): String to be trimmed
############################################################
function trim() {
    local var="$*"
    # remove leading whitespace characters
    var="${var#"${var%%[![:space:]]*}"}"
    # remove trailing whitespace characters
    var="${var%"${var##*[![:space:]]}"}"
    # remove space whitespace inside string
    var="${var// /}"
    echo -n "$var"
}

############################################################
# Convert a string in LowerCase
#
# Arguments :
# $* (required): String to be converted
############################################################
function toLowerCase () {
    local var=$*
    var=${var,,}
    echo -n "$var"
}

############################################################
# Called on EXIT
# Used to print messages on exit
# Arguments : Exit cause
############################################################
function finalize () {
    title "Script complete!"

    if [[ -f "$OUT_END" ]]; then
        cat "$OUT_END"
    fi

    if [[ $LOG = 1 ]]; then
        cat "$TEMP_DIR"/"temp_log.txt" | sed 's/\t/ -- /g' >> "$LOG_FILE"
        info "See logs in ${LOG_FILE}"
    else
        rm --force "$LOG_FILE"
    fi

    rm --recursive --force --dir "$TEMP_DIR"
    _no_more_locking
}

############################################################
# GLOBAL VARIABLES
############################################################
# Only set when calling get_distro()
OS=''       # OS type
VER=''      # OS version

# Only set when calling set_papckage_manager()
INST=''             # Package manager to use when installing package
INST_FALLBACK=''    # Package manager to use if $INST didn't works
REM=''              # Package manager to use when removing package

# Options
QUIET=0
LOCK=0
LOG=0

# ./name.sh ==> name.sh
PROGNAME=${0##*/}
# name.sh ==> name, and then trim the string
PROGNAME="$(trim ${PROGNAME%.*})"

SCRIPTPATH="$(realpath $0)"
START_DATE="$(date '+%Y-%m-%d--%H:%M:%S')"

LOCKFILE=/tmp/script_lockfile.lock
LOCKFD=99

# Useful paths
TEMP_DIR="$(mktemp -d /tmp/XXXXXXX)"                  # Temporary directory
LOG_FILE=/tmp/log_"$PROGNAME"_["$START_DATE"].txt   # Store logs
OUT_END="$TEMP_DIR/out_end.txt"                     # Store output to display after script execution

# COLORS used in output
NORMAL="\e[0m"
GREEN="\e[32m"
YELLOW="\e[33m"
RED="\e[31m"
BLUE="\e[34m"
CYAN="\e[36m"
BOLD="\e[1m"

priority_options_pattern='@(--debug|-h|--help|--strict|--lock|--logs|-q|--quiet)'

############################################################
# ENTRY POINT
############################################################
# Bash will remember & return the highest exitcode in a chain of pipes.
# This way you can catch the error in case mysqldump fails in `mysqldump |gzip`, for example.
set -o pipefail
# Call finalize when script exit (whatever the return code)
trap 'finalize' EXIT INT TERM
_prepare_locking
exlock_now
set_papckage_manager

# First parsing to priority options
for option in $@; do
    case $option in
        --debug)
            set -x
            ;;
        --strict)
            set -o nounset
            ;;
        -q|--quiet)
            QUIET=1
            ;;
        --logs)
            LOG=1
            ;;
        --lock)
            LOCK=1
            ;;
        -h|--help)
            usage
            exit
            ;;

        --check|-c)
            check_dep exit ${@:2}
            exit
            ;;
        --)              # End of all options.
            shift
            break
            ;;
        *)               # Default case: No more options, so break out of the loop.
            continue
    esac
done

if [[ LOCK = 0 ]]; then
    unlock
fi

# Second parsing
while :; do
    case $1 in
        --fallback|-f)
            INST_FALLBACK=$2
            shift
            ;;

        --dep)
            check_dep install ${@:2}
            shift
            ;;

        --dep-file)
            while IFS= read -r line; do
                check_dep install $line
            done < "$2"
            shift
            ;;

        --info)
            on_exit info "Progname : $PROGNAME\nOS : $OS\nVersion : $VER\nPackage manager : $INST"
            exit
            ;;
        --)              # End of all options.
            shift
            break
            ;;
        -?*)
            usage "Invalid option $1"
            ;;
        *)               # Default case: No more options, so break out of the loop.
            break
    esac
    shift
done

############################################################
# script goes here
############################################################
exit
