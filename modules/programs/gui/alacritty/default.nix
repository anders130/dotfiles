{
    lib,
    pkgs,
    username,
    ...
}: {
    environment.systemPackages = [
        pkgs.alacritty
    ];

    home-manager.users.${username} = {
        xdg.configFile.alacritty = lib.mkSymlink ./.;
    };
}
