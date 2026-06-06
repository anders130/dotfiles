{
    den.aspects.atuin.homeManager = {config, ...}: {
        programs.atuin = {
            enable = true;
            enableFishIntegration = config.programs.fish.enable;
            settings = {
                enter_accept = true;
                filter_mode = "workspace";
                workspaces = true;
                inline_height = 10;
                keymap_mode = "vim-insert";
            };
        };
    };
}
