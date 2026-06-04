{inputs, ...}: {
    flake.modules.nixos.fish = {pkgs, ...}: {
        imports = [inputs.self.modules.nixos.starship];
        home-manager.sharedModules = with inputs.self.modules.homeManager; [
            fish
            fastfetch
            atuin
            starship
            yazi
        ];
        environment = {
            shells = [pkgs.fish];
            systemPackages = with pkgs; [
                lsd
                nix-output-monitor
                yt-dlp
                zoxide
                fd
            ];
        };
        programs.fish = {
            enable = true;
            interactiveShellInit = ''
                fish_config theme choose "fish"
                source $HOME/.config/fish/extraConfig.fish
                source ${pkgs.fish}/share/fish/completions/git.fish
                fastfetch -c $HOME/.config/fastfetch/short.jsonc
            '';
            shellAliases = {
                ls = "lsd";
                cat = "bat";
            };
        };
        documentation.man.cache.enable = false;
        stylix.targets.fish.enable = false;
    };

    flake.modules.homeManager.fish = {pkgs, ...}: {
        programs = {
            bat.enable = true;
            fish = {
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
        };
        xdg.configFile = {
            "fish/extraConfig.fish".source = ./config.fish;
            "fish/custom_functions".source = ./functions;
            "fish/themes/fish.theme".source = ./fish.theme;
            "fish/conf.d/direnv_hook.fish".source = ./direnv_hook.fish;
        };
    };
}
