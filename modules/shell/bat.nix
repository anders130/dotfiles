{
    den.aspects.shell.homeManager = {
        programs.bat.enable = true;
        home.shellAliases.cat = "bat";
        # render man pages with bat
        home.sessionVariables = {
            MANPAGER = "sh -c 'col -bx | bat -l man -p'";
            MANROFFOPT = "-c";
        };
    };
}
