{
    config,
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
        unimatrix # ascii art matrix
        zoxide # better cd
    ];

    fishPlugins = with pkgs.fishPlugins; [
        autopair
        z # autosuggestions
    ];

    modulePath = "modules/console/fish";
in {
    options.modules.console.fish = {
        enable = lib.mkEnableOption "fish";
    };

    config = lib.mkIf config.modules.console.fish.enable {
        modules.console.starship.enable = true;

        programs.fish = {
            enable = true;
            package = pkgs.fish;
            shellAliases = {
                ls = "lsd";
                cat = "bat";
                aquarium = "asciiquarium -s -t";
                matrix = "unimatrix -as 98";
            };
            shellInit = /*fish*/''
                if status is-interactive
                    fastfetch -c $HOME/.config/fastfetch/shell-greeting.jsonc
                end
            '';
            interactiveShellInit = /*fish*/''
                source $HOME/.config/fish/extraConfig.fish
            '';
        };

        stylix.targets.fish.enable = false;

        environment.shells = [pkgs.fish];

        users.users.${username}.shell = pkgs.fish;

        home-manager.users.${username} = {config, ...}: {
            stylix.targets.bat.enable = false;
            home.sessionVariables.SHELL = "etc/profiles/per-user/${username}/bin/fish";

            xdg.configFile = {
                "fish/extraConfig.fish" = lib.mkSymlink config {
                    source = "${modulePath}/config.fish";
                };
                "fish/functions" = lib.mkSymlink config {
                    source = "${modulePath}/functions";
                    recursive = true;
                };
                "fish/themes/fish.theme" = lib.mkSymlink config {
                    source = "${modulePath}/themes/fish.theme";
                };
                "bat/themes/bat.tmTheme" = lib.mkSymlink config {
                    source = "${modulePath}/themes/bat.tmTheme";
                };
                "fastfetch/shell-greeting.jsonc" = lib.mkSymlink config {
                    source = "${modulePath}/shell-greeting.jsonc";
                };
            };
        };

        environment.systemPackages = dependencies ++ fishPlugins;
    };
}
