{
    username,
    pkgs,
    lib,
    config,
    ...
}: let
    secrets = import ./secrets.nix;
in {
    options.modules.console.git = {
        enable = lib.mkEnableOption "git";
    };

    config = lib.mkIf config.modules.console.git.enable {
        environment.systemPackages = [pkgs.unstable.git];

        home-manager.users.${username} = {
            programs.git = {
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
        };
    };
}
