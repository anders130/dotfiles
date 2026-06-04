{
    flake.modules.nixos.desktop = {
        config,
        lib,
        ...
    }: let
        inherit (lib) mapAttrsToList mkOption types;
        inherit (builtins) filter head length;
        mkMonitorKernelParam = port: c: "video=${port}:${c.resolution}@${toString c.refreshRate}Hz";
        mkHyprlandMonitor = port: c: "${port}, ${c.resolution}@${toString c.refreshRate}, ${c.position}, ${toString c.scale}";
        getMainMonitorName = monitors: let
            mainMonitors = filter (m: m.value.isMain) (lib.attrsToList monitors);
        in
            if length mainMonitors == 0
            then "DP-1"
            else (head mainMonitors).name;
    in {
        options.my.desktop = {
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
                default = getMainMonitorName config.my.desktop.monitors;
                description = "Name of the main monitor";
            };
        };
        config = {
            boot.kernelParams = mapAttrsToList mkMonitorKernelParam config.my.desktop.monitors;
            home-manager.sharedModules = [
                {
                    wayland.windowManager.hyprland.settings.monitor =
                        mapAttrsToList mkHyprlandMonitor config.my.desktop.monitors;
                }
            ];
        };
    };
}
