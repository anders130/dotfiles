{
    dots.desktop.provides.hyprland.homeManager = {
        config,
        lib,
        ...
    }: let
        inherit (lib) concatStringsSep;
    in {
        wayland.windowManager.hyprland.settings.config.input = with config.home.keyboard; {
            kb_layout = layout;
            kb_variant = variant;
            kb_model = "";
            kb_options = concatStringsSep "," options;
            kb_rules = "";
            numlock_by_default = true;
            repeat_delay = 250;
            repeat_rate = 25;
            follow_mouse = 1;
            mouse_refocus = 0;
            touchpad.natural_scroll = true;
            sensitivity = 0;
        };
    };
}
