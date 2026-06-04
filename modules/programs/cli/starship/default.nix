{
    flake.modules.nixos.starship = {
        environment.sessionVariables.STARSHIP_CONFIG = "$HOME/.config/starship.toml";
    };
    flake.modules.homeManager.starship = {lib, ...}: {
        stylix.targets.starship.enable = false;
        programs.starship = {
            enable = true;
            enableFishIntegration = true;
            settings = lib.importTOML ./starship.toml;
        };
    };
}
