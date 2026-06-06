{den, ...}: {
    den.aspects.fish = {
        includes = [den.aspects.shell];
        user = {pkgs, ...}: {
            shell = pkgs.fish;
        };
        nixos = {pkgs, ...}: {
            environment.shells = [pkgs.fish];
            programs.fish = {
                enable = true;
                interactiveShellInit = ''
                    fish_config theme choose "fish"
                    source $HOME/.config/fish/extraConfig.fish
                    source ${pkgs.fish}/share/fish/completions/git.fish
                    fastfetch -c $HOME/.config/fastfetch/short.jsonc
                '';
            };
            documentation.man.cache.enable = false;
            stylix.targets.fish.enable = false;
        };

        homeManager = {pkgs, ...}: {
            programs.fish = {
                enable = true;
                plugins = map (p: {
                    name = p.pname;
                    inherit (p) src;
                }) (with pkgs.fishPlugins; [
                    autopair
                    z
                    fzf
                ]);
            };
            xdg.configFile = {
                "fish/extraConfig.fish".source = ./config.fish;
                "fish/custom_functions".source = ./functions;
                "fish/themes/fish.theme".source = ./fish.theme;
                "fish/conf.d/direnv_hook.fish".source = ./direnv_hook.fish;
            };
        };
    };
}
