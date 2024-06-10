{
    config,
    lib,
    pkgs,
    self,
    username,
    ...
}: let
    dependencies = with pkgs; [
        asciiquarium-transparent
        bat # better cat
        broot # better tree
        fastfetch # system info
        fzf # fuzzy finder
        librespeed-cli # speedtest-cli
        nix-output-monitor # prettier nix command outputs
        starship # shell prompt
        zoxide # better cd
    ];

    fishPlugins = with pkgs.fishPlugins; [
        autopair
        z # autosuggestions
    ];
in {
    options = {
        modules.fish.enable = lib.mkEnableOption "fish";
    };

    config = lib.mkIf config.modules.fish.enable {
        programs.fish = {
            enable = true;
            package = pkgs.fish;
            shellAliases = {
                ls = "lsd";
                cat = "bat";
                aquarium = "asciiquarium -s -t";
            };
        };

        environment.shells = [pkgs.fish];
        environment.sessionVariables.STARSHIP_CONFIG = "${self}/other/starship.toml";

        users.users.${username}.shell = pkgs.fish;

        home-manager.users.${username} = { config, ... }: {
            home.sessionVariables.SHELL = "etc/profiles/per-user/${username}/bin/fish";

            xdg.configFile."fish/config.fish" = lib.mkSymlink {
                source = "modules/fish/config.fish";
                config = config;
            };
            xdg.configFile."fish/themes" = lib.mkSymlink {
                source = "modules/fish/themes";
                recursive = true;
                config = config;
            };
            xdg.configFile."fish/functions" = lib.mkSymlink {
                source = "modules/fish/functions";
                recursive = true;
                config = config;
            };
        };

        environment.systemPackages = dependencies ++ fishPlugins;
    };
}
