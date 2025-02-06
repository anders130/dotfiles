{
    lib,
    pkgs,
    username,
    ...
}: {
    services.xserver.displayManager.lightdm = {
        greeter.package = pkgs.hyprland;
        enable = lib.mkDefault true;
    };

    services.displayManager = {
        autoLogin = {
            enable = lib.mkDefault true;
            user = username;
        };
        defaultSession = lib.mkDefault "hyprland";
    };
}
