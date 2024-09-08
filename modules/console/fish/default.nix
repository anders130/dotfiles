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

    modulePath = "modules/console/fish";
in {
    imports = [
        inputs.nix-index-database.nixosModules.nix-index
    ];

    options.modules.console.fish = {
        enable = lib.mkEnableOption "fish";
    };

    config = lib.mkIf config.modules.console.fish.enable {
        programs.fish = {
            enable = true;
            package = pkgs.fish;
            shellAliases = {
                ls = "lsd";
                cat = "bat";
                aquarium = "asciiquarium -s -t";
                matrix = "unimatrix -as 98";
            };
            interactiveShellInit = /*fish*/''
                source $FLAKE/${modulePath}/config.fish
            '';
        };

        stylix.targets.fish.enable = false;

        programs.nix-index.enable = true;
        programs.nix-index-database.comma.enable = true;
        programs.command-not-found.enable = false; # nix-index handles this

        environment.shells = [pkgs.fish];
        environment.sessionVariables.STARSHIP_CONFIG = "$FLAKE/${modulePath}/starship.toml";

        users.users.${username}.shell = pkgs.fish;

        home-manager.users.${username} = {config, ...}: let
            mkSymlink = args: lib.mkSymlink (args // {inherit config;});
        in {
            stylix.targets.bat.enable = false;
            home.sessionVariables.SHELL = "etc/profiles/per-user/${username}/bin/fish";

            xdg.configFile."fish/functions" = mkSymlink {
                source = "${modulePath}/functions";
                recursive = true;
            };
            xdg.configFile."fish/themes/fish.theme" = mkSymlink {
                source = "${modulePath}/themes/fish.theme";
            };
            xdg.configFile."bat/themes/bat.tmTheme" = mkSymlink {
                source = "${modulePath}/themes/bat.tmTheme";
            };
        };

        environment.systemPackages = dependencies ++ fishPlugins;
    };
}
