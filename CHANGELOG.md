## v4.1.0 (2023-09-02)

### Feat

- **fish**: add bat/nvim abbreviations

### Refactor

- **fish**: add CARGO_INSTALL_ROOT env var
- **fish**: pin enhancd to v2.3.0

## 3.0.0 (2020-10-18)
### Features
- Include hidden system file
- Configure screen size

### Changes
- Only focus on archlinux installation (drop support for other distros)
- Switch back to authy package
- Add PCManFM
- Add geany
- Add gksu
- Add twemoji
- Add pulse default.pa config
- Add install_package setting
- Add pulseeffects presets
- Add variety config
- Add pacman hook to reinstall GDM theme
- Add snapper config
- Add Typora conf
- Add frontend delight tilix theme
- Use VP9 vdpau driver for nvidia
- Add fish-chezmoi fish plugin

## 2.1.2 (2020-08-10)
- 🐛 fix: fix insomnia installation

## 2.1.1 (2020-08-10)
- ✅ tests: configure chezmoi repo

## 2.1.0 (2020-08-10)
- ✨ feat: enable vulkan in chromium
- Revert "✨ feat: enable vulkan in chromium"
- ♻️ refactor: add zero copy flags to chromium
- ♻️ refactor: remove gpu memory buffers flags
- ✨ feat: add basic ufw rules
- ✨ feat: install ufw
- ✨ feat(package): add meld
- ♻️ ref(package): install meld on desktop only
- ✨ feat(arch): add nautilus extensions
- ♻️ ref(arch): nautilus extensions on desktop only
- ✨ feat(package): add gtkhash
- ✨ feat: add more packages
- 🐛 fix(pkgs): fix aur repo links

## 2.0.2 (2020-06-05)
- ♻️ ref(ubuntu): install profile-cleaner last
- ♻️ refactor: (system config): update y/n prompt
- ♻️ refactor: store chromium cache in ram
- ♻️ refactor: same chromium scale for all
- ✨ feat: add option for system config
- ♻️ refactor: (fish): print absolute path using alt+d/alt+shift+d
- ♻️ refactor: add fast scrolling for discord
- ♻️ refactor: disable search engine scrapping in chromium
- ♻️ refactor: add fast scrolling for insomnia

## 2.0.1 (2020-05-27)
- ♻️ ref: more compatibility for debian/fedora
- ✅ test: always clone repo before testing
- ✅ test: fix find install on ubuntu
- ♻️ ref: ensure copr is installed on fedora
- 🐛 fix: fix systemd services
- 🐛 fix: fix avahi install on fedora/ubuntu

## 2.0.0 (2020-05-26)
- ♻️ ref: better compatibility Stop using hostname to differenciate machines and use chezmoi config (chezmoi.toml) to specifiy some caracteristics

## 1.6.0 (2020-05-26)
- 🐛 fix(system script): create dir if not exist
- ♻️ ref(system script): more verbose
- ✨ feat: add network tweaks
- ✨ feat: add journald conf
- ✨ feat: add xorg config for intel graphics
- 👷 chore: update .chezmoiignore
- ✨ feat(system script): add yes/no dialog
- ♻️ ref: use intel graphics only for smallbox
- ♻️ ref: update sysctl conf
- ✨ feat: update ssh conf
- 👷 chore: update .chezmoiignore
- ♻️ ref: update yes/no prompt
- 🐛 fix: fix ssh config
- ♻️ ref: update sshd config
- ✨ feat: add pacman conf for arch/manjaro

## 1.5.0 (2020-05-25)
- ♻️ ref: use templating for fishfile
- ♻️ refactor: update fishfile
- ♻️ refactor: remove exa aliases from config.fish
- ✨ feat: add ghacks config
- ♻️ refactor: update user-overrides.js
- ♻️ refactor: delete mozilla profile folder
- ✨ feat: add fish-exa plugin
- ♻️ refactor: use chromium in psd conf
- ♻️ refactor: chromium flags
- ♻️ refactor: add imwheel systemd service
- ♻️ refactor: update starship config
- ♻️ refactor: use .desktop sepc to start imwheel and protonmail
- ♻️ refactor: don't auotstart imwheel on laptop
- ♻️ refactor: update fzf config
- ♻️ refactor: update fzf config
- ✨ feat: add pulse config
- ♻️ refactor: update imwheelrc config
- ♻️ refactor: update bump config
- ✨ feat: add pulse daemon.conf
- ♻️ refactor: update pulse default.pa
- ♻️ refactor: remove pulse default.pa
- ♻️ refactor: use pulse daemon.conf everywhere
- ♻️ refactor: update chromium flags
- ♻️ refactor: fix chromium scaling
- 🐛 fix: fix line in chromium-flags.conf
- ♻️ refactor: increase scrolling speed on spotify
- ♻️ refactor: update fzf default command
- Revert "♻️ refactor: update fzf default command"
- ♻️ refactor: fzf default cmd don't follow files
- ♻️ refactor: enable wasm on chromium
- ✨ feat: manage files outside home dir
- ✨ feat: add resolved.conf and nsswitch.conf

