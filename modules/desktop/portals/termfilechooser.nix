{
    den,
    dots,
    ...
}: {
    den.aspects.termfilechooser = {
        includes = [
            dots.desktop.provides.hyprland
            den.aspects.yazi
        ];
        nixos = {pkgs, ...}: {
            xdg.portal = {
                config.hyprland."org.freedesktop.impl.portal.FileChooser" = ["termfilechooser"];
                extraPortals = [pkgs.xdg-desktop-portal-termfilechooser];
            };
        };
        homeManager = {pkgs, ...}: let
            package = pkgs.xdg-desktop-portal-termfilechooser;
        in {
            xdg.configFile."xdg-desktop-portal-termfilechooser/config".text = ''
                [filechooser]
                cmd=${package}/share/xdg-desktop-portal-termfilechooser/yazi-wrapper.sh
                default_dir=$HOME/Downloads
            '';
            # float + center the picker window
            my.desktop.windowRules.termfilechooser = {
                matchType = "initial_title";
                match = "termfilechooser";
                float = true;
                center = true;
                size = "monitor_w*0.7 monitor_h*0.7";
            };
        };
    };
}
