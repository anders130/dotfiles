{den, ...}: {
    den.aspects.work = {
        includes = with den.aspects; [
            zen-browser.provides.work
            claude.provides.work
            git
            teams
        ];
        nixos.my.teams.browser = "zen-work";
        homeManager.my.git.extraConfig = ''
            [includeIf "gitdir:~/Projects/Work/"]
                path = ~/Projects/Work/.gitconfig
        '';
    };
}
