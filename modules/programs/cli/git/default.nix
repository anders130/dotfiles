{pkgs, ...}: let
    secrets = builtins.fromJSON (builtins.readFile ./secrets.json);
    package = pkgs.git;
in {
    environment = {
        shellAliases.g = "git";
        systemPackages = [package];
    };

    hm.programs = {
        git = {
            inherit package;
            enable = true;
            settings = {
                user = {
                    name = "${secrets.git_credentials.username}";
                    email = "${secrets.git_credentials.email}";
                };
                push = {
                    default = "current";
                    autoSetupRemote = true;
                };
                merge.conflictstyle = "diff3";
                diff.colorMoved = "default";
                alias = {
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
                    ps = "push";
                    pl = "pull";
                    yeet = "push --force-with-lease";
                    yoink = "pull --rebase";
                };
            };
            includes = [
                {
                    path = "~/Projects/Work/.gitconfig";
                    condition = "gitdir:~/Projects/Work/";
                }
                {
                    path = "~/Projects/HSB/.gitconfig";
                    condition = "gitdir:~/Projects/HSB/";
                }
            ];
        };
        # syntax highlighting in diff view
        delta = {
            enable = true;
            options = {
                line-numbers = true;
                side-by-side = true;
                navigate = true;
            };
            enableGitIntegration = true;
        };
    };
}
