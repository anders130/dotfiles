{inputs, ...}: {
    imports = [inputs.lumehub.nixosModules.default];

    modules = {
        bundles.rpi.enable = true;
        hardware.raspberry-pi = {
            enable = true;
            spi.enable = true;
        };
    };
    modules.programs.cli = {
        nvix.enable = false; # neovim config - probably huge
        nix-index.enable = false; # large database
        direnv.enable = false;
    };

    services.lumehub = {
        enable = true;
        openFirewall = true;
        settings = {
            led_controller.controller_type = "ws2801";
            led_controller.pixel_count = 256;
            effects.presets.tv_mode = {
                effect = "zone_interpolation";
                params = {
                    color1 = {
                        r = 0;
                        g = 0;
                        b = 0;
                    };
                    color2 = {
                        r = 255;
                        g = 120;
                        b = 20;
                    };
                    interpolation_length = 40;
                    midpoint = 120;
                };
            };
        };
    };

    system.stateVersion = "24.05";
    hm.home.stateVersion = "24.05";
}
