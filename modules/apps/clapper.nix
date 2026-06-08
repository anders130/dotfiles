{dots, ...}: {
    dots.apps.provides.clapper = {
        includes = [dots.desktop.provides.window-rules];
        homeManager = {pkgs, ...}: {
            home.packages = [pkgs.clapper];
            my.desktop.windowRules.clapper = {
                match = "com.github.rafostar.Clapper";
                opacity = "opaque";
            };
        };
    };
}
