inputs: final: prev: {
    inherit (inputs.hyprland.packages.${prev.system}) hyprland;
}
