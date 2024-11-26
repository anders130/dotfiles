{
    lib,
    pkgs,
    username,
    ...
}: {
    environment.systemPackages = with pkgs; [
        swaynotificationcenter
        socat # to listen to hyprland events for scritping
    ];

    home-manager.users.${username} = {config, ...}: {
        xdg.configFile."swaync" = lib.mkSymlink config ./.;
    };
}
