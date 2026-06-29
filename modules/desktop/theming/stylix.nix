{config, ...}: let
    inherit (config.flake.lib) style;
in {
    den.aspects.theming = {
        nixos = {pkgs, ...}: {
            stylix = {
                # Theming gtksourceview overrides it, which cascades into a full
                # inkscape recompile every update (inkscape depends on it, and the
                # cursor package pulls inkscape into the system closure).
                targets.gtksourceview.enable = false;
                cursor = {
                    name = "catppuccin-macchiato-dark-cursors";
                    package = pkgs.catppuccin-cursors.macchiatoDark;
                    size = 24;
                };
                fonts = {
                    monospace = {
                        inherit (style.monospace) name;
                        package = style.monospace.package pkgs;
                    };
                    sizes.terminal = style.terminalSize;
                };
                icons = {
                    enable = true;
                    package = pkgs.papirus-icon-theme;
                    dark = "Papirus-Dark";
                    light = "Papirus-Light";
                };
            };
        };
        homeManager = {
            stylix.targets.gtk.enable = true;
            gtk.enable = true;
        };
    };
}
