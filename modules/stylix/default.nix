{
    config,
    lib,
    pkgs,
    ...
}: {
    options = {
        modules.stylix = {
            enable = lib.mkEnableOption "stylix";
            desktop.enable = lib.mkEnableOption "stylix.desktop";
        };
    };

    config = lib.mkIf config.modules.stylix.enable {
        stylix = {
            enable = true;
            base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-macchiato.yaml";
            image = ../../other/wallpaper.png;
            cursor = lib.mkIf config.modules.stylix.desktop.enable {
                name = "Catppuccin-Macchiato-Dark-Cursors";
                package = pkgs.catppuccin-cursors.macchiatoDark;
                size = 24;
            };
            fonts = lib.mkIf config.modules.stylix.desktop.enable {
                monospace = {
                    package = pkgs.nerdfonts.override {fonts = ["CascadiaCode"];};
                    name = "CaskaydiaCove Nerd Font Mono";
                };
            };
            polarity = "dark";

            targets.console.enable = false; # deactivate tty styling
        };
    };
}
