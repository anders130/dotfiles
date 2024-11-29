{username, ...}: let
    monitors = [
        {
            port = "DP-3";
            resolution = "2560x1440";
            refreshRate = 180;
            position = "-2560x0";
            scale = 1;
        }
        {
            port = "DP-1";
            resolution = "3440x1440";
            refreshRate = 144;
            position = "0x0";
            scale = 1;
        }
        {
            port = "DP-2";
            resolution = "2560x1440";
            refreshRate = 180;
            position = "3440x0";
            scale = 1;
        }
    ];

    mkMonitorKernelParam = m: "video=${m.port}:${m.resolution}@${toString m.refreshRate}";
    mkWaylandMonitor = m: "${m.port}, ${m.resolution}@${toString m.refreshRate}, ${m.position}, ${toString m.scale}";
in {
    boot.kernelParams = map mkMonitorKernelParam monitors;
    home-manager.users.${username}.wayland.windowManager.hyprland.settings.monitor = map mkWaylandMonitor monitors;
}
