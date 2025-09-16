inputs: final: prev: {
    inherit (inputs.hyprland.packages.${prev.system}) hyprland;
    hyprlandPlugins = {
        inherit (inputs.hyprsplit.packages.${prev.system}) hyprsplit;
    };
}
