{
    dots.desktop.provides.hyprland.homeManager = {config, ...}: let
        inherit (config.lib.hyprland) hl;
    in {
        my.hyprland.binds = {
            "SUPER + C" = hl.window.close;
            "SUPER + V" = hl.window.float {action = "toggle";};
            "SUPER + F" = hl.window.fullscreen;
            "SUPER + S" = hl.layout "togglesplit";
            "SUPER + P" = hl.window.pin;
            "SUPER + mouse:272" = {
                dispatch = hl.window.drag;
                opts.mouse = true;
            };
            "SUPER + mouse:273" = {
                dispatch = hl.window.resize null;
                opts.mouse = true;
            };
        };
    };
}
