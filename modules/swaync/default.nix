{
    myLib,
    pkgs,
    username,
    ...
}: {
    environment.systemPackages = with pkgs; [
        swaynotificationcenter
        socat # to listen to hyprland events for scritping
    ];

    home-manager.users.${username} = {
        xdg.configFile."swaync" = myLib.mkSymlink ./.;
    };
}
