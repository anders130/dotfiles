{
    secrets,
    username,
    variables,
    pkgs,
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
            aliases = {
                s = "status -s";
                st = "status";
                ci = "commit";
                ciam = "commit --amend --no-edit";
                co = "checkout";
                d = "diff";
                ds = "diff --staged";
                a = "add";
                aa = "add --all";
                lg = "log --pretty=oneline --decorate --graph --abbrev-commit -30";
            };
        };
    };
}
