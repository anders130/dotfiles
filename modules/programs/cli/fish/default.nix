{
    lib,
    pkgs,
    username,
    ...
}: let
    inherit (lib) mkSymlink;
in {
    modules.programs.cli = {
        fastfetch.enable = true;
        starship.enable = true;
        yazi.enable = true;
    };

    environment = {
        shells = [pkgs.fish];
        systemPackages = with pkgs; [
            lsd # better ls
            nix-output-monitor # prettier nix command outputs
            yt-dlp # youtube downloader
            zoxide # better cd
        ];
    };
    programs.fish = {
        enable = true;
        interactiveShellInit = /*fish*/''
            fish_config theme choose "fish"
            source $HOME/.config/fish/extraConfig.fish
            fastfetch -c $HOME/.config/fastfetch/short.jsonc
        '';
        shellAliases = {
            ls = "lsd";
            cat = "bat";
        };
    };
    stylix.targets.fish.enable = false;
    users.users.${username}.shell = pkgs.fish;
    hm = { home.sessionVariables.SHELL = "etc/profiles/per-user/${username}/bin/fish";
        programs = {
            bat.enable = true;
            fish = {
                enable = true;
                plugins = with pkgs.fishPlugins; [
                    {
                        name = "autopair";
                        inherit (autopair) src;
                    }
                    {
                        name = "zoxide";
                        inherit (z) src;
                    }
                ];
            };
        };
        xdg.configFile = {
            "fish/extraConfig.fish" = mkSymlink ./config.fish;
            "fish/functions" = mkSymlink ./functions;
            "fish/themes/fish.theme" = mkSymlink ./fish.theme;
        };
    };
}
