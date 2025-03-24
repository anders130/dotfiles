{
    config,
    lib,
    pkgs,
    ...
}: let
    rofi-calc = pkgs.rofi-calc.override {
        rofi-unwrapped = pkgs.rofi-wayland-unwrapped;
    };
in {
    options.terminal = lib.mkOption {
        type = lib.types.str;
        description = "Terminal to use for rofi";
        default = "kitty";
    };

    config = cfg: {
        hm = {
            stylix.targets.rofi.enable = false;

            programs.rofi = {
                inherit (cfg) terminal;
                enable = true;
                package = pkgs.rofi-wayland;
                theme = "extraConfig";
                font = with config.stylix.fonts; "${sansSerif.name} ${toString sizes.applications}";
                extraConfig = {
                    modi = "drun,calc";
                    show-icons = true;
                    display-drun = " ";
                    drun-display-format = "{name}";
                    display-calc = " ";
                };
                plugins = [rofi-calc];
            };

            xdg.configFile = {
                "rofi/extraConfig.rasi" = lib.mkSymlink ./config.rasi;
                "rofi/wallpaper-selector.rasi" = lib.mkSymlink ./wallpaper-selector.rasi;
            };
        };
    };
}
