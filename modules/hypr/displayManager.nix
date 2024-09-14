{
    config,
    lib,
    username,
    ...
}: let
    cfg = config.modules.hypr;
    greeter.package = (lib.getPkgs "hyprland").hyprland;
in {
    config = lib.mkIf cfg.enable {
        # boot into hyprland
        services.xserver.displayManager.lightdm = {
            inherit greeter;
            enable = true;
        };

        services.displayManager = {
            autoLogin = {
                enable = true;
                user = username;
            };
            defaultSession = lib.mkDefault "hyprland";
        };
    };
}
