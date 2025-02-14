{
    lib,
    pkgs,
    username,
    ...
}: let
    dependencies = with pkgs; [
        bat # better cat
        lsd # better ls
        nix-output-monitor # prettier nix command outputs
        yt-dlp # youtube downloader
        zoxide # better cd
    ];

    fishPlugins = with pkgs.fishPlugins; [
        autopair
        z # autosuggestions
    ];
in {
    modules.programs.cli = {
        fastfetch.enable = true;
        starship.enable = true;
    };

    programs.fish = {
        enable = true;
        package = pkgs.fish;
        shellAliases = {
            ls = "lsd";
            cat = "bat";
        };
        shellInit = /*fish*/''
            if status is-interactive
                fastfetch -c $HOME/.config/fastfetch/short.jsonc
            end
        '';
        interactiveShellInit = /*fish*/''
            source $HOME/.config/fish/extraConfig.fish
        '';
    };

    stylix.targets.fish.enable = false;

    environment.shells = [pkgs.fish];

    users.users.${username}.shell = pkgs.fish;

    hm = {
        home.sessionVariables.SHELL = "etc/profiles/per-user/${username}/bin/fish";

        programs.bat.enable = true;

        xdg.configFile = {
            "fish/extraConfig.fish" = lib.mkSymlink ./config.fish;
            "fish/functions" = lib.mkSymlink ./functions;
            "fish/themes/fish.theme" = lib.mkSymlink ./fish.theme;
        };
    };

    environment.systemPackages = dependencies ++ fishPlugins;
}
