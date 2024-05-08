{
    username,
    pkgs,
    home-symlink,
    inputs,
    ...
}: {
    home-manager.users.${username} = { config, ... }: {
        xdg.configFile.hypr = home-symlink { config = config; source = "hypr"; recursive = true; };

        wayland.windowManager.hyprland = {
            enable = true;
            package = inputs.hyprland.packages.${pkgs.system}.hyprland;
            plugins = [
                inputs.split-monitor-workspaces.packages.${pkgs.system}.split-monitor-workspaces
            ];
            extraConfig = ''
                plugin {
                    split-monitor-workspaces {
                        count = 5
                    }
                }
            '';
        };
    };
}
