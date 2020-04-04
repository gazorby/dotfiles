# Dotfiles

This is my dotfile repo. I use it to quickly recover my config on a fresh install

- [Dotfiles](#dotfiles)
  - [Dotfiles manager](#dotfiles-manager)
  - [Make targets](#make-targets)
    - [Fish config :](#fish-config)
      - [.gitconfig](#gitconfig)
    - [Pacman and aria2](#pacman-and-aria2)
    - [fstrim-timer](#fstrim-timer)
    - [nvidia](#nvidia)
  - [Custom configuration](#custom-configuration)
    - [ssh](#ssh)
    - [Journald](#journald)
    - [20-intel](#20-intel)
    - [99-sysctl](#99-sysctl)
    - [vlcrc](#vlcrc)
    - [After login script](#after-login-script)
  - [Great tools used :](#great-tools-used)
    - [Fish plugins :](#fish-plugins)
    - [Others :](#others)

## Dotfiles manager

Use `dotfile.py` to link dotfiles under `config/` :

```bash
usage: dotfile.py [-h] [-a PATH [PATH ...]] [-u PATH [PATH ...]] [-d DIRECTORY]

Dotfile utility

optional arguments:
  -h, --help            show this help message and exit
  -a PATH [PATH ...], --add PATH [PATH ...]
                        save a path in dotfile config. PATH can be a full path or a directory. If the latter is used, all files will be recursively added
  -u PATH [PATH ...], --update PATH [PATH ...]
                        recursively update all links from files under PATH. Root permissions will be asked if needed
  -d DIRECTORY, --dotfile DIRECTORY
                        specify dotfile directory
```

## Make targets

`make` is used to install tools and configurations, but not all targets are meant to be used by hand.

Use `make help` to display infos on most useful targets

### Fish config :
  ```bash
  make fish
  ```
  Will try to automatically install all dependencies listed in `dependencies.txt` with your system's packet manager

  If you miss some of the dependencies listed in `dependencies.txt` in your distribution repositories, then it will install rust and compile them from source.
https://github.com/oh-my-fish/plugin-python
  ```bash
  make git
  ```

  This call [tree](#link-config-tree) target before and creates the following structure in your home directory :

  ```console
  ~/
    |
    .gitconfig
    |
    git/
      |
      .git-remotes
      |
      template/
      |
      perso/
        |
        .gitconfig    # to complete with your perso identity
      pro/
        |
        .gitconfig    # to complete with your pro identity
  ```

  This suppose you have the two private keys named like this :

  ```console
  ~/.ssh/
    |
    id_rsa
    id_rsa_pro
    ...
  ```

  The template directory is used by the `gtt` function to init a git repository with the directory tree inside `template` folder.

  I like to separate pro and personal projects by using two private keys. the `.gitconfig` files take care of using the right ssh private key when working on a pro or personal project

  #### .gitconfig
  1) Fill `.gitconfig` files

     Make sure to fill `~/git/perso/.gitconfig` and `~/git/pro/.gitconfig` with your perso / pro identities. I also use auto signing with gpg keys (again, pro and perso), it can be disabled in `~/.gitconfig`

     ```bash
      [user]
        name =
        email =
        signingKey = <GPG key>

      [core]
        autocrlf = input
     ```

1) Fill `.git-remotes` file

    See [fish-git-check-id](https://link)


### Pacman and aria2
  ```bash
  make pacman-aria2
  ```
  Makes pacman using [aria2](https://github.com/aria2/aria2) to download packages

### fstrim-timer
  ```bash
  make fstrim-timer
  ```
  Uses `fstrim-timer` systemd service enable periodic trim on ssd storage

### nvidia
  ```bash
  make nvidia
  ```
  Enables `ForceFullComposiitonPipeline` at boot to eliminate tearing when using nvidia graphic cards

## Custom configuration

Summary of what files inside `config/` do

### ssh

  Uses a fast cipher algo, set alive interval and make all sessions using the same connection

### Journald

  Uses a custom journald config that reduce journal maximum size limit and used memory.

### 20-intel

  Uses common options to improve perf on intel graphics IGPUs

### 99-sysctl

  Reduces swapiness and apply network tweaks

### vlcrc

  Applies compression, an equalizer emphasizing low and high mids, volume normalization plus highest-quality sample rate conversion. (Config from [this gist](https://gist.github.com/ageis/c79ada44c8208f688298bb8437c1d69e))

### After login script

  Symlinks `after-login.sh` in `/etc/profile.d/` to run commands right after login

## Great tools used :

### Fish plugins :
- [pisces](https://github.com/laughedelic/pisces)
- [enhancd](https://github.com/b4b4r07/enhancd)
- [fish-colored-man](https://github.com/decors/fish-colored-man)
- [plugin-git](https://github.com/jhillyerd/plugin-git)
- [plugin-sudope](https://github.com/oh-my-fish/plugin-sudope)
- [plugin-python](https://github.com/oh-my-fish/plugin-python)
- [plugin-direnv](https://github.com/oh-my-fish/plugin-direnv)
- [fish-autols](https://link)
- [fish-git-emojis](https://link)
- [fish-git-check-id](https://link)
- [fish-finders](https://link)



### Others :

  - **Starship**
    The cross-shell prompt for astronauts. https://starship.rs


  - **Exa**

    [exa](https://the.exa.website/) (ls replacement) is an improved file lister with more features and better defaults. It uses colours to distinguish file types and metadata. It knows about symlinks, extended attributes,and Git. And it’s small, fast, and just one single binary.

  - **fd**

    [fd](https://github.com/sharkdp/fd) fd is a simple, fast and user-friendly alternative to [find](https://www.gnu.org/software/findutils/).

  - **ripgrep**

    [ripgrep](https://github.com/BurntSushi/ripgrep) is a line-oriented search tool that recursively searches your current directory for a regex pattern. By default, ripgrep will respect your `.gitignore` and automatically skip  hidden files/directories and binary files.

  - **fzf fuzzy finder**

    [fzf](https://github.com/junegunn/fzf) fuzzy finder is an interactive Unix filter for command-line that can be used with any list; files, command history, processes, hostnames, bookmarks, git commits, etc.
