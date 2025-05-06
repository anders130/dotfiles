{
    config,
    lib,
    pkgs,
    ...
}: let
    font_family = config.stylix.fonts.monospace.name;

    colors = with config.lib.stylix.colors; {
        base = base00;
        blue = base0D;
        transparent = "rgba(0, 0, 0, 0)";

        check_color = "rgba(${base0D-rgb-r}, ${base0D-rgb-g}, ${base0D-rgb-b}, 0.4)";
        fail_color = "rgba(${base08-rgb-r}, ${base08-rgb-g}, ${base08-rgb-b}, 0.4)";
        font_color = "rgb(${base05})";
        capslock_color = "rgba(${base0A-rgb-r}, ${base0A-rgb-g}, ${base0A-rgb-b}, 0.4)";
        font_color_hex = base05;
    };
in {
    options.mainMonitor = lib.mkOption {
        type = lib.types.str;
        description = "The main monitor";
    };
    config = cfg: let
        monitor = cfg.mainMonitor;
    in {
        hm.stylix.targets.hyprlock.enable = false;
        hm.programs.hyprlock = {
            package = pkgs.unstable.hyprlock;
            enable = true;
            settings = {
                general.hide_cursor = true;

                # only enable if fingerprint is enabled on the host
                auth.fingerprint.enabled = config.services.fprintd.enable;

                background = [{
                    monitor = ""; # all monitors
                    path = "$HOME/.config/hypr/wallpaper.png";
                    blur_passes = 5;
                    blur_size = 3;
                    brightness = 0.5;
                    color = "rgb(${colors.base})"; # fallback to color if image is not found
                }];

                label = [
                    {
                        inherit monitor;
                        inherit font_family;
                        color = colors.font_color;
                        text = ''cmd[update:30000] echo "$(date +"%R")"'';
                        font_size = 90;
                        position = "0, 80";
                        halign = "center";
                        valign = "center";
                    }
                    {
                        inherit monitor;
                        inherit font_family;
                        color = colors.font_color;
                        text = ''cmd[update:43200000] echo "$(date +"%A, %d %B %Y")"'';
                        font_size = 20;
                        position = "0, 0";
                        halign = "center";
                        valign = "bottom";
                    }
                ];

                input-field = [{
                    inherit monitor;
                    inherit (colors) capslock_color check_color fail_color font_color;
                    inner_color = colors.transparent;
                    outer_color = "rgba(255, 255, 255, 0.1)";
                    placeholder_text = ''<span foreground="##${colors.font_color_hex}"><i>󰌾 Logged in as </i><span foreground="##${colors.blue}">$USER</span></span>'';
                    fail_text = ''<i>$FAIL <b>($ATTEMPTS)</b></i>'';
                    dots_size = 0.2;
                    dots_spacing = 0.2;
                    dots_center = true;
                    outline_thickness = 4;
                    fade_on_empty = false;
                    hide_input = false;
                    size = "300, 60";
                    position = "0, -35";
                    halign = "center";
                    valign = "center";
                }];

                animations = {
                    enabled = true;
                    bezier = ["linear, 1, 1, 0, 0"];
                    animation = [
                        "fadeIn, 1, 5, linear"
                        "fadeOut, 1, 2, linear"
                        "inputFieldFade, 1, 3, linear"
                        "inputFieldColors, 1, 6, linear"
                        "inputFieldDots, 1, 2, linear"
                    ];
                };
            };
        };
    };
}
