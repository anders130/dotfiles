{
    inputs,
    lib,
    pkgs,
    username,
    ...
}: let
    inherit (lib) mkSymlink;
in {
    imports = [inputs.self.modules.nixos.starship];
    hm.imports = with inputs.self.modules.homeManager; [fastfetch atuin starship];
    modules.programs.cli = {
        yazi.enable = true;
    };

    environment = {
        shells = [pkgs.fish];
        systemPackages = with pkgs; [
            lsd # better ls
            nix-output-monitor # prettier nix command outputs
            yt-dlp # youtube downloader
            zoxide # better cd
            fd # better find
        ];
    };
    programs.fish = {
        enable = true;
        interactiveShellInit = /*fish*/''
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
    documentation.man.cache.enable = false; # speeds up rebuilds
    stylix.targets.fish.enable = false;
    users.users.${username}.shell = pkgs.fish;
    hm = {
        programs = {
            bat.enable = true;
            fish = {
                enable = true;
                plugins = map (p: {
                    name = p.pname;
                    inherit (p) src;
                })
                (with pkgs.fishPlugins; [
                    autopair
                    z
                    fzf
                ]);
            };
        };
        xdg.configFile = {
            "fish/extraConfig.fish" = mkSymlink ./config.fish;
            "fish/custom_functions" = mkSymlink ./functions;
            "fish/themes/fish.theme" = mkSymlink ./fish.theme;
            "fish/conf.d/direnv_hook.fish" = mkSymlink ./direnv_hook.fish;
        };
    };
}
