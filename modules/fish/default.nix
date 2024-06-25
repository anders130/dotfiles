{
    config,
    inputs,
    lib,
    pkgs,
    username,
    ...
}: let
    dependencies = with pkgs; [
        asciiquarium-transparent # ascii art aquarium
        bat # better cat
        broot # better tree
        fastfetch # system info
        fzf # fuzzy finder
        librespeed-cli # speedtest-cli
        lsd # better ls
        nix-output-monitor # prettier nix command outputs
        starship # shell prompt
        unimatrix # ascii art matrix
        zoxide # better cd
    ];

    fishPlugins = with pkgs.fishPlugins; [
        autopair
        z # autosuggestions
    ];
in {
    imports = [
        inputs.nix-index-database.nixosModules.nix-index
    ];

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
                matrix = "unimatrix -as 98";
            };
        };

        programs.nix-index.enable = true;
        programs.nix-index-database.comma.enable = true;
        programs.command-not-found.enable = false; # nix-index handles this

        environment.shells = [pkgs.fish];
        environment.sessionVariables.STARSHIP_CONFIG = "$FLAKE/other/starship.toml";

        users.users.${username}.shell = pkgs.fish;

        home-manager.users.${username} = {config, ...}: {
            home.sessionVariables.SHELL = "etc/profiles/per-user/${username}/bin/fish";

            xdg.configFile."fish/config.fish" = lib.mkSymlink {
                source = "modules/fish/config.fish";
                config = config;
            };
            xdg.configFile."fish/functions" = lib.mkSymlink {
                source = "modules/fish/functions";
                recursive = true;
                config = config;
            };
            xdg.configFile."fish/themes/fish.theme" = lib.mkSymlink {
                source = "modules/fish/themes/fish.theme";
                config = config;
            };
            xdg.configFile."bat/themes/bat.tmTheme" = lib.mkSymlink {
                source = "modules/fish/themes/bat.tmTheme";
                config = config;
            };
            xdg.configFile."fastfetch/shell-greeting.jsonc" = lib.mkSymlink {
                source = "modules/fish/shell-greeting.jsonc";
                config = config;
            };
        };

        environment.systemPackages = dependencies ++ fishPlugins;
    };
}
