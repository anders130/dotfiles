{
    lib,
    pkgs,
    username,
    ...
}: {
    programs.hyprland = {
        enable = true;
        xwayland.enable = true;
        package = pkgs.hyprland;
    };

    services.displayManager.defaultSession = "hyprland";

    home-manager.users.${username} = {config, ...}: {
        xdg.configFile.hypr = lib.mkSymlink {
            config = config;
            source = "hypr";
            recursive = true;
        };
    };
}
