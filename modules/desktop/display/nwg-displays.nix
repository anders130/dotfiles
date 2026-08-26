{dots, ...}: {
    dots.desktop.provides.nwg-displays = {
        includes = [dots.desktop.provides.hyprland];
        homeManager = {
            pkgs,
            lib,
            ...
        }: {
            home.packages = [pkgs.nwg-displays];
            wayland.windowManager.hyprland.extraLuaFiles."nwg-displays" = {
                autoLoad = true;
                content = ''pcall(require, "monitors")'';
            };
            wayland.windowManager.hyprland.settings.monitor = lib.mkForce [];
        };
    };
}
