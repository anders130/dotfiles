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
        boot.extraModulePackages = with config.boot.kernelPackages; [
            evdi
        ];

        services.xserver = {
            videoDrivers = ["displaylink" "modesetting"];

            displayManager.sessionCommands = /*bash*/''
                ${lib.getBin pkgs.xorg.xrandr}/bin/xrandr --setprovideroutputsource 2 0
            '';
        };
    };
}
