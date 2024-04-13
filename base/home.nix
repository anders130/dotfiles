{
    secrets,
    username,
    pkgs,
    ...
}: {
    imports = [
        ../neovim
    ];

    home = {
        stateVersion = "23.11";
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

        git = {
            enable = true;
            package = pkgs.unstable.git;
            delta.enable = true;
            delta.options = {
                line-numbers = true;
                side-by-side = true;
                navigate = true;
            };
            userEmail = "${secrets.git_credentials.email}";
            userName = "${secrets.git_credentials.username}";
            extraConfig = {
                push = {
                    default = "current";
                    autoSetupRemote = true;
                };
                merge = {
                    conflictstyle = "diff3";
                };
                diff = {
                    colorMoved = "default";
                };
            };
        };
    };
}
