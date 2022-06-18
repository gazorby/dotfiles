#!/usr/bin/env sh

BW_UNLOCKED=0
GIT_REPO="${GIT_REPO:-https://github.com/gazorby/dotfiles}"

# Unlock bitwarden vault to retrieve secrets and files
unlock_vault() {
    if [ "$BW_UNLOCKED" = 1 ]; then
        return
    fi
    bw login --apikey
    if [ ! -z ${BW_PASSWORD+x} ]; then
        export BW_SESSION=$(bw unlock --raw $BW_PASSWORD)
    else
        export BW_SESSION=$(bw unlock --raw)
    fi
    # Retrieve bitwarden item
    ITEM=$(bw get item chezmoi)
    ITEM_ID=$(echo $ITEM | jq -r .id)

    BW_UNLOCKED=1
}

# Install chezmoi config
chezmoi init $GIT_REPO

CM_CONFIG_FILE=$(chezmoi data | jq -r .chezmoi.configFile)
CM_WORKING_TREE=$(chezmoi data | jq -r .chezmoi.workingTree)

mkdir -p $(dirname $CM_CONFIG_FILE)
cp -n $CM_WORKING_TREE/chezmoi.default.toml $CM_CONFIG_FILE

IMPORT_SSH_KEY=$(chezmoi data | jq -r .secret_import_ssh_key)
IMPORT_GPG_KEY=$(chezmoi data | jq -r .secret_import_gpg_key)

# Copy ssh private key
if [ "$IMPORT_SSH_KEY" = "true" ]; then
    unlock_vault
    bw get attachment id_rsa --itemid $ITEM_ID --output ~/.ssh/id_rsa
    bw get attachment id_rsa.pub --itemid $ITEM_ID --output ~/.ssh/id_rsa.pub
    chmod 600 ~/.ssh/id_rsa
    chmod 600 ~/.ssh/id_rsa.pub
fi

# Import gpg private key
if [ "$IMPORT_GPG_KEY" = "true" ]; then
    unlock_vault
    bw get attachment gpg_private.key --itemid $ITEM_ID --output ./gpg_private.key
    gpg_passphrase=$(echo $ITEM | jq -r '.fields[] | select(.name == "gpg_passphrase") | .value')
    gpg --import --passphrase $gpg_passphrase --pinentry-mode=loopback gpg_private.key
    rm -f gpg_private.key
fi

chezmoi apply

unset BW_SESSION
unset BW_CLIENTID
unset BW_CLIENTSECRET
unset BW_PASSWORD

if [ "$BW_UNLOCKED" = 1 ]; then
    bw logout
fi
