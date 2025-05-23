{pkgs, ...}: let
    accent = "blue";
    variant = "macchiato";

    catppuccinKvantum = pkgs.catppuccin-kvantum.override {
        inherit accent variant;
    };

    qtThemeName = "catppuccin-${variant}-${accent}";
in {
    hm = {
        home.packages = [catppuccinKvantum];
        qt = {
            enable = true;
            platformTheme.name = "kvantum";
            style.name = "kvantum";
        };
        stylix.targets.qt.enable = false;
        xdg.configFile = {
            "Kvantum/${qtThemeName}".source = "${catppuccinKvantum}/share/Kvantum/${qtThemeName}";
            "Kvantum/kvantum.kvconfig".source = (pkgs.formats.ini {}).generate "kvantum.kvconfig" {
                General.theme = qtThemeName;
            };
        };
    };
}
