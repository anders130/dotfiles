{
    # my personal hyprland binds, applied only to my hosts (via the desktop
    # aspect) — kept out of the shared dots.desktop.provides.hyprland preset.
    den.aspects.desktop.homeManager = {config, ...}: let
        inherit (config.my.desktop.defaultPrograms) terminal fileManager browser;
        asString = builtins.concatStringsSep " ";
    in {
        my.hyprland.binds = {
            # program launches (my key choices)
            "SUPER, return" = "exec, ${asString terminal}";
            "SUPER, E" = "exec, ${asString fileManager}";
            "SUPER, B" = "exec, ${asString browser}";
            "SUPER, Q" = "exec, qutebrowser";
            "SUPER ALT, C" = "exec, hyprpicker -a";
            # vim-style movement
            "SUPER, h" = "movefocus, l";
            "SUPER, j" = "movefocus, d";
            "SUPER, k" = "movefocus, u";
            "SUPER, l" = "movefocus, r";
            "SUPER SHIFT, h" = "movewindow, l";
            "SUPER SHIFT, j" = "movewindow, d";
            "SUPER SHIFT, k" = "movewindow, u";
            "SUPER SHIFT, l" = "movewindow, r";
            # personal workflow
            "SUPER, D" = "togglespecialworkspace, magic";
            "SUPER SHIFT, D" = "movetoworkspace, special:magic";
            "SUPER, G" = "togglespecialworkspace, other";
            "SUPER SHIFT, G" = "movetoworkspace, special:other";
        };
    };
}
