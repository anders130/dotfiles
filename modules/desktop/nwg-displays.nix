{
    den.aspects.nwg-displays.homeManager = {
        lib,
        pkgs,
        ...
    }: {
        home.packages = [pkgs.nwg-displays];
        wayland.windowManager.hyprland.extraConfig = lib.mkAfter ''
            source = ./monitors.conf
        '';
    };
}
