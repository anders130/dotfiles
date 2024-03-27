{
    username,
    ...
}: {
    home-manager.users.${username} = { config, ... }: {
        xdg.configFile."alacritty/alacritty.toml".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/alacritty/alacritty.toml";
    };
}
