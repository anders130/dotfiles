{
    username,
    pkgs,
    home-symlink,
    ...
}: {
    programs.hyprland = {
        enable = true;
        xwayland.enable = true;
        package = pkgs.unstable.hyprland;
    };

    services.xserver.displayManager.defaultSession = "hyprland";

    home-manager.users.${username} = { config, ... }: {
        xdg.configFile.hypr = home-symlink { config = config; source = "hyprland"; recursive = true; };
    };
}
