{
    config,
    lib,
    username,
    ...
}: {
    options.modules.programs.cli.starship = {
        enable = lib.mkEnableOption "starship";
    };

    config = lib.mkIf config.modules.programs.cli.starship.enable {
        programs.starship.enable = true;

        environment.sessionVariables.STARSHIP_CONFIG = "$HOME/.config/starship.toml";

        home-manager.users.${username}.programs.starship = {
            enable = true;
            enableFishIntegration = true;
            settings = lib.importTOML ./starship.toml;
        };
    };
}
