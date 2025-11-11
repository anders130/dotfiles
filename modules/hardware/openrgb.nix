{
    config,
    lib,
    ...
}: {
    services.hardware.openrgb = {
        enable = true;
        motherboard = "amd";
    };
    systemd.user.services.openrgb = {
        description = "OpenRGB";
        wantedBy = ["graphical-session.target"];
        serviceConfig.ExecStart = "${lib.getExe' config.services.hardware.openrgb.package "openrgb"} --startminimized";
    };
}
