{
    den.aspects.starship.nixos = {
        environment.sessionVariables.STARSHIP_CONFIG = "$HOME/.config/starship.toml";
    };
    den.aspects.starship.homeManager = {lib, ...}: {
        stylix.targets.starship.enable = false;
        programs.starship = {
            enable = true;
            enableFishIntegration = true;
            settings = lib.importTOML ./starship.toml;
        };
    };
}
