{
    den.aspects.displaylink.nixos = {
        config,
        lib,
        pkgs,
        ...
    }: {
        boot.extraModulePackages = with config.boot.kernelPackages; [evdi];
        services.xserver = {
            videoDrivers = ["displaylink" "modesetting"];
            displayManager.sessionCommands = ''
                ${lib.getBin pkgs.xorg.xrandr}/bin/xrandr --setprovideroutputsource 2 0
            '';
        };
    };
}
