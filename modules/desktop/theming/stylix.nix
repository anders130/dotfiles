{
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
                        package = pkgs.nerd-fonts.caskaydia-cove;
                        name = "CaskaydiaCove NF"; # important, because the mono version has tiny symbols
                    };
                    sizes.terminal = 14;
                };
                icons = {
                    enable = true;
                    package = pkgs.papirus-icon-theme;
                    dark = "Papirus-Dark";
                    light = "Papirus-Light";
                };
                polarity = "dark";
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
