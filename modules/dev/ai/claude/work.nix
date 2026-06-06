{den, ...}: {
    den.aspects.claude.provides.work = {
        includes = [den.aspects.claude];
        homeManager.my.programs.claude.profiles.work = ".claude-work";
    };
}
