{dots, ...}: {
    dots.desktop.provides.nwg-displays = {
        includes = [dots.desktop.provides.hyprland];
        homeManager = {pkgs, ...}: {
            # TODO: lua: require("monitors")
            home.packages = [pkgs.nwg-displays];
        };
    };
}
