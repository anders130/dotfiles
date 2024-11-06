{
    config,
    inputs,
    lib,
    pkgs,
    username,
    ...
}: lib.mkModule config ./. {
    imports = [
        inputs.stylix.nixosModules.stylix
    ];

    options = {
        desktop.enable = lib.mkEnableOption "stylix.desktop";
    };

    config = cfg: {
        home-manager.users.${username} = lib.mkIf cfg.desktop.enable {
            gtk.enable = true;
        };

        stylix = {
            enable = true;
            base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-macchiato.yaml";
            image = ./wallpaper.png;
            cursor = lib.mkIf cfg.desktop.enable {
                name = "catppuccin-macchiato-dark-cursors";
                package = pkgs.catppuccin-cursors.macchiatoDark;
                size = 24;
            };
            fonts = lib.mkIf cfg.desktop.enable {
                monospace = {
                    package = pkgs.nerdfonts.override {fonts = [
                        "CascadiaCode"
                        "CascadiaMono"
                    ];};
                    name = "CaskaydiaCove NF"; # important, because the mono version has tiny symbols
                };
                sizes.terminal = 14;
            };
            polarity = "dark";

            targets.console.enable = false; # deactivate tty styling
        };
    };
}
