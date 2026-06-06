{dots, ...}: {
    dots.desktop.provides.hyprland.includes = [dots.desktop.provides.window-rules];
    dots.desktop.provides.hyprland.homeManager = {
        config,
        lib,
        ...
    }: {
        wayland.windowManager.hyprland.settings = {
            general = {
                border_size = 3;
                "col.active_border" = "rgba(8aadf4ee)";
                "col.inactive_border" = "rgba(494d64aa)";
            };
            decoration = {
                blur = {
                    enabled = true;
                    ignore_opacity = true;
                    size = 10;
                    passes = 3;
                    brightness = 1;
                    contrast = 1.1;
                    noise = 1.17e-2;
                    new_optimizations = true;
                    xray = true;
                    popups = true;
                    popups_ignorealpha = 0.15;
                };
                shadow.enabled = false;
            };
            animations = {
                enabled = true;
                bezier = [
                    "wind, 0.05, 0.9, 0.1, 1.05"
                    "winIn, 0.1, 1.1, 0.1, 1.1"
                    "winOut, 0.3, -0.3, 0, 1"
                    "liner, 1, 1, 1, 1"
                ];
                animation = [
                    "windows, 1, 6, wind, slide"
                    "windowsIn, 1, 6, winIn, slide"
                    "windowsOut, 1, 5, winOut, slide"
                    "windowsMove, 1, 5, wind, slide"
                    "border, 1, 1, liner"
                    "borderangle, 1, 30, liner, loop"
                    "fade, 1, 10, default"
                    "workspaces, 1, 5, wind"
                ];
            };
            misc = {
                force_default_wallpaper = 0;
                disable_hyprland_logo = 1;
                session_lock_xray = 1;
            };
            windowrule = let
                # active and inactive opacity
                default_opacity = "0.85 0.84";
                # for windows that set their own opacity
                blur_opacity = "0.99999997";
                mkAttrs = r:
                    lib.concatStringsSep ", " (
                        lib.optional (r.opacity == "opaque") "opaque true"
                        ++ lib.optional (r.opacity == "blur") "opacity ${blur_opacity}"
                        ++ lib.optional r.float "float true"
                        ++ lib.optional r.center "center true"
                        ++ lib.optional r.noScreenShare "no_screen_share true"
                        ++ lib.optional (r.size != null) "size ${r.size}"
                    );
                mkRule = r: "match:${r.matchType} ${r.match}, ${mkAttrs r}";
            in
                [
                    # make everything transparent; per-app rules come from the port
                    "match:class .*, opacity ${default_opacity}"
                ]
                ++ map mkRule (lib.attrValues config.my.desktop.windowRules);
        };
    };
}
