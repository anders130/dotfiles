{dots, ...}: {
    den.aspects.theming = {
        includes = [dots.desktop.provides.hidden-apps];
        nixos = {
            stylix.targets.qt.enable = true;
            environment.sessionVariables.QT_QPA_PLATFORMTHEME_QT6 = "qt6ct";
        };
        homeManager = {
            config,
            lib,
            ...
        }: let
            inherit (config.lib.stylix) colors;
            kvconfig = "${config.xdg.configHome}/Kvantum/Base16Kvantum/Base16Kvantum.kvconfig";
        in {
            stylix.targets = {
                qt.enable = true;
                kde.enable = false;
            };
            my.desktop.hiddenApps = ["kvantummanager" "qt5ct" "qt6ct"];
            home.activation.kvantumBlueAccent = lib.hm.dag.entryAfter ["writeBoundary"] ''
                run sed -i 's/${colors.base0E-hex}/${colors.base0D-hex}/g' ${lib.escapeShellArg kvconfig}
            '';
        };
    };
}
