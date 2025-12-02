inputs: final: prev: let
    inherit (prev.stdenv.hostPlatform) system;
in {
    inherit (inputs.hyprland.packages.${system}) hyprland;
    hyprlandPlugins = {
        inherit (inputs.hyprsplit.packages.${system}) hyprsplit;
    };
}
