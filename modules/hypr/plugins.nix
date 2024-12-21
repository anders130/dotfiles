{lib, ...}: {
    hm.wayland.windowManager.hyprland = {
        plugins = [(lib.getPkgs "split-monitor-workspaces").split-monitor-workspaces];

        extraConfig = /*hyprlang*/''
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
}
