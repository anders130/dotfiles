{
    inputs,
    config,
    ...
}: {
    flake.wrappers.git = {
        pkgs,
        lib,
        ...
    }: {
        imports = [inputs.wrapper-modules.wrapperModules.git];
        runtimePkgs = [pkgs.delta];
        settings = {
            user = {
                inherit (config.meta.owner) name email;
            };
            push = {
                default = "current";
                autoSetupRemote = true;
            };
            merge.conflictstyle = "diff3";
            diff.colorMoved = "default";
            core.pager = lib.getExe pkgs.delta;
            interactive.diffFilter = "${lib.getExe pkgs.delta} --color-only";
            delta = {
                line-numbers = true;
                side-by-side = true;
                navigate = true;
            };
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
        configFile.content = ''
            [include]
                path = ~/.config/git/local.conf
        '';
    };

    den.aspects.git.homeManager = {
        self',
        lib,
        config,
        ...
    }: {
        options.my.git.extraConfig = lib.mkOption {
            type = lib.types.lines;
            default = "";
            description = "Extra git configuration, written to ~/.config/git/local.conf (included by the git wrapper).";
        };
        config = {
            home.shellAliases.g = "git";
            home.packages = [self'.packages.git];
            xdg.configFile."git/local.conf" = lib.mkIf (config.my.git.extraConfig != "") {
                text = config.my.git.extraConfig;
            };
        };
    };
}
