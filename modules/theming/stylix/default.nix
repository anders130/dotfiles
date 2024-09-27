{
    config,
    inputs,
    lib,
    pkgs,
    ...
}: let
    cfg = config.modules.theming.stylix;
in {
    imports = [
        inputs.stylix.nixosModules.stylix
    ];

    options.modules.theming.stylix = {
        enable = lib.mkEnableOption "stylix";
        desktop.enable = lib.mkEnableOption "stylix.desktop";
    };

    config = lib.mkIf cfg.enable {
        stylix = {
            enable = true;
            base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-macchiato.yaml";
            image = ../../../other/wallpaper.png;
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
