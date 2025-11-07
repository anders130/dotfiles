{
    inputs,
    lib,
    pkgs,
    ...
}: {
    imports = [inputs.stylix.nixosModules.stylix];
    options.desktop.enable = lib.mkEnableOption "stylix.desktop";
    config = cfg: let
        ifDesktop = lib.mkForce cfg.desktop.enable;
    in {
        hm.gtk = {
            enable = ifDesktop;
            iconTheme = {
                package = pkgs.adwaita-icon-theme;
                name = "Adwaita";
            };
        };
        stylix = {
            enable = true;
            base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-macchiato.yaml";
            cursor = lib.mkIf cfg.desktop.enable {
                name = "catppuccin-macchiato-dark-cursors";
                package = pkgs.catppuccin-cursors.macchiatoDark;
                size = 24;
            };
            fonts = lib.mkIf cfg.desktop.enable {
                monospace = {
                    package = pkgs.nerd-fonts.caskaydia-cove;
                    name = "CaskaydiaCove NF"; # important, because the mono version has tiny symbols
                };
                sizes.terminal = 14;
            };
            polarity = "dark";

            targets.console.enable = false; # deactivate tty styling
        };
        # only enable qt for desktop
        qt.enable = ifDesktop;
        hm.qt.enable = ifDesktop;
    };
}
