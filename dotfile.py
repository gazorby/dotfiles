#!/usr/bin/env python

import argparse
import os
from datetime import datetime
from subprocess import call
import sys


PATH_METAVAR = 'PATH'
DIR_METAVAR = 'DIRECTORY'


def update(arg_paths):
    """Symlink all files under arg_path, or link it if it's a file

    Arguments:
        path {str} -- path to lookup
    """
    for arg_path in arg_paths:
        conf_path = os.path.expanduser(os.path.normpath(DOT_DIR + arg_path.replace(os.getenv('USER'), "user")))
        if os.path.isfile(conf_path):
            update_file(conf_path, arg_path)
        else:
            for path in conf_path.split():
                for r, d, f in os.walk(path):
                    for file in f:
                        conf_file = os.path.join(r, file)
                        real_file = os.path.normpath(
                            conf_file
                            .replace(DOT_DIR, "/")
                            .replace("user", os.getenv('USER'))
                        )
                        update_file(conf_file, real_file)


def update_file(conf_file, real_file):
    """Symlink conf_file to real_file

    Arguments:
        conf_file {str} -- symlink source (file from dotfile path)
        real_file {str} -- symlink target (desired location)
    """
    if os.path.exists(real_file):
        # Continue if conf file is already linked
        if (os.path.realpath(real_file) == conf_file):
            return
        # Else backup existing file
        else:
            os.makedirs(DOT_BACKUPS + os.path.dirname(real_file), exist_ok=True)
            mv_to_config(real_file, DOT_BACKUPS + real_file)

    # Create dirs and symlink the file
    if not os.path.exists(os.path.dirname(real_file)):
        if os.access(os.path.dirname(real_file), os.W_OK):
            os.makedirs(os.path.dirname(real_file))
        else:
            call(["sudo", "mkdir", "-p", os.path.dirname(real_file)])
    link_from_config(conf_file, real_file)


def add(arg_path):
    """Add arg_path to dotfiles

    Arguments:
        arg_path {str}  -- Can be a file or a folder
        In the latter, all files under arg_path
        will be linked
    """
    files = []
    for path in arg_path:
        if os.path.isdir(path):
            for r, d, f in os.walk(path):
                for file in f:
                    files.append(os.path.join(r, file))
        else:
            files.append(path)

        for file in files:
            config_path = DOT_DIR + file.replace(os.getenv('USER'), "user")
            # exit if file is already in config path
            if os.path.exists(config_path):
                continue
            # else, move it to config path and link it
            os.makedirs(os.path.dirname(config_path), exist_ok=True)
            mv_to_config(file, config_path)
            link_from_config(config_path, file)


def real_path(conf_path):
    """Get real path from config path

    Arguments:
        config_path {str} -- config path (path under config/)

    Returns:
        str -- the real path
    """
    return (conf_path.replace(DOT_DIR, "")
            .replace("user", os.getenv('USER')))


def link_from_config(src, dest):
    """Link src to dest

    Arguments:
        src {str} -- link source
        dest {str} -- link target
    """
    if os.access(os.path.dirname(dest), os.W_OK):
        os.symlink(src, dest)
    else:
        call(["sudo", "ln", "-s", src, os.path.dirname(dest)])


def mv_to_config(src, dest):
    """Move src to config

    Arguments:
        src {str} -- source location
        dest {str} -- new location
    """
    if os.access(src, os.W_OK):
        os.rename(src, dest)
    else:
        call(["sudo", "mv", src, dest])


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Dotfile utility")
    parser.add_argument('-a', '--add', type=str, nargs='+', metavar=PATH_METAVAR,
                        help="save a path in dotfile config." + " " + PATH_METAVAR + " can be a full path or a directory. If the latter is used, all files will be recursively added")

    parser.add_argument('-u', '--update', type=str, nargs='+', metavar=PATH_METAVAR,
                        help=f"recursively update all links from files under {PATH_METAVAR}. Root permissions will be asked if needed")

    parser.add_argument('-d', '--dotfile', type=str, nargs=1, help="specify dotfile directory", metavar=DIR_METAVAR, default=os.getenv('HOME') + '/.dotfiles')

    args = parser.parse_args()

    global DOT_ROOT, DOT_DIR, DOT_BACKUPS
    DOT_ROOT = args.dotfile[0]

    if not os.path.exists(DOT_ROOT):
        print(f"dotfile path {DOT_ROOT} doesn't exist."
              + " You can set it via DOTFILES environement variable,"
              + " or using --dotfile option",
              file=sys.stderr)
        exit(1)

    DOT_DIR = os.path.join(DOT_ROOT, 'config/')
    DOT_BACKUPS = os.path.join(DOT_ROOT, '.backups/', datetime.now().strftime('%d-%m-%Y--%H:%M:%S'))

    if args.update is not None:
        update(args.update)
    if args.add is not None:
        add(args.add)
