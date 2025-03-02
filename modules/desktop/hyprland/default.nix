{
    inputs,
    lib,
    pkgs,
    ...
}: {
    options.extraConfig = lib.mkOption {
        description = "Extra config to be appended to the hyprland config";
        type = lib.types.lines;
        default = "";
    };

    config = cfg: {
        programs.hyprland = {
            package = pkgs.hyprland;
            enable = true;
            xwayland.enable = true;
        };

        xdg.portal = {
            enable = true;
            xdgOpenUsePortal = true;
            config.hyprland.default = [
                "hyprland"
                "gtk"
            ];
        };

        hm = {
            imports = [inputs.hyprland.homeManagerModules.default];

            wayland.windowManager.hyprland = {
                package = pkgs.hyprland;
                enable = true;
                xwayland.enable = true;

                settings = {
                    general = {
                        layout = "dwindle";
                        allow_tearing = false;
                    };
                    dwindle.preserve_split = true;
                    gestures.workspace_swipe = false;
                    ecosystem.no_update_news = true;
                };

                extraConfig = ''
                    source = ./visuals/default.conf
                '' + cfg.extraConfig;

                # tell systemd to import environment by default (fixes screenshare)
                systemd.variables = ["--all"];
            };

            xdg.configFile."hypr/visuals" = lib.mkSymlink ./visuals;

            stylix.targets.hyprland.enable = false;
        };
    };
}
