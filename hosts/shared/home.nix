{
    username,
    variables,
    ...
}: {
    home = {
        stateVersion = variables.version;
        username = "${username}";
        homeDirectory = "/home/${username}";
    };

    programs.home-manager.enable = true;
}
