{
    den.aspects.theming = {
        nixos.stylix.targets.qt.enable = true;
        homeManager.stylix.targets = {
            qt.enable = true;
            kde.enable = false;
        };
    };
}
