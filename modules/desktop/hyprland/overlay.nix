{
    dots.desktop.provides.hyprland.nixos = {inputs', ...}: {
        nixpkgs.overlays = [
            (_: _: {
                inherit (inputs'.hyprland.packages) hyprland;
                hyprlandPlugins = {
                    inherit (inputs'.hyprsplit.packages) hyprsplit;
                };
            })
        ];
    };
}
