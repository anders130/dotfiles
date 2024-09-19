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

        services.xserver.displayManager.sessionCommands = /*bash*/''
            ${lib.getBin pkgs.xorg.xrandr}/bin/xrandr --setprovideroutputsource 2 0
        '';
    };
}
