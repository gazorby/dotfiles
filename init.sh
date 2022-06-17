#!/usr/bin/env sh

bw login --apikey

if [ ! -z ${BW_PASSWORD+x} ]; then
    export BW_SESSION=$(bw unlock --raw $BW_PASSWORD)
else
    export BW_SESSION=$(bw unlock --raw)
fi

item=$(bw get item chezmoi)
item_id=$(echo $item | jq -r .id)

bw get attachment id_rsa --itemid $item_id --output ~/.ssh/id_rsa
bw get attachment id_rsa.pub --itemid $item_id --output ~/.ssh/id_rsa.pub

chezmoi init https://github.com/gazorby/dotfiles

CM_CONFIG_FILE=$(chezmoi data | jq -r .chezmoi.configFile)
CM_WORKING_TREE=$(chezmoi data | jq -r .chezmoi.workingTree)

cp $CM_WORKING_TREE/chezmoi.toml.example $CM_CONFIG_FILE

chezmoi apply

unset BW_SESSION