## 1.4.1 (2020-04-24)
- ✨ feat: initial support for opensuse tumbleweed
- 🐛 fix: typo in .chezmoiignore
- 🐛 fix(chezmoiignore): template syntax

## 1.4.0 (2020-04-24)
- ✨ feat: add neovim
- ♻️ ref: update fishfile
- ♻️ ref: update config.fish
- 🐛 fix: Fix varaible scope for fzf completion
- ✨ feat: Add vim-plug to install script
- ♻️ refactor: auto install vim-plug using init.vim conf
- ♻️ ref: don't reinstall aur packages
- ✨ feat: add starship config
- ♻️ refactor: use templating in config.fish
- 🐛 fix: don't overwrite go env variables
- ♻️ ref(install): updates repositories before installing
- 🐛 ref: install asdf with git, only use homebrew for ubuntu
- ♻️ ref: update asdf sourcing
- ♻️ ref: add asdf completions
- ♻️ ref: try installing starship from repo on fedora

## 1.3.1 (2020-04-22)
- ♻️  ref(install): fix shell syntax
- ♻️ ref(install): remove uninterpreted newline
- ♻️ ref(install): fix newline

## 1.3.0 (2020-04-22)
- ♻️ ref: always ask user before installing
- ✨ feat: ignore install script or homebrew

## 1.2.0 (2020-04-22)
- 🐛 fix: remove git add from precommit hook in bump conf
- ♻️ ref: refactor code
- ♻️ refactor: add linuxbrew bin folder to path
- ♻️ ref: use homebrew
- ♻️ ref: don't use root as default user

## 1.1.1 (2020-04-21)

## 1.1.0 (2020-04-21)
- ♻️ ref: install starship with aur in arch
- ✅ test: add arch image
- 🐛 fix: ensure to install chezmoi using sudo
- 🐛 fix: fix shell syntax
- ♻️ ref: install starship in install script
- ✨ feat: add fzf keybindings
- 🐛 fix: cd ~/ after removing starship build dir
- ♻️ ref: try installing fzf with package manager
- 🐛 fix: enable fzf keybindings on fedora
- ✅ test: spawn a fish shell to test installation
- ✅ test: fix archlinux image
- 🐛 fix: fix watcher function name
- ♻️ ref: install asdf with aur on arch
- ♻️ ref: ensure makepkg deps are installed on arch
- ♻️ ref: handle sourcing logic in config.fish
- 🐛 fix: fix shell syntax
- 🐛 fix: fix arch detection for asdf
- ✅ test: spawn a fish in ubuntu image
- 👷 chore: update .chezmoiignore

## 1.0.0 (2020-04-21)
- Initial commit
- 🐛 fix: add missing quotes
- 👷 chore: add bump.json
- ♻️ ref(bump): use v0.1.0 as initial version
- ♻️ refactor: update bump config
- ♻️ refactor: use exa aliases if exa is detected
- ♻️ refactor: update exa aliases
- ♻️ refactor: check if starship and asdf are present
- ♻️ refactor: remove unused environment variables
- ♻️ refactor: add fzf keybinding if fzf is present
- ♻️ ref: check fzf existence to set fzf alias
- ✨ feat: install starship if not present
- ✨ feat: install asdf if not present
- ✨ feat: install fzf if not present
- ✨ feat: add more distro in install script
- ♻️ ref: use same logic for debian and ubuntu
- ♻️ ref: try installing fzf last
- 🐛 fix: fix infinite loop while installing fzf
- ♻️ refactor: use HOME instead of ~
- ♻️ ref: use bat instead of highlight
- ✨ feat: use bat to colorize man pages
- ♻️ ref(fif): use bat instead of highlight
- ✨ feat: add monitor function
- ✨ feat: add bat to install script
- 🐛 fix: use don't reinstall packages with pacman'
- 🐛 fix: fix typo in install script
- ♻️ ref: update install script
- ♻️ ref: move fzf installation to install script
- 🐛 fix: improve ubuntu installation
- ♻️ ref: move asdf install to install script
- 🐛 fix: asdf install
- ♻️ ref: update fishfile
- ✨ feat: add exa installation for ubuntu
- ♻️ ref: install exa first on ubuntu
- 🐛 fix: fix node installation in ubuntu
- 🐛 fix: fix if template condition
- 🐛 fix: node install again
- 👷 chore: update .chezmoiignore
- ♻️ ref: clean exa files after install
- ✅ test: remove vim installation from test image
- 🐛 fix: install latest fosh version on fedora
- ♻️ ref: assumes yes for fedora commands
- ♻️ ref: assume yes for starship installation
- ♻️ ref: prefer installing fzf with git
- 🐛 fix: ensure find is installed on fedora
- 🐛 fix: fix find installation on fedora
- ✅ test: add fedora image
- 🐛 fix: typo
- ✨ feat: add bump

## 0.1.0 (2020-04-19)
- Initial commit
- 🐛 fix: add missing quotes
