{
    config,
    lib,
    ...
}: {
    options.modules.hardware.displaylink = {
        enable = lib.mkEnableOption "DisplayLink driver";
    };

    config = lib.mkIf config.modules.hardware.displaylink.enable {
        services.xserver.videoDrivers = ["displaylink" "modesetting"];
    };
}
