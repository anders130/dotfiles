{
    dots.desktop.provides.hyprland.homeManager = {lib, ...}: let
        inherit (lib) mapAttrsToList optionalAttrs;
        mkCurve = name: points: {
            _args = [
                name
                {
                    type = "bezier";
                    inherit points;
                }
            ];
        };
        mkAnim = leaf: speed: bezier: style:
            {
                inherit leaf speed bezier;
                enabled = true;
            }
            // optionalAttrs (style != null) {inherit style;};
    in {
        wayland.windowManager.hyprland.settings = {
            curve = mapAttrsToList mkCurve
            {
                wind = [[0.05 0.9] [0.1 1.05]];
                winIn = [[0.1 1.1] [0.1 1.1]];
                winOut = [[0.3 (-0.3)] [0 1]];
                liner = [[1 1] [1 1]];
            };
            animation = [
                (mkAnim "windows" 6 "wind" "slide")
                (mkAnim "windowsIn" 6 "winIn" "slide")
                (mkAnim "windowsOut" 5 "winOut" "slide")
                (mkAnim "windowsMove" 5 "wind" "slide")
                (mkAnim "border" 1 "liner" null)
                (mkAnim "borderangle" 30 "liner" "loop")
                (mkAnim "fade" 10 "default" null)
                (mkAnim "workspaces" 5 "wind" null)
            ];
        };
    };
}
