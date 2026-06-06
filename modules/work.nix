{den, ...}: {
    den.aspects.work = {
        includes = with den.aspects; [
            zen-browser.provides.work
            teams
        ];
        nixos.my.teams.browser = "zen-work";
    };
}
