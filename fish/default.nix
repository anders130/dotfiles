{
    username,
    pkgs,
    home-symlink,
    ...
}: {
    programs.fish.enable = true;
    environment.shells = [pkgs.fish];
    environment.sessionVariables.STARSHIP_CONFIG = "/home/${username}/.dotfiles/other/starship.toml";

    users.users.${username}.shell = pkgs.fish;

    home-manager.users.${username} = { config, ... }: {
        home.sessionVariables.SHELL = "etc/profiles/per-user/${username}/bin/fish";

        xdg.configFile."fish/config.fish" = home-symlink { source = "fish/config.fish"; config = config; };
        xdg.configFile."fish/themes" = home-symlink { source = "fish/themes"; recursive = true; config = config; };
    };
}
