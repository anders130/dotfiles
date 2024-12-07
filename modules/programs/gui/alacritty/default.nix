{
    lib,
    pkgs,
    ...
}: {
    environment.systemPackages = [
        pkgs.alacritty
    ];

    hm.xdg.configFile.alacritty = lib.mkSymlink ./.;
}
