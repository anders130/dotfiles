{
    lib,
    pkgs,
    username,
    ...
}: {
    environment.systemPackages = [
        pkgs.unstable.alacritty
    ];

    home-manager.users.${username} = {config, ...}: {
        xdg.configFile.alacritty = lib.mkSymlink {
            config = config;
            source = "alacritty";
            recursive = true;
        };
    };
}
