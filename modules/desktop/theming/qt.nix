{dots, ...}: {
    den.aspects.theming = {
        includes = [dots.desktop.provides.hidden-apps];
        nixos.stylix.targets.qt.enable = true;
        homeManager = {
            stylix.targets = {
                qt.enable = true;
                kde.enable = false;
            };
            my.desktop.hiddenApps = ["kvantummanager" "qt5ct" "qt6ct"];
        };
    };
}
