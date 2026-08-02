{
    dots.desktop.provides.hyprland.nixos = {inputs', ...}: {
        nixpkgs.overlays = [
            (_: _: {
                inherit (inputs'.hyprland.packages) hyprland xdg-desktop-portal-hyprland;
            })
        ];
    };
}
