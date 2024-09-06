{
    config,
    inputs,
    lib,
    pkgs,
    username,
    ...
}: let
    cfg = config.modules.hypr;
in {
    config = lib.mkIf cfg.enable {
        # boot into hyprland
        services.xserver.displayManager.lightdm = {
            enable = true;
            greeter.package = inputs.hyprland.packages.${pkgs.system}.hyprland;
        };

        services.displayManager.autoLogin = {
            enable = true;
            user = username;
        };
    };
}
