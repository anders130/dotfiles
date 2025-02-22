{
    config,
    lib,
    pkgs,
    ...
}: {
    options.terminal = lib.mkOption {
        type = lib.types.str;
        description = "Terminal to use for rofi";
        default = "kitty";
    };

    config = cfg: {
        hm = {
            stylix.targets.rofi.enable = false;

            programs.rofi = {
                enable = true;
                font = with config.stylix.fonts; "${sansSerif.name} ${toString sizes.applications}";
                package = pkgs.rofi-wayland;
                # theme = "theme";
                theme = "extraConfig";
                terminal = cfg.terminal;
                extraConfig = {
                    modi = "drun";
                    show-icons = true;
                    display-drun = " ";
                    drun-display-format = "{name}";
                };
            };

            xdg.configFile = {
                "rofi/extraConfig.rasi" = lib.mkSymlink ./config.rasi;
                "rofi/wallpaper-selector.rasi" = lib.mkSymlink ./wallpaper-selector.rasi;
            };
        };
    };
}
