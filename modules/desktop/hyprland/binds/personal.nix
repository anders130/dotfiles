{
    den.aspects.desktop.homeManager = {config, ...}: let
        inherit (builtins) concatStringsSep;
        inherit (config.my.desktop.mime) terminal fileManager browser;
        inherit (config.lib.hyprland) hl;
        asString = concatStringsSep " ";
    in {
        my.hyprland.binds = {
            "SUPER + return" = hl.exec_cmd (asString terminal);
            "SUPER + E" = hl.exec_cmd (asString fileManager);
            "SUPER + B" = hl.exec_cmd (asString browser);
            "SUPER + Q" = hl.exec_cmd "qutebrowser";
            "SUPER + ALT + C" = hl.exec_cmd "hyprpicker -a";
            # vim-style movement
            "SUPER + h" = hl.focus {direction = "left";};
            "SUPER + j" = hl.focus {direction = "down";};
            "SUPER + k" = hl.focus {direction = "up";};
            "SUPER + l" = hl.focus {direction = "right";};
            "SUPER + SHIFT + h" = hl.window.move {direction = "left";};
            "SUPER + SHIFT + j" = hl.window.move {direction = "down";};
            "SUPER + SHIFT + k" = hl.window.move {direction = "up";};
            "SUPER + SHIFT + l" = hl.window.move {direction = "right";};
            # personal workflow
            "SUPER + D" = hl.workspace.toggle_special "magic";
            "SUPER + SHIFT + D" = hl.window.move {workspace = "special:magic";};
            "SUPER + G" = hl.workspace.toggle_special "other";
            "SUPER + SHIFT + G" = hl.window.move {workspace = "special:other";};
        };
    };
}
