{inputs, ...}: {
    flake.modules.nixos.desktop = {pkgs, ...}: {
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
            polarity = "dark";
        };
        home-manager.sharedModules = [inputs.self.modules.homeManager.desktop];
    };
    flake.modules.homeManager.desktop = {
        config,
        pkgs,
        ...
    }: {
        stylix.targets.gtk.enable = true;
        gtk = {
            enable = true;
            iconTheme = {
                package = pkgs.adwaita-icon-theme;
                name = "Adwaita";
            };
            gtk4.theme = config.gtk.theme;
        };
    };
}
