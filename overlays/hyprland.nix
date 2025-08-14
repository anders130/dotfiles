inputs: final: prev: {
    inherit (inputs.hyprland.packages.${prev.system}) hyprland;
    hyprlandPlugins = {
        inherit (inputs.split-monitor-workspaces.packages.${prev.system}) split-monitor-workspaces;
    };
}
