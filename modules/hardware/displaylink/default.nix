{
    config,
    lib,
    pkgs,
    ...
}: {
    options.modules.hardware.displaylink = {
        enable = lib.mkEnableOption "DisplayLink driver";
    };

    config = lib.mkIf config.modules.hardware.displaylink.enable {
        services.xserver.videoDrivers = ["displaylink" "modesetting"];

        boot.extraModulePackages = with config.boot.kernelPackages; [
            evdi
        ];

        environment.systemPackages = with pkgs.unstable; [
            displaylink
        ];
    };
}
