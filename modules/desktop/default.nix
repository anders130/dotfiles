{
    config,
    lib,
    ...
}: let
    mkMonitorKernelParam = port: c: "video=${port}:${c.resolution}@${toString c.refreshRate}Hz";
    mkHyprlandMonitor = port: c: "${port}, ${c.resolution}@${toString c.refreshRate}, ${c.position}, ${toString c.scale}";
    getMainMonitorName = monitors: let
        mainMonitors = builtins.filter (m: m.value.isMain) (lib.attrsToList monitors);
    in if builtins.length mainMonitors == 0 then "DP-1" else (builtins.head mainMonitors).name;
in {
    options = {
        monitors = lib.mkOption {
            type = lib.types.attrsOf (
                lib.types.submodule {
                    options = {
                        isMain = lib.mkOption {
                            type = lib.types.bool;
                            default = false;
                        };
                        resolution = lib.mkOption {
                            type = lib.types.str;
                            description = "Resolution of the monitor";
                        };
                        refreshRate = lib.mkOption {
                            type = lib.types.int;
                            description = "Refresh rate of the monitor";
                            default = 60;
                        };
                        position = lib.mkOption {
                            type = lib.types.str;
                            description = "Position of the monitor";
                        };
                        scale = lib.mkOption {
                            type = lib.types.float;
                            description = "Scale of the monitor";
                            default = 1.0;
                        };
                    };
                }
            );
            default = {};
            description = "Monitors to use";
        };
        mainMonitor = lib.mkOption {
            type = lib.types.str;
            default = getMainMonitorName config.modules.desktop.monitors;
            description = "Name of the main monitor";
        };
        defaultPrograms = let
            mkOption = default: description:
                lib.mkOption {
                    inherit default description;
                    type = lib.types.str;
                };
        in {
            browser = mkOption "firefox" "Default browser to use";
            terminal = mkOption "kitty" "Default terminal to use";
            editor = mkOption "nvim" "Default editor to use";
            fileManager = mkOption "nautilus --new-window" "Default file manager to use";
            imageViewer = mkOption "loupe" "Default image viewer to use";
            videoPlayer = mkOption "totem" "Default video player to use";
            musicPlayer = mkOption "gnome-music" "Default music player to use";
        };
    };

    config = cfg: {
        boot.kernelParams = lib.mapAttrsToList mkMonitorKernelParam cfg.monitors;
        hm.wayland.windowManager.hyprland.settings.monitor = lib.mapAttrsToList mkHyprlandMonitor cfg.monitors;

        xdg.mime.defaultApplications = {
            "application/pdf" = "${cfg.defaultPrograms.browser}.desktop";
            "x-scheme-handler/http" = "${cfg.defaultPrograms.browser}.desktop";
            "x-scheme-handler/https" = "${cfg.defaultPrograms.browser}.desktop";

            "image/*" = "${cfg.defaultPrograms.imageViewer}.desktop";
            "video/*" = "${cfg.defaultPrograms.videoPlayer}.desktop";
            "audio/*" = "${cfg.defaultPrograms.musicPlayer}.desktop";
            "text/*" = "${cfg.defaultPrograms.editor}.desktop";
        };
    };
}
