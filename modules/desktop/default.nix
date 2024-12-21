{lib, ...}: let
    mkMonitorKernelParam = port: c: "video=${port}:${c.resolution}@${toString c.refreshRate}Hz";
    mkHyprlandMonitor = port: c: "${port}, ${c.resolution}@${toString c.refreshRate}, ${c.position}, ${toString c.scale}";
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
    };

    config = cfg: {
        boot.kernelParams = lib.mapAttrsToList mkMonitorKernelParam cfg.monitors;
        hm.wayland.windowManager.hyprland.settings.monitor = lib.mapAttrsToList mkHyprlandMonitor cfg.monitors;
    };
}
