-include Makefile.utils

fish: fish-install common-tools fish-setup fish-fzf asdf ##- Installs the fish config
zsh: zsh-install common-tools prezto-install zsh-fzf asdf ##- Installs the zsh config

git:  ##- Setups the git workflow
	$(info Link git config files)
	@mkdir -p $(HOME)/git/pro $(HOME)/git/perso
	@ln --symbolic --force $(current_dir)/git/.gitconfig-home $(HOME)/.gitconfig
	@touch $(HOME)/git/.git-remotes
	@[[ -f $(HOME)/git/perso/.gitconfig ]] || cp $(current_dir)/git/.gitconfig $(HOME)/git/perso/.gitconfig
	@[[ -f $(HOME)/git/pro/.gitconfig ]] || cp $(current_dir)/git/.gitconfig $(HOME)/git/pro/.gitconfig

nvidia: config_path=config/etc/profile.d/after-login.sh

nvidia: tree ##- Enables `ForceFullComposiitonPipeline` at boot to eliminate tearing when using nvidia graphic cards
	$(info Enable force full composition at boot)
	@if ! grep -q $(nvidia) $(current_dir)/config/etc/profile.d/after-login.sh; then \
		echo $(nvidia) >> $(current_dir)/config/etc/profile.d/after-login.sh; \
	fi
	@sudo ln --symbolic --force $(current_dir)/config/etc/profile.d/after-login.sh /etc/profile.d

pacman-aria2: aria2-install ##- Makes pacman using aria2 to speed up downloading
# Adds XferCommand if commented in pacman.conf, or replace it with the new value if it's already set
	$(info Add xfer command in pacman.conf)
	@if ! grep '^XferCommand = .*' /etc/pacman.conf; then \
		sudo sed -i '1h;1!H;$$!d;x;s/.*XferCommand[[:blank:]]*=[[:blank:]]*[^\n]*/&\n\$(xfer_cmd)/' /etc/pacman.conf; \
	else \
		sudo sed -E -i 's/^(XferCommand[[:blank:]]*=[[:blank:]]*).*/\$(xfer_cmd)/' /etc/pacman.conf; \
	fi

fstrim-timer:
	$(info Enable fstrim.timer systemd service)
	@sudo systemctl enable fstrim.timer

asdf:
	@if ! [[ -d $(HOME)/.asdf ]]; then \
		git clone https://github.com/asdf-vm/asdf.git ~/.asdf; \
		cd ~/.asdf; \
		git checkout "$(git describe --abbrev=0 --tags)"; \
	fi
