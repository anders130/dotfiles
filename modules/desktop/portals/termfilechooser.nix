{dots, ...}: {
    dots.desktop.provides.termfilechooser = {
        includes = [dots.desktop.provides.hyprland];
        homeManager = {pkgs, ...}: let
            package = pkgs.xdg-desktop-portal-termfilechooser;
        in {
            xdg.portal = {
                config.hyprland."org.freedesktop.impl.portal.FileChooser" = ["termfilechooser"];
                extraPortals = [package];
            };
            xdg.configFile."xdg-desktop-portal-termfilechooser/config".text = ''
                [filechooser]
                cmd=${package}/share/xdg-desktop-portal-termfilechooser/yazi-wrapper.sh
                default_dir=$HOME/Downloads
            '';
            # float + center the picker window
            my.desktop.windowRules.termfilechooser = {
                matchType = "title";
                match = "'termfilechooser'";
                float = true;
                center = true;
                size = "70% 70%";
            };
        };
    };
}
