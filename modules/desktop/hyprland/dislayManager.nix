{
    lib,
    pkgs,
    username,
    ...
}: let
    inherit (lib) mkDefault;
in {
    services.xserver.displayManager.lightdm = {
        greeter.package = pkgs.hyprland;
        enable = mkDefault true;
    };

    services.displayManager = {
        autoLogin = {
            enable = mkDefault true;
            user = username;
        };
        defaultSession = mkDefault "hyprland";
    };

    security.pam.services = {
        lightdm.enableGnomeKeyring = mkDefault true;
        lightdm-autologin.enableGnomeKeyring = mkDefault true;
    };
}
