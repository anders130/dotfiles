{
    lib,
    username,
    ...
}: {
    home-manager.users.${username} = { config, ... }: {
        xdg.configFile.alacritty = lib.mkSymlink {
            config = config;
            source = "alacritty";
            recursive = true;
        };
    };
}
