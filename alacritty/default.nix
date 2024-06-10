{
    lib,
    username,
    ...
}: {
    home-manager.users.${username} = { config, ... }: {
        xdg.configFile.alacritty = lib.home-symlink { config = config; source = "alacritty"; recursive = true; };
    };
}
