{
    dots.desktop.provides.hidden-apps.homeManager = {lib, ...}: {
        options.my.desktop.hiddenApps = lib.mkOption {
            type = lib.types.listOf lib.types.str;
            default = [];
            description = "App launcher entries to hide (caelestia's launcher.hiddenApps).";
        };
    };
}
