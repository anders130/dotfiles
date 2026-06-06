{den, ...}: {
    den.aspects.work = {
        includes = with den.aspects; [
            zen-browser.provides.work
            claude.provides.work
            teams
        ];
        nixos.my.teams.browser = "zen-work";
    };
}
