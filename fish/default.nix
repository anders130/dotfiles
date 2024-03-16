{
    username,
    pkgs,
    ...
}: {
    programs.fish.enable = true;
    environment.shells = [pkgs.fish];
    environment.sessionVariables.STARSHIP_CONFIG = "/home/${username}/.dotfiles/starship.toml";

    users.users.${username}.shell = pkgs.fish;
    
    home-manager.users.${username} = { config, ... }: {
        home.sessionVariables.SHELL = "etc/profiles/per-user/${username}/bin/fish";

        xdg.configFile."./fish/config.fish".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/fish/config.fish";
    };
}
