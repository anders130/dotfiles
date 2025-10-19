{
    modules = {
        bundles.rpi.enable = true;
        hardware.raspberry-pi = {
            enable = true;
            spi.enable = true;
        };
        services.lumehub = {
            enable = true;
            settings.LedControllerSettings = {
                PixelCount = 256;
                ClockFrequency = 1500000;
            };
        };
    };

    system.stateVersion = "24.05";
    hm.home.stateVersion = "24.05";
}
