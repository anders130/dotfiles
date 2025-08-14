{
    lib,
    pkgs,
    ...
}: {
    hm.wayland.windowManager.hyprland = {
        plugins = [pkgs.hyprlandPlugins.split-monitor-workspaces];
        extraConfig = lib.toHyprlang {
            plugin.split-monitor-workspaces = {
                count = 10;
                keep_focused = 0;
                enable_notifications = 0;
                enable_persistent_workspaces = 0;
            };
        };
    };
}
