{
    modules = {
        bundles.rpi.enable = true;
        services.lumehub = {
            enable = true;
            settings.LedControllerSettings = {
                PixelCount = 256;
                ClockFrequency = 1500000;
            };
        };
    };

    raspberry-pi-nix.board = "bcm2711";

    hardware.raspberry-pi.config.all.base-dt-params.spi = {
        enable = true;
        value = "on";
    };

    system.stateVersion = "24.05";
    hm.home.stateVersion = "24.05";
}
