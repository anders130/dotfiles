{lib, ...}: {
    programs.starship.enable = true;

    environment.sessionVariables.STARSHIP_CONFIG = "$HOME/.config/starship.toml";

    hm.programs.starship = {
        enable = true;
        enableFishIntegration = true;
        settings = lib.importTOML ./starship.toml;
    };
}
