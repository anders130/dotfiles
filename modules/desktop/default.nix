{
    config,
    lib,
    ...
}: let
    inherit (lib) mapAttrsToList mkOption types;
    inherit (builtins) attrNames filter head length listToAttrs;

    mkMonitorKernelParam = port: c: "video=${port}:${c.resolution}@${toString c.refreshRate}Hz";
    mkHyprlandMonitor = port: c: "${port}, ${c.resolution}@${toString c.refreshRate}, ${c.position}, ${toString c.scale}";
    getMainMonitorName = monitors: let
        mainMonitors = filter (m: m.value.isMain) (lib.attrsToList monitors);
    in
        if length mainMonitors == 0
        then "DP-1"
        else (head mainMonitors).name;
in {
    options = {
        monitors = mkOption {
            type = types.attrsOf (
                types.submodule {
                    options = {
                        isMain = mkOption {
                            type = types.bool;
                            default = false;
                        };
                        resolution = mkOption {
                            type = types.str;
                            description = "Resolution of the monitor";
                        };
                        refreshRate = mkOption {
                            type = types.int;
                            description = "Refresh rate of the monitor";
                            default = 60;
                        };
                        position = mkOption {
                            type = types.str;
                            description = "Position of the monitor";
                            default = "0x0";
                        };
                        scale = mkOption {
                            type = types.float;
                            description = "Scale of the monitor";
                            default = 1.0;
                        };
                    };
                }
            );
            default = {};
            description = "Monitors to use";
        };
        mainMonitor = mkOption {
            type = types.str;
            default = getMainMonitorName config.modules.desktop.monitors;
            description = "Name of the main monitor";
        };
        defaultPrograms = let
            mkOpt = default: description:
                mkOption {
                    inherit description default;
                    type = types.listOf types.str;
                };
        in {
            browser = mkOpt ["zen"] "Default browser to use";
            terminal = mkOpt ["kitty"] "Default terminal to use";
            editor = mkOpt ["nvim"] "Default editor to use";
            fileManager = mkOpt ["nautilus" "--new-window"] "Default file manager to use";
            imageViewer = mkOpt ["loupe"] "Default image viewer to use";
            videoPlayer = mkOpt ["clapper"] "Default video player to use";
            musicPlayer = mkOpt ["decibels"] "Default music player to use";
        };
    };

    config = cfg: {
        boot.kernelParams = mapAttrsToList mkMonitorKernelParam cfg.monitors;
        hm.wayland.windowManager.hyprland.settings.monitor = mapAttrsToList mkHyprlandMonitor cfg.monitors;

        xdg.mime.defaultApplications = let
            mkMimes = mimes:
                mimes
                |> attrNames
                |> map (mime: {
                    name = mime;
                    value = "${head mimes.${mime}}.desktop";
                })
                |> listToAttrs;
            inherit (cfg.defaultPrograms) browser imageViewer videoPlayer musicPlayer editor;
        in
            mkMimes {
                "application/pdf" = browser;
                "x-scheme-handler/http" = browser;
                "x-scheme-handler/https" = browser;
                "image/*" = imageViewer;
                "video/*" = videoPlayer;
                "audio/*" = musicPlayer;
                "text/*" = editor;
            };

        # for secret and session management
        services.gnome.gnome-keyring.enable = true;
    };
}
