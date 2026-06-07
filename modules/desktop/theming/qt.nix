{config, ...}: let
    inherit (config.flake.lib) style;
in {
    den.aspects.theming.nixos.stylix.targets.qt.enable = false;

    den.aspects.theming.homeManager = {pkgs, ...}: let
        inherit (style) accent;
        variant = style.flavour;

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
        stylix.targets = {
            qt.enable = false;
            kde.enable = false;
        };
        xdg.configFile = {
            "Kvantum/${qtThemeName}".source = "${catppuccinKvantum}/share/Kvantum/${qtThemeName}";
            "Kvantum/kvantum.kvconfig".source = (pkgs.formats.ini {}).generate "kvantum.kvconfig" {
                General.theme = qtThemeName;
            };
        };
    };
}
