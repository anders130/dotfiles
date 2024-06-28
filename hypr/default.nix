{
    lib,
    pkgs,
    username,
    ...
}: {
    environment.systemPackages = with pkgs; [
        unstable.hyprlock # lock screen
        local.hyprsome # awesome-like workspaces
    ];

    programs.hyprland = {
        enable = true;
        xwayland.enable = true;
        package = pkgs.hyprland;
    };

    services.displayManager.defaultSession = "hyprland";

    services.greetd = {
        enable = true;
        settings = rec {
            initial_session = {
                command = "${pkgs.unstable.hyprland}/bin/Hyprland";
                user = username;
            };
            default_session = initial_session;
        };
    };

    home-manager.users.${username} = {config, ...}: {
        xdg.configFile.hypr = lib.mkSymlink {
            config = config;
            source = "hypr";
            recursive = true;
        };
    };
}
