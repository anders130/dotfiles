{
    config,
    lib,
    pkgs,
    ...
}: let
    stylixColors = config.lib.stylix.colors;

    package = pkgs.unstable.hyprlock;

    font = config.stylix.fonts.monospace.name;

    colors = {
        text = "rgb(${stylixColors.base05})";
        textHex = stylixColors.base05;

        base = stylixColors.base00;

        blue = stylixColors.base0D;
        transparentBlue = "rgba(${stylixColors.base0D-rgb-r}, ${stylixColors.base0D-rgb-g}, ${stylixColors.base0D-rgb-b}, 0.4)";
        transparentRed = "rgba(${stylixColors.base08-rgb-r}, ${stylixColors.base08-rgb-g}, ${stylixColors.base08-rgb-b}, 0.4)";
        transparentYellow = "rgba(${stylixColors.base0A-rgb-r}, ${stylixColors.base0A-rgb-g}, ${stylixColors.base0A-rgb-b}, 0.4)";
        transparent = "rgba(0, 0, 0, 0)";
        transparentBase = "rgba(${stylixColors.base02-rgb-r}, ${stylixColors.base02-rgb-g}, ${stylixColors.base02-rgb-b}, 0.2)";
    };
in {
    options.mainMonitor = lib.mkOption {
        type = lib.types.str;
        description = "The main monitor";
    };
    config = cfg: {
        hm = {
            stylix.targets.hyprlock.enable = false;
            programs.hyprlock = {
                inherit package;
                enable = true;
                settings = {
                    general = {
                        disable_loading_bar = true;
                        hide_cursor = true;
                    };

                    background = [{
                        monitor = "";
                        path = "$HOME/Pictures/main.png";
                        blur_passes = 3;
                        blur_size = 4;
                        brightness = 0.5;
                        color = colors.base;
                    }];

                    label = [
                        {
                            monitor = cfg.mainMonitor;
                            text = ''cmd[update:30000] echo "$(date +"%R")"'';
                            color = colors.text;
                            font_size = 90;
                            font_family = font;
                            position = "0, 80";
                            halign = "center";
                            valign = "center";
                        }
                        {
                            monitor = cfg.mainMonitor;
                            text = ''cmd[update:43200000] echo "$(date +"%A, %d %B %Y")"'';
                            color = colors.text;
                            font_size = 20;
                            font_family = font;
                            position = "0, 0";
                            halign = "center";
                            valign = "bottom";
                        }
                    ];

                    # INPUT FIELD
                    input-field = [{
                        monitor = cfg.mainMonitor;
                        size = "300, 60";
                        outline_thickness = 4;
                        dots_size = 0.2;
                        dots_spacing = 0.2;
                        dots_center = true;
                        outer_color = colors.transparentBase;
                        inner_color = colors.transparent;
                        font_color =  colors.text;
                        fade_on_empty = false;
                        placeholder_text = ''<span foreground="##${colors.textHex}"><i>󰌾 Logged in as </i><span foreground="##${colors.blue}">$USER</span></span>'';
                        hide_input = false;
                        capslock_color = colors.transparentYellow;
                        check_color = colors.transparentBlue;
                        fail_color = colors.transparentRed;
                        fail_text = ''<i>$FAIL <b>($ATTEMPTS)</b></i>'';
                        position = "0, -35";
                        halign = "center";
                        valign = "center";
                    }];
                };
            };
        };
    };
}
