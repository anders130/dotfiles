{
    dots.desktop.provides.hyprland.homeManager = {config, ...}: let
        inherit (config.lib.stylix) colors;
    in {
        wayland.windowManager.hyprland.settings.config = {
            general = {
                border_size = 3;
                col = {
                    # base0D (blue) at ~93% alpha, base02 (surface1) at ~67%
                    active_border = "rgba(${colors.base0D}ee)";
                    inactive_border = "rgba(${colors.base02}aa)";
                };
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
        };
    };
}
