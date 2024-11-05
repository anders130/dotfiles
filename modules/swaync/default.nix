{
    config,
    lib,
    pkgs,
    username,
    ...
}: {
    options.modules.swaync = {
        enable = lib.mkEnableOption "swaync";
    };

    config = lib.mkIf config.modules.swaync.enable {
        environment.systemPackages = with pkgs; [
            swaynotificationcenter
            socat # to listen to hyprland events for scritping
        ];

        home-manager.users.${username} = {config, ...}: {
            xdg.configFile."swaync" = lib.mkSymlink config {
                source = ./.;
                recursive = true;
            };
        };
    };
}
