{
    den.aspects.starship.nixos = {
        environment.sessionVariables.STARSHIP_CONFIG = "$HOME/.config/starship.toml";
    };
    den.aspects.starship.homeManager = {
        config,
        lib,
        ...
    }: {
        stylix.targets.starship.enable = false;
        programs.starship = {
            enable = true;
            enableFishIntegration = config.programs.fish.enable;
            settings = lib.importTOML ./starship.toml;
        };
    };
}
