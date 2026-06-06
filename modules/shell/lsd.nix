{
    den.aspects.shell = {
        nixos = {
            config,
            lib,
            pkgs,
            ...
        }: {
            environment.systemPackages = [pkgs.lsd];
            programs.fish.interactiveShellInit = lib.optionalString config.programs.fish.enable ''
                function ls
                    if test -f .hidden
                        set hidden_args (cat .hidden | xargs -I{} echo --ignore-glob={})
                    end

                    # only hide hidden files if the current command is ls
                    switch (basename (status current-command))
                        case 'ls'
                            command lsd $hidden_args $argv
                        case '*'
                            command lsd $argv
                    end
                end
            '';
        };
        homeManager.home.shellAliases.ls = "lsd";
    };
}
