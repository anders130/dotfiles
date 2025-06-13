{pkgs, ...}: let
    package = pkgs.xdg-desktop-portal-termfilechooser;
in {
    xdg.portal = {
        config.hyprland."org.freedesktop.impl.portal.FileChooser" = ["termfilechooser"];
        extraPortals = [package];
    };

    hm.xdg.configFile."xdg-desktop-portal-termfilechooser/config".text = ''
        [filechooser]
        cmd=${package}/share/xdg-desktop-portal-termfilechooser/yazi-wrapper.sh
        default_dir=$HOME/Downloads
    '';
}
