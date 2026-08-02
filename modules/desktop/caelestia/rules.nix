{
    dots.desktop.provides.caelestia.homeManager = let
        mkLayerRule = namespace: effects: {match.namespace = namespace;} // effects;
        mkWindowRule = match: effects: {inherit match;} // effects;
    in {
        wayland.windowManager.hyprland.settings = {
            layer_rule = [
                (mkLayerRule "hyprpicker" {animation = "fade";})
                (mkLayerRule "selection" {animation = "fade";}) # slurp
                (mkLayerRule "wayfreeze" {animation = "fade";})
                # Fuzzel
                (mkLayerRule "launcher" {animation = "popin 80%";})
                (mkLayerRule "launcher" {blur = true;})
                # Shell
                (mkLayerRule "caelestia-(border-exclusion|area-picker)" {no_anim = true;})
                (mkLayerRule "caelestia-(drawers|background)" {animation = "fade";})
                (mkLayerRule "caelestia-drawers" {blur = true;})
                (mkLayerRule "caelestia-drawers" {ignore_alpha = 0.57;})
            ];
            window_rule = [
                (mkWindowRule {class = "swappy|org.quickshell";} {opaque = true;})
                (mkWindowRule {
                    float = true;
                    xwayland = false;
                } {center = true;})
                (mkWindowRule {class = "org.quickshell|org.pulseaudio";} {float = true;})
            ];
        };
    };
}
