#!/bin/sh
# Template script executed once at init by run_once_init.tmpl.
# chezmoi execute run_once* scripts if content after template execution has changed,
# meaning that template execution is ran on each `chezmoi apply`,
# and chezmoi will want to use bitwarden cli each time, which takes more time and require the vault to be unlocked.
# To avoid this, we call this script using `chezmoi execute-template` in run_once_init.tmpl,
# so run_once_init.tmpl content never change once templated.

# Directories
mkdir -p "$HOME/.local/chezmoi_system"

# ssh
mkdir -p "$HOME/.ssh/sockets"
echo -e {{ bitwardenAttachment .bw_ssh_private_key_filename (bitwarden "item" .bw_chezmoi_item_name).id | quote }} > ~/.ssh/{{- .bw_ssh_private_key_filename }}
echo -e {{ bitwardenAttachment .bw_ssh_public_key_filename (bitwarden "item" .bw_chezmoi_item_name).id | quote }} > ~/.ssh/{{- .bw_ssh_public_key_filename }}
chmod 600 ~/.ssh/{{- .bw_ssh_private_key_filename }}
chmod 600 ~/.ssh/{{- .bw_ssh_public_key_filename }}

# gpg
echo -e {{ bitwardenAttachment .bw_gpg_private_key_filename (bitwarden "item" .bw_chezmoi_item_name).id | quote }} > ./{{- .bw_gpg_private_key_filename }}
gpg --import --passphrase {{ (bitwardenFields "item" (bitwarden "item" .bw_chezmoi_item_name).id).gpg_passphrase.value | quote }} --pinentry-mode=loopback ./{{- .bw_gpg_private_key_filename }}
rm -f ./{{- .bw_gpg_private_key_filename -}}
