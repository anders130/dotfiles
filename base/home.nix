{
    username,
    variables,
    ...
}: {
    imports = [
        ../neovim
    ];

    home = {
        stateVersion = variables.version;
        username = "${username}";
        homeDirectory = "/home/${username}";

        packages = [];
    };

    programs = {
        home-manager.enable = true;

        lsd = {
            enable = true;
            enableAliases = true;
        };
    };
}
