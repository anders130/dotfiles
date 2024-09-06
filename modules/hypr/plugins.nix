{
    config,
    inputs,
    lib,
    pkgs,
    username,
    ...
}: let
    cfg = config.modules.hypr;
in {
    home-manager.users.${username} = lib.mkIf cfg.enable {
        wayland.windowManager.hyprland = {
            plugins = [
                inputs.split-monitor-workspaces.packages.${pkgs.system}.split-monitor-workspaces
            ];

            extraConfig = /*hyprlang*/ ''
                plugin {
                    split-monitor-workspaces {
                        count = 10
                        keep_focused = 0
                        enable_notifications = 0
                    }
                }
            '';
        };
    };
}
