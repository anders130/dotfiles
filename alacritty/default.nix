{
    username,
    ...
}: {
    home-manager.users.${username} = { config, ... }: {
        xdg.configFile."alacritty/alacritty.yml".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/alacritty/alacritty.yml";
    };
}
