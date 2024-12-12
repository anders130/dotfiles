{pkgs, ...}: let
    secrets = builtins.fromJSON (builtins.readFile ./secrets.json);
    package = pkgs.git;
in {
    environment.systemPackages = [package];

    hm.programs.git = {
        inherit package;
        enable = true;
        # syntax highlighting in diff view
        delta = {
            enable = true;
            options = {
                line-numbers = true;
                side-by-side = true;
                navigate = true;
            };
        };
        userEmail = "${secrets.git_credentials.email}";
        userName = "${secrets.git_credentials.username}";
        extraConfig = {
            push = {
                default = "current";
                autoSetupRemote = true;
            };
            merge.conflictstyle = "diff3";
            diff.colorMoved = "default";
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
            rt = "restore";
            rts = "restore --staged";
        };
        includes = [
            {
                path = "~/Projects/Work/.gitconfig";
                condition = "gitdir:~/Projects/Work/";
            }
        ];
    };
}
