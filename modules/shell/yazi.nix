{dots, ...}: {
    den.aspects.yazi = {
        includes = [dots.desktop.provides.hidden-apps];
        homeManager = {config, ...}: {
            my.desktop.hiddenApps = ["yazi"];
            programs.yazi = {
                enable = true;
                enableFishIntegration = config.programs.fish.enable;
                shellWrapperName = "y";
                settings.opener.play = [
                    {
                        run = "xdg-open \"$@\"";
                        orphan = true;
                    }
                ];
            };
        };
    };
}
