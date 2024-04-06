{
    username,
    home-symlink,
    ...
}: {
    home-manager.users.${username} = { config, ... }: {
        xdg.configFile.alacritty = home-symlink { config = config; source = "alacritty"; recursive = true; };
    };
}
