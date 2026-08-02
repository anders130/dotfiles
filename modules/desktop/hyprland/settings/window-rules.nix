{dots, ...}: {
    dots.desktop.provides.hyprland.includes = [dots.desktop.provides.window-rules];
    dots.desktop.provides.hyprland.homeManager = {
        config,
        lib,
        ...
    }: let
        inherit (lib) mkOption optionalAttrs attrValues;
        default_opacity = "0.85 0.84"; # active and inactive opacity
        blur_opacity = "0.99999997"; # for windows that set their own opacity

        catchAllOpacityRule =
            {match.class = ".*";}
            // (
                if config.my.hyprland.transparency.enable
                then {opacity = default_opacity;}
                else {opaque = true;}
            );
        mkWindowRule = r: let
            effects =
                optionalAttrs (r.opacity == "opaque") {opaque = true;}
                // optionalAttrs (r.opacity == "blur") {opacity = blur_opacity;}
                // optionalAttrs r.float {float = true;}
                // optionalAttrs r.center {center = true;}
                // optionalAttrs r.noScreenShare {no_screen_share = true;}
                // optionalAttrs (r.size != null) {inherit (r) size;};
        in
            {match.${r.matchType} = r.match;} // effects;
        perAppWindowRules = map mkWindowRule (attrValues config.my.desktop.windowRules);
    in {
        options.my.hyprland.transparency.enable = mkOption {
            type = lib.types.bool;
            default = true;
            description = "Whether windows get the default semi-transparent/blur look, vs fully opaque.";
        };
        config.wayland.windowManager.hyprland.settings.window_rule = [catchAllOpacityRule] ++ perAppWindowRules;
    };
}
