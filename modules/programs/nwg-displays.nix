{
    flake.modules.homeManager.nwg-displays = {
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
