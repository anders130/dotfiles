{
    den.aspects.atuin.homeManager = {config, ...}: let
        inherit (config.lib.stylix) colors;
    in {
        programs.atuin = {
            enable = true;
            enableFishIntegration = config.programs.fish.enable;
            settings = {
                enter_accept = true;
                filter_mode = "workspace";
                workspaces = true;
                filter_mode_shell_up_key_binding = "session-preload";
                inline_height = 10;
                keymap_mode = "vim-insert";
                theme.name = "stylix";
            };
        };
        xdg.configFile."atuin/themes/stylix.toml".text = ''
            [theme]
            name = "stylix"

            [colors]
            Base = "#${colors.base05}"
            Title = "#${colors.base0D}"
            Important = "#${colors.base0E}"
            Guidance = "#${colors.base0C}"
            Annotation = "#${colors.base04}"
            Muted = "#${colors.base03}"
            AlertInfo = "#${colors.base0B}"
            AlertWarn = "#${colors.base0A}"
            AlertError = "#${colors.base08}"
            SyntaxCommand = "#${colors.base0D}"
            SyntaxFlag = "#${colors.base0A}"
            SyntaxString = "#${colors.base0B}"
            SyntaxVariable = "#${colors.base0E}"
            SyntaxOperator = "#${colors.base0C}"
            SyntaxComment = "#${colors.base03}"
        '';
    };
}
