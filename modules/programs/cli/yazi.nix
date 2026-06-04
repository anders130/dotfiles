{
    flake.modules.homeManager.yazi = {config, ...}: {
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
}
