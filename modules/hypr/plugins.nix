{
    config,
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
                (lib.getPkgs pkgs.system "split-monitor-workspaces").split-monitor-workspaces
            ];

            extraConfig = /*hyprlang*/ ''
                plugin {
                    split-monitor-workspaces {
                        count = 10
                        keep_focused = 0
                        enable_notifications = 0
                        enable_persistent_workspaces = 0
                    }
                }
            '';
        };
    };
}
