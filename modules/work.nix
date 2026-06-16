{den, ...}: {
    den.aspects.work = {
        includes = with den.aspects; [
            zen-work
            ai.provides.agents.claude
            ai.provides.agents.github-copilot
            git
            teams
        ];
        nixos.my.teams.browser = "zen-work";
        homeManager.my = {
            ai.agents.claude.work.dir = ".claude-work";
            git.extraConfig = ''
                [includeIf "gitdir:~/Projects/Work/"]
                    path = ~/Projects/Work/.gitconfig
            '';
        };
    };
}
