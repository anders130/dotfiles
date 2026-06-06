{dots, ...}: {
    dots.desktop.provides.nwg-displays = {
        includes = [dots.desktop.provides.hyprland];
        homeManager = {
            lib,
            pkgs,
            ...
        }: {
            home.packages = [pkgs.nwg-displays];
            wayland.windowManager.hyprland.extraConfig = lib.mkAfter ''
                source = ./monitors.conf
            '';
        };
    };
}
