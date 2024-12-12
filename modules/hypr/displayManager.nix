{
    lib,
    username,
    ...
}: let
    greeter.package = (lib.getPkgs "hyprland").hyprland;
in {
    config = cfg: {
        # boot into hyprland
        services.xserver.displayManager.lightdm = {
            inherit greeter;
            enable = cfg.displayManager.enable;
        };

        services.displayManager = {
            autoLogin = {
                enable = cfg.displayManager.autoLogin.enable;
                user = username;
            };
            defaultSession = lib.mkDefault "hyprland";
        };
    };
}
