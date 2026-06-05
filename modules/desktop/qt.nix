{
    # stylix's system qt target enables nixos qt (platformTheme qt5ct) which
    # fights HM's kvantum; turn it off so home-manager owns qt theming.
    den.aspects.desktop.nixos.stylix.targets.qt.enable = false;

    den.aspects.desktop.homeManager = {pkgs, ...}: let
        accent = "blue";
        variant = "macchiato";

        catppuccinKvantum = pkgs.catppuccin-kvantum.override {
            inherit accent variant;
        };

        qtThemeName = "catppuccin-${variant}-${accent}";
    in {
        home.packages = [catppuccinKvantum];
        qt = {
            enable = true;
            platformTheme.name = "kvantum";
            style.name = "kvantum";
        };
        # let kvantum own qt theming; stylix's qt + kde (kdeglobals) targets
        # would otherwise fight it
        stylix.targets.qt.enable = false;
        stylix.targets.kde.enable = false;
        xdg.configFile = {
            "Kvantum/${qtThemeName}".source = "${catppuccinKvantum}/share/Kvantum/${qtThemeName}";
            "Kvantum/kvantum.kvconfig".source = (pkgs.formats.ini {}).generate "kvantum.kvconfig" {
                General.theme = qtThemeName;
            };
        };
    };
}
