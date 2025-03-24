{config, ...}: {
    # terminal file manager
    hm.programs.yazi = {
        enable = true;
        enableFishIntegration = config.hm.programs.fish.enable;
        shellWrapperName = "y";
        settings.opener.play = [
            {
                run = "xdg-open \"$@\"";
                orphan = true;
            }
        ];
    };
}
