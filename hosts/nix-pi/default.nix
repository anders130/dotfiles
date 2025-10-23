{inputs, ...}: {
    imports = [inputs.lumehub.nixosModules.default];

    modules = {
        bundles.rpi.enable = true;
        hardware.raspberry-pi = {
            enable = true;
            spi.enable = true;
        };
    };

    services.lumehub = {
        enable = true;
        openFirewall = true;
        settings = {
            led_controller.controller_type = "ws2801";
            led_controller.pixel_count = 256;
        };
    };

    system.stateVersion = "24.05";
    hm.home.stateVersion = "24.05";
}
