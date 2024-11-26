{
    lib,
    pkgs,
    username,
    ...
}: {
    environment.systemPackages = [
        pkgs.alacritty
    ];

    home-manager.users.${username} = {config, ...}: {
        xdg.configFile.alacritty = lib.mkSymlink config ./.;
    };
}
