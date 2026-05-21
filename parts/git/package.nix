{
    inputs,
    config,
    ...
}: {
    flake.modules.homeManager.git = {
        home.shellAliases.g = "git";
    };
    perSystem = {
        pkgs,
        lib,
        ...
    }: {
        packages.git = inputs.wrapper-modules.wrappers.git.wrap {
            inherit pkgs;
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
                [includeIf "gitdir:~/Projects/Work/"]
                    path = ~/Projects/Work/.gitconfig
                [includeIf "gitdir:~/Projects/HSB/"]
                    path = ~/Projects/HSB/.gitconfig
            '';
        };
    };
}
