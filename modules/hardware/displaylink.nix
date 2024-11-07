{
    config,
    lib,
    pkgs,
    ...
}: lib.mkModule config ./displaylink.nix {
    boot.extraModulePackages = with config.boot.kernelPackages; [
        evdi
    ];

    services.xserver = {
        videoDrivers = ["displaylink" "modesetting"];

        displayManager.sessionCommands = /*bash*/''
            ${lib.getBin pkgs.xorg.xrandr}/bin/xrandr --setprovideroutputsource 2 0
        '';
    };
}
