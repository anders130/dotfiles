{
    pkgs,
    lib,
    ...
}: let
    inherit (pkgs) git jq writeShellApplication;

    mkEnabledOption = desc: lib.mkEnableOption desc // {default = true;};
in {
    options.statusline = {
        contextBar = mkEnabledOption "visual context window bar";
        directory = mkEnabledOption "current directory";
        fiveHourLimit = mkEnabledOption "5-hour rate limit";
        gitBranch = mkEnabledOption "git branch name";
        model = mkEnabledOption "model name and context size";
        sevenDayLimit = mkEnabledOption "7-day rate limit";
        tokens = mkEnabledOption "total session token count";
    };

    config = cfg: let
        inherit (lib) boolToString getExe;
        s = cfg.statusline;

        statusline = writeShellApplication {
            name = "claude-statusline";
            runtimeInputs = [git jq];
            text = ''
                SHOW_CONTEXT_BAR=${boolToString s.contextBar}
                SHOW_DIRECTORY=${boolToString s.directory}
                SHOW_FIVE_HOUR=${boolToString s.fiveHourLimit}
                SHOW_GIT_BRANCH=${boolToString s.gitBranch}
                SHOW_MODEL=${boolToString s.model}
                SHOW_SEVEN_DAY=${boolToString s.sevenDayLimit}
                SHOW_TOKENS=${boolToString s.tokens}
            '' + builtins.readFile ./statusline.sh;
        };
    in {
        modules.programs.cli.claude.settings.statusLine = {
            type = "command";
            command = getExe statusline;
        };
    };
}
