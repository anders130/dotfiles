{
    username,
    pkgs,
    ...
}: {
    programs.hyprland = {
        enable = true;
        xwayland.enable = true;
        package = pkgs.hyprland;
    };

    services.xserver.displayManager.defaultSession = "hyprland";

    home-manager.users.${username} = { config, ... }: {
        xdg.configFile.hypr = {
            source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/hyprland";
            recursive = true;
        };
    };
}
