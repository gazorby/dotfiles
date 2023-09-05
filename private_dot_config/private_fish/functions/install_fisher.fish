function install_fisher -d "Install fisher if not already installed"
    if not type -q fisher; and not set -q _installing_fisher
        set -l fisher_url https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish
        set -gx _installing_fisher 1
        if test -f "$__fish_config_dir/fish_plugins"
            cp "$__fish_config_dir/fish_plugins" "$__fish_config_dir/fish_plugins.tmp"
            curl -sL "$fisher_url" | source && fisher install jorgebucaran/fisher
            cp "$__fish_config_dir/fish_plugins.tmp" "$__fish_config_dir/fish_plugins"
            fisher update
            rm "$__fish_config_dir/fish_plugins.tmp"
        else
            curl -sL "$fisher_url" | source && fisher install jorgebucaran/fisher
        end

        set -e _installing_fisher
    end
end
