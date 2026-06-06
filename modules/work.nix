{den, ...}: {
    den.aspects.work = {
        includes = with den.aspects; [
            zen-browser.provides.work
            claude
            git
            teams
        ];
        nixos.my.teams.browser = "zen-work";
        homeManager.my = {
            programs.claude.profiles.work = ".claude-work";
            git.extraConfig = ''
                [includeIf "gitdir:~/Projects/Work/"]
                    path = ~/Projects/Work/.gitconfig
            '';
        };
    };
}
