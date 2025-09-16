{
    lib,
    pkgs,
    ...
}: {
    hm.wayland.windowManager.hyprland = {
        plugins = [pkgs.hyprlandPlugins.hyprsplit];
        extraConfig = lib.toHyprlang {
            plugin.hyprsplit = {
                num_workspaces = 10;
                persistent_workspaces = false;
            };
        };
    };
}
