{
    modules.bundles.rpi.enable = true;

    raspberry-pi-nix.board = "bcm2711";

    hardware.raspberry-pi.config.all.base-dt-params.spi = {
        enable = true;
        value = "on";
    };

    services.lumehub = {
        enable = true;
        openFirewall = true;
        settings.LedControllerSettings = {
            PixelCount = 256;
            ClockFrequency = 1500000;
        };
    };

    system.stateVersion = "24.05";
    hm.home.stateVersion = "24.05";
}
