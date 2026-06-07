{config, ...}: let
    inherit (config.flake.lib) style;
in {
    den.aspects.theming = {
        nixos = {pkgs, ...}: {
            stylix = {
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
        homeManager = {config, ...}: {
            stylix.targets.gtk.enable = true;
            gtk = {
                enable = true;
                gtk4.theme = config.gtk.theme;
            };
        };
    };
}
