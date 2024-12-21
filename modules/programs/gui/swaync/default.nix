{
    lib,
    pkgs,
    ...
}: {
    environment.systemPackages = with pkgs; [
        swaynotificationcenter
        socat # to listen to hyprland events for scritping
    ];

    hm.xdg.configFile."swaync" = lib.mkSymlink ./.;
}
